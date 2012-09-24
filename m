Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757121Ab2IXQv4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 12:51:56 -0400
Received: from mail.skyhub.de ([78.46.96.112]:59998 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757081Ab2IXQvx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 12:51:53 -0400
Date: Mon, 24 Sep 2012 18:52:11 +0200
From: Borislav Petkov <bp@alien8.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Mel Gorman <mgorman@suse.de>,
        Nikolay Ulyanitsky <lystor@gmail.com>, Mike Galbraith <efault@gmx.de>,
        linux-kernel@vger.kernel.org,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>
Subject: Re: 20% performance drop on PostgreSQL 9.2 from kernel 3.5.3 to
 3.6-rc5 on AMD chipsets - bisected
Message-ID: <20120924165210.GA23482@x1.osrc.amd.com>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>,
	Mel Gorman <mgorman@suse.de>, Nikolay Ulyanitsky <lystor@gmail.com>,
	Mike Galbraith <efault@gmx.de>, linux-kernel@vger.kernel.org,
	Andreas Herrmann <andreas.herrmann3@amd.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@kernel.org>
References: <CA+Medix98MHYzpKSDKKWf7Wew0H4zDFsUS74LrhsP2Lxemd3Mw@mail.gmail.com>
 <20120914212717.GA29307@liondog.tnic>
 <CA+55aFwn3UhTDDch4+-=9=T3rHpDvqphY+NLtf2Ljq-7eG+gYw@mail.gmail.com>
 <20120924150048.GB11266@suse.de>
 <1348500647.11847.69.camel@twins>
 <CA+55aFy5C-gFs6ZU5LyyVN=oxpuoaOpydkbJbhri215QkLx3aA@mail.gmail.com>
 <1348503163.11847.97.camel@twins>
 <CA+55aFzU2QOgexc2cpEkWqPBw6wPJMBuUzRyxTxu=rxZV_ay3A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CA+55aFzU2QOgexc2cpEkWqPBw6wPJMBuUzRyxTxu=rxZV_ay3A@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 24, 2012 at 09:30:05AM -0700, Linus Torvalds wrote:
> On Mon, Sep 24, 2012 at 9:12 AM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> >
> > So we're looking for an idle cpu around @target. We prefer a cpu of an
> > idle core, since SMT-siblings share L[12] cache. The way we do this is
> > by iterating the topology tree downwards starting at the LLC (L3) cache
> > level. Its groups are either the SMT-siblings or singleton groups.
> 
> So if it'sally guaranteed to be SMT-siblings or singleton groups, then
> the whole "for_each_cpu()" is a total disaster. That's a truly
> expensive way to look up adjacent CPU's. Is there no saner way to look
> up that thing? Like a simple circular list of SMT siblings (I realize
> that on x86 that list is either one or two, but other SMT
> implementations are groups of four or more).
> 
> So I suspect your patch largely makes things faster (avoid those
> insane cpumask operations), but the for_each_cpu() one is still an
> absolutely horrible way to find a couple of basically statically known
> (modulo hotplug, which is disabled here anyway) CPU's. So even if the
> algorithm makes sense at some higher level, it doesn't really seem to
> make sense from an implementation standpoint.
> 
> Also, do we really want to spread things out that aggressively?
> How/why do we know that we don't want to share L2 caches, for example?
> It sounds like a bad idea from a power standpoint, and possibly
> performance too.

Right,

maybe the quicker lookup would be the other way around, down the cache
hierarchy: check the CPUs sharing L1, then L2 and if there's no idle
cpu, fall back to the L3-sharing ones and then simply grab one. I don't
know whether that could work though, we'd need to run it heavily.

-- 
Regards/Gruss,
Boris.
