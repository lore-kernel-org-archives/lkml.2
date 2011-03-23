Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755859Ab1CWNgO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 09:36:14 -0400
Received: from relay3.sgi.com ([192.48.152.1]:47966 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751109Ab1CWNgN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 09:36:13 -0400
Date: Wed, 23 Mar 2011 08:36:04 -0500
From: Jack Steiner <steiner@sgi.com>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Don Zickus <dzickus@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        tglx@linutronix.de, hpa@zytor.com, x86@kernel.org,
        linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH] x86, UV: Fix NMI handler for UV platforms
Message-ID: <20110323133604.GA21288@sgi.com>
References: <20110321160135.GA31562@sgi.com> <20110321161425.GC23614@elte.hu> <4D877C4B.9090602@gmail.com> <20110321175110.GL1239@redhat.com> <20110321182235.GA14562@sgi.com> <20110321193740.GN1239@redhat.com> <20110322171118.GA6294@sgi.com> <20110322184450.GU1239@redhat.com> <20110322212519.GA12076@sgi.com> <4D891C93.8070502@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D891C93.8070502@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 23, 2011 at 01:02:59AM +0300, Cyrill Gorcunov wrote:
> On 03/23/2011 12:25 AM, Jack Steiner wrote:
> > On Tue, Mar 22, 2011 at 02:44:50PM -0400, Don Zickus wrote:
> >> On Tue, Mar 22, 2011 at 12:11:18PM -0500, Jack Steiner wrote:
> >>> How certain are you that multiple NMIs triggered at about the same time will
> >>> deliver discrete NMI events? I updated the patch so that I'm running with:
> >>
> >> I think as long as there isn't more than two (1 active, 1 latched), you
> >> would be ok.  A third one looks like it would get dropped.
> >>
> >>>
> >>> 	- no special code in traps.c (I removed the traps.c code that was
> >>> 	  in the patch I posted)
> >>> 	- used die_notifier for calling the UV nmi handler
> >>> 	- UV priority is higher than the hw_perf priority
> >>>
> >>> Both hw_perf (perf top) & UV NMIs work correctly under light loads. However, if I
> >>> run for 10 - 15 minutes injecting UV NMIs at a rate of about 30/min, "perf top"
> >>> stops generating output. Strace shows that it continues to poll() but no data
> >>> is received.
> >>
> >> That's a low frequency and it still gets stuck?
> >>
> >>>
> >>> While "perf top" is hung, if I inject an NMI into the system in a way that will NOT
> >>> be consumed by the UV nmi handler, "perf top" resumes output but will stop again after
> >>> a few minutes.
> >>
> >> So that means the PMU set its interrupt bit but the cpu failed to get the
> >> NMI.
> >>
> >>>
> >>>
> >>> AFAICT, the UV nmi handler is not consuming extra NMI interrupts. I can't
> >>> rule out that I'm missing something but I don't see it.
> >>
> >> What happens if you put the UV nmi handler below the hw_perf handler in
> >> priority?  I assume the DIE_NMIUNKNOWN snippet in the hw_perf handler will
> >> swallow some of the UV NMIs, but more importantly does it still generate
> >> the hang you see?
> > 
> > I verified that the failures ("perf top" stops) are the same on both RHEL6.1 & the
> > latest x86 2.6.38+ tree.
> > 
> > I switched priorities & as expected, "perf top" no longer hangs. I see an occassional
> > missed UV NMI - about 1 every minute. I also see a few "dazed" messages as
> > well - 3 in a 5 minute period. This testing was done on a 2.6.38+ kernel.
> > 
> > I'm running on a 48p system.
> > 
> > Ideas?
> > 
> 
>   I fear there is always a probability for eaten nmi (due to inflight nmi logic
> we have) or missed nmi (due to non-instant deliery of nmi).  Say the following
> scenario may happen:
> 
> 1) perf-nmi-0 (from counter 0) issued
> 2) uv-nmi issued
> 3) perf-nmi-0 latched
> 4) perf-nmi-1 (from counter 1) not yet issued but couter overflowed
> 5) nmi-handler
> 6) uv-nmi-latched
> 7) nmi-handler eats both nmis from perf-nmi-0 and uv-nmi because of in-flight
>    nmi logic we have
> 8) finally perf-nmi-1 should appear on line but counter already pulled down so
>    no nmi
> 
> and here you get missed nmi you expect from uv. I *guess*, not sure if it's possible.

Makes sense.


> If you disable nmi-watchdog on boot line, does it help?

Nmi_watchdog is disabled by default on our platforms.
