Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933001Ab1KHX5T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 18:57:19 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:47106 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754026Ab1KHX5S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 18:57:18 -0500
Date: Tue, 8 Nov 2011 15:57:16 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Vasiliy Kulikov <segoon@openwall.com>
Cc: Luis Henriques <henrix@camandro.org>, Miles Lane <miles.lane@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Alexey Dobriyan <adobriyan@gmail.com>, stable@vger.kernel.org
Subject: Re: Linus GIT - INFO: possible circular locking dependency detected
Message-Id: <20111108155716.33c04ce1.akpm@linux-foundation.org>
In-Reply-To: <20111105093146.GA14338@albatros>
References: <CAHFgRy8S0xLfhZxTUOEH5A0PL_Fb79-0-gmbQ=9h2D-xMqt1hA@mail.gmail.com>
	<20111103204930.GA3599@hades>
	<20111105093146.GA14338@albatros>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 5 Nov 2011 13:31:46 +0400
Vasiliy Kulikov <segoon@openwall.com> wrote:

> (cc'ed Andrew and Alexey)
> 
> On Thu, Nov 03, 2011 at 20:49 +0000, Luis Henriques wrote:
> > On Thu, Nov 03, 2011 at 11:57:20AM -0400, Miles Lane wrote:
> > ...
> > 
> > I'm hitting the exact same problem, using a minimal .config file (can send
> > it if required), by just running "find /".
> > 
> > I have bisected the problem and found that commit
> > aa6afca5bcaba8101f3ea09d5c3e4100b2b9f0e5 seems to be the cause of it.

Well, let's tell the -stable maintainer(s?) that aa6afca5bca ("proc:
fix races against execve() of /proc/PID/fd**") is known to cause a
regression.

> procfs holds sig->cred_guard_mutex to ensure the target's credentials are
> not changed.  It is held for a little timeslice.  From the stack trace I
> don't understand how sys_execve() can happen with ->cred_guard_mutex
> held:
> 
> static struct dentry *proc_lookupfd_common(struct inode *dir,
> 					   struct dentry *dentry,
> 					   instantiate_t instantiate)
> {
>     ...
> 	if (lock_trace(task))
> 		goto out;
> 
> 	result = instantiate(dir, dentry, task, &fd);
> 	unlock_trace(task);
>     ...
> }
> 
> 
> static int lock_trace(struct task_struct *task)
> {
> 	int err = mutex_lock_killable(&task->signal->cred_guard_mutex);
> 	if (err)
> 		return err;
> 	if (!ptrace_may_access(task, PTRACE_MODE_ATTACH)) {
> 		mutex_unlock(&task->signal->cred_guard_mutex);
> 		return -EPERM;
> 	}
> 	return 0;
> }
> 
> proc_lookupfd_common() always exits without ->cred_guard_mutex held.
> 

Yes, it's a strange trace.  udev is a strange thing and can be
triggered by the kernel at odd times.  I wonder if it's possible that
some other process is now synchronously running udevd while holding
cred_guard_mutex.  That wouldn't show up in the backtrace.  But I doubt
if lockdep would notice it either...

Either way, it would be prudent to revert aa6afca5bca from mainline if
we can't get this fixed up soon.
