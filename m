Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754234Ab2AEJG1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 04:06:27 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:34375 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753932Ab2AEJGW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 04:06:22 -0500
Subject: [PATCH for tty-next 2/2] tty: rework pty count limiting
To: Greg Kroah-Hartman <gregkh@suse.de>
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: linux-kernel@vger.kernel.org
Date: Thu, 05 Jan 2012 13:06:11 +0400
Message-ID: <20120105090611.28009.57270.stgit@zurg>
In-Reply-To: <20120105002409.GA30083@kroah.com>
References: <20120105002409.GA30083@kroah.com>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After adding devpts multiple-insrances sysctl kernel.pty.max limit pty count for
each devpts instance independently, while kernel.pty.nr shows total pty count.

This patch restores sysctl kernel.pty.max as global limit (4096 by default),
adds pty reseve for main devpts (mounted without "newinstance" argument),
and new sysctl to tune it: kernel.pty.reserve (1024 by default)

Also it adds devpts mount option "max=%d" to limit pty count for each devpts
instance independently. (by default NR_UNIX98_PTY_MAX == 2^20)

Thus devpts instances in containers cannot eat up all available pty even if we didn't
set any limits, while with "max" argument we can adjust limits more precisely.

Plus, now open("/dev/ptmx") return -ENOSPC in case lack of pty indexes,
this is more informative than -EIO.

Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
---
 fs/devpts/inode.c   |   34 ++++++++++++++++++++++++++++++----
 include/linux/tty.h |    1 +
 2 files changed, 31 insertions(+), 4 deletions(-)

diff --git a/fs/devpts/inode.c b/fs/devpts/inode.c
index dd37e85..ff84832 100644
--- a/fs/devpts/inode.c
+++ b/fs/devpts/inode.c
@@ -41,8 +41,9 @@
  * Otherwise one can eat up all kernel memory by opening /dev/ptmx repeatedly.
  */
 static int pty_limit = NR_UNIX98_PTY_DEFAULT;
+static int pty_reserve = NR_UNIX98_PTY_RESERVE;
 static int pty_limit_min;
-static int pty_limit_max = NR_UNIX98_PTY_MAX;
+static int pty_limit_max = INT_MAX;
 static int pty_count;
 
 static struct ctl_table pty_table[] = {
@@ -55,6 +56,14 @@ static struct ctl_table pty_table[] = {
 		.extra1		= &pty_limit_min,
 		.extra2		= &pty_limit_max,
 	}, {
+		.procname	= "reserve",
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.data		= &pty_reserve,
+		.proc_handler	= proc_dointvec_minmax,
+		.extra1		= &pty_limit_min,
+		.extra2		= &pty_limit_max,
+	}, {
 		.procname	= "nr",
 		.maxlen		= sizeof(int),
 		.mode		= 0444,
@@ -94,10 +103,11 @@ struct pts_mount_opts {
 	umode_t mode;
 	umode_t ptmxmode;
 	int newinstance;
+	int max;
 };
 
 enum {
-	Opt_uid, Opt_gid, Opt_mode, Opt_ptmxmode, Opt_newinstance,
+	Opt_uid, Opt_gid, Opt_mode, Opt_ptmxmode, Opt_newinstance,  Opt_max,
 	Opt_err
 };
 
@@ -108,6 +118,7 @@ static const match_table_t tokens = {
 #ifdef CONFIG_DEVPTS_MULTIPLE_INSTANCES
 	{Opt_ptmxmode, "ptmxmode=%o"},
 	{Opt_newinstance, "newinstance"},
+	{Opt_max, "max=%d"},
 #endif
 	{Opt_err, NULL}
 };
@@ -154,6 +165,7 @@ static int parse_mount_options(char *data, int op, struct pts_mount_opts *opts)
 	opts->gid     = 0;
 	opts->mode    = DEVPTS_DEFAULT_MODE;
 	opts->ptmxmode = DEVPTS_DEFAULT_PTMX_MODE;
+	opts->max     = NR_UNIX98_PTY_MAX;
 
 	/* newinstance makes sense only on initial mount */
 	if (op == PARSE_MOUNT)
@@ -197,6 +209,12 @@ static int parse_mount_options(char *data, int op, struct pts_mount_opts *opts)
 			if (op == PARSE_MOUNT)
 				opts->newinstance = 1;
 			break;
+		case Opt_max:
+			if (match_int(&args[0], &option) ||
+			    option < 0 || option > NR_UNIX98_PTY_MAX)
+				return -EINVAL;
+			opts->max = option;
+			break;
 #endif
 		default:
 			printk(KERN_ERR "devpts: called with bogus options\n");
@@ -303,6 +321,8 @@ static int devpts_show_options(struct seq_file *seq, struct vfsmount *vfs)
 	seq_printf(seq, ",mode=%03o", opts->mode);
 #ifdef CONFIG_DEVPTS_MULTIPLE_INSTANCES
 	seq_printf(seq, ",ptmxmode=%03o", opts->ptmxmode);
+	if (opts->max < NR_UNIX98_PTY_MAX)
+		seq_printf(seq, ",max=%d", opts->max);
 #endif
 
 	return 0;
@@ -485,6 +505,12 @@ retry:
 		return -ENOMEM;
 
 	mutex_lock(&allocated_ptys_lock);
+	if (pty_count >= pty_limit -
+			(fsi->mount_opts.newinstance ? pty_reserve : 0)) {
+		mutex_unlock(&allocated_ptys_lock);
+		return -ENOSPC;
+	}
+
 	ida_ret = ida_get_new(&fsi->allocated_ptys, &index);
 	if (ida_ret < 0) {
 		mutex_unlock(&allocated_ptys_lock);
@@ -493,10 +519,10 @@ retry:
 		return -EIO;
 	}
 
-	if (index >= pty_limit) {
+	if (index >= fsi->mount_opts.max) {
 		ida_remove(&fsi->allocated_ptys, index);
 		mutex_unlock(&allocated_ptys_lock);
-		return -EIO;
+		return -ENOSPC;
 	}
 	pty_count++;
 	mutex_unlock(&allocated_ptys_lock);
diff --git a/include/linux/tty.h b/include/linux/tty.h
index d3ebd76..d407741 100644
--- a/include/linux/tty.h
+++ b/include/linux/tty.h
@@ -52,6 +52,7 @@
  * hardcoded at present.)
  */
 #define NR_UNIX98_PTY_DEFAULT	4096      /* Default maximum for Unix98 ptys */
+#define NR_UNIX98_PTY_RESERVE	1024	  /* Default reserve for main devpts */
 #define NR_UNIX98_PTY_MAX	(1 << MINORBITS) /* Absolute limit */
 
 /*

