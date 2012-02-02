Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754692Ab2BBIRH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 03:17:07 -0500
Received: from exprod5og103.obsmtp.com ([64.18.0.145]:40472 "EHLO
	exprod5og103.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754409Ab2BBIRF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 03:17:05 -0500
MIME-Version: 1.0
In-Reply-To: <20120201145802.GF5650@redhat.com>
References: <CAOwKts8zS1rYA+Y4k-vb8YAaR=aFd1BwryhhWWnWLQyrYrNqyA@mail.gmail.com>
	<20120131154748.GA5650@redhat.com>
	<CAOwKts_dTvc4LiCZUXN9oYzty1pkDEn_VQwPKY=EoVzk0n6tFA@mail.gmail.com>
	<20120201145802.GF5650@redhat.com>
Date: Thu, 2 Feb 2012 16:17:02 +0800
Message-ID: <CAOwKts8S0EkUGcP3rYqZe+HdvyXD0+SR1f_3xWpu5FprKWuGhQ@mail.gmail.com>
Subject: Re: In many cases softlockup can not be reported after disabling IRQ
 for long time
From: TAO HU <tghk48@motorola.com>
To: Don Zickus <dzickus@redhat.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        linux-arm-kernel@lists.infradead.org,
        linux-omap <linux-omap@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Don

My concern is not actually that the softlockup could not be reported
while the IRQ is disabled.
What bothering me is that even AFTER re-enable the IRQ, it will not
give warning in many cases.

In theory, disabling IRQ for long time (10s in my case) also implies
the high priority thread (watchdog) is blocked
as well.
So the ideal case is that softlockup driver could give warning right
after the IRQ is re-enabled.
It does so occasionally but fails to be consistent.


On Wed, Feb 1, 2012 at 10:58 PM, Don Zickus <dzickus@redhat.com> wrote:
> On Wed, Feb 01, 2012 at 10:18:09AM +0800, TAO HU wrote:
>> Hi, Don
>>
>> Thanks for your feedback!
>>
>> Unfortunately, the hardlockup depends on NMI which is not available on
>> ARM (Cortex-A9) per my understanding.
>> Our system uses OMAP4430. Any more suggestions?
>
> Ah.  I wrongly assumed this is x86. Sorry about that.
>
> Ok, so this is what is going on.  The softlockup check is just a high
> priority thread that periodically runs.  If preemption is disabled that
> thread can't run (or any threads for that matter) and a softlockup
> condition will exist.  However, in order to determine that, a periodic
> hrtimer has to come along and do the actual check.
>
> If that check fails, then the warning is printed out.  However that
> accuracy is based on the resolution of that hrtimer which I set to about
> 1/5 the watchdog threshold or 1 second in this case.
>
> Unfortunately, if you disable the irqs, then that timer can't fire and now
> we don't have a way to trigger the softlockup check until interrupts are
> re-enabled.
>
> On x86, we have a backup plan for disabled interrupts and that is the
> hardlockup check which rely on NMIs (something that still fires even when
> interrupts are disabled).
>
> If on ARM you don't have NMIs, then it will be difficult to check for
> softlockups when interrupts are disabled.  Though I do recall sparc doing
> something clever like using IRQ0 as a special purpose IRQ to emulate an
> NMI (IOW, software purposely avoided masking IRQ0).  So when an interrupt
> came in on that irq, it was never blocked and always ran based on the irq
> nesting rules.
>
> I don't know ARM well enough to give any solution for your problem, but my
> reason above is why it isn't working the way you intended.
>
> Cheers,
> Don
>
>>
>> On Tue, Jan 31, 2012 at 11:47 PM, Don Zickus <dzickus@redhat.com> wrote:
>> > On Tue, Jan 31, 2012 at 03:28:09PM +0800, TAO HU wrote:
>> >> Resend with a new subject
>> >>
>> >> On Wed, Jan 25, 2012 at 4:24 PM, TAO HU <tghk48@motorola.com> wrote:
>> >> > Hi, All
>> >> >
>> >> > While playing kernel 3.0.8 with below test code, it does NOT report
>> >> > any softlockup with 60%~70% chances.
>> >> > NOTE: the softlockup timeout is set to 10 seconds (i.e.
>> >> > watchdog_thresh=5) in my test.
>> >> > ... ...
>> >> > preempt_disable();
>> >> > local_irq_disable();
>> >> > for (i = 0; i < 20; i++)
>> >> >       mdelay(1000);
>> >> > local_irq_enable();
>> >> > preempt_enable();
>> >> > ... ...
>> >> >
>> >> > However, if I remove local_irq_disable()/local_irq_enable() it will
>> >> > report softlockup with no problem.
>> >> > I believe it is due to that after local_irq_enable()
>> >> > touch_softlockup_watchdog() is called prior softlockup timer.
>> >
>> > Hi Hu,
>> >
>> > Honestly, you should be getting hardlockup warnings if you are disabling
>> > interrupts.  Do you see anything in the console output?
>> >
>> > Cheers,
>> > Don
>>
>>
>>
>> --
>> Best Regards
>> Hu Tao



-- 
Best Regards
Hu Tao
