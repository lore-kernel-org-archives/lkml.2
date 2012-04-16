Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755024Ab2DPRWu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 13:22:50 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:18768 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754643Ab2DPRWt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 13:22:49 -0400
MIME-Version: 1.0
Message-ID: <84023b26-a682-44b5-990e-1635da6949ff@default>
Date: Mon, 16 Apr 2012 10:22:08 -0700 (PDT)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: Jan Beulich <JBeulich@suse.com>, David Vrabel <david.vrabel@citrix.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, xen-devel <xen-devel@lists.xen.org>,
        Konrad Wilk <konrad.wilk@oracle.com>, linux-kernel@vger.kernel.org,
        "Tim (Xen.org)" <tim@xen.org>, Sheng Yang <sheng@yasker.org>
Subject: RE: [Xen-devel] [PATCH] xen: always set the sched clock as unstable
References: <1334341255-11153-1-git-send-email-david.vrabel@citrix.com>
 <4F8C1F6D020000780007E11A@nat28.tlf.novell.com> <4F8C33E0.2080007@citrix.com>
 <049b7b93-fb37-4962-b272-d786e1dcfacb@default>
 <4F8C619C020000780007E34E@nat28.tlf.novell.com>
In-Reply-To: <4F8C619C020000780007E34E@nat28.tlf.novell.com>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 2.0.1.6  (510070) [OL
 12.0.6607.1000 (x86)]
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090202.4F8C554B.0120,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Jan Beulich [mailto:JBeulich@suse.com]
> Subject: RE: [Xen-devel] [PATCH] xen: always set the sched clock as unstable
> 
> >>> On 16.04.12 at 18:05, Dan Magenheimer <dan.magenheimer@oracle.com> wrote:
> >>  From: David Vrabel [mailto:david.vrabel@citrix.com]
> >> On 16/04/12 12:32, Jan Beulich wrote:
> >> >>>> On 13.04.12 at 20:20, David Vrabel <david.vrabel@citrix.com> wrote:
> >> >> --- a/arch/x86/xen/time.c
> >> >> +++ b/arch/x86/xen/time.c
> >> >> @@ -473,6 +473,7 @@ static void __init xen_time_init(void)
> >> >>  	do_settimeofday(&tp);
> >> >>
> >> >>  	setup_force_cpu_cap(X86_FEATURE_TSC);
> >> >> +	sched_clock_stable = 0;
> >> >
> >> > This, unfortunately, is not sufficient afaict: If a CPU gets brought up
> >> > post-boot, the variable may need to be cleared again. Instead you
> >> > ought to call mark_tsc_unstable().
> >>
> >> Yeah, mark_tsc_unstable() is the right thing to do.
> >
> > NACK!
> >
> > No, no, no.  The exact opposite is true.  Like VMware, TSC is
> > stable.  The issue is that Linux trusts other clock hardware more
> > completely than TSC so whenever there is a problem with another
> > clocksource, Linux blames TSC and marks TSC unstable.  But TSC
> > on Xen 4.0+ is innocent.  In fact, TSC is a better clocksource
> > choice than clocksource=xen (aka pvclock) because pvclock
> > indirectly depends on TSC.
> >
> > For upstream kernels, the answer is to set clocksource=tsc
> > and tsc=reliable, like VMware enforces. See:
> >
> > https://lists.ubuntu.com/archives/kernel-team/2008-October/004283.html
> >
> > In fact, it might be wise for a Xen-savvy kernel to check to see
> > if it is running on Xen-4.0+ and, if so, force clocksource=tsc
> > and tsc=reliable.
> 
> Are you possibly mixing up PV and HVM cases? sched_clock_stable
> getting set _is_ a problem in PV kernels - we had bug reports long
> ago when this first appeared in arch/x86/kernel/cpu/intel.c. I'm
> suspecting this because there's not supposed to be (and in non-
> pv-ops there is no; in pv-ops I assume it simply has no effect)
> clocksource=tsc in PV kernels.

Hi Jan --

In upstream (and recent pv-ops) kernels, is there any need for there
to be a difference between HVM and PV in the clocksource chosen?  The
pvclock algorithm was necessary for PV when non-TSC hardware clocks
were privileged and the only non-privileged hardware clock (TSC)
was badly broken in hardware and for migration/save/restore.
With TSC now working and stable, and now that we are making changes
in the upstream kernel that work for both PV and HVM, is it
time to drop pvclock (at least as the default for PV)?

Certainly if an old (non-pv-ops) kernel is broken, something like
David's patch might be an acceptable workaround.  I'm just arguing
against perpetuating pvclock-as-the-only-xen-clock upstream.

Does that make sense?
Dan
