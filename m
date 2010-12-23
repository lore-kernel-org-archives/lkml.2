Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752934Ab0LWNxg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Dec 2010 08:53:36 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:56671 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751739Ab0LWNxf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Dec 2010 08:53:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=weAnAGn9sMfEQYXVN+CuA98NPLPfF8fp8MQdxRSK+QHrFoSq7bRvut4yyGJTY9/41J
         EuclrSbGe5Ak/uXHHE641U75oywgqaU7FoDryzmWiJ87/rBlB7hyhStgaM80fBH/IN40
         CFbUeqyLk5bsWWEih+grE60rpbSsR/F170ucM=
Date: Thu, 23 Dec 2010 14:53:30 +0100
From: Tejun Heo <tj@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: roland@redhat.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org, rjw@sisk.pl,
        jan.kratochvil@redhat.com
Subject: Re: [PATCH 09/16] ptrace: make do_signal_stop() use ptrace_stop()
 if the task is being ptraced
Message-ID: <20101223135330.GA18482@htj.dyndns.org>
References: <1291654624-6230-1-git-send-email-tj@kernel.org>
 <1291654624-6230-10-git-send-email-tj@kernel.org>
 <20101223122634.GA365@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101223122634.GA365@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Thu, Dec 23, 2010 at 01:26:34PM +0100, Oleg Nesterov wrote:
> I missed this part of the changelog. "visible via fs/proc" is not
> the only change. Another change is how the tracee reacts to SIGCONT
> after that. With this patch it can't wake the tracee up.
> 
> Consider the simplest example. The tracee is single-threaded and
> debugger == parent. Something like
> 
> 	int main(void)
> 	{
> 		int child, status;
> 
> 		child = fork();
> 		if (!child) {
> 			ptrace(PTRACE_TRACEME);
> 
> 			kill(getpid(), SIGSTOP);
> 
> 			return 0;
> 		}
> 
> 		wait(&status)
> 		// the tracee reports the signal
> 		assert(WIFSTOPPED() && WSTOPSIG() == SIGSTOP);
> 		// it should stop after that
> 		ptrace(PTRACE_CONT, child, SIGSTOP);
> 
> 		wait(&status);
> 		// now it is stopped
> 		assert(WIFSTOPPED() && WSTOPSIG() == SIGSTOP);
> 
> 		kill(child, SIGCONT);
> 
> 		wait(&status);
> 		assert(WIFSTOPPED() && WSTOPSIG() == SIGCONT);
> 
> This won't work with this patch. the last do_wait() will hang forever.
> Probably this is fine, I do not know. Please take a look and ack/nack
> explicitly.

Yes, before the change, the task would respond to SIGCONT before the
first ptrace request succeeds after attach.  To me, this doesn't seem
to be anything intentional tho.  It seems a lot of ptrace and group
stop interactions is in the grey area with only the current (quirky,
I'm afraid) behavior drawing almost arbitrary lines across different
behaviors.

We can try to preserve all those behaviors but I don't think that will
be very beneficial.  I think the best way to proceed would be
identifying the sensible and depended upon assumptions and then draw
clear lines from there stating what's guaranteed and what's undefined.
We'll have to keep some of quirkiness for sure.

Anyways, pondering and verifying all the possibly visible changes
definitely is necessary, but that said, we fortunately have rather
limited number of ptrace users and their usages don't seem to be too
wild (at least on my cursory investigation), so I think it to be
doable without breaking anything noticeably.  But yeap we definitely
need to be careful.

> However. There is something I missed previously, and this small
> detail doesn't look good to me: the behaviour of SIGCONT becomes
> a bit unpredictable. Suppose it races with do_signal_stop() and
> clears GROUP_STOP_PENDING or SIGNAL_STOP_DEQUEUED before, in this
> case in can "wakeup" the tracee.
> 
> IOW. Let's remove the 2nd wait() in the code above, the parent
> does
> 
> 		wait(&status)
> 		// the tracee reports the signal
> 		assert(WIFSTOPPED() && WSTOPSIG() == SIGSTOP);
> 		// it should stop after that
> 		ptrace(PTRACE_CONT, child, SIGSTOP);
> 
> 		kill(child, SIGCONT);
> 
> Now we can't know id this SIGCONT works or not. If the tracee
> is already parked in ptrace_stop() - it doesn't. If the parent
> wins - the tracee doesn't stop.

We can change ptrace_stop() to use TASK_STOPPED if it's stopping for
group stop to preserve the original behavior but if it doesn't disturb
current users (and I doubt it would), I think it would be far cleaner
to state that the behavior is undefined.  The current behavior - it
works if there hasn't been whichever ptrace operation inbetween - is
quite unexpected anyway, IMHO.

And, for longer term, I think it would be a good idea to separate
group stop and ptrace trap mechanisms, so that ptrace trap works
properly on per-task level and properly transparent from group stop
handling.  The intertwining between the two across different domains
of threads inhfferently involves a lot of grey areas where there is no
good intuitive behavior.

> OTOH. Looking at this patch, I can no longer understand why
> ptrace_check_attach() can silently do s/STOPPED/TRACED/. Indeed,
> as Tejun pointed out, if ptrace_stop() needs arch_ptrace_stop(),
> then ptrace_check_attach() should be arch-friendly as well.
> 
> So, the patch looks like the bugfix, but I do not understand this
> ia64/sparc magic and thus I do not know how important this fix.
> Nobody complained so far, though.

IIUC, it dumps the register window to userland memory.  ia64 has this
stacked windows of registers which gets wound up and unwound according
to function calls and those need to be dumped to userland memory so
that the debugger can PEEK and POKE them.  Not really sure why
skipping it didn't cause any problem until now tho.

Thanks.

-- 
tejun
