Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754397Ab2IMBiU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 21:38:20 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:41045 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752091Ab2IMBiS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 21:38:18 -0400
Message-ID: <1347500288.7434.1.camel@phoenix>
Subject: [PATCH 1/2] HID: hid-sensor-hub: Clear HID_CLAIMED_INPUT bit earlier
From: Axel Lin <axel.lin@gmail.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: srinivas pandruvada <srinivas.pandruvada@intel.com>,
        Jonathan Cameron <jic23@kernel.org>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Thu, 13 Sep 2012 09:38:08 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Clear HID_CLAIMED_INPUT bit of hdev->claimed, this prevents calling
hidinput_disconnect() in hid_disconnect(), which is called by hid_hw_stop().

We need to clear HID_CLAIMED_INPUT bit earlier rather than in
sensor_hub_remove() because we also call hid_hw_stop() in sensor_hub_probe
error handling.

Also adds comments for why we set hdev->claimed = HID_CLAIMED_INPUT.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
Hi srinivas,
I don't have this hardware, I'd appreciate if you can test these patches.
Axel

 drivers/hid/hid-sensor-hub.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/hid/hid-sensor-hub.c b/drivers/hid/hid-sensor-hub.c
index 4ac759c..50bc8c7 100644
--- a/drivers/hid/hid-sensor-hub.c
+++ b/drivers/hid/hid-sensor-hub.c
@@ -539,8 +539,11 @@ static int sensor_hub_probe(struct hid_device *hdev,
 	}
 	INIT_LIST_HEAD(&hdev->inputs);
 
+	/* We don't use hidinput but hid_hw_start() fails if nothing is
+	 * claimed. So spoof claimed input. */
 	hdev->claimed = HID_CLAIMED_INPUT;
 	ret = hid_hw_start(hdev, 0);
+	hdev->claimed &= ~HID_CLAIMED_INPUT;
 	if (ret) {
 		hid_err(hdev, "hw start failed\n");
 		goto err_free;
@@ -627,7 +630,6 @@ static void sensor_hub_remove(struct hid_device *hdev)
 	int i;
 
 	hid_dbg(hdev, " hardware removed\n");
-	hdev->claimed &= ~HID_CLAIMED_INPUT;
 	hid_hw_stop(hdev);
 	hid_hw_close(hdev);
 	spin_lock_irqsave(&data->lock, flags);
-- 
1.7.9.5



