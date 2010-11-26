Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755201Ab0KZSFW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Nov 2010 13:05:22 -0500
Received: from smtp-out.google.com ([216.239.44.51]:17227 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754250Ab0KZSFV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Nov 2010 13:05:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=I2ZnIfvOyrBIJIqifRnJcAFswGKbOB6Gvo1Rc+SHhl94pO5oqLJNb9KULyXbxQqXlC
         NgJ10swh0MpgJUQZC1YQ==
MIME-Version: 1.0
In-Reply-To: <20101126171642.GB5620@lenovo>
References: <AANLkTimOY=58aW0OsWhTRjc5tgxNApKpReNh0hwK7SJJ@mail.gmail.com>
	<AANLkTikWB0TbCO1JLCtk03HAV0qEj63fPZ+rzViAZJS4@mail.gmail.com>
	<AANLkTik1R-4kvoE81oqTrSm6RZdO005kL_xfbqfyrnFm@mail.gmail.com>
	<AANLkTi=1nxsKR2e9MAEzbPNt66TUD9Ltd+ug+C7Jhk+Y@mail.gmail.com>
	<AANLkTin63X+2pOuRYHF0ntnB95g-MWjug-sUYAFGFnxa@mail.gmail.com>
	<AANLkTikG9swqOxF2GwhvKY__Lbgt1+GgRfra-+DrBsk0@mail.gmail.com>
	<AANLkTi=jLNwKOqUKay9c9aLVd_7do5n1iCYEUkOfS7G+@mail.gmail.com>
	<AANLkTintEs9oM+UDzjymAMGfiYCBxPeEtY-NHA55s-Ge@mail.gmail.com>
	<20101126152744.GA5620@lenovo>
	<AANLkTikezMvVLD5vkB6OuLtPOMF1JZRyai09uhoWu=0n@mail.gmail.com>
	<20101126171642.GB5620@lenovo>
Date: Fri, 26 Nov 2010 19:05:17 +0100
Message-ID: <AANLkTi=3BqbTkn90s_fhs0v0tp04SCKTHR2XO1qrrjkW@mail.gmail.com>
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

On Fri, Nov 26, 2010 at 6:16 PM, Cyrill Gorcunov <gorcunov@gmail.com> wrote:
> On Fri, Nov 26, 2010 at 05:22:51PM +0100, Stephane Eranian wrote:
>> On Fri, Nov 26, 2010 at 4:27 PM, Cyrill Gorcunov <gorcunov@gmail.com> wrote:
>> > On Fri, Nov 26, 2010 at 02:54:39PM +0100, Stephane Eranian wrote:
>> > ...
>> >> >
>> >> > No, single thread mode means _any_ single thread is running,
>> >> > Stephane I'll describe some more a bit later (as only reach home),
>> >> > ok?
>> >>
>> >> From the manual:
>> >>
>> >> 00 — None. Count only when neither logical processor is active.
>> >> 01 — Single. Count only when one logical processor is active (either 0 or 1).
>> >> 10 — Both. Count only when both logical processors are active.
>> >> 11 — Any. Count when either logical processor is active.
>> >>
>> >> In per-thread mode, you won't hit 00. I suspect you want to
>> >> disallow 01, 10 (or CAP_SYS_ADMIN). Otherwise, you want
>> >> to force 11, i.e., can't figure out what's going on in the other
>> >> HT thread.
>> >>
>> >
>> >  No ;) The key moment here that this flags are related to _activity_ of
>> > logical thread and I guess they were introduced just to allow measuring
>> > if user-space application does win from using HT or not (since for
>> > some loads the HT simply drops the perfomance).
>> >
>>
>> I think what they call 'logical CPU' is what the kernel calls CPU.
>
> yes
>> So I think bits 16-17 are used if you want to measure on CPU0 only
>> when CPU1 (assume both share the same physical core) is active
>> or inactive or don't care. You're right that I believe this mode was
>> introduced to measure the level of concurrency between HT
>> thread (logical CPUs).
>
> but "single thread mode" measures the event if *any* thread
> is active at a time, if we would assume that your assumption
> is right -- there would be no need for T1_OS/T1_USR.
>
If not in halted state, then it means the thread is executing either
at the user or kernel level.

You can view Tx_OS/Tx_USR as a way to refine the level at which
you want to measure. Of course, if Tx_OS = Tx_USR = 0, then  you
don't measure anything.


> So I must admit I'm confused, the Oprofile do things simplier --
> it just sets "thread any" ;)
>
>>
>> In architectural perfmon the .any modifier is slightly different.
>> It indicates whether you want to measure only yourself or both
>> threads (regardless of the state of the other HT thread). In other
>> words, it is not because .any=1 that the event counts ONLY when
>> both threads (logical CPUs) are active.
>>
> ...
>
>  Stephane, could you do a test? We need a pinned event which would be
> running on say cpu0 only and if you set P4_CCCR_THREAD_SINGLE in CCCR
> and event would be still incrementing -- this mean my theory is correct
> and this "thread" field means "when" to count, if not -- you're right
> and "thread" field means "where" instead.
>

I think we both agree that active_threads determines when to count
in your thread based on what is going on in the other thread. It does
not allow you to directly count the activity in the other thread (unlike
.any).

Imagine you measure function foo() at 10k instr retired when running
with HT off. You run the same function with HT on and set the mode to
10 (only when both). If you get a lower count, it means there was
nothing going on on the other thread. If you get the same, then it
means the other thread was busy all along. If you set it to 01 instead
and get the same count, then you know the other thread was idle all
along.

The question is: does this present a security issue? Can you infer
something about what is going on in the other thread. It is clear
you can figure out when it did run or not. Is that any different
than running top? I suspect not, so I think what you have is
probably okay.
