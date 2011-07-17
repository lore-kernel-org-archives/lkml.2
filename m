Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755372Ab1GQAub (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jul 2011 20:50:31 -0400
Received: from ozlabs.org ([203.10.76.45]:39029 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754700Ab1GQAu3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jul 2011 20:50:29 -0400
Date: Sun, 17 Jul 2011 10:50:27 +1000
From: Anton Blanchard <anton@samba.org>
To: npiggin@kernel.dk, viro@zeniv.linux.org.uk
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: vfsmount lock issues on very large ppc64 box
Message-ID: <20110717105027.53cc3ca4@kryten>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.24.4; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


When compiling a kernel with make -j on a ppc64 box with 896
HW threads we spend a very large amount of time in vfsmount
lock code:

    20.85%  [k] .vfsmount_lock_local_lock
            |
            |--57.20%-- .mntput_no_expire
            |          |
            |          |--74.93%-- .fput
            |          |          |
            |          |          |--91.19%-- .filp_close
            |          |          |          |
            |          |          |          |--98.97%-- .sys_close

    14.15%  [k] .vfsmount_lock_global_lock_online
            |
            |--100.00%-- .mntput_no_expire
            |          .fput
            |          .filp_close
            |          |
            |          |--70.01%-- .put_files_struct
            |          |          .do_exit
            |          |          .do_group_exit
            |          |          .sys_exit_group
            |          |          syscall_exit
            |          |
            |           --29.99%-- .sys_close


Looking closer, all of these calls are in pipefs and sockfs.
Since we never mount either filesystem they never get a long term
reference and we always end up in the very slow write brlock path
that takes a lock for each online CPU.

Here is a quick hack that takes a long term reference on pipefs
and sockfs which fixes the problem. Any thoughts on how we should
fix it properly?

---
Signed-off-by: Anton Blanchard <anton@samba.org>

Index: linux-2.6-work/fs/pipe.c
===================================================================
--- linux-2.6-work.orig/fs/pipe.c	2011-07-17 10:21:54.695472158 +1000
+++ linux-2.6-work/fs/pipe.c	2011-07-17 10:33:31.127204731 +1000
@@ -20,6 +20,7 @@
 #include <linux/audit.h>
 #include <linux/syscalls.h>
 #include <linux/fcntl.h>
+#include "internal.h"
 
 #include <asm/uaccess.h>
 #include <asm/ioctls.h>
@@ -1286,11 +1287,13 @@ static int __init init_pipe_fs(void)
 			unregister_filesystem(&pipe_fs_type);
 		}
 	}
+	mnt_make_longterm(pipe_mnt);
 	return err;
 }
 
 static void __exit exit_pipe_fs(void)
 {
+	mnt_make_shortterm(pipe_mnt);
 	unregister_filesystem(&pipe_fs_type);
 	mntput(pipe_mnt);
 }
Index: linux-2.6-work/net/socket.c
===================================================================
--- linux-2.6-work.orig/net/socket.c	2011-07-17 10:21:54.685471989 +1000
+++ linux-2.6-work/net/socket.c	2011-07-17 10:33:41.247375257 +1000
@@ -2500,6 +2500,8 @@ void sock_unregister(int family)
 }
 EXPORT_SYMBOL(sock_unregister);
 
+extern void mnt_make_longterm(struct vfsmount *);
+
 static int __init sock_init(void)
 {
 	int err;
@@ -2530,6 +2532,8 @@ static int __init sock_init(void)
 		goto out_mount;
 	}
 
+	mnt_make_longterm(sock_mnt);
+
 	/* The real protocol initialization is performed in later initcalls.
 	 */
 
