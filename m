Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757441Ab1ANCsN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 21:48:13 -0500
Received: from mx1.redhat.com ([209.132.183.28]:35963 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751576Ab1ANCsD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 21:48:03 -0500
Subject: Re: linux-next: lockdep whinge in cgroup_rmdir
From: Eric Paris <eparis@redhat.com>
To: Valdis.Kletnieks@vt.edu
Cc: Stephen Smalley <sds@tycho.nsa.gov>, James Morris <jmorris@namei.org>,
        Eric Paris <eparis@parisplace.org>, Paul Menage <menage@google.com>,
        linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        containers@lists.linux-foundation.org
In-Reply-To: <12545.1294932849@localhost>
References: <12545.1294932849@localhost>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 13 Jan 2011 21:47:20 -0500
Message-ID: <1294973240.18912.1.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-01-13 at 10:34 -0500, Valdis.Kletnieks@vt.edu wrote:
> Seen booting yesterday's linux-next, was not present in 2.6.37-rc7-mmotm1202.
> 
> Not sure if it's an selinux or cgroup issue, so I'm throwing it at every
> address I can find for either.  This is easily replicatable and happens at
> every boot, so I can test patches if needed.  Am willing to bisect it down if
> nobody knows right off the bat what the problem is.

Not an SELinux issue.  selinux_inode_rmdir() on the stack trace is just
left over junk.  The vfs doesn't call into the filesystem rmdir code
(cgroup_rmdir()) until after the selinux code has already returned.  So
cgroup people, you might as well pretend that wasn't on the stack trace
at all.

-Eric
> 
> The 'W' taint is from the already-reported kernel/workqueue.c worker_enter_idle issue.
> 
> [   85.100795] systemd[1]: readahead-replay.service: main process exited, code=exited, status=1
> [   85.101530] 
> [   85.101531] =============================================
> [   85.101796] [ INFO: possible recursive locking detected ]
> [   85.102002] 2.6.37-next-20110111 #1
> [   85.102009] ---------------------------------------------
> [   85.102009] systemd/1 is trying to acquire lock:
> [   85.102009]  (&(&dentry->d_lock)->rlock){+.+...}, at: [<ffffffff8107ca5c>] cgroup_rmdir+0x339/0x479
> [   85.102009] 
> [   85.102009] but task is already holding lock:
> [   85.102009]  (&(&dentry->d_lock)->rlock){+.+...}, at: [<ffffffff8107ca54>] cgroup_rmdir+0x331/0x479
> [   85.102009] 
> [   85.102009] other info that might help us debug this:
> [   85.102009] 4 locks held by systemd/1:
> [   85.102009]  #0:  (&sb->s_type->i_mutex_key#14/1){+.+.+.}, at: [<ffffffff810fea4d>] do_rmdir+0x7d/0x121
> [   85.102009]  #1:  (&sb->s_type->i_mutex_key#14){+.+.+.}, at: [<ffffffff810fd4bc>] vfs_rmdir+0x4a/0xbe
> [   85.102009]  #2:  (cgroup_mutex){+.+.+.}, at: [<ffffffff8107cb84>] cgroup_rmdir+0x461/0x479
> [   85.102009]  #3:  (&(&dentry->d_lock)->rlock){+.+...}, at: [<ffffffff8107ca54>] cgroup_rmdir+0x331/0x479
> [   85.102009] 
> [   85.102009] stack backtrace:
> [   85.102009] Pid: 1, comm: systemd Tainted: G        W   2.6.37-next-20110111 #1
> [   85.102009] Call Trace:
> [   85.102009]  [<ffffffff81069f22>] ? __lock_acquire+0x929/0xd4e
> [   85.102009]  [<ffffffff8107c6f1>] ? cgroup_clear_directory+0xff/0x131
> [   85.102009]  [<ffffffff8107c6f1>] ? cgroup_clear_directory+0xff/0x131
> [   85.102009]  [<ffffffff8107ca5c>] ? cgroup_rmdir+0x339/0x479
> [   85.102009]  [<ffffffff8106a859>] ? lock_acquire+0x100/0x126
> [   85.102009]  [<ffffffff8107ca5c>] ? cgroup_rmdir+0x339/0x479
> [   85.102009]  [<ffffffff815521ef>] ? sub_preempt_count+0x35/0x48
> [   85.102009]  [<ffffffff8154e401>] ? _raw_spin_lock+0x36/0x45
> [   85.102009]  [<ffffffff8107ca5c>] ? cgroup_rmdir+0x339/0x479
> [   85.102009]  [<ffffffff8107ca5c>] ? cgroup_rmdir+0x339/0x479
> [   85.102009]  [<ffffffff810579cd>] ? autoremove_wake_function+0x0/0x34
> [   85.102009]  [<ffffffff811e1839>] ? selinux_inode_rmdir+0x15/0x17
> [   85.102009]  [<ffffffff810fd4eb>] ? vfs_rmdir+0x79/0xbe
> [   85.102009]  [<ffffffff810feaa0>] ? do_rmdir+0xd0/0x121
> [   85.102009]  [<ffffffff8100256c>] ? sysret_check+0x27/0x62
> [   85.102009]  [<ffffffff8106ac79>] ? trace_hardirqs_on_caller+0x117/0x13b
> [   85.102009]  [<ffffffff8154e201>] ? trace_hardirqs_on_thunk+0x3a/0x3f
> [   85.102009]  [<ffffffff8110040b>] ? sys_rmdir+0x11/0x13
> [   85.102009]  [<ffffffff8100253b>] ? system_call_fastpath+0x16/0x1b
> [   85.268272] systemd[1]: readahead-collect.service: main process exited, code=exited, status=1
> 
> Any ideas?
> 


