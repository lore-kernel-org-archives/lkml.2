Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754395Ab2GCRiO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2012 13:38:14 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:60928 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751724Ab2GCRiL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2012 13:38:11 -0400
Date: Tue, 3 Jul 2012 10:38:06 -0700
From: Tejun Heo <tj@kernel.org>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Li Zefan <lizefan@huawei.com>, shyju pv <shyju.pv@huawei.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>,
        Sanil kumar <sanil.kumar@huawei.com>,
        Masanari Iida <standby24x7@gmail.com>
Subject: [PATCH] cgroup: cgroup_rm_files() was calling simple_unlink() with
 the wrong inode
Message-ID: <20120703173806.GD555@google.com>
References: <20120627182903.GP15811@google.com>
 <4FEBF4B7.2070105@huawei.com>
 <20120628180712.GC22641@google.com>
 <4FED10DB.7040500@huawei.com>
 <20120629165809.GB21048@google.com>
 <4FEE98EE.1050409@huawei.com>
 <20120630064724.GC14083@ZenIV.linux.org.uk>
 <CAOS58YNnU3J+c2ZQcRCesSoxn0dSJjDLBsZ2qzZ09X6N-ky0fQ@mail.gmail.com>
 <20120630083421.GD14083@ZenIV.linux.org.uk>
 <20120703171033.GC555@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120703171033.GC555@google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 6da2689412c78b97716ec524cc30baf7b46508cd Mon Sep 17 00:00:00 2001
From: Tejun Heo <tj@kernel.org>
Date: Tue, 3 Jul 2012 10:32:26 -0700

While refactoring cgroup file removal path, 05ef1d7c4a "cgroup:
introduce struct cfent" incorrectly changed the @dir argument of
simple_unlink() to the inode of the file being deleted instead of that
of the containing directory.

The effect of this bug is minor - ctime and mtime of the parent
weren't properly updated on file deletion.

Fix it by using @cgrp->dentry->d_inode instead.

Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-by: Al Viro <viro@ZenIV.linux.org.uk>
---
Will commit to cgroup/for-3.5-fixes.  Li, can you please ack this?

Thanks.

 kernel/cgroup.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 2097684..b214fc2 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -964,7 +964,7 @@ static int cgroup_rm_file(struct cgroup *cgrp, const struct cftype *cft)
 
 		dget(d);
 		d_delete(d);
-		simple_unlink(d->d_inode, d);
+		simple_unlink(cgrp->dentry->d_inode, d);
 		list_del_init(&cfe->node);
 		dput(d);
 
-- 
1.7.7.3

