Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752566Ab1KEJdv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Nov 2011 05:33:51 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:63164 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752135Ab1KEJdu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Nov 2011 05:33:50 -0400
Date: Sat, 5 Nov 2011 13:31:46 +0400
From: Vasiliy Kulikov <segoon@openwall.com>
To: Luis Henriques <henrix@camandro.org>
Cc: Miles Lane <miles.lane@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: Linus GIT - INFO: possible circular locking dependency detected
Message-ID: <20111105093146.GA14338@albatros>
References: <CAHFgRy8S0xLfhZxTUOEH5A0PL_Fb79-0-gmbQ=9h2D-xMqt1hA@mail.gmail.com>
 <20111103204930.GA3599@hades>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111103204930.GA3599@hades>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(cc'ed Andrew and Alexey)

On Thu, Nov 03, 2011 at 20:49 +0000, Luis Henriques wrote:
> On Thu, Nov 03, 2011 at 11:57:20AM -0400, Miles Lane wrote:
> ...
> 
> I'm hitting the exact same problem, using a minimal .config file (can send
> it if required), by just running "find /".
> 
> I have bisected the problem and found that commit
> aa6afca5bcaba8101f3ea09d5c3e4100b2b9f0e5 seems to be the cause of it.

procfs holds sig->cred_guard_mutex to ensure the target's credentials are
not changed.  It is held for a little timeslice.  From the stack trace I
don't understand how sys_execve() can happen with ->cred_guard_mutex
held:

static struct dentry *proc_lookupfd_common(struct inode *dir,
					   struct dentry *dentry,
					   instantiate_t instantiate)
{
    ...
	if (lock_trace(task))
		goto out;

	result = instantiate(dir, dentry, task, &fd);
	unlock_trace(task);
    ...
}


static int lock_trace(struct task_struct *task)
{
	int err = mutex_lock_killable(&task->signal->cred_guard_mutex);
	if (err)
		return err;
	if (!ptrace_may_access(task, PTRACE_MODE_ATTACH)) {
		mutex_unlock(&task->signal->cred_guard_mutex);
		return -EPERM;
	}
	return 0;
}

proc_lookupfd_common() always exits without ->cred_guard_mutex held.


Thanks,

-- 
Vasiliy Kulikov
http://www.openwall.com - bringing security into open computing environments
