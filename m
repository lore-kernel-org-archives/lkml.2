Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755720Ab2HOQYu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 12:24:50 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:43652 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755159Ab2HOQYq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 12:24:46 -0400
Subject: [RFC PATCH 1/5] net: cleanup unix_bind() a little
To: tglx@linutronix.de, mingo@redhat.com, davem@davemloft.net, hpa@zytor.com
From: Stanislav Kinsbursky <skinsbursky@parallels.com>
Cc: thierry.reding@avionic-design.de, bfields@redhat.com,
        eric.dumazet@gmail.com, xemul@parallels.com, neilb@suse.de,
        netdev@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org,
        paul.gortmaker@windriver.com, viro@zeniv.linux.org.uk,
        gorcunov@openvz.org, akpm@linux-foundation.org,
        tim.c.chen@linux.intel.com, devel@openvz.org, ebiederm@xmission.com
Date: Wed, 15 Aug 2012 20:22:04 +0400
Message-ID: <20120815162204.7598.6975.stgit@localhost.localdomain>
In-Reply-To: <20120815161141.7598.16682.stgit@localhost.localdomain>
References: <20120815161141.7598.16682.stgit@localhost.localdomain>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This will simplify further changes for unix_fbind().
---
 net/unix/af_unix.c |   12 +++++-------
 1 files changed, 5 insertions(+), 7 deletions(-)

diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index 641f2e4..bc90ddb 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -880,10 +880,8 @@ static int unix_bind(struct socket *sock, struct sockaddr *uaddr, int addr_len)
 		if (err)
 			goto out_mknod_dput;
 		err = security_path_mknod(&path, dentry, mode, 0);
-		if (err)
-			goto out_mknod_drop_write;
-		err = vfs_mknod(path.dentry->d_inode, dentry, mode, 0);
-out_mknod_drop_write:
+		if (!err)
+			err = vfs_mknod(path.dentry->d_inode, dentry, mode, 0);
 		mnt_drop_write(path.mnt);
 		if (err)
 			goto out_mknod_dput;
@@ -896,9 +894,9 @@ out_mknod_drop_write:
 
 	spin_lock(&unix_table_lock);
 
+	err = -EADDRINUSE;
 	if (!sun_path[0]) {
-		err = -EADDRINUSE;
-		if (__unix_find_socket_byname(net, sunaddr, addr_len,
+		if (__unix_find_socket_byname(net, sunaddr, addr->len,
 					      sk->sk_type, hash)) {
 			unix_release_addr(addr);
 			goto out_unlock;
@@ -906,7 +904,7 @@ out_mknod_drop_write:
 
 		list = &unix_socket_table[addr->hash];
 	} else {
-		list = &unix_socket_table[dentry->d_inode->i_ino & (UNIX_HASH_SIZE-1)];
+		list = &unix_socket_table[path.dentry->d_inode->i_ino & (UNIX_HASH_SIZE-1)];
 		u->path = path;
 	}
 

