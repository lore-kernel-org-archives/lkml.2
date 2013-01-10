Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755495Ab3AJSSL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 13:18:11 -0500
Received: from mx1.redhat.com ([209.132.183.28]:24734 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753777Ab3AJSSJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 13:18:09 -0500
Date: Thu, 10 Jan 2013 13:17:51 -0500
From: Don Zickus <dzickus@redhat.com>
To: Colin Cross <ccross@android.com>
Cc: lkml <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        liu chuansheng <chuansheng.liu@intel.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] hardlockup: detect hard lockups without NMIs using
 secondary cpus
Message-ID: <20130110181751.GR88797@redhat.com>
References: <1357783059-13923-1-git-send-email-ccross@android.com>
 <20130110140215.GP88797@redhat.com>
 <CAMbhsRT7q+DSKOdPMtUqtPZJrB_z-ixmv09TkT2ZweUJGXjkYg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMbhsRT7q+DSKOdPMtUqtPZJrB_z-ixmv09TkT2ZweUJGXjkYg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 10, 2013 at 09:27:28AM -0800, Colin Cross wrote:
> On Thu, Jan 10, 2013 at 6:02 AM, Don Zickus <dzickus@redhat.com> wrote:
> > On Wed, Jan 09, 2013 at 05:57:39PM -0800, Colin Cross wrote:
> >> Emulate NMIs on systems where they are not available by using timer
> >> interrupts on other cpus.  Each cpu will use its softlockup hrtimer
> >> to check that the next cpu is processing hrtimer interrupts by
> >> verifying that a counter is increasing.
> >>
> >> This patch is useful on systems where the hardlockup detector is not
> >> available due to a lack of NMIs, for example most ARM SoCs.
> >
> > I have seen other cpus, like Sparc I think, create a 'virtual NMI' by
> > reserving an IRQ line as 'special' (can not be masked).  Not sure if that
> > is something worth looking at here (or even possible).
> >
> >> Without this patch any cpu stuck with interrupts disabled can
> >> cause a hardware watchdog reset with no debugging information,
> >> but with this patch the kernel can detect the lockup and panic,
> >> which can result in useful debugging info.
> >
> > <SNIP>
> >> +#ifdef CONFIG_HARDLOCKUP_DETECTOR_OTHER_CPU
> >> +static int is_hardlockup_other_cpu(int cpu)
> >> +{
> >> +     unsigned long hrint = per_cpu(hrtimer_interrupts, cpu);
> >> +
> >> +     if (per_cpu(hrtimer_interrupts_saved, cpu) == hrint)
> >> +             return 1;
> >> +
> >> +     per_cpu(hrtimer_interrupts_saved, cpu) = hrint;
> >> +     return 0;
> >
> > Will this race with the other cpu you are checking?  For example if cpuA
> > just updated its hrtimer_interrupts_saved and cpuB goes to check cpuA's
> > hrtimer_interrupts_saved, it seems possible that cpuB could falsely assume
> > cpuA is stuck?
> 
> cpuA doesn't update its own hrtimer_interrupts_saved, cpuB does.
> However, there may be a similar race condition during hotplug if cpuB
> updates hrtimer_interrupts_saved for cpuA, then goes offline, then
> cpuC may try to check cpuA and see that hrtimer_interrupts_saved ==
> hrtimer_interrupts.  I think this can be solved by setting
> watchdog_nmi_touch for the next cpu when a cpu goes online or offline.

Ah, that is where my misunderstanding was.  I overlooked the fact that it
was only updated by the other cpu.  Sorry about that.

I'll re-review it again with that in mind.

Cheers,
Don
