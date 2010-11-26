Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755201Ab0KZQW6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Nov 2010 11:22:58 -0500
Received: from smtp-out.google.com ([216.239.44.51]:21051 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751557Ab0KZQW5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Nov 2010 11:22:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=dKIukQjR75jzGpmnst2uKRwMSl4RFef/lKL/rfwHgW2j+TfIY3VYsaXLV8eHl7foiw
         q3f7KmS74Z2nl3fW354w==
MIME-Version: 1.0
In-Reply-To: <20101126152744.GA5620@lenovo>
References: <AANLkTikjfM=8xa8smgT6D_WTYC_S-JZ69iiqu8gD21sK@mail.gmail.com>
	<AANLkTin1Q0eo4mFbSCeO4RNrK8Men0Q3r_x9_dCse11Q@mail.gmail.com>
	<AANLkTimOY=58aW0OsWhTRjc5tgxNApKpReNh0hwK7SJJ@mail.gmail.com>
	<AANLkTikWB0TbCO1JLCtk03HAV0qEj63fPZ+rzViAZJS4@mail.gmail.com>
	<AANLkTik1R-4kvoE81oqTrSm6RZdO005kL_xfbqfyrnFm@mail.gmail.com>
	<AANLkTi=1nxsKR2e9MAEzbPNt66TUD9Ltd+ug+C7Jhk+Y@mail.gmail.com>
	<AANLkTin63X+2pOuRYHF0ntnB95g-MWjug-sUYAFGFnxa@mail.gmail.com>
	<AANLkTikG9swqOxF2GwhvKY__Lbgt1+GgRfra-+DrBsk0@mail.gmail.com>
	<AANLkTi=jLNwKOqUKay9c9aLVd_7do5n1iCYEUkOfS7G+@mail.gmail.com>
	<AANLkTintEs9oM+UDzjymAMGfiYCBxPeEtY-NHA55s-Ge@mail.gmail.com>
	<20101126152744.GA5620@lenovo>
Date: Fri, 26 Nov 2010 17:22:51 +0100
Message-ID: <AANLkTikezMvVLD5vkB6OuLtPOMF1JZRyai09uhoWu=0n@mail.gmail.com>
Subject: Re: [rfc 1/3] perf, x86: P4 PMU - describe config format
From: Stephane Eranian <eranian@google.com>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
        ming.m.lin@intel.com, peterz@infradead.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 26, 2010 at 4:27 PM, Cyrill Gorcunov <gorcunov@gmail.com> wrote:
> On Fri, Nov 26, 2010 at 02:54:39PM +0100, Stephane Eranian wrote:
> ...
>> >
>> > No, single thread mode means _any_ single thread is running,
>> > Stephane I'll describe some more a bit later (as only reach home),
>> > ok?
>>
>> From the manual:
>>
>> 00 — None. Count only when neither logical processor is active.
>> 01 — Single. Count only when one logical processor is active (either 0 or 1).
>> 10 — Both. Count only when both logical processors are active.
>> 11 — Any. Count when either logical processor is active.
>>
>> In per-thread mode, you won't hit 00. I suspect you want to
>> disallow 01, 10 (or CAP_SYS_ADMIN). Otherwise, you want
>> to force 11, i.e., can't figure out what's going on in the other
>> HT thread.
>>
>
>  No ;) The key moment here that this flags are related to _activity_ of
> logical thread and I guess they were introduced just to allow measuring
> if user-space application does win from using HT or not (since for
> some loads the HT simply drops the perfomance).
>

I think what they call 'logical CPU' is what the kernel calls CPU.
So I think bits 16-17 are used if you want to measure on CPU0 only
when CPU1 (assume both share the same physical core) is active
or inactive or don't care. You're right that I believe this mode was
introduced to measure the level of concurrency between HT
thread (logical CPUs).

In architectural perfmon the .any modifier is slightly different.
It indicates whether you want to measure only yourself or both
threads (regardless of the state of the other HT thread). In other
words, it is not because .any=1 that the event counts ONLY when
both threads (logical CPUs) are active.



>  But I guess what you have in mind is actually set in ESCR register --
> flags T0/1_USR, T0/1_OS. And these bits are controlled by kernel and

That's different, yes.

> "measurement" of events happening on another thread is simply not
> allowed, though you still can set on which CPL level measure the event
> by 'exclude_kernel','exclude_user' config attributes.
>
But CPL is orthogonal to CPUs.

>  Though there are still events which are "shared" across threads,
> so such events will need CAP_SYS_ADMIN permission.
>
That's a different event category. I think this is yet a different problem.

Bit 16-17 apply to any event.

>  Here is what I've put in comments while were touching this code.
>
>        /*
>         * NOTE: P4_CCCR_THREAD_ANY has not the same meaning as
>         * in Architectural Performance Monitoring, it means not
>         * on _which_ logical cpu to count but rather _when_, ie it
>         * depends on logical cpu state -- count event if one cpu active,
>         * none, both or any, so we just allow user to pass any value
>         * desired.
>         *
>         * In turn we always set Tx_OS/Tx_USR bits bound to logical
>         * cpu without their propagation to another cpu
>         */
>
>        /*
>         * if an event is shared accross the logical threads
>         * the user needs special permissions to be able to use it
>         */
>        if (p4_event_bind_map[v].shared) {
>                if (perf_paranoid_cpu() && !capable(CAP_SYS_ADMIN))
>                        return -EACCES;
>        }
>
>  Cyrill
>
