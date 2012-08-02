Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753001Ab2HBXxp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2012 19:53:45 -0400
Received: from mail-wi0-f202.google.com ([209.85.212.202]:65529 "EHLO
	mail-wi0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751296Ab2HBXxh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2012 19:53:37 -0400
From: Vincent Palatin <vpalatin@chromium.org>
To: rtc-linux@googlegroups.com
Cc: Alessandro Zummo <a.zummo@towertech.it>, linux-kernel@vger.kernel.org,
        Vincent Palatin <vpalatin@chromium.org>
Subject: [PATCH] rtc: recycle id when unloading a rtc driver
Date: Thu,  2 Aug 2012 16:53:25 -0700
Message-Id: <1343951605-25722-1-git-send-email-vpalatin@chromium.org>
X-Mailer: git-send-email 1.7.7.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When calling rtc_device_unregister, we are not freeing the id used by the
driver.
So when doing a unload/load cycle for a RTC driver (e.g. rmmod rtc_cmos
&& modprobe rtc_cmos), its id is incremented by one. As a consequence,
we no longer have neither an rtc0 driver nor a /proc/driver/rtc (as it
only exists for the first driver).

Signed-off-by: Vincent Palatin <vpalatin@chromium.org>
---
 drivers/rtc/class.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/rtc/class.c b/drivers/rtc/class.c
index dc4c274..37b1d82 100644
--- a/drivers/rtc/class.c
+++ b/drivers/rtc/class.c
@@ -238,6 +238,7 @@ void rtc_device_unregister(struct rtc_device *rtc)
 		rtc_proc_del_device(rtc);
 		device_unregister(&rtc->dev);
 		rtc->ops = NULL;
+		ida_simple_remove(&rtc_ida, rtc->id);
 		mutex_unlock(&rtc->ops_lock);
 		put_device(&rtc->dev);
 	}
-- 
1.7.7.3

