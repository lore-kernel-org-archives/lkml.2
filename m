Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753295Ab1AZOuh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 09:50:37 -0500
Received: from smtp-out.google.com ([74.125.121.67]:22484 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752267Ab1AZOug convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 09:50:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=ruNuo/G+V6VLxLUsr4xGvlgqbmrr07oeHGbjSQQ8otuqC7gABqwj/Syf1UBZF4THk7
         YxLMF2S/nnzO2njDEvcA==
MIME-Version: 1.0
In-Reply-To: <1296052834.28776.1165.camel@laptop>
References: <AANLkTikX=tQwYKj9VZhCNudErf4TP-74+Jv3WPvSdUMn@mail.gmail.com>
	<1295633925.28776.308.camel@laptop>
	<AANLkTima4Bfe-wRewbEkbrF9MGJmW1D0Cd3B4KynntSk@mail.gmail.com>
	<1296052834.28776.1165.camel@laptop>
Date: Wed, 26 Jan 2011 15:50:32 +0100
Message-ID: <AANLkTik=zGEUqh0AOWDus_bUM4xYxka0Grqn6cRDgz_j@mail.gmail.com>
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

Yeah, something like that.

I didn't quite understand why the event->pmu->read() was outside of the
lock.

Thanks.

On Wed, Jan 26, 2011 at 3:40 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Fri, 2011-01-21 at 19:25 +0100, Stephane Eranian wrote:
>
>> I remember checking this about a month ago and tip-x86 had
>> some checks in this routine, but now the're gone.
>
> I did a quick look through history and I couldn't find anything like
> that, a well...
>
>> I think you need something like:
>>
>> +     if (ctx->is_active)
>> +             update_context_time(ctx);
>>
>> +     if (event->state == PERF_EVENT_STATE_ACTIVE)
>> +             event->pmu->read(event);
>
> Something like so?
>
> ---
> Subject: perf: Fix race in perf_event_read()
> From: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Date: Wed Jan 26 15:38:35 CET 2011
>
> It is quite possible for the event to have been disabled between
> perf_event_read() sending the IPI and the CPU servicing the IPI and
> calling __perf_event_read(), hence revalidate the state.
>
> Reported-by: Stephane Eranian <eranian@google.com>
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> LKML-Reference: <new-submission>
> ---
>  kernel/perf_event.c |    7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
>
> Index: linux-2.6/kernel/perf_event.c
> ===================================================================
> --- linux-2.6.orig/kernel/perf_event.c
> +++ linux-2.6/kernel/perf_event.c
> @@ -1901,11 +1901,12 @@ static void __perf_event_read(void *info
>                return;
>
>        raw_spin_lock(&ctx->lock);
> -       update_context_time(ctx);
> +       if (ctx->is_active)
> +               update_context_time(ctx);
>        update_event_times(event);
> +       if (event->state == PERF_EVENT_STATE_ACTIVE)
> +               event->pmu->read(event);
>        raw_spin_unlock(&ctx->lock);
> -
> -       event->pmu->read(event);
>  }
>
>  static inline u64 perf_event_count(struct perf_event *event)
>
>
