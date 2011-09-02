Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756214Ab1IBVjo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Sep 2011 17:39:44 -0400
Received: from mail209.messagelabs.com ([216.82.255.3]:32803 "EHLO
	mail209.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756076Ab1IBVjl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Sep 2011 17:39:41 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-14.tower-209.messagelabs.com!1314999568!15379333!8
X-Originating-IP: [216.166.12.32]
X-StarScan-Version: 6.3.6; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] nfs/super.c: local functions should be static
Date: Fri, 2 Sep 2011 14:39:12 -0700
User-Agent: KMail/1.9.9
CC: <linux-nfs@vger.kernel.org>, <Trond.Myklebust@netapp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201109021439.13146.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit ae50c0b5 "pnfs: client stats" added additional information to
the output of /proc/self/mountstats. The new functions introduced are
only used in this file and should be marked static.

If CONFIG_NFS_V4_1 is not defined, empty stub functions are used.  If
CONFIG_NFS_V4 is not defined these stub functions are not used at all.
Adding static for the functions results in compile warnings:

fs/nfs/super.c:743: warning: 'show_sessions' defined but not used
fs/nfs/super.c:756: warning: 'show_pnfs' defined but not used

Fix this by adding a #ifdef CONFIG_NFS_V4 guard around the two
show_ functions.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Trond Myklebust <Trond.Myklebust@netapp.com>

---

diff --git a/fs/nfs/super.c b/fs/nfs/super.c
index b961cea..4b07e9b 100644
--- a/fs/nfs/super.c
+++ b/fs/nfs/super.c
@@ -733,18 +733,22 @@ static int nfs_show_options(struct seq_file *m, struct vfsmount *mnt)
 
 	return 0;
 }
+
+#ifdef CONFIG_NFS_V4
 #ifdef CONFIG_NFS_V4_1
-void show_sessions(struct seq_file *m, struct nfs_server *server)
+static void show_sessions(struct seq_file *m, struct nfs_server *server)
 {
 	if (nfs4_has_session(server->nfs_client))
 		seq_printf(m, ",sessions");
 }
 #else
-void show_sessions(struct seq_file *m, struct nfs_server *server) {}
+static void show_sessions(struct seq_file *m, struct nfs_server *server) {}
+#endif
 #endif
 
+#ifdef CONFIG_NFS_V4
 #ifdef CONFIG_NFS_V4_1
-void show_pnfs(struct seq_file *m, struct nfs_server *server)
+static void show_pnfs(struct seq_file *m, struct nfs_server *server)
 {
 	seq_printf(m, ",pnfs=");
 	if (server->pnfs_curr_ld)
@@ -752,9 +756,10 @@ void show_pnfs(struct seq_file *m, struct nfs_server *server)
 	else
 		seq_printf(m, "not configured");
 }
-#else  /* CONFIG_NFS_V4_1 */
-void show_pnfs(struct seq_file *m, struct nfs_server *server) {}
-#endif /* CONFIG_NFS_V4_1 */
+#else
+static void show_pnfs(struct seq_file *m, struct nfs_server *server) {}
+#endif
+#endif
 
 static int nfs_show_devname(struct seq_file *m, struct vfsmount *mnt)
 {
