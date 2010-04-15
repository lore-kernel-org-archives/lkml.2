Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757158Ab0DOVC0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Apr 2010 17:02:26 -0400
Received: from mail-bw0-f225.google.com ([209.85.218.225]:58922 "EHLO
	mail-bw0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757095Ab0DOVCY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Apr 2010 17:02:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=Cu8lI3H8wCOzyiFCZ7CJBPcpLRPKGBuzS8oszaFjVXIQ6+PFtnh0TIQD5RsYvq3BpK
         51mUWXkLwXY1YqEQT7Q6BbA1aVMnI/GK75UiFymzXU0eUq7ogtvCO++a8IWMiYdi+Lta
         0aOd6Kac22T5OInO/H3LRyvWyAR1Zf6h7IdC8=
MIME-Version: 1.0
Date: Fri, 16 Apr 2010 01:02:22 +0400
Message-ID: <t2ka4423d671004151402n7b2dc425mdc9c6bb9640d63fb@mail.gmail.com>
Subject: reiserfs locking
From: Alexander Beregalov <a.beregalov@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Frederic!

[ INFO: possible circular locking dependency detected ]
2.6.34-rc3-00410-gd620a7c #1
-------------------------------------------------------
conftest/3639 is trying to acquire lock:
 (&sb->s_type->i_mutex_key#5){+.+.+.}, at: [<c10f08fc>]
reiserfs_file_release+0x4c/0x3c0

but task is already holding lock:
 (&mm->mmap_sem){++++++}, at: [<c10818e2>] sys_munmap+0x22/0x50

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #1 (&mm->mmap_sem){++++++}:
       [<c104fcb3>] validate_chain+0xa23/0xf70
       [<c10506d0>] __lock_acquire+0x4d0/0xa40
       [<c1050cba>] lock_acquire+0x7a/0xa0
       [<c107b90b>] might_fault+0x7b/0xa0
       [<c11d6866>] copy_to_user+0x36/0x130
       [<c10a05fc>] filldir+0x6c/0xd0
       [<c10f14d1>] reiserfs_readdir_dentry+0x331/0x720
       [<c10f18d7>] reiserfs_readdir+0x17/0x20
       [<c10a07c5>] vfs_readdir+0x85/0xa0
       [<c10a08f8>] sys_getdents+0x68/0xc0
       [<c1002a90>] sysenter_do_call+0x12/0x36

-> #0 (&sb->s_type->i_mutex_key#5){+.+.+.}:
       [<c10501f8>] validate_chain+0xf68/0xf70
       [<c10506d0>] __lock_acquire+0x4d0/0xa40
       [<c1050cba>] lock_acquire+0x7a/0xa0
       [<c135765f>] mutex_lock_nested+0x5f/0x2b0
       [<c10f08fc>] reiserfs_file_release+0x4c/0x3c0
       [<c1094136>] __fput+0xf6/0x230
       [<c1094285>] fput+0x15/0x20
       [<c108092e>] remove_vma+0x3e/0x70
       [<c10817f8>] do_munmap+0x228/0x2f0
       [<c10818ef>] sys_munmap+0x2f/0x50
       [<c1002a90>] sysenter_do_call+0x12/0x36

other info that might help us debug this:

1 lock held by conftest/3639:
 #0:  (&mm->mmap_sem){++++++}, at: [<c10818e2>] sys_munmap+0x22/0x50

stack backtrace:
Pid: 3639, comm: conftest Not tainted 2.6.34-rc3-00410-gd620a7c #1
Call Trace:
 [<c1356147>] ? printk+0x18/0x21
 [<c104ed20>] print_circular_bug+0xc0/0xd0
 [<c10501f8>] validate_chain+0xf68/0xf70
 [<c10425a5>] ? sched_clock_cpu+0x95/0x110
 [<c104ca6b>] ? trace_hardirqs_off+0xb/0x10
 [<c10506d0>] __lock_acquire+0x4d0/0xa40
 [<c1050cba>] lock_acquire+0x7a/0xa0
 [<c10f08fc>] ? reiserfs_file_release+0x4c/0x3c0
 [<c135765f>] mutex_lock_nested+0x5f/0x2b0
 [<c10f08fc>] ? reiserfs_file_release+0x4c/0x3c0
 [<c10f08fc>] ? reiserfs_file_release+0x4c/0x3c0
 [<c10f08fc>] reiserfs_file_release+0x4c/0x3c0
 [<c1080d0e>] ? unlink_file_vma+0x3e/0x50
 [<c135923d>] ? _raw_spin_unlock+0x1d/0x20
 [<c1094136>] __fput+0xf6/0x230
 [<c1094285>] fput+0x15/0x20
 [<c108092e>] remove_vma+0x3e/0x70
 [<c10817f8>] do_munmap+0x228/0x2f0
 [<c10818ef>] sys_munmap+0x2f/0x50
 [<c1002a90>] sysenter_do_call+0x12/0x36
