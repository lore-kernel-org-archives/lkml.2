Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756185Ab2GXRBs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2012 13:01:48 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:40776 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755798Ab2GXRBo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2012 13:01:44 -0400
From: Ming Lei <ming.lei@canonical.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Borislav Petkov <borislav.petkov@amd.com>,
        linux-kernel@vger.kernel.org, Ming Lei <ming.lei@canonical.com>
Subject: [RFC PATCH 12/13] driver core: firmware loader: use small timeout for cache device firmware
Date: Wed, 25 Jul 2012 01:00:12 +0800
Message-Id: <1343149213-10160-13-git-send-email-ming.lei@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1343149213-10160-1-git-send-email-ming.lei@canonical.com>
References: <1343149213-10160-1-git-send-email-ming.lei@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Because device_cache_firmwares only cache the firmware which has been
loaded sucessfully at leat once, using a small loading timeout should
be OK.

Signed-off-by: Ming Lei <ming.lei@canonical.com>
---
 drivers/base/firmware_class.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/base/firmware_class.c b/drivers/base/firmware_class.c
index 7a96e75..0918b26 100644
--- a/drivers/base/firmware_class.c
+++ b/drivers/base/firmware_class.c
@@ -1130,10 +1130,19 @@ static void device_cache_firmwares(void)
 {
 	struct firmware_cache *fwc = &fw_cache;
 	struct device *dev;
+	int old_timeout;
 	DEFINE_WAIT(wait);
 
 	pr_debug("%s\n", __func__);
 
+	/*
+	 * use small loading timeout for caching devces firmwares
+	 * because all these firmwares have been loaded successfully
+	 * at lease once
+	 */
+	old_timeout = loading_timeout;
+	loading_timeout = 10;
+
 	device_pm_lock();
 	list_for_each_entry(dev, &dpm_list, power.entry)
 		dev_cache_firmware(dev);
@@ -1157,6 +1166,8 @@ static void device_cache_firmwares(void)
 	}
 	spin_unlock(&fwc->name_lock);
 	finish_wait(&fwc->wait_queue, &wait);
+
+	loading_timeout = old_timeout;
 }
 
 /**
-- 
1.7.9.5

