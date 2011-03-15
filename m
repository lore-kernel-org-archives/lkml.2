Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932264Ab1COPs1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 11:48:27 -0400
Received: from max.feld.cvut.cz ([147.32.192.36]:49760 "EHLO max.feld.cvut.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932110Ab1COPs0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 11:48:26 -0400
X-Greylist: delayed 375 seconds by postgrey-1.27 at vger.kernel.org; Tue, 15 Mar 2011 11:48:26 EDT
From: Michal Sojka <sojkam1@fel.cvut.cz>
To: linux-kernel@vger.kernel.org
Cc: Chris Frey <cdfrey@foursquare.net>, Greg Kroah-Hartman <gregkh@suse.de>,
        Michal Sojka <sojkam1@fel.cvut.cz>, stable@kernel.org
Subject: [PATCH] USB: Do not pass negative length to snoop_urb()
Date: Tue, 15 Mar 2011 16:41:47 +0100
Message-Id: <1300203707-4552-1-git-send-email-sojkam1@fel.cvut.cz>
X-Mailer: git-send-email 1.7.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When `echo Y > /sys/module/usbcore/parameters/usbfs_snoop` and
usb_control_msg() returns error, a lot of kernel memory is dumped to dmesg
until unhandled kernel paging request occurs.

Signed-off-by: Michal Sojka <sojkam1@fel.cvut.cz>
Cc: stable@kernel.org
---
 drivers/usb/core/devio.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/usb/core/devio.c b/drivers/usb/core/devio.c
index a7131ad..37518df 100644
--- a/drivers/usb/core/devio.c
+++ b/drivers/usb/core/devio.c
@@ -802,7 +802,7 @@ static int proc_control(struct dev_state *ps, void __user *arg)
 				    tbuf, ctrl.wLength, tmo);
 		usb_lock_device(dev);
 		snoop_urb(dev, NULL, pipe, max(i, 0), min(i, 0), COMPLETE,
-			tbuf, i);
+			  tbuf, max(i, 0));
 		if ((i > 0) && ctrl.wLength) {
 			if (copy_to_user(ctrl.data, tbuf, i)) {
 				free_page((unsigned long)tbuf);
-- 
1.7.2.3

