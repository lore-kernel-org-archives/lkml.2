Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755392Ab0JJS5D (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Oct 2010 14:57:03 -0400
Received: from mx1.redhat.com ([209.132.183.28]:64973 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752937Ab0JJS5B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Oct 2010 14:57:01 -0400
Message-ID: <4CB20C72.3030504@redhat.com>
Date: Sun, 10 Oct 2010 20:56:50 +0200
From: Milan Broz <mbroz@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100914 Thunderbird/3.1.3
MIME-Version: 1.0
To: Mike Snitzer <snitzer@redhat.com>
CC: Andi Kleen <andi@firstfloor.org>, Andi Kleen <ak@linux.intel.com>,
        device-mapper development <dm-devel@redhat.com>, pedrib@gmail.com,
        linux-kernel@vger.kernel.org, Alasdair G Kergon <agk@redhat.com>
Subject: [PATCH] Fix double free and use generic private pointer in per-cpu
 struct
References: <20101010115941.GA8539@basil.fritz.box> <4CB1B3B9.4030205@redhat.com> <20101010130842.GE8256@basil.fritz.box> <4CB1DD1A.5080906@redhat.com> <20101010162257.GA1272@redhat.com> <4CB1ECCA.8040801@redhat.com> <20101010170750.GA1475@redhat.com>
In-Reply-To: <20101010170750.GA1475@redhat.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 10/10/2010 07:07 PM, Mike Snitzer wrote:

> I'll send patch on top of Andi's v3 if it helps something. (When back to my devel machine).
> That'll be helpful (I'm sure Andi is interested).
ok here are my changes on top of v3 - one bugfix and generic IV pointer.
If you merge it to v4 and it appears in git as one patch I have no problem with that.

Thanks,
Milan


[PATCH] Use generic private pointer in per-cpu struct

If an IV need to use per-cpu struct, it should allocate
it in its constructor and free in destructor.
(There will be possible more compatibility IVs which need per-cpu struct.)

For ESSIV, only tfm pointer is needed so use iv_private directly.

Also fix double free of salt in ESSIV IV constructor.

Signed-off-by: Milan Broz <mbroz@redhat.com>

diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index 8802e1d..88a2a05 100644
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
@@ -234,6 +231,8 @@ static int crypt_iv_essiv_init(struct crypt_config *cc)
 	struct iv_essiv_private *essiv = &cc->iv_gen_private.essiv;
 	struct hash_desc desc;
 	struct scatterlist sg;
+	struct crypt_cpu *cs;
+	struct crypto_cipher *essiv_tfm;
 	int err, n, cpu;
 
 	sg_init_one(&sg, cc->key, cc->key_size);
@@ -245,9 +244,10 @@ static int crypt_iv_essiv_init(struct crypt_config *cc)
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
@@ -263,14 +263,17 @@ static int crypt_iv_essiv_wipe(struct crypt_config *cc)
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
@@ -312,6 +315,8 @@ static struct crypto_cipher *setup_essiv_cpu(struct crypt_config *cc,
 static void crypt_iv_essiv_dtr(struct crypt_config *cc)
 {
 	int cpu;
+	struct crypt_cpu *cs;
+	struct crypto_cipher *essiv_tfm;
 	struct iv_essiv_private *essiv = &cc->iv_gen_private.essiv;
 
 	crypto_free_hash(essiv->hash_tfm);
@@ -321,11 +326,11 @@ static void crypt_iv_essiv_dtr(struct crypt_config *cc)
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
 
@@ -365,11 +370,10 @@ static int crypt_iv_essiv_ctr(struct crypt_config *cc, struct dm_target *ti,
 		essiv_tfm = setup_essiv_cpu(cc, ti, salt,
 					crypto_hash_digestsize(hash_tfm));
 		if (IS_ERR(essiv_tfm)) {
-			kfree(salt);
 			crypt_iv_essiv_dtr(cc);
 			return PTR_ERR(essiv_tfm);
 		}
-		per_cpu_ptr(cc->cpu, cpu)->ie.tfm = essiv_tfm;
+		per_cpu_ptr(cc->cpu, cpu)->iv_private = essiv_tfm;
 	}
 	return 0;
 
@@ -382,9 +386,11 @@ bad:
 
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
 


