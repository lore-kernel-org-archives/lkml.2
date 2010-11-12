Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932181Ab0KLSwI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 13:52:08 -0500
Received: from mx1.redhat.com ([209.132.183.28]:17959 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751405Ab0KLSwG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 13:52:06 -0500
Message-ID: <4CDD8CC6.3070108@redhat.com>
Date: Fri, 12 Nov 2010 19:51:50 +0100
From: Milan Broz <mbroz@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100918 Thunderbird/3.1.4
MIME-Version: 1.0
To: device-mapper development <dm-devel@redhat.com>
CC: Andi Kleen <andi@firstfloor.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Alasdair G Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH v5] dm crypt: scale to multiple CPUs
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
finally I found some time and tried to fix that Andi's dm-crypt patch
to not break stacking.

Here is what I have:
 - it still keeps two per device threads, with WQ_NON_REENTRANT set
 - only crypt thread is cpu intensive

There is for sure space for additional optimisations (that reentrant flags
must limit it) but I think it fixes exactly the same problem without breaking
other things.

I got very similar results with this patch compared to original Andi's v3 patch.

All stacking and async crypto problems are gone, even 20 dm-crypt devices
stacked works for me now.

Some numbers - really stupid test, run 4 threads on 2.6.37-rc1+ 2xdualcore CPU
with aes-xts-plain64/256bit encrypted block device like this

fio --rw=$1 --size=1G --bsrange=1k-128k --filename=$2 --name=1 --name=2 --name=3 --name=4

(similar is cbs-ESSIV, but I want to test just per-cpu worker changes)

values below are just aggregated numbers (aggrb) from fio output.

1) device backed by dm-zero (reads/writes -> noop)
(so there no real device, it should measure just dm-crypt performance)

			old code 	new (per cpu)
zero-read		117205KB/s	193866KB/s
zero-write		160572KB/s	324109KB/s
zero-randread		137829KB/s	180477KB/s
zero-randwrite		 56088KB/s	206158KB/s
zero-rw READS		 39192KB/s	 52667KB/s
zero-rw WRITES		 39534KB/s	 52746KB/s
zero-randrw READS	 43220KB/s	103868KB/s
zero-randrw WRITES	 43322KB/s	104192KB/s

2) and the same test backed by MD/RAID0
(no tuning here, drives use CFQ, but I have no better
machine for now)

disk-read		100598KB/s	141802KB/s
disk-write		 78848KB/s	178102KB/s
disk-randread		 51148KB/s	 49378KB/s
disk-randwrite		 32679KB/s	 49560KB/s
disk-rw	READS		 36812KB/s	 40575KB/s
disk-rw	WRITES		 36506KB/s	 40552KB/s
disk-randrw READS	 19426KB/s	 24603KB/s
disk-randrw WRITES	 19402KB/s	 24479KB/s


Andi, is this version ok for you?

So we can move forward, and finally include this.
(There should be some other optimisations but I would like
to commit this first and all changes do as following patches.)

Thanks,
Milan

diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index d5b0e4c..b4dac68 100644
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
@@ -77,7 +78,6 @@ struct crypt_iv_operations {
 };
 
 struct iv_essiv_private {
-	struct crypto_cipher *tfm;
 	struct crypto_hash *hash_tfm;
 	u8 *salt;
 };
