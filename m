Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751396Ab1LFPpb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 10:45:31 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:58710 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750846Ab1LFPp3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 10:45:29 -0500
MIME-Version: 1.0
In-Reply-To: <CACVXFVO8Uk808J9HgVv6ernd4x_QwN3YsAaERF=W8F=NQrLwQw@mail.gmail.com>
References: <1322817178-8931-1-git-send-email-ming.lei@canonical.com>
	<201112061255.56136.arnd@arndb.de>
	<CACVXFVPYUY-vpeoKJKX2XN7-0w+=seW0u3EaP=hD9m1Sy7nkTQ@mail.gmail.com>
	<201112061441.25822.arnd@arndb.de>
	<CACVXFVO8Uk808J9HgVv6ernd4x_QwN3YsAaERF=W8F=NQrLwQw@mail.gmail.com>
Date: Tue, 6 Dec 2011 23:45:27 +0800
Message-ID: <CACVXFVOoQRZKDEWUtuq3hE3H25b7UUWWAJbsTGgVHJcUbnihig@mail.gmail.com>
Subject: Re: [RFC PATCH v1 5/7] media: v4l2: introduce two IOCTLs for face detection
From: Ming Lei <ming.lei@canonical.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Tony Lindgren <tony@atomide.com>, Greg KH <greg@kroah.com>,
        linux-kernel@vger.kernel.org, Sylwester Nawrocki <snjw23@gmail.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-omap@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, Dec 6, 2011 at 10:52 PM, Ming Lei <ming.lei@canonical.com> wrote:
> On Tue, Dec 6, 2011 at 10:41 PM, Arnd Bergmann <arnd@arndb.de> wrote:
>> 3. extending video_usercopy in some way to make this work, preferably
>>   in a generic way.
>
> Maybe this one is a good choice, and I think that it is worthy to
> support the below kind of array parameter:
>
> struct v4l2_fd_result {
>        __u32   buf_index;
>        __u32   face_cnt;
>        __u32   reserved[6];
>        struct v4l2_fd_detection fd[];
> };
>
> and it is not difficult to implement it in a generic way so that new
> array parameters can be supported as 64/32 compatible.

How about the blow patch to support 64/32 compatible array parameter?

diff --git a/drivers/media/video/v4l2-ioctl.c b/drivers/media/video/v4l2-ioctl.c
index e1da8fc..72c81f7 100644
--- a/drivers/media/video/v4l2-ioctl.c
+++ b/drivers/media/video/v4l2-ioctl.c
@@ -2239,6 +2239,26 @@ static int check_array_args(unsigned int cmd,
void *parg, size_t *array_size,
 	return ret;
 }

+static int is_64_32_array_args(unsigned int cmd, void *parg, int *extra_len)
+{
+	int ret = 0;
+
+	switch (cmd) {
+	case VIDIOC_G_FD_RESULT: {
+		struct v4l2_fd_result *fr = parg;
+
+		*extra_len = fr->faces_cnt *
+			sizeof(struct v4l2_fd_detection);
+		ret = 1;
+		break;
+	}
+	default:
+		break;
+	}
+
+	return ret;
+}
+
 long
 video_usercopy(struct file *file, unsigned int cmd, unsigned long arg,
 	       v4l2_kioctl func)
@@ -2251,6 +2271,7 @@ video_usercopy(struct file *file, unsigned int
cmd, unsigned long arg,
 	size_t  array_size = 0;
 	void __user *user_ptr = NULL;
 	void	**kernel_ptr = NULL;
+	int	extra = 0;

 	/*  Copy arguments into temp kernel buffer  */
 	if (_IOC_DIR(cmd) != _IOC_NONE) {
@@ -2280,9 +2301,29 @@ video_usercopy(struct file *file, unsigned int
cmd, unsigned long arg,
 		}
 	}

-	err = check_array_args(cmd, parg, &array_size, &user_ptr, &kernel_ptr);
+	if (is_64_32_array_args(cmd, parg, &extra)) {
+		int size;
+		void *old_mbuf;
+
+		err = 0;
+		if (!extra)
+			goto out_array_args;
+		old_mbuf = mbuf;
+		size = extra + _IOC_SIZE(cmd);
+		mbuf = kmalloc(size, GFP_KERNEL);
+		if (NULL == mbuf)
+			return -ENOMEM;
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
+out_array_args:
 	has_array_args = err;

 	if (has_array_args) {
@@ -2321,7 +2362,7 @@ out_array_args:
 	switch (_IOC_DIR(cmd)) {
 	case _IOC_READ:
 	case (_IOC_WRITE | _IOC_READ):
-		if (copy_to_user((void __user *)arg, parg, _IOC_SIZE(cmd)))
+		if (copy_to_user((void __user *)arg, parg, _IOC_SIZE(cmd) + extra))
 			err = -EFAULT;
 		break;
 	}



thanks,
--
Ming Lei
