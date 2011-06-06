Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752798Ab1FFQvo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 12:51:44 -0400
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:37598 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750896Ab1FFQvn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 12:51:43 -0400
X-Originating-IP: 217.70.178.134
X-Originating-IP: 50.43.15.19
Date: Mon, 6 Jun 2011 09:51:30 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>, Sam Ravnborg <sam@ravnborg.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCHv3] Make CONFIG_EXPERT select CONFIG_DEBUG_KERNEL to unhide
 debug options
Message-ID: <20110606165130.GA1844@leaf>
References: <20110605210223.GA7595@leaf>
 <20110606151832.GI30348@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110606151832.GI30348@elte.hu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Several debugging options currently default to y, such as
CONFIG_DEBUG_BUGVERBOSE and CONFIG_DEBUG_RODATA.  Embedded users might
want to turn those options off to save space; however, turning them off
requires turning on CONFIG_DEBUG_KERNEL to unhide them.  Since
CONFIG_DEBUG_KERNEL exists specifically to unhide debugging options, and
CONFIG_EXPERT exists specifically to unhide options potentially needed
by experts and/or embedded users, make CONFIG_EXPERT automatically imply
CONFIG_DEBUG_KERNEL.

Change various debugging options to only reference DEBUG_KERNEL, not
EXPERT.

Note that DEBUG_MEMORY_INIT defaulted to !EXPERT, which seemed wrong,
since EXPERT should not directly affect anything except the availability
of other options.  (And EXPERT definitely shouldn't mean "implicitly
turn off default safety features".)  Change it to default to y, which
means that turning on EXPERT does not automatically disable it, but will
provide the option to disable it.

Signed-off-by: Josh Triplett <josh@joshtriplett.org>
---

v3: Changed other debugging options to stop referencing EXPERT.

 arch/tile/Kconfig.debug |    2 +-
 init/Kconfig            |    2 ++
 lib/Kconfig.debug       |    6 +++---
 3 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/arch/tile/Kconfig.debug b/arch/tile/Kconfig.debug
index ddbfc33..afc9cf3 100644
--- a/arch/tile/Kconfig.debug
+++ b/arch/tile/Kconfig.debug
@@ -3,7 +3,7 @@ menu "Kernel hacking"
 source "lib/Kconfig.debug"
 
 config EARLY_PRINTK
-	bool "Early printk" if EXPERT && DEBUG_KERNEL
+	bool "Early printk" if DEBUG_KERNEL
 	default y
 	help
 	  Write kernel log output directly via the hypervisor console.
diff --git a/init/Kconfig b/init/Kconfig
index ebafac4..14370d3 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -909,6 +909,8 @@ config ANON_INODES
 
 menuconfig EXPERT
 	bool "Configure standard kernel features (expert users)"
+	# Unhide debug options, to make the on-by-default options visible
+	select DEBUG_KERNEL
 	help
 	  This option allows certain base kernel options and settings
           to be disabled or tweaked. This is for specialized
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index dd373c8..b121413 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -694,7 +694,7 @@ config DEBUG_HIGHMEM
 	  Disable for production systems.
 
 config DEBUG_BUGVERBOSE
-	bool "Verbose BUG() reporting (adds 70K)" if DEBUG_KERNEL && EXPERT
+	bool "Verbose BUG() reporting (adds 70K)" if DEBUG_KERNEL
 	depends on BUG
 	depends on ARM || AVR32 || M32R || M68K || SPARC32 || SPARC64 || \
 		   FRV || SUPERH || GENERIC_BUG || BLACKFIN || MN10300 || TILE
@@ -766,8 +766,8 @@ config DEBUG_WRITECOUNT
 	  If unsure, say N.
 
 config DEBUG_MEMORY_INIT
-	bool "Debug memory initialisation" if EXPERT
-	default !EXPERT
+	bool "Debug memory initialisation" if DEBUG_KERNEL
+	default y
 	help
 	  Enable this for additional checks during memory initialisation.
 	  The sanity checks verify aspects of the VM such as the memory model
-- 
1.7.5.3

