Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756858Ab1FDAgj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jun 2011 20:36:39 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:46853 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756778Ab1FDAgh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jun 2011 20:36:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=TH9UHIXt4oL3KPywywuMy45h14wPAFy2skFAaq2s68l3reKKzNuP9nWQ7AOWhcGzU4
         /Ay7Q5c0Nh4TM/xubsMbLs//tWmRvgD4sG5cSzGwFeZCV2dch9SFzDJZqEndgP2o/yMz
         YHBrdXq4mScLGQyo0mdynJJMlvCt5TWKgP+Ck=
Message-ID: <4DE97E12.1030900@lwfinger.net>
Date: Fri, 03 Jun 2011 19:36:34 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110414 SUSE/3.1.10 Thunderbird/3.1.10
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>, Tejun Heo <tj@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
CC: Amit Shah <amit.shah@redhat.com>, Jens Axboe <jaxboe@fusionio.com>
Subject: Regression for 3.0-rc1 - bisected to commit ea6949b66d084a197dd7f243b72e216a71d9f2ca
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With kernel 3.0-rc1 and an openSUSE 11.4 distro, my HP dv2815nr notebook fails 
to boot. Bisection leads to the following:

finger@larrylap:~/linux-2.6> git bisect bad
ea6949b66d084a197dd7f243b72e216a71d9f2ca is the first bad commit
commit ea6949b66d084a197dd7f243b72e216a71d9f2ca
Author: Tejun Heo <tj@kernel.org>
Date:   Thu Apr 21 20:54:44 2011 +0200

     cdrom: always check_disk_change() on open

     cdrom_open() called check_disk_change() after the rest of open path
     succeeded which leads to the following bizarre behavior.

     * After media change, if the device opened without O_NONBLOCK,
       open_for_data() naturally fails with -ENOMEDIA and
       check_disk_change() is never called.  The media is known to be gone
       and the open failure makes it obvious to the userland but device
       invalidation never happens.

     * But if the device is opened with O_NONBLOCK, all the checks are
       bypassed and cdrom_open() doesn't notice that the media is not there
       and check_disk_change() is called and invalidation happens.

     There's nothing to be gained by avoiding calling check_disk_change()
     on open failure.  Common cases end up calling check_disk_change()
     anyway.  All we get is inconsistent behavior.

     Fix it by moving check_disk_change() invocation to the top of
     cdrom_open() so that it always gets called regardless of how the rest
     of open proceeds.

     Note for stable: 2.6.38 and later only

     Cc: stable@kernel.org
     Signed-off-by: Tejun Heo <tj@kernel.org>
     Reported-by: Amit Shah <amit.shah@redhat.com>
     Tested-by: Amit Shah <amit.shah@redhat.com>
     Signed-off-by: Jens Axboe <jaxboe@fusionio.com>

:040000 040000 6af2e041bcda269a2378f5c8bf10f11fb1903d32 
8dbfeb49db2617d65b4074094c3ff0e2a8159a23 M      drivers

Although I was concerned when I discovered that bisection led to the very first 
patch in a branch, I found that 3.0-rc1 booted when this patch was reverted.

To help debug it, I added some printk's before and after the relocated call to 
check_disk_change(). After those showed that user space was infinite looping, I 
added a dump_stack() with the following result:

