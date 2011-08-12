Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751201Ab1HLVFG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Aug 2011 17:05:06 -0400
Received: from smtp-out.google.com ([74.125.121.67]:17490 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750820Ab1HLVFD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Aug 2011 17:05:03 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:date:message-id:x-mailer;
	b=GFeklVckUuMyjahC03xfxP5Nmo6zX09/eGBLR4hpiCo5TsR5W11aFRrnkja4A4N73
	ZD5CqSjeDrUahViBaTFqg==
From: Mike Waychison <mikew@google.com>
To: Alessandro Zummo <a.zummo@towertech.it>
Cc: rtc-linux@googlegroups.com, linux-kernel@vger.kernel.org,
        Mike Waychison <mikew@google.com>
Subject: [PATCH] rtc: Initialized rtc_time->tm_isdst
Date: Fri, 12 Aug 2011 14:04:30 -0700
Message-Id: <1313183070-16724-1-git-send-email-mikew@google.com>
X-Mailer: git-send-email 1.7.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Even though the Linux kernel does not use the tm_isdst field, it is
exposed as part of the ABI.  This field can accidentally be left
initialized, which is why we currently memset buffers returned to
userland in rtc_read_time.

There is a case however where the field can return garbage from the
stack though when using the RTC_ALM_READ ioctl on the rtc device.  This
ioctl invokes rtc_read_alarm, which is careful to memset the rtc_wkalrm
buffer that is copied to userland, but it then uses a struct copy to
assign to alarm->time given the return value from rtc_ktime_to_tm().

rtc_ktime_to_tm() is implemented by calling rtc_time_to_tm using a
derivative seconds counds from ktime, but rtc_time_to_tm does not assign
a value to ->tm_isdst.  This results in garbage from rtc_ktime_to_tm()'s
frame ending up being copied out to userland as part of the returned
rtc_wkalrm.

Fix this by initializing rtc_time->tm_isdst to 0 in rtc_time_to_tm.

Signed-off-by: Mike Waychison <mikew@google.com>
---
 drivers/rtc/rtc-lib.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/rtc/rtc-lib.c b/drivers/rtc/rtc-lib.c
index 075f170..c4cf057 100644
--- a/drivers/rtc/rtc-lib.c
+++ b/drivers/rtc/rtc-lib.c
@@ -85,6 +85,8 @@ void rtc_time_to_tm(unsigned long time, struct rtc_time *tm)
 	time -= tm->tm_hour * 3600;
 	tm->tm_min = time / 60;
 	tm->tm_sec = time - tm->tm_min * 60;
+
+	tm->tm_isdst = 0;
 }
 EXPORT_SYMBOL(rtc_time_to_tm);
 
-- 
1.7.3.1

