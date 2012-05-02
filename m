Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754574Ab2EBMA1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2012 08:00:27 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:63610 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752390Ab2EBMAZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2012 08:00:25 -0400
MIME-Version: 1.0
In-Reply-To: <20120426152840.GC1659@m.brq.redhat.com>
References: <1334661441-4420-1-git-send-email-jolsa@redhat.com>
	<1334661441-4420-3-git-send-email-jolsa@redhat.com>
	<CABPqkBRqG5WhWYY5viVW3j89WUrpmkk1j7VA=oUhY_TGXg=14g@mail.gmail.com>
	<20120423103350.GB1720@m.brq.redhat.com>
	<20120426152840.GC1659@m.brq.redhat.com>
Date: Wed, 2 May 2012 14:00:23 +0200
Message-ID: <CABPqkBSC02vBxAPLrS6j4bVFGme3ibKH=VOkT0yHVCP=pJMnYA@mail.gmail.com>
Subject: Re: [PATCH 02/16] perf: Unified API to record selective sets of arch registers
From: Stephane Eranian <eranian@google.com>
To: Jiri Olsa <jolsa@redhat.com>
Cc: acme@redhat.com, a.p.zijlstra@chello.nl, mingo@elte.hu, paulus@samba.org,
        cjashfor@linux.vnet.ibm.com, fweisbec@gmail.com, gorcunov@openvz.org,
        tzanussi@gmail.com, mhiramat@redhat.com, rostedt@goodmis.org,
        robert.richter@amd.com, fche@redhat.com, linux-kernel@vger.kernel.org,
        masami.hiramatsu.pt@hitachi.com, drepper@gmail.com,
        Arun Sharma <asharma@fb.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry for the delay, had higher priority tasks to do.
[+asharma]

On Thu, Apr 26, 2012 at 5:28 PM, Jiri Olsa <jolsa@redhat.com> wrote:
> On Mon, Apr 23, 2012 at 12:33:50PM +0200, Jiri Olsa wrote:
>> On Mon, Apr 23, 2012 at 12:10:57PM +0200, Stephane Eranian wrote:
>> > On Tue, Apr 17, 2012 at 1:17 PM, Jiri Olsa <jolsa@redhat.com> wrote:
>
> SNIP
>
>> > How are you going to deal with 32-bit binaries sampled on a 64-bit system?
>>
>> I dont have the solution right now... but seems like compat tasks need more
>> thinking even before go ahead with this patchset.. since it's going affect
>> the perf_event_attr and could bite us in future.
> hi,
> got more info on the compat task unwind
>
> - for 32 bit task running under 64 bit env. the 64 bits user
>  registers values are stored on kernel stack when entering
>  the kernel via exception or interrupt, like for native
>  64 bit task
>
You mean the 32-bit registers are stored on the kernel stack,
right? Or you mean 64-bit and the upper 32 are guaranteed 0.


>  So I think we can keep the current interface as far as
>  compat tasks are concerned, since we will get 64 bits
>  registers all the time anyway.
>
>  The place that will take care of compat task unwind
>  is the post processing unwind.
>
>  For each processed sample we:
>     - get the sample and translate IP into MAP and DSO
>     - read DSO ELF class and figure out wether we deal with
>       64 or 32 bit task
>     - run libunwind interface with proper task class info,
>       which gets us to next bullet:
>
> - 64 bit libunwind does not support unwind of 32 bit tasks ;)
>  so unless that change, I can see just one hacky way of doing
>  this via 32 bit libunwind being loaded in separate 32 bit
>  process and doing remote unwind for us..

okay was not aware of that restriction on libunwind. I copied Arun
on this response, so maybe he can comment on that.

>
>  I'll try to follow on this to see if there'd be some better
>  libunwind interface solution.. but thats quite longterm ;)
>
>
> As for the sample registers interface.
>
> Currently we have:
>
>  u64 user_sample_regs
>  - if != 0 we provide the user registers with mask specified
>    by its value
>
>  - it will stay for compat tasks as well

What if I say EAX|EBX|R15? but the sample was captured
on a 32-bit tasks. Are you going to just store 0 for R15?
Unless you also store a bitmask of what was actually saved,
then you have to fill in non-existent registers with zeroes, otherwise
the tool cannot parse the sample.


>  - we could use PERF_SAMPLE_USER_REGS sample type instead of the != 0
>    check to be more consistent, but that would eat up one sample bit
>    unnecessary

But then that would be aligned with how branch_stack has been implemented
for instance (PERF_SAMPLE_BRANCH_STACK).

>
> In some previous email you suggested some generic interface like
>
>    attr->sample_type |= PERF_SAMPLE_REGS
>    attr->sample_regs = EAX | EBX | EDI | ESI |.....
>    attr->sample_reg_mode = { INTR, PRECISE, USER }
>
> I think we can have something like:
>
>    attr->sample_type |= PERF_SAMPLE_REGS
>    attr->sample_reg_mode = { INTR, PRECISE, USER }
>
> but in case we want eg both USER and INTR modes together then we still
> need to have:
>
>  u64 user_sample_regs
>  u64 intr_sample_regs
>  ...
>
Yes. but if we allow any combinations, then you'd need
u64 user_sample_regs
u64 intr_sample_regs
u64 precise_sample_regs

Note that in the case of Intel PEBS used for precise mode, there are
only a subset of the INTR registers available.

> for the register modes mask definition. Some mode combinations might be
> useless, but I think this could work.. we could always customize our
> needs with new mode ;)
>
The INTR vs. PRECISE is useful to get an idea of the skid.
The USER vs. INTR is useful to determine how we entered
the kernel in case the IP @ INTR is in the kernel.

> I'll start to work on this unless I hear some screaming ;)
>

In any case, the important issue is how does the kernel
satisfy the request for registers when those  may not
be available in the interrupt task AND it is impossible
to know this in advance.

Note that in the case of precise on Intel, we know in advance
which registers will be available. So you can fail early, when
the event is created.

The alternative is to include the bitmask of which registers
was actually saved at the beginning of the section after the
ABI type flag.


> thoughts? ;)
>
>
> thanks and sorry for long email,
> jirka
