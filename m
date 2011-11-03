Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932954Ab1KCLmd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Nov 2011 07:42:33 -0400
Received: from helcar.apana.org.au ([209.40.204.226]:59060 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755767Ab1KCLmb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Nov 2011 07:42:31 -0400
Date: Thu, 3 Nov 2011 22:42:14 +1100
From: Herbert Xu <herbert@gondor.hengli.com.au>
To: Luis Henriques <henrix@camandro.org>
Cc: Steffen Klassert <steffen.klassert@secunet.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the crypto-current
	tree
Message-ID: <20111103114214.GA14681@gondor.apana.org.au>
References: <20111101115851.2e37ac680db78bdba0661691@canb.auug.org.au> <20111102200900.GA3454@hades> <20111102233936.GA10058@gondor.apana.org.au> <20111103055824.GC22141@secunet.com> <20111103061628.GA12678@gondor.apana.org.au> <20111103101554.GA17569@onza.mythic-beasts.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111103101554.GA17569@onza.mythic-beasts.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 03, 2011 at 10:15:54AM +0000, Luis Henriques wrote:
>
> No, this did not solved the problem; build still fails.  The problem is
> that, in lib/nlattr.c, we have:

Ugh, for the time being I guess we'll have to wrap these within
CONFIG_NET, as I'd rather not have CONFIG_CRYPTO depend on CONFIG_NET.

Please let me know whether this patch fixes the problem.

diff --git a/crypto/ablkcipher.c b/crypto/ablkcipher.c
index a816f24..aa19970 100644
--- a/crypto/ablkcipher.c
+++ b/crypto/ablkcipher.c
@@ -383,6 +383,7 @@ static int crypto_init_ablkcipher_ops(struct crypto_tfm *tfm, u32 type,
 	return 0;
 }
 
+#ifdef CONFIG_NET
 static int crypto_ablkcipher_report(struct sk_buff *skb, struct crypto_alg *alg)
 {
 	struct crypto_report_blkcipher rblkcipher;
@@ -404,6 +405,12 @@ static int crypto_ablkcipher_report(struct sk_buff *skb, struct crypto_alg *alg)
 nla_put_failure:
 	return -EMSGSIZE;
 }
+#else
+static int crypto_ablkcipher_report(struct sk_buff *skb, struct crypto_alg *alg)
+{
+	return -ENOSYS;
+}
+#endif
 
 static void crypto_ablkcipher_show(struct seq_file *m, struct crypto_alg *alg)
 	__attribute__ ((unused));
@@ -457,6 +464,7 @@ static int crypto_init_givcipher_ops(struct crypto_tfm *tfm, u32 type,
 	return 0;
 }
 
+#ifdef CONFIG_NET
 static int crypto_givcipher_report(struct sk_buff *skb, struct crypto_alg *alg)
 {
 	struct crypto_report_blkcipher rblkcipher;
@@ -478,6 +486,12 @@ static int crypto_givcipher_report(struct sk_buff *skb, struct crypto_alg *alg)
 nla_put_failure:
 	return -EMSGSIZE;
 }
+#else
+static int crypto_givcipher_report(struct sk_buff *skb, struct crypto_alg *alg)
+{
+	return -ENOSYS;
+}
+#endif
 
 static void crypto_givcipher_show(struct seq_file *m, struct crypto_alg *alg)
 	__attribute__ ((unused));
diff --git a/crypto/aead.c b/crypto/aead.c
index 701556f..fb8772f 100644
--- a/crypto/aead.c
+++ b/crypto/aead.c
@@ -111,6 +111,7 @@ static int crypto_init_aead_ops(struct crypto_tfm *tfm, u32 type, u32 mask)
 	return 0;
 }
 
+#ifdef CONFIG_NET
 static int crypto_aead_report(struct sk_buff *skb, struct crypto_alg *alg)
 {
 	struct crypto_report_aead raead;
@@ -132,6 +133,12 @@ static int crypto_aead_report(struct sk_buff *skb, struct crypto_alg *alg)
 nla_put_failure:
 	return -EMSGSIZE;
 }
+#else
+static int crypto_aead_report(struct sk_buff *skb, struct crypto_alg *alg)
+{
+	return -ENOSYS;
+}
+#endif
 
 static void crypto_aead_show(struct seq_file *m, struct crypto_alg *alg)
 	__attribute__ ((unused));
@@ -190,6 +197,7 @@ static int crypto_init_nivaead_ops(struct crypto_tfm *tfm, u32 type, u32 mask)
 	return 0;
 }
 
+#ifdef CONFIG_NET
 static int crypto_nivaead_report(struct sk_buff *skb, struct crypto_alg *alg)
 {
 	struct crypto_report_aead raead;
@@ -210,6 +218,12 @@ static int crypto_nivaead_report(struct sk_buff *skb, struct crypto_alg *alg)
 nla_put_failure:
 	return -EMSGSIZE;
 }
+#else
+static int crypto_nivaead_report(struct sk_buff *skb, struct crypto_alg *alg)
+{
+	return -ENOSYS;
+}
+#endif
 
 
 static void crypto_nivaead_show(struct seq_file *m, struct crypto_alg *alg)
