Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756538Ab0DFNyJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Apr 2010 09:54:09 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:57098 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755575Ab0DFNyE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Apr 2010 09:54:04 -0400
Date: Tue, 6 Apr 2010 06:53:45 -0700
From: Matt Helsley <matthltc@us.ibm.com>
To: Roland McGrath <roland@redhat.com>
Cc: Oleg Nesterov <oleg@redhat.com>, Grzegorz Nosek <root@localdomain.pl>,
       Matt Helsley <matthltc@us.ibm.com>,
       Sukadev Bhattiprolu <sukadev@us.ibm.com>,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Biederman Eric Biederman <ebiederm@xmission.com>
Subject: Re: Testing lxc 0.6.5 in Fedora 13
Message-ID: <20100406135345.GC3345@count0.beaverton.ibm.com>
References: <20100321195044.GA23757@megiteam.pl>
 <20100323212834.GH20796@count0.beaverton.ibm.com>
 <20100325213356.GB20541@megiteam.pl>
 <20100326111131.GA8604@redhat.com>
 <20100326115357.GA3345@count0.beaverton.ibm.com>
 <20100326124522.GD17113@megiteam.pl>
 <20100326134709.GB15790@redhat.com>
 <20100406034443.8B40ED477@magilla.sf.frob.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100406034443.8B40ED477@magilla.sf.frob.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, Apr 05, 2010 at 08:44:43PM -0700, Roland McGrath wrote:
> (I've been away for a couple of weeks.)
> I concur with the things Oleg's said in this thread.
> 
> As to what's "correct" for the kernel in theory, it would certainly make
> sense to clean up the ptrace cases to use the tracer (parent) pid_ns when
> reporting any PID as such.  The wait and SIGCHLD code already does this, so
> that would be consistent.  Off hand I don't see anything other than
> tracehook_report_clone{,_complete}() that sees the wrong value now.

Yup.

> Fixing that requires a bit of hair.  The simple and clean approach is to
> just have the tracehook calls (i.e. ptrace layer) extract the PID from the
> task_struct using the desired pid_ns.  The trouble there is that the

It's also possible to take an extra reference to the struct pid and pass
that to the tracehook. That and the pid_ns of the tracer receiving the pid
is all we'll ever need inside the tracehook layer. The only advantage, I
think, is we wouldn't pin the task struct while holding the pid reference.

> tracehook_report_clone_complete() call is made when that task_struct is no
> longer guaranteed to be valid.  The contrary approach of extracting the
> appropriate value for the tracer earlier breaks the clean layering because
> the fork.c code really should not know at all that ->parent->nsproxy is the
> place to look for what values to pass to tracehook calls.  I guess the
> simple and clean fix is to get_task_struct() before wake_up_new_task()
> and put_task_struct() after tracehook_report_clone_complete().  That does
> add some gratuitous atomic incr/decr overhead, though.

Also true.

Of course my suggestion of holding the pid reference won't avoid adding
atomic ops -- just changes which refcount they work on.

> 
> None of this has much of anything to do with strace, of course.  As I've
> said, I don't see anything other than the PTRACE_GETEVENTMSG value for
> PTRACE_EVENT_{CLONE,FORK,VFORK} reports that is wrong in the kernel.  As
> Oleg said, strace doesn't use that at all.  (This is not the place to
> discuss the details of strace further.)

Also, looking at proposed changes (utrace and Eric Biederman's setns())
storing a pid nr rather than a reference to a task struct or struct pid
probably won't be correct.

In the case of Eric Biederman's setns(), if capable of changing pid namespace,
we could have:

	Traced				Tracer
	fork()
					... (an arbitrary amount of time passes)
					setns()
					ptrace(GETEVENTMSG)

At which point returning a static pid number held in the message field
produces the wrong pid. Also, if utrace allows multiple tracers and they each
exist in a different namespace then storing a pid nr isn't going to work.

So my hunch is, in the long run, we'll need to hold a reference there and
drop it when the last tracer detaches or the next event would have
overwritten the "message". The amount of time it would need to be held
suggests to me that we should refer to a struct pid and not a task struct
if possible.

Cheers,
	-Matt Helsley
