Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757356Ab1LNOBx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 09:01:53 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:56233 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755231Ab1LNOBq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 09:01:46 -0500
From: Ming Lei <ming.lei@canonical.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>,
        Tony Lindgren <tony@atomide.com>
Cc: Sylwester Nawrocki <snjw23@gmail.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        Ming Lei <ming.lei@canonical.com>, Arnd Bergmann <arnd@arndb.de>
Subject: [RFC PATCH v2 5/8] media: v4l2-ioctl: support 64/32 compatible array parameter
Date: Wed, 14 Dec 2011 22:00:11 +0800
Message-Id: <1323871214-25435-6-git-send-email-ming.lei@canonical.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1323871214-25435-1-git-send-email-ming.lei@canonical.com>
References: <1323871214-25435-1-git-send-email-ming.lei@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch supports to handle 64/32 compatible array parameter,
such as below:

	struct v4l2_fd_result {
	       __u32   buf_index;
	       __u32   face_cnt;
	       __u32   reserved[6];
	       struct v4l2_fd_detection fd[];
	};

With this patch, the pointer to user space array needn't be passed
to kernel any more.

Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Ming Lei <ming.lei@canonical.com>
---
 drivers/media/video/v4l2-ioctl.c |   33 +++++++++++++++++++++++++++++++--
 1 files changed, 31 insertions(+), 2 deletions(-)

diff --git a/drivers/media/video/v4l2-ioctl.c b/drivers/media/video/v4l2-ioctl.c
index e1da8fc..ded8b72 100644
--- a/drivers/media/video/v4l2-ioctl.c
+++ b/drivers/media/video/v4l2-ioctl.c
@@ -2239,6 +2239,11 @@ static int check_array_args(unsigned int cmd, void *parg, size_t *array_size,
 	return ret;
 }
 
+static int is_64_32_array_args(unsigned int cmd, void *parg, int *extra_len)
+{
+	return 0;
+}
+
 long
 video_usercopy(struct file *file, unsigned int cmd, unsigned long arg,
 	       v4l2_kioctl func)
@@ -2251,6 +2256,7 @@ video_usercopy(struct file *file, unsigned int cmd, unsigned long arg,
 	size_t  array_size = 0;
 	void __user *user_ptr = NULL;
 	void	**kernel_ptr = NULL;
+	int	extra = 0;
 
 	/*  Copy arguments into temp kernel buffer  */
 	if (_IOC_DIR(cmd) != _IOC_NONE) {
@@ -2280,9 +2286,32 @@ video_usercopy(struct file *file, unsigned int cmd, unsigned long arg,
 		}
 	}
 
-	err = check_array_args(cmd, parg, &array_size, &user_ptr, &kernel_ptr);
+	if (is_64_32_array_args(cmd, parg, &extra)) {
+		int size;
+		void *old_mbuf;
+
+		err = 0;
+		if (!extra)
+			goto handle_array_args;
+		old_mbuf = mbuf;
+		size = extra + _IOC_SIZE(cmd);
+		mbuf = kmalloc(size, GFP_KERNEL);
+		if (NULL == mbuf) {
+			mbuf = old_mbuf;
+			err = -ENOMEM;
+			goto out;
+		}
+		memcpy(mbuf, parg, _IOC_SIZE(cmd));
+		parg = mbuf;
+		kfree(old_mbuf);
+	} else {
+		err = check_array_args(cmd, parg, &array_size,
+				&user_ptr, &kernel_ptr);
+	}
+
 	if (err < 0)
 		goto out;
+handle_array_args:
 	has_array_args = err;
 
 	if (has_array_args) {
@@ -2321,7 +2350,7 @@ out_array_args:
 	switch (_IOC_DIR(cmd)) {
 	case _IOC_READ:
 	case (_IOC_WRITE | _IOC_READ):
-		if (copy_to_user((void __user *)arg, parg, _IOC_SIZE(cmd)))
+		if (copy_to_user((void __user *)arg, parg, _IOC_SIZE(cmd) + extra))
 			err = -EFAULT;
 		break;
 	}
-- 
1.7.5.4

