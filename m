Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758992Ab2KBVoQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 17:44:16 -0400
Received: from oproxy8-pub.bluehost.com ([69.89.22.20]:35517 "HELO
	oproxy8-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1758193Ab2KBVnr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 17:43:47 -0400
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org
Cc: rjw@sisk.pl
Subject: [PATCH 1/2] PM: make VT switching to the suspend console optional
Date: Fri,  2 Nov 2012 14:43:40 -0700
Message-Id: <1351892621-4840-2-git-send-email-jbarnes@virtuousgeek.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1351892621-4840-1-git-send-email-jbarnes@virtuousgeek.org>
References: <1351892621-4840-1-git-send-email-jbarnes@virtuousgeek.org>
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.37.189 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KMS drivers can potentially restore the display configuration without
userspace help.  Such drivers can set a new global, pm_vt_switch, to
false if they support this feature.  In that case, the PM layer won't VT
switch to the suspend console at suspend time and then back to the
original VT on resume, but rather leave things alone for a nicer looking
suspend and resume sequence.

Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>
---
 include/linux/pm.h     |    3 +++
 kernel/power/console.c |    7 +++++++
 2 files changed, 10 insertions(+)

diff --git a/include/linux/pm.h b/include/linux/pm.h
index 007e687..d8e7efb 100644
--- a/include/linux/pm.h
+++ b/include/linux/pm.h
@@ -35,6 +35,9 @@ extern void (*pm_idle)(void);
 extern void (*pm_power_off)(void);
 extern void (*pm_power_off_prepare)(void);
 
+/* VT switch to the suspend console or not */
+extern bool pm_vt_switch; /* defaults to true in console.c */
+
 /*
  * Device power management
  */
diff --git a/kernel/power/console.c b/kernel/power/console.c
index b1dc456..65376b4 100644
--- a/kernel/power/console.c
+++ b/kernel/power/console.c
@@ -13,9 +13,13 @@
 #define SUSPEND_CONSOLE	(MAX_NR_CONSOLES-1)
 
 static int orig_fgconsole, orig_kmsg;
+bool pm_vt_switch = true;
 
 int pm_prepare_console(void)
 {
+	if (!pm_vt_switch)
+		return 0;
+
 	orig_fgconsole = vt_move_to_console(SUSPEND_CONSOLE, 1);
 	if (orig_fgconsole < 0)
 		return 1;
@@ -26,6 +30,9 @@ int pm_prepare_console(void)
 
 void pm_restore_console(void)
 {
+	if (!pm_vt_switch)
+		return;
+
 	if (orig_fgconsole >= 0) {
 		vt_move_to_console(orig_fgconsole, 0);
 		vt_kmsg_redirect(orig_kmsg);
-- 
1.7.9.5

