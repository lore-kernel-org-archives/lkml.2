Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755002Ab1E3HXL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 May 2011 03:23:11 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:33484 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754288Ab1E3HXJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 May 2011 03:23:09 -0400
Date: Mon, 30 May 2011 09:23:00 +0200
From: Ingo Molnar <mingo@elte.hu>
To: David Woodhouse <dwmw2@infradead.org>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix corruption of CONFIG_X86_32 in 'make oldconfig'
Message-ID: <20110530072300.GA9802@elte.hu>
References: <1306707270.2029.377.camel@i7.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1306707270.2029.377.camel@i7.infradead.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* David Woodhouse <dwmw2@infradead.org> wrote:

> I wasted a bunch of time today because I'd taken a .config from my 
> test machine and tried to build it, and the existing setting of 
> CONFIG_X86_32 got corrupted.
> 
> This patch fixes that. Last time I tried to fix this bug, I had to 
> contend with Ingo's objection that he didn't actually want 'make 
> randconfig' to give him a random config... [...]

You thoroughly misunderstood my prior regression report, the problem 
with your patch was that your patch actually *broke* existing 
filtered-randconfig behavior, for example trying to get a 64-bit 
randconfig:

  make ARCH=x86_64 randconfig

... will today produce a 64-bit randconfig while with your old change 
applied it produced a 32-bit randconfig 50% of the time.

That randconfig behavior is an entirely expected and intuitive: if 
the ARCH=x86_64 condition is added to the command line then kconfig 
should not ignore it - why should randconfig override the user's 
wishes? Furthermore this behavior worked fine before your first patch 
so not only did your first patch make kconfig behavior less 
intuitive, it also caused a regression.

Similarly, "make ARCH=i386 randconfig" will produce a 32-bit 
randconfig today, while with your old patch applied it produced a 
64-bit randconfig 50% of the time.

As i said it two years ago when you first submitted this patch:

 | I dont mind the change you are after, but randconfig should work as 
 | expected too: if ARCH=x86_64 is passed it should generate a 64-bit 
 | randconfig, not a 50% 32-bit one.

I still don't mind "make oldconfig" picking up the bitness of the 
.config instead of the host system's (it is the more intuitive and 
more correct behavior) - although note that me not minding it is not 
enough: we still have to be on the lookout for people and tools 
relying on that behavior.

So instead of complaining about my regression report i've updated the 
changelog as attached below - if you are fine with that then i'll 
commit and test it more widely.

Thanks,

	Ingo

-------------->
Subject: x86, kconfig: Pick up the .config arch version in 'make oldconfig'
From: David Woodhouse <dwmw2@infradead.org>
Date: Sun, 29 May 2011 23:14:28 +0100

I wasted a bunch of time today because I'd taken a .config from my 
test machine and tried to build it, and the existing setting of 
CONFIG_X86_32 got changed to the host system's bitness which was 
64-bit.

This patch fixes that. Last time I tried to fix this bug, I had 
introduced a regression that broke:

   make ARCH=x86_64 randconfig
   make ARCH=i386 randconfig

type of filtered-randconfig behavior which restricted randconfigs to 
64-bit and 32-bit configs, respectively.

This version fixes that so prior randconfig behavior is maintained.

Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>
Link: http://lkml.kernel.org/r/1306707270.2029.377.camel@i7.infradead.org
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 Makefile          |    3 ++-
 arch/x86/Kconfig  |    2 +-
 arch/x86/Makefile |    4 ++++
 3 files changed, 7 insertions(+), 2 deletions(-)

Index: linux/Makefile
===================================================================
--- linux.orig/Makefile
+++ linux/Makefile
@@ -165,7 +165,8 @@ export srctree objtree VPATH
 # then ARCH is assigned, getting whatever value it gets normally, and 
 # SUBARCH is subsequently ignored.
 
-SUBARCH := $(shell uname -m | sed -e s/i.86/i386/ -e s/sun4u/sparc64/ \
+SUBARCH := $(shell uname -m | sed -e s/i.86/x86/ -e s/x86_64/x86/ \
+				  -e s/sun4u/sparc64/ \
 				  -e s/arm.*/arm/ -e s/sa110/arm/ \
 				  -e s/s390x/s390/ -e s/parisc64/parisc/ \
 				  -e s/ppc.*/powerpc/ -e s/mips.*/mips/ \
Index: linux/arch/x86/Kconfig
===================================================================
--- linux.orig/arch/x86/Kconfig
+++ linux/arch/x86/Kconfig
@@ -1,7 +1,7 @@
 # Select 32 or 64 bit
 config 64BIT
 	bool "64-bit kernel" if ARCH = "x86"
-	default ARCH = "x86_64"
+	default ARCH != "i386"
 	---help---
 	  Say yes to build a 64-bit kernel - formerly known as x86_64
 	  Say no to build a 32-bit kernel - formerly known as i386
Index: linux/arch/x86/Makefile
===================================================================
--- linux.orig/arch/x86/Makefile
+++ linux/arch/x86/Makefile
@@ -2,7 +2,11 @@
 
 # select defconfig based on actual architecture
 ifeq ($(ARCH),x86)
+  ifeq ($(shell uname -m),x86_64)
+        KBUILD_DEFCONFIG := x86_64_defconfig
+  else
         KBUILD_DEFCONFIG := i386_defconfig
+  endif
 else
         KBUILD_DEFCONFIG := $(ARCH)_defconfig
 endif
