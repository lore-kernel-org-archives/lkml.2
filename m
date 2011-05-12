Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755048Ab1ELIsR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 04:48:17 -0400
Received: from casper.infradead.org ([85.118.1.10]:58761 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754873Ab1ELIsQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 04:48:16 -0400
Subject: Re: [RFC PATCH] perf: Carve out cgroup-related code
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Borislav Petkov <bp@amd64.org>
Cc: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        osrc-patches <osrc-patches@elbe.amd.com>
In-Reply-To: <20110511170912.GA27362@aftab>
References: <20110511121135.GA25865@aftab>
	 <1305121600.2914.214.camel@laptop> <20110511140208.GD25827@aftab>
	 <20110511141342.GA19053@elte.hu> <20110511143149.GA26548@aftab>
	 <20110511152156.GA21707@elte.hu>  <20110511170912.GA27362@aftab>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 12 May 2011 10:51:17 +0200
Message-ID: <1305190277.2914.259.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-05-11 at 19:09 +0200, Borislav Petkov wrote:

I can't really say I like this move stuff into perf_event.h and then
move it out again dance. Makes it exceedingly hard for me to tell wth
actually happened.

>  include/linux/perf_event.h |  132 --------------------------------------------

Compared with:

 include/linux/perf_event.h |  126 +++++++++++-
 include/linux/perf_event.h |    7 +-

Its very hard to tell if this undoes the exact damage you did earlier.

>  kernel/events/callchain.c  |    3 +
>  kernel/events/cgroup.c     |    2 +
>  kernel/events/core.c       |    2 +
>  kernel/events/internal.h   |  129 +++++++++++++++++++++++++++++++++++++++++++
>  5 files changed, 136 insertions(+), 132 deletions(-)
>  create mode 100644 kernel/events/internal.h
> 
> diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
> index 7978850..6b25452 100644
> --- a/include/linux/perf_event.h
> +++ b/include/linux/perf_event.h
> @@ -963,7 +963,6 @@ enum event_type_t {
>  #ifdef CONFIG_PERF_EVENTS
>  extern struct list_head pmus;
>  extern int perf_pmu_register(struct pmu *pmu, char *name, int type);
> -extern void perf_pmu_unregister(struct pmu *pmu);

That just doesn't make any sense. If we publish one side of the API we
should also publish the other side.

>  extern int perf_num_counters(void);
>  extern const char *perf_pmu_name(void);
> @@ -985,8 +984,6 @@ perf_event_create_kernel_counter(struct perf_event_attr *attr,
>                                 int cpu,
>                                 struct task_struct *task,
>                                 perf_overflow_handler_t callback);
> -extern u64 perf_event_read_value(struct perf_event *event,
> -                                u64 *enabled, u64 *running);

While not used, that is a valid part of the API.

>  
>  struct perf_sample_data {
>         u64                             type;
> @@ -1152,60 +1149,10 @@ extern int perf_output_begin(struct perf_output_handle *handle,
>                              struct perf_event *event, unsigned int size,
>                              int nmi, int sample);
>  extern void perf_output_end(struct perf_output_handle *handle);
> -extern void perf_output_copy(struct perf_output_handle *handle,
> -                            const void *buf, unsigned int len);

idem

>  extern int perf_swevent_get_recursion_context(void);
> -extern void perf_swevent_put_recursion_context(int rctx);

Again, creating asymmetry. 

>  extern void perf_event_enable(struct perf_event *event);
>  extern void perf_event_disable(struct perf_event *event);
>  extern void perf_event_task_tick(void);


