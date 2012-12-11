Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752647Ab2LKDNX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 22:13:23 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:40724 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752568Ab2LKDNU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 22:13:20 -0500
From: Cyril Roelandt <tipecaml@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, michael@mihu.de, mchehab@redhat.com,
        linux-media@vger.kernel.org, Cyril Roelandt <tipecaml@gmail.com>
Subject: [PATCH 1/1] media: saa7146: don't use mutex_lock_interruptible() in device_release().
Date: Tue, 11 Dec 2012 04:05:28 +0100
Message-Id: <1355195128-10209-2-git-send-email-tipecaml@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1355195128-10209-1-git-send-email-tipecaml@gmail.com>
References: <1355195128-10209-1-git-send-email-tipecaml@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use uninterruptible mutex_lock in the release() file op to make sure all
resources are properly freed when a process is being terminated. Returning
-ERESTARTSYS has no effect for a terminating process and this may cause driver
resources not to be released.

This was found using the following semantic patch (http://coccinelle.lip6.fr/):

<spml>
@r@
identifier fops;
identifier release_func;
@@
static const struct v4l2_file_operations fops = {
.release = release_func
};

@depends on r@
identifier r.release_func;
expression E;
@@
static int release_func(...)
{
...
- if (mutex_lock_interruptible(E)) return -ERESTARTSYS;
+ mutex_lock(E);
...
}
</spml>

Signed-off-by: Cyril Roelandt <tipecaml@gmail.com>
---
 drivers/media/common/saa7146/saa7146_fops.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/media/common/saa7146/saa7146_fops.c b/drivers/media/common/saa7146/saa7146_fops.c
index b3890bd..0afe98d 100644
--- a/drivers/media/common/saa7146/saa7146_fops.c
+++ b/drivers/media/common/saa7146/saa7146_fops.c
@@ -265,8 +265,7 @@ static int fops_release(struct file *file)
 
 	DEB_EE("file:%p\n", file);
 
-	if (mutex_lock_interruptible(vdev->lock))
-		return -ERESTARTSYS;
+	mutex_lock(vdev->lock);
 
 	if (vdev->vfl_type == VFL_TYPE_VBI) {
 		if (dev->ext_vv_data->capabilities & V4L2_CAP_VBI_CAPTURE)
-- 
1.7.10.4

