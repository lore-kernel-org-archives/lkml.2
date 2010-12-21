Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753650Ab0LUXtB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Dec 2010 18:49:01 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:35863 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751799Ab0LUXs7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Dec 2010 18:48:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references
         :mime-version:content-type:content-transfer-encoding;
        b=SbVueKruNaJs38xQ7ApZjv2dNshte2t3dnRzVpBrLUpLgjSCcwxrY4lROckpfAuTU7
         +l3o9JcQUsWGH0V5ggzMH9TJqlOoG1FBjFBBdWnp0alZWVupWs1LmaSS9BTqiisdEEfD
         nva5jKyjAbCrrcVyXb67/TocjoKbwYamA8WK0=
From: Thiago Farina <tfransosi@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-media@vger.kernel.org
Subject: [PATCH v2] drivers/media/video/v4l2-compat-ioctl32.c: Check the return value of copy_to_user
Date: Tue, 21 Dec 2010 21:48:45 -0200
Message-Id: <83948188cda2388c2e22a50119dfb0023fba759a.1292975147.git.tfransosi@gmail.com>
X-Mailer: git-send-email 1.7.3.2.343.g7d43d
In-Reply-To: <201012212003.11446.arnd@arndb.de>
References: <201012212003.11446.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fix the following warning:
drivers/media/video/v4l2-compat-ioctl32.c: In function ‘get_microcode32’:
drivers/media/video/v4l2-compat-ioctl32.c:209: warning: ignoring return value of ‘copy_to_user’, declared with attribute warn_unused_result

Signed-off-by: Thiago Farina <tfransosi@gmail.com>
---
 Changes from v1:
 - Check the return code of put_user too.
 - Remove the obsolete comment.

 drivers/media/video/v4l2-compat-ioctl32.c |   14 ++++++--------
 1 files changed, 6 insertions(+), 8 deletions(-)

diff --git a/drivers/media/video/v4l2-compat-ioctl32.c b/drivers/media/video/v4l2-compat-ioctl32.c
index e30e8df..6f2a022 100644
--- a/drivers/media/video/v4l2-compat-ioctl32.c
+++ b/drivers/media/video/v4l2-compat-ioctl32.c
@@ -201,14 +201,12 @@ static struct video_code __user *get_microcode32(struct video_code32 *kp)
 
 	up = compat_alloc_user_space(sizeof(*up));
 
-	/*
-	 * NOTE! We don't actually care if these fail. If the
-	 * user address is invalid, the native ioctl will do
-	 * the error handling for us
-	 */
-	(void) copy_to_user(up->loadwhat, kp->loadwhat, sizeof(up->loadwhat));
-	(void) put_user(kp->datasize, &up->datasize);
-	(void) put_user(compat_ptr(kp->data), &up->data);
+	if (copy_to_user(up->loadwhat, kp->loadwhat, sizeof(up->loadwhat)))
+		return NULL;
+	if (put_user(kp->datasize, &up->datasize))
+		return NULL;
+	if (put_user(compat_ptr(kp->data), &up->data))
+		return NULL;
 	return up;
 }
 
-- 
1.7.3.2.343.g7d43d

