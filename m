Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933400Ab0ECQrN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 May 2010 12:47:13 -0400
Received: from smtpout.cs.fsu.edu ([128.186.122.75]:23304 "EHLO
	mail.cs.fsu.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933277Ab0ECQrL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 May 2010 12:47:11 -0400
Date: Mon, 3 May 2010 11:54:38 -0400
From: Ted Baker <baker@cs.fsu.edu>
To: Peter Zijlstra <peterz@infradead.org>
Cc: raj@ece.cmu.edu, jayhawk@soe.ucsc.edu, raistlin@linux.it,
       niehaus@ittc.ku.edu, henrik@austad.us, linux-kernel@vger.kernel.org,
       mingo@elte.hu, billh@gnuppy.monkey.org, linux-rt-users@vger.kernel.org,
       fabio@gandalf.sssup.it, anderson@cs.unc.edu, tglx@linutronix.de,
       dhaval.giani@gmail.com, cucinotta@sssup.it, lipari@retis.sssup.it,
       baker.tlh@comcast.net
Subject: Re: [Fwd: Re: RFC for a new Scheduling policy/class in the Linux-kernel]
Message-ID: <20100503155438.GB11020@cs.fsu.edu>
References: <20100426115658.GA21346@cs.fsu.edu> <1272897682.1642.124.camel@laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1272897682.1642.124.camel@laptop>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Peter,

Thanks for the message.

The reference to lkml is not very helpful, as it refers to 5
months of e-mail, broken down by days, with no (apparent) search
capability.  However, I did manage to find some references to the
deadline scheduling work via the search capability on the
marc.info site.

In any case, deadline scheduling and sporadic server scheduling
are two quite different things. SCHED_SPORADIC belongs to the
fixed priority scheduling domain.  So, the proposed SCHED_DEADLINE
will not meet the same user requirement.

SCHED_SPORADIC has a well-defined POSIX name and a well-defined
API.  The semantics are not so badly broken that they can't be
fixed by an "interpretation" of the existing standard.  I intend
to submit a request for such an interpretation to the Austin
Group, to get them to relax their specification for
SCHED_SPORADIC, so that it can be implemented with reasonable
semantics.  It would help to convince the Austin Group to do this
if there were "existing practice" in Linux for this, though.

While I appreciate the enthusiasm of the SSUP folks for deadline
scheduling, the debates over the virtues of deadline-based vs.
fixed-priority scheduling, as well as over partitioned versus
global scheduling schemes, are likely to continue without a clear
resolution for a long time.  In the mean time, existing
applications use fixed priorities.  So, I'd hope that wherever
Linux goes with respect to adding support for deadline scheduling
it maintains the option for applications to use fixed-priority
scheduling.

BTW, I've found that deadline and fixed-priority scheduling can be
implemented and used together in a reasonable way, using a mapping
of all system priorities to values of a 128-bit time type.  The
internal scheduler is entirely based on deadline values, but fixed
priorities above and below normal dadlines are accomodated by
mapping:

a. The largest possible time value (2^128) is reserved for
DO_NOT_RUN.  Each processor's idle task is given a priority
level higher (earlier in time) than this.

b. Fixed priority values that are intended to be lower in priority
(later) than deadline-scheduled tasks are given "deadlines" in the
unreachable future.  A range of very large time values, just
short of DO_NOT_RUN can be reserved for this purpose.

c. Most time values are treated as normal deadlines.

d. The range of deadline values that would always be in the past
either negative values or values very close to zero, are reserved
for fixed priority scheduling of higher priority (earlier) than
all deadline-scheduled tasks.

In this fashion, it is easy for one scheduler, using one domain
of priority values, with a consistent interpretations, to 
implement.

Ted

On Mon, May 03, 2010 at 04:41:22PM +0200, Peter Zijlstra wrote:
> Hi Ted,
> 
> On Mon, 2010-04-26 at 07:56 -0400, Ted Baker wrote:
> > I have not seen any more e-mail on this.  How is it going?  Is there any
> > chance of rolling in some corrections for the SCHED_SPORADIC treatment?  In
> > particular, could we have a DO_NOT_RUN priority, that is guaranteed to
> > prevent a task from running at all?
> 
> Without having fully read the referenced paper, we're currently looking
> to support the sporadic task model through SCHED_DEADLINE (by our SSSUP
> friends):
> 
>   http://lkml.org/lkml/2010/2/28/107
> 
> This work aims to implement a full sporadic task scheduler [initially
> (g)EDF], SCHED_SPORADIC would have been a better name, but since POSIX
> stole that from us we took SCHED_DEADLINE to indicate its a deadline
> scheduler.
> 
> Along with this work comes the full Deadline-inheritance (which should
> be but a small change from our current Priority-inheritance code), and
> also Bandwidth-inheritance (more work). Esp. the latter would also be
> required for your proposed SCHED_SPORADIC since it does aim to be a
> 'strict' bandwidth enforcing scheduler.
> 
> [Does the proposed 'fixed' SCHED_SPORADIC deal with admission control?]
> 
> But as it stands, this work would provide much more complete sporadic
> task support than the fixed SCHED_SPORADIC would.
> 
> 
> 
> -- 
> This message has been scanned for viruses and
> dangerous content by MailScanner, and is
> believed to be clean.
