Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752703Ab0CZMqd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Mar 2010 08:46:33 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:33268 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751710Ab0CZMqa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Mar 2010 08:46:30 -0400
Date: Fri, 26 Mar 2010 05:46:19 -0700
From: Matt Helsley <matthltc@us.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Grzegorz Nosek <root@localdomain.pl>, Matt Helsley <matthltc@us.ibm.com>,
       Roland McGrath <roland@redhat.com>,
       Sukadev Bhattiprolu <sukadev@us.ibm.com>,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: Testing lxc 0.6.5 in Fedora 13
Message-ID: <20100326124619.GC3345@count0.beaverton.ibm.com>
References: <20100321195044.GA23757@megiteam.pl>
 <20100323212834.GH20796@count0.beaverton.ibm.com>
 <20100325213356.GB20541@megiteam.pl>
 <20100326111131.GA8604@redhat.com>
 <20100326113201.GB17113@megiteam.pl>
 <20100326120028.GA11311@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100326120028.GA11311@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 26, 2010 at 01:00:28PM +0100, Oleg Nesterov wrote:
> On 03/26, Grzegorz Nosek wrote:
> >
> > On Fri, Mar 26, 2010 at 12:11:31PM +0100, Oleg Nesterov wrote:
> > > Yes, this is broken. More precisely, this wasn't even supposed to work.
> > >
> > > Even stracing of the sub-init itself (or global init btw) has problems,
> > > the straced init is not protected from unwanted signals.
> >
> > Is this impossible/very hard to do cleanly? I understand that container's
> > init becomes vulnerable to signals sent from root-owned processes in the
> > container. If so, the impact of this issue should be quite limited, no?
> 
> Yes, probably we can ignore this.
> 
> > > Yes. First of all, tracehook_report_clone_complete() reports the wrong pid nr,
> > > as it seen inside the init's namespace. This is easy to fix, but I doubt this
> > > can help. IIRC strace doesn't use PTRACE_GETEVENTMSG at all, it looks at eax
> > > after syscall.
> > >
> > > which patch?
> >
> > The patch below posted by Matt. AIUI, it fixes the
> > tracehook_report_clone_complete() part, which results in an observable
> > change in strace's behaviour (not that it makes strace work, though).
> 
> I guess it doesn't work because we need to fix strace, see "strace doesn't
> use PTRACE_GETEVENTMSG" above.
> 
> > Anyway, are there any remaining issues on the kernel side or does strace
> > have to be taught about pid namespaces?
> 
> At first glance, I don't see other problems, except sometimes the reported
> pid is wrong (like in do_fork). 
> 
> > +               ptrace_pid_vnr = nr;
> > +               if (unlikely(p->parent != p->real_parent)) {
> > +                       rcu_read_lock();
> > +                       ptrace_pid_vnr = task_pid_nr_ns(p, p->parent->nsproxy->pid_ns);
> 
> Yes, this is what I meant.
> 
> But we should not do this in do_fork().

I'm puzzled. If not here, where should we do this? Or are you saying
ptrace should take a reference to the pid, store it, and get the vnr during
PTRACE_GETEVENTMSG? (drop the reference at detach or when a new pid reference
comes in..)

> But once again. This change fixes the value in "tracee->ptrace_message == newpid",
> but a quick grep shows that strace-4.5.19 doesn't use PTRACE_GETEVENTMSG at all.

You are correct. However strace and gdb aren't necessarily the only users
of ptrace so wouldn't it still be good to fix this?

Cheers,
	-Matt Helsley
