Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757061Ab1EZLRB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 07:17:01 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:52690 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754763Ab1EZLQ7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 07:16:59 -0400
Date: Thu, 26 May 2011 13:16:24 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Avi Kivity <avi@redhat.com>
Cc: James Morris <jmorris@namei.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Kees Cook <kees.cook@canonical.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>, Will Drewry <wad@chromium.org>,
        Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
        gnatapov@redhat.com, Chris Wright <chrisw@sous-sol.org>,
        Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [PATCH 3/5] v2 seccomp_filters: Enable ftrace-based system call
 filtering
Message-ID: <20110526111624.GG1763@elte.hu>
References: <20110525150153.GE29179@elte.hu>
 <alpine.LFD.2.02.1105251836030.3078@ionos>
 <20110525180100.GY19633@outflux.net>
 <BANLkTimiLvtyKJe-+Fd+4N_rGLfYdUvSVA@mail.gmail.com>
 <alpine.LRH.2.00.1105261034200.29690@tundra.namei.org>
 <20110526082451.GB26775@elte.hu>
 <4DDE1419.3000708@redhat.com>
 <20110526093040.GB19536@elte.hu>
 <20110526094806.GC19536@elte.hu>
 <4DDE333D.6020608@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DDE333D.6020608@redhat.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Avi Kivity <avi@redhat.com> wrote:

> > It would be possible to further increase isolation there by also 
> > passing the IO/MMIO decoding to the worker thread - but i'm not 
> > sure that's truly needed. Most of the risk is where most of the 
> > code is - and the code is in the worker task which interprets 
> > on-disk data, protocols, etc.
> 
> I've suggested in the past to add an "mmiofd" facility to kvm, 
> similar to ioeventfd.  This is how it would work:
> 
> - userspace configures kvm with an mmio range and a pipe
> - guest writes to that range write a packet to the pipe describing the write
> - guest reads from that range write a packet to the pipe describing
> the read, then wait for a reply packet with the result
> 
> The advantages would be
> - avoid heavyweight exit; kvm can simply wake up a thread on another
> core and resume processing
> - writes can be pipelined, similar to how PCI writes are posted
> - supports process separation

Yes, that was my exact thought, a per transport channel fd.

> So far no one has posted an implementation but it should be pretty 
> simple.

tools/kvm/ could make quick use of it - and it's a performance 
optimization mainly IMO, not primarily a security feature.

If you whip up a quick untested prototype for the KVM side we could 
look into adding tooling support for it and could test it.

As long as it's provided as an opt-in ioctl() which if fails (on 
older kernels) we fall back to the vcpu-fd, it should be relatively 
straightforward to support on the tooling side as well AFAICS.

Thanks,

	Ingo
