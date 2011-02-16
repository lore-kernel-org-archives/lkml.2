Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758928Ab1BPK24 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 05:28:56 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:58934 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758905Ab1BPK2q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 05:28:46 -0500
Date: Wed, 16 Feb 2011 11:28:01 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andrea Arcangeli <aarcange@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        the arch/x86 maintainers <x86@kernel.org>,
        "Xen-devel@lists.xensource.com" <Xen-devel@lists.xensource.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ian Campbell <Ian.Campbell@citrix.com>,
        Jan Beulich <JBeulich@novell.com>, Larry Woodman <lwoodman@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>,
        Johannes Weiner <jweiner@redhat.com>, Hugh Dickins <hughd@google.com>,
        Rik van Riel <riel@redhat.com>
Subject: Re: [PATCH] fix pgd_lock deadlock
Message-ID: <20110216102801.GA23082@elte.hu>
References: <20110215190710.GL5935@random.random>
 <alpine.LFD.2.00.1102152020590.26192@localhost6.localdomain6>
 <20110215195450.GO5935@random.random>
 <alpine.LFD.2.00.1102152102530.26192@localhost6.localdomain6>
 <alpine.LFD.2.00.1102152125180.26192@localhost6.localdomain6>
 <20110215225234.GP5935@random.random>
 <alpine.LFD.2.00.1102160002300.26192@localhost6.localdomain6>
 <20110215231733.GR5935@random.random>
 <1297850294.2413.30.camel@twins>
 <20110216101521.GU5935@random.random>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110216101521.GU5935@random.random>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andrea Arcangeli <aarcange@redhat.com> wrote:

> On Wed, Feb 16, 2011 at 10:58:14AM +0100, Peter Zijlstra wrote:
> > On Wed, 2011-02-16 at 00:17 +0100, Andrea Arcangeli wrote:
> > > On Wed, Feb 16, 2011 at 12:03:30AM +0100, Thomas Gleixner wrote:
> > > > I assume you run it with a lockdep enabled kernel as well, right ?
> > > 
> > > Yes, I always run with lockdep and prove locking enabled on my test
> > > box, not sure how it's meant to trigger more bugs in this case, the
> > > debug check that should be relevant for this is DEBUG_VM and that is
> > > enabled too of course. I didn't try DEBUG_PAGEALLOC yet.
> > 
> > I think what Thomas tried to tell you is that your
> > VM_BUG_ON(in_interrupt()) is fully redundant if you have lockdep
> > enabled.
> > 
> > Lockdep will warn you if a !irqsave lock is taken from IRQ context,
> > since that is a clear inversion problem.
> 
> Ah I get it now, but I prefer to have it on an all my builds, and
> I don't keep lockdep on for all builds (but I keep DEBUG_VM on). It's
> still only debug code that no production system will ever deal with,
> so it should be good to exercise it in more than on debug .config
> considering it's very low overhead (pgd_lock is never taken in fast
> paths) so it's suitable for a VM_BUG_ON.

The point both Thomas and Peter tried to point out to you, that adding 7 instances 
of redundant debug checks:

+		VM_BUG_ON(in_interrupt());
+		VM_BUG_ON(in_interrupt());
+	VM_BUG_ON(in_interrupt());
+	VM_BUG_ON(in_interrupt());
+	VM_BUG_ON(in_interrupt());
+	VM_BUG_ON(in_interrupt());
+	VM_BUG_ON(in_interrupt());

to arch/x86/ is not acceptable, for the reasons stated. Please remove it from the 
patch.

Thanks,

	Ingo
