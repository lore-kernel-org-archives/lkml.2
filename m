Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754985Ab2HOPZK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 11:25:10 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:46559 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753810Ab2HOPZI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 11:25:08 -0400
Date: Wed, 15 Aug 2012 19:25:04 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Pavel Emelyanov <xemul@parallels.com>
Subject: Q: On restoring terminal with hinted index
Message-ID: <20120815152504.GG23657@moon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,

that happened that in a sake of restoring ptys after checkpoint
we need to create them with predefined indices, as they were at
moment of dumping. So we have two options -- 1) Open terminals
in sequence until needed index reached 2) Use some other way to
say the kernel that some index is preferred.

So I thought, would it be acceptible to provide such hint via
sysctl, as in patch below (note I've not even compiled it yet,
but would like to know your opinion early).

(Maybe even make it one shot, thus once ida_get_new_above called
 the pty_next reset to zero).

---
 fs/devpts/inode.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

Index: linux-2.6.git/fs/devpts/inode.c
===================================================================
--- linux-2.6.git.orig/fs/devpts/inode.c
+++ linux-2.6.git/fs/devpts/inode.c
@@ -45,6 +45,7 @@ static int pty_reserve = NR_UNIX98_PTY_R
 static int pty_limit_min;
 static int pty_limit_max = INT_MAX;
 static int pty_count;
+static int pty_next;
 
 static struct ctl_table pty_table[] = {
 	{
@@ -69,6 +70,12 @@ static struct ctl_table pty_table[] = {
 		.mode		= 0444,
 		.data		= &pty_count,
 		.proc_handler	= proc_dointvec,
+	}, {
+		.procname	= "next",
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.data		= &pty_next,
+		.proc_handler	= proc_dointvec,
 	},
 	{}
 };
@@ -516,7 +523,7 @@ retry:
 		return -ENOSPC;
 	}
 
-	ida_ret = ida_get_new(&fsi->allocated_ptys, &index);
+	ida_ret = ida_get_new_above(&fsi->allocated_ptys, pty_next, &index);
 	if (ida_ret < 0) {
 		mutex_unlock(&allocated_ptys_lock);
 		if (ida_ret == -EAGAIN)
