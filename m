Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753040Ab1BHVY2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Feb 2011 16:24:28 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:54955 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752568Ab1BHVYZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Feb 2011 16:24:25 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 2/5] PM: Make CONFIG_PM depend on (CONFIG_PM_SLEEP || CONFIG_PM_RUNTIME)
Date: Tue, 8 Feb 2011 22:21:07 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.38-rc4+; KDE/4.4.4; x86_64; ; )
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Len Brown <len.brown@intel.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-embedded@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
References: <1297081335-13631-1-git-send-email-broonie@opensource.wolfsonmicro.com> <20110208122159.GA8284@elte.hu> <201102082218.28015.rjw@sisk.pl>
In-Reply-To: <201102082218.28015.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-Id: <201102082221.07930.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

>From the users' point of view CONFIG_PM is really only used for
making it possible to set CONFIG_SUSPEND, CONFIG_HIBERNATION,
CONFIG_PM_RUNTIME and (surprisingly enough) CONFIG_XEN_SAVE_RESTORE
(CONFIG_PM_OPP also depends on CONFIG_PM, but quite artificially).
However, both CONFIG_SUSPEND and CONFIG_HIBERNATION require platform
support (independent of CONFIG_PM) and it is not quite obvious that
CONFIG_PM has to be set for CONFIG_XEN_SAVE_RESTORE to be available.
Thus, from the users' point of view, it would be more logical to
automatically select CONFIG_PM if any of the above options depending
on it are set.

Make CONFIG_PM depend on (CONFIG_PM_SLEEP || CONFIG_PM_RUNTIME),
which will cause it to be selected when any of CONFIG_SUSPEND,
CONFIG_HIBERNATION, CONFIG_PM_RUNTIME, CONFIG_XEN_SAVE_RESTORE is
set and will clarify its meaning.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 arch/x86/xen/Kconfig |    2 +-
 kernel/power/Kconfig |   29 ++++++-----------------------
 2 files changed, 7 insertions(+), 24 deletions(-)

Index: linux-2.6/kernel/power/Kconfig
===================================================================
--- linux-2.6.orig/kernel/power/Kconfig
+++ linux-2.6/kernel/power/Kconfig
@@ -1,23 +1,7 @@
 config PM
-	bool "Power Management support"
-	depends on !IA64_HP_SIM
-	---help---
-	  "Power Management" means that parts of your computer are shut
-	  off or put into a power conserving "sleep" mode if they are not
-	  being used.  There are two competing standards for doing this: APM
-	  and ACPI.  If you want to use either one, say Y here and then also
-	  to the requisite support below.
-
-	  Power Management is most important for battery powered laptop
-	  computers; if you have a laptop, check out the Linux Laptop home
-	  page on the WWW at <http://www.linux-on-laptops.com/> or
-	  Tuxmobil - Linux on Mobile Computers at <http://www.tuxmobil.org/>
-	  and the Battery Powered Linux mini-HOWTO, available from
-	  <http://www.tldp.org/docs.html#howto>.
-
-	  Note that, even if you say N here, Linux on the x86 architecture
-	  will issue the hlt instruction if nothing is to be done, thereby
-	  sending the processor to sleep and saving power.
+	bool
+	depends on PM_SLEEP || PM_RUNTIME
+	default y
 
 config PM_DEBUG
 	bool "Power Management Debug Support"
@@ -102,7 +86,7 @@ config PM_SLEEP_ADVANCED_DEBUG
 
 config SUSPEND
 	bool "Suspend to RAM and standby"
-	depends on PM && ARCH_SUSPEND_POSSIBLE
+	depends on ARCH_SUSPEND_POSSIBLE
 	default y
 	---help---
 	  Allow the system to enter sleep states in which main memory is
@@ -133,7 +117,7 @@ config SUSPEND_FREEZER
 
 config HIBERNATION
 	bool "Hibernation (aka 'suspend to disk')"
-	depends on PM && SWAP && ARCH_HIBERNATION_POSSIBLE
+	depends on SWAP && ARCH_HIBERNATION_POSSIBLE
 	select LZO_COMPRESS
 	select LZO_DECOMPRESS
 	---help---
@@ -224,7 +208,7 @@ config APM_EMULATION
 
 config PM_RUNTIME
 	bool "Run-time PM core functionality"
-	depends on PM
+	depends on !IA64_HP_SIM
 	---help---
 	  Enable functionality allowing I/O devices to be put into energy-saving
 	  (low power) states at run time (or autosuspended) after a specified
@@ -246,7 +230,6 @@ config ARCH_HAS_OPP
 
 config PM_OPP
 	bool "Operating Performance Point (OPP) Layer library"
-	depends on PM
 	depends on ARCH_HAS_OPP
 	---help---
 	  SOCs have a standard set of tuples consisting of frequency and
Index: linux-2.6/arch/x86/xen/Kconfig
===================================================================
--- linux-2.6.orig/arch/x86/xen/Kconfig
+++ linux-2.6/arch/x86/xen/Kconfig
@@ -38,7 +38,7 @@ config XEN_MAX_DOMAIN_MEMORY
 
 config XEN_SAVE_RESTORE
        bool
-       depends on XEN && PM
+       depends on XEN
        default y
 
 config XEN_DEBUG_FS

