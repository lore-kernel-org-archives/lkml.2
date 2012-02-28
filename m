Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965545Ab2B1BTg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 20:19:36 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:40933 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965517Ab2B1BTb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 20:19:31 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of gregkh@linuxfoundation.org designates 10.68.216.42 as permitted sender) smtp.mail=gregkh@linuxfoundation.org
MIME-Version: 1.0
Message-Id: <20120228010430.299312499@linuxfoundation.org>
User-Agent: quilt/0.51-17.1
Date: Mon, 27 Feb 2012 17:04:39 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [ 10/72] S390: correct ktime to tod clock comparator conversion
In-Reply-To: <20120228010511.GA8453@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Martin Schwidefsky <schwidefsky@de.ibm.com>

commit cf1eb40f8f5ea12c9e569e7282161fc7f194fd62 upstream.

The conversion of the ktime to a value suitable for the clock comparator
does not take changes to wall_to_monotonic into account. In fact the
conversion just needs the boot clock (sched_clock_base_cc) and the
total_sleep_time.

This is applicable to 3.2+ kernels.

Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/s390/kernel/time.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/arch/s390/kernel/time.c
+++ b/arch/s390/kernel/time.c
@@ -113,11 +113,14 @@ static void fixup_clock_comparator(unsig
 static int s390_next_ktime(ktime_t expires,
 			   struct clock_event_device *evt)
 {
+	struct timespec ts;
 	u64 nsecs;
 
-	nsecs = ktime_to_ns(ktime_sub(expires, ktime_get_monotonic_offset()));
+	ts.tv_sec = ts.tv_nsec = 0;
+	monotonic_to_bootbased(&ts);
+	nsecs = ktime_to_ns(ktime_add(timespec_to_ktime(ts), expires));
 	do_div(nsecs, 125);
-	S390_lowcore.clock_comparator = TOD_UNIX_EPOCH + (nsecs << 9);
+	S390_lowcore.clock_comparator = sched_clock_base_cc + (nsecs << 9);
 	set_clock_comparator(S390_lowcore.clock_comparator);
 	return 0;
 }


