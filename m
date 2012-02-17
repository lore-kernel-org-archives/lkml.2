Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751001Ab2BQFCc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Feb 2012 00:02:32 -0500
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:36837 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750703Ab2BQFCb convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Feb 2012 00:02:31 -0500
MIME-Version: 1.0
In-Reply-To: <1329399124.10311.8.camel@acer.local.home>
References: <yad.naveen@gmail.com>
	<4f3cce7d.443a440a.2f15.ffffe7ff@mx.google.com>
	<1329399124.10311.8.camel@acer.local.home>
Date: Fri, 17 Feb 2012 10:32:29 +0530
Message-ID: <CAJ8eaTwxN07L4yAj5qmbrZdrpP+OEX9qXR4dX4A+sF74=MK==Q@mail.gmail.com>
Subject: Re: [PATCH] futex: fix uninitialized warning
From: naveen yadav <yad.naveen@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Darren Hart <dvhart@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks a lot Steven for your comments:

I am Building for ARM versatile Board. and
I check with gcc version gcc version 4.4.1 and gcc version 4.6.3.

If we check the code flow, we can confirm that this is fake warning ,
since value will be updated cmpxchg_futex_value_locked() function.
May be this is limitation of GCC.
So we can ignore the warning ..

Thanks.

naveen



On Thu, Feb 16, 2012 at 7:02 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> On Thu, 2012-02-16 at 15:15 +0530, yad.naveen@gmail.com wrote:
>> From: Naveen Yadav <yad.naveen@gmail.com>
>>
>>
>> Signed-off-by: Naveen Yadav <yad.naveen@gmail.com>
>> ---
>>  kernel/futex.c |    4 ++--
>>  1 files changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/kernel/futex.c b/kernel/futex.c
>> index 6487e4c..fdb93b0 100644
>> --- a/kernel/futex.c
>> +++ b/kernel/futex.c
>> @@ -1588,7 +1588,7 @@ static int fixup_pi_state_owner(u32 __user *uaddr, struct futex_q *q,
>>       u32 newtid = task_pid_vnr(newowner) | FUTEX_WAITERS;
>>       struct futex_pi_state *pi_state = q->pi_state;
>>       struct task_struct *oldowner = pi_state->owner;
>> -     u32 uval, curval, newval;
>> +     u32 uval, uninitialized_var(curval), newval;
>
> NAK, an uninitialized_var() macro should not be added unless there's a
> really good reason that gcc is not detecting it. Some logic does require
> this.
>
> If it ends up being that this macro should be added, then it should have
> a comment to why it is added, and why gcc is failing to figure out that
> it is initialized.
>
> What gcc version is complaining and what arch is this for? There could
> definitely be a case here that it may really be uninitialized, and this
> patch would hide that bug.
>
> The cmpxchg_futex_* is arch specific, and if an arch screws it up, we
> will never know that this value is uninitialized because this patch
> would have hidden that bug. Hiding a bug is much worse than dealing with
> some "might be uninitialized" warnings.
>
> -- Steve
>
>>       int ret;
>>
>>       /* Owner died? */
>> @@ -2493,7 +2493,7 @@ err_unlock:
>>   */
>>  int handle_futex_death(u32 __user *uaddr, struct task_struct *curr, int pi)
>>  {
>> -     u32 uval, nval, mval;
>> +     u32 uval, uninitialized_var(nval), mval;
>>
>>  retry:
>>       if (get_user(uval, uaddr))
>
>
