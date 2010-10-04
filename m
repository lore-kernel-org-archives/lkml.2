Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753285Ab0JDIHP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Oct 2010 04:07:15 -0400
Received: from www.tglx.de ([62.245.132.106]:57242 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752624Ab0JDIHN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Oct 2010 04:07:13 -0400
Date: Mon, 4 Oct 2010 10:05:43 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: "Eric W. Biederman" <ebiederm@xmission.com>
cc: LKML <linux-kernel@vger.kernel.org>, linux-arch@vger.kernel.org,
        Linus Torvalds <torvalds@osdl.org>,
        Andrew Morton <akpm@linux-foundation.org>, x86@kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mundt <lethal@linux-sh.org>,
        Russell King <linux@arm.linux.org.uk>,
        David Woodhouse <dwmw2@infradead.org>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Yinghai Lu <yinghai@kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [patch 00/47] Sparse irq rework
In-Reply-To: <m162xibx3k.fsf@fess.ebiederm.org>
Message-ID: <alpine.LFD.2.00.1010040952460.14550@localhost6.localdomain6>
References: <20100930221351.682772535@linutronix.de> <m1wrpzfctu.fsf@fess.ebiederm.org> <alpine.LFD.2.00.1010032034420.14550@localhost6.localdomain6> <m162xibx3k.fsf@fess.ebiederm.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 3 Oct 2010, Eric W. Biederman wrote:
> Thomas Gleixner <tglx@linutronix.de> writes:
> >> I believe you have distored the design when aiming for migration
> >> of active irq descriptors (which you have not even implemented yet).
> >> 
> >> How do you plan to remove the radix tree lookup from the irq
> >> handling path?
> >
> > Not at all and it's not even even a requirement to remove the lookup
> > for implementing live migration.
> 
> It sounds like it is a requirement to *keep* the lookup for supporting
> live migration.  *Keeping* the lookup I see as a serious problem.  If we
> do this right the only users of the radix tree will be drivers using the
> functions in interrupt.h.

Oh well. I said that it's not a requirement to remove the lookup from
the entry code, but we can remove it for optimizaiton reasons.

That is the same problem vs. migration as we have a reference to
irq_desc either by lookup or by storage in vector data on x86.

> >> Those files provide the genirq irq chip implementation especially
> >> drivers/pci/msi.c.  Of course they will do what every other irq_chip
> >> implementation does to get access to data.  There is an unpleasant
> >> difference between which generic irq data field htirq.c uses and msi.c
> >> which may be worth cleaning up.  But otherwise I don't see any
> >> fundamental problems.
> >
> > The fundamental problem I hit, was the hack which handed down irq_desc
> > to avoid the lookup. If it had been msi_desc in the first place, then
> > I would not even need to touch the msi code to cleanup x86.
> 
> Just because you intend to rename the irq_desc irq_data...

No, I'm not renaming it. I'm cleaning up the mess which was created
with references to irq_desc all over the place. I need to change core
code and I cant w/o breaking the world and some more, just because
everyone fiddles in irq_desc directly. So I want to hand down irq_data
which is right now inside of irq_desc until the irq_desc users outside
of kernel/irq are gone. Then irq_data is not necessarily a part of
irq_desc anymore.
 
> It isn't a hack for an irq method to look at irq_desc.  At least not
> until your irq_data changes go through.  This has nothing to do with
> how x86 is structured and everything to do with your irq_data
> ``cleanup'' which appears to be mostly about code churn, for very little
> apparent benefit.

I tend to disagree. The sparse_irq optimizations to get rid of the
redundant irq_desc lookups to gain access to the irq_data should have
been done in exactly that way.

And I call something which removes 500 lines of code hardly useless
code churn.

> In the current state of the kernel I find it very hard to swallow that
> having a genirq client using irq_desc (which is the only way to
> implement somethings) is a hack.

This could have been done 2 years ago by those who pushed sparse_irq
including the resulting "optimization".

Thanks,

	tglx
