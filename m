Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752599Ab1KNBYG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Nov 2011 20:24:06 -0500
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:18374 "EHLO
	TX2EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751071Ab1KNBYF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Nov 2011 20:24:05 -0500
X-SpamScore: 0
X-BigFish: VS0(zzzz1202hzz8275bhz2dh2a8h668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPVD:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
From: Peter Chen <peter.chen@freescale.com>
To: <gregkh@suse.de>, <linux-kernel@vger.kernel.org>
CC: <linux-pm@vger.kernel.org>, <rjw@sisk.pl>, <stern@rowland.harvard.edu>,
        <hzpeterchen@gmail.com>
Subject: [PATCH 1/1] driver core: disable device's runtime pm during shutdown
Date: Mon, 14 Nov 2011 08:43:00 +0800
Message-ID: <1321231380-11631-1-git-send-email-peter.chen@freescale.com>
X-Mailer: git-send-email 1.7.1
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There may be an issue when the user issue "reboot/shutdown" command, then
the device has shut down its hardware, after that, this runtime-pm featured
device's driver will probably be scheduled to do its suspend routine,
and at its suspend routine, it may access hardware, but the device has
already shutdown physically, then the system hang may be occurred.

I ran out this issue using an auto-suspend supported USB devices, like
3G modem, keyboard. The usb runtime suspend routine may be scheduled
after the usb controller has been shut down, and the usb runtime suspend
routine will try to suspend its roothub(controller), it will access
register, then the system hang occurs as the controller is shutdown.
Signed-off-by: Peter Chen <peter.chen@freescale.com>
---
 drivers/base/core.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/base/core.c b/drivers/base/core.c
index bc8729d..78445f4 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -22,6 +22,7 @@
 #include <linux/kallsyms.h>
 #include <linux/mutex.h>
 #include <linux/async.h>
+#include <linux/pm_runtime.h>
 
 #include "base.h"
 #include "power/power.h"
@@ -1742,6 +1743,8 @@ void device_shutdown(void)
 		 */
 		list_del_init(&dev->kobj.entry);
 		spin_unlock(&devices_kset->list_lock);
+		/* Disable all device's runtime power management */
+		pm_runtime_disable(dev);
 
 		if (dev->bus && dev->bus->shutdown) {
 			dev_dbg(dev, "shutdown\n");
-- 
1.7.1


