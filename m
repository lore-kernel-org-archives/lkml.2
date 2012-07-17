Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756238Ab2GQSHl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 14:07:41 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:53291 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756184Ab2GQSHi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 14:07:38 -0400
From: John Stultz <johnstul@us.ibm.com>
To: stable@vger.kernel.org
Cc: Richard Cochran <richardcochran@gmail.com>,
        Prarit Bhargava <prarit@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        John Stultz <john.stultz@linaro.org>
Subject: [PATCH 02/11] 2.6.35.x: ntp: Correct TAI offset during leap second
Date: Tue, 17 Jul 2012 14:05:33 -0400
Message-Id: <1342548342-19683-3-git-send-email-johnstul@us.ibm.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1342548342-19683-1-git-send-email-johnstul@us.ibm.com>
References: <1342548342-19683-1-git-send-email-johnstul@us.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12071718-6148-0000-0000-000007BE3D8C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Richard Cochran <richardcochran@gmail.com>

This is a backport of dd48d708ff3e917f6d6b6c2b696c3f18c019feed

When repeating a UTC time value during a leap second (when the UTC
time should be 23:59:60), the TAI timescale should not stop. The kernel
NTP code increments the TAI offset one second too late. This patch fixes
the issue by incrementing the offset during the leap second itself.

Signed-off-by: Richard Cochran <richardcochran@gmail.com>
Cc: Prarit Bhargava <prarit@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 kernel/time/ntp.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/time/ntp.c b/kernel/time/ntp.c
index 67ef677..272e169 100644
--- a/kernel/time/ntp.c
+++ b/kernel/time/ntp.c
@@ -208,6 +208,7 @@ int second_overflow(unsigned long secs)
 		if (secs % 86400 == 0) {
 			leap = -1;
 			time_state = TIME_OOP;
+			time_tai++;
 			printk(KERN_NOTICE
 				"Clock: inserting leap second 23:59:60 UTC\n");
 		}
@@ -222,7 +223,6 @@ int second_overflow(unsigned long secs)
 		}
 		break;
 	case TIME_OOP:
-		time_tai++;
 		time_state = TIME_WAIT;
 		break;
 
-- 
1.7.9.5

