Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754926Ab1EPM1H (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 08:27:07 -0400
Received: from vps.jankratochvil.net ([46.28.109.124]:44039 "EHLO
	host1.jankratochvil.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754031Ab1EPM1F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 08:27:05 -0400
Date: Mon, 16 May 2011 14:26:42 +0200
From: Jan Kratochvil <jan.kratochvil@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: oleg@redhat.com, vda.linux@googlemail.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org, indan@nul.nu
Subject: Re: PTRACE_SEIZE should not stop  [Re: [PATCH 02/11] ptrace:
 implement PTRACE_SEIZE]
Message-ID: <20110516122642.GD10469@host1.jankratochvil.net>
References: <1304869745-1073-1-git-send-email-tj@kernel.org>
 <1304869745-1073-3-git-send-email-tj@kernel.org>
 <20110515155602.GD31855@host1.jankratochvil.net>
 <20110515162630.GG23665@htj.dyndns.org>
 <20110515171512.GA24047@host1.jankratochvil.net>
 <20110515172505.GL23665@htj.dyndns.org>
 <20110515194829.GA27023@host1.jankratochvil.net>
 <20110516083113.GN23665@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110516083113.GN23665@htj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tejun,

On Mon, 16 May 2011 10:31:13 +0200, Tejun Heo wrote:
> On Sun, May 15, 2011 at 09:48:29PM +0200, Jan Kratochvil wrote:
> > # The debugee does not handle SIGUSR1 so it would crash on its delivery:
> > (gdb) handle SIGUSR1 nopass
> > Signal        Stop	Print	Pass to program	Description
> > SIGUSR1       Yes	Yes	No		User defined signal 1
> > (gdb) continue 
> > Program received signal SIGUSR1, User defined signal 1.
> > 
> > OK, GDB has waitpid()ed SIGUSR1 already and still some thread has delivered
> > afterwards before GDB has managed to stop that thread.
> 
> I can't understand the above sentence.  A thread can't deliver signal
> without going through tracer while ptraced.  Can you elaborate a bit
> more?

I tried to explain why GDB will see SIGUSR1 twice.  Despite it is not
a realtime signal and therefore the signal is "flag", it does not queue/count.
You know better than me why GDB sees SIGUSR1 twice.


> > (gdb) continue 
> > Program received signal SIGUSR2, User defined signal 2.
> > 
> > Only now the user has found SIGUSR2 has also been delivered.  The main thread
> > (receiving the signals) has not run yet been resumed at all.
> 
> There's no distinction between main or sub threads in terms of signal
> delivery unless signal itself is specifically directed to a thread.

This sample code uses only tkill to avoid any mess with which TID will get
which signal.


> > It would be nice if GDB could display all the signals the inferior
> > has received as the other threads are stopped already after the
> > signals were sent (in pause ()) - this gives user a skewed picture
> > of different state in time for each thread.
> 
> Isn't that the signal pending mask?

Yes but how do you query siginfo_t (GDB $_siginfo) of a pending signal to make
it accessible to the user?  You also need to mask out blocked signals and
properly order them like kernel does - which is not guaranteed by POSIX.
You need to reimplement part of the kernel functionality and if you implement
it a bit differently it will break transparency of the debugging.


> > I would prefer if GDB would print all the signals at once on a single stop:
> > 
> > Program received signal SIGUSR1, User defined signal 1.
> > Program received signal SIGUSR2, User defined signal 2.
> > (gdb) _
> 
> Ditto.
> 
> > (This is not a simple change for GDB as it has many operations bound to
> > receiving single signal.)
> > 
> > Currently when GDB receives SIGUSR1 it has to do PTRACE_CONT before waitpid()
> > and receiving SIGUSR2.  The time it does PTRACE_CONT it does not know if then
> > waitpid() returns immediately or if the application will run for another hour.
> > 
> > There are similar problems GDB wanting to do something-like-INTERRUPT sends now
> > SIGSTOP and then it wants to remove that SIGSTOP from the inferior's queue as
> > it would confuse both user and the debuggee if left there.  Fortunately this
> > paragraph's pain will no longer be needed with PTRACE_INTERRUPT.
> > 
> > For example if you guarantee that after PTRACE_INTERRUPT the INTERRUPT even
> > will always get delivered as the last one after all the other signals GDB could
> > safely operate on all the delivered signals without a risk of accidentally
> > resuming the debuggee before explicitly instructed to do so by the user.
> 
> Signal delivery is sequential in nature and delivering a signal which
> has user specified signal handler involves roundtrip to userland.  I'm
> not following what you're suggesting.
> 
> > This is not a real plan how it should be done - but I hope it gives a picture
> > debuggers are interested the processing all the already delivered signals.
> > GDB should probably check the SigCgt /proc field (it already does in some
> > cases) for the informational display of delivered threads.
> 
> Okay, I'm a bit confused, so let's clear things up a bit.
> 
> * Signal is sent to a group of threads of a specific thread.  Note
>   that SIGCONT wakes up stopped process at this point.

Normally yes but this sample code uses tkill to avoid it.


> * On the receipient, the signal becomes pending.  The mask of pending
>   signals is visible through /proc.

But not their siginfo_t, not which are blocked, their ordering etc.


> * Signal is delievered when the receipient processes those pending
>   signals.  This, of course, happens one signal after another.
>   Depending on signal and configuration, signal may be ignored, kill,
>   stop the process or trigger signal handler which involves roundtrip
>   to userland.
>   
> * ptrace is notified of and can alter signal delivery.
> 
> Given the different modes of signal deliveries, I don't think
> prioritizing signal delivery to other traps makes sense.
> 
> Hmmm... but I think what you want can be achieved with simply calling
> PTRACE_INTERRUPT on each signal delivery trap.  The tracee will
> deliver the signal and then immediately take INTERRUPT trap.  ie.
> 
> * Check if there are pending signals which can be delivered by this
>   thread.  Note that different threads may have different pending and
>   blocked masks so there isn't a single thread which can do
>   everything.
> 
> * If there are signals to deliver,

This is the question if the debugger can reliably detect.  Maybe it can.


>   CONT it and it will take the signal
>   trap (eventually).  During signal trap, do PTRACE_INTERRUPT and then
>   let the tracee deliver the signal.  Tracee will deliver the signal
>   and take STOP trap.
> 
> Is the above enough for your use case?

If there is enough documentation - or one reads the soures - one can
reimplement the signal delivery login in userland to expect what will kernel
do.  TBH I do not think it is the right API but you are right it is
workaroundable in userland.


Thanks,
Jan
