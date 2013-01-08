Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756262Ab3AHXg4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 18:36:56 -0500
Received: from mail.windriver.com ([147.11.1.11]:63349 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755922Ab3AHXgx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 18:36:53 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Hector Palacios <hector.palacios@digi.com>,
        John Stultz <john.stultz@linaro.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [v2.6.34-stable 26/77] timekeeping: add arch_offset hook to ktime_get functions
Date: Tue, 8 Jan 2013 18:35:05 -0500
Message-ID: <1357688156-25387-27-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.12.1
In-Reply-To: <1357688156-25387-1-git-send-email-paul.gortmaker@windriver.com>
References: <1357688156-25387-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hector Palacios <hector.palacios@digi.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit d004e024058a0eaca097513ce62cbcf978913e0a upstream.

ktime_get and ktime_get_ts were calling timekeeping_get_ns()
but later they were not calling arch_gettimeoffset() so architectures
using this mechanism returned 0 ns when calling these functions.

This happened for example when running Busybox's ping which calls
syscall(__NR_clock_gettime, CLOCK_MONOTONIC, ts) which eventually
calls ktime_get. As a result the returned ping travel time was zero.

Signed-off-by: Hector Palacios <hector.palacios@digi.com>
Signed-off-by: John Stultz <john.stultz@linaro.org>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 kernel/time/timekeeping.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index 21cd75b..8559968 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -277,6 +277,8 @@ ktime_t ktime_get(void)
 		secs = xtime.tv_sec + wall_to_monotonic.tv_sec;
 		nsecs = xtime.tv_nsec + wall_to_monotonic.tv_nsec;
 		nsecs += timekeeping_get_ns();
+		/* If arch requires, add in gettimeoffset() */
+		nsecs += arch_gettimeoffset();
 
 	} while (read_seqretry(&xtime_lock, seq));
 	/*
@@ -308,6 +310,8 @@ void ktime_get_ts(struct timespec *ts)
 		*ts = xtime;
 		tomono = wall_to_monotonic;
 		nsecs = timekeeping_get_ns();
+		/* If arch requires, add in gettimeoffset() */
+		nsecs += arch_gettimeoffset();
 
 	} while (read_seqretry(&xtime_lock, seq));
 
-- 
1.7.12.1

