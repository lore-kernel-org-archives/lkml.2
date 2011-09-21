Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753690Ab1IUR4N (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Sep 2011 13:56:13 -0400
Received: from www.linutronix.de ([62.245.132.108]:50765 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753494Ab1IUR4L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Sep 2011 13:56:11 -0400
Date: Wed, 21 Sep 2011 19:56:04 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Oleg Nesterov <oleg@redhat.com>
cc: Eric Dumazet <eric.dumazet@gmail.com>, Andi Kleen <ak@linux.intel.com>,
        Andi Kleen <andi@firstfloor.org>, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 4/4] posix-timers: turn it_signal into it_valid flag
In-Reply-To: <alpine.LFD.2.02.1109211835550.2723@ionos>
Message-ID: <alpine.LFD.2.02.1109211954430.2723@ionos>
References: <20110904165658.GA23948@redhat.com> <20110904202907.GA3404@redhat.com> <20110906031411.GA24024@alboin.amr.corp.intel.com> <20110906145124.GA15390@redhat.com> <1315323596.2899.6.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC> <alpine.LFD.2.02.1109061823100.2723@ionos>
 <20110906184926.GA25997@redhat.com> <alpine.LFD.2.02.1109062110090.2723@ionos> <20110906192626.GA27362@redhat.com> <alpine.LFD.2.02.1109062134010.2723@ionos> <20110906220827.GA1800@redhat.com> <alpine.LFD.2.02.1109211835550.2723@ionos>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 Sep 2011, Thomas Gleixner wrote:

> On Wed, 7 Sep 2011, Oleg Nesterov wrote:
> > On 09/06, Thomas Gleixner wrote:
> > >
> > > On Tue, 6 Sep 2011, Oleg Nesterov wrote:
> > >
> > > > But how this can help? Suppose that the task is preempted right
> > > > after dequeue_signal() drops ->siglock. We need rcu_read_lock()
> > > > before unlock then, no?
> > >
> > > Crap, you are right, but that's fortunately an easy to solve one :)
> > 
> > Yes, this is solvable. But I think we can do something better.
> > 
> > > > And. This breaks the accounting logic. I mean the patch from Andi
> > > > which adds the limits.
> > >
> > > That's a different problem and really, it does not break it by any
> > > means. When the timer is released, then the count is decreased and we
> > > can safely assume that the memory is going to be freed in the next
> > > grace period.
> > 
> > Yes, but this means we need the counter which we do not have.
> > 
> > I think we can avoid this problems. Although I am not sure, I am
> > already sleeping.
> > 
> > 	- we add rcu_read_lock() into dequeueu_signal().
> > 
> > 	- we add the new "struct k_itimer *my_timer" member into
> > 	 siginfo._timer. Like _sys_private it is not passed to
> > 	 user, and perhaps we can kill _sys_private later.
> 
> sys_private is ugly as hell and we should avoid to add another field
> to siginfo.
> 
> I think we can embed the timer siginfo into k_itimer instead and

That should be sigqeue of course, which has siginfo embedded.

Thanks,

	tglx
 
