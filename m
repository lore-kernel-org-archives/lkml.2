Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753115Ab1CZQgA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Mar 2011 12:36:00 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:46099 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752853Ab1CZQf7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Mar 2011 12:35:59 -0400
Subject: Re: [PATCH,RFC] perf: panic due to inclied cpu context task_ctx
 value
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Jiri Olsa <jolsa@redhat.com>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
In-Reply-To: <20110326161346.GA18272@redhat.com>
References: <20110324164436.GC1930@jolsa.brq.redhat.com>
	 <1301153868.2250.359.camel@laptop>  <20110326161346.GA18272@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 26 Mar 2011 17:38:03 +0100
Message-ID: <1301157483.2250.366.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2011-03-26 at 17:13 +0100, Oleg Nesterov wrote:
> 
> I don't think this is right.
> 
> It is too late to clear ->task_ctx when the task exits. It is simply
> wrong that cpuctx->task_ctx != NULL after context_switch(). And, once
> again ->is_active is still true. 

Ah, indeed. Somehow I was thinking we did remove_from_context on
close(), I thought about adding it to list_del_event() because that's
the place we empty the context and I guess I should have done something
like that.

The problem with adding it to list_del_event() is that it isn't
necessarily called on the correct cpu.

/me ponders things for a bit ...

The alternative seems to be to put it in event_sched_out(), right where
we decrease ctx->nr_active. Again, I might have missed something quite
trivial.. let me try and get that test-case running someplace.


---
 kernel/perf_event.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index c75925c..e9e4e35 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -1073,6 +1073,8 @@ event_sched_out(struct perf_event *event,
 	if (!is_software_event(event))
 		cpuctx->active_oncpu--;
 	ctx->nr_active--;
+	if (!ctx->nr_active && cpuctx->task_ctx == ctx)
+		cpuctx->task_ctx = NULL;
 	if (event->attr.exclusive || !cpuctx->active_oncpu)
 		cpuctx->exclusive = 0;
 }


