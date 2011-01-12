Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755896Ab1ALUEo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jan 2011 15:04:44 -0500
Received: from mx2.netapp.com ([216.240.18.37]:19932 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755441Ab1ALUEm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jan 2011 15:04:42 -0500
X-IronPort-AV: E=Sophos;i="4.60,314,1291622400"; 
   d="scan'208";a="504662099"
Subject: Re: vfs-scale, chroot
From: Trond Myklebust <Trond.Myklebust@netapp.com>
To: "J. R. Okajima" <hooanon05@yahoo.co.jp>
Cc: Nick Piggin <npiggin@gmail.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-kernel@vger.kernel.org
In-Reply-To: <29345.1294861630@jrobl>
References: <29345.1294861630@jrobl>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Organization: NetApp Inc
Date: Wed, 12 Jan 2011 15:04:40 -0500
Message-ID: <1294862680.2971.51.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 (2.32.1-1.fc14) 
X-OriginalArrivalTime: 12 Jan 2011 20:04:41.0825 (UTC) FILETIME=[F3133510:01CBB293]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-01-13 at 04:47 +0900, J. R. Okajima wrote: 
> Hello Nick,
> 
> I've got a crash around d_lock.
> 
> # mount -t nfs host:/dir /nfs
> # chroot /nfs
> 
> BUG: spinlock recursion on CPU#1, chroot/2524
>  lock: ffff88001d106880, .magic: dead4ead, .owner: chroot/2524, .owner_cpu: 1
> Call Trace:
>  [<ffffffff8128ca52>] ? spin_bug+0xa2/0xf0
>  [<ffffffff8128cd53>] ? do_raw_spin_lock+0x193/0x1b0
>  [<ffffffff814eaa5e>] ? _raw_spin_lock_nested+0x4e/0x60
>  [<ffffffff81137aef>] ? nameidata_dentry_drop_rcu+0xcf/0x1b0
>  [<ffffffff814eaab3>] ? _raw_spin_lock+0x43/0x50
>  [<ffffffff81137aef>] ? nameidata_dentry_drop_rcu+0xcf/0x1b0
>  [<ffffffff81137c1b>] ? d_revalidate+0x4b/0x70
>  [<ffffffff81139a75>] ? link_path_walk+0x655/0x1210
>  [<ffffffff81138702>] ? path_init_rcu+0x1c2/0x370
>  [<ffffffff811387e5>] ? path_init_rcu+0x2a5/0x370
>  [<ffffffff81138702>] ? path_init_rcu+0x1c2/0x370
>  [<ffffffff811059b3>] ? might_fault+0x53/0xb0
>  [<ffffffff8113a9fe>] ? do_path_lookup+0x8e/0x1d0
>  [<ffffffff8113b936>] ? user_path_at+0xa6/0xe0
>  [<ffffffff8114c167>] ? vfsmount_lock_local_unlock+0x77/0x90
>  [<ffffffff814ebab9>] ? retint_swapgs+0x13/0x1b
>  [<ffffffff81090b15>] ? trace_hardirqs_on_caller+0x145/0x190
>  [<ffffffff8112841e>] ? sys_chdir+0x2e/0x90
>  [<ffffffff8100bfd2>] ? system_call_fastpath+0x16/0x1b
> 
> It looks like nameidata_dentry_drop_rcu() is trying spin_lock() twice
> for the same dentry when parent == dentry.
> 
> - NFS ->d_revalidate() returns -ECHILD for LOOKUP_RCU
> - VFS d_revalidate() will try ->d_revalidate() again after dropping
>   LOOKUP_RCU by nameidata_dentry_drop_rcu().
> - nameidata_dentry_drop_rcu() calls
> 	spin_lock(&parent->d_lock);
> 	spin_lock_nested(&dentry->d_lock, DENTRY_D_LOCK_NESTED);
> - it may happen on all fs which specifies FS_REVAL_DOT
> 
> If we have a function like below, it may be useful.
> But are there so many cases like this problem?
> If it is not so many, then the fix will be adding several
> "if (!IS_ROOT(dentry)" into nameidata_dentry_drop_rcu(), I think.
> 
> int d_lock_parent_child(parent, child)
> {
> 	err = Success;
> 	spin_lock(&parent->d_lock);
> 	if (!IS_ROOT(dentry)) {
> 		spin_lock_nested(&dentry->d_lock, DENTRY_D_LOCK_NESTED);
> 		if (unlikely(parent != dentry->d_parent)) {
> 			spin_unlock(&parent->d_lock);
> 			err = Error_Unmatch;
> 		}
> 	} else
> 		err = Success_Root;
> 	return err;
> }
> 
> void d_unlock_parent_child(int stat, parent, child)
> {
> 	Assert(stat == Error_Unmatch);
> 	if (stat == Success)
> 		spin_unlock(&dentry->d_lock);
> 	spin_unlock(&parent->d_lock);
> }

BTW, Nick: Given that some filesystems such as NFS are _always_ going to
reject LOOKUP_RCU, it would appear to be completely out of place to use
the 'unlikely()' keyword when testing the results of path_walk_rcu() and
friends. In particular when the kernel is running with nfsroot, we're
saying that 100% of all cases are 'unlikely'...

Trond
-- 
Trond Myklebust
Linux NFS client maintainer

NetApp
Trond.Myklebust@netapp.com
www.netapp.com

