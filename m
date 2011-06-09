Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754763Ab1FIDGd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 23:06:33 -0400
Received: from mga03.intel.com ([143.182.124.21]:26260 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752684Ab1FIDGb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 23:06:31 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,340,1304319600"; 
   d="scan'208";a="9647744"
Date: Thu, 9 Jun 2011 11:06:28 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: "Antonino A. Daplas" <adaplas@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-fbdev@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: [RFC] fbmem: reset file->private_data on failed fb_open()
Message-ID: <20110609030628.GA10233@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I wrote this when looking at NULL dereference bug
https://bugzilla.kernel.org/show_bug.cgi?id=18912

Will it help by clearing private_data? I have no idea at all, because
for regular files, ->release won't be called on failed ->open. Just in
case there are some exceptions in fbmem...

---
 drivers/video/fbmem.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- linux-next.orig/drivers/video/fbmem.c	2011-06-09 10:36:06.000000000 +0800
+++ linux-next/drivers/video/fbmem.c	2011-06-09 10:39:30.000000000 +0800
@@ -1424,26 +1424,28 @@ __releases(&info->lock)
 	file->private_data = info;
 	if (info->fbops->fb_open) {
 		res = info->fbops->fb_open(info,1);
 		if (res)
 			module_put(info->fbops->owner);
 	}
 #ifdef CONFIG_FB_DEFERRED_IO
 	if (info->fbdefio)
 		fb_deferred_io_open(info, inode, file);
 #endif
 out:
 	mutex_unlock(&info->lock);
-	if (res)
+	if (res) {
+		file->private_data = NULL;
 		put_fb_info(info);
+	}
 	return res;
 }
 
 static int 
 fb_release(struct inode *inode, struct file *file)
 __acquires(&info->lock)
 __releases(&info->lock)
 {
 	struct fb_info * const info = file->private_data;
 
 	mutex_lock(&info->lock);
 	if (info->fbops->fb_release)
