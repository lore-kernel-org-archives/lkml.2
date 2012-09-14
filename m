Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759322Ab2INJX3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 05:23:29 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:59413 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758462Ab2INJX1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 05:23:27 -0400
Message-ID: <5052F78A.7010007@suse.cz>
Date: Fri, 14 Sep 2012 11:23:22 +0200
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120825 Thunderbird/15.0
MIME-Version: 1.0
To: aris@redhat.com
CC: Andrew Morton <akpm@linux-foundation.org>,
        Linux kernel mailing list <linux-kernel@vger.kernel.org>,
        Tejun Heo <tj@kernel.org>, lizefan@huawei.com,
        containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        Jiri Slaby <jirislaby@gmail.com>
Subject: include/linux/cgroup.h:553 suspicious rcu_dereference_check() usage!
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

with current -next trees and LDEP enabled, I'm getting:
===============================
[ INFO: suspicious RCU usage. ]
3.6.0-rc5-next-20120913+ #42 Not tainted
-------------------------------
/home/latest/linux/include/linux/cgroup.h:553 suspicious
rcu_dereference_check() usage!

other info that might help us debug this:


rcu_scheduler_active = 1, debug_locks = 0
2 locks held by kdevtmpfs/23:
 #0:  (sb_writers){.+.+.+}, at: [<ffffffff8116873f>]
mnt_want_write+0x1f/0x50
 #1:  (&sb->s_type->i_mutex_key#3/1){+.+.+.}, at: [<ffffffff811558af>]
kern_path_create+0x7f/0x170

stack backtrace:
Pid: 23, comm: kdevtmpfs Not tainted 3.6.0-rc5-next-20120913+ #42
Call Trace:
 [<ffffffff810c638d>] lockdep_rcu_suspicious+0xfd/0x130
 [<ffffffff8121541d>] devcgroup_inode_mknod+0x19d/0x240
 [<ffffffff8107bf54>] ? ns_capable+0x44/0x80
 [<ffffffff81156b21>] vfs_mknod+0x71/0xf0
 [<ffffffff813a8332>] handle_create.isra.2+0x72/0x200
 [<ffffffff813a85d4>] devtmpfsd+0x114/0x140
 [<ffffffff813a84c0>] ? handle_create.isra.2+0x200/0x200
 [<ffffffff81093ad6>] kthread+0xd6/0xe0
 [<ffffffff81654f24>] kernel_thread_helper+0x4/0x10
 [<ffffffff8165369d>] ? retint_restore_args+0xe/0xe
 [<ffffffff81093a00>] ? kthread_create_on_node+0x140/0x140
 [<ffffffff81654f20>] ? gs_change+0xb/0xb


It's due to the commit "device_cgroup: convert device_cgroup internally
to policy + exceptions". It removed rcu locks which are needed in
task_devcgroup called in this chain: devcgroup_inode_mknod OR
__devcgroup_inode_permission -> __devcgroup_inode_permission ->
task_devcgroup -> task_subsys_state -> task_subsys_state_check.

regards,
-- 
js
suse labs
