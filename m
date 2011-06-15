Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755211Ab1FONvF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jun 2011 09:51:05 -0400
Received: from relay2.sgi.com ([192.48.179.30]:44401 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753925Ab1FONvD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jun 2011 09:51:03 -0400
Date: Wed, 15 Jun 2011 08:52:13 -0500
From: Cliff Wickman <cpw@sgi.com>
To: Rakib Mullick <rakib.mullick@gmail.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu
Subject: Re: [PATCH 1 of 6] x86, UV: smp_processor_id in a preemptable
	region
Message-ID: <20110615135213.GA29493@sgi.com>
References: <E1QWcgn-0004Mv-T6@eag09.americas.sgi.com> <BANLkTinpqPhTNRtqPGnfZznefESwD19iXA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTinpqPhTNRtqPGnfZznefESwD19iXA@mail.gmail.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 15, 2011 at 12:05:17PM +0600, Rakib Mullick wrote:
> On Wed, Jun 15, 2011 at 5:06 AM, Cliff Wickman <cpw@sgi.com> wrote:
> > From: Cliff Wickman <cpw@sgi.com>
> >
> > Calling smp_processor_id() from within a preemptable region will issue
> > a warning if DEBUG_PREEMPT is set.
> >
> > Diffed against 3.0.0-rc3
> >
> > Signed-off-by: Cliff Wickman <cpw@sgi.com>
> > ---
> > ?arch/x86/platform/uv/tlb_uv.c | ? ?2 ++
> > ?1 file changed, 2 insertions(+)
> >
> > Index: linux/arch/x86/platform/uv/tlb_uv.c
> > ===================================================================
> > --- linux.orig/arch/x86/platform/uv/tlb_uv.c
> > +++ linux/arch/x86/platform/uv/tlb_uv.c
> > @@ -1334,7 +1334,9 @@ static ssize_t tunables_write(struct fil
> >
> > ? ? ? ?instr[count] = '\0';
> >
> > + ? ? ? preempt_disable(); /* avoid DEBUG_PREEMPT warning */
> 
> I think above code comment, "avoid DEBUG_PREEMPT warning" should be to
> something more meaningful. It's a BUG, if smp_processor_id() is called
> within preemptible context. So, we don't want to hit that BUG.

I agree that calling smp_processor_id() within a preemptible context is
going to produce unpredictable results.  In this particular case we just
need a valid cpu number so that we can find a per-cpu structure.
That structure contains a reasonable (sanity-checking) limit to the value
of the tunable that is being written.
It is possible that the found per-cpu structure could differ from cpu to
cpu. But if this tunable is thus caused to be set too high, a 'throttling'
upper bound will not be enforced. No other harm is done.
But yes, I should have noted that an ugly DEBUG_PREEMPT warning will
be the worst effect.
-Cliff

> 
> > ? ? ? ?bcp = &per_cpu(bau_control, smp_processor_id());
> > + ? ? ? preempt_enable_no_resched();
> >
> > ? ? ? ?ret = parse_tunables_write(bcp, instr, count);
> > ? ? ? ?if (ret)
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at ?http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at ?http://www.tux.org/lkml/
> >
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
Cliff Wickman
SGI
cpw@sgi.com
(651) 683-3824
