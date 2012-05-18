Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946123Ab2EROLl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 10:11:41 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:49542 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031204Ab2EROKO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 10:10:14 -0400
From: Richard Cochran <richardcochran@gmail.com>
To: <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>, Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH RFC V2 3/6] time: keep track of the pending utc/tai threshold
Date: Fri, 18 May 2012 16:09:55 +0200
Message-Id: <6777ac8ebc321c67d13fdb8d0a3d826332b60f1f.1337348892.git.richardcochran@gmail.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <cover.1337348892.git.richardcochran@gmail.com>
References: <cover.1337348892.git.richardcochran@gmail.com>
In-Reply-To: <cover.1337348892.git.richardcochran@gmail.com>
References: <cover.1337348892.git.richardcochran@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch introduces time keeping variables to track the next
mini-epoch between the UTC and TAI timescales. A leap second occurs
one second before a mini-epoch. When no leap second is pending, then
the epoch is set to the far future, LONG_MAX.

This code will become useful later on for providing correct time
surrounding a leap second.

Signed-off-by: Richard Cochran <richardcochran@gmail.com>
---
 kernel/time/timekeeping.c |   14 ++++++++++++++
 1 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index d66b213..ac04de4 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -70,6 +70,19 @@ struct timekeeper {
 	/* The raw monotonic time for the CLOCK_MONOTONIC_RAW posix clock. */
 	struct timespec raw_time;
 
+	/* The current TAI - UTC offset */
+	time_t tai_offset;
+	/* The UTC time of the next leap second epoch */
+	time_t utc_epoch;
+	/* Tracks where we stand with regard to leap the second epoch. */
+	enum {
+		LEAP_IDLE,
+		LEAP_INS_PENDING,
+		LEAP_INS_DONE,
+		LEAP_DEL_PENDING,
+		LEAP_DEL_DONE,
+	} leap_state;
+
 	/* Seqlock for all timekeeper values */
 	seqlock_t lock;
 };
@@ -608,6 +621,7 @@ void __init timekeeping_init(void)
 				-boot.tv_sec, -boot.tv_nsec);
 	timekeeper.total_sleep_time.tv_sec = 0;
 	timekeeper.total_sleep_time.tv_nsec = 0;
+	timekeeper.utc_epoch = LONG_MAX;
 	write_sequnlock_irqrestore(&timekeeper.lock, flags);
 }
 
-- 
1.7.2.5

