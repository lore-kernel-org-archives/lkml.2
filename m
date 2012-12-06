Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932648Ab2LFOFe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 09:05:34 -0500
Received: from mx1.redhat.com ([209.132.183.28]:13220 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932126Ab2LFOFd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 09:05:33 -0500
Date: Thu, 6 Dec 2012 22:03:34 +0800
From: Dong Zhu <bluezhudong@gmail.com>
To: John Stultz <john.stultz@linaro.org>, Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] timekeeping: avoid adjust kernel time once hwclock kept in
 UTC time
Message-ID: <20121206140334.GA24261@zhudong.nay.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From c126376cf1837b0956e0268056db61870fbbc1d4 Mon Sep 17 00:00:00 2001
From: Dong Zhu <bluezhudong@gmail.com>
Date: Thu, 6 Dec 2012 21:45:00 +0800
Subject: [PATCH] timekeeping: avoid adjust kernel time once hwclock kept in
 UTC time

If the Hardware Clock kept in local time,kernel will adjust the time
to be UTC time.But if Hardware Clock kept in UTC time,system will make
a dummy settimeofday call first (sys_tz.tz_minuteswest = 0) to make sure
the time is not shifted,so at this point I think maybe it is not necessary
to set the kernel time once the sys_tz.tz_minuteswest is zero.

Signed-off-by: Dong Zhu <bluezhudong@gmail.com>
---
 kernel/time.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/kernel/time.c b/kernel/time.c
index d226c6a..0b592ce 100644
--- a/kernel/time.c
+++ b/kernel/time.c
@@ -134,9 +134,11 @@ static inline void warp_clock(void)
 {
 	struct timespec adjust;
 
-	adjust = current_kernel_time();
-	adjust.tv_sec += sys_tz.tz_minuteswest * 60;
-	do_settimeofday(&adjust);
+	if (sys_tz.tz_minuteswest) {
+		adjust = current_kernel_time();
+		adjust.tv_sec += sys_tz.tz_minuteswest * 60;
+		do_settimeofday(&adjust);
+	}
 }
 
 /*
-- 
1.7.11.7


-- 
Best Regards,
Dong Zhu
