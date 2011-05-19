Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933977Ab1ESSZj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 14:25:39 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:38777 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933941Ab1ESSZg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 14:25:36 -0400
X-Sasl-enc: oJAOm4YLILJMBMjSEygDpy1/0787G95aaUGM7s1FUwCf 1305829535
X-Mailbox-Line: From gregkh@clark.kroah.org Thu May 19 11:24:36 2011
Message-Id: <20110519182436.801262289@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Thu, 19 May 2011 11:23:35 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Eric Dumazet <eric.dumazet@gmail.com>,
        John Stultz <johnstul@us.ibm.com>
Subject: [05/21] Fix time() inconsistencies caused by intermediate xtime_cache values being read
In-Reply-To: <20110519182446.GA23751@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

------------------


Currently with 2.6.32-longterm, its possible for time() to occasionally
return values one second earlier then the previous time() call.

This happens because update_xtime_cache() does:
	xtime_cache = xtime;
	timespec_add_ns(&xtime_cache, nsec);

Its possible that xtime is 1sec,999msecs, and nsecs is 1ms, resulting in
a xtime_cache that is 2sec,0ms.

get_seconds() (which is used by sys_time()) does not take the
xtime_lock, which is ok as the xtime.tv_sec value is a long and can be
atomically read safely.

The problem occurs the next call to update_xtime_cache() if xtime has
not increased:
	/* This sets xtime_cache back to 1sec, 999msec */
	xtime_cache = xtime; 
	/* get_seconds, calls here, and sees a 1second inconsistency */
	timespec_add_ns(&xtime_cache, nsec);


In order to resolve this, we could add locking to get_seconds(), but it
needs to be lock free, as it is called from the machine check handler,
opening a possible deadlock.

So instead, this patch introduces an intermediate value for the
calculations, so that we only assign xtime_cache once with the correct
time, using ACCESS_ONCE to make sure the compiler doesn't optimize out
any intermediate values.

The xtime_cache manipulations were removed with 2.6.35, so that kernel
and later do not need this change.

In 2.6.33 and 2.6.34 the logarithmic accumulation should make it so
xtime is updated each tick, so it is unlikely that two updates to
xtime_cache could occur while the difference between xtime and
xtime_cache crosses the second boundary. However, the paranoid might
want to pull this into 2.6.33/34-longterm just to be sure.

Thanks to Stephen for helping finally narrow down the root cause and
many hours of help with testing and validation. Also thanks to Max,
Andi, Eric and Paul for review of earlier attempts and helping clarify
what is possible with regard to out of order execution.

Acked-by: Eric Dumazet <eric.dumazet@gmail.com>
Signed-off-by: John Stultz <johnstul@us.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 kernel/time/timekeeping.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -168,8 +168,15 @@ int __read_mostly timekeeping_suspended;
 static struct timespec xtime_cache __attribute__ ((aligned (16)));
 void update_xtime_cache(u64 nsec)
 {
-	xtime_cache = xtime;
-	timespec_add_ns(&xtime_cache, nsec);
+	/*
+	 * Use temporary variable so get_seconds() cannot catch
+	 * an intermediate xtime_cache.tv_sec value.
+	 * The ACCESS_ONCE() keeps the compiler from optimizing
+	 * out the intermediate value.
+	 */
+	struct timespec ts = xtime;
+	timespec_add_ns(&ts, nsec);
+	ACCESS_ONCE(xtime_cache) = ts;
 }
 
 /* must hold xtime_lock */


