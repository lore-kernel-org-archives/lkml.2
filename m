Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935286Ab0HFCf4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 22:35:56 -0400
Received: from helcar.apana.org.au ([209.40.204.226]:33512 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933390Ab0HFCfx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 22:35:53 -0400
Date: Fri, 6 Aug 2010 10:35:39 +0800
From: Herbert Xu <herbert@gondor.hengli.com.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: David Howells <dhowells@redhat.com>, gregkh@suse.de,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
Subject: Re: Initcall ordering problem (TTY vs modprobe vs MD5) and
	cryptomgr problem
Message-ID: <20100806023539.GA22774@gondor.apana.org.au>
References: <23662.1281056463@redhat.com> <20100806011706.GA21657@gondor.apana.org.au> <20100806014057.GA22395@gondor.apana.org.au> <AANLkTi=+-Y2GOZYAZHeaX+op3XB9AY5S85rfJD3jSDvz@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTi=+-Y2GOZYAZHeaX+op3XB9AY5S85rfJD3jSDvz@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 05, 2010 at 07:01:21PM -0700, Linus Torvalds wrote:
> On Thu, Aug 5, 2010 at 6:40 PM, Herbert Xu <herbert@gondor.hengli.com.au> wrote:
> >
> > -config CRYPTO_MANAGER_TESTS
> > -       bool "Run algolithms' self-tests"
> > -       default y
> > -       depends on CRYPTO_MANAGER2
> > +config CRYPTO_MANAGER_DISABLE_TESTS
> > +       bool "Disable run-time self tests"
> > +       depends on CRYPTO_MANAGER2 && EMBEDDED
> 
> Why do you still want to force-enable those tests? I was going to
> complain about the "default y" anyway, now I'm _really_ complaining,
> because you've now made it impossible to disable those tests. Why?

Because it can save data.  Each cryptographic algorithm (such as
AES) may have multiple impelmentations, some of which are hardware-
based.

The purpose of these tests are to make a particular driver or
implementation available only if it passes them.  So your encrypted
disk/file system will not be subject to a hardware/software combo
without at least some semblance of testing.

The last thing you want to is to upgrade your kernel with a new
hardware crypto driver that detects that you have a piece of rarely-
used crypto hardeware, decides to use it and ends up making your
data toast.

But whatever, if you want the default to be no tests, that's fine.
Here's the patch to do just that.

commit 00ca28a507b215dcd121735f16764ea4173c4ff9
Author: Herbert Xu <herbert@gondor.apana.org.au>
Date:   Fri Aug 6 10:34:00 2010 +0800

    crypto: testmgr - Default to no tests
    
    On Thu, Aug 05, 2010 at 07:01:21PM -0700, Linus Torvalds wrote:
    > On Thu, Aug 5, 2010 at 6:40 PM, Herbert Xu <herbert@gondor.hengli.com.au> wrote:
    > >
    > > -config CRYPTO_MANAGER_TESTS
    > > -       bool "Run algolithms' self-tests"
    > > -       default y
    > > -       depends on CRYPTO_MANAGER2
    > > +config CRYPTO_MANAGER_DISABLE_TESTS
    > > +       bool "Disable run-time self tests"
    > > +       depends on CRYPTO_MANAGER2 && EMBEDDED
    >
    > Why do you still want to force-enable those tests? I was going to
    > complain about the "default y" anyway, now I'm _really_ complaining,
    > because you've now made it impossible to disable those tests. Why?
    
    As requested, this patch sets the default to y and removes the
    EMBEDDED dependency.
    
    Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/crypto/Kconfig b/crypto/Kconfig
index 6f5c50f..e573077 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -103,7 +103,8 @@ config CRYPTO_MANAGER2
 
 config CRYPTO_MANAGER_DISABLE_TESTS
 	bool "Disable run-time self tests"
-	depends on CRYPTO_MANAGER2 && EMBEDDED
+	default y
+	depends on CRYPTO_MANAGER2
 	help
 	  Disable run-time self tests that normally take place at
 	  algorithm registration.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
