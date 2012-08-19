Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753878Ab2HSRcL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Aug 2012 13:32:11 -0400
Received: from smtprelay.restena.lu ([158.64.1.62]:59757 "EHLO
	smtprelay.restena.lu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751692Ab2HSRcI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Aug 2012 13:32:08 -0400
Date: Sun, 19 Aug 2012 19:31:23 +0200
From: Bruno =?UTF-8?B?UHLDqW1vbnQ=?= <bonbons@linux-vserver.org>
To: Jiri Kosina <jkosina@suse.cz>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/6] HID: picoLCD: prevent NULL pointer dereferences
Message-ID: <20120819193123.4f8200a6@neptune.home>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
References: <20120819192859.74136bb0@neptune.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Driver code expects to get access to struct picolcd_data from hiddev
and is not prepared to find a NULL pointer there. Most prominent
candidate to trip on it is picolcd_fb_deferred_io().
Delay removing struct picolcd_data from hiddev until all sub-devices
have been unregistered.

Signed-off-by: Bruno Prémont <bonbons@linux-vserver.org>
---
 drivers/hid/hid-picolcd_core.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/hid/hid-picolcd_core.c b/drivers/hid/hid-picolcd_core.c
index e08ffd2..76ab173 100644
--- a/drivers/hid/hid-picolcd_core.c
+++ b/drivers/hid/hid-picolcd_core.c
@@ -631,7 +631,6 @@ static void picolcd_remove(struct hid_device *hdev)
 	device_remove_file(&hdev->dev, &dev_attr_operation_mode_delay);
 	hid_hw_close(hdev);
 	hid_hw_stop(hdev);
-	hid_set_drvdata(hdev, NULL);
 
 	/* Shortcut potential pending reply that will never arrive */
 	spin_lock_irqsave(&data->lock, flags);
@@ -649,6 +648,7 @@ static void picolcd_remove(struct hid_device *hdev)
 	picolcd_exit_cir(data);
 	picolcd_exit_keys(data);
 
+	hid_set_drvdata(hdev, NULL);
 	mutex_destroy(&data->mutex);
 	/* Finally, clean up the picolcd data itself */
 	kfree(data);
-- 
1.7.8.6

