Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758015Ab0FIQ5h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jun 2010 12:57:37 -0400
Received: from hapkido.dreamhost.com ([66.33.216.122]:56008 "EHLO
	hapkido.dreamhost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758004Ab0FIQ5g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jun 2010 12:57:36 -0400
Subject: [PATCH] uniform cdrom: fix mutex unlocking in
 /proc/sys/dev/cdrom/info file
From: Davidlohr Bueso <dave.bueso@gmail.com>
Reply-To: dave.bueso@gmail.com
To: axboe@kernel.dk, jens.axboe@oracle.com
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 09 Jun 2010 12:56:50 -0400
Message-ID: <1276102610.5572.32.camel@cowboy>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the last if condition passes the cdrom_mutex mutex will not be unlocked. 
This patch fixes this and also removes the unnecessary doit label that was only invoked by the done label.

Thanks.


Signed-off-by: Davidlohr Bueso <dave@gnu.org>
---
 drivers/cdrom/cdrom.c |   51 +++++++++++++++++++++++++-----------------------
 1 files changed, 27 insertions(+), 24 deletions(-)

diff --git a/drivers/cdrom/cdrom.c b/drivers/cdrom/cdrom.c
index e3749d0..539b8d0 100644
--- a/drivers/cdrom/cdrom.c
+++ b/drivers/cdrom/cdrom.c
@@ -3429,70 +3429,73 @@ static int cdrom_sysctl_info(ctl_table *ctl, int write,
 	pos = sprintf(info, "CD-ROM information, " VERSION "\n");
 	
 	if (cdrom_print_info("\ndrive name:\t", 0, info, &pos, CTL_NAME))
-		goto done;
+		goto small;
 	if (cdrom_print_info("\ndrive speed:\t", 0, info, &pos, CTL_SPEED))
-		goto done;
+		goto small;
 	if (cdrom_print_info("\ndrive # of slots:", 0, info, &pos, CTL_SLOTS))
-		goto done;
+		goto small;
 	if (cdrom_print_info("\nCan close tray:\t",
 				CDC_CLOSE_TRAY, info, &pos, CTL_CAPABILITY))
-		goto done;
+		goto small;
 	if (cdrom_print_info("\nCan open tray:\t",
 				CDC_OPEN_TRAY, info, &pos, CTL_CAPABILITY))
-		goto done;
+		goto small;
 	if (cdrom_print_info("\nCan lock tray:\t",
 				CDC_LOCK, info, &pos, CTL_CAPABILITY))
-		goto done;
+		goto small;
 	if (cdrom_print_info("\nCan change speed:",
 				CDC_SELECT_SPEED, info, &pos, CTL_CAPABILITY))
-		goto done;
+		goto small;
 	if (cdrom_print_info("\nCan select disk:",
 				CDC_SELECT_DISC, info, &pos, CTL_CAPABILITY))
-		goto done;
+		goto small;
 	if (cdrom_print_info("\nCan read multisession:",
 				CDC_MULTI_SESSION, info, &pos, CTL_CAPABILITY))
-		goto done;
+		goto small;
 	if (cdrom_print_info("\nCan read MCN:\t",
 				CDC_MCN, info, &pos, CTL_CAPABILITY))
-		goto done;
+		goto small;
 	if (cdrom_print_info("\nReports media changed:",
 				CDC_MEDIA_CHANGED, info, &pos, CTL_CAPABILITY))
-		goto done;
+		goto small;
 	if (cdrom_print_info("\nCan play audio:\t",
 				CDC_PLAY_AUDIO, info, &pos, CTL_CAPABILITY))
-		goto done;
+		goto small;
 	if (cdrom_print_info("\nCan write CD-R:\t",
 				CDC_CD_R, info, &pos, CTL_CAPABILITY))
-		goto done;
+		goto small;
 	if (cdrom_print_info("\nCan write CD-RW:",
 				CDC_CD_RW, info, &pos, CTL_CAPABILITY))
-		goto done;
+		goto small;
 	if (cdrom_print_info("\nCan read DVD:\t",
 				CDC_DVD, info, &pos, CTL_CAPABILITY))
-		goto done;
+		goto small;
 	if (cdrom_print_info("\nCan write DVD-R:",
 				CDC_DVD_R, info, &pos, CTL_CAPABILITY))
-		goto done;
+		goto small;
 	if (cdrom_print_info("\nCan write DVD-RAM:",
 				CDC_DVD_RAM, info, &pos, CTL_CAPABILITY))
-		goto done;
+		goto small;
 	if (cdrom_print_info("\nCan read MRW:\t",
 				CDC_MRW, info, &pos, CTL_CAPABILITY))
-		goto done;
+		goto small;
 	if (cdrom_print_info("\nCan write MRW:\t",
 				CDC_MRW_W, info, &pos, CTL_CAPABILITY))
-		goto done;
+		goto small;
 	if (cdrom_print_info("\nCan write RAM:\t",
 				CDC_RAM, info, &pos, CTL_CAPABILITY))
-		goto done;
+		goto small;
 	if (!scnprintf(info + pos, max_size - pos, "\n\n"))
-		goto done;
-doit:
+		goto small;
+	
+	goto ret;
+
+ret:
 	mutex_unlock(&cdrom_mutex);
 	return proc_dostring(ctl, write, buffer, lenp, ppos);
-done:
+small:
 	printk(KERN_INFO "cdrom: info buffer too small\n");
-	goto doit;
+	goto ret;
 }
 
 /* Unfortunately, per device settings are not implemented through
-- 
1.7.0.4



