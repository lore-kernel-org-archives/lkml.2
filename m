Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751535Ab2DPQGK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 12:06:10 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:39262 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751163Ab2DPQGI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 12:06:08 -0400
MIME-Version: 1.0
Message-ID: <049b7b93-fb37-4962-b272-d786e1dcfacb@default>
Date: Mon, 16 Apr 2012 09:05:32 -0700 (PDT)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: David Vrabel <david.vrabel@citrix.com>, Jan Beulich <JBeulich@suse.com>
Cc: Konrad Wilk <konrad.wilk@oracle.com>, "Tim (Xen.org)" <tim@xen.org>,
        linux-kernel@vger.kernel.org, xen-devel <xen-devel@lists.xen.org>,
        Sheng Yang <sheng@yasker.org>, Thomas Gleixner <tglx@linutronix.de>
Subject: RE: [Xen-devel] [PATCH] xen: always set the sched clock as unstable
References: <1334341255-11153-1-git-send-email-david.vrabel@citrix.com>
 <4F8C1F6D020000780007E11A@nat28.tlf.novell.com> <4F8C33E0.2080007@citrix.com>
In-Reply-To: <4F8C33E0.2080007@citrix.com>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 2.0.1.6  (510070) [OL
 12.0.6607.1000 (x86)]
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
X-CT-RefId: str=0001.0A090205.4F8C435E.0078,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: David Vrabel [mailto:david.vrabel@citrix.com]
> Subject: Re: [Xen-devel] [PATCH] xen: always set the sched clock as unstable

Nacked-by: Dan Magenheimer <dan.magenheimer@oracle.com>

(Apologies for missing the original post... our Oracle mail server
has gone bonkers again... classifying nearly all (but not all) xen-devel
email as spam.  This problem started when xen.org moved to a different
ISP last year, was supposedly fixed by Oracle IT, and has just
started being a problem again. Argh!)
 
> On 16/04/12 12:32, Jan Beulich wrote:
> >>>> On 13.04.12 at 20:20, David Vrabel <david.vrabel@citrix.com> wrote:
> >> From: David Vrabel <david.vrabel@citrix.com>
> >>
> >> The sched clock was considered stable based on the capabilities of the
> >> underlying hardware.  This does not make sense for Xen PV guests as:
> >> a) the hardware TSC is not used directly as the clock source; and b)
> >> guests may migrate to hosts with different hardware capabilities.
> >>
> >> It is not clear to me whether the Xen clock source is supposed to be
> >> stable and whether it should be stable across migration.  For a clock
> >> source to be stable it must be: a) monotonic; c) synchronized across
> >> CPUs; and c) constant rate.
> 
> Tim, Thomas, can you comment on the above paragraph?  Is it correct?

(Sigh... I keep seeing clock-related things, wish I had more time
to spend on them, cursing, and going back to other things.  But,
I need to comment further here...)

Hmmm... I spent a great deal of time on TSC support in the hypervisor
2-3 years ago.  I worked primarily on PV, but Intel supposedly was tracking
everything on HVM as well.  There's most likely a bug or two still lurking
but, for all guests, with the default tsc_mode, TSC is provided by Xen
as an absolutely stable clock source.  If Xen determines that the underlying
hardware declares that TSC is stable, guest rdtsc instructions are not trapped.
If it is not, Xen emulates all guest rdtsc instructions.  After a migration or
save/restore, TSC is always emulated.  The result is (ignoring possible
bugs) that TSC as provided by Xen is a) monotonic; b) synchronized across
CPUs; and c) constant rate.  Even across migration/save/restore.

This should be true for Xen 4.0+ (but not for pre-Xen-4.0).

Please see docs/misc/tscmode.txt in the xen tree.  Though
it may appear at first to be targeted at a different audience,
all the relevant info is in there if you read it all the way through.

(If you have any questions or disagreements on that doc, please start
a new thread and cc me directly since my list access is unreliable.)
 
> >> There have also been reports of systems with apparently unstable
> >> clocks where clearing sched_clock_stable has fixed problems with
> >> migrated VMs hanging.
> >>
> >> So, always set the sched clock as unstable when using the Xen clock
> >> source.
> >>
> >> Signed-off-by: David Vrabel <david.vrabel@citrix.com>
> >> ---
> >>  arch/x86/xen/time.c |    1 +
> >>  1 files changed, 1 insertions(+), 0 deletions(-)
> >>
> >> diff --git a/arch/x86/xen/time.c b/arch/x86/xen/time.c
> >> index 0296a95..8469b5a 100644
> >> --- a/arch/x86/xen/time.c
> >> +++ b/arch/x86/xen/time.c
> >> @@ -473,6 +473,7 @@ static void __init xen_time_init(void)
> >>  	do_settimeofday(&tp);
> >>
> >>  	setup_force_cpu_cap(X86_FEATURE_TSC);
> >> +	sched_clock_stable = 0;
> >
> > This, unfortunately, is not sufficient afaict: If a CPU gets brought up
> > post-boot, the variable may need to be cleared again. Instead you
> > ought to call mark_tsc_unstable().
> 
> Yeah, mark_tsc_unstable() is the right thing to do.

NACK!

No, no, no.  The exact opposite is true.  Like VMware, TSC is
stable.  The issue is that Linux trusts other clock hardware more
completely than TSC so whenever there is a problem with another
clocksource, Linux blames TSC and marks TSC unstable.  But TSC
on Xen 4.0+ is innocent.  In fact, TSC is a better clocksource
choice than clocksource=xen (aka pvclock) because pvclock
indirectly depends on TSC.

For upstream kernels, the answer is to set clocksource=tsc
and tsc=reliable, like VMware enforces. See:

https://lists.ubuntu.com/archives/kernel-team/2008-October/004283.html 

In fact, it might be wise for a Xen-savvy kernel to check to see
if it is running on Xen-4.0+ and, if so, force clocksource=tsc
and tsc=reliable.

There have been very odd rare problems reported in Xen time
handling for a very long time.  These usually manifest as some
kind of "TSC is not stable" message from a guest Linux kernel,
but the symptoms always point away from TSC as the culprit.
Forcing Xen-savvy guests to use TSC will either make these problems
go away (if they haven't already been fixed) or allow us to find
the obscure underlying hypervisor bugs rather than paper over them.

Thanks,
Dan

P.S.  For anyone new to this areas, see VMware's classic document: http://www.vmware.com/files/pdf/Timekeeping-In-VirtualMachines.pdf 

P.P.S. note this recent kernel issue which is related, but
likely not seen in Xen... it pre-requires cpu overcommitment
at boot time when TSC is being calibrated by the kernel.

https://lkml.org/lkml/2012/2/21/518
