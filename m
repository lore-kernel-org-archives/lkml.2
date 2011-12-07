Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757325Ab1LGQSa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 11:18:30 -0500
Received: from cantor2.suse.de ([195.135.220.15]:33236 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756839Ab1LGQS0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 11:18:26 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Dec  7 08:08:24 2011
Message-Id: <20111207160824.879156691@clark.kroah.org>
User-Agent: quilt/0.50-23.1
Date: Wed, 07 Dec 2011 08:06:47 -0800
From: Greg KH <gregkh@suse.de>
To: <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>
Cc: <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <alan@lxorguk.ukuu.org.uk>, Hector Palacios <hector.palacios@digi.com>,
        John Stultz <john.stultz@linaro.org>
Subject: [27/80] timekeeping: add arch_offset hook to ktime_get functions
In-Reply-To: <20111207161256.GA7736@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hector Palacios <hector.palacios@digi.com>

commit d004e024058a0eaca097513ce62cbcf978913e0a upstream.

ktime_get and ktime_get_ts were calling timekeeping_get_ns()
but later they were not calling arch_gettimeoffset() so architectures
using this mechanism returned 0 ns when calling these functions.

This happened for example when running Busybox's ping which calls
syscall(__NR_clock_gettime, CLOCK_MONOTONIC, ts) which eventually
calls ktime_get. As a result the returned ping travel time was zero.

Signed-off-by: Hector Palacios <hector.palacios@digi.com>
Signed-off-by: John Stultz <john.stultz@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 kernel/time/timekeeping.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -249,6 +249,8 @@ ktime_t ktime_get(void)
 		secs = xtime.tv_sec + wall_to_monotonic.tv_sec;
 		nsecs = xtime.tv_nsec + wall_to_monotonic.tv_nsec;
 		nsecs += timekeeping_get_ns();
+		/* If arch requires, add in gettimeoffset() */
+		nsecs += arch_gettimeoffset();
 
 	} while (read_seqretry(&xtime_lock, seq));
 	/*
@@ -280,6 +282,8 @@ void ktime_get_ts(struct timespec *ts)
 		*ts = xtime;
 		tomono = wall_to_monotonic;
 		nsecs = timekeeping_get_ns();
+		/* If arch requires, add in gettimeoffset() */
+		nsecs += arch_gettimeoffset();
 
 	} while (read_seqretry(&xtime_lock, seq));
 


