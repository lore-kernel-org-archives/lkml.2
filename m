Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759621Ab2ILOuV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 10:50:21 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:51891 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755891Ab2ILOuT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 10:50:19 -0400
MIME-Version: 1.0
In-Reply-To: <1347461232.15764.45.camel@twins>
References: <CABPqkBSemt4hsoFfGkm3pac+R+aUJ6Kd9LBTWM-JtKMOF4VM9Q@mail.gmail.com>
	<1347461232.15764.45.camel@twins>
Date: Wed, 12 Sep 2012 16:50:17 +0200
Message-ID: <CABPqkBSPVBuKRYkO02O1BgbL5u=EtsRHJdYxqHrj56_H1vtsGQ@mail.gmail.com>
Subject: Re: [BUG] perf: multiplexing and hotplug CPU problem
From: Stephane Eranian <eranian@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>, "mingo@elte.hu" <mingo@elte.hu>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        Robert Richter <robert.richter@amd.com>
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 12, 2012 at 4:47 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Wed, 2012-09-12 at 16:40 +0200, Stephane Eranian wrote:
>> Hi,
>>
>> As I was debugging my hrtimer patch, I ran a few tests
>> with hotplug CPU. In others words, I offline a CPU while
>> there is an active monitoring session which causes multiplexing.
>>
>> When the CPU goes down, all is well. But when it comes back,
>> things go wrong. No kernel crashes but wrong results and multiplexing
>> does not work anymore.
>>
>> I investigated this some more and found out there is an issue
>> on re-activation.
>>
>> During shutdown, system-wide events are scheduled out AND removed
>> from the event lists. Consequently, ctx->nr_events and ctx->nr_active
>> go to zero.
>>
>> When the CPU is brought back online and tools do start/stop on the events
>> they can be scheduled back in, and therefore increment ctx->nr_active.
>> Because list_add_event() is not called again, you may end up with
>> ctx->nr_events < ctx->nr_active which is wrong. Events may not
>> be a lists and therefore they cannot get multiplexed again.
>>
>> It is not clear to me why we need to remove the events from any
>> list (list_del_event) when the CPU goes down.
>>
>> Why isn't calling event_sched_out() enough?
>> If events are kept on lists, why not try to schedule them back in when
>> the CPU is brought back online?
>
> This might be never, I think we should put the events in error state
> instead of disabling them, that should avoid the re-activation and
> provide a stronger hint to userspace that something went funny.

Yeah, that's probably a better approach. Counters should be put
in error state such that IOC_ENABLE or read() return errors.
