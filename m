Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760686Ab0GSM2I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jul 2010 08:28:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47459 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760675Ab0GSM2E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jul 2010 08:28:04 -0400
Message-ID: <4C4444C2.6040607@redhat.com>
Date: Mon, 19 Jul 2010 14:27:46 +0200
From: Milan Broz <mbroz@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.4) Gecko/20100608 Lightning/1.0b2 Thunderbird/3.1
MIME-Version: 1.0
To: device-mapper development <dm-devel@redhat.com>,
        Andi Kleen <andi@firstfloor.org>
CC: agk@redhat.com, linux-kernel@vger.kernel.org, eric.dumazet@gmail.com
Subject: Re: [dm-devel] [PATCH] DM-CRYPT: Scale to multiple CPUs v2
References: <20100601075259.GA13333@basil.fritz.box>
In-Reply-To: <20100601075259.GA13333@basil.fritz.box>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 On 06/01/2010 09:52 AM, Andi Kleen wrote:
> DM-CRYPT: Scale to multiple CPUs v2
>
> Updated version with the per CPU access improvements Eric suggested.
Hi,

seems that this approach is probably the best one we can use now...
(I would better see threads in crypto layer but that's taken of
the programme for today, seems.)

I did some tests and it works for me, even tries some strange stacked
mapping etc.
Do you have some exact numbers for particular tests btw?

Anyway, I have just one comment - please can we make the per-cpu attribute
for IV generic? IOW not add explicit ie (ESSIV) but void * iv_private
- see attached patch.

(I'll try discuss this with Alasdair to review for next merge
window, I think you requested that already in some private mail...)

Otherwise ack and

Reviewed-by: Milan Broz <mbroz@redhat.com>

Thanks,
Milan
----

[PATCH] Use generic private pointer in per-cpu struct

If an IV need to use per-cpu struct, it should allocate
it in its constructor and free in destructor.
(There will be possible more compatibility IVs which need per-cpu struct.)

For ESSIV, only tfm pointer is needed so use iv_private directly.

Signed-off-by: Milan Broz <mbroz@redhat.com>
---
 drivers/md/dm-crypt.c |   41 ++++++++++++++++++++++++-----------------
 1 files changed, 24 insertions(+), 17 deletions(-)

diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index 13b1675..f7b2cf6 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -82,11 +82,6 @@ struct iv_essiv_private {
 	u8 *salt;
 };
 
-/* Duplicated per CPU state for cipher */
-struct iv_essiv_private_cpu {
-	struct crypto_cipher *tfm;
-};
-
 struct iv_benbi_private {
 	int shift;
 };
@@ -101,7 +96,9 @@ enum flags { DM_CRYPT_SUSPENDED, DM_CRYPT_KEY_VALID };
 struct crypt_cpu {
 	struct ablkcipher_request *req;
 	struct crypto_ablkcipher *tfm;
-	struct iv_essiv_private_cpu ie;
+
+	/* ESSIV: struct crypto_cipher *essiv_tfm */
+	void *iv_private;
 };
 
 /*
@@ -235,6 +232,8 @@ static int crypt_iv_essiv_init(struct crypt_config *cc)
 	struct iv_essiv_private *essiv = &cc->iv_gen_private.essiv;
 	struct hash_desc desc;
 	struct scatterlist sg;
+	struct crypt_cpu *cs;
+	struct crypto_cipher *essiv_tfm;
 	int err, n, cpu;
 
 	sg_init_one(&sg, cc->key, cc->key_size);
@@ -246,9 +245,10 @@ static int crypt_iv_essiv_init(struct crypt_config *cc)
 		return err;
 
 	for_each_possible_cpu (cpu) {
-		struct crypt_cpu *cs = per_cpu_ptr(cc->cpu, cpu);
+		cs = per_cpu_ptr(cc->cpu, cpu);
+		essiv_tfm = cs->iv_private,
 
-		n = crypto_cipher_setkey(cs->ie.tfm, essiv->salt,
+		n = crypto_cipher_setkey(essiv_tfm, essiv->salt,
 				    crypto_hash_digestsize(essiv->hash_tfm));
 		if (n) {
 			err = n;
@@ -264,14 +264,17 @@ static int crypt_iv_essiv_wipe(struct crypt_config *cc)
 {
 	struct iv_essiv_private *essiv = &cc->iv_gen_private.essiv;
 	unsigned salt_size = crypto_hash_digestsize(essiv->hash_tfm);
+	struct crypt_cpu *cs;
+	struct crypto_cipher *essiv_tfm;
 	int cpu, err, n;
 
 	memset(essiv->salt, 0, salt_size);
 
 	err = 0;
 	for_each_possible_cpu (cpu) {
-		struct crypt_cpu *cs = per_cpu_ptr(cc->cpu, cpu);
-		n = crypto_cipher_setkey(cs->ie.tfm, essiv->salt, salt_size);
+		cs = per_cpu_ptr(cc->cpu, cpu);
+		essiv_tfm = cs->iv_private;
+		n = crypto_cipher_setkey(essiv_tfm, essiv->salt, salt_size);
 		if (n)
 			err = n;
 	}
@@ -314,6 +317,8 @@ static struct crypto_cipher *setup_essiv_cpu(struct crypt_config *cc,
 static void crypt_iv_essiv_dtr(struct crypt_config *cc)
 {
 	int cpu;
+	struct crypt_cpu *cs;
+	struct crypto_cipher *essiv_tfm;
 	struct iv_essiv_private *essiv = &cc->iv_gen_private.essiv;
 
 	crypto_free_hash(essiv->hash_tfm);
@@ -323,11 +328,11 @@ static void crypt_iv_essiv_dtr(struct crypt_config *cc)
 	essiv->salt = NULL;
 
 	for_each_possible_cpu (cpu) {
-		struct crypt_cpu *cs = per_cpu_ptr(cc->cpu, cpu);
-		if (cs->ie.tfm) {
-			crypto_free_cipher(cs->ie.tfm);
-			cs->ie.tfm = NULL;
-		}
+		cs = per_cpu_ptr(cc->cpu, cpu);
+		essiv_tfm = cs->iv_private;
+		if (essiv_tfm)
+			crypto_free_cipher(essiv_tfm);
+		cs->iv_private = NULL;
 	}
 }
 
@@ -371,7 +376,7 @@ static int crypt_iv_essiv_ctr(struct crypt_config *cc, struct dm_target *ti,
 			crypt_iv_essiv_dtr(cc);
 			return PTR_ERR(essiv_tfm);
 		}
-		per_cpu_ptr(cc->cpu, cpu)->ie.tfm = essiv_tfm;
+		per_cpu_ptr(cc->cpu, cpu)->iv_private = essiv_tfm;
 	}
 	return 0;
 
@@ -384,9 +389,11 @@ bad:
 
 static int crypt_iv_essiv_gen(struct crypt_config *cc, u8 *iv, sector_t sector)
 {
+	struct crypto_cipher *essiv_tfm = crypt_me(cc)->iv_private;
+
 	memset(iv, 0, cc->iv_size);
 	*(u64 *)iv = cpu_to_le64(sector);
-	crypto_cipher_encrypt_one(crypt_me(cc)->ie.tfm, iv, iv);
+	crypto_cipher_encrypt_one(essiv_tfm, iv, iv);
 	return 0;
 }
 
-- 
1.7.1



