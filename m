Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933893Ab0FCKed (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 06:34:33 -0400
Received: from ringil.hengli.com.au ([216.59.3.182]:54627 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933843Ab0FCKeb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 06:34:31 -0400
Date: Thu, 3 Jun 2010 20:34:27 +1000
From: Herbert Xu <herbert@gondor.hengli.com.au>
To: Alexander Shishkin <virtuoso@slind.org>
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
Subject: Re: [PATCH] crypto: add an option to disable cryptoalgos'
	self-tests
Message-ID: <20100603103427.GB31063@gondor.apana.org.au>
References: <20100526004357.GE20073@gondor.apana.org.au> <1274866114-15817-1-git-send-email-virtuoso@slind.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1274866114-15817-1-git-send-email-virtuoso@slind.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 26, 2010 at 12:28:34PM +0300, Alexander Shishkin wrote:
> By default, CONFIG_CRYPTO_MANAGER_TESTS will be enabled and thus
> self-tests will still run, but it is now possible to disable them
> to gain some time during bootup.

While reviewing this patch I found a bug in the current PCOMP
Kconfig entry.

commit bc94e59662c13516d13e117b6edab4bec487d5a0
Author: Herbert Xu <herbert@gondor.apana.org.au>
Date:   Thu Jun 3 20:33:06 2010 +1000

    crypto: pcomp - Fix illegal Kconfig configuration
    
    The PCOMP Kconfig entry current allows the following combination
    which is illegal:
    
    ZLIB=y
    PCOMP=y
    ALGAPI=m
    ALGAPI2=y
    MANAGER=m
    MANAGER2=m
    
    This patch fixes this by adding PCOMP2 so that PCOMP can select
    ALGAPI to propagate the setting to MANAGER2.
    
    Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/crypto/Kconfig b/crypto/Kconfig
index 9d9434f..11d0f21 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -80,6 +80,11 @@ config CRYPTO_RNG2
 
 config CRYPTO_PCOMP
 	tristate
+	select CRYPTO_PCOMP2
+	select CRYPTO_ALGAPI
+
+config CRYPTO_PCOMP2
+	tristate
 	select CRYPTO_ALGAPI2
 
 config CRYPTO_MANAGER
@@ -94,7 +99,7 @@ config CRYPTO_MANAGER2
 	select CRYPTO_AEAD2
 	select CRYPTO_HASH2
 	select CRYPTO_BLKCIPHER2
-	select CRYPTO_PCOMP
+	select CRYPTO_PCOMP2
 
 config CRYPTO_GF128MUL
 	tristate "GF(2^128) multiplication functions (EXPERIMENTAL)"
diff --git a/crypto/Makefile b/crypto/Makefile
index d7e6441..d1cfa05 100644
--- a/crypto/Makefile
+++ b/crypto/Makefile
@@ -26,7 +26,7 @@ crypto_hash-objs += ahash.o
 crypto_hash-objs += shash.o
 obj-$(CONFIG_CRYPTO_HASH2) += crypto_hash.o
 
-obj-$(CONFIG_CRYPTO_PCOMP) += pcompress.o
+obj-$(CONFIG_CRYPTO_PCOMP2) += pcompress.o
 
 cryptomgr-objs := algboss.o testmgr.o
 
Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
