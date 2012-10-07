Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752404Ab2JGXVs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2012 19:21:48 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:38116 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752358Ab2JGXVp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2012 19:21:45 -0400
Message-Id: <20121007225835.149828981@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 07 Oct 2012 23:58:37 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Francesco Ruggeri <fruggeri@aristanetworks.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [ 003/108] fs/proc: fix potential unregister_sysctl_table hang
In-Reply-To: <20121007225834.673681075@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Francesco Ruggeri <fruggeri@aristanetworks.com>

commit 6bf6104573482570f7103d3e5ddf9574db43a363 upstream.

The unregister_sysctl_table() function hangs if all references to its
ctl_table_header structure are not dropped.

This can happen sometimes because of a leak in proc_sys_lookup():
proc_sys_lookup() gets a reference to the table via lookup_entry(), but
it does not release it when a subsequent call to sysctl_follow_link()
fails.

This patch fixes this leak by making sure the reference is always
dropped on return.

See also commit 076c3eed2c31 ("sysctl: Rewrite proc_sys_lookup
introducing find_entry and lookup_entry") which reorganized this code in
3.4.

Tested in Linux 3.4.4.

Signed-off-by: Francesco Ruggeri <fruggeri@aristanetworks.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/proc/proc_sysctl.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/proc/proc_sysctl.c b/fs/proc/proc_sysctl.c
index dfafeb2..eb7cc91 100644
--- a/fs/proc/proc_sysctl.c
+++ b/fs/proc/proc_sysctl.c
@@ -462,9 +462,6 @@ static struct dentry *proc_sys_lookup(struct inode *dir, struct dentry *dentry,
 
 	err = ERR_PTR(-ENOMEM);
 	inode = proc_sys_make_inode(dir->i_sb, h ? h : head, p);
-	if (h)
-		sysctl_head_finish(h);
-
 	if (!inode)
 		goto out;
 
@@ -473,6 +470,8 @@ static struct dentry *proc_sys_lookup(struct inode *dir, struct dentry *dentry,
 	d_add(dentry, inode);
 
 out:
+	if (h)
+		sysctl_head_finish(h);
 	sysctl_head_finish(head);
 	return err;
 }


