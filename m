Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751544Ab0CSPSj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Mar 2010 11:18:39 -0400
Received: from kroah.org ([198.145.64.141]:45856 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751052Ab0CSPSi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Mar 2010 11:18:38 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Ari Entlich <atrigent@ccs.neu.edu>,
       Alan Cox <alan@linux.intel.com>
Subject: [PATCH 1/7] Revert "tty: Add a new VT mode which is like VT_PROCESS but doesn't require a VT_RELDISP ioctl call"
Date: Fri, 19 Mar 2010 08:18:30 -0700
Message-Id: <1269011916-8836-1-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.0.2
In-Reply-To: <20100319151326.GC8541@kroah.com>
References: <20100319151326.GC8541@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This reverts commit eec9fe7d1ab4a0dfac4cb43047a7657fffd0002f.

Ari writes as the reason this should be reverted:
	The problems with this patch include:
	1. There's at least one subtlety I overlooked - switching
	between X servers (i.e. from one X VT to another) still requires
	the cooperation of both X servers. I was assuming that KMS
	eliminated this.
	2. It hasn't been tested at all (no X server patch exists which
	uses the new mode).

As he was the original author of the patch, I'll revert it.

Cc: Ari Entlich <atrigent@ccs.neu.edu>
Cc: Alan Cox <alan@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/char/vt_ioctl.c |   39 +++++++++++++++++++--------------------
 include/linux/vt.h      |    3 +--
 2 files changed, 20 insertions(+), 22 deletions(-)

diff --git a/drivers/char/vt_ioctl.c b/drivers/char/vt_ioctl.c
index 87778dc..6aa1028 100644
--- a/drivers/char/vt_ioctl.c
+++ b/drivers/char/vt_ioctl.c
@@ -888,7 +888,7 @@ int vt_ioctl(struct tty_struct *tty, struct file * file,
 			ret = -EFAULT;
 			goto out;
 		}
-		if (tmp.mode != VT_AUTO && tmp.mode != VT_PROCESS && tmp.mode != VT_PROCESS_AUTO) {
+		if (tmp.mode != VT_AUTO && tmp.mode != VT_PROCESS) {
 			ret = -EINVAL;
 			goto out;
 		}
@@ -1622,7 +1622,7 @@ static void complete_change_console(struct vc_data *vc)
 	 * telling it that it has acquired. Also check if it has died and
 	 * clean up (similar to logic employed in change_console())
 	 */
-	if (vc->vt_mode.mode == VT_PROCESS || vc->vt_mode.mode == VT_PROCESS_AUTO) {
+	if (vc->vt_mode.mode == VT_PROCESS) {
 		/*
 		 * Send the signal as privileged - kill_pid() will
 		 * tell us if the process has gone or something else
@@ -1682,7 +1682,7 @@ void change_console(struct vc_data *new_vc)
 	 * vt to auto control.
 	 */
 	vc = vc_cons[fg_console].d;
-	if (vc->vt_mode.mode == VT_PROCESS || vc->vt_mode.mode == VT_PROCESS_AUTO) {
+	if (vc->vt_mode.mode == VT_PROCESS) {
 		/*
 		 * Send the signal as privileged - kill_pid() will
 		 * tell us if the process has gone or something else
@@ -1693,28 +1693,27 @@ void change_console(struct vc_data *new_vc)
 		 */
 		vc->vt_newvt = new_vc->vc_num;
 		if (kill_pid(vc->vt_pid, vc->vt_mode.relsig, 1) == 0) {
-			if(vc->vt_mode.mode == VT_PROCESS)
-				/*
-				 * It worked. Mark the vt to switch to and
-				 * return. The process needs to send us a
-				 * VT_RELDISP ioctl to complete the switch.
-				 */
-				return;
-		} else {
 			/*
-			 * The controlling process has died, so we revert back to
-			 * normal operation. In this case, we'll also change back
-			 * to KD_TEXT mode. I'm not sure if this is strictly correct
-			 * but it saves the agony when the X server dies and the screen
-			 * remains blanked due to KD_GRAPHICS! It would be nice to do
-			 * this outside of VT_PROCESS but there is no single process
-			 * to account for and tracking tty count may be undesirable.
+			 * It worked. Mark the vt to switch to and
+			 * return. The process needs to send us a
+			 * VT_RELDISP ioctl to complete the switch.
 			 */
-			reset_vc(vc);
+			return;
 		}
 
 		/*
-		 * Fall through to normal (VT_AUTO and VT_PROCESS_AUTO) handling of the switch...
+		 * The controlling process has died, so we revert back to
+		 * normal operation. In this case, we'll also change back
+		 * to KD_TEXT mode. I'm not sure if this is strictly correct
+		 * but it saves the agony when the X server dies and the screen
+		 * remains blanked due to KD_GRAPHICS! It would be nice to do
+		 * this outside of VT_PROCESS but there is no single process
+		 * to account for and tracking tty count may be undesirable.
+		 */
+		reset_vc(vc);
+
+		/*
+		 * Fall through to normal (VT_AUTO) handling of the switch...
 		 */
 	}
 
diff --git a/include/linux/vt.h b/include/linux/vt.h
index 778b7b2..d5dd0bc 100644
--- a/include/linux/vt.h
+++ b/include/linux/vt.h
@@ -27,7 +27,7 @@ struct vt_mode {
 #define VT_SETMODE	0x5602	/* set mode of active vt */
 #define		VT_AUTO		0x00	/* auto vt switching */
 #define		VT_PROCESS	0x01	/* process controls switching */
-#define		VT_PROCESS_AUTO 0x02	/* process is notified of switching */
+#define		VT_ACKACQ	0x02	/* acknowledge switch */
 
 struct vt_stat {
 	unsigned short v_active;	/* active vt */
@@ -38,7 +38,6 @@ struct vt_stat {
 #define VT_SENDSIG	0x5604	/* signal to send to bitmask of vts */
 
 #define VT_RELDISP	0x5605	/* release display */
-#define		VT_ACKACQ	0x02	/* acknowledge switch */
 
 #define VT_ACTIVATE	0x5606	/* make vt active */
 #define VT_WAITACTIVE	0x5607	/* wait for vt active */
-- 
1.7.0.2

