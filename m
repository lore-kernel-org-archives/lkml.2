Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757922Ab1KKPaT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Nov 2011 10:30:19 -0500
Received: from mx1.redhat.com ([209.132.183.28]:9385 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751284Ab1KKPaR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Nov 2011 10:30:17 -0500
Date: Fri, 11 Nov 2011 16:25:32 +0100
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
Message-ID: <20111111152532.GA22640@redhat.com>
References: <4EBC0696.9030103@parallels.com> <4EBC06DB.3090202@parallels.com> <20111110184654.GA1006@redhat.com> <20111110185603.GA1757@redhat.com> <4EBCF4E7.4090002@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4EBCF4E7.4090002@parallels.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/11, Pavel Emelyanov wrote:
>
> >> Unless: you are using CLONE_NEWPID along with CLONE_CHILD_USEPIDS and
> >> this child_tidptr array has only one pid (before zero pid).
> >
> > And, if you do clone(CLONE_NEWPID | CLONE_CHILD_USEPIDS), then
> > new_ns->child_reaper == NULL (unless you pass "1" in child_tidptr[]) ?
> >
> >> So, could you please explain what I have missed?
> >
> > please ;) I guess I misread this patch completely. Help!
>
> This is how I plan to use this functionality.
>
> When creating an init of a container being restored I call
>
>    pids[0] = 1;
>    pids[1] = 0;
>
>    clone(CLONE_NEWPID | CLONE_CHILD_USEPIDS, &pids)

Yep, this is clear. In this case everything works because the pid_ns
has no pids (and thus ->last_pid == 0).

But. Let me repeat the question, what if you do the same with
pids[0] = 2 /* anything != 1 */ ? In this case we create the new
pid_ns, but its ->child_reaper is NULL. Unless I missed something.

> Then this created "init" task will have to read pids
> from image files and call
>
> pids[0] = <pid>
> pids[1] = 0
>
> clone(CLONE_CHILD_USEPIDS, &pids);
>
> one by one. At this point the last_pid is still 0

Yes, understood. set_pidmap() bypasses the last_pid logic.

Clever hack^Wtrick ;)

May be this deserves a comment above "if (pid_ns->last_pid != 0)",
and perhaps it would be more clean to do this check before anything
else.

Hmm. It seems, we can make a simpler patch to achieve the (roughly)
same effect. Without touching copy_process/alloc_pid paths. What if
we simply add PR_SET_LAST_PID? (or something else).

In this case the new init (created normally) read the pids from image
file and does prcrl(PR_SET_LAST_PID, pid-1) before the next fork.

What do you think?

Oleg.

