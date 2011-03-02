Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751264Ab1CBFHq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 00:07:46 -0500
Received: from smarthost1.greenhost.nl ([195.190.28.78]:38340 "EHLO
	smarthost1.greenhost.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750702Ab1CBFHp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 00:07:45 -0500
Message-ID: <830cc1666bd4a610d5e870218f06bd2d.squirrel@webmail.greenhost.nl>
In-Reply-To: <20110301183454.GC23527@mtj.dyndns.org>
References: <20110301152457.GE26074@htj.dyndns.org>
    <201103011757.48593.vda.linux@googlemail.com>
    <20110301170953.GB17933@htj.dyndns.org>
    <AANLkTi=8=Tw2aYzvwM_s8dsMmw3W_tYjsYkqTHS9moUW@mail.gmail.com>
    <20110301183454.GC23527@mtj.dyndns.org>
Date: Wed, 2 Mar 2011 06:07:35 +0100 (CET)
Subject: Re: [RFC] Proposal for ptrace improvements
From: "Indan Zupancic" <indan@nul.nu>
To: "Tejun Heo" <tj@kernel.org>
Cc: "Denys Vlasenko" <vda.linux@googlemail.com>,
        "Oleg Nesterov" <oleg@redhat.com>,
        "Roland McGrath" <roland@redhat.com>, jan.kratochvil@redhat.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org
User-Agent: SquirrelMail/1.4.17
MIME-Version: 1.0
Content-Type: text/plain;charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
X-Spam-Score: 0.1
X-Scan-Signature: 788438cbfdc4dc137ce560360a3a99c7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Tue, March 1, 2011 19:34, Tejun Heo wrote:
> Maybe it should, maybe not, but that's mostly irrelevant because the
> described behavior is the current behavior.  There is no
> continue-if-not-job-control-stopped operation and we shouldn't change
> that beneath gdb because otherwise not only the behavior changes
> unexpectedly but also the user doesn't have a way to resume the tracee
> from within gdb.  The user has to go to another terminal and send
> SIGCONT explicitly.  If gdb wants to improve the behavior, it sure can
> implement proper job control behavior using the proposed changes.

I'm not sure what Denys is talking about: Currently it's impossible to
pass along SIGSTOP to traced processes. Quoting the ptrace manpage:

   PTRACE_CONT
          Restarts  the stopped child process.  If data is nonzero and not
          SIGSTOP, it is interpreted as a signal to be  delivered  to  the
          child;  otherwise,  no  signal is delivered.

So you can pass along signals, but it's ignored if it happens to be
SIGSTOP. If you emulate SIGSTOP signals in the tracer by not calling
PTRACE_CONT, SIGCONT on the task won't work because the task can't
receive the signal until it's continued by the tracer, but the tracer
doesn't get a new notification until it resumes the task.

As for distinguishing STOP signals from stopped childs: Just don't set
the WUNTRACED flag in the tracer for waitpid.

If you want SIGSTOP to work on a traced task, then you have to add a
new PTRACE_SETOPTIONS option which enables the changed behaviour.
E.g. PTRACE_O_SIGSTOP which does pass all signals, even SIGSTOP for
PTRACE_CONT/SYSCALL/etc. Without something like this I don't see how
you can make job control for traced tasks work.

To me it seems clear that job ctl state should be managed independently
of ptrace stopped state.  I'm not sure how that fits in with your
proposed changes, but my impression is that you make everything a lot
simpler by separating traced stopping/continuing from SIGSTOP/SIGCONT
job control. It's just not the same. A task stopped by a trace event
shouldn't generate a STOP signal for it's parent, only for real SIGSTOPS.

Greetings,

Indan


