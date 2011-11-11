Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758055Ab1KKQoO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Nov 2011 11:44:14 -0500
Received: from mx1.redhat.com ([209.132.183.28]:16633 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757266Ab1KKQoN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Nov 2011 11:44:13 -0500
Date: Fri, 11 Nov 2011 17:39:26 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Pavel Emelyanov <xemul@parallels.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Glauber Costa <glommer@parallels.com>, Nathan Lynch <ntl@pobox.com>,
        Tejun Heo <tj@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Serge Hallyn <serue@us.ibm.com>, Daniel Lezcano <dlezcano@fr.ibm.com>
Subject: Re: [PATCH 3/3] pids: Make it possible to clone tasks with given
	pids
Message-ID: <20111111163926.GA25106@redhat.com>
References: <4EBC0696.9030103@parallels.com> <4EBC06DB.3090202@parallels.com> <20111110184654.GA1006@redhat.com> <20111110185603.GA1757@redhat.com> <4EBCF4E7.4090002@parallels.com> <20111111152532.GA22640@redhat.com> <4EBD461E.1000106@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4EBD461E.1000106@parallels.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/11, Pavel Emelyanov wrote:
>
> On 11/11/2011 07:25 PM, Oleg Nesterov wrote:
> >
> > But. Let me repeat the question, what if you do the same with
> > pids[0] = 2 /* anything != 1 */ ? In this case we create the new
> > pid_ns, but its ->child_reaper is NULL. Unless I missed something.
>
> Hm... You're right here. I've missed the fact, then in recent kernels
> child_reaper is set under pid == 1 condition (was clone_flags & CLONE_NEWPID).

Yes, I always hated the "cleanup" which removed CLONE_NEWPID from
copy_process. This is_child_reaper() simply hides CLONE_NEWPID from
grep.

But this is offtopic. We should not create ->child_reaper with pid_nr != 1.

> How about if I fix it by disabling the simultaneous use of CLONE_NEWPID and
> CLONE_CHILD_USEPIDS and checking for last_pid != 1 in the set_pidmap?

I think this should work...

> > Hmm. It seems, we can make a simpler patch to achieve the (roughly)
> > same effect. Without touching copy_process/alloc_pid paths. What if
> > we simply add PR_SET_LAST_PID? (or something else).
> >
> > In this case the new init (created normally) read the pids from image
> > file and does prcrl(PR_SET_LAST_PID, pid-1) before the next fork.
> >
> > What do you think?
>
> This will make it impossible to fork() children on restore in parallel. And
> I don't want to lose this ability :(

Yes, this is true. You need some form of synchronization in user-space.
But, otoh, prctl/sysctl/whatever is much simpler. Both from implementation
pov and from understanding/using. You can even do, say, pthread_create()
to make a thread with the desired tid. And of course I like the fact we
do not add the new hacks into copy_process's paths.

And. If you want to restore the process tree, then these new children
have to cooperate anyway. Say, nobody can clone() without
CLONE_CHILD_USEPIDS before we restore all pids.

Yes, sysctl+clone should be "atomic", but that is all. Does it really
hurt? OK, if nothing else, can't you do somthing like

	int fork_with_pid(int pid)
	{
		int ret;
		int pipefd[2];

		pipe(pipefd);

	retry:
		prcrl(PR_SET_LAST_PID, pid-1);
		ret = fork();

		if (ret == 0) {
			/* child, wait from parent's ACK */
			read(pipefd[0], 1, NULL);
			return 0;
		}

		/* raced with another user of PR_SET_LAST_PID */
		if (unlikely(ret != pid) {
			kill(ret, SIGKILL);
			waitpid(ret);
			goto retry;
		}

		close(pipefd[1]);
		return pid;
	}

?

Oleg.

