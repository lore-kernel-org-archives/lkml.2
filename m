Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754114Ab2GEHfA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 03:35:00 -0400
Received: from e06smtp15.uk.ibm.com ([195.75.94.111]:35846 "EHLO
	e06smtp15.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752581Ab2GEHe7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 03:34:59 -0400
From: Dong Hao <haodong@linux.vnet.ibm.com>
To: gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, Hao Dong <haodong@linux.vnet.ibm.com>
Subject: [PATCH] lib/kobject: restore old name when rename failure
Date: Thu,  5 Jul 2012 15:34:49 +0800
Message-Id: <1341473689-2987-1-git-send-email-haodong@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.2.5
x-cbid: 12070507-0342-0000-0000-00000232914C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hao Dong <haodong@linux.vnet.ibm.com>

Function kobject_set_name_vargs() was implemented to rename the
existing kobject. That depends on kvasprintf(), which might return
NULL. So it's possible the kobject name becomes NULL and in that case we
would lose the old name.

The patch restores the old name when kvasprintf() returns NULL.

Signed-off-by: Dong Hao<haodong@linux.vnet.ibm.com>
---
 lib/kobject.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/lib/kobject.c b/lib/kobject.c
index e07ee1f..c6e201a 100644
--- a/lib/kobject.c
+++ b/lib/kobject.c
@@ -220,8 +220,10 @@ int kobject_set_name_vargs(struct kobject *kobj, const char *fmt,
 		return 0;
 
 	kobj->name = kvasprintf(GFP_KERNEL, fmt, vargs);
-	if (!kobj->name)
+	if (!kobj->name) {
+		kobj->name = old_name;
 		return -ENOMEM;
+	}
 
 	/* ewww... some of these buggers have '/' in the name ... */
 	while ((s = strchr(kobj->name, '/')))
-- 
1.7.9.5

