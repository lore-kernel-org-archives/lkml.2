Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753193Ab1BBAoB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 19:44:01 -0500
Received: from mga01.intel.com ([192.55.52.88]:7970 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753175Ab1BBAn7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 19:43:59 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,412,1291622400"; 
   d="scan'208";a="883418080"
From: Andi Kleen <andi@firstfloor.org>
References: <20110201443.618138584@firstfloor.org>
In-Reply-To: <20110201443.618138584@firstfloor.org>
To: eric.dumazet@gmail.com, davem@davemloft.net, gregkh@suse.de,
        ak@linux.intel.com, linux-kernel@vger.kernel.org, stable@kernel.org
Subject: [PATCH] [53/139] af_unix: limit unix_tot_inflight
Message-Id: <20110202004409.4E70E3E09BD@tassilo.jf.intel.com>
Date: Tue,  1 Feb 2011 16:44:09 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <eric.dumazet@gmail.com>

[ Upstream commit 9915672d41273f5b77f1b3c29b391ffb7732b84b ]

Vegard Nossum found a unix socket OOM was possible, posting an exploit
program.

My analysis is we can eat all LOWMEM memory before unix_gc() being
called from unix_release_sock(). Moreover, the thread blocked in
unix_gc() can consume huge amount of time to perform cleanup because of
huge working set.

One way to handle this is to have a sensible limit on unix_tot_inflight,
tested from wait_for_unix_gc() and to force a call to unix_gc() if this
limit is hit.

This solves the OOM and also reduce overall latencies, and should not
slowdown normal workloads.

Reported-by: Vegard Nossum <vegard.nossum@gmail.com>
Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 net/unix/garbage.c |    7 +++++++
 1 file changed, 7 insertions(+)

Index: linux-2.6.35.y/net/unix/garbage.c
===================================================================
--- linux-2.6.35.y.orig/net/unix/garbage.c
+++ linux-2.6.35.y/net/unix/garbage.c
@@ -259,9 +259,16 @@ static void inc_inflight_move_tail(struc
 }
 
 static bool gc_in_progress = false;
+#define UNIX_INFLIGHT_TRIGGER_GC 16000
 
 void wait_for_unix_gc(void)
 {
+	/*
+	 * If number of inflight sockets is insane,
+	 * force a garbage collect right now.
+	 */
+	if (unix_tot_inflight > UNIX_INFLIGHT_TRIGGER_GC && !gc_in_progress)
+		unix_gc();
 	wait_event(unix_gc_wait, gc_in_progress == false);
 }
 