diff --git a/crypto/ahash.c b/crypto/ahash.c
index a3e6ef9..1b9b7d1 100644
--- a/crypto/ahash.c
+++ b/crypto/ahash.c
@@ -399,6 +399,7 @@ static unsigned int crypto_ahash_extsize(struct crypto_alg *alg)
 	return sizeof(struct crypto_shash *);
 }
 
+#ifdef CONFIG_NET
 static int crypto_ahash_report(struct sk_buff *skb, struct crypto_alg *alg)
 {
 	struct crypto_report_hash rhash;
@@ -416,6 +417,12 @@ static int crypto_ahash_report(struct sk_buff *skb, struct crypto_alg *alg)
 nla_put_failure:
 	return -EMSGSIZE;
 }
+#else
+static int crypto_ahash_report(struct sk_buff *skb, struct crypto_alg *alg)
+{
+	return -ENOSYS;
+}
+#endif
 
 static void crypto_ahash_show(struct seq_file *m, struct crypto_alg *alg)
 	__attribute__ ((unused));
diff --git a/crypto/blkcipher.c b/crypto/blkcipher.c
index 2572d26..ad0226f 100644
--- a/crypto/blkcipher.c
+++ b/crypto/blkcipher.c
@@ -494,6 +494,7 @@ static int crypto_init_blkcipher_ops(struct crypto_tfm *tfm, u32 type, u32 mask)
 		return crypto_init_blkcipher_ops_async(tfm);
 }
 
+#ifdef CONFIG_NET
 static int crypto_blkcipher_report(struct sk_buff *skb, struct crypto_alg *alg)
 {
 	struct crypto_report_blkcipher rblkcipher;
@@ -515,6 +516,12 @@ static int crypto_blkcipher_report(struct sk_buff *skb, struct crypto_alg *alg)
 nla_put_failure:
 	return -EMSGSIZE;
 }
+#else
+static int crypto_blkcipher_report(struct sk_buff *skb, struct crypto_alg *alg)
+{
+	return -ENOSYS;
+}
+#endif
 
 static void crypto_blkcipher_show(struct seq_file *m, struct crypto_alg *alg)
 	__attribute__ ((unused));
diff --git a/crypto/pcompress.c b/crypto/pcompress.c
index fefda78..ad8b659 100644
--- a/crypto/pcompress.c
+++ b/crypto/pcompress.c
@@ -48,6 +48,7 @@ static int crypto_pcomp_init_tfm(struct crypto_tfm *tfm)
 	return 0;
 }
 
+#ifdef CONFIG_NET
 static int crypto_pcomp_report(struct sk_buff *skb, struct crypto_alg *alg)
 {
 	struct crypto_report_comp rpcomp;
@@ -62,6 +63,12 @@ static int crypto_pcomp_report(struct sk_buff *skb, struct crypto_alg *alg)
 nla_put_failure:
 	return -EMSGSIZE;
 }
+#else
+static int crypto_pcomp_report(struct sk_buff *skb, struct crypto_alg *alg)
+{
+	return -ENOSYS;
+}
+#endif
 
 static void crypto_pcomp_show(struct seq_file *m, struct crypto_alg *alg)
 	__attribute__ ((unused));
diff --git a/crypto/rng.c b/crypto/rng.c
index feb7de0..e7c23e8 100644
--- a/crypto/rng.c
+++ b/crypto/rng.c
@@ -60,6 +60,7 @@ static int crypto_init_rng_ops(struct crypto_tfm *tfm, u32 type, u32 mask)
 	return 0;
 }
 
+#ifdef CONFIG_NET
 static int crypto_rng_report(struct sk_buff *skb, struct crypto_alg *alg)
 {
 	struct crypto_report_rng rrng;
@@ -76,6 +77,12 @@ static int crypto_rng_report(struct sk_buff *skb, struct crypto_alg *alg)
 nla_put_failure:
 	return -EMSGSIZE;
 }
+#else
+static int crypto_rng_report(struct sk_buff *skb, struct crypto_alg *alg)
+{
+	return -ENOSYS;
+}
+#endif
 
 static void crypto_rng_show(struct seq_file *m, struct crypto_alg *alg)
 	__attribute__ ((unused));
diff --git a/crypto/shash.c b/crypto/shash.c
index ea8a9c6..dabbbb6 100644
--- a/crypto/shash.c
+++ b/crypto/shash.c
@@ -524,6 +524,7 @@ static unsigned int crypto_shash_extsize(struct crypto_alg *alg)
 	return alg->cra_ctxsize;
 }
 
+#ifdef CONFIG_NET
 static int crypto_shash_report(struct sk_buff *skb, struct crypto_alg *alg)
 {
 	struct crypto_report_hash rhash;
@@ -541,6 +542,12 @@ static int crypto_shash_report(struct sk_buff *skb, struct crypto_alg *alg)
 nla_put_failure:
 	return -EMSGSIZE;
 }
+#else
+static int crypto_shash_report(struct sk_buff *skb, struct crypto_alg *alg)
+{
+	return -ENOSYS;
+}
+#endif
 
 static void crypto_shash_show(struct seq_file *m, struct crypto_alg *alg)
 	__attribute__ ((unused));

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
