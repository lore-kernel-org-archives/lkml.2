Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758127Ab1DYNkS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 09:40:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:8502 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752139Ab1DYNkQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 09:40:16 -0400
Date: Mon, 25 Apr 2011 09:39:54 -0400
From: Don Zickus <dzickus@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: x86@kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Robert Richter <robert.richter@amd.com>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        George Spelvin <linux@horizon.com>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 3/4] perf, nmi: Move LVT un-masking into irq handlers
Message-ID: <20110425133954.GA20887@redhat.com>
References: <1303398203-2918-1-git-send-email-dzickus@redhat.com>
 <1303398203-2918-4-git-send-email-dzickus@redhat.com>
 <20110422082636.GC24011@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110422082636.GC24011@elte.hu>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 22, 2011 at 10:26:36AM +0200, Ingo Molnar wrote:
> 
> * Don Zickus <dzickus@redhat.com> wrote:
> 
> > --- a/arch/x86/kernel/cpu/perf_event.c
> > +++ b/arch/x86/kernel/cpu/perf_event.c
> > @@ -1284,6 +1284,9 @@ static int x86_pmu_handle_irq(struct pt_regs *regs)
> >  
> >  	cpuc = &__get_cpu_var(cpu_hw_events);
> >  
> > +	/* chipsets have their own quirks when to unmask */
> > +	apic_write(APIC_LVTPC, APIC_DM_NMI);
> > +
> 
> What sense does this comment make in this place?
> 
> Yes, chipsets have their own quirks - but the generic handler is not one of 
> them. So a more appropriate comment would be to point out why we want to unmask 
> there - before PMU handling or after it, etc.

Yup.  I rework that.

> 
> Like the P4 quirk is documented a bit better:
> 
> > +        /*
> > +	 * P4 quirks:
> > +	 * - An overflown perfctr will assert its interrupt
> > +	 *   until the OVF flag in its CCCR is cleared.
> > +	 * - LVTPC is masked on interrupt and must be
> > +	 *   unmasked by the LVTPC handler.
> > +	 */
> > +	apic_write(APIC_LVTPC, APIC_DM_NMI);
> 
> (btw., there's whitespace damage above as well.)
> 
> Furthermore, the P4 comment should *explain* the quirk coherently, not just 
> list random facts. What happens, why, where, and why do we unmask the LVTPC in 
> that spot.

Yeah, I copied that from the old watchdog code.  I'll revise that too and
repost.

Cheers,
Don
