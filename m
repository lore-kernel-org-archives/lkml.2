Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759972Ab0GVWJt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jul 2010 18:09:49 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:2537 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755991Ab0GVWJS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jul 2010 18:09:18 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6051"; a="48209974"
From: Patrick Pannuto <ppannuto@codeaurora.org>
To: linux-kernel@vger.kernel.org
Cc: ppannuto@codeaurora.org, Mark Fasheh <mfasheh@suse.com>,
        Joel Becker <joel.becker@oracle.com>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Jens Axboe <jens.axboe@oracle.com>,
        David Teigland <teigland@redhat.com>,
        Pekka Enberg <penberg@cs.helsinki.fi>, ocfs2-devel@oss.oracle.com
Subject: [PATCH 5/6] ocfs2: Fix memory leak on mlog_sys_init error path
Date: Thu, 22 Jul 2010 15:09:05 -0700
Message-Id: <1279836546-26913-6-git-send-email-ppannuto@codeaurora.org>
X-Mailer: git-send-email 1.7.2
In-Reply-To: <1279836546-26913-1-git-send-email-ppannuto@codeaurora.org>
References: <1279836546-26913-1-git-send-email-ppannuto@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This leak is the same as the bus path; mlog_kset.kobj.name is
set, but kset_register fails, thus nothing will ever call
kset_unregister and name will be leaked

Signed-off-by: Patrick Pannuto <ppannuto@codeaurora.org>
---
 fs/ocfs2/cluster/masklog.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/fs/ocfs2/cluster/masklog.c b/fs/ocfs2/cluster/masklog.c
index c7fba39..de715d4 100644
--- a/fs/ocfs2/cluster/masklog.c
+++ b/fs/ocfs2/cluster/masklog.c
@@ -154,6 +154,7 @@ static struct kset mlog_kset = {
 int mlog_sys_init(struct kset *o2cb_kset)
 {
 	int i = 0;
+	int ret;
 
 	while (mlog_attrs[i].attr.mode) {
 		mlog_attr_ptrs[i] = &mlog_attrs[i].attr;
@@ -163,7 +164,11 @@ int mlog_sys_init(struct kset *o2cb_kset)
 
 	kobject_set_name(&mlog_kset.kobj, "logmask");
 	mlog_kset.kobj.kset = o2cb_kset;
-	return kset_register(&mlog_kset);
+
+	ret = kset_register(&mlog_kset);
+	if (ret)
+		kfree(mlog_kset.kobj.name);
+	return ret;
 }
 
 void mlog_sys_shutdown(void)
-- 
1.7.2

