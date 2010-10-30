Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754065Ab0J3O0Y (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Oct 2010 10:26:24 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:40880 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752879Ab0J3O0X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Oct 2010 10:26:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=HIth1nnaE5FjtN85NWf1P1KjsEXwdSTKRwn9ZncM66/nvshITRGnDFrInaldM8fqkV
         n2Z7+AuYHejq2vjnIBMhIwrA2qwPbLlWmnpFKQDG5AIneYvQANsj2JeI7pg+CpAMIIpF
         0SotewmZp15f13mMAgvYA7djfcLJBxQ2SJtSw=
From: Vasiliy Kulikov <segooon@gmail.com>
To: kernel-janitors@vger.kernel.org
Cc: Alex Elder <aelder@sgi.com>, xfs-masters@oss.sgi.com,
        Christoph Hellwig <hch@lst.de>, Dave Chinner <dchinner@redhat.com>,
        Eric Sandeen <sandeen@redhat.com>,
        =?UTF-8?q?Arkadiusz=20Mi=C5=9Bkiewicz?= <arekm@maven.pl>,
        xfs@oss.sgi.com, linux-kernel@vger.kernel.org
Subject: [PATCH] xfs: linux-2.6: xfs_ioctl: fix information leak to userland
Date: Sat, 30 Oct 2010 18:26:17 +0400
Message-Id: <1288448778-5373-1-git-send-email-segooon@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

al_hreq is copied from userland.  If al_hreq.buflen is not properly aligned then
xfs_attr_list will ignore the last bytes of kbuf.  These bytes are unitialized.
It leads to leaking of contents of kernel stack memory.

Signed-off-by: Vasiliy Kulikov <segooon@gmail.com>
---
 Compile tested.

 fs/xfs/linux-2.6/xfs_ioctl.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_ioctl.c b/fs/xfs/linux-2.6/xfs_ioctl.c
index 2ea238f..ad442d9 100644
--- a/fs/xfs/linux-2.6/xfs_ioctl.c
+++ b/fs/xfs/linux-2.6/xfs_ioctl.c
@@ -416,7 +416,7 @@ xfs_attrlist_by_handle(
 	if (IS_ERR(dentry))
 		return PTR_ERR(dentry);
 
-	kbuf = kmalloc(al_hreq.buflen, GFP_KERNEL);
+	kbuf = kzalloc(al_hreq.buflen, GFP_KERNEL);
 	if (!kbuf)
 		goto out_dput;
 
-- 
1.7.0.4

