Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757021Ab0LRRDO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Dec 2010 12:03:14 -0500
Received: from mx1.redhat.com ([209.132.183.28]:59637 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756873Ab0LRRDN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Dec 2010 12:03:13 -0500
Message-ID: <4D0CE937.8090601@redhat.com>
Date: Sat, 18 Dec 2010 19:02:47 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: Mike Galbraith <efault@gmx.de>
CC: Rik van Riel <riel@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Chris Wright <chrisw@sous-sol.org>
Subject: Re: [RFC -v2 PATCH 2/3] sched: add yield_to function
References: <20101213224434.7495edb2@annuminas.surriel.com>	 <20101213224657.7e141746@annuminas.surriel.com>	 <1292306896.7448.157.camel@marge.simson.net> <4D0A6D34.6070806@redhat.com>	 <1292569018.7772.75.camel@marge.simson.net>  <4D0B7D24.5060207@redhat.com> <1292615509.7381.81.camel@marge.simson.net>
In-Reply-To: <1292615509.7381.81.camel@marge.simson.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/17/2010 09:51 PM, Mike Galbraith wrote:
> On Fri, 2010-12-17 at 17:09 +0200, Avi Kivity wrote:
> >  On 12/17/2010 08:56 AM, Mike Galbraith wrote:
> >  >  >   Surely that makes it a reasonable idea to call yield, and
> >  >  >   get one of the other tasks on the current CPU running for
> >  >  >   a bit?
> >  >
> >  >  There's nothing wrong with trying to give up the cpu.  It's the concept
> >  >  of a cross cpu yield_to() that I find mighty strange.
> >
> >  What's so strange about it?  From a high level there are N runnable
> >  tasks contending for M cpus.  If task X really needs task Y to run, what
> >  does it matter if task Y last ran on the same cpu as task X or not?
>
> Task X wants control of when runnable task Y gets the cpu.  Task X
> clearly wants to be the scheduler.  This isn't about _yielding_ diddly
> spit, it's about individual tasks wanting to make scheduling decisions,
> so calling it a yield is high grade horse-pookey.  You're trying to give
> the scheduler a hint, the stronger that hint, the happier you'll be.

Please suggest a better name then.

> I can see the problem, and I'm not trying to be Mr. Negative here, I'm
> only trying to point out problems I see with what's been proposed.
>
> If the yielding task had a concrete fee he could pay, that would be
> fine, but he does not.

It does.  The yielding task is entitled to its fair share of the cpu, as 
modified by priority and group scheduling.  The yielding task is willing 
to give up some of this cpu, in return for increasing another task's 
share.  Other tasks would not be negatively affected by this.

> If he did have something, how often do you think it should be possible
> for task X to bribe the scheduler into selecting task Y?

In extreme cases, very often.  Say 100KHz.

> Will his
> pockets be deep enough to actually solve the problem?  Once he's
> yielded, he's out of the picture for a while if he really gave anything
> up.

Unless the other task donates some cpu share back.  This is exactly what 
will happen in those extreme cases.

> What happens to donated entitlement when the recipient goes to
> sleep?

Nothing.

> If you try to give it back, what happens if the donor exited?

It's lost, too bad.

> Where did the entitlement come from if task A running alone on cpu A
> tosses some entitlement over the fence to his pal task B on cpu B.. and
> keeps on trucking on cpu A?  Where does that leave task C, B's
> competition?

Eventually C would replace A, since its share will be exhausted.  If C 
is pinned... good question.  How does fairness work with pinned tasks?

> >  Do I correctly read between the lines that CFS maintains complete
> >  fairness only on a cpu, but not globally?
>
> Nothing between the lines about it.  There are N individual engines,
> coupled via load balancing.

Is this not seen as a major deficiency?

I can understand intra-cpu scheduling decisions at 300 Hz and inter-cpu 
decisions at 10 Hz (or even lower, with some intermediate rate for 
intra-socket scheduling).  But this looks like a major deviation from 
fairness - instead of 33%/33%/33% you get 50%/25%/25% depending on 
random placement.

-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

