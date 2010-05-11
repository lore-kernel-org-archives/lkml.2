Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757339Ab0EKT4A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 15:56:00 -0400
Received: from ey-out-2122.google.com ([74.125.78.24]:44699 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752827Ab0EKTz6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 15:55:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type:content-transfer-encoding;
        b=GNAAn9ESysagN2Ds0koGW1hZViFsTp8rlS4ifzVkppJXCCCfd/MUUuZsKGdY3nEpxi
         QQUdy5uUAy0RBTer8UHrJaxAZvlX4ZDuOj0kFrGgaMZvDB8/3wgIQMc7F/YKXRGERVYh
         3eJzDFxjP7vr0pWWTqEGd7YufQyDdT0wqdGeI=
MIME-Version: 1.0
Reply-To: eranian@gmail.com
In-Reply-To: <1273588935.1810.6.camel@laptop>
References: <4BE4C4BF.6020801@linux.vnet.ibm.com>
	 <1273588935.1810.6.camel@laptop>
Date: Tue, 11 May 2010 21:55:56 +0200
Message-ID: <h2i7c86c4471005111255ke689a7acz3a9bbb80480235b0@mail.gmail.com>
Subject: Re: [BUG] perf_event: when events are grouped, the time enabled / 
	running values are incorrect
From: stephane eranian <eranian@googlemail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>, Paul Mackerras <paulus@samba.org>,
       eranian@google.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I believe there is another bug related to timing and I am not
sure if this patch fixes it too.

If you add TIME_ENABLED|TIME_RUNNING in samples, they
will get zero all the time (ENA, RUN):

$ libpfm/perf_examples/task_smpl noploop 4
period=240000000 freq=0
58  PERF_COUNT_HW_CPU_CYCLES
59  PERF_COUNT_HW_INSTRUCTIONS
noploop for 4 seconds

IIP:0x0000000000400651 PID:10613 TID:10613 TIME:27480525003765
STREAM_ID:58 PERIOD:240000000 ENA=0 RUN=0 NR=2
	240000257 PERF_COUNT_HW_CPU_CYCLES (58)
	239740143 PERF_COUNT_HW_INSTRUCTIONS (59)

IP:0x0000000000400651 PID:10613 TID:10613 TIME:27480626252349
STREAM_ID:58 PERIOD:240000000 ENA=0 RUN=0 NR=2
	480000257 PERF_COUNT_HW_CPU_CYCLES (58)
	479688363 PERF_COUNT_HW_INSTRUCTIONS (59)

Events are also grouped in this example. Both this same issue exists
also when only
one event is used. I suspect an update_event_times() or
update_group_times() is also
missing on the sampling path in perf_overflow_handler().


On Tue, May 11, 2010 at 4:42 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Fri, 2010-05-07 at 18:56 -0700, Corey Ashford wrote:
>> Hi,
>>
>> There appears to be a bug in the kernel related to reading up the time
>> running and enabled values for events that are in a group.  The group
>> leader's time running and time enable values look correct, but all of
>> the other group members have a zero value for their time running and
>> time enabled fields.
>>
>> This happens only when remote monitoring a process (perhaps only after
>> it has terminated)... when self monitoring, the time running/enabled
>> values come out non-zero, and the values are the same for all of the
>> counters (as one would expect since they can be enabled/disabled
>> simultaneously).
>>
>> I've attached a test case which you can place in the tools/perf
>> subdirectory and compile with just:
>>
>> gcc -o show_re_bug show_re_bug.c
>
> The below seems to fix this for me.
>
> ---
> Subject: perf: Fix exit() vs event-groups
> From: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Date: Tue May 11 16:19:10 CEST 2010
>
> Corey reported that the value scale times of group siblings are not
> updated when the monitored task dies.
>
> The problem appears to be that we only update the group leader's
> time values, fix it by updating the whole group.
>
> Reported-by: Corey Ashford <cjashfor@linux.vnet.ibm.com>
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: stable@kernel.org
> ---
>  kernel/perf_event.c |   44 +++++++++++++++++++++++---------------------
>  1 file changed, 23 insertions(+), 21 deletions(-)
>
> Index: linux-2.6/kernel/perf_event.c
> ===================================================================
> --- linux-2.6.orig/kernel/perf_event.c
> +++ linux-2.6/kernel/perf_event.c
> @@ -255,6 +255,18 @@ static void update_event_times(struct pe
>        event->total_time_running = run_end - event->tstamp_running;
>  }
>
> +/*
> + * Update total_time_enabled and total_time_running for all events in a group.
> + */
> +static void update_group_times(struct perf_event *leader)
> +{
> +       struct perf_event *event;
> +
> +       update_event_times(leader);
> +       list_for_each_entry(event, &leader->sibling_list, group_entry)
> +               update_event_times(event);
> +}
> +
>  static struct list_head *
>  ctx_group_list(struct perf_event *event, struct perf_event_context *ctx)
>  {
> @@ -320,7 +332,7 @@ list_del_event(struct perf_event *event,
>        if (event->group_leader != event)
>                event->group_leader->nr_siblings--;
>
> -       update_event_times(event);
> +       update_group_times(event);
>
>        /*
>         * If event was in error state, then keep it
> @@ -502,18 +514,6 @@ retry:
>  }
>
>  /*
> - * Update total_time_enabled and total_time_running for all events in a group.
> - */
> -static void update_group_times(struct perf_event *leader)
> -{
> -       struct perf_event *event;
> -
> -       update_event_times(leader);
> -       list_for_each_entry(event, &leader->sibling_list, group_entry)
> -               update_event_times(event);
> -}
> -
> -/*
>  * Cross CPU call to disable a performance event
>  */
>  static void __perf_event_disable(void *info)
>
>
>
