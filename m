Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754626Ab0FAHxE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 03:53:04 -0400
Received: from one.firstfloor.org ([213.235.205.2]:37538 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753335Ab0FAHxB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 03:53:01 -0400
Date: Tue, 1 Jun 2010 09:52:59 +0200
From: Andi Kleen <andi@firstfloor.org>
To: dm-devel@redhat.com, agk@redhat.com, linux-kernel@vger.kernel.org,
       eric.dumazet@gmail.com
Subject: [PATCH] DM-CRYPT: Scale to multiple CPUs v2
Message-ID: <20100601075259.GA13333@basil.fritz.box>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

DM-CRYPT: Scale to multiple CPUs v2

Updated version with the per CPU access improvements Eric suggested.

-Andi

---

Currently dm-crypt does all encryption work per dmcrypt mapping in a
single workqueue. This does not scale well when multiple CPUs
are submitting IO at a high rate. The single CPU running the single
thread cannot keep up with the encryption and encrypted IO performance
tanks.

This patch changes the crypto workqueue to be per CPU. This means
that as long as the IO submitter (or the interrupt target CPUs
for reads) runs on different CPUs the encryption work will be also
parallel.

To avoid a bottleneck on the IO worker I also changed those to be
per CPU threads.

There is still some shared data, so I suspect some bouncing
cache lines. But I haven't done a detailed study on that yet.

All the threads are global, not per CPU. That is to avoid a thread
explosion on systems with a large number of CPUs and a larger
number of dm-crypt mappings. The code takes care to avoid problems
with nested mappings.

v2: per cpu improvements from Eric Dumazet

Signed-off-by: Andi Kleen <ak@linux.intel.com>

diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index 3bdbb61..251d548 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -18,6 +18,7 @@
 #include <linux/crypto.h>
 #include <linux/workqueue.h>
 #include <linux/backing-dev.h>
+#include <linux/percpu.h>
 #include <asm/atomic.h>
 #include <linux/scatterlist.h>
 #include <asm/page.h>
@@ -77,11 +78,15 @@ struct crypt_iv_operations {
 };
 
 struct iv_essiv_private {
-	struct crypto_cipher *tfm;
 	struct crypto_hash *hash_tfm;
 	u8 *salt;
 };
 
+/* Duplicated per CPU state for cipher */
+struct iv_essiv_private_cpu {
+	struct crypto_cipher *tfm;
+};
+
 struct iv_benbi_private {
 	int shift;
 };
@@ -91,6 +96,18 @@ struct iv_benbi_private {
  * and encrypts / decrypts at the same time.
  */
 enum flags { DM_CRYPT_SUSPENDED, DM_CRYPT_KEY_VALID };
+
+/* Duplicated per CPU state for cipher */
+struct crypt_cpu {
+	struct ablkcipher_request *req;
+	struct crypto_ablkcipher *tfm;
+	struct iv_essiv_private_cpu ie;
+};
+
+/*
+ * The fields in here must be read only after initialization,
+ * changing state should be in crypt_cpu.
+ */
 struct crypt_config {
 	struct dm_dev *dev;
 	sector_t start;
@@ -103,10 +120,6 @@ struct crypt_config {
 	mempool_t *req_pool;
 	mempool_t *page_pool;
 	struct bio_set *bs;
-
-	struct workqueue_struct *io_queue;
-	struct workqueue_struct *crypt_queue;
-
 	/*
 	 * crypto related data
 	 */
@@ -120,6 +133,12 @@ struct crypt_config {
 	unsigned int iv_size;
 
 	/*
+	 * Duplicated per cpu state. Access through
+	 * per_cpu_ptr() only.
+	 */
+	struct crypt_cpu __percpu *cpu;
+
+	/*
 	 * Layout of each crypto request:
 	 *
 	 *   struct ablkcipher_request
@@ -133,25 +152,44 @@ struct crypt_config {
 	 * correctly aligned.
 	 */
 	unsigned int dmreq_start;
-	struct ablkcipher_request *req;
 
 	char cipher[CRYPTO_MAX_ALG_NAME];
 	char chainmode[CRYPTO_MAX_ALG_NAME];
-	struct crypto_ablkcipher *tfm;
 	unsigned long flags;
 	unsigned int key_size;
 	u8 key[0];
 };
 
+/* RED-PEN scale with number of cpus? */
 #define MIN_IOS        16
 #define MIN_POOL_PAGES 32
 #define MIN_BIO_PAGES  8
 
+/* Protect creation of a new crypt queue */
+static DEFINE_MUTEX(queue_setup_lock);
+static struct workqueue_struct *crypt_workqueue;
+static struct workqueue_struct *io_workqueue;
+static DEFINE_PER_CPU(struct task_struct *, io_wq_cpu);
+
 static struct kmem_cache *_crypt_io_pool;
 
 static void clone_init(struct dm_crypt_io *, struct bio *);
 static void kcryptd_queue_crypt(struct dm_crypt_io *io);
 
+static struct crypt_cpu *crypt_me(struct crypt_config *cc)
+{
+	return this_cpu_ptr(cc->cpu);
+}
+
+/* Use this for cipher attributes that are the same for all cpus */
+static struct crypto_ablkcipher *any_tfm(struct crypt_config *cc)
+{
+	struct crypto_ablkcipher *tfm;
+	/* cpu doesn't matter, output is always the same */
+	tfm = __this_cpu_ptr(cc->cpu)->tfm;
+	return tfm;
+}
+
 /*
  * Different IV generation algorithms:
  *
@@ -198,7 +236,7 @@ static int crypt_iv_essiv_init(struct crypt_config *cc)
 	struct iv_essiv_private *essiv = &cc->iv_gen_private.essiv;
 	struct hash_desc desc;
 	struct scatterlist sg;
-	int err;
+	int err, n, cpu;
 
 	sg_init_one(&sg, cc->key, cc->key_size);
 	desc.tfm = essiv->hash_tfm;
@@ -208,8 +246,18 @@ static int crypt_iv_essiv_init(struct crypt_config *cc)
 	if (err)
 		return err;
 
-	return crypto_cipher_setkey(essiv->tfm, essiv->salt,
+	for_each_possible_cpu (cpu) {
+		struct crypt_cpu *cs = per_cpu_ptr(cc->cpu, cpu);
+
+		n = crypto_cipher_setkey(cs->ie.tfm, essiv->salt,
 				    crypto_hash_digestsize(essiv->hash_tfm));
+		if (n) {
+			err = n;
+			break;
+		}
+	}
+
+	return err;
 }
 
 /* Wipe salt and reset key derived from volume key */
@@ -217,24 +265,70 @@ static int crypt_iv_essiv_wipe(struct crypt_config *cc)
 {
 	struct iv_essiv_private *essiv = &cc->iv_gen_private.essiv;
 	unsigned salt_size = crypto_hash_digestsize(essiv->hash_tfm);
+	int cpu, err, n;
 
 	memset(essiv->salt, 0, salt_size);
 
-	return crypto_cipher_setkey(essiv->tfm, essiv->salt, salt_size);
+	err = 0;
+	for_each_possible_cpu (cpu) {
+		struct crypt_cpu *cs = per_cpu_ptr(cc->cpu, cpu);
+		n = crypto_cipher_setkey(cs->ie.tfm, essiv->salt, salt_size);
+		if (n)
+			err = n;
+	}
+	return err;
+}
+
+/* Set up per cpu cipher state */
+static struct crypto_cipher *setup_essiv_cpu(struct crypt_config *cc,
+					     struct dm_target *ti,
+					     u8 *salt, unsigned saltsize)
+{
+	struct crypto_cipher *essiv_tfm;
+	int err;
+
+	/* Setup the essiv_tfm with the given salt */
+	essiv_tfm = crypto_alloc_cipher(cc->cipher, 0, CRYPTO_ALG_ASYNC);
+	if (IS_ERR(essiv_tfm)) {
+		ti->error = "Error allocating crypto tfm for ESSIV";
+		return essiv_tfm;
+	}
+
+	if (crypto_cipher_blocksize(essiv_tfm) !=
+	    crypto_ablkcipher_ivsize(any_tfm(cc))) {
+		ti->error = "Block size of ESSIV cipher does "
+			    "not match IV size of block cipher";
+		crypto_free_cipher(essiv_tfm);
+		return ERR_PTR(-EINVAL);
+	}
+	err = crypto_cipher_setkey(essiv_tfm, salt, saltsize);
+	if (err) {
+		ti->error = "Failed to set key for ESSIV cipher";
+		crypto_free_cipher(essiv_tfm);
+		return ERR_PTR(err);
+	}
+
+	return essiv_tfm;
 }
 
 static void crypt_iv_essiv_dtr(struct crypt_config *cc)
 {
+	int cpu;
 	struct iv_essiv_private *essiv = &cc->iv_gen_private.essiv;
 
-	crypto_free_cipher(essiv->tfm);
-	essiv->tfm = NULL;
-
 	crypto_free_hash(essiv->hash_tfm);
 	essiv->hash_tfm = NULL;
 
 	kzfree(essiv->salt);
 	essiv->salt = NULL;
+
+	for_each_possible_cpu (cpu) {
+		struct crypt_cpu *cs = per_cpu_ptr(cc->cpu, cpu);
+		if (cs->ie.tfm) {
+			crypto_free_cipher(cs->ie.tfm);
+			cs->ie.tfm = NULL;
+		}
+	}
 }
 
 static int crypt_iv_essiv_ctr(struct crypt_config *cc, struct dm_target *ti,
@@ -244,6 +338,7 @@ static int crypt_iv_essiv_ctr(struct crypt_config *cc, struct dm_target *ti,
 	struct crypto_hash *hash_tfm = NULL;
 	u8 *salt = NULL;
 	int err;
+	int cpu;
 
 	if (!opts) {
 		ti->error = "Digest algorithm missing for ESSIV mode";
@@ -265,30 +360,22 @@ static int crypt_iv_essiv_ctr(struct crypt_config *cc, struct dm_target *ti,
 		goto bad;
 	}
 
-	/* Allocate essiv_tfm */
-	essiv_tfm = crypto_alloc_cipher(cc->cipher, 0, CRYPTO_ALG_ASYNC);
-	if (IS_ERR(essiv_tfm)) {
-		ti->error = "Error allocating crypto tfm for ESSIV";
-		err = PTR_ERR(essiv_tfm);
-		goto bad;
-	}
-	if (crypto_cipher_blocksize(essiv_tfm) !=
-	    crypto_ablkcipher_ivsize(cc->tfm)) {
-		ti->error = "Block size of ESSIV cipher does "
-			    "not match IV size of block cipher";
-		err = -EINVAL;
-		goto bad;
-	}
-
 	cc->iv_gen_private.essiv.salt = salt;
-	cc->iv_gen_private.essiv.tfm = essiv_tfm;
 	cc->iv_gen_private.essiv.hash_tfm = hash_tfm;
 
+	for_each_possible_cpu (cpu) {
+		essiv_tfm = setup_essiv_cpu(cc, ti, salt,
+					crypto_hash_digestsize(hash_tfm));
+		if (IS_ERR(essiv_tfm)) {
+			kfree(salt);
+			crypt_iv_essiv_dtr(cc);
+			return PTR_ERR(essiv_tfm);
+		}
+		per_cpu_ptr(cc->cpu, cpu)->ie.tfm = essiv_tfm;
+	}
 	return 0;
 
 bad:
-	if (essiv_tfm && !IS_ERR(essiv_tfm))
-		crypto_free_cipher(essiv_tfm);
 	if (hash_tfm && !IS_ERR(hash_tfm))
 		crypto_free_hash(hash_tfm);
 	kfree(salt);
@@ -299,14 +386,14 @@ static int crypt_iv_essiv_gen(struct crypt_config *cc, u8 *iv, sector_t sector)
 {
 	memset(iv, 0, cc->iv_size);
 	*(u64 *)iv = cpu_to_le64(sector);
-	crypto_cipher_encrypt_one(cc->iv_gen_private.essiv.tfm, iv, iv);
+	crypto_cipher_encrypt_one(crypt_me(cc)->ie.tfm, iv, iv);
 	return 0;
 }
 
 static int crypt_iv_benbi_ctr(struct crypt_config *cc, struct dm_target *ti,
 			      const char *opts)
 {
-	unsigned bs = crypto_ablkcipher_blocksize(cc->tfm);
+	unsigned bs = crypto_ablkcipher_blocksize(any_tfm(cc));
 	int log = ilog2(bs);
 
 	/* we need to calculate how far we must shift the sector count
@@ -415,7 +502,7 @@ static int crypt_convert_block(struct crypt_config *cc,
 
 	dmreq = dmreq_of_req(cc, req);
 	iv = (u8 *)ALIGN((unsigned long)(dmreq + 1),
-			 crypto_ablkcipher_alignmask(cc->tfm) + 1);
+			 crypto_ablkcipher_alignmask(any_tfm(cc)) + 1);
 
 	dmreq->ctx = ctx;
 	sg_init_table(&dmreq->sg_in, 1);
@@ -460,13 +547,14 @@ static void kcryptd_async_done(struct crypto_async_request *async_req,
 static void crypt_alloc_req(struct crypt_config *cc,
 			    struct convert_context *ctx)
 {
-	if (!cc->req)
-		cc->req = mempool_alloc(cc->req_pool, GFP_NOIO);
-	ablkcipher_request_set_tfm(cc->req, cc->tfm);
-	ablkcipher_request_set_callback(cc->req, CRYPTO_TFM_REQ_MAY_BACKLOG |
+	struct crypt_cpu *cs = crypt_me(cc);
+	if (!cs->req)
+		cs->req = mempool_alloc(cc->req_pool, GFP_NOIO);
+	ablkcipher_request_set_tfm(cs->req, cs->tfm);
+	ablkcipher_request_set_callback(cs->req, CRYPTO_TFM_REQ_MAY_BACKLOG |
 					CRYPTO_TFM_REQ_MAY_SLEEP,
 					kcryptd_async_done,
-					dmreq_of_req(cc, cc->req));
+					dmreq_of_req(cc, cs->req));
 }
 
 /*
@@ -475,6 +563,7 @@ static void crypt_alloc_req(struct crypt_config *cc,
 static int crypt_convert(struct crypt_config *cc,
 			 struct convert_context *ctx)
 {
+	struct crypt_cpu *cs = crypt_me(cc);
 	int r;
 
 	atomic_set(&ctx->pending, 1);
@@ -486,7 +575,7 @@ static int crypt_convert(struct crypt_config *cc,
 
 		atomic_inc(&ctx->pending);
 
-		r = crypt_convert_block(cc, ctx, cc->req);
+		r = crypt_convert_block(cc, ctx, cs->req);
 
 		switch (r) {
 		/* async */
@@ -495,7 +584,7 @@ static int crypt_convert(struct crypt_config *cc,
 			INIT_COMPLETION(ctx->restart);
 			/* fall through*/
 		case -EINPROGRESS:
-			cc->req = NULL;
+			cs->req = NULL;
 			ctx->sector++;
 			continue;
 
@@ -654,6 +743,9 @@ static void crypt_dec_pending(struct dm_crypt_io *io)
  * They must be separated as otherwise the final stages could be
  * starved by new requests which can block in the first stages due
  * to memory allocation.
+ *
+ * The work is done per CPU global for all dmcrypt instances.
+ * They should not depend on each other and do not block.
  */
 static void crypt_endio(struct bio *clone, int error)
 {
@@ -735,6 +827,7 @@ static void kcryptd_io(struct work_struct *work)
 {
 	struct dm_crypt_io *io = container_of(work, struct dm_crypt_io, work);
 
+	__this_cpu_write(io_wq_cpu, current);
 	if (bio_data_dir(io->base_bio) == READ)
 		kcryptd_io_read(io);
 	else
@@ -743,10 +836,23 @@ static void kcryptd_io(struct work_struct *work)
 
 static void kcryptd_queue_io(struct dm_crypt_io *io)
 {
-	struct crypt_config *cc = io->target->private;
+	int cpu;
+
+	/*
+	 * Since we only have a single worker per CPU in extreme
+	 * cases there might be nesting (dm-crypt on another dm-crypt)
+	 * To avoid deadlock run the work directly then.
+	 */
+	cpu = get_cpu();
+	if (per_cpu(io_wq_cpu, cpu) == current && !in_interrupt()) {
+		put_cpu();
+		kcryptd_io(&io->work);
+		return;
+	}
 
 	INIT_WORK(&io->work, kcryptd_io);
-	queue_work(cc->io_queue, &io->work);
+	queue_work(io_workqueue, &io->work);
+	put_cpu();
 }
 
 static void kcryptd_crypt_write_io_submit(struct dm_crypt_io *io,
@@ -927,10 +1033,8 @@ static void kcryptd_crypt(struct work_struct *work)
 
 static void kcryptd_queue_crypt(struct dm_crypt_io *io)
 {
-	struct crypt_config *cc = io->target->private;
-
 	INIT_WORK(&io->work, kcryptd_crypt);
-	queue_work(cc->crypt_queue, &io->work);
+	queue_work(crypt_workqueue, &io->work);
 }
 
 /*
@@ -974,6 +1078,21 @@ static void crypt_encode_key(char *hex, u8 *key, unsigned int size)
 	}
 }
 
+static int crypt_setkey_allcpus(struct crypt_config *cc)
+{
+	int cpu, n, err;
+
+	err = 0;
+	for_each_possible_cpu (cpu) {
+		struct crypt_cpu *cs = per_cpu_ptr(cc->cpu, cpu);
+		n = crypto_ablkcipher_setkey(cs->tfm, cc->key, cc->key_size);
+		if (n)
+			err = n;
+	}
+	return err;
+}
+
+
 static int crypt_set_key(struct crypt_config *cc, char *key)
 {
 	unsigned key_size = strlen(key) >> 1;
@@ -989,14 +1108,48 @@ static int crypt_set_key(struct crypt_config *cc, char *key)
 
 	set_bit(DM_CRYPT_KEY_VALID, &cc->flags);
 
-	return crypto_ablkcipher_setkey(cc->tfm, cc->key, cc->key_size);
+	return crypt_setkey_allcpus(cc);
 }
 
 static int crypt_wipe_key(struct crypt_config *cc)
 {
 	clear_bit(DM_CRYPT_KEY_VALID, &cc->flags);
 	memset(&cc->key, 0, cc->key_size * sizeof(u8));
-	return crypto_ablkcipher_setkey(cc->tfm, cc->key, cc->key_size);
+	return crypt_setkey_allcpus(cc);
+}
+
+/* Use a global per-CPU encryption workqueue for all mounts */
+static int crypt_create_workqueues(void)
+{
+	int ret = 0;
+
+	/* Module unload cleans up on error */
+	mutex_lock(&queue_setup_lock);
+	if (!crypt_workqueue) {
+		crypt_workqueue = create_workqueue("dmcrypt");
+		if (!crypt_workqueue)
+			ret = -ENOMEM;
+	}
+	if (!io_workqueue) {
+		io_workqueue = create_workqueue("dmcrypt-io");
+		if (!io_workqueue)
+			ret = -ENOMEM;
+	}
+	mutex_unlock(&queue_setup_lock);
+	return ret;
+}
+
+static void crypt_dtr_cpus(struct crypt_config *cc)
+{
+	int cpu;
+
+	for_each_possible_cpu (cpu) {
+		struct crypt_cpu *cs = per_cpu_ptr(cc->cpu, cpu);
+		if (cs->tfm) {
+			crypto_free_ablkcipher(cs->tfm);
+			cs->tfm = NULL;
+		}
+	}
 }
 
 /*
@@ -1014,6 +1167,7 @@ static int crypt_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 	char *ivopts;
 	unsigned int key_size;
 	unsigned long long tmpll;
+	int cpu;
 
 	if (argc != 5) {
 		ti->error = "Not enough arguments";
@@ -1038,7 +1192,13 @@ static int crypt_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 		return -ENOMEM;
 	}
 
-	/* Compatibility mode for old dm-crypt cipher strings */
+	cc->cpu = alloc_percpu(struct crypt_cpu);
+	if (!cc->cpu) {
+		ti->error = "Cannot allocate per cpu state";
+		goto bad_percpu;
+	}
+
+	/* Compatiblity mode for old dm-crypt cipher strings */
 	if (!chainmode || (strcmp(chainmode, "plain") == 0 && !ivmode)) {
 		chainmode = "cbc";
 		ivmode = "plain";
@@ -1055,15 +1215,18 @@ static int crypt_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 		goto bad_cipher;
 	}
 
-	tfm = crypto_alloc_ablkcipher(cc->cipher, 0, 0);
-	if (IS_ERR(tfm)) {
-		ti->error = "Error allocating crypto tfm";
-		goto bad_cipher;
+	for_each_possible_cpu (cpu) {
+		tfm = crypto_alloc_ablkcipher(cc->cipher, 0, 0);
+		if (IS_ERR(tfm)) {
+			ti->error = "Error allocating crypto tfm";
+			goto bad_ivmode;
+		}
+		per_cpu_ptr(cc->cpu, cpu)->tfm = tfm;
 	}
+	tfm = any_tfm(cc);
 
 	strcpy(cc->cipher, cipher);
 	strcpy(cc->chainmode, chainmode);
-	cc->tfm = tfm;
 
 	if (crypt_set_key(cc, argv[1]) < 0) {
 		ti->error = "Error decoding and setting key";
@@ -1134,7 +1297,6 @@ static int crypt_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 		ti->error = "Cannot allocate crypt request mempool";
 		goto bad_req_pool;
 	}
-	cc->req = NULL;
 
 	cc->page_pool = mempool_create_page_pool(MIN_POOL_PAGES, 0);
 	if (!cc->page_pool) {
@@ -1148,6 +1310,14 @@ static int crypt_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 		goto bad_bs;
 	}
 
+	for_each_possible_cpu (cpu) {
+		struct crypt_cpu *cs = per_cpu_ptr(cc->cpu, cpu);
+		if (crypto_ablkcipher_setkey(cs->tfm, cc->key, key_size) < 0) {
+			ti->error = "Error setting key";
+			goto bad_device;
+		}
+	}
+
 	if (sscanf(argv[2], "%llu", &tmpll) != 1) {
 		ti->error = "Invalid iv_offset sector";
 		goto bad_device;
@@ -1177,25 +1347,16 @@ static int crypt_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 	} else
 		cc->iv_mode = NULL;
 
-	cc->io_queue = create_singlethread_workqueue("kcryptd_io");
-	if (!cc->io_queue) {
-		ti->error = "Couldn't create kcryptd io queue";
-		goto bad_io_queue;
-	}
-
-	cc->crypt_queue = create_singlethread_workqueue("kcryptd");
-	if (!cc->crypt_queue) {
-		ti->error = "Couldn't create kcryptd queue";
-		goto bad_crypt_queue;
+	if (crypt_create_workqueues() < 0) {
+		ti->error = "Couldn't create kcrypt work queues";
+		goto bad_queues;
 	}
 
 	ti->num_flush_requests = 1;
 	ti->private = cc;
 	return 0;
 
-bad_crypt_queue:
-	destroy_workqueue(cc->io_queue);
-bad_io_queue:
+bad_queues:
 	kfree(cc->iv_mode);
 bad_ivmode_string:
 	dm_put_device(ti, cc->dev);
@@ -1211,8 +1372,10 @@ bad_slab_pool:
 	if (cc->iv_gen_ops && cc->iv_gen_ops->dtr)
 		cc->iv_gen_ops->dtr(cc);
 bad_ivmode:
-	crypto_free_ablkcipher(tfm);
+	crypt_dtr_cpus(cc);
 bad_cipher:
+	free_percpu(cc->cpu);
+bad_percpu:
 	/* Must zero key material before freeing */
 	kzfree(cc);
 	return -EINVAL;
@@ -1220,13 +1383,14 @@ bad_cipher:
 
 static void crypt_dtr(struct dm_target *ti)
 {
+	int cpu;
 	struct crypt_config *cc = (struct crypt_config *) ti->private;
 
-	destroy_workqueue(cc->io_queue);
-	destroy_workqueue(cc->crypt_queue);
-
-	if (cc->req)
-		mempool_free(cc->req, cc->req_pool);
+	for_each_possible_cpu (cpu) {
+		struct crypt_cpu *cs = per_cpu_ptr(cc->cpu, cpu);
+		if (cs->req)
+			mempool_free(cs->req, cc->req_pool);
+	}
 
 	bioset_free(cc->bs);
 	mempool_destroy(cc->page_pool);
@@ -1236,9 +1400,11 @@ static void crypt_dtr(struct dm_target *ti)
 	kfree(cc->iv_mode);
 	if (cc->iv_gen_ops && cc->iv_gen_ops->dtr)
 		cc->iv_gen_ops->dtr(cc);
-	crypto_free_ablkcipher(cc->tfm);
+	crypt_dtr_cpus(cc);
 	dm_put_device(ti, cc->dev);
 
+	free_percpu(cc->cpu);
+
 	/* Must zero key material before freeing */
 	kzfree(cc);
 }
@@ -1428,6 +1594,10 @@ static void __exit dm_crypt_exit(void)
 {
 	dm_unregister_target(&crypt_target);
 	kmem_cache_destroy(_crypt_io_pool);
+	if (crypt_workqueue)
+		destroy_workqueue(crypt_workqueue);
+	if (io_workqueue)
+		destroy_workqueue(io_workqueue);
 }
 
 module_init(dm_crypt_init);
