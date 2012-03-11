Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753335Ab2CKPT3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Mar 2012 11:19:29 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:48719 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753155Ab2CKPT2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Mar 2012 11:19:28 -0400
MIME-Version: 1.0
In-Reply-To: <20120311150311.GC13336@n2100.arm.linux.org.uk>
References: <1331471665-22226-1-git-send-email-santoshprasadnayak@gmail.com>
	<20120311132746.GA13336@n2100.arm.linux.org.uk>
	<CAOD=uF7kQHABCmxUL3-J-hZ1E2mXrb7dgsYq7msHhiPJ4Gm-Ew@mail.gmail.com>
	<20120311143615.GB13336@n2100.arm.linux.org.uk>
	<CAOD=uF5GbsyHS5iXjJ1YcqJyGLHwT8Wjhiie1daJAVqu527Umg@mail.gmail.com>
	<20120311150311.GC13336@n2100.arm.linux.org.uk>
Date: Sun, 11 Mar 2012 20:49:27 +0530
Message-ID: <CAOD=uF5F4tOG0Y2tZdDeMgqs4-46HXYzA3RR-t8KuNuYRarJbg@mail.gmail.com>
Subject: Re: [PATCH] Video : Amba: Use in_interrupt() in clcdfb_sleep().
From: santosh prasad nayak <santoshprasadnayak@gmail.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: FlorianSchandinat@gmx.de, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 11, 2012 at 8:33 PM, Russell King - ARM Linux
<linux@arm.linux.org.uk> wrote:
> On Sun, Mar 11, 2012 at 08:18:32PM +0530, santosh prasad nayak wrote:
>> On Sun, Mar 11, 2012 at 8:06 PM, Russell King - ARM Linux
>> <linux@arm.linux.org.uk> wrote:
>> > On Sun, Mar 11, 2012 at 07:47:27PM +0530, santosh prasad nayak wrote:
>> >> Not to use in_atomic()  in driver code.
>> >>
>> >>  Following article  inspired me to do the change.
>> >> http://lwn.net/Articles/274695/
>> >>
>> >> "in_atomic() is for core kernel use only. Because in special
>> >> circumstances (ie: kmap_atomic()) we run inc_preempt_count() even on
>> >> non-preemptible kernels to tell the per-arch fault handler that it was
>> >> invoked by copy_*_user() inside kmap_atomic(), and it must fail.
>> >> In other words, in_atomic() works in a specific low-level situation,
>> >> but it was never meant to be used in a wider context. Its placement in
>> >> hardirq.h next to macros which can be used elsewhere was, thus, almost
>> >> certainly a mistake. As Alan Stern pointed out, the fact that Linux
>> >> Device Drivers recommends the use of in_atomic() will not have helped
>> >> the situation. Your editor recommends that the authors of that book be
>> >> immediately sacked. "
>> >>
>> >> In the present case, we just check whether its an IRQ context or user
>> >> context. So for that
>> >> we can use "in_interrupt()".
>> >>
>> >> Greg also mentions the same in the following mail.
>> >> http://www.spinics.net/lists/newbies/msg43402.html
>> >
>> > In which case, we'll just have to do mdelay() and forget about allowing
>> > anything else to run for the 20ms that we need to sleep.  Sucky but
>> > that's the way things are.
>>
>>  mdelay() or msleep() are there before. I did not change that.
>>
>>
>> my point is :  in_atomic()  vs "in_interrupt()".
>> We should avoid to use "in_atomic()" in driver code.
>>
>> In the present case to check IRQ context "in_interrupt()" should be preferred.
>
> in_interrupt() won't tell us if we're being called with spinlocks held,
> which _is_ a possibility because this can be called from printk(), for
> oops dumps and the like.
>
> in_interrupt() just means that we're inside a hard or soft interrupt,
> or nmi.  It says nothing about whether msleep() is possible.


in_atomic() is also not  error free.  I found following comment in
include/linux/hardirq.h.  How do you handle it in non-preemptible
kernel ?

/*
 * Are we running in atomic context?  WARNING: this macro cannot
 * always detect atomic context; in particular, it cannot know about
 * held spinlocks in non-preemptible kernels.  Thus it should not be
 * used in the general case to determine whether sleeping is possible.
 * Do not use in_atomic() in driver code.
 */
#define in_atomic()     ((preempt_count() & ~PREEMPT_ACTIVE) != 0)



regards
Santosh
