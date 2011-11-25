Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753684Ab1KYWgt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Nov 2011 17:36:49 -0500
Received: from relay1.mentorg.com ([192.94.38.131]:58612 "EHLO
	relay1.mentorg.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753423Ab1KYWgs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Nov 2011 17:36:48 -0500
From: Pedro Alves <pedro@codesourcery.com>
Organization: CodeSourcery
To: Pavel Emelyanov <xemul@parallels.com>
Subject: Re: [RFC][PATCH 0/3] fork: Add the ability to create tasks 
 =?iso-8859-1?q?with=09given?= pids
Date: Fri, 25 Nov 2011 22:36:39 +0000
User-Agent: KMail/1.13.6 (Linux/2.6.38-12-generic; KDE/4.7.2; x86_64; ; )
Cc: Oleg Nesterov <oleg@redhat.com>, Tejun Heo <tj@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        James Bottomley <jbottomley@parallels.com>
References: <201111221204.39235.pedro@codesourcery.com> <20111125165409.GA19238@redhat.com> <4ECFCA5E.1020307@parallels.com>
In-Reply-To: <4ECFCA5E.1020307@parallels.com>
MIME-Version: 1.0
Content-Type: Text/Plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-Id: <201111252236.40246.pedro@codesourcery.com>
X-OriginalArrivalTime: 25 Nov 2011 22:36:43.0391 (UTC) FILETIME=[B4E678F0:01CCABC2]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 25 November 2011 17:03:26, Pavel Emelyanov wrote:
> On 11/25/2011 08:54 PM, Oleg Nesterov wrote:
> > How you can restore the multithread tracee?
> 
> Don't know :) But if this approach sounds promising (I see, that now it's not, but...) I
> can think more on it.
> 
> > You need to unreserve/reserve the previous pid, and we have the same problems again, no?
> 
> With the existing patch - yes, but as I said above - we need to decide which direction to
> go and then I'll think further.

Thanks for thinking about all this.  Being able to reserve pids would be
nice, but I won't pretend to know the kernel's internals enough to be able
to suggest a sane and acceptable way to do it.  We'd have to be able
to restore multi-threaded tracees (which would also mean that there are
pids which leaders and others which are clones), and, we'd have to support
a single-threaded tracer debugging (and spawning) more than one process,
while not all tracees are involved in C/R.  Maybe this (reservation) issue
should be be considered an orthogonal mechanism for now.

> By now your opinion is to better stay where we are ;) but if moving is unavoidable, then
> it's better to take the CLONE_CHILD_USEPIDS route. That's my position as well.

>From the perspective of a client that is
going to use this on a live system, CLONE_CHILD_USEPIDS seems a little better,
in that the pid race is only against another task reusing the same pid,
while with setting last_pid, you have a try/whoops-not-the-pid-I-want/kill/retry/rinse/repeat/
loop racing against all fork/clone's in the system, along with possibly
needing to first to do a kill(PID, 0) to check whether the PID is
available (unless setting last_pid already detects that).

BTW, it's not only GDB that would want this for live systems.
Check out Berkeley Lab's C/R (https://ftg.lbl.gov/projects/CheckpointRestart/),
where these guys use mixed kernel/userspace C/R in clusters for high-end
scientific computing to e.g., migrate tasks between nodes, and pause/resume
parallel MPI jobs (on live systems).  (Apologies if everyone already knows
about this :-) .)

>From what I read from their papers, in their approach, from userspace, they
spawn new children as usual, with whatever pids the kernel wants, and then
afterwards (from userspace, but through a kernel module), magically change
the process and threads's pids to the pids they really want.  They also fixup
the parent pids, and session ids after the fact, along the way.

-- 
Pedro Alves
