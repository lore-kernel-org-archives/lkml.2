Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754501Ab2B0SRt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 13:17:49 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:59340 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754391Ab2B0SRs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 13:17:48 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of venki@google.com designates 10.42.108.6 as permitted sender) smtp.mail=venki@google.com; dkim=pass header.i=venki@google.com
MIME-Version: 1.0
In-Reply-To: <1330332354.11248.32.camel@twins>
References: <1329957415-15239-1-git-send-email-venki@google.com>
	<1329989454.24994.57.camel@twins>
	<CABeCy1a0U8Hk3Yfp54M-U80t2fbPrFQw=GnNQ_V082e9VxJQow@mail.gmail.com>
	<1330332354.11248.32.camel@twins>
Date: Mon, 27 Feb 2012 10:17:47 -0800
Message-ID: <CABeCy1a4b=79=NBHoQD8oJnBawe1uN3LNkmGw-s8XG-kXhyPMQ@mail.gmail.com>
Subject: Re: [PATCH] Extend mwait idle to optimize away CAL and RES interrupts
 to an idle CPU -v1
From: Venki Pallipadi <venki@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Aaron Durbin <adurbin@google.com>, Paul Turner <pjt@google.com>,
        Yong Zhang <yong.zhang0@gmail.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 27, 2012 at 12:45 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Thu, 2012-02-23 at 11:34 -0800, Venki Pallipadi wrote:
>
>> > > +             local_bh_disable();
>> > > +             local_irq_disable();
>> >
>> > That local_bh_disable() is completely superfluous, disabling IRQs
>> > already kills bh.
>>
>> The reason for local_bh_disable/enable was to check for potential
>> softirqs after these interrupt.
>
> Why is that needed? We never wrap local_irq_disable() in bh muck?
>

For normal interrupts, we check for bh on interrutp return. For idle
loop no interrupt case, we will have to call bh handler explicitly as
otherwise we will go back to idle until need_resched().
local_bh_enable() handles this bh call here.

>> > Why doesn't ipiless_idle_exit() call this? That would keep it isolated
>> > to just those idle routines that actually use mwait instead of bothering
>> > the generic idle paths with this.
>>
>> ipiless_idle_exit is called in the inner most part of idle entry exit.
>> In mwait case we may not even have interrupts enabled at that time and
>> there is code that does idle residency timing etc which will get
>> impacted if we start doing the pending ipi work there. Doing it at
>> higher level along with things like enter-exit tickless felt nicer.
>
> But but but, an actual interrupt can be handled before the instruction
> after mwait, so why would this be a problem?
>

With most commom usage of mwait(), interrupts are disabled on entry
and exit from mwait(). There is a special flag that brings CPU out of
mwait on interrupt, without actually handling the interrupt. We do
C-state timing in acpi idle/intel idle and enable interrupts and thats
where interrupt will get handled. My concern is calling the interrupt
and bh immediatley after mwait exit will inflate C-state residency
timings.

Thanks,
Venki
