Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934906Ab0HFBlK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 21:41:10 -0400
Received: from helcar.apana.org.au ([209.40.204.226]:48629 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934131Ab0HFBlG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 21:41:06 -0400
Date: Fri, 6 Aug 2010 09:40:57 +0800
From: Herbert Xu <herbert@gondor.hengli.com.au>
To: David Howells <dhowells@redhat.com>
Cc: torvalds@osdl.org, gregkh@suse.de, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org
Subject: Re: Initcall ordering problem (TTY vs modprobe vs MD5) and
	cryptomgr problem
Message-ID: <20100806014057.GA22395@gondor.apana.org.au>
References: <23662.1281056463@redhat.com> <20100806011706.GA21657@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100806011706.GA21657@gondor.apana.org.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 06, 2010 at 09:17:06AM +0800, Herbert Xu wrote:
> On Fri, Aug 06, 2010 at 02:01:03AM +0100, David Howells wrote:
> > 
> > but it's not being found by the crypto routines.  By GIT bisection, I note
> > that this problem is introduced in the following commit:
> > 
> > 	commit 0b767f96164b2b27488e3daa722ff16e89d49314
> > 	Author: Alexander Shishkin <virtuoso@slind.org>
> > 	Date:   Thu Jun 3 20:53:43 2010 +1000
> > 
> > 	crypto: testmgr - add an option to disable cryptoalgos' self-tests
> 
> Indeed this changeset is buggy.  It makes cryptomgr return a value
> as if it was not loaded.  This triggers the module load.
> 
> I'll send you a patch.

This patch should do the trick:

commit 326a6346ffb5b19eb593530d9d3096d409e46f62
Author: Herbert Xu <herbert@gondor.apana.org.au>
Date:   Fri Aug 6 09:40:28 2010 +0800

    crypto: testmgr - Fix test disabling option
    
    This patch fixes a serious bug in the test disabling patch where
    it can cause an spurious load of the cryptomgr module even when
    it's compiled in.
    
    It also negates the test disabling option so that its absence
    causes tests to be enabled.
    
    The Kconfig option is also now behind EMBEDDED.
    
    Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/crypto/Kconfig b/crypto/Kconfig
index 1cd497d..6f5c50f 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -101,13 +101,12 @@ config CRYPTO_MANAGER2
 	select CRYPTO_BLKCIPHER2
 	select CRYPTO_PCOMP2
 
-config CRYPTO_MANAGER_TESTS
-	bool "Run algolithms' self-tests"
-	default y
-	depends on CRYPTO_MANAGER2
+config CRYPTO_MANAGER_DISABLE_TESTS
+	bool "Disable run-time self tests"
+	depends on CRYPTO_MANAGER2 && EMBEDDED
 	help
-	  Run cryptomanager's tests for the new crypto algorithms being
-	  registered.
+	  Disable run-time self tests that normally take place at
+	  algorithm registration.
 
 config CRYPTO_GF128MUL
 	tristate "GF(2^128) multiplication functions (EXPERIMENTAL)"
diff --git a/crypto/algboss.c b/crypto/algboss.c
index 40bd391..791d194 100644
--- a/crypto/algboss.c
+++ b/crypto/algboss.c
@@ -206,13 +206,16 @@ err:
 	return NOTIFY_OK;
 }
 
-#ifdef CONFIG_CRYPTO_MANAGER_TESTS
 static int cryptomgr_test(void *data)
 {
 	struct crypto_test_param *param = data;
 	u32 type = param->type;
 	int err = 0;
 
+#ifdef CONFIG_CRYPTO_MANAGER_DISABLE_TESTS
+	goto skiptest;
+#endif
+
 	if (type & CRYPTO_ALG_TESTED)
 		goto skiptest;
 
@@ -267,7 +270,6 @@ err_put_module:
 err:
 	return NOTIFY_OK;
 }
-#endif /* CONFIG_CRYPTO_MANAGER_TESTS */
 
 static int cryptomgr_notify(struct notifier_block *this, unsigned long msg,
 			    void *data)
@@ -275,10 +277,8 @@ static int cryptomgr_notify(struct notifier_block *this, unsigned long msg,
 	switch (msg) {
 	case CRYPTO_MSG_ALG_REQUEST:
 		return cryptomgr_schedule_probe(data);
-#ifdef CONFIG_CRYPTO_MANAGER_TESTS
 	case CRYPTO_MSG_ALG_REGISTER:
 		return cryptomgr_schedule_test(data);
-#endif
 	}
 
 	return NOTIFY_DONE;
diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index abd980c..fa8c8f7 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -23,7 +23,7 @@
 
 #include "internal.h"
 
-#ifndef CONFIG_CRYPTO_MANAGER_TESTS
+#ifdef CONFIG_CRYPTO_MANAGER_DISABLE_TESTS
 
 /* a perfect nop */
 int alg_test(const char *driver, const char *alg, u32 type, u32 mask)
@@ -2542,6 +2542,6 @@ non_fips_alg:
 	return -EINVAL;
 }
 
-#endif /* CONFIG_CRYPTO_MANAGER_TESTS */
+#endif /* CONFIG_CRYPTO_MANAGER_DISABLE_TESTS */
 
 EXPORT_SYMBOL_GPL(alg_test);

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
