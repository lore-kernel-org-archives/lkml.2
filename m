Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754864Ab2L1T2O (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2012 14:28:14 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:24489 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754560Ab2L1T2K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2012 14:28:10 -0500
From: Sasha Levin <sasha.levin@oracle.com>
To: Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org
Cc: Sasha Levin <sasha.levin@oracle.com>
Subject: [PATCH] module: prevent warning when finit_module a 0 sized file
Date: Fri, 28 Dec 2012 14:27:17 -0500
Message-Id: <1356722837-1457-1-git-send-email-sasha.levin@oracle.com>
X-Mailer: git-send-email 1.8.0.2
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If we try to finit_module on a file sized 0 bytes vmalloc will
scream and spit out a warning.

Since modules have to be bigger than 0 bytes anyways we can just
check that beforehand and avoid the warning.

Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
---
 kernel/module.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/kernel/module.c b/kernel/module.c
index 250092c..2e1ce2e 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -2527,6 +2527,12 @@ static int copy_module_from_fd(int fd, struct load_info *info)
 		err = -EFBIG;
 		goto out;
 	}
+
+	if (stat.size == 0) {
+		err = -EINVAL;
+		goto out;
+	}
+
 	info->hdr = vmalloc(stat.size);
 	if (!info->hdr) {
 		err = -ENOMEM;
-- 
1.8.0.2

