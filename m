Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932177Ab1CIKdZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 05:33:25 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:64138 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757138Ab1CIKdY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 05:33:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=BoPatj8xWNJ9BJqMQD+5bhB+GY7X36ZfXUWhLwmcl6SED+cZyJyrkUTp/tZlHnMHWR
         8HmuToGcnlrvKSEQJNNLyjy3zKSOv7ZxEQvMYtpW0GFpjm2CdZZ5uYB/v/mtAgoqiq45
         GNXbdCsJ7QyDSVKBY+h4o+6KD+28Gq7I7iiC0=
Date: Wed, 9 Mar 2011 11:28:55 +0100
From: Tejun Heo <tj@kernel.org>
To: Roland McGrath <roland@redhat.com>
Cc: Oleg Nesterov <oleg@redhat.com>, jan.kratochvil@redhat.com,
        Denys Vlasenko <vda.linux@googlemail.com>,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org
Subject: Re: [RFC] Proposal for ptrace improvements
Message-ID: <20110309102855.GC27010@htj.dyndns.org>
References: <20110301152457.GE26074@htj.dyndns.org>
 <20110307204346.19557183C29@magilla.sf.frob.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110307204346.19557183C29@magilla.sf.frob.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Roland.

On Mon, Mar 07, 2011 at 12:43:46PM -0800, Roland McGrath wrote:
> I've only skimmed through this whole thread, and I'm not going to try to
> respond to all the details.  I've lost interest in working in this area
> and I don't plan to keep up with all the details any more.  If you want
> to reach me about kernel subjects after March 11, you'll need to use the
> address <roland@hack.frob.com> as I won't be getting @redhat.com any more.

I see.  That's a pity.  I'll keep the new address cc'd for related
discussions.

> I've said before more than once what I think are the important
> principles about compatibility that ought to be maintained so as not to
> break existing applications such as older versions of GDB and strace
> (not to mention things less well-known and not publically visible, where
> code has come to depend on details of ptrace behavior and there may not
> even be anyone who really knows what they are depending on by now).
> When real-world applications have worked in practice, even if the
> behavior they were seeing was not pedantically reliable, they should not
> be broken.  Saner behavior can be provided when new requests or new
> options are used, without breaking any old usage.

The biggest changes the current ptrace users are gonna see are
probably the ones from P1 and those are really corner cases - /proc
state, behavior change visible only to other thread in a multithreaded
debugger, and behavior change on back-to-back DETACH/ATTACH sequence
on STOPPED task, which BTW was broken due to the extra
wake_up_process() anyway.

The biggest visible changes are the ones visible to a real parent
while the children are being ptraced - most of the changes introduced
by the recent P2 patchset.  As noted there, I don't think
conditionalizing those behavior changes is necessary given that the
previous behavior was utterly broken.  If somebody was actually
depending on job control events being broken while ptraced, well, I
primarily don't care, but if the problem actually is significant we'll
think about workarounds.

What I'm trying to say is that it's _ALWAYS_ about balances and trade
offs.  Sticking to some or any rules in fundamentalistic manner is a
guaranteed way to horrible code base which is not only painful to
develop and maintain but also will deliever a lot of WTF moments to
its users too in the long run.

So, let's balance it.  Avoiding changes to the userland visible
behaviors does have a lot of weight but its mass is NOT infinite.

> A problem long identified with ptrace is that there is no way to attach
> or detach without perturbing some of the user-visible behavior of the
> traced threads.  (There will always be some perturbation of the timing
> of the thread's activities, but I mean factors other than that alone.)
> Not overloading SIGSTOP is certainly an improvement.  But, PTRACE_SEIZE
> still has this problem in ways that the proposed PTRACE_ATTACH_NOSTOP
> does not.  For any passive tracing use (such as strace -p), you don't
> actually want the thing to stop right away, you only want it to stop
> when a new event happens (such as the next syscall entry/exit).  The
> PTRACE_SEIZE idea does not give the option of attaching without any
> perturbation when you don't care about "seizing".
>
> Anything that works via interruption can perturb the user-visible
> behavior of a system call already in progress.  It would be nice if all
> uninterruptible waits were truly reliably short and if all system call
> paths supported syscall restart thoroughly so that they could be
> interrupted with TIF_SIGPENDING and then restarted (a la SA_RESTART, or
> its equivalent when there is no actual signal to handle) with no change
> in semantics that userland can perceive (aside from timing).  But it
> just isn't so, and the way the kernel is organized makes it a difficult
> and open-ended task (perhaps an impossible one for some cases) to try to
> hunt down and fix every violation of that principle or to prevent
> introductions of new violations in the future.

But the only side effect would be that from signal_wake_up().  Our
hibernation code does that to every single thread and naturally any
signal delivery would also do that.  It's something fundamentally
ingrained into the design of the whole UNIX syscall mechanism.  If we
have undocumented behaviors there, we should fix and/or document them.
I don't think ptrace is the right place to to incorporate workaround
for such basic assumption.

Also, ptrace is inherently a very heavy mechanism.  It is intertwined
with the whole process model and hijacks the target task and if you
look at the provided operations, they aren't designed for light weight
monitoring.  The whole thing is designed to be heavy weight for dirty
diddling.

If someone is looking for completely transparent light weight
monitoring, there is a much better fitting mechanism for that and it
works frigging well and provides much better insight into what's going
on with the system.

Use tracing for tracing.

> The other areas of concern with PTRACE_SEIZE are its robustness and
> scalability.  The whole point of this request is that the one ptrace
> call does a full synchronization with the tracee, blocking until it has
> been interrupted and stopped.

No, I'm planning to do the waiting by wait(2), so there won't be
latency, interruptible sleep or scalability (compared to the current
attach) problems.

> None of this means at all that PTRACE_SEIZE is worthless.  But it is
> certainly inadequate to meet the essential needs that motivate adding
> new interfaces in this area.  The PTRACE_ATTACH_NOSTOP idea I
> suggested is far from complete for all the issues as well, but it is a
> more versatile building block than PTRACE_SEIZE.

I skipped a lot of parts but in general I think that you're trying to
do too much with ptrace.  ptrace has its place which is called
debugging.  Let's concentrate on that.  It doesn't have to do every
thing one can dream of.  There are a lot better tools for most of
them.

Thanks.

-- 
tejun
