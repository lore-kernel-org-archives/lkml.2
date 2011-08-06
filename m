Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757322Ab1HFAKE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Aug 2011 20:10:04 -0400
Received: from cantor2.suse.de ([195.135.220.15]:39291 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932133Ab1HFAJv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Aug 2011 20:09:51 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Aug  5 17:02:54 2011
Message-Id: <20110806000254.303730660@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Fri, 05 Aug 2011 17:02:24 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, Greg KH <greg@kroah.com>
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Vince Weaver <vweaver1@eecs.utk.edu>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [54/55] perf: overflow/perf_count_sw_cpu_clock crashes recent kernels
In-Reply-To: <20110806000257.GA25498@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Peter Zijlstra <a.p.zijlstra@chello.nl>

The below patch is for -stable only, upstream has a much larger patch
that contains the below hunk in commit a8b0ca17b80e92faab46ee7179ba9e99ccb61233

Vince found that under certain circumstances software event overflows
go wrong and deadlock. Avoid trying to delete a timer from the timer
callback.

Reported-by: Vince Weaver <vweaver1@eecs.utk.edu>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 kernel/perf_event.c |    8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -3694,12 +3694,8 @@ static int __perf_event_overflow(struct
 	if (events && atomic_dec_and_test(&event->event_limit)) {
 		ret = 1;
 		event->pending_kill = POLL_HUP;
-		if (nmi) {
-			event->pending_disable = 1;
-			perf_pending_queue(&event->pending,
-					   perf_pending_event);
-		} else
-			perf_event_disable(event);
+		event->pending_disable = 1;
+		perf_pending_queue(&event->pending, perf_pending_event);
 	}
 
 	perf_event_output(event, nmi, data, regs);


