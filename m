Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752413Ab0CZMCK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Mar 2010 08:02:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12079 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751505Ab0CZMCI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Mar 2010 08:02:08 -0400
Date: Fri, 26 Mar 2010 13:00:28 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Grzegorz Nosek <root@localdomain.pl>
Cc: Matt Helsley <matthltc@us.ibm.com>, Roland McGrath <roland@redhat.com>,
       Sukadev Bhattiprolu <sukadev@us.ibm.com>,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: Testing lxc 0.6.5 in Fedora 13
Message-ID: <20100326120028.GA11311@redhat.com>
References: <20100321195044.GA23757@megiteam.pl> <20100323212834.GH20796@count0.beaverton.ibm.com> <20100325213356.GB20541@megiteam.pl> <20100326111131.GA8604@redhat.com> <20100326113201.GB17113@megiteam.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100326113201.GB17113@megiteam.pl>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/26, Grzegorz Nosek wrote:
>
> On Fri, Mar 26, 2010 at 12:11:31PM +0100, Oleg Nesterov wrote:
> > Yes, this is broken. More precisely, this wasn't even supposed to work.
> >
> > Even stracing of the sub-init itself (or global init btw) has problems,
> > the straced init is not protected from unwanted signals.
>
> Is this impossible/very hard to do cleanly? I understand that container's
> init becomes vulnerable to signals sent from root-owned processes in the
> container. If so, the impact of this issue should be quite limited, no?

Yes, probably we can ignore this.

> > Yes. First of all, tracehook_report_clone_complete() reports the wrong pid nr,
> > as it seen inside the init's namespace. This is easy to fix, but I doubt this
> > can help. IIRC strace doesn't use PTRACE_GETEVENTMSG at all, it looks at eax
> > after syscall.
> >
> > which patch?
>
> The patch below posted by Matt. AIUI, it fixes the
> tracehook_report_clone_complete() part, which results in an observable
> change in strace's behaviour (not that it makes strace work, though).

I guess it doesn't work because we need to fix strace, see "strace doesn't
use PTRACE_GETEVENTMSG" above.

> Anyway, are there any remaining issues on the kernel side or does strace
> have to be taught about pid namespaces?

At first glance, I don't see other problems, except sometimes the reported
pid is wrong (like in do_fork). 

> +               ptrace_pid_vnr = nr;
> +               if (unlikely(p->parent != p->real_parent)) {
> +                       rcu_read_lock();
> +                       ptrace_pid_vnr = task_pid_nr_ns(p, p->parent->nsproxy->pid_ns);

Yes, this is what I meant.

But we should not do this in do_fork().


But once again. This change fixes the value in "tracee->ptrace_message == newpid",
but a quick grep shows that strace-4.5.19 doesn't use PTRACE_GETEVENTMSG at all.

Oleg.

