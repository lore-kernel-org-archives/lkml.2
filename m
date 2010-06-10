Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758778Ab0FJKuj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jun 2010 06:50:39 -0400
Received: from casper.infradead.org ([85.118.1.10]:47244 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758100Ab0FJKuh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jun 2010 06:50:37 -0400
Subject: Re: [PATCH 2/5] perf: Support disable() after stop() on software
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
In-Reply-To: <1276141760-11590-3-git-send-regression-fweisbec@gmail.com>
References: <1276141760-11590-1-git-send-regression-fweisbec@gmail.com>
	 <1276141760-11590-3-git-send-regression-fweisbec@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 10 Jun 2010 12:50:17 +0200
Message-ID: <1276167017.2077.100.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-06-10 at 05:49 +0200, Frederic Weisbecker wrote:
> If we call perf_event_stop() on a software event and then the
> disable() pmu callback on them after that, we'll call twice
> hlist_del_rcu() on the same hlist node and then bring a crash
> by dereferencing LIST_POISON2.
> 
> Just use hlist_del_init_rcu() instead to fix this problem.
> 
> This preparates for new context exclusions.
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
>  kernel/perf_event.c             |    2 +-
>  kernel/trace/trace_event_perf.c |    2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/perf_event.c b/kernel/perf_event.c
> index 5c004f7..2d818bc 100644
> --- a/kernel/perf_event.c
> +++ b/kernel/perf_event.c
> @@ -4291,7 +4291,7 @@ static int perf_swevent_enable(struct perf_event *event)
>  
>  static void perf_swevent_disable(struct perf_event *event)
>  {
> -	hlist_del_rcu(&event->hlist_entry);
> +	hlist_del_init_rcu(&event->hlist_entry);
>  }
>  
>  static void perf_swevent_void(struct perf_event *event)
> diff --git a/kernel/trace/trace_event_perf.c b/kernel/trace/trace_event_perf.c
> index 4799d70..7bc1f26 100644
> --- a/kernel/trace/trace_event_perf.c
> +++ b/kernel/trace/trace_event_perf.c
> @@ -122,7 +122,7 @@ int perf_trace_enable(struct perf_event *p_event)
>  
>  void perf_trace_disable(struct perf_event *p_event)
>  {
> -	hlist_del_rcu(&p_event->hlist_entry);
> +	hlist_del_init_rcu(&p_event->hlist_entry);
>  }
>  
>  void perf_trace_destroy(struct perf_event *p_event)


Ok, so then why did you need the first patch?