@@ -91,6 +91,20 @@ struct iv_benbi_private {
  * and encrypts / decrypts at the same time.
  */
 enum flags { DM_CRYPT_SUSPENDED, DM_CRYPT_KEY_VALID };
+
+/* Duplicated per CPU state for cipher */
+struct crypt_cpu {
+	struct ablkcipher_request *req;
+	struct crypto_ablkcipher *tfm;
+
+	/* ESSIV: struct crypto_cipher *essiv_tfm */
+	void *iv_private;
+};
+
+/*
+ * The fields in here must be read only after initialization,
+ * changing state should be in crypt_cpu.
+ */
 struct crypt_config {
 	struct dm_dev *dev;
 	sector_t start;
@@ -119,6 +133,12 @@ struct crypt_config {
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
@@ -132,9 +152,7 @@ struct crypt_config {
 	 * correctly aligned.
 	 */
 	unsigned int dmreq_start;
-	struct ablkcipher_request *req;
 
-	struct crypto_ablkcipher *tfm;
 	unsigned long flags;
 	unsigned int key_size;
 	u8 key[0];
@@ -149,6 +167,20 @@ static struct kmem_cache *_crypt_io_pool;
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
@@ -195,7 +227,9 @@ static int crypt_iv_essiv_init(struct crypt_config *cc)
 	struct iv_essiv_private *essiv = &cc->iv_gen_private.essiv;
 	struct hash_desc desc;
 	struct scatterlist sg;
-	int err;
+	struct crypt_cpu *cs;
+	struct crypto_cipher *essiv_tfm;
+	int err, n, cpu;
 
 	sg_init_one(&sg, cc->key, cc->key_size);
 	desc.tfm = essiv->hash_tfm;
@@ -205,8 +239,19 @@ static int crypt_iv_essiv_init(struct crypt_config *cc)
 	if (err)
 		return err;
 
-	return crypto_cipher_setkey(essiv->tfm, essiv->salt,
+	for_each_possible_cpu (cpu) {
+		cs = per_cpu_ptr(cc->cpu, cpu);
+		essiv_tfm = cs->iv_private,
+
+		n = crypto_cipher_setkey(essiv_tfm, essiv->salt,
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
@@ -214,24 +259,75 @@ static int crypt_iv_essiv_wipe(struct crypt_config *cc)
 {
 	struct iv_essiv_private *essiv = &cc->iv_gen_private.essiv;
 	unsigned salt_size = crypto_hash_digestsize(essiv->hash_tfm);
+	struct crypt_cpu *cs;
+	struct crypto_cipher *essiv_tfm;
+	int cpu, err, n;
 
 	memset(essiv->salt, 0, salt_size);
 
-	return crypto_cipher_setkey(essiv->tfm, essiv->salt, salt_size);
+	err = 0;
+	for_each_possible_cpu (cpu) {
+		cs = per_cpu_ptr(cc->cpu, cpu);
+		essiv_tfm = cs->iv_private;
+		n = crypto_cipher_setkey(essiv_tfm, essiv->salt, salt_size);
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
+	struct crypt_cpu *cs;
+	struct crypto_cipher *essiv_tfm;
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
+		cs = per_cpu_ptr(cc->cpu, cpu);
+		essiv_tfm = cs->iv_private;
+		if (essiv_tfm)
+			crypto_free_cipher(essiv_tfm);
+		cs->iv_private = NULL;
+	}
 }
 
 static int crypt_iv_essiv_ctr(struct crypt_config *cc, struct dm_target *ti,
@@ -240,7 +336,7 @@ static int crypt_iv_essiv_ctr(struct crypt_config *cc, struct dm_target *ti,
 	struct crypto_cipher *essiv_tfm = NULL;
 	struct crypto_hash *hash_tfm = NULL;
 	u8 *salt = NULL;
-	int err;
+	int err, cpu;
 
 	if (!opts) {
 		ti->error = "Digest algorithm missing for ESSIV mode";
@@ -262,30 +358,21 @@ static int crypt_iv_essiv_ctr(struct crypt_config *cc, struct dm_target *ti,
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
+			crypt_iv_essiv_dtr(cc);
+			return PTR_ERR(essiv_tfm);
+		}
+		per_cpu_ptr(cc->cpu, cpu)->iv_private = essiv_tfm;
+	}
 	return 0;
 
 bad:
-	if (essiv_tfm && !IS_ERR(essiv_tfm))
-		crypto_free_cipher(essiv_tfm);
 	if (hash_tfm && !IS_ERR(hash_tfm))
 		crypto_free_hash(hash_tfm);
 	kfree(salt);
@@ -294,16 +381,18 @@ bad:
 
 static int crypt_iv_essiv_gen(struct crypt_config *cc, u8 *iv, sector_t sector)
 {
+	struct crypto_cipher *essiv_tfm = crypt_me(cc)->iv_private;
+
 	memset(iv, 0, cc->iv_size);
 	*(u64 *)iv = cpu_to_le64(sector);
-	crypto_cipher_encrypt_one(cc->iv_gen_private.essiv.tfm, iv, iv);
+	crypto_cipher_encrypt_one(essiv_tfm, iv, iv);
 	return 0;
 }
 
 static int crypt_iv_benbi_ctr(struct crypt_config *cc, struct dm_target *ti,
 			      const char *opts)
 {
-	unsigned bs = crypto_ablkcipher_blocksize(cc->tfm);
+	unsigned bs = crypto_ablkcipher_blocksize(any_tfm(cc));
 	int log = ilog2(bs);
 
 	/* we need to calculate how far we must shift the sector count
@@ -412,7 +501,7 @@ static int crypt_convert_block(struct crypt_config *cc,
 
 	dmreq = dmreq_of_req(cc, req);
 	iv = (u8 *)ALIGN((unsigned long)(dmreq + 1),
-			 crypto_ablkcipher_alignmask(cc->tfm) + 1);
+			 crypto_ablkcipher_alignmask(any_tfm(cc)) + 1);
 
 	dmreq->ctx = ctx;
 	sg_init_table(&dmreq->sg_in, 1);
@@ -457,13 +546,14 @@ static void kcryptd_async_done(struct crypto_async_request *async_req,
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
@@ -472,6 +562,7 @@ static void crypt_alloc_req(struct crypt_config *cc,
 static int crypt_convert(struct crypt_config *cc,
 			 struct convert_context *ctx)
 {
+	struct crypt_cpu *cs = crypt_me(cc);
 	int r;
 
 	atomic_set(&ctx->pending, 1);
@@ -483,7 +574,7 @@ static int crypt_convert(struct crypt_config *cc,
 
 		atomic_inc(&ctx->pending);
 
-		r = crypt_convert_block(cc, ctx, cc->req);
+		r = crypt_convert_block(cc, ctx, cs->req);
 
 		switch (r) {
 		/* async */
@@ -492,7 +583,7 @@ static int crypt_convert(struct crypt_config *cc,
 			INIT_COMPLETION(ctx->restart);
 			/* fall through*/
 		case -EINPROGRESS:
-			cc->req = NULL;
+			cs->req = NULL;
 			ctx->sector++;
 			continue;
 
@@ -651,6 +742,9 @@ static void crypt_dec_pending(struct dm_crypt_io *io)
  * They must be separated as otherwise the final stages could be
  * starved by new requests which can block in the first stages due
  * to memory allocation.
+ *
+ * The work is done per CPU global for all dmcrypt instances.
+ * They should not depend on each other and do not block.
  */
 static void crypt_endio(struct bio *clone, int error)
 {
@@ -971,6 +1065,22 @@ static void crypt_encode_key(char *hex, u8 *key, unsigned int size)
 	}
 }
 
+static int crypt_setkey_allcpus(struct crypt_config *cc)
+{
+	struct crypt_cpu *cs;
+	int cpu, n, err;
+
+	err = 0;
+	for_each_possible_cpu(cpu) {
+		cs = per_cpu_ptr(cc->cpu, cpu);
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
@@ -986,19 +1096,35 @@ static int crypt_set_key(struct crypt_config *cc, char *key)
 
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
+static void crypt_dtr_cpus(struct crypt_config *cc)
+{
+	struct crypt_cpu *cs;
+	int cpu;
+
+	for_each_possible_cpu(cpu) {
+		cs = per_cpu_ptr(cc->cpu, cpu);
+		if (cs->tfm) {
+			crypto_free_ablkcipher(cs->tfm);
+			cs->tfm = NULL;
+		}
+	}
 }
 
 static void crypt_dtr(struct dm_target *ti)
 {
 	struct crypt_config *cc = ti->private;
+	struct crypt_cpu *cs;
+	int cpu;
 
 	ti->private = NULL;
 
@@ -1010,6 +1136,12 @@ static void crypt_dtr(struct dm_target *ti)
 	if (cc->crypt_queue)
 		destroy_workqueue(cc->crypt_queue);
 
+	for_each_possible_cpu(cpu) {
+		cs = per_cpu_ptr(cc->cpu, cpu);
+		if (cs->req)
+			mempool_free(cs->req, cc->req_pool);
+	}
+
 	if (cc->bs)
 		bioset_free(cc->bs);
 
@@ -1023,12 +1155,14 @@ static void crypt_dtr(struct dm_target *ti)
 	if (cc->iv_gen_ops && cc->iv_gen_ops->dtr)
 		cc->iv_gen_ops->dtr(cc);
 
-	if (cc->tfm && !IS_ERR(cc->tfm))
-		crypto_free_ablkcipher(cc->tfm);
-
 	if (cc->dev)
 		dm_put_device(ti, cc->dev);
 
+	crypt_dtr_cpus(cc);
+
+	if (cc->cpu)
+		free_percpu(cc->cpu);
+
 	kzfree(cc->cipher);
 	kzfree(cc->cipher_mode);
 
@@ -1040,9 +1174,10 @@ static int crypt_ctr_cipher(struct dm_target *ti,
 			    char *cipher_in, char *key)
 {
 	struct crypt_config *cc = ti->private;
+	struct crypto_ablkcipher *tfm;
 	char *tmp, *cipher, *chainmode, *ivmode, *ivopts;
 	char *cipher_api = NULL;
-	int ret = -EINVAL;
+	int cpu, ret = -EINVAL;
 
 	/* Convert to crypto api definition? */
 	if (strchr(cipher_in, '(')) {
@@ -1074,6 +1209,12 @@ static int crypt_ctr_cipher(struct dm_target *ti,
 	if (tmp)
 		DMWARN("Ignoring unexpected additional cipher options");
 
+	cc->cpu = alloc_percpu(struct crypt_cpu);
+	if (!cc->cpu) {
+		ti->error = "Cannot allocate per cpu state";
+		goto bad_mem;
+	}
+
 	/* Compatibility mode for old dm-crypt mappings */
 	if (!chainmode || (!strcmp(chainmode, "plain") && !ivmode)) {
 		kfree(cc->cipher_mode);
@@ -1099,12 +1240,16 @@ static int crypt_ctr_cipher(struct dm_target *ti,
 	}
 
 	/* Allocate cipher */
-	cc->tfm = crypto_alloc_ablkcipher(cipher_api, 0, 0);
-	if (IS_ERR(cc->tfm)) {
-		ret = PTR_ERR(cc->tfm);
-		ti->error = "Error allocating crypto tfm";
-		goto bad;
-	}
+	for_each_possible_cpu (cpu) {
+		tfm = crypto_alloc_ablkcipher(cipher_api, 0, 0);
+		if (IS_ERR(tfm)) {
+			ret = PTR_ERR(tfm);
+			ti->error = "Error allocating crypto tfm";
+			goto bad;
+		}
+		per_cpu_ptr(cc->cpu, cpu)->tfm = tfm;
+ 	}
+	tfm = any_tfm(cc);
 
 	/* Initialize and set key */
 	ret = crypt_set_key(cc, key);
@@ -1114,7 +1259,7 @@ static int crypt_ctr_cipher(struct dm_target *ti,
 	}
 
 	/* Initialize IV */
-	cc->iv_size = crypto_ablkcipher_ivsize(cc->tfm);
+	cc->iv_size = crypto_ablkcipher_ivsize(tfm);
 	if (cc->iv_size)
 		/* at least a 64 bit sector number should fit in our buffer */
 		cc->iv_size = max(cc->iv_size,
@@ -1178,9 +1323,10 @@ bad_mem:
 static int crypt_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 {
 	struct crypt_config *cc;
+	struct crypt_cpu *cs;
 	unsigned int key_size;
 	unsigned long long tmpll;
-	int ret;
+	int ret, cpu;
 
 	if (argc != 5) {
 		ti->error = "Not enough arguments";
@@ -1208,9 +1354,9 @@ static int crypt_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 	}
 
 	cc->dmreq_start = sizeof(struct ablkcipher_request);
-	cc->dmreq_start += crypto_ablkcipher_reqsize(cc->tfm);
+	cc->dmreq_start += crypto_ablkcipher_reqsize(any_tfm(cc));
 	cc->dmreq_start = ALIGN(cc->dmreq_start, crypto_tfm_ctx_alignment());
-	cc->dmreq_start += crypto_ablkcipher_alignmask(cc->tfm) &
+	cc->dmreq_start += crypto_ablkcipher_alignmask(any_tfm(cc)) &
 			   ~(crypto_tfm_ctx_alignment() - 1);
 
 	cc->req_pool = mempool_create_kmalloc_pool(MIN_IOS, cc->dmreq_start +
@@ -1219,7 +1365,6 @@ static int crypt_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 		ti->error = "Cannot allocate crypt request mempool";
 		goto bad;
 	}
-	cc->req = NULL;
 
 	cc->page_pool = mempool_create_page_pool(MIN_POOL_PAGES, 0);
 	if (!cc->page_pool) {
@@ -1233,6 +1378,14 @@ static int crypt_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 		goto bad;
 	}
 
+	for_each_possible_cpu(cpu) {
+		cs = per_cpu_ptr(cc->cpu, cpu);
+		if (crypto_ablkcipher_setkey(cs->tfm, cc->key, key_size) < 0) {
+			ti->error = "Error setting key";
+			goto bad;
+		}
+	}
+
 	ret = -EINVAL;
 	if (sscanf(argv[2], "%llu", &tmpll) != 1) {
 		ti->error = "Invalid iv_offset sector";
@@ -1252,13 +1405,20 @@ static int crypt_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 	cc->start = tmpll;
 
 	ret = -ENOMEM;
-	cc->io_queue = create_singlethread_workqueue("kcryptd_io");
+	cc->io_queue = alloc_workqueue("kcryptd_io",
+				       WQ_NON_REENTRANT|
+				       WQ_MEM_RECLAIM,
+				       1);
 	if (!cc->io_queue) {
 		ti->error = "Couldn't create kcryptd io queue";
 		goto bad;
 	}
 
-	cc->crypt_queue = create_singlethread_workqueue("kcryptd");
+	cc->crypt_queue = alloc_workqueue("kcryptd",
+					  WQ_NON_REENTRANT|
+					  WQ_CPU_INTENSIVE|
+					  WQ_MEM_RECLAIM,
+					  1);
 	if (!cc->crypt_queue) {
 		ti->error = "Couldn't create kcryptd queue";
 		goto bad;


