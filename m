Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965996Ab2C3Vre (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 17:47:34 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:40131 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965968Ab2C3VUr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 17:20:47 -0400
Message-Id: <20120330194840.460418919@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 30 Mar 2012 12:49:45 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, NeilBrown <neilb@suse.de>
Subject: [ 080/175] md: dont set md arrays to readonly on shutdown.
In-Reply-To: <20120330195801.GA31806@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: NeilBrown <neilb@suse.de>

commit c744a65c1e2d59acc54333ce80a5b0702a98010b upstream.

It seems that with recent kernel, writeback can still be happening
while shutdown is happening, and consequently data can be written
after the md reboot notifier switches all arrays to read-only.
This causes a BUG.

So don't switch them to read-only - just mark them clean and
set 'safemode' to '2' which mean that immediately after any
write the array will be switch back to 'clean'.

This could result in the shutdown happening when array is marked
dirty, thus forcing a resync on reboot.  However if you reboot
without performing a "sync" first, you get to keep both halves.

This is suitable for any stable kernel (though there might be some
conflicts with obvious fixes in earlier kernels).

Signed-off-by: NeilBrown <neilb@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/md/md.c |   37 +++++++++++++++----------------------
 1 file changed, 15 insertions(+), 22 deletions(-)

--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -8157,30 +8157,23 @@ static int md_notify_reboot(struct notif
 	struct mddev *mddev;
 	int need_delay = 0;
 
-	if ((code == SYS_DOWN) || (code == SYS_HALT) || (code == SYS_POWER_OFF)) {
-
-		printk(KERN_INFO "md: stopping all md devices.\n");
-
-		for_each_mddev(mddev, tmp) {
-			if (mddev_trylock(mddev)) {
-				/* Force a switch to readonly even array
-				 * appears to still be in use.  Hence
-				 * the '100'.
-				 */
-				md_set_readonly(mddev, 100);
-				mddev_unlock(mddev);
-			}
-			need_delay = 1;
+	for_each_mddev(mddev, tmp) {
+		if (mddev_trylock(mddev)) {
+			__md_stop_writes(mddev);
+			mddev->safemode = 2;
+			mddev_unlock(mddev);
 		}
-		/*
-		 * certain more exotic SCSI devices are known to be
-		 * volatile wrt too early system reboots. While the
-		 * right place to handle this issue is the given
-		 * driver, we do want to have a safe RAID driver ...
-		 */
-		if (need_delay)
-			mdelay(1000*1);
+		need_delay = 1;
 	}
+	/*
+	 * certain more exotic SCSI devices are known to be
+	 * volatile wrt too early system reboots. While the
+	 * right place to handle this issue is the given
+	 * driver, we do want to have a safe RAID driver ...
+	 */
+	if (need_delay)
+		mdelay(1000*1);
+
 	return NOTIFY_DONE;
 }
 


