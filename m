Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964942Ab2EXSWZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 14:22:25 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:45877 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754055Ab2EXSWX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 14:22:23 -0400
Message-ID: <1337883797.3292.18.camel@lappy>
Subject: fs,eventfd: BUG kmalloc-128, Poison overwritten
From: Sasha Levin <levinsasha928@gmail.com>
To: viro <viro@zeniv.linux.org.uk>
Cc: Dave Jones <davej@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Date: Thu, 24 May 2012 20:23:17 +0200
Content-Type: text/plain; charset="us-ascii"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

During fuzzing with trinity inside a KVM tools guest, using latest linux-next, I've stumbled on the following:

[ 1113.948407] =============================================================================
[ 1113.949014] BUG kmalloc-128 (Tainted: G        W   ): Poison overwritten
[ 1113.949014] -----------------------------------------------------------------------------
[ 1113.949014] 
[ 1113.949014] INFO: 0xffff8800496c8000-0xffff8800496c8000. First byte 0x6a instead of 0x6b
[ 1113.949014] INFO: Allocated in eventfd_file_create+0x4d/0xd0 age=54768 cpu=4 pid=15908
[ 1113.949014]  __slab_alloc+0x638/0x6f0
[ 1113.949014]  kmem_cache_alloc_trace+0xbb/0x230
[ 1113.949014]  eventfd_file_create+0x4d/0xd0
[ 1113.949014]  sys_eventfd2+0x3a/0x80
[ 1113.949014]  system_call_fastpath+0x16/0x1b
[ 1113.949014] INFO: Freed in eventfd_ctx_put+0x14/0x20 age=51749 cpu=4 pid=15908
[ 1113.949014]  __slab_free+0x33/0x560
[ 1113.949014]  kfree+0x2bb/0x2d0
[ 1113.949014]  eventfd_ctx_put+0x14/0x20
[ 1113.949014]  eventfd_release+0x30/0x40
[ 1113.949014]  __fput+0x11a/0x2c0
[ 1113.949014]  fput+0x15/0x20
[ 1113.949014]  filp_close+0x82/0xa0
[ 1113.949014]  close_files+0x1b4/0x200
[ 1113.949014]  put_files_struct+0x21/0x180
[ 1113.949014]  exit_files+0x4d/0x60
[ 1113.949014]  do_exit+0x322/0x510
[ 1113.949014]  do_group_exit+0xa1/0xe0
[ 1113.949014]  sys_exit_group+0x12/0x20
[ 1113.949014]  system_call_fastpath+0x16/0x1b
[ 1113.949014] INFO: Slab 0xffffea000125b200 objects=17 used=17 fp=0x          (null) flags=0x150000000004080
[ 1113.949014] INFO: Object 0xffff8800496c8000 @offset=0 fp=0xffff8800496c81c8
[ 1113.949014] 
[ 1113.949014] Object ffff8800496c8000: 6a 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  jkkkkkkkkkkkkkkk
[ 1113.949014] Object ffff8800496c8010: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[ 1113.949014] Object ffff8800496c8020: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[ 1113.949014] Object ffff8800496c8030: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[ 1113.949014] Object ffff8800496c8040: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[ 1113.949014] Object ffff8800496c8050: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[ 1113.949014] Object ffff8800496c8060: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[ 1113.949014] Object ffff8800496c8070: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b a5  kkkkkkkkkkkkkkk.
[ 1113.949014] Redzone ffff8800496c8080: bb bb bb bb bb bb bb bb                          ........
[ 1113.949014] Padding ffff8800496c81c0: 5a 5a 5a 5a 5a 5a 5a 5a                          ZZZZZZZZ
[ 1113.949014] Pid: 16574, comm: trinity Tainted: G        W    3.4.0-next-20120524-sasha-00003-ge89ff01 #281
[ 1113.949014] Call Trace:
[ 1113.949014]  [<ffffffff81217b12>] print_trailer+0x132/0x140
[ 1113.949014]  [<ffffffff81217f51>] check_bytes_and_report+0xe1/0x130
[ 1113.949014]  [<ffffffff8121a17c>] check_object+0xcc/0x220
[ 1113.949014]  [<ffffffff812adaaf>] ? sysfs_get_open_dirent+0x9f/0x150
[ 1113.949014]  [<ffffffff8121a726>] alloc_debug_processing+0xb6/0x160
[ 1113.949014]  [<ffffffff8121cd08>] __slab_alloc+0x638/0x6f0
[ 1113.949014]  [<ffffffff8114932d>] ? trace_hardirqs_on+0xd/0x10
[ 1113.949014]  [<ffffffff812adaaf>] ? sysfs_get_open_dirent+0x9f/0x150
[ 1113.949014]  [<ffffffff81146c6d>] ? __lock_acquired+0x3d/0x2e0
[ 1113.949014]  [<ffffffff812ada36>] ? sysfs_get_open_dirent+0x26/0x150
[ 1113.949014]  [<ffffffff8121de4b>] kmem_cache_alloc_trace+0xbb/0x230
[ 1113.949014]  [<ffffffff812adaaf>] ? sysfs_get_open_dirent+0x9f/0x150
[ 1113.949014]  [<ffffffff812adaaf>] sysfs_get_open_dirent+0x9f/0x150
[ 1113.949014]  [<ffffffff812adc9d>] sysfs_open_file+0x13d/0x190
[ 1113.949014]  [<ffffffff812adb60>] ? sysfs_get_open_dirent+0x150/0x150
[ 1113.949014]  [<ffffffff8122f5c9>] __dentry_open+0x229/0x370
[ 1113.949014]  [<ffffffff8122f775>] nameidata_to_filp+0x65/0x80
[ 1113.949014]  [<ffffffff8124019c>] do_last+0x67c/0x850
[ 1113.949014]  [<ffffffff81241187>] path_openat+0xd7/0x4a0
[ 1113.949014]  [<ffffffff81241664>] do_filp_open+0x44/0xa0
[ 1113.949014]  [<ffffffff82f71a50>] ? _raw_spin_unlock+0x30/0x60
[ 1113.949014]  [<ffffffff81250abd>] ? alloc_fd+0x1ed/0x200
[ 1113.949014]  [<ffffffff81230a05>] do_sys_open+0x125/0x1c0
[ 1113.949014]  [<ffffffff81230adc>] sys_open+0x1c/0x20
[ 1113.949014]  [<ffffffff82f72bf9>] system_call_fastpath+0x16/0x1b
[ 1113.949014] FIX kmalloc-128: Restoring 0xffff8800496c8000-0xffff8800496c8000=0x6b
[ 1113.949014] 
[ 1113.949014] FIX kmalloc-128: Marking all objects used

