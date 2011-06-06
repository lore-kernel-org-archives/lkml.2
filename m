Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758143Ab1FFWI1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 18:08:27 -0400
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:50180 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758090Ab1FFWIZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 18:08:25 -0400
X-Originating-IP: 217.70.178.137
X-Originating-IP: 131.252.246.56
Date: Mon, 6 Jun 2011 15:08:10 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Sam Ravnborg <sam@ravnborg.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCHv4] Make CONFIG_EXPERT select CONFIG_DEBUG_KERNEL to unhide
 debug options
Message-ID: <20110606220810.GA1999@leaf>
References: <20110605210223.GA7595@leaf>
 <20110606151832.GI30348@elte.hu>
 <20110606165130.GA1844@leaf>
 <20110606181606.GB7862@somewhere>
 <20110606183939.GA2335@leaf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110606183939.GA2335@leaf>
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

Since EXPERT now implies DEBUG_KERNEL, change debugging options that
reference DEBUG_KERNEL && EXPERT to just reference EXPERT.

Signed-off-by: Josh Triplett <josh@joshtriplett.org>
---
v4: Avoid semantic changes, by changing DEBUG_KERNEL && EXPERT to EXPERT
rather than to DEBUG_KERNEL.  This avoids exposing debug options that
only experts should turn off, such as DEBUG_BUGVERBOSE.

A subsequent patch should probably go through and change the various
"default !EXPERT" lines to "default y", since enabling CONFIG_EXPERT
should not directly change anything.

 arch/tile/Kconfig.debug |    2 +-
 init/Kconfig            |    2 ++
 lib/Kconfig.debug       |    2 +-
 3 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/tile/Kconfig.debug b/arch/tile/Kconfig.debug
index ddbfc33..1d31246 100644
--- a/arch/tile/Kconfig.debug
+++ b/arch/tile/Kconfig.debug
@@ -3,7 +3,7 @@ menu "Kernel hacking"
 source "lib/Kconfig.debug"
 
 config EARLY_PRINTK
-	bool "Early printk" if EXPERT && DEBUG_KERNEL
+	bool "Early printk" if EXPERT
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
index dd373c8..9a00361 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -694,7 +694,7 @@ config DEBUG_HIGHMEM
 	  Disable for production systems.
 
 config DEBUG_BUGVERBOSE
-	bool "Verbose BUG() reporting (adds 70K)" if DEBUG_KERNEL && EXPERT
+	bool "Verbose BUG() reporting (adds 70K)" if EXPERT
 	depends on BUG
 	depends on ARM || AVR32 || M32R || M68K || SPARC32 || SPARC64 || \
 		   FRV || SUPERH || GENERIC_BUG || BLACKFIN || MN10300 || TILE
-- 
1.7.5.3

