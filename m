Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753621Ab2DSJII (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 05:08:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10787 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752574Ab2DSJIC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 05:08:02 -0400
From: Lukas Czerner <lczerner@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: mbroz@redhat.com, linux-fsdevel@vger.kernel.org,
        Lukas Czerner <lczerner@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH] fs: print warning when mount flags was ignored
Date: Thu, 19 Apr 2012 11:07:55 +0200
Message-Id: <1334826475-11606-1-git-send-email-lczerner@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some mount flags can conflict with each other so they can not be
handled together. Currently when conflicting flags are specified,
some of them are silently ignored putting user in believe that
they was handled correctly.

Fix this by checking for unhandled flags and print warning when
flags was ignored. I am not sure if it's worth translating the flags
into the name, so it just prints the flag as a hexadecimal number.

Obviously we can not fail when conflicting flags are specified,
because it may break buggy application, but it can change in the
future.

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
Reported-by: Milan Broz <mbroz@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
---
 fs/namespace.c |   24 +++++++++++++++++++-----
 1 files changed, 19 insertions(+), 5 deletions(-)

diff --git a/fs/namespace.c b/fs/namespace.c
index e608199..8736a48 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -2175,18 +2175,32 @@ long do_mount(char *dev_name, char *dir_name, char *type_page,
 		   MS_NOATIME | MS_NODIRATIME | MS_RELATIME| MS_KERNMOUNT |
 		   MS_STRICTATIME);
 
-	if (flags & MS_REMOUNT)
+	if (flags & MS_REMOUNT) {
 		retval = do_remount(&path, flags & ~MS_REMOUNT, mnt_flags,
 				    data_page);
-	else if (flags & MS_BIND)
+		flags &= ~MS_REMOUNT;
+	} else if (flags & MS_BIND) {
 		retval = do_loopback(&path, dev_name, flags & MS_REC);
-	else if (flags & (MS_SHARED | MS_PRIVATE | MS_SLAVE | MS_UNBINDABLE))
+		flags &= ~MS_BIND;
+	} else if (flags & (MS_SHARED | MS_PRIVATE |
+			    MS_SLAVE | MS_UNBINDABLE)) {
 		retval = do_change_type(&path, flags);
-	else if (flags & MS_MOVE)
+		flags &= ~(MS_SHARED | MS_PRIVATE | MS_SLAVE | MS_UNBINDABLE);
+	} else if (flags & MS_MOVE) {
 		retval = do_move_mount(&path, dev_name);
-	else
+		flags &= ~MS_MOVE;
+	} else
 		retval = do_new_mount(&path, type_page, flags, mnt_flags,
 				      dev_name, data_page);
+
+	flags &= (MS_REMOUNT | MS_BIND | MS_SHARED | MS_PRIVATE |
+		  MS_SLAVE | MS_UNBINDABLE | MS_MOVE);
+
+	if (!retval && flags)
+		printk(KERN_WARNING "%s(%u): (%s -> %s) Conflicting mount flags"
+				    " specified. These flags has been "
+				    "ignored: %#.8lx\n", __func__, current->pid,
+				    dev_name, dir_name, flags);
 dput_out:
 	path_put(&path);
 	return retval;
-- 
1.7.4.4

