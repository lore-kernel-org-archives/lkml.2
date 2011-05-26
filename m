Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755403Ab1EZJsZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 05:48:25 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:47154 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750789Ab1EZJsX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 05:48:23 -0400
Date: Thu, 26 May 2011 11:48:06 +0200
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
Message-ID: <20110526094806.GC19536@elte.hu>
References: <20110524195435.GC27634@elte.hu>
 <alpine.LFD.2.02.1105242239230.3078@ionos>
 <20110525150153.GE29179@elte.hu>
 <alpine.LFD.2.02.1105251836030.3078@ionos>
 <20110525180100.GY19633@outflux.net>
 <BANLkTimiLvtyKJe-+Fd+4N_rGLfYdUvSVA@mail.gmail.com>
 <alpine.LRH.2.00.1105261034200.29690@tundra.namei.org>
 <20110526082451.GB26775@elte.hu>
 <4DDE1419.3000708@redhat.com>
 <20110526093040.GB19536@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110526093040.GB19536@elte.hu>
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


* Ingo Molnar <mingo@elte.hu> wrote:

> You are missing the geniality of the tools/kvm/ thread pool! :-)
> 
> It could be switched to a worker *process* model rather easily. 
> Guest RAM and (a limited amount of) global resources would be 
> shared via mmap(SHARED), but otherwise each worker process would 
> have its own stack, its own subsystem-specific state, etc.

We get VM exit events in the vcpu threads which after minimal 
processing pass much of the work to the thread pool. Most of the 
virtio work (which could be a source of vulnerability - ringbuffers 
are hard) is done in the worker task context.

It would be possible to further increase isolation there by also 
passing the IO/MMIO decoding to the worker thread - but i'm not sure 
that's truly needed. Most of the risk is where most of the code is - 
and the code is in the worker task which interprets on-disk data, 
protocols, etc.

So we could not only isolate devices from each other, but we could 
also protect the highly capable vcpu fd from exploits in devices - 
worker threads generally do not need access to the vcpu fd IIRC.

Thanks,

	Ingo
