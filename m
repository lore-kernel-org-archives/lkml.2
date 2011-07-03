Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752882Ab1GCBCy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jul 2011 21:02:54 -0400
Received: from utopia.booyaka.com ([72.9.107.138]:38767 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752583Ab1GCBCx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jul 2011 21:02:53 -0400
MBOX-Line: From nobody Sat Jul  2 19:02:08 2011
Subject: [PATCH] OMAP: hwmod: add kernel cmdline flag to avoid resetting IP
	blocks during init
To: linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
From: Paul Walmsley <paul@pwsan.com>
Cc: Tony Lindgren <tony@atomide.com>, Rajendra Nayak <rnayak@ti.com>,
        =?utf-8?q?Beno=C3=AEt?= Cousson <b-cousson@ti.com>,
        Michael Buesch <mb@bu3sch.de>
Date: Sat, 02 Jul 2011 19:02:08 -0600
Message-ID: <20110703010206.19046.85293.stgit@dusk>
In-Reply-To: <20110703010204.19046.85186.stgit@dusk>
References: <20110703010204.19046.85186.stgit@dusk>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On some boards, it's not possible to reset certain IP blocks during
kernel initialization.  Some boards connect GPIO lines to external
voltage controllers, so resetting them may cause voltage to drop on a
critical supply[1].  Other boards connect GPIO lines to reset pins on
external devices without open documentation, so if the GPIO blocks are
reset, the external devices cannot currently be reconfigured[2].

The correct way to fix these issues on OMAP is to add a
hwmod_no_setup_reset(hwmod) call to the board file, that references
the IP block that must preserve its state.  This allows the OMAP core
code to reset the remaining IP blocks.

However, during initial bring-up of a new board, it may be desirable
to not reset any IP block, for ease of debugging.  This patch adds a
kernel command line parameter, 'hwmod_no_setup_reset', that prevents
the OMAP hwmod code from resetting any IP block during init.

1. Nayak, Rajendra.  _[PATCH 7/7] 4460sdp/blaze/panda: hwmod: Prevent
   gpio1 reset during hwmod init_.  1 July 2011.  E-mail to the
   linux-omap@vger.kernel.org mailing list.  Retrieved from
   http://www.mail-archive.com/linux-omap@vger.kernel.org/msg51992.html

2. Buesch, Michael.  _Nokia n810 LCD (MIPID/blizzard) on 2.6.38_.  28
   Feb 2011.  E-mail to the linux-omap@vger.kernel.org mailing list.
   Retrieved from http://www.spinics.net/lists/linux-omap/msg47277.html

Signed-off-by: Paul Walmsley <paul@pwsan.com>
Cc: Benoît Cousson <b-cousson@ti.com>
Cc: Rajendra Nayak <rnayak@ti.com>
Cc: Michael Buesch <mb@bu3sch.de>
Cc: Tony Lindgren <tony@atomide.com>
---
 Documentation/kernel-parameters.txt |    9 +++++++++
 arch/arm/mach-omap2/omap_hwmod.c    |   19 +++++++++++++++++--
 2 files changed, 26 insertions(+), 2 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index fd248a31..4b1c03f 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -75,6 +75,7 @@ parameter is applicable:
 	NET	Appropriate network support is enabled.
 	NUMA	NUMA support is enabled.
 	NFS	Appropriate NFS support is enabled.
+	OMAP	OMAP sub-architecture is enabled.
 	OSS	OSS sound support is enabled.
 	PV_OPS	A paravirtualized kernel is enabled.
 	PARIDE	The ParIDE (parallel port IDE) subsystem is enabled.
@@ -872,6 +873,14 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 			       If specified, z/VM IUCV HVC accepts connections
 			       from listed z/VM user IDs only.
 
+	hwmod_no_setup_reset
+			[OMAP] During kernel initialization,
+			prevent the subarchitecture code from resetting
+			IP blocks before the driver loads.  Useful for
+			initial bring-up of boards which require some
+			bootloader configuration to be retained on GPIO or
+			other IP blocks.
+
 	keep_bootcon	[KNL]
 			Do not unregister boot console at start. This is only
 			useful for debugging when something happens in the window
diff --git a/arch/arm/mach-omap2/omap_hwmod.c b/arch/arm/mach-omap2/omap_hwmod.c
index 293fa6c..025bf2f 100644
--- a/arch/arm/mach-omap2/omap_hwmod.c
+++ b/arch/arm/mach-omap2/omap_hwmod.c
@@ -86,7 +86,9 @@
  * completely self-reliant and independent from bootloaders.  This is
  * to ensure a repeatable configuration, both to ensure consistent
  * runtime behavior, and to make it easier for others to reproduce
- * bugs.
+ * bugs.  (This behavior can be disabled while bringing up a new board
+ * by passing the kernel command line parameter
+ * 'hwmod_no_setup_reset'.)
  *
  * OMAP module activity states
  * ---------------------------
@@ -162,6 +164,12 @@ static LIST_HEAD(omap_hwmod_list);
 /* mpu_oh: used to add/remove MPU initiator from sleepdep list */
 static struct omap_hwmod *mpu_oh;
 
+/*
+ * no_setup_reset: if true, then don't reset any hwmods on boot.  This
+ * can be changed by the 'hwmod_no_setup_reset' kernel command line
+ * parameter
+ */
+static bool no_setup_reset;
 
 /* Private functions */
 
@@ -1453,7 +1461,7 @@ static int _setup(struct omap_hwmod *oh, void *data)
 		return 0;
 	}
 
-	if (!(oh->flags & HWMOD_INIT_NO_RESET)) {
+	if (!no_setup_reset && !(oh->flags & HWMOD_INIT_NO_RESET)) {
 		_reset(oh);
 
 		/*
@@ -1542,6 +1550,13 @@ static int __init _register(struct omap_hwmod *oh)
 	return 0;
 }
 
+static int __init _cmdline_no_setup_reset(char *s)
+{
+	no_setup_reset = true;
+	return 1;
+}
+
+__setup("hwmod_no_setup_reset", _cmdline_no_setup_reset);
 
 /* Public functions */
 


