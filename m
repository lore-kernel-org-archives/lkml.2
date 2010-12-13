Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751804Ab0LMGLo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 01:11:44 -0500
Received: from e28smtp06.in.ibm.com ([122.248.162.6]:51699 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751235Ab0LMGLn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 01:11:43 -0500
From: Harsh Prateek Bora <harsh@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: kamezawa.hiroyu@jp.fujitsu.com, aneesh.kumar@linux.vnet.ibm.com,
        Harsh Prateek Bora <harsh@linux.vnet.ibm.com>
Subject: [PATCH v2] Typecasting required for comparing unlike datatypes
Date: Mon, 13 Dec 2010 11:41:35 +0530
Message-Id: <1292220695-6578-1-git-send-email-harsh@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The existing code causes the if condition to pass when it should fail
on a *64-bit kernel* because of implicit data type conversions. It can
be observed by passing pos = -1 and count = some positive number.
This results in function returning EOVERFLOW instead of EINVAL.

With this patch, the function returns EINVAL when pos is -1 and count
is a positive number. This can be tested by calling sendfile with
offset = -1 and count = some positive number on a 64-bit kernel.

Signed-off-by: Harsh Prateek Bora <harsh@linux.vnet.ibm.com>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

---
 fs/read_write.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/read_write.c b/fs/read_write.c
index 431a0ed..a8eabd4 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -38,7 +38,7 @@ __negative_fpos_check(struct file *file, loff_t pos, size_t count)
 	 * pos or pos+count is negative here, check overflow.
 	 * too big "count" will be caught in rw_verify_area().
 	 */
-	if ((pos < 0) && (pos + count < pos))
+	if ((pos < 0) && ( (loff_t) (pos + count) < pos))
 		return -EOVERFLOW;
 	if (file->f_mode & FMODE_UNSIGNED_OFFSET)
 		return 0;
-- 
1.7.1.1

