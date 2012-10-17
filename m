Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756558Ab2JQKog (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 06:44:36 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:40158 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752773Ab2JQKoe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 06:44:34 -0400
MIME-Version: 1.0
In-Reply-To: <20121015150204.6f837a39.akpm@linux-foundation.org>
References: <BD54883EA7DE8B41A61B7E723561C711139F75D348@sc-vexch3.marvell.com>
	<CAE-am1NFB+opbid_f7RA_9EXUKjPCJssdOcZBrEQmQHG4EP9Gg@mail.gmail.com>
	<20121015150204.6f837a39.akpm@linux-foundation.org>
Date: Wed, 17 Oct 2012 18:44:32 +0800
Message-ID: <CAE-am1OY8Tjv6a004-NfhEe1DXTGcFC6ogVAmtVdESW8sZ_R4w@mail.gmail.com>
Subject: Re: [PATCH] panic: fix incomplete panic log in panic()
From: Qing Z <njumical@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mingo@kernel.org, ben@decadent.org.uk, markivx@codeaurora.org,
        ak@linux.intel.com, linux-kernel@vger.kernel.org, cxie4@marvell.com,
        binw@marvell.com, wwang27@marvell.com, xjian@marvell.com,
        zhangwm@marvell.com, Qing Zhu <qzhu@marvell.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/10/16 Andrew Morton <akpm@linux-foundation.org>:
> On Mon, 15 Oct 2012 19:38:46 +0800
> Qing Z <njumical@gmail.com> wrote:
>
>> >>       atomic_notifier_call_chain(&panic_notifier_list, 0, buf);
>> >>
>> >> +     /*
>> >> +      * Unlock the console anyway here, in case it's occupied by another
>> >> +      * one which has no chance to unlock the console thus prevents the
>> >> +      * panic log prints on the console.
>> >> +      */
>> >> +     console_unlock();
>> >> +
>> >>       bust_spinlocks(0);
>> >>
>> >>       if (!panic_blink)
>> >
>> > hm.  console_unlock() does a large amount of work, and it seems risky
>> > to do all of that when the system is in a bad-and-getting-worse state.
>> >
>> > Is there some more modest thing we could do here, for example,
>> >
>> >         if (console_locked) {
>> >                 up(&console_sem);
>> >                 console_locked = 0;
>> >         }
>> >
>> > or something along those lines?
>> >
>> > Also, perhaps this operation should be moved into bust_spinlocks().
>> > What would have happened if your code had triggered an oops, rather
>> > than called panic()?
>> >
>> >
>> Hi Andrew,
>>       Thanks for your reply!
>>       For your question" What would have happened if your code had
>> triggered an oops, rather than called panic()?", actually we found the
>> issue when trigger an oops. When we call FBIOPAN_DISPLAY in
>> ./drivers/video/fbmem.c, it will first lock console, if we trigger an
>> oops before unlock console, the issue happen. It also exist when call
>> panic() directly in the same case. It is a common issue for panic
>> process.
>>       I have two options for solution:
>>       1. I agree with your suggestion that add some modest thing in
>> bust_spinlocks(), bust_spinlocks() is supposed to clear spinlocks
>> which prevent oops information from reaching the user. But it didn't
>> clear console_sem. We can add codes that clear console_sem.
>>       1) add up(&console_sem) in bust_spinlocks(0).
>>               It will be risky in case that no printk after bust_spinlocks(0) in
>> panic(), because no console_unlock() to print log out.
>>       2) call console_unlock()in bust_spinlocks(0).
>>               For bust_spinlocks(0), console_unblank() is used to flush oops to
>> mtdoops console(commit: b61312d353da1871778711040464b10f5cd904df).
>> Logically, if panic without the issue, console_unlock is called after
>> couples of console_lock and console_unlock; if panic with the issue,
>> will it be risky call console_unlock() in console_unblank() after
>> console_lock()?
>>       2. Moreover, there is another option. We can also add protect codes
>> in vprintk(), vprintk() just cover the cases that two cores' log
>> interleave when panic and printk recurse itself. We can add all cases'
>> protection here. Actually the original vprintk() don___t have the issue,
>> but after the patch(commit: fe21773d655c2c64641ec2cef499289ea175c817)
>> which fix two cores' log interleave issue , the issue is not covered.
>> I add a flag after panic_smp_self_stop() in panic(), and check the
>> flag, if flag is set, vprintk will call zap_locks(), I have tested the
>> option, the issue also disappear.
>>       What do you think?
>
> The #1 priority is to get the oops message reliably delivered.
>
> That means we should avoid console_unlock() on the oops path: it's far
> too complicated and risks deadlocks, re-oopses, recursion, etc.
>
> If there was text queued in the console layer and that text fails to be
> emitted, well, that's sad, but it's more important that the oops
> message be displayed.
>
> If the oops trace is occasionally interleaved with other text then
> that's sad too, but at least the info we need is readable.  Oopses
> inside console_lock() are rare.
>
>
> So I'd suggest that the code in bust_spinlocks(1) should simply do
> whatever needs to be done to make the forthcoming oops trace be
> visible, and leave it at that - don't bother trying to flush out any
> old text.
>
>
> Also, we should be careful with things like up() on a semaphore which
> hasn't been down()ed.  Because under some Kconfig combinations, such an
> operation might trigger debugging traces and we could get into a big
> mess.  (An up() on non-down()ed semaphore is actually an OK operation,
> so this was a bad example.  But you see the problem).
>
Hi Andrew,
        Thanks for your suggestions.
         I am e newbie, may not state the issue clearly. Let me state it again:
         In ./drivers/video/fbmem.c, codes below cause issues:
	
                            case FBIOPAN_DISPLAY:
			...
			console_lock();
			ret = fb_pan_display(info, &var);
			console_unlock();
			...
			break;

issue case 1:
1. core 0 call console_lock();
2. panic;
...
4. panic process done.
Result: all panic log won't be printed.

issue case 2:
1. core 0 panic;
2. core 1 call console_lock();
3. core 0 call smp_send_stop(), core1 stop;
4. core 0 panic process done.
Result: only little top part of panic log will be printed.

My soluiton according to your suggestions:

As you said, the first priority is to get oops message reliably
delivered. I think we needn't care about console_sem when panic, just
make sure we print the log imediately, so add
sema_init(&console_sem,1) in bust_spinlocks(0), just like zap_locks()
do.  It is safer than console_unlock() or up().

We can't add sema_init(..) in bust_spinlocks(1) due to issue case2,
although the condition is rare. About issue case 2: should we avoid
call console_lock() when panic?

If we init console_sem in panic, old text may be flushed too, but
should be before panic oops message. Also we can fix it by updating
con_start("con_start = log_end") once panic happen, only log after
panic will be printed.


What do you think? Thanks!
