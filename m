Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755053Ab1AFAvG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 19:51:06 -0500
Received: from kroah.org ([198.145.64.141]:35720 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754237Ab1AFA3y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 19:29:54 -0500
X-Mailbox-Line: From gregkh@clark.site Wed Jan  5 16:23:02 2011
Message-Id: <20110106002302.398143553@clark.site>
User-Agent: quilt/0.48-11.2
Date: Wed, 05 Jan 2011 16:22:40 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [061/152] af_unix: limit unix_tot_inflight
In-Reply-To: <20110106002500.GA3172@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

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
---
 net/unix/garbage.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/net/unix/garbage.c
+++ b/net/unix/garbage.c
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
 


