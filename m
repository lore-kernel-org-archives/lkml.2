Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964864Ab2HGXbo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 19:31:44 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:63658 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932610Ab2HGWaa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 18:30:30 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Tejun Heo <tj@kernel.org>, Al Viro <viro@ZenIV.linux.org.uk>,
        Li Zefan <lizefan@huawei.com>
Subject: [ 059/122] cgroup: cgroup_rm_files() was calling simple_unlink() with the wrong inode
Date: Tue,  7 Aug 2012 15:25:47 -0700
Message-Id: <20120807221953.610036857@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120807221948.220495155@linuxfoundation.org>
References: <20120807221948.220495155@linuxfoundation.org>
User-Agent: quilt/0.60-20.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tejun Heo <tj@kernel.org>

commit ce27e317ba22b359bde02216afab934dac3af095 upstream.

While refactoring cgroup file removal path, 05ef1d7c4a "cgroup:
introduce struct cfent" incorrectly changed the @dir argument of
simple_unlink() to the inode of the file being deleted instead of that
of the containing directory.

The effect of this bug is minor - ctime and mtime of the parent
weren't properly updated on file deletion.

Fix it by using @cgrp->dentry->d_inode instead.

Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-by: Al Viro <viro@ZenIV.linux.org.uk>
Acked-by: Li Zefan <lizefan@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/cgroup.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -954,7 +954,7 @@ static int cgroup_rm_file(struct cgroup
 
 		dget(d);
 		d_delete(d);
-		simple_unlink(d->d_inode, d);
+		simple_unlink(cgrp->dentry->d_inode, d);
 		list_del_init(&cfe->node);
 		dput(d);
 


