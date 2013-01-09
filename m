Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933817Ab3AIUkT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 15:40:19 -0500
Received: from mail.kernel.org ([198.145.19.201]:43211 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933675Ab3AIUkO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 15:40:14 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Gao feng <gaofeng@cn.fujitsu.com>, Li Zefan <lizefan@huawei.com>,
        Tejun Heo <tj@redhat.com>
Subject: [ 072/123] cgroup_rm_file: dont delete the uncreated files
Date: Wed,  9 Jan 2013 12:35:11 -0800
Message-Id: <20130109201507.859215171@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130109201458.392601412@linuxfoundation.org>
References: <20130109201458.392601412@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gao feng <gaofeng@cn.fujitsu.com>

commit f33fddc2b9573d8359f1007d4bbe5cd587a0c093 upstream.

in cgroup_add_file,when creating files for cgroup,
some of creation may be skipped. So we need to avoid
deleting these uncreated files in cgroup_rm_file,
otherwise the warning msg will be triggered.

"cgroup_addrm_files: failed to remove memory_pressure_enabled, err=-2"

Signed-off-by: Gao feng <gaofeng@cn.fujitsu.com>
Acked-by: Li Zefan <lizefan@huawei.com>
Signed-off-by: Tejun Heo <tj@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/cgroup.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -2789,12 +2789,6 @@ static int cgroup_add_file(struct cgroup
 
 	simple_xattrs_init(&cft->xattrs);
 
-	/* does @cft->flags tell us to skip creation on @cgrp? */
-	if ((cft->flags & CFTYPE_NOT_ON_ROOT) && !cgrp->parent)
-		return 0;
-	if ((cft->flags & CFTYPE_ONLY_ON_ROOT) && cgrp->parent)
-		return 0;
-
 	if (subsys && !test_bit(ROOT_NOPREFIX, &cgrp->root->flags)) {
 		strcpy(name, subsys->name);
 		strcat(name, ".");
@@ -2835,6 +2829,12 @@ static int cgroup_addrm_files(struct cgr
 	int err, ret = 0;
 
 	for (cft = cfts; cft->name[0] != '\0'; cft++) {
+		/* does cft->flags tell us to skip this file on @cgrp? */
+		if ((cft->flags & CFTYPE_NOT_ON_ROOT) && !cgrp->parent)
+			continue;
+		if ((cft->flags & CFTYPE_ONLY_ON_ROOT) && cgrp->parent)
+			continue;
+
 		if (is_add)
 			err = cgroup_add_file(cgrp, subsys, cft);
 		else


