Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753535Ab2CKQ5q (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Mar 2012 12:57:46 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:46880 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753506Ab2CKQ5N convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Mar 2012 12:57:13 -0400
MIME-Version: 1.0
In-Reply-To: <20120311164243.GE13336@n2100.arm.linux.org.uk>
References: <1331471665-22226-1-git-send-email-santoshprasadnayak@gmail.com>
	<20120311132746.GA13336@n2100.arm.linux.org.uk>
	<CAOD=uF7kQHABCmxUL3-J-hZ1E2mXrb7dgsYq7msHhiPJ4Gm-Ew@mail.gmail.com>
	<20120311143615.GB13336@n2100.arm.linux.org.uk>
	<CAOD=uF5GbsyHS5iXjJ1YcqJyGLHwT8Wjhiie1daJAVqu527Umg@mail.gmail.com>
	<20120311150311.GC13336@n2100.arm.linux.org.uk>
	<CAOD=uF5F4tOG0Y2tZdDeMgqs4-46HXYzA3RR-t8KuNuYRarJbg@mail.gmail.com>
	<20120311154846.GD13336@n2100.arm.linux.org.uk>
	<CAOD=uF6OtpX-1eoJB3X5ZywNUeU2_-tsE+Ksu33ZFXqoxVK_aQ@mail.gmail.com>
	<20120311164243.GE13336@n2100.arm.linux.org.uk>
Date: Sun, 11 Mar 2012 22:27:12 +0530
Message-ID: <CAOD=uF6sckygJf+76jY65N1-0BSD4E6VYf0KcZAQpyNmtxi_+A@mail.gmail.com>
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

Russel,

Is this what you want ?

 static inline void clcdfb_sleep(unsigned int ms)
 {
-       if (in_atomic()) {
                mdelay(ms);
-       } else {
-               msleep(ms);
-       }
 }



Regards
Santosh

On Sun, Mar 11, 2012 at 10:12 PM, Russell King - ARM Linux
<linux@arm.linux.org.uk> wrote:
> On Sun, Mar 11, 2012 at 10:07:18PM +0530, santosh prasad nayak wrote:
>> On Sun, Mar 11, 2012 at 9:18 PM, Russell King - ARM Linux
>> <linux@arm.linux.org.uk> wrote:
>> > On Sun, Mar 11, 2012 at 08:49:27PM +0530, santosh prasad nayak wrote:
>> >> On Sun, Mar 11, 2012 at 8:33 PM, Russell King - ARM Linux
>> >> <linux@arm.linux.org.uk> wrote:
>> >> > in_interrupt() won't tell us if we're being called with spinlocks held,
>> >> > which _is_ a possibility because this can be called from printk(), for
>> >> > oops dumps and the like.
>> >> >
>> >> > in_interrupt() just means that we're inside a hard or soft interrupt,
>> >> > or nmi.  It says nothing about whether msleep() is possible.
>> >>
>> >>
>> >> in_atomic() is also not  error free.  I found following comment in
>> >> include/linux/hardirq.h.  How do you handle it in non-preemptible
>> >> kernel ?
>> >>
>> >> /*
>> >>  * Are we running in atomic context?  WARNING: this macro cannot
>> >>  * always detect atomic context; in particular, it cannot know about
>> >>  * held spinlocks in non-preemptible kernels.  Thus it should not be
>> >>  * used in the general case to determine whether sleeping is possible.
>> >>  * Do not use in_atomic() in driver code.
>> >>  */
>> >> #define in_atomic()     ((preempt_count() & ~PREEMPT_ACTIVE) != 0)
>> >
>> > That may be, but the fact of the matter is that no one has *ever*
>> > reported an incident where this has failed at this point - and when
>> > it does people will end up with a might_sleep() warning from msleep().
>> >
>> > Maybe those who are saying people should not use this should instead
>> > be analysing why people use this, and suggest an alternative solution
>> > to the problem instead of a basic and uninformative "you shouldn't use
>> > this" statement.
>>
>> The reason is given in the article.
>
> At this point I'm just going to restate what I said above and below, so
> I'm not even going to bother doing that, and instead just say that.  I'm
> not arguing whether it's right or wrong.  I'm just stating that the only
> solution I see is to get rid of msleep() in there entirely.
>
>> http://lwn.net/Articles/274695/
>>
>> "The in_atomic() macro works by checking whether preemption is
>> disabled, which seems like the right thing to do. Handlers for events
>> like hardware interrupts will disable preemption, but so will the
>> acquisition of a spinlock. So this test appears to catch all of the
>> cases where sleeping would be a bad idea. Certainly a number of people
>> who have looked at this macro have come to that conclusion.
>>
>> But if preemption has not been configured into the kernel in the first
>> place, the kernel does not raise the "preemption count" when spinlocks
>> are acquired. So, in this situation (which is common - many
>> distributors still do not enable preemption in their kernels),
>> in_atomic() has no way to know if the calling code holds any spinlocks
>> or not. So it will return zero (indicating process context) even when
>> spinlocks are held. And that could lead to kernel code thinking that
>> it is running in process context (and acting accordingly) when, in
>> fact, it is not."
>>
>>
>>
>>
>> regards
>> Santosh
>> >
>> > As I've said, if we aren't going to use this, then the only solution is
>> > to completely omit the msleep() there and just say "sod you to running
>> > anything else for 20ms while this driver busy-spins."  That's
>> > ultimately the safe thing to do, and at the moment I see no other
>> > alternative there.
