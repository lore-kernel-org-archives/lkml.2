Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752055Ab1K0Jlo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Nov 2011 04:41:44 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:47461 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750973Ab1K0Jlm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Nov 2011 04:41:42 -0500
Message-ID: <4ED205D1.5060407@openvz.org>
Date: Sun, 27 Nov 2011 13:41:37 +0400
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.19) Gecko/20111108 Iceape/2.0.14
MIME-Version: 1.0
To: Pavel Emelyanov <xemul@parallels.com>
CC: Oleg Nesterov <oleg@redhat.com>, Tejun Heo <tj@kernel.org>,
        Pedro Alves <pedro@codesourcery.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        James Bottomley <jbottomley@parallels.com>
Subject: Re: [RFC][PATCH 0/3] fork: Add the ability to create tasks with	given
 pids
References: <4EC4F2FB.408@parallels.com> <201111221204.39235.pedro@codesourcery.com> <20111122153326.GD322@google.com> <201111231620.45440.pedro@codesourcery.com> <20111123162417.GE25780@google.com> <4ECD3946.1030503@parallels.com> <4ECD542C.7010705@parallels.com> <20111124173121.GA23260@redhat.com> <4ECF6AA0.80006@parallels.com>
In-Reply-To: <4ECF6AA0.80006@parallels.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Emelyanov wrote:
> OK, here's another proposal that seem to suit all of us:
>
> 1. me wants to clone tasks with pids set
> 2. Pedro wants to fork task with not changing pids and w/o root perms
> 3. Oleg and Tejun want to have little intrusion into fork() path
>
> The proposal is to implement the PR_RESERVE_PID prctl which allocates and puts a
> pid on the current. The subsequent fork() uses this pid, this pid survives and keeps
> its bit in the pidmap after detach. The 2nd fork() after the 1st task death thus
> can reuse the same pid again. This basic thing doesn't require root perms at all
> and safe against pid reuse problems. When requesting for pid reservation task may
> specify a pid number it wants to have, but this requires root perms (CAP_SYS_ADMIN).
>
> Pedro, I suppose this will work for your checkpoint feature in gdb, am I right?
>
> Few comments about intrusion:
>
>   * the common path - if (pid !=&init_struct_pid) - on fork is just modified
>   * we have -1 argument to copy_process
>   * one more field on struct pid is OK, since it size doesn't change (32 bit level is
>     anyway not required, it's OK to reduce on down to 16 bits)
>   * no clone flags extension
>   * no new locking - the reserved pid manipulations happen under tasklist_lock and
>     existing common paths do not require more of it
>   * yes, we have +1 member on task_struct :(
>
> Current API problems:
>
>   * Only one fork() with pid at a time. Next call to PR_RESERVE_PID will kill the
>     previous reservation (don't know how to fix)
>   * No way to fork() an init of a pid sub-namespace with desired pid in current
>     (can be fixed for a flag for PR_RESERVE_PID saying that we need a pid for a
>      namespace of a next level)

>   * No way to grab existing pid for reserve (can be fixed, if someone wants this)

We can add flag to sys_wait4(), and stash pid in wait_task_zombie(), right before release_task()
code will looks something like this:

-       if (p != NULL)
+       if (p != NULL) {
+               if ((wo->wo_flags & WCATCHPID) && !current->pid_stash) {
+                       struct pid *pid = task_pid(p);
+
+                       pid->flags |= PID_STASHED;
+                       current->pid_stash = get_pid(pid);
+               }
                 release_task(p);
+       }

And next fork() creates child with the same pid.
So, struct pid will work like boomerang =)
