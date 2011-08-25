Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753085Ab1HYPDN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 11:03:13 -0400
Received: from smtp-out.google.com ([74.125.121.67]:46290 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752818Ab1HYPDM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 11:03:12 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:in-reply-to:references:date:
	message-id:subject:from:to:cc:content-type:
	content-transfer-encoding:x-system-of-record;
	b=KiyyaEW/kXf5EgYRWGs2ceEdyIOjqzxlA4AOFGel9LE10fpvC5e9tLEyz16+nHiX9
	WmeSv7XFGfimd8Ozg9VVQ==
MIME-Version: 1.0
In-Reply-To: <1314283321.27911.25.camel@twins>
References: <20110825135803.GA4697@quad>
	<1314282021.27911.12.camel@twins>
	<CABPqkBTnrQRNnAz6Z0Nk+oBczDD4+-NLDtb_o3aMfc11SMe7nw@mail.gmail.com>
	<1314283321.27911.25.camel@twins>
Date: Thu, 25 Aug 2011 17:03:08 +0200
Message-ID: <CABPqkBT_Wf8BLj7U7EDP2jpKUbzCJCbfF1ffzxWn2s-5pd+1og@mail.gmail.com>
Subject: Re: [PATCH] perf_event: fix slow and broken cgroup context switch code
From: Stephane Eranian <eranian@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, ming.m.lin@intel.com,
        Oleg Nesterov <oleg@redhat.com>, Jiri Olsa <jolsa@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 25, 2011 at 4:42 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Thu, 2011-08-25 at 16:36 +0200, Stephane Eranian wrote:
>> On Thu, Aug 25, 2011 at 4:20 PM, Peter Zijlstra <peterz@infradead.org> wrote:
>> > On Thu, 2011-08-25 at 15:58 +0200, Stephane Eranian wrote:
>> >> +static inline void perf_event_task_sched_out(struct task_struct
>> >> *prev,
>> >> +                                            struct task_struct *next)
>> >>  {
>> >>         perf_sw_event(PERF_COUNT_SW_CONTEXT_SWITCHES, 1, NULL, 0);
>> >>
>> >> -       __perf_event_task_sched_out(task, next);
>> >> +       if (static_branch(&perf_sched_events))
>> >> +               __perf_event_task_sched_out(prev, next);
>> >>  }
>> >
>> > Right, so the reason we removed the static branch from there is
>> >
>> >  lkml.kernel.org/r/20110324164436.GC1930@jolsa.brq.redhat.com
>> >
>> > now I think the series 075e0b0085 to 64ce312618e should have cured that
>> > problem, and adding the static_branch() is now safe again. But there's
>> > no mention of any of this in the Changelog.
>> >
>> I realized I did not talk about the static_branch() change after I had
>> clicked on
>> Send. But to me, this looks natural to have the static branch in the ctxsw out
>> routine. This has to be symmetrical with ctxsw in . The static branch is about
>> avoiding perf ctxsw when there is no need for it, i.e., no per-thread
>> nor per-cgroup
>> events.
>
> Yeah, that argument is what got us into trouble initially :) But I think
> its ok now, we'll see if stuff explodes or not..
>
I just ran that crash test you pointed out and so far so good. Don't know if
the crash was systematic, though.
