Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752853Ab2JOLiw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 07:38:52 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:39473 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752046Ab2JOLit convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 07:38:49 -0400
MIME-Version: 1.0
In-Reply-To: <BD54883EA7DE8B41A61B7E723561C711139F75D348@sc-vexch3.marvell.com>
References: <BD54883EA7DE8B41A61B7E723561C711139F75D348@sc-vexch3.marvell.com>
Date: Mon, 15 Oct 2012 19:38:46 +0800
Message-ID: <CAE-am1NFB+opbid_f7RA_9EXUKjPCJssdOcZBrEQmQHG4EP9Gg@mail.gmail.com>
Subject: Re: [PATCH] panic: fix incomplete panic log in panic()
From: Qing Z <njumical@gmail.com>
To: akpm@linux-foundation.org
Cc: mingo@kernel.org, ben@decadent.org.uk, markivx@codeaurora.org,
        ak@linux.intel.com, linux-kernel@vger.kernel.org, cxie4@marvell.com,
        binw@marvell.com, wwang27@marvell.com, xjian@marvell.com,
        zhangwm@marvell.com, Qing Zhu <qzhu@marvell.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Thu, 11 Oct 2012 16:03:07 +0800
> Qing Zhu <qzhu@marvell.com> wrote:
>
>> Panic log should be printed on the console, but if someone lock the
>> console when panic, console won't print out panic log.
>>
>> The incomplete panic log issue will happen in below scenarios:
>> 1. One task call console_lock(), then panic happend before it call
>> console_unlock(). No panic log can be printed.
>> 2. Cpu 0 call panic()->Cpu 1 call console_lock()->Cpu 0 call
>> smp_send_stop()
>> Cpu 1 will be stopped and can't unlock console,only top part of panic log
>> will be printed.
>>
>> So unlock console anyway in panic() to keep panic log printed.
>>
>> Signed-off-by: Qing Zhu <qzhu@marvell.com>
>> ---
>>  kernel/panic.c |    8 ++++++++
>>  1 files changed, 8 insertions(+), 0 deletions(-)
>>
>> diff --git a/kernel/panic.c b/kernel/panic.c
>> index e1b2822..3924d25 100644
>> --- a/kernel/panic.c
>> +++ b/kernel/panic.c
>> @@ -23,6 +23,7 @@
>>  #include <linux/init.h>
>>  #include <linux/nmi.h>
>>  #include <linux/dmi.h>
>> +#include <linux/console.h>
>>
>>  #define PANIC_TIMER_STEP 100
>>  #define PANIC_BLINK_SPD 18
>> @@ -127,6 +128,13 @@ void panic(const char *fmt, ...)
>>
>>       atomic_notifier_call_chain(&panic_notifier_list, 0, buf);
>>
>> +     /*
>> +      * Unlock the console anyway here, in case it's occupied by another
>> +      * one which has no chance to unlock the console thus prevents the
>> +      * panic log prints on the console.
>> +      */
>> +     console_unlock();
>> +
>>       bust_spinlocks(0);
>>
>>       if (!panic_blink)
>
> hm.  console_unlock() does a large amount of work, and it seems risky
> to do all of that when the system is in a bad-and-getting-worse state.
>
> Is there some more modest thing we could do here, for example,
>
>         if (console_locked) {
>                 up(&console_sem);
>                 console_locked = 0;
>         }
>
> or something along those lines?
>
> Also, perhaps this operation should be moved into bust_spinlocks().
> What would have happened if your code had triggered an oops, rather
> than called panic()?
>
>
Hi Andrew,
	Thanks for your reply!
	For your question" What would have happened if your code had
triggered an oops, rather than called panic()?", actually we found the
issue when trigger an oops. When we call FBIOPAN_DISPLAY in
./drivers/video/fbmem.c, it will first lock console, if we trigger an
oops before unlock console, the issue happen. It also exist when call
panic() directly in the same case. It is a common issue for panic
process.
	I have two options for solution:
	1. I agree with your suggestion that add some modest thing in
bust_spinlocks(), bust_spinlocks() is supposed to clear spinlocks
which prevent oops information from reaching the user. But it didn't
clear console_sem. We can add codes that clear console_sem.
	1) add up(&console_sem) in bust_spinlocks(0).
		It will be risky in case that no printk after bust_spinlocks(0) in
panic(), because no console_unlock() to print log out.
	2) call console_unlock()in bust_spinlocks(0).
		For bust_spinlocks(0), console_unblank() is used to flush oops to
mtdoops console(commit: b61312d353da1871778711040464b10f5cd904df).
Logically, if panic without the issue, console_unlock is called after
couples of console_lock and console_unlock; if panic with the issue,
will it be risky call console_unlock() in console_unblank() after
console_lock()?
	2. Moreover, there is another option. We can also add protect codes
in vprintk(), vprintk() just cover the cases that two cores' log
interleave when panic and printk recurse itself. We can add all cases'
protection here. Actually the original vprintk() don’t have the issue,
but after the patch(commit: fe21773d655c2c64641ec2cef499289ea175c817)
which fix two cores' log interleave issue , the issue is not covered.
I add a flag after panic_smp_self_stop() in panic(), and check the
flag, if flag is set, vprintk will call zap_locks(), I have tested the
option, the issue also disappear.
	What do you think?
