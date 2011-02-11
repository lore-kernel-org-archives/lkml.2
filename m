Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757704Ab1BKRwX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Feb 2011 12:52:23 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:38762 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756595Ab1BKRwW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Feb 2011 12:52:22 -0500
Subject: Re: perf on 2.6.38-rc4 wedges my box
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: David Ahern <dsahern@gmail.com>
Cc: Jeff Moyer <jmoyer@redhat.com>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
In-Reply-To: <4D55654F.6090408@gmail.com>
References: <x49k4h9az25.fsf@segfault.boston.devel.redhat.com>
	 <1297373905.5226.31.camel@laptop>  <4D55654F.6090408@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 11 Feb 2011 18:53:26 +0100
Message-ID: <1297446806.5226.44.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-02-11 at 09:35 -0700, David Ahern wrote:
> I'm guessing in your case perf is using hardware cycles for profiling.
> 
> I was able to reproduce the lockup in a VM which uses cpu-clock for
> profiling - like Jeff's case. The VM is running Fedora 14 with
> 2.6.38-rc4.
> 
Ah, indeed, when I use:

  perf record -gfe task-clock -- ./aio-stress -O -o 0 -r 4 -d 32 -b 16 /dev/sdb

things did come apart, something like the below cured that problem (but
did show the pending softirq thing and triggered something iffy in the
backtrace code -- will have to stare at those still)


---
diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index a353a4d..36fb410 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -5123,6 +5123,10 @@ static enum hrtimer_restart perf_swevent_hrtimer(struct hrtimer *hrtimer)
 	u64 period;
 
 	event = container_of(hrtimer, struct perf_event, hw.hrtimer);
+
+	if (event->state < PERF_EVENT_STATE_ACTIVE)
+		return HRTIMER_NORESTART;
+
 	event->pmu->read(event);
 
 	perf_sample_data_init(&data, 0);
@@ -5174,7 +5178,7 @@ static void perf_swevent_cancel_hrtimer(struct perf_event *event)
 		ktime_t remaining = hrtimer_get_remaining(&hwc->hrtimer);
 		local64_set(&hwc->period_left, ktime_to_ns(remaining));
 
-		hrtimer_cancel(&hwc->hrtimer);
+		hrtimer_try_to_cancel(&hwc->hrtimer);
 	}
 }
 


