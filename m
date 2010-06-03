Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757866Ab0FCICn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 04:02:43 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:58504 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757349Ab0FCICg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 04:02:36 -0400
Subject: Re: [GIT PULL] perf crash fix
From: Peter Zijlstra <peterz@infradead.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Paul Mackerras <paulus@samba.org>,
       Stephane Eranian <eranian@google.com>
In-Reply-To: <1275534810-1837-1-git-send-regression-fweisbec@gmail.com>
References: <1275534810-1837-1-git-send-regression-fweisbec@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 03 Jun 2010 10:02:39 +0200
Message-ID: <1275552159.27810.34944.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-06-03 at 05:13 +0200, Frederic Weisbecker wrote:

> diff --git a/kernel/perf_event.c b/kernel/perf_event.c
> index 858f56f..b666d7d 100644
> --- a/kernel/perf_event.c
> +++ b/kernel/perf_event.c
> @@ -1510,20 +1510,16 @@ do {					\
>  	return div64_u64(dividend, divisor);
>  }
>  
> -static void perf_event_stop(struct perf_event *event)
> +static void perf_event_stop_hwevent(struct perf_event *event)
>  {
> -	if (!event->pmu->stop)
> -		return event->pmu->disable(event);
> -
> -	return event->pmu->stop(event);
> +	if (event->pmu->stop && !is_software_event(event))
> +		return event->pmu->stop(event);
>  }
>  
> -static int perf_event_start(struct perf_event *event)
> +static int perf_event_start_hwevent(struct perf_event *event)
>  {
> -	if (!event->pmu->start)
> -		return event->pmu->enable(event);
> -
> -	return event->pmu->start(event);
> +	if (event->pmu->start && !is_software_event(event))
> +		return event->pmu->start(event);
>  }
>  
>  static void perf_adjust_period(struct perf_event *event, u64 nsec, u64 count)
> @@ -1546,9 +1542,9 @@ static void perf_adjust_period(struct perf_event *event, u64 nsec, u64 count)
>  
>  	if (atomic64_read(&hwc->period_left) > 8*sample_period) {
>  		perf_disable();
> -		perf_event_stop(event);
> +		perf_event_stop_hwevent(event);
>  		atomic64_set(&hwc->period_left, 0);
> -		perf_event_start(event);
> +		perf_event_start_hwevent(event);
>  		perf_enable();
>  	}
>  }

Urhm,. isn't is much easier to simply give the software events a NOP
stop/start callback?

 kernel/perf_event.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index 858f56f..16c99e1 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -4276,9 +4276,15 @@ static void perf_swevent_disable(struct perf_event *event)
 	hlist_del_rcu(&event->hlist_entry);
 }
 
+static void perf_swevent_nop(struct perf_event *event)
+{
+}
+
 static const struct pmu perf_ops_generic = {
 	.enable		= perf_swevent_enable,
 	.disable	= perf_swevent_disable,
+	.start		= perf_swevent_nop,
+	.stop		= perf_swevent_nop,
 	.read		= perf_swevent_read,
 	.unthrottle	= perf_swevent_unthrottle,
 };

