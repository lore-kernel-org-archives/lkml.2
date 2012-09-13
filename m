Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754765Ab2IMBjz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 21:39:55 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:38682 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751764Ab2IMBjx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 21:39:53 -0400
Message-ID: <1347500387.7434.3.camel@phoenix>
Subject: [PATCH 2/2] HID: hid-sensor-hub: Fix sensor_hub_probe error handling
From: Axel Lin <axel.lin@gmail.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: srinivas pandruvada <srinivas.pandruvada@intel.com>,
        Jonathan Cameron <jic23@kernel.org>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Thu, 13 Sep 2012 09:39:47 +0800
In-Reply-To: <1347500288.7434.1.camel@phoenix>
References: <1347500288.7434.1.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix below issues in sensor_hub_probe error handling:
1. In the case of goto err_close, hid_hw_stop(hdev) is called twice. Fix it.
2. If fails to allocate MFD device name, we also need to free all
   successfully allocated names in previous iterations.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/hid/hid-sensor-hub.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/hid/hid-sensor-hub.c b/drivers/hid/hid-sensor-hub.c
index 50bc8c7..8bd7620 100644
--- a/drivers/hid/hid-sensor-hub.c
+++ b/drivers/hid/hid-sensor-hub.c
@@ -584,7 +584,7 @@ static int sensor_hub_probe(struct hid_device *hdev,
 				hid_err(hdev,
 					"Failed MFD device name\n");
 					ret = -ENOMEM;
-					goto err_free_cells;
+					goto err_free_names;
 			}
 			sd->hid_sensor_hub_client_devs[
 				sd->hid_sensor_client_cnt].name = name;
@@ -608,10 +608,8 @@ static int sensor_hub_probe(struct hid_device *hdev,
 err_free_names:
 	for (i = 0; i < sd->hid_sensor_client_cnt ; ++i)
 		kfree(sd->hid_sensor_hub_client_devs[i].name);
-err_free_cells:
 	kfree(sd->hid_sensor_hub_client_devs);
 err_close:
-	hid_hw_stop(hdev);
 	hid_hw_close(hdev);
 err_stop_hw:
 	hid_hw_stop(hdev);
-- 
1.7.9.5



