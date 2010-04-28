Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754151Ab0D1GB0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Apr 2010 02:01:26 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:40697 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753566Ab0D1GBY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Apr 2010 02:01:24 -0400
Subject: Re: 2.6.33.3-rt16 Oops caused by umount
From: john stultz <johnstul@us.ibm.com>
To: Xianghua Xiao <xiaoxianghua@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <s2me6bf505b1004271354v128e0e89q6b506ce99af6d7fd@mail.gmail.com>
References: <l2ye6bf505b1004271144ta6817962vec8167d813658648@mail.gmail.com>
	 <alpine.LFD.2.00.1004272053130.2951@localhost.localdomain>
	 <1272399798.2255.2.camel@localhost>	 <1272400246.2255.5.camel@localhost>
	 <s2me6bf505b1004271354v128e0e89q6b506ce99af6d7fd@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 27 Apr 2010 23:01:21 -0700
Message-ID: <1272434481.1974.101.camel@work-vm>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-04-27 at 15:54 -0500, Xianghua Xiao wrote:
> On Tue, Apr 27, 2010 at 3:30 PM, john stultz <johnstul@us.ibm.com> wrote:
> > On Tue, 2010-04-27 at 13:23 -0700, john stultz wrote:
> >> On Tue, 2010-04-27 at 20:56 +0200, Thomas Gleixner wrote:
> >> > On Tue, 27 Apr 2010, Xianghua Xiao wrote:
> >> > > 2.6.33.2-rt13 worked fine, however on 2.6.33.3-rt16, when I do reboot, it oops:
> >> > >
> >> > > # reboot
> >> > > # Oops: Kernel access of bad area, sig: 11 [#1]
> >> > > PREEMPT 83xx Sys
> >> > > Modules linked in:
> >> > > NIP: c00efc68 LR: c00efc38 CTR: 00000000
> >> > > REGS: ce6e3dc0 TRAP: 0300   Not tainted  (2.6.33.3-rt16)
> >> > > MSR: 00009032 <EE,ME,IR,DR>  CR: 24000448  XER: 00000000
> >> > > DAR: 00000038, DSISR: 20000000
> >> > > TASK = cd89ccc0[1613] 'umount' THREAD: ce6e2000
> >> > > GPR00: 00000000 ce6e3e70 cd89ccc0 ce6e3ddc 22222222 00000000 ce6e3e24 ce6e3e04
> >> > > GPR08: 00008000 00000010 cdfa2130 cdfa26e0 44000442 100bbc1c 0fffd000 ffffffff
> >> > > GPR16: 00000001 00000000 007fff00 00000000 00000000 00000001 ce6e3eb8 00000021
> >> > > GPR24: 00000060 00000000 00000000 ceb94c40 00000000 ceb94cc0 c065781c ce6e3e70
> >> > > NIP [c00efc68] fs_may_remount_ro+0x6c/0xd8
> >> > > LR [c00efc38] fs_may_remount_ro+0x3c/0xd8
> >> > > Call Trace:
> >> > > [ce6e3e70] [c00efc38] fs_may_remount_ro+0x3c/0xd8 (unreliable)
> >> > > [ce6e3e90] [c00f1198] do_remount_sb+0x11c/0x164
> >> > > [ce6e3eb0] [c0113a3c] do_mount+0x538/0x86c
> >> > > [ce6e3f10] [c0113e30] sys_mount+0xc0/0x120
> >> > > [ce6e3f40] [c00178d8] ret_from_syscall+0x0/0x38
> >> > > --- Exception: c01 at 0xfe5f8c4
> >> > >     LR = 0x10051b88
> >> > > Instruction dump:
> >> > > 38000000 817d00c0 3bbd00c0 60088000 814b0000 2f8a0000 419e0008 7c00522c
> >> > > 7f8be800 419e004c 812b000c 81290040 <80090028> 2f800000 419e0028 a009006e
> >> > > ---[ end trace 17c711f9d369c3a3 ]---
> >>
> >> Hey Xianghua,
> >>       What filesystem was this on? And what architecture?
> >
> it's ext2 and powerpc 834x. config.gz is attached.
> the same config is used on 2.6.33.2-rt13 which did not show this umount oops.

So I've not been able to reproduce the issue, but I have found a few
problems in hunting down the issue Luis reported, and one of them may be
affecting you here.

Could you try the patch below and let me know if it resolves it for you?

thanks
-john


Fix 3 logic bugs in the vfs-scalability patches.

1) Typo that could cause a deadlock in do_umount
2) Improve MNT_MOUNT handling on cloned rootfs
3) Fix might_sleep in atomic in put_mnt_ns

These may not be totally correct, as I still am chasing down some
namespace issues triggered by unshare().

Signed-off-by: John Stultz <johnstul@us.ibm.com>

diff --git a/fs/namespace.c b/fs/namespace.c
index 5459a05..8c5d60b 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -1233,7 +1233,7 @@ static int do_umount(struct vfsmount *mnt, int flags)
 		 */
 		vfsmount_write_lock();
 		if (count_mnt_count(mnt) != 2) {
-			vfsmount_write_lock();
+			vfsmount_write_unlock();
 			return -EBUSY;
 		}
 		vfsmount_write_unlock();
@@ -1376,6 +1376,12 @@ struct vfsmount *copy_tree(struct vfsmount *mnt, struct dentry *dentry,
 	if (!q)
 		goto Enomem;
 	q->mnt_mountpoint = mnt->mnt_mountpoint;
+	/*
+	 * We don't call attach_mnt on rootfs, so set
+	 * it as mounted here.
+	 */
+	WARN_ON(q->mnt_flags & MNT_MOUNTED);
+	q->mnt_flags |= MNT_MOUNTED;
 
 	p = mnt;
 	list_for_each_entry(r, &mnt->mnt_mounts, mnt_child) {
@@ -2513,17 +2519,15 @@ void put_mnt_ns(struct mnt_namespace *ns)
 {
 	struct vfsmount *root;
 	LIST_HEAD(umount_list);
-	spinlock_t *lock;
 
-	lock = &get_cpu_var(vfsmount_lock);
-	if (!atomic_dec_and_lock(&ns->count, lock)) {
-		put_cpu_var(vfsmount_lock);
+	vfsmount_write_lock();
+	if (!atomic_dec_and_test(&ns->count)){
+		vfsmount_write_unlock();
 		return;
 	}
 	root = ns->root;
 	ns->root = NULL;
-	spin_unlock(lock);
-	put_cpu_var(vfsmount_lock);
+	vfsmount_write_unlock();
 
 	down_write(&namespace_sem);
 	vfsmount_write_lock();




