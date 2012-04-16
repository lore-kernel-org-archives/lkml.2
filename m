Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754726Ab2DPPZH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 11:25:07 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:25676 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753732Ab2DPPZF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 11:25:05 -0400
Date: Mon, 16 Apr 2012 11:17:59 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: David Vrabel <david.vrabel@citrix.com>
Cc: Jan Beulich <JBeulich@suse.com>, Thomas Gleixner <tglx@linutronix.de>,
        xen-devel <xen-devel@lists.xen.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Tim (Xen.org)" <tim@xen.org>, Sheng Yang <sheng@yasker.org>
Subject: Re: [PATCH] xen: always set the sched clock as unstable
Message-ID: <20120416151759.GI1903@phenom.dumpdata.com>
References: <1334341255-11153-1-git-send-email-david.vrabel@citrix.com>
 <4F8C1F6D020000780007E11A@nat28.tlf.novell.com>
 <4F8C33E0.2080007@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F8C33E0.2080007@citrix.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-CT-RefId: str=0001.0A090202.4F8C3955.00F6,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 16, 2012 at 03:59:44PM +0100, David Vrabel wrote:
> On 16/04/12 12:32, Jan Beulich wrote:
> >>>> On 13.04.12 at 20:20, David Vrabel <david.vrabel@citrix.com> wrote:
> >> From: David Vrabel <david.vrabel@citrix.com>
> >>
> >> The sched clock was considered stable based on the capabilities of the
> >> underlying hardware.  This does not make sense for Xen PV guests as:

In regards to PV dom0 is this still the case? Asking b/c your
patch will make dom0 be in the same category.

> >> a) the hardware TSC is not used directly as the clock source; and b)
> >> guests may migrate to hosts with different hardware capabilities.
> >>
> >> It is not clear to me whether the Xen clock source is supposed to be
> >> stable and whether it should be stable across migration.  For a clock

I thought it was dependent on XEN_DOMCTL_settscinfo:
 - whether it gets emulated, or the guest can do rdtsc or pvrdtsc?

Which I think is determined by some 'timer=X' option in the guest config?


> >> source to be stable it must be: a) monotonic; c) synchronized across
> >> CPUs; and c) constant rate.
> 
> Tim, Thomas, can you comment on the above paragraph?  Is it correct?
> 
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
> 
> David
