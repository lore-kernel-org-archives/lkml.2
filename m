Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757427Ab0C3Xtl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 19:49:41 -0400
Received: from kroah.org ([198.145.64.141]:45859 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932465Ab0C3XTn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 19:19:43 -0400
X-Mailbox-Line: From linux@linux.site Tue Mar 30 15:47:42 2010
Message-Id: <20100330224741.789511392@linux.site>
User-Agent: quilt/0.47-14.9
Date: Tue, 30 Mar 2010 15:41:07 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       =?ISO-8859-15?q?Andr=C3=A9=20Goddard=20Rosa?= 
	<andre.goddard@gmail.com>,
       Al Viro <viro@zeniv.linux.org.uk>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [033/156] mqueue: fix mq_open() file descriptor leak on user-space processes
In-Reply-To: <20100330230630.GA28824@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let us know.

------------------

From: André Goddard Rosa <andre.goddard@gmail.com>

commit 4294a8eedb17bbc45e1e7447c2a4d05332943248 upstream.

We leak fd on lookup_one_len() failure

Signed-off-by: André Goddard Rosa <andre.goddard@gmail.com>
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 ipc/mqueue.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/ipc/mqueue.c
+++ b/ipc/mqueue.c
@@ -705,7 +705,7 @@ SYSCALL_DEFINE4(mq_open, const char __us
 	dentry = lookup_one_len(name, ipc_ns->mq_mnt->mnt_root, strlen(name));
 	if (IS_ERR(dentry)) {
 		error = PTR_ERR(dentry);
-		goto out_err;
+		goto out_putfd;
 	}
 	mntget(ipc_ns->mq_mnt);
 
@@ -742,7 +742,6 @@ out:
 	mntput(ipc_ns->mq_mnt);
 out_putfd:
 	put_unused_fd(fd);
-out_err:
 	fd = error;
 out_upsem:
 	mutex_unlock(&ipc_ns->mq_mnt->mnt_root->d_inode->i_mutex);