Jun  2 23:11:55 (none) kernel: [   59.311058] Entering cdrom_open
Jun  2 23:11:55 (none) kernel: [   59.313351] Pid: 5776, comm: udisks-part-id 
Not tainted 3.0.0-rc1-Linus+ #47
Jun  2 23:11:55 (none) kernel: [   59.313354] Call Trace:
Jun  2 23:11:55 (none) kernel: [   59.313365]  [<ffffffffa009ba6f>] 
cdrom_open+0x4f/0x610 [cdrom]
Jun  2 23:11:55 (none) kernel: [   59.313372]  [<ffffffff81351ae1>] ? 
__mutex_unlock_slowpath+0xc1/0x150
Jun  2 23:11:55 (none) kernel: [   59.313377]  [<ffffffff81081f1d>] ? 
trace_hardirqs_on_caller+0x13d/0x180
Jun  2 23:11:55 (none) kernel: [   59.313381]  [<ffffffff81081f6d>] ? 
trace_hardirqs_on+0xd/0x10
Jun  2 23:11:55 (none) kernel: [   59.313387]  [<ffffffffa00da5d7>] 
idecd_open+0xc7/0xe0 [ide_cd_mod]
Jun  2 23:11:55 (none) kernel: [   59.313393]  [<ffffffff811515b7>] 
__blkdev_get+0x97/0x3e0
Jun  2 23:11:55 (none) kernel: [   59.313397]  [<ffffffff81151c80>] ? 
blkdev_get+0x380/0x380
Jun  2 23:11:55 (none) kernel: [   59.313401]  [<ffffffff8115194e>] 
blkdev_get+0x4e/0x380
Jun  2 23:11:55 (none) kernel: [   59.313406]  [<ffffffff81353206>] ? 
_raw_spin_unlock+0x26/0x30
Jun  2 23:11:55 (none) kernel: [   59.313410]  [<ffffffff81151c80>] ? 
blkdev_get+0x380/0x380
Jun  2 23:11:55 (none) kernel: [   59.313414]  [<ffffffff81151ce0>] 
blkdev_open+0x60/0x80
Jun  2 23:11:55 (none) kernel: [   59.313419]  [<ffffffff8111b7af>] 
__dentry_open+0x12f/0x2f0
Jun  2 23:11:55 (none) kernel: [   59.313423]  [<ffffffff81353206>] ? 
_raw_spin_unlock+0x26/0x30
Jun  2 23:11:55 (none) kernel: [   59.313427]  [<ffffffff8111c8f1>] 
nameidata_to_filp+0x71/0x80
Jun  2 23:11:55 (none) kernel: [   59.313432]  [<ffffffff8112b04a>] 
do_last+0xda/0x910
Jun  2 23:11:55 (none) kernel: [   59.313437]  [<ffffffff8112c26b>] 
path_openat+0xcb/0x400
Jun  2 23:11:55 (none) kernel: [   59.313441]  [<ffffffff810f7567>] ? 
might_fault+0x57/0xb0
Jun  2 23:11:55 (none) kernel: [   59.313445]  [<ffffffff810f7567>] ? 
might_fault+0x57/0xb0
Jun  2 23:11:55 (none) kernel: [   59.313449]  [<ffffffff8112c5e4>] 
do_filp_open+0x44/0xa0
Jun  2 23:11:55 (none) kernel: [   59.313454]  [<ffffffff81353206>] ? 
_raw_spin_unlock+0x26/0x30
Jun  2 23:11:55 (none) kernel: [   59.313458]  [<ffffffff81139104>] ? 
alloc_fd+0xf4/0x150
Jun  2 23:11:55 (none) kernel: [   59.313462]  [<ffffffff8111c9fc>] 
do_sys_open+0xfc/0x1d0
Jun  2 23:11:55 (none) kernel: [   59.313467]  [<ffffffff8111caeb>] 
sys_open+0x1b/0x20
Jun  2 23:11:55 (none) kernel: [   59.313472]  [<ffffffff81353c7b>] 
system_call_fastpath+0x16/0x1b
Jun  2 23:11:55 (none) kernel: [   59.328377] Back from check_disk_change

 From the above, it seems to me that program "udisks-part-id" is looping on the 
attempt to mount a cdrom.

 From the commit message, it seems to me that this change is correct, and that 
the user-space program has the bug. I am posting this to provide a trail for 
anyone else that hits the problem, and to solicit any help in developing a 
proper fix. Until such a fix is available, I can always revert ea6949b.

Bug 698104 on http://bugzilla.novell.com has been filed for this issue.

Thanks,

Larry
