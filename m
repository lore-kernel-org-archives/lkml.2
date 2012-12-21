Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751948Ab2LUCIs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 21:08:48 -0500
Received: from terminus.zytor.com ([198.137.202.10]:59061 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751626Ab2LUCIn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 21:08:43 -0500
Date: Thu, 20 Dec 2012 18:07:46 -0800
From: tip-bot for David Woodhouse <dwmw2@infradead.org>
Message-ID: <tip-ffee0de411fd4f74f3b788892eeb075abbf26c52@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        dwmw2@infradead.org, tglx@linutronix.de, hpa@linux.intel.com,
        David.Woodhouse@intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        dwmw2@infradead.org, tglx@linutronix.de, hpa@linux.intel.com,
        David.Woodhouse@intel.com
In-Reply-To: <1356040315.3198.51.camel@shinybook.infradead.org>
References: <1356040315.3198.51.camel@shinybook.infradead.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/build] x86: Default to ARCH=
 x86 to avoid overriding CONFIG_64BIT
Git-Commit-ID: ffee0de411fd4f74f3b788892eeb075abbf26c52
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Thu, 20 Dec 2012 18:07:52 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ffee0de411fd4f74f3b788892eeb075abbf26c52
Gitweb:     http://git.kernel.org/tip/ffee0de411fd4f74f3b788892eeb075abbf26c52
Author:     David Woodhouse <dwmw2@infradead.org>
AuthorDate: Thu, 20 Dec 2012 21:51:55 +0000
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Thu, 20 Dec 2012 14:37:18 -0800

x86: Default to ARCH=x86 to avoid overriding CONFIG_64BIT

It is easy to waste a bunch of time when one takes a 32-bit .config
from a test machine and try to build it on a faster 64-bit system, and
its existing setting of CONFIG_64BIT=n gets *changed* to match the
build host.  Similarly, if one has an existing build tree it is easy
to trash an entire build tree that way.

This is because the default setting for $ARCH when discovered from
'uname' is one of the legacy pre-x86-merge values (i386 or x86_64),
which effectively force the setting of CONFIG_64BIT to match. We should
default to ARCH=x86 instead, finally completing the merge that we
started so long ago.

This patch preserves the behaviour of the legacy ARCH settings for commands
such as:

   make ARCH=x86_64 randconfig
   make ARCH=i386 randconfig

... since making the value of CONFIG_64BIT actually random in that situation
is not desirable.

In time, perhaps we can retire this legacy use of the old ARCH= values.
We already have a way to override values for *any* config option, using
$KCONFIG_ALLCONFIG, so it could be argued that we don't necessarily need
to keep ARCH={i386,x86_64} around as a special case just for overriding
CONFIG_64BIT.

We'd probably at least want to add a way to override config options from
the command line ('make CONFIG_FOO=y oldconfig') before we talk about doing
that though.

Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>
Link: http://lkml.kernel.org/r/1356040315.3198.51.camel@shinybook.infradead.org
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 Makefile                        | 3 ++-
 arch/x86/Kconfig                | 2 +-
 arch/x86/Makefile               | 4 ++++
 arch/x86/configs/i386_defconfig | 1 +
 4 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/Makefile b/Makefile
index 540f7b2..9a07340 100644
--- a/Makefile
+++ b/Makefile
@@ -165,7 +165,8 @@ export srctree objtree VPATH
 # then ARCH is assigned, getting whatever value it gets normally, and 
 # SUBARCH is subsequently ignored.
 
-SUBARCH := $(shell uname -m | sed -e s/i.86/i386/ -e s/sun4u/sparc64/ \
+SUBARCH := $(shell uname -m | sed -e s/i.86/x86/ -e s/x86_64/x86/ \
+				  -e s/sun4u/sparc64/ \
 				  -e s/arm.*/arm/ -e s/sa110/arm/ \
 				  -e s/s390x/s390/ -e s/parisc64/parisc/ \
 				  -e s/ppc.*/powerpc/ -e s/mips.*/mips/ \
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 46c3bff..9084c7b 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1,7 +1,7 @@
 # Select 32 or 64 bit
 config 64BIT
 	bool "64-bit kernel" if ARCH = "x86"
-	default ARCH = "x86_64"
+	default ARCH != "i386"
 	---help---
 	  Say yes to build a 64-bit kernel - formerly known as x86_64
 	  Say no to build a 32-bit kernel - formerly known as i386
diff --git a/arch/x86/Makefile b/arch/x86/Makefile
index 05afcca..fa981ca 100644
--- a/arch/x86/Makefile
+++ b/arch/x86/Makefile
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
diff --git a/arch/x86/configs/i386_defconfig b/arch/x86/configs/i386_defconfig
index 5598547..9444708 100644
--- a/arch/x86/configs/i386_defconfig
+++ b/arch/x86/configs/i386_defconfig
@@ -1,3 +1,4 @@
+# CONFIG_64BIT is not set
 CONFIG_EXPERIMENTAL=y
 # CONFIG_LOCALVERSION_AUTO is not set
 CONFIG_SYSVIPC=y
