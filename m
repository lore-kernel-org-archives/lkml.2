Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756831Ab1FFVkZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 17:40:25 -0400
Received: from hera.kernel.org ([140.211.167.34]:55112 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756131Ab1FFVkY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 17:40:24 -0400
Date: Mon, 6 Jun 2011 21:39:40 GMT
From: tip-bot for Josh Triplett <josh@joshtriplett.org>
Message-ID: <tip-2458073da04571182748aa4289630dca52ba63cc@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        torvalds@linux-foundation.org, sam@ravnborg.org, fweisbec@gmail.com,
        tglx@linutronix.de, josh@joshtriplett.org, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        sam@ravnborg.org, torvalds@linux-foundation.org, fweisbec@gmail.com,
        tglx@linutronix.de, josh@joshtriplett.org, mingo@elte.hu
In-Reply-To: <20110606165130.GA1844@leaf>
References: <20110606165130.GA1844@leaf>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/debug] debug: Make CONFIG_EXPERT select CONFIG_DEBUG_KERNEL to unhide debug options
Git-Commit-ID: 2458073da04571182748aa4289630dca52ba63cc
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 06 Jun 2011 21:39:41 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  2458073da04571182748aa4289630dca52ba63cc
Gitweb:     http://git.kernel.org/tip/2458073da04571182748aa4289630dca52ba63cc
Author:     Josh Triplett <josh@joshtriplett.org>
AuthorDate: Mon, 6 Jun 2011 09:51:30 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 6 Jun 2011 19:30:01 +0200

debug: Make CONFIG_EXPERT select CONFIG_DEBUG_KERNEL to unhide debug options

Several debugging options currently default to y, such as
CONFIG_DEBUG_BUGVERBOSE and CONFIG_DEBUG_RODATA.

Embedded users might want to turn those options off to save space;
however, turning them off requires turning on CONFIG_DEBUG_KERNEL to
unhide them.  Since CONFIG_DEBUG_KERNEL exists specifically to
unhide debugging options, and CONFIG_EXPERT exists specifically
to unhide options potentially needed by experts and/or embedded
users, make CONFIG_EXPERT automatically imply CONFIG_DEBUG_KERNEL.

Change various debugging options to only reference DEBUG_KERNEL,
not EXPERT.

Note that DEBUG_MEMORY_INIT defaulted to !EXPERT, which seemed
wrong, since EXPERT should not directly affect anything except
the availability of other options.  (And EXPERT definitely
shouldn't mean "implicitly turn off default safety features".)

Change it to default to y, which means that turning on EXPERT
does not automatically disable it, but will provide the option
to disable it.

Signed-off-by: Josh Triplett <josh@joshtriplett.org>
Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: http://lkml.kernel.org/r/20110606165130.GA1844@leaf
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
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
