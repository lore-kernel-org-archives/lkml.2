Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758727Ab0FJKrK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jun 2010 06:47:10 -0400
Received: from casper.infradead.org ([85.118.1.10]:51663 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752822Ab0FJKrI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jun 2010 06:47:08 -0400
Subject: Re: [PATCH 1/5] perf: Provide a proper stop action for software
 events
From: Peter Zijlstra <peterz@infradead.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Paul Mackerras <paulus@samba.org>,
       Stephane Eranian <eranian@google.com>,
       Cyrill Gorcunov <gorcunov@gmail.com>,
       Zhang Yanmin <yanmin_zhang@linux.intel.com>,
       Steven Rostedt <rostedt@goodmis.org>
In-Reply-To: <1276141760-11590-2-git-send-regression-fweisbec@gmail.com>
References: <1276141760-11590-1-git-send-regression-fweisbec@gmail.com>
	 <1276141760-11590-2-git-send-regression-fweisbec@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 10 Jun 2010 12:46:53 +0200
Message-ID: <1276166813.2077.96.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-06-10 at 05:49 +0200, Frederic Weisbecker wrote:
> In order to introduce new context exclusions, software events will
> have to eventually stop when needed. We'll want perf_event_stop() to
> act on every events.
> 
> To achieve this, remove the stub stop/start pmu callbacks of software
> and tracepoint events.
> 
> This may even optimize the case of hardware and software events
> running at the same time: now we only stop/start all hardware
> events if we reset a hardware event period, not anymore with
> software events.
> 
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: Stephane Eranian <eranian@google.com>
> Cc: Cyrill Gorcunov <gorcunov@gmail.com>
> Cc: Zhang Yanmin <yanmin_zhang@linux.intel.com>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> ---
>  kernel/perf_event.c |   29 ++++++++++++++++-------------
>  1 files changed, 16 insertions(+), 13 deletions(-)
> 
> diff --git a/kernel/perf_event.c b/kernel/perf_event.c
> index c772a3d..5c004f7 100644
> --- a/kernel/perf_event.c
> +++ b/kernel/perf_event.c
> @@ -1541,11 +1541,23 @@ static void perf_adjust_period(struct perf_event *event, u64 nsec, u64 count)
>  	hwc->sample_period = sample_period;
>  
>  	if (local64_read(&hwc->period_left) > 8*sample_period) {
> -		perf_disable();
> -		perf_event_stop(event);
> +		bool software_event = is_software_event(event);
> +
> +		/*
> +		 * Only hardware events need their irq period to be
> +		 * reprogrammed
> +		 */
> +		if (!software_event) {
> +			perf_disable();
> +			perf_event_stop(event);
> +		}
> +
>  		local64_set(&hwc->period_left, 0);
> -		perf_event_start(event);
> -		perf_enable();
> +
> +		if (!software_event) {
> +			perf_event_start(event);
> +			perf_enable();
> +		}
>  	}
>  }
>  
> @@ -4286,16 +4298,9 @@ static void perf_swevent_void(struct perf_event *event)
>  {
>  }
>  
> -static int perf_swevent_int(struct perf_event *event)
> -{
> -	return 0;
> -}
> -
>  static const struct pmu perf_ops_generic = {
>  	.enable		= perf_swevent_enable,
>  	.disable	= perf_swevent_disable,
> -	.start		= perf_swevent_int,
> -	.stop		= perf_swevent_void,
>  	.read		= perf_swevent_read,
>  	.unthrottle	= perf_swevent_void, /* hwc->interrupts already reset */
>  };
> @@ -4578,8 +4583,6 @@ static int swevent_hlist_get(struct perf_event *event)
>  static const struct pmu perf_ops_tracepoint = {
>  	.enable		= perf_trace_enable,
>  	.disable	= perf_trace_disable,
> -	.start		= perf_swevent_int,
> -	.stop		= perf_swevent_void,
>  	.read		= perf_swevent_read,
>  	.unthrottle	= perf_swevent_void,
>  };

I really don't like this.. we should be removing differences between
software and hardware pmu implementations, not add more :/

Something like the below would work, the only 'problem' is that it grows
hw_perf_event.

---
 include/linux/perf_event.h |    1 +
 kernel/perf_event.c        |   27 ++++++++++++++++++---------
 2 files changed, 19 insertions(+), 9 deletions(-)

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 9073bde..2292659 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -531,6 +531,7 @@ struct hw_perf_event {
 		struct { /* software */
 			s64		remaining;
 			struct hrtimer	hrtimer;
+			int		stopped;
 		};
 #ifdef CONFIG_HAVE_HW_BREAKPOINT
 		/* breakpoint */
diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index 403d180..14b691e 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -4113,6 +4113,9 @@ static int perf_swevent_match(struct perf_event *event,
 				struct perf_sample_data *data,
 				struct pt_regs *regs)
 {
+	if (event->hw.stopped)
+		return 0;
+
 	if (event->attr.type != type)
 		return 0;
 
@@ -4282,22 +4285,28 @@ static void perf_swevent_disable(struct perf_event *event)
 	hlist_del_rcu(&event->hlist_entry);
 }
 
-static void perf_swevent_void(struct perf_event *event)
+static void perf_swevent_throttle(struct perf_event *event)
 {
+	/* hwc->interrupts already reset */
 }
 
-static int perf_swevent_int(struct perf_event *event)
+static int perf_swevent_start(struct perf_event *event)
 {
-	return 0;
+	event->hw.stopped = 0;
+}
+
+static void perf_swevent_throttle(struct perf_event *event)
+{
+	event->hw.stopped = 1;
 }
 
 static const struct pmu perf_ops_generic = {
 	.enable		= perf_swevent_enable,
 	.disable	= perf_swevent_disable,
-	.start		= perf_swevent_int,
-	.stop		= perf_swevent_void,
+	.start		= perf_swevent_start,
+	.stop		= perf_swevent_stop,
 	.read		= perf_swevent_read,
-	.unthrottle	= perf_swevent_void, /* hwc->interrupts already reset */
+	.unthrottle	= perf_swevent_throttle,
 };
 
 /*
@@ -4578,10 +4587,10 @@ static int swevent_hlist_get(struct perf_event *event)
 static const struct pmu perf_ops_tracepoint = {
 	.enable		= perf_trace_enable,
 	.disable	= perf_trace_disable,
-	.start		= perf_swevent_int,
-	.stop		= perf_swevent_void,
+	.start		= perf_swevent_start,
+	.stop		= perf_swevent_stop,
 	.read		= perf_swevent_read,
-	.unthrottle	= perf_swevent_void,
+	.unthrottle	= perf_swevent_throttle,
 };
 
 static int perf_tp_filter_match(struct perf_event *event,


