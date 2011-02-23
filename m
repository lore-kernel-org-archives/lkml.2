Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754649Ab1BWQAQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 11:00:16 -0500
Received: from casper.infradead.org ([85.118.1.10]:48451 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754533Ab1BWQAN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 11:00:13 -0500
Subject: Re: [PATCH 2/2] sched: allow users with rtprio rlimit to change
 from SCHED_IDLE policy
From: Peter Zijlstra <peterz@infradead.org>
To: Darren Hart <dvhart@linux.intel.com>
Cc: Ingo Molnar <mingo@elte.hu>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        richard.purdie@linuxfoundation.org
In-Reply-To: <4D652D42.4040801@linux.intel.com>
References: <1298408674-3130-1-git-send-email-dvhart@linux.intel.com>
	 <1298408674-3130-3-git-send-email-dvhart@linux.intel.com>
	 <1298458989.2217.361.camel@twins>  <20110223111354.GB7448@elte.hu>
	 <1298459826.2217.363.camel@twins>  <4D652D42.4040801@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 23 Feb 2011 17:00:05 +0100
Message-ID: <1298476805.2217.791.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-02-23 at 07:52 -0800, Darren Hart wrote:
> On 02/23/2011 03:17 AM, Peter Zijlstra wrote:
> > On Wed, 2011-02-23 at 12:13 +0100, Ingo Molnar wrote:
> >> * Peter Zijlstra<peterz@infradead.org>  wrote:
> >>
> >>> On Tue, 2011-02-22 at 13:04 -0800, Darren Hart wrote:
> >>>> As it stands, users with rtprio rlimit permissions can change their policy from
> >>>> SCHED_OTHER to SCHED_FIFO and back. They can change to SCHED_IDLE, but not back
> >>>> to SCHED_FIFO. If they have the rtprio permission, they should be able to. Once
> >>>> in SCHED_FIFO, they could go back to SCHED_OTHER. This patch allows users with
> >>>> rtprio permission to change out of SCHED_IDLE.
> >>>>
> >>>
> >>> Ingo, can you remember the rationale for this?
> >>>
> >>> The fact is that SCHED_IDLE is very near nice-20, and we can do:
> >>>
> >>> peterz@twins:~$ renice 5 -p $$
> >>> 1867: old priority 0, new priority 5
> >>> peterz@twins:~$ renice 0 -p $$
> >>> 1867: old priority 5, new priority 0
> >>>
> >>> Which would suggest that we should be able to return to SCHED_OTHER
> >>> RLIMIT_NICE-20.
> >>
> >> I dont remember anything subtle there - most likely we just forgot about that spot
> >> when adding RLIMIT_RTPRIO support.
> >
> > Ah, I was arguing we should allow it regardless of RLIMIT_RTPRIO, based
> > on RLIMIT_NICE, it is after all a change to SCHED_OTHER, not
> > SCHED_FIFO/RR.
> 
> So we need an OR test of RLIMIT_NICE | RLIMIT_RTPRIO ? 

Just RLIMIT_NICE I think.

> The reason I keep 
> coming back to RTPRIO is it allows the user to change to 
> SCHED_(FIFO|RR), and from there they can change to anything they want - 

Hmm,. is that so? I would think that even if you're SCHED_FIFO changing
back to SCHED_OTHER ought to make you respect RLIMIT_NICE.

That is, even if you're a SCHED_FIFO-1 task due to RLIMIT_RTPRIO, when
you switch back to SCHED_OTHER I would expect you not to be able to
switch to a lower nice than RLIMIT_NICE-20.

Now, if this isn't actually so I think we ought to make it so.

> so why force two steps? Perhaps the argument is to keep the meaning of 
> the RLIMITs precise, and if you want to go from IDLE->OTHER you had 
> better properly set RLIMIT_NICE - maybe I just convinced myself.

Right

> Shall I respin the patch to reflect that?

Please.
