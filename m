Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752319Ab1ELDvS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 23:51:18 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:53147 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751241Ab1ELDvR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 23:51:17 -0400
Date: Thu, 12 May 2011 13:51:13 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: build failure after merge of the final tree (namespace
 tree related)
Message-Id: <20110512135113.93c1b671.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.24.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

After merging the final tree, today's linux-next build (powerpc
ppc44x_defconfig) failed like this:

net/built-in.o: In function `get_net_ns_by_fd':
(.text+0x11976): undefined reference to `netns_operations'
net/built-in.o: In function `get_net_ns_by_fd':
(.text+0x1197a): undefined reference to `netns_operations'

netns_operations is only available if CONFIG_NET_NS is set ...

Caused by commit f063052947f7 ("net: Allow setting the network namespace
by fd").

I applied the patch below for today.

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Thu, 12 May 2011 13:41:16 +1000
Subject: [PATCH] net: fix get_net_ns_by_fd for !CONFIG_NET_NS

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 net/core/net_namespace.c |   49 +++++++++++++++++++++++++--------------------
 1 files changed, 27 insertions(+), 22 deletions(-)

diff --git a/net/core/net_namespace.c b/net/core/net_namespace.c
index bddcaff..e630588 100644
--- a/net/core/net_namespace.c
+++ b/net/core/net_namespace.c
@@ -304,6 +304,28 @@ void __put_net(struct net *net)
 }
 EXPORT_SYMBOL_GPL(__put_net);
 
+struct net *get_net_ns_by_fd(int fd)
+{
+	struct proc_inode *ei;
+	struct file *file;
+	struct net *net;
+
+	net = ERR_PTR(-EINVAL);
+	file = proc_ns_fget(fd);
+	if (!file)
+		goto out;
+
+	ei = PROC_I(file->f_dentry->d_inode);
+	if (ei->ns_ops != &netns_operations)
+		goto out;
+
+	net = get_net(ei->ns);
+out:
+	if (file)
+		fput(file);
+	return net;
+}
+
 #else
 struct net *copy_net_ns(unsigned long flags, struct net *old_net)
 {
@@ -311,6 +333,11 @@ struct net *copy_net_ns(unsigned long flags, struct net *old_net)
 		return ERR_PTR(-EINVAL);
 	return old_net;
 }
+
+struct net *get_net_ns_by_fd(int fd)
+{
+	return ERR_PTR(-EINVAL);
+}
 #endif
 
 struct net *get_net_ns_by_pid(pid_t pid)
@@ -333,28 +360,6 @@ struct net *get_net_ns_by_pid(pid_t pid)
 }
 EXPORT_SYMBOL_GPL(get_net_ns_by_pid);
 
-struct net *get_net_ns_by_fd(int fd)
-{
-	struct proc_inode *ei;
-	struct file *file;
-	struct net *net;
-
-	net = ERR_PTR(-EINVAL);
-	file = proc_ns_fget(fd);
-	if (!file)
-		goto out;
-
-	ei = PROC_I(file->f_dentry->d_inode);
-	if (ei->ns_ops != &netns_operations)
-		goto out;
-
-	net = get_net(ei->ns);
-out:
-	if (file)
-		fput(file);
-	return net;
-}
-
 static int __init net_ns_init(void)
 {
 	struct net_generic *ng;
-- 
1.7.5.1

-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
