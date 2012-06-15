Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757487Ab2FOTRC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2012 15:17:02 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:45983 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751361Ab2FOTRA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2012 15:17:00 -0400
From: Sadasivan Shaiju <sshaiju@mvista.com>
MIME-Version: 1.0
X-Mailer: Microsoft Outlook 14.0
Thread-Index: Ac1LK28RdGDCULtESZ27ija8isEsLQ==
Date: Fri, 15 Jun 2012 12:16:59 -0700
Message-ID: <0518844d43f3399a8aaa6d0c915bac97@mail.gmail.com>
Subject: crash in filesytem during reboot . (and proposed patch)
To: linux-kernel@vger.kernel.org
Cc: walker@fifo99.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi ,

I  am  getting  the  following  crashes during  a  reboot of   the  system
.  It  looks  like  a  race  condition   during  umount .



<4>Call Trace:

<4>[] clear_inode+0x28/0xe8

<4>[] generic_drop_inode+0x3c/0xa8

<4>[] d_kill+0x4c/0x78

<4>[] __shrink_dcache_sb+0x258/0x360

<4>[] shrink_dcache_parent+0x140/0x190

<4>[] proc_flush_task+0xac/0x2e8

<4>[] release_task+0x80/0x4c0

<4>[] wait_consider_task+0x608/0xa80

<4>[] do_wait+0x10c/0x2b8

<4>[] SyS_wait4+0x88/0x120

<4>[] compat_sys_wait4+0xc8/0xd0

<4>[] handle_sysn32+0x44/0x84







Call Trace:
[] file_ra_state_init+0x0/0x20
[] __dentry_open+0x26c/0x3d0
[] do_filp_open+0x70c/0xbc8
[] do_sys_open+0x78/0x1e0
[] handle_sysn32+0x44/0x84






Call Trace:

[<ffffffff812ae3e4>] iput+0x3c/0x88

[<ffffffff812aaa84>] d_kill+0x4c/0x78

[<ffffffff812aad08>] __shrink_dcache_sb+0x258/0x360

[<ffffffff812ab300>] shrink_dcache_parent+0x140/0x190

[<ffffffff812eea14>] proc_flush_task+0xac/0x2e8

[<ffffffff811e6538>] release_task+0x80/0x4c0

[<ffffffff811e80c8>] do_exit+0x6f8/0x908

[<ffffffff8121dee8>] unregister_module_notifier+0x0/0x10







Call Trace:
[<ffffffff812ae3e4>] iput+0x3c/0x88
[<ffffffff812aaa84>] d_kill+0x4c/0x78
[<ffffffff812ab6b8>] dput+0x120/0x220
[<ffffffff812a0f1c>] do_lookup+0xdc/0x210 [<ffffffff812a33e8>]
__link_path_walk+0x910/0x1408 [<ffffffff812a4194>] path_walk+0x64/0x108
[<ffffffff812a4350>] do_path_lookup+0x60/0x68 [<ffffffff812a519c>]
do_filp_open+0xdc/0xbc8 [<ffffffff81293768>] do_sys_open+0x78/0x1e0
[<ffffffff81103844>] handle_sysn32+0x44/0x84





Call Trace:
[<ffffffff812af56c>] __destroy_inode+0x74/0xb0 [<ffffffff812af5bc>]
destroy_inode+0x14/0x50 [<ffffffff812aacd4>] d_kill+0x4c/0x78
[<ffffffff812aaf58>] __shrink_dcache_sb+0x258/0x360 [<ffffffff812ab550>]
shrink_dcache_parent+0x140/0x190 [<ffffffff812eec9c>]
proc_flush_task+0xac/0x2e8 [<ffffffff811e65f0>] release_task+0x80/0x4c0
[<ffffffff811e7038>] wait_consider_task+0x608/0xa80 [<ffffffff811e75bc>]
do_wait+0x10c/0x2b8 [<ffffffff811e7928>] SyS_waitid+0xa0/0x200
[<ffffffff812241cc>] compat_sys_waitid+0x64/0xd8 [<ffffffff81103844>]
handle_sysn32+0x44/0x84



I  am  thinking  of  putting  the  following  fix  in
shrink_dcache_parent() .   Please  let  me  know  is  there  any  problem
with  this  fix .



Index: linux-2.6.32/fs/dcache.c
===================================================================
--- linux-2.6.32.orig/fs/dcache.c       2012-05-30 15:59:18.000000000
-0700
+++ linux-2.6.32/fs/dcache.c    2012-06-11 17:10:33.000000000 -0700
@@ -881,8 +881,14 @@
        struct super_block *sb = parent->d_sb;
        int found;

-       while ((found = select_parent(parent)) != 0)
-               __shrink_dcache_sb(sb, &found, 0);
+       while ((found = select_parent(parent)) != 0) {
+               if (down_read_trylock(&sb->s_umount)) {
+                        if ((sb->s_root != NULL)) {
+                               __shrink_dcache_sb(sb, &found, 0);
+                }
+                  up_read(&sb->s_umount);
+             }
+        }
}

/*



Regards,
shaiju
