Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753349Ab1AZOkA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 09:40:00 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:49962 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752267Ab1AZOj7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 09:39:59 -0500
Subject: Re: perf_events: question about __perf_event_read()
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: LKML <linux-kernel@vger.kernel.org>, mingo@elte.hu,
        =?ISO-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        "David S. Miller" <davem@davemloft.net>
In-Reply-To: <AANLkTima4Bfe-wRewbEkbrF9MGJmW1D0Cd3B4KynntSk@mail.gmail.com>
References: <AANLkTikX=tQwYKj9VZhCNudErf4TP-74+Jv3WPvSdUMn@mail.gmail.com>
	 <1295633925.28776.308.camel@laptop>
	 <AANLkTima4Bfe-wRewbEkbrF9MGJmW1D0Cd3B4KynntSk@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 26 Jan 2011 15:40:34 +0100
Message-ID: <1296052834.28776.1165.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-01-21 at 19:25 +0100, Stephane Eranian wrote:

> I remember checking this about a month ago and tip-x86 had
> some checks in this routine, but now the're gone.

I did a quick look through history and I couldn't find anything like
that, a well...

> I think you need something like:
> 
> +	if (ctx->is_active)
> +		update_context_time(ctx);
> 
> +	if (event->state == PERF_EVENT_STATE_ACTIVE)
> +		event->pmu->read(event);

Something like so?

---
Subject: perf: Fix race in perf_event_read()
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
Date: Wed Jan 26 15:38:35 CET 2011

It is quite possible for the event to have been disabled between
perf_event_read() sending the IPI and the CPU servicing the IPI and
calling __perf_event_read(), hence revalidate the state.

Reported-by: Stephane Eranian <eranian@google.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <new-submission>
---
 kernel/perf_event.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

Index: linux-2.6/kernel/perf_event.c
===================================================================
--- linux-2.6.orig/kernel/perf_event.c
+++ linux-2.6/kernel/perf_event.c
@@ -1901,11 +1901,12 @@ static void __perf_event_read(void *info
 		return;
 
 	raw_spin_lock(&ctx->lock);
-	update_context_time(ctx);
+	if (ctx->is_active)
+		update_context_time(ctx);
 	update_event_times(event);
+	if (event->state == PERF_EVENT_STATE_ACTIVE)
+		event->pmu->read(event);
 	raw_spin_unlock(&ctx->lock);
-
-	event->pmu->read(event);
 }
 
 static inline u64 perf_event_count(struct perf_event *event)

