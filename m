Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751642Ab2ILTMT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 15:12:19 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:57257 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750944Ab2ILTMR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 15:12:17 -0400
MIME-Version: 1.0
Date: Wed, 12 Sep 2012 12:12:16 -0700
Message-ID: <CA+HUmGiXkMtLG84KiXZiuuQnSOseY7R5ykHq8226YaTnuzp=Qw@mail.gmail.com>
Subject: PATCH [1/1] fs/proc: unregister_sysctl_table hanging forever
From: Francesco Ruggeri <fruggeri@aristanetworks.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

unregister_sysctl_table hangs forever if all references to its
ctl_table_header structure are not dropped.
This happens sometimes because of a leak in proc_sys_lookup().
proc_sys_lookup() gets a reference to the table via lookup_entry(), but it
does not release it when a subsequent call to sysctl_follow_link() fails.
This patch fixes this leak by making sure the reference is always dropped
on return.
See also 076c3eed2c31773200b082568957fd8852ae93d7 which reorganized this
code in 3.4.

Tested in Linux 3.4.4.

Signed-off-by: Francesco Ruggeri <fruggeri@aristanetworks.com>

Index: linux-3.4.x86_64/fs/proc/proc_sysctl.c
===================================================================
--- linux-3.4.x86_64.orig/fs/proc/proc_sysctl.c
+++ linux-3.4.x86_64/fs/proc/proc_sysctl.c
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
