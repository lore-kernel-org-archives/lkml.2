Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967873Ab2ERJbu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 05:31:50 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:50119 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932852Ab2ERJbs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 05:31:48 -0400
Message-ID: <4FB61626.9010506@gmail.com>
Date: Fri, 18 May 2012 17:28:06 +0800
From: "WANG.Jiong" <wong.kwongyuan@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.15) Gecko/20110307 Fedora/3.1.9-0.39.b3pre.fc14 Lightning/1.0b2 Thunderbird/3.1.9
MIME-Version: 1.0
To: Clemens Ladisch <clemens@ladisch.de>
CC: linux-kernel@vger.kernel.org
Subject: Re: a volatile related bug in kernel/timer.c ?
References: <CA++uP6MrvbaaBg3iCZDwYFTQdujPHaKYhAC5FFt+r9M_J-AJ_Q@mail.gmail.com> <4FB615A1.1090203@ladisch.de>
In-Reply-To: <4FB615A1.1090203@ladisch.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/18/2012 05:25 PM, Clemens Ladisch wrote:
> KwongYuan Wong wrote:
>>   in the function "del_timer" in kernel/timer.c, there is the following code
>>
>> 954  if (timer_pending(timer)) {
>> 955    base = lock_timer_base(timer, &flags);
>> 956    if (timer_pending(timer)) {
>>
>> suppose timer_pending(timer) check in line 954 is A, and in line 956 is B.
>>
>> because the timer_pending(timer) check is very simple, so the result
>> may be saved in a register, and that register is reused
>> by both A and B.  While this should be wrong? the check at B should
>> reload the value from memory instead of using previous
>> result kept in register,  because lock_timer_base may have side-effect
>> which change the result of time_pending?
>>
>> so I guess a barrier() is needed, so that the code should be the following?
>>
>> if (timer_pending(timer)) {
>>   base = lock_timer_base(timer, &flags);
>>   barrier();
>>   if (timer_pending(timer)) {
> The spin_lock_irqsave() in lock_timer_base() already implies a barrier.
> (Well, if it's written correctly.)
>
     Clemens,

         Yes,  our "spin_lock_irqsave" are implemented wrongly, it's
without the barrier, fixed

         Thanks very much
>> in my chip, the generated assembly is like the following:
>> ( the function "lock_timer_base" in inlined also)
>>
>> 1035         __raw_local_irq_save $7
> This is not the arch_spin_lock() code I see in my copy of
> arch/mips/include/asm/spinlock.h.
>
>
> Regards,
> Clemens

