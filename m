Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752759Ab1EPIbT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 04:31:19 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:51838 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752339Ab1EPIbS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 04:31:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=bpR0T3MdTLPTQ4H5gIirLYf+vEITSQOb/Qebvwzs8V0+a+n91huyvuqOSmM7jKlxox
         uxjOt4VmCx6+YlsalEsS5+JNs172R7W/ksnNeCK2sxhqSPZqO/A87ejj+Djty7tBtftT
         bocDReExJ4G4KO+UU/5f6NNCtg18lMViBuzyo=
Date: Mon, 16 May 2011 10:31:13 +0200
From: Tejun Heo <tj@kernel.org>
To: Jan Kratochvil <jan.kratochvil@redhat.com>
Cc: oleg@redhat.com, vda.linux@googlemail.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org, indan@nul.nu
Subject: Re: PTRACE_SEIZE should not stop  [Re: [PATCH 02/11] ptrace:
 implement PTRACE_SEIZE]
Message-ID: <20110516083113.GN23665@htj.dyndns.org>
References: <1304869745-1073-1-git-send-email-tj@kernel.org>
 <1304869745-1073-3-git-send-email-tj@kernel.org>
 <20110515155602.GD31855@host1.jankratochvil.net>
 <20110515162630.GG23665@htj.dyndns.org>
 <20110515171512.GA24047@host1.jankratochvil.net>
 <20110515172505.GL23665@htj.dyndns.org>
 <20110515194829.GA27023@host1.jankratochvil.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110515194829.GA27023@host1.jankratochvil.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Sun, May 15, 2011 at 09:48:29PM +0200, Jan Kratochvil wrote:
> How to trigger it reliably?  One can just try it in a loop but it takes minutes
> and depends on hardware specifics making it I guess even unreproducible in
> various configurations.  We were allocating various machines for hours in the
> farm but it may be unreproducible anyway.

First of all, I don't think hitting different trap spots would be that
difficult.  Handling different traps after SEIZE might not be easy but
could just be something which needs to be done anyway.  I'm reluctant
to treat the initial trap differently because it's essentially
identical to what happens when a program does PTRACE_INTERRUPT.  It's
just something the program should be able to deal with, somewhat like
read(2) may return shorter amount of data than provided buffer.

> # The debugee does not handle SIGUSR1 so it would crash on its delivery:
> (gdb) handle SIGUSR1 nopass
> Signal        Stop	Print	Pass to program	Description
> SIGUSR1       Yes	Yes	No		User defined signal 1
> (gdb) continue 
> Program received signal SIGUSR1, User defined signal 1.
> 
> OK, GDB has waitpid()ed SIGUSR1 already and still some thread has delivered
> afterwards before GDB has managed to stop that thread.

I can't understand the above sentence.  A thread can't deliver signal
without going through tracer while ptraced.  Can you elaborate a bit
more?

> (gdb) continue 
> Program received signal SIGUSR2, User defined signal 2.
> 
> Only now the user has found SIGUSR2 has also been delivered.  The main thread
> (receiving the signals) has not run yet been resumed at all.

There's no distinction between main or sub threads in terms of signal
delivery unless signal itself is specifically directed to a thread.

> It would be nice if GDB could display all the signals the inferior
> has received as the other threads are stopped already after the
> signals were sent (in pause ()) - this gives user a skewed picture
> of different state in time for each thread.

Isn't that the signal pending mask?

> I would prefer if GDB would print all the signals at once on a single stop:
> 
> Program received signal SIGUSR1, User defined signal 1.
> Program received signal SIGUSR2, User defined signal 2.
> (gdb) _

Ditto.

> (This is not a simple change for GDB as it has many operations bound to
> receiving single signal.)
> 
> Currently when GDB receives SIGUSR1 it has to do PTRACE_CONT before waitpid()
> and receiving SIGUSR2.  The time it does PTRACE_CONT it does not know if then
> waitpid() returns immediately or if the application will run for another hour.
> 
> There are similar problems GDB wanting to do something-like-INTERRUPT sends now
> SIGSTOP and then it wants to remove that SIGSTOP from the inferior's queue as
> it would confuse both user and the debuggee if left there.  Fortunately this
> paragraph's pain will no longer be needed with PTRACE_INTERRUPT.
> 
> For example if you guarantee that after PTRACE_INTERRUPT the INTERRUPT even
> will always get delivered as the last one after all the other signals GDB could
> safely operate on all the delivered signals without a risk of accidentally
> resuming the debuggee before explicitly instructed to do so by the user.

Signal delivery is sequential in nature and delivering a signal which
has user specified signal handler involves roundtrip to userland.  I'm
not following what you're suggesting.

> This is not a real plan how it should be done - but I hope it gives a picture
> debuggers are interested the processing all the already delivered signals.
> GDB should probably check the SigCgt /proc field (it already does in some
> cases) for the informational display of delivered threads.

Okay, I'm a bit confused, so let's clear things up a bit.

* Signal is sent to a group of threads of a specific thread.  Note
  that SIGCONT wakes up stopped process at this point.

* On the receipient, the signal becomes pending.  The mask of pending
  signals is visible through /proc.

* Signal is delievered when the receipient processes those pending
  signals.  This, of course, happens one signal after another.
  Depending on signal and configuration, signal may be ignored, kill,
  stop the process or trigger signal handler which involves roundtrip
  to userland.
  
* ptrace is notified of and can alter signal delivery.

Given the different modes of signal deliveries, I don't think
prioritizing signal delivery to other traps makes sense.

Hmmm... but I think what you want can be achieved with simply calling
PTRACE_INTERRUPT on each signal delivery trap.  The tracee will
deliver the signal and then immediately take INTERRUPT trap.  ie.

* Check if there are pending signals which can be delivered by this
  thread.  Note that different threads may have different pending and
  blocked masks so there isn't a single thread which can do
  everything.

* If there are signals to deliver, CONT it and it will take the signal
  trap (eventually).  During signal trap, do PTRACE_INTERRUPT and then
  let the tracee deliver the signal.  Tracee will deliver the signal
  and take STOP trap.

Is the above enough for your use case?

Thanks.

-- 
tejun
