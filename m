Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932716Ab0GAUxM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 16:53:12 -0400
Received: from kroah.org ([198.145.64.141]:47831 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932819Ab0GAUvJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 16:51:09 -0400
X-Mailbox-Line: From gregkh@clark.site Thu Jul  1 10:34:37 2010
Message-Id: <20100701173437.339606380@clark.site>
User-Agent: quilt/0.48-10.1
Date: Thu, 01 Jul 2010 10:35:11 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>
Subject: [patch 125/164] perf: Fix signed comparison in perf_adjust_period()
In-Reply-To: <20100701175152.GA2135@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Zijlstra <a.p.zijlstra@chello.nl>

commit f6ab91add6355e231e1c47897027b2a6ee4fa268 upstream.

Frederic reported that frequency driven swevents didn't work properly
and even caused a division-by-zero error.

It turns out there are two bugs, the division-by-zero comes from a
failure to deal with that in perf_calculate_period().

The other was more interesting and turned out to be a wrong comparison
in perf_adjust_period(). The comparison was between an s64 and u64 and
got implicitly converted to an unsigned comparison. The problem is
that period_left is typically < 0, so it ended up being always true.

Cure this by making the local period variables s64.

Reported-by: Frederic Weisbecker <fweisbec@gmail.com>
Tested-by: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 kernel/perf_event.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -1417,13 +1417,16 @@ do {					\
 		divisor = nsec * frequency;
 	}
 
+	if (!divisor)
+		return dividend;
+
 	return div64_u64(dividend, divisor);
 }
 
 static void perf_adjust_period(struct perf_event *event, u64 nsec, u64 count)
 {
 	struct hw_perf_event *hwc = &event->hw;
-	u64 period, sample_period;
+	s64 period, sample_period;
 	s64 delta;
 
 	period = perf_calculate_period(event, nsec, count);


