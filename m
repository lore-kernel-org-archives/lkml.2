Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934445Ab1ETAUO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 20:20:14 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:59452 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934431Ab1ETALV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 20:11:21 -0400
X-Sasl-enc: AaidHYsLxBw8eA1xMJsKWTlzDu5JbcDoQ+0ECzWDdP8v 1305850280
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Hillf Danton <dhillf@gmail.com>, "Hans J. Koch" <hjk@hansjkoch.de>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 09/44] uio: fix finding mm index for vma
Date: Thu, 19 May 2011 17:10:27 -0700
Message-Id: <1305850262-9575-9-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.4.2
In-Reply-To: <1305850262-9575-1-git-send-email-gregkh@suse.de>
References: <20110520000821.GA9367@kroah.com>
 <1305850262-9575-1-git-send-email-gregkh@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hillf Danton <dhillf@gmail.com>

When finding mm index for vma it looks more flexible that the mm could
be sparse, and both the size of mm and the pgoff of vma could give
correct selection.

Signed-off-by: Hillf Danton <dhillf@gmail.com>
Signed-off-by: Hans J. Koch <hjk@hansjkoch.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/uio/uio.c |    8 +++-----
 1 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/uio/uio.c b/drivers/uio/uio.c
index 51fe179..10a029b 100644
--- a/drivers/uio/uio.c
+++ b/drivers/uio/uio.c
@@ -587,14 +587,12 @@ static ssize_t uio_write(struct file *filep, const char __user *buf,
 
 static int uio_find_mem_index(struct vm_area_struct *vma)
 {
-	int mi;
 	struct uio_device *idev = vma->vm_private_data;
 
-	for (mi = 0; mi < MAX_UIO_MAPS; mi++) {
-		if (idev->info->mem[mi].size == 0)
+	if (vma->vm_pgoff < MAX_UIO_MAPS) {
+		if (idev->info->mem[vma->vm_pgoff].size == 0)
 			return -1;
-		if (vma->vm_pgoff == mi)
-			return mi;
+		return (int)vma->vm_pgoff;
 	}
 	return -1;
 }
-- 
1.7.4.2

