Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753330Ab1AUSZr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 13:25:47 -0500
Received: from smtp-out.google.com ([216.239.44.51]:17559 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752212Ab1AUSZq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 13:25:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=tIVHhC5lv9Cj0JW2sKrwOEBR6/4Zwc4k0MLCCiLun0bS/C9hflvVrdykCEY7MIfqhp
         2ndv9GOSVcqg1tZYyYtw==
MIME-Version: 1.0
In-Reply-To: <1295633925.28776.308.camel@laptop>
References: <AANLkTikX=tQwYKj9VZhCNudErf4TP-74+Jv3WPvSdUMn@mail.gmail.com>
	<1295633925.28776.308.camel@laptop>
Date: Fri, 21 Jan 2011 19:25:43 +0100
Message-ID: <AANLkTima4Bfe-wRewbEkbrF9MGJmW1D0Cd3B4KynntSk@mail.gmail.com>
Subject: Re: perf_events: question about __perf_event_read()
From: Stephane Eranian <eranian@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>, mingo@elte.hu,
        =?UTF-8?B?RnLDqWTDqXJpYyBXZWlzYmVja2Vy?= <fweisbec@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        "David S. Miller" <davem@davemloft.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 21, 2011 at 7:18 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Fri, 2011-01-21 at 19:06 +0100, Stephane Eranian wrote:
>> Hi,
>>
>> I think the code below still has a problem in case of a per-cpu event.
>>
>> If you issue a read() on a different CPU, then you IPI to the event's cpu.
>> By the time you get there, the event may be de-scheduled in which
>> case you don't want to issue event->pmu_read() nor update context
>> timings. The function has a test but it seems to be checking the per-cpu
>> case only.
>>
>> I have seen panics on P4 with this code because it goes all the way
>> down to rdmsrl() with a bogus counter index (like -1).
>>
>> Am I missing something here?
>>
>> static void __perf_event_read(void *info)
>> {
>>         struct perf_event *event = info;
>>         struct perf_event_context *ctx = event->ctx;
>>         struct perf_cpu_context *cpuctx = __get_cpu_context(ctx);
>>
>>         /*
>>          * If this is a task context, we need to check whether it is
>>          * the current task context of this cpu.  If not it has been
>>          * scheduled out before the smp call arrived.  In that case
>>          * event->count would have been updated to a recent sample
>>          * when the event was scheduled out.
>>          */
>>         if (ctx->task && cpuctx->task_ctx != ctx)
>>                 return;
>>
>>         raw_spin_lock(&ctx->lock);
>
> Shouldn't we re-check event->state once we hold this lock?
>
I remember checking this about a month ago and tip-x86 had
some checks in this routine, but now the're gone.

I think you need something like:

+	if (ctx->is_active)
+		update_context_time(ctx);

+	if (event->state == PERF_EVENT_STATE_ACTIVE)
+		event->pmu->read(event);

>>         update_context_time(ctx);
>>         update_event_times(event);
>>         raw_spin_unlock(&ctx->lock);
>>
>>         event->pmu->read(event);
>> }
>
>
>
