Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751043Ab0HRCsP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 22:48:15 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:38926 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750977Ab0HRCsL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 22:48:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=jTj5s+FLHRBTmaXL4EF6KHcSJ0AQ32nrFqm1Iddfhtu4BMRKG8F2gGGodB9JOlU3wh
         Wn6LwmZBReDsykO8/qBUHqsYqSVw9QiuH1DwqB3KyjZTNVrg/MV8wYk6HYbhGBI6ygYP
         H6h0dH4K14AYjWxARa84SGaVoDwQ7VkZ7GLA8=
Date: Wed, 18 Aug 2010 04:48:05 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Don Zickus <dzickus@redhat.com>, Len Brown <len.brown@intel.com>
Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Yong Zhang <yong.zhang0@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fix BUG using smp_processor_id() in touch_nmi_watchdog
	and touch_softlockup_watchdog
Message-ID: <20100818024802.GA24748@nowhere>
References: <1281966418.1926.1421.camel@laptop> <20100816140829.GA5225@swordfish.minsk.epam.com> <20100817025954.GA12366@nowhere> <AANLkTikdng247Fct0ANXiitC3ja98_ee3-fUVDGraEwo@mail.gmail.com> <20100817083945.GA12022@swordfish.minsk.epam.com> <AANLkTik-4S_=L5FLhMfommf5Umd0xO+h4QP9uoxwrgFE@mail.gmail.com> <20100817092407.GB12022@swordfish.minsk.epam.com> <AANLkTikjR1nC3DYdvSw=FEmAVZ98=ju2RNq-MF1L7U3u@mail.gmail.com> <20100817103948.GA5352@swordfish.minsk.epam.com> <20100817131320.GX4879@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100817131320.GX4879@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 17, 2010 at 09:13:20AM -0400, Don Zickus wrote:
> On Tue, Aug 17, 2010 at 01:39:48PM +0300, Sergey Senozhatsky wrote:
> > Please kindly review.
> 
> I don't have a deep enough understanding of the subtleties between
> per_cpu, __get_cpu_var, and __raw_get_cpu_var to really say which is
> correct.  To me, all three versions of your patch look they do the same
> thing.
> 
> Technically, it seems like preempt_disable/enable would be the correct
> thing to do.  But as someone pointed out earlier, if the code is preempted
> and switches cpu, then the touch_*_watchdog effectively becomes a no-op
> (which I guess it can do even with the preempt_disable/enable surrounding
> it).  So I have no idea.  I am going to wait for smarter people than me to
> provide an opinion. :-)
> 
> Cheers,
> Don


(Adding Len Brown in Cc.

Len, this is about acpi_os_stall() that touches the watchdog while
running in a preemptable section, this triggers warnings because of
the use of local cpu accessors. We are debating about the appropriate
way to solve this).

The more I think about it, the more I think that doesn't make sense
to have touch_nmi_watchdog() callable from preemptable code.

It is buggy by nature.

If you run in a preemptable section, then interrupts can fire, and if
they can, the nmi watchdog is fine and doesn't need to be touched.

Here the problem is more in the softlockup watchdog, because even if you
run in a preemptable section, if you run a !CONFIG_PREEMPT kernel, then
you can't be preempted and the watchdog won't be scheduled until the
udelay loop finishes. But to solve that you would need cond_resched()
calls, not touching the watchdog.

Because touching the softlockup watchdog doesn't make sense either
if you can migrate: you can run the udelay on CPU 0, then migrate on
CPU 1 and call touch_softlockup_watchdog() from there. Which makes
definetely no sense. This is buggy.

And because we want to avoid such buggy uses of the touch_whatever_watchdog()
APIs, these function must continue to check they are called from non-preemptable
code. Randomly touching the watchdog could hide real lockups to the user.

The problem is on the caller. Considering such udelays loop:

* if it's in a irq disabled section, call touch_nmi_watchdog(), because this
  could prevent the nmi watchdog irq from firing
* if it's in a non-preemptable section, call touch_softlockup_watchdog(), because
  this could prevent the softlockup watchdog task from beeing scheduled
* if it's from a preemptable task context, this should call cond_resched() to
  avoid huge latencies on !CONFIG_PREEMPT


But acpi_os_stall() seem to be called from 4 different places, and these places
may run in different context like the above described.

The ACPI code should probably use more specific busy-loop APIs, depending on the
context it runs.

