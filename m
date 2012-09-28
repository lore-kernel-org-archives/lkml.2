Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031765Ab2I1TzB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 15:55:01 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:47421 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964866Ab2I1S5G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 14:57:06 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Francesco Ruggeri <fruggeri@aristanetworks.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [ 067/262] fs/proc: fix potential unregister_sysctl_table hang
Date: Fri, 28 Sep 2012 11:49:56 -0700
Message-Id: <20120928183006.010655416@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120928182957.993484211@linuxfoundation.org>
References: <20120928182957.993484211@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.5-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/proc/proc_sysctl.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/fs/proc/proc_sysctl.c
+++ b/fs/proc/proc_sysctl.c
@@ -462,9 +462,6 @@ static struct dentry *proc_sys_lookup(st
 
 	err = ERR_PTR(-ENOMEM);
 	inode = proc_sys_make_inode(dir->i_sb, h ? h : head, p);
-	if (h)
-		sysctl_head_finish(h);
-
 	if (!inode)
 		goto out;
 
@@ -473,6 +470,8 @@ static struct dentry *proc_sys_lookup(st
 	d_add(dentry, inode);
 
 out:
+	if (h)
+		sysctl_head_finish(h);
 	sysctl_head_finish(head);
 	return err;
 }


