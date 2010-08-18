Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753906Ab0HRUC2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 16:02:28 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46818 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753580Ab0HRUCY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 16:02:24 -0400
Date: Wed, 18 Aug 2010 13:01:56 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Don Zickus <dzickus@redhat.com>, Len Brown <len.brown@intel.com>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Yong Zhang <yong.zhang0@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        Andy Grover <andy.grover@oracle.com>
Subject: Re: [PATCH] fix BUG using smp_processor_id() in touch_nmi_watchdog
 and touch_softlockup_watchdog
Message-Id: <20100818130156.43a183d9.akpm@linux-foundation.org>
In-Reply-To: <20100818024802.GA24748@nowhere>
References: <1281966418.1926.1421.camel@laptop>
	<20100816140829.GA5225@swordfish.minsk.epam.com>
	<20100817025954.GA12366@nowhere>
	<AANLkTikdng247Fct0ANXiitC3ja98_ee3-fUVDGraEwo@mail.gmail.com>
	<20100817083945.GA12022@swordfish.minsk.epam.com>
	<AANLkTik-4S_=L5FLhMfommf5Umd0xO+h4QP9uoxwrgFE@mail.gmail.com>
	<20100817092407.GB12022@swordfish.minsk.epam.com>
	<AANLkTikjR1nC3DYdvSw=FEmAVZ98=ju2RNq-MF1L7U3u@mail.gmail.com>
	<20100817103948.GA5352@swordfish.minsk.epam.com>
	<20100817131320.GX4879@redhat.com>
	<20100818024802.GA24748@nowhere>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18 Aug 2010 04:48:05 +0200
Frederic Weisbecker <fweisbec@gmail.com> wrote:

> On Tue, Aug 17, 2010 at 09:13:20AM -0400, Don Zickus wrote:
> > On Tue, Aug 17, 2010 at 01:39:48PM +0300, Sergey Senozhatsky wrote:
> > > Please kindly review.
> > 
> > I don't have a deep enough understanding of the subtleties between
> > per_cpu, __get_cpu_var, and __raw_get_cpu_var to really say which is
> > correct.  To me, all three versions of your patch look they do the same
> > thing.
> > 
> > Technically, it seems like preempt_disable/enable would be the correct
> > thing to do.  But as someone pointed out earlier, if the code is preempted
> > and switches cpu, then the touch_*_watchdog effectively becomes a no-op
> > (which I guess it can do even with the preempt_disable/enable surrounding
> > it).  So I have no idea.  I am going to wait for smarter people than me to
> > provide an opinion. :-)
> > 
> > Cheers,
> > Don
> 
> 
> (Adding Len Brown in Cc.

I'm not sure who looks after osl.c.  I added linux-acpi to cc.

> Len, this is about acpi_os_stall() that touches the watchdog while
> running in a preemptable section, this triggers warnings because of
> the use of local cpu accessors. We are debating about the appropriate
> way to solve this).
> 
> The more I think about it, the more I think that doesn't make sense
> to have touch_nmi_watchdog() callable from preemptable code.
> 
> It is buggy by nature.
> 
> If you run in a preemptable section, then interrupts can fire, and if
> they can, the nmi watchdog is fine and doesn't need to be touched.
> 
> Here the problem is more in the softlockup watchdog, because even if you
> run in a preemptable section, if you run a !CONFIG_PREEMPT kernel, then
> you can't be preempted and the watchdog won't be scheduled until the
> udelay loop finishes. But to solve that you would need cond_resched()
> calls, not touching the watchdog.
> 
> Because touching the softlockup watchdog doesn't make sense either
> if you can migrate: you can run the udelay on CPU 0, then migrate on
> CPU 1 and call touch_softlockup_watchdog() from there. Which makes
> definetely no sense. This is buggy.
> 
> And because we want to avoid such buggy uses of the touch_whatever_watchdog()
> APIs, these function must continue to check they are called from non-preemptable
> code. Randomly touching the watchdog could hide real lockups to the user.
> 
> The problem is on the caller. Considering such udelays loop:
> 
> * if it's in a irq disabled section, call touch_nmi_watchdog(), because this
>   could prevent the nmi watchdog irq from firing
> * if it's in a non-preemptable section, call touch_softlockup_watchdog(), because
>   this could prevent the softlockup watchdog task from beeing scheduled
> * if it's from a preemptable task context, this should call cond_resched() to
>   avoid huge latencies on !CONFIG_PREEMPT
> 
> 
> But acpi_os_stall() seem to be called from 4 different places, and these places
> may run in different context like the above described.
> 
> The ACPI code should probably use more specific busy-loop APIs, depending on the
> context it runs.

The touch_nmi_watchdog() was added to acpi_os_stall() by little old me
in 2003.  It was committed by Andy with the patch title "ACPI:
Correctly handle NMI watchdog during long stalls (Andrew Morton)".  My
title was "ACPI poweroff trigers the NMI watchdog".  My changelog was

	ACPI poweroff trigers the NMI watchdog.  Fix.

(My spelling has improved with age).

So.  If we remove that touch, will poweroff still trigger the NMI? 
Dunno.


The surprise new requirement that touch_nmi_watchdog() be called from
non-preemptible code does seem to make sense IMO.  It's hard to see why
anyone would be touching the watchdog unless he's spinning in irqs-off
code.  Except, of course, when we have a utility function which can be
called from wither irqs-on or irqs-off: acpi_os_stall().

That being said, it's not good to introduce new API requirements by
accident!  An audit of all callers should first be performed, at least.


The surprise new requirement that touch_softlockup_watchdog() be called
from non-preemptible code doesn't make sense IMO.  If I have a piece of
code in the kernel which I expect to sit in TASK_UNINTERRUPTIBLE state
for three minutes waiting for my egg to boil, I should be able to do
that and I should be able to touch the softlockup detector without
needing to go non-preemptible.
