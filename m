Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756049Ab1EDV6V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 17:58:21 -0400
Received: from smtp-out.google.com ([74.125.121.67]:26108 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755965Ab1EDV6R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 17:58:17 -0400
From: Colin Cross <ccross@android.com>
To: linux-arm-kernel@lists.infradead.org
Cc: Colin Cross <ccross@android.com>, Tony Lindgren <tony@atomide.com>,
        Russell King <linux@arm.linux.org.uk>, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] ARM: omap4: Pass core and wakeup mux tables to omap4_mux_init
Date: Wed,  4 May 2011 14:57:57 -0700
Message-Id: <1304546278-28965-1-git-send-email-ccross@android.com>
X-Mailer: git-send-email 1.7.4.1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

OMAP4 contains two separate instances of the padconf registers,
one in the core system config and one in the wakeup system config.
Pass in two tables to apply the correct values to each instance.

Signed-off-by: Colin Cross <ccross@android.com>
---
 arch/arm/mach-omap2/board-4430sdp.c    |    2 +-
 arch/arm/mach-omap2/board-omap4panda.c |    2 +-
 arch/arm/mach-omap2/mux.h              |    6 ++++--
 arch/arm/mach-omap2/mux44xx.c          |    5 +++--
 4 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/arch/arm/mach-omap2/board-4430sdp.c b/arch/arm/mach-omap2/board-4430sdp.c
index 56702c5..41c109a 100644
--- a/arch/arm/mach-omap2/board-4430sdp.c
+++ b/arch/arm/mach-omap2/board-4430sdp.c
@@ -784,7 +784,7 @@ static void __init omap_4430sdp_init(void)
 
 	if (omap_rev() == OMAP4430_REV_ES1_0)
 		package = OMAP_PACKAGE_CBL;
-	omap4_mux_init(board_mux, package);
+	omap4_mux_init(board_mux, NULL, package);
 
 	omap_board_config = sdp4430_config;
 	omap_board_config_size = ARRAY_SIZE(sdp4430_config);
diff --git a/arch/arm/mach-omap2/board-omap4panda.c b/arch/arm/mach-omap2/board-omap4panda.c
index f3a7b10..f70850e 100644
--- a/arch/arm/mach-omap2/board-omap4panda.c
+++ b/arch/arm/mach-omap2/board-omap4panda.c
@@ -720,7 +720,7 @@ static void __init omap4_panda_init(void)
 
 	if (omap_rev() == OMAP4430_REV_ES1_0)
 		package = OMAP_PACKAGE_CBL;
-	omap4_mux_init(board_mux, package);
+	omap4_mux_init(board_mux, NULL, package);
 
 	if (wl12xx_set_platform_data(&omap_panda_wlan_data))
 		pr_err("error setting wl12xx data\n");
diff --git a/arch/arm/mach-omap2/mux.h b/arch/arm/mach-omap2/mux.h
index 137f321..2132308 100644
--- a/arch/arm/mach-omap2/mux.h
+++ b/arch/arm/mach-omap2/mux.h
@@ -323,10 +323,12 @@ int omap3_mux_init(struct omap_board_mux *board_mux, int flags);
 
 /**
  * omap4_mux_init() - initialize mux system with board specific set
- * @board_mux:		Board specific mux table
+ * @board_subset:	Board specific mux table
+ * @board_wkup_subset:	Board specific mux table for wakeup instance
  * @flags:		OMAP package type used for the board
  */
-int omap4_mux_init(struct omap_board_mux *board_mux, int flags);
+int omap4_mux_init(struct omap_board_mux *board_subset,
+	struct omap_board_mux *board_wkup_subset, int flags);
 
 /**
  * omap_mux_init - private mux init function, do not call
diff --git a/arch/arm/mach-omap2/mux44xx.c b/arch/arm/mach-omap2/mux44xx.c
index 9a66445..f5a74da 100644
--- a/arch/arm/mach-omap2/mux44xx.c
+++ b/arch/arm/mach-omap2/mux44xx.c
@@ -1309,7 +1309,8 @@ static struct omap_ball __initdata omap4_wkup_cbl_cbs_ball[] = {
 #define omap4_wkup_cbl_cbs_ball  NULL
 #endif
 
-int __init omap4_mux_init(struct omap_board_mux *board_subset, int flags)
+int __init omap4_mux_init(struct omap_board_mux *board_subset,
+	struct omap_board_mux *board_wkup_subset, int flags)
 {
 	struct omap_ball *package_balls_core;
 	struct omap_ball *package_balls_wkup = omap4_wkup_cbl_cbs_ball;
@@ -1347,7 +1348,7 @@ int __init omap4_mux_init(struct omap_board_mux *board_subset, int flags)
 			    OMAP_MUX_GPIO_IN_MODE3,
 			    OMAP4_CTRL_MODULE_PAD_WKUP_MUX_PBASE,
 			    OMAP4_CTRL_MODULE_PAD_WKUP_MUX_SIZE,
-			    omap4_wkup_muxmodes, NULL, board_subset,
+			    omap4_wkup_muxmodes, NULL, board_wkup_subset,
 			    package_balls_wkup);
 
 	return ret;
-- 
1.7.4.1

