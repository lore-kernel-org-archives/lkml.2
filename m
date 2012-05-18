Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030789Ab2ERJ0X (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 05:26:23 -0400
Received: from smtprelay04.ispgateway.de ([80.67.31.32]:58382 "EHLO
	smtprelay04.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761211Ab2ERJ0W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 05:26:22 -0400
Message-ID: <4FB615A1.1090203@ladisch.de>
Date: Fri, 18 May 2012 11:25:53 +0200
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: KwongYuan Wong <wong.kwongyuan@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: a volatile related bug in kernel/timer.c ?
References: <CA++uP6MrvbaaBg3iCZDwYFTQdujPHaKYhAC5FFt+r9M_J-AJ_Q@mail.gmail.com>
In-Reply-To: <CA++uP6MrvbaaBg3iCZDwYFTQdujPHaKYhAC5FFt+r9M_J-AJ_Q@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Df-Sender: bGludXgta2VybmVsQGNsLmRvbWFpbmZhY3Rvcnkta3VuZGUuZGU=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KwongYuan Wong wrote:
>   in the function "del_timer" in kernel/timer.c, there is the following code
>
> 954  if (timer_pending(timer)) {
> 955    base = lock_timer_base(timer, &flags);
> 956    if (timer_pending(timer)) {
>
> suppose timer_pending(timer) check in line 954 is A, and in line 956 is B.
>
> because the timer_pending(timer) check is very simple, so the result
> may be saved in a register, and that register is reused
> by both A and B.  While this should be wrong? the check at B should
> reload the value from memory instead of using previous
> result kept in register,  because lock_timer_base may have side-effect
> which change the result of time_pending?
>
> so I guess a barrier() is needed, so that the code should be the following?
>
> if (timer_pending(timer)) {
>   base = lock_timer_base(timer, &flags);
>   barrier();
>   if (timer_pending(timer)) {

The spin_lock_irqsave() in lock_timer_base() already implies a barrier.
(Well, if it's written correctly.)

> in my chip, the generated assembly is like the following:
> ( the function "lock_timer_base" in inlined also)
>
> 1035         __raw_local_irq_save $7

This is not the arch_spin_lock() code I see in my copy of
arch/mips/include/asm/spinlock.h.


Regards,
Clemens
