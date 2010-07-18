Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757048Ab0GRSge (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jul 2010 14:36:34 -0400
Received: from mail.pripojeni.net ([217.66.174.14]:58321 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1756994Ab0GRSgb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jul 2010 14:36:31 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: mchehab@infradead.org
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        jirislaby@gmail.com, Markus Rechberger <markus.rechberger@amd.com>
Subject: [PATCH 1/1] DVB: fix dvr node refcounting
Date: Sun, 18 Jul 2010 20:34:18 +0200
Message-Id: <1279478058-974-1-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In dvb_dvr_release, there is a test dvbdev->users==-1, but users are
never negative. This error results in hung tasks:
  task                        PC stack   pid father
bash          D ffffffffa000c948     0  3264   3170 0x00000000
 ffff88003aec5ce8 0000000000000086 0000000000011f80 0000000000011f80
 ffff88003aec5fd8 ffff88003aec5fd8 ffff88003b848670 0000000000011f80
 ffff88003aec5fd8 0000000000011f80 ffff88003e02a030 ffff88003b848670
Call Trace:
 [<ffffffff813dd4a5>] dvb_dmxdev_release+0xc5/0x130
 [<ffffffff8107b750>] ? autoremove_wake_function+0x0/0x40
 [<ffffffffa00013a2>] dvb_usb_adapter_dvb_exit+0x42/0x70 [dvb_usb]
 [<ffffffffa0000525>] dvb_usb_exit+0x55/0xd0 [dvb_usb]
 [<ffffffffa00005ee>] dvb_usb_device_exit+0x4e/0x70 [dvb_usb]
 [<ffffffffa000a065>] af9015_usb_device_exit+0x55/0x60 [dvb_usb_af9015]
 [<ffffffff813a3f05>] usb_unbind_interface+0x55/0x1a0
 [<ffffffff81316000>] __device_release_driver+0x70/0xe0
...

So check against 1 there instead.

BTW why's the TODO there? Adding TODOs to the code without
descriptions is like adding nothing.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Markus Rechberger <markus.rechberger@amd.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
---
 drivers/media/dvb/dvb-core/dmxdev.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/dvb/dvb-core/dmxdev.c b/drivers/media/dvb/dvb-core/dmxdev.c
index 425862f..0042306 100644
--- a/drivers/media/dvb/dvb-core/dmxdev.c
+++ b/drivers/media/dvb/dvb-core/dmxdev.c
@@ -207,7 +207,7 @@ static int dvb_dvr_release(struct inode *inode, struct file *file)
 	}
 	/* TODO */
 	dvbdev->users--;
-	if(dvbdev->users==-1 && dmxdev->exit==1) {
+	if (dvbdev->users == 1 && dmxdev->exit == 1) {
 		fops_put(file->f_op);
 		file->f_op = NULL;
 		mutex_unlock(&dmxdev->mutex);
-- 
1.7.1


