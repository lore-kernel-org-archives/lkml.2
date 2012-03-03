Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752948Ab2CCKow (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Mar 2012 05:44:52 -0500
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:37230 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750880Ab2CCKov convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Mar 2012 05:44:51 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of kernel.org.gnu@gmail.com designates 10.112.101.40 as permitted sender) smtp.mail=kernel.org.gnu@gmail.com; dkim=pass header.i=kernel.org.gnu@gmail.com
MIME-Version: 1.0
In-Reply-To: <201203021522.10518.arnd@arndb.de>
References: <CA+U0gVhRUv_dWkO2yntsLvG_L727c=0zrVRkN_ceiPUwoAGbBg@mail.gmail.com>
	<201203021522.10518.arnd@arndb.de>
Date: Sat, 3 Mar 2012 18:44:49 +0800
Message-ID: <CA+U0gVjpRBVc_wPVJsdCY6H-A2wVkQxj66TUxfOJmjB3hdcVBQ@mail.gmail.com>
Subject: Re: [PATCH] <down,down_interruptible...>, kernel <3.2.9>
From: Dennis Chen <kernel.org.gnu@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 2, 2012 at 11:22 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Friday 02 March 2012, Dennis Chen wrote:
>> Current down family functions use mismatch spin_lock pairs, this will
>> incur some interrupt state chaos, for example,
>> down_interruptible --
>>      spin_lock_irqsave(&sem->lock, flags);              P1
>>            __down_common--
>>                  spin_unlock_irq(&sem->lock);              P2
>>                 timeout = schedule_timeout(timeout);
>>                 spin_lock_irq(&sem->lock);                  P3
>>
>>      spin_unlock_irqrestore(&sem->lock, flags);       P4
>>
>> Suppose 2 kernel thread A and B in an UP system call
>> down_interruptible to get the semaphore, if the irq is OFF before A
>> calls, in the section between P2 and P3,  the irq will be turned _ON_,
>> then B begins to call down_interruptible, it will save a flag
>> indicating irq is _ON_. So after A finish the path of
>> down_interruptible, the irq is still _OFF_, but when B wakes up and
>> finish the path, the irq will be _ON_. Actually, irq should be in on
>> state before any down_interruptible calling, so
>> spin_lock_irqsave/irqrestore is not necessary. Given it will make
>> confusion for the reason of unmatched spin_lock pairs between
>> down_interruptible and __down_common, so it's reason for the patch.
>> Any comments?
>
> You are right that the spin_lock_irqsave is unnecessary because
> down() can only be called in non-atomic state with interrupts enabled.
> Your patch will be tiny performance improvement on architectures where
> saving the interrupt state does not come for free.
>
> However, there is nothing in the code where we can end up with an
> unexpected state, because both threads have their own copy of the
> 'flags' variable, which always contains the enabled state that gets
> restored upon leaving the functions.
>
>        Arnd

Arnd, thanks for the clarification. It's the truth that every thread
has its own copy of 'flags', so if the down() can only be called with
interrupts enabled, that's ok for the code as the way.

        Dennis
