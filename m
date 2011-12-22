Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755067Ab1LVKTF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Dec 2011 05:19:05 -0500
Received: from relay01.digicable.hu ([92.249.128.189]:35221 "EHLO
	relay01.digicable.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752948Ab1LVKTD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Dec 2011 05:19:03 -0500
X-Greylist: delayed 2143 seconds by postgrey-1.27 at vger.kernel.org; Thu, 22 Dec 2011 05:19:02 EST
Message-ID: <4EF2FBA2.5070802@freemail.hu>
Date: Thu, 22 Dec 2011 10:42:58 +0100
From: =?UTF-8?B?TsOpbWV0aCBNw6FydG9u?= <nm127@freemail.hu>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; hu-HU; rv:1.8.1.21) Gecko/20090402 SeaMonkey/1.1.16
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@infradead.org>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        V4L Mailing List <linux-media@vger.kernel.org>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] v4l2: handle multiplication overflow
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Original: 84.236.126.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Márton Németh <nm127@freemail.hu>

When a V4L2 ioctl is executed the memory provided by the caller in user space
is copied to the kernel space in video_usercopy() function. To find out
how many bytes has to be copied the check_array_args() helper function is used.

This patch adds a check for multiplication overflow. Without this check the
multiplication may overflow resulting array_size to be zero. This means that
later on uninitialized value can trigger NULL pointer exception.

The overflow happens because ctrls->count is an __u32 multiplied by a constant
coming from sizeof() operator. Multiplication result of two 32bit value may
be a 64bit value, thus overflow can happen. Similarly buf->length is an __u32
multiplied by a constant coming from sizeof() operator.

The chosen error value is -ENOMEM because we are just about to allocate
kernel memory to copy data from userspace. We cannot even store the required
number of bytes in the variable of size_t type.

To trigger the error from user space use the v4l-test 0.19 [1] or essentially
the following code fragment:

	struct v4l2_ext_controls controls;
	memset(&controls, 0, sizeof(controls));
	controls.ctrl_class = V4L2_CTRL_CLASS_USER;
	controls.count = 0x40000000;
	controls.controls = NULL;
	ret = ioctl(f, VIDIOC_G_EXT_CTRLS, &controls);


References:
[1] v4l-test: Test environment for Video For Linux Two (V4L2) API
    http://v4l-test.sourceforge.net/

Signed-off-by: Márton Németh <nm127@freemail.hu>
---

I'm a little bit in doubt whether this is the correct way to check for the
multiplication overflow. In case of x86 architecture the MUL insruction [2]
can be used to multiply EAX with an other 32bit register, and the 64bit result
is placed to EDX:EAX. In case of EDX != 0 the carry and overflow flags are set.

This means that executing the MUL instruction on x86 already provides information
whether the result fits to 32bit or not. I might use __u64 as a result of the
multiplication and check whether the upper 32bit is still zero but the optimal
would be to check for the carry or the overflow flag.

Still, there could be a special case when the constant from sizeof() operator is
a power of 2, in this case the compiler might optimize the multiplication using
a shift left. In this case something else is needed.

I couldn't really find information about the number of bits for size_t on
different architectures. If size_t happens to be at least 64bit on some architecture
then this overflow will not happen at all and the array_size will contain the
correct value.

What do you think?

References:
[2] Intel 80386 Reference Programmer's Manual
    MUL -- Unsigned Multiplication of AL or AX
    http://www.scs.stanford.edu/nyu/04fa/lab/i386/MUL.htm

---
diff --git a/drivers/media/video/v4l2-ioctl.c b/drivers/media/video/v4l2-ioctl.c
index e1da8fc..e239be8 100644
--- a/drivers/media/video/v4l2-ioctl.c
+++ b/drivers/media/video/v4l2-ioctl.c
@@ -2200,6 +2200,7 @@ static int check_array_args(unsigned int cmd, void *parg, size_t *array_size,
 			    void * __user *user_ptr, void ***kernel_ptr)
 {
 	int ret = 0;
+	size_t size;

 	switch (cmd) {
 	case VIDIOC_QUERYBUF:
@@ -2214,8 +2215,15 @@ static int check_array_args(unsigned int cmd, void *parg, size_t *array_size,
 			}
 			*user_ptr = (void __user *)buf->m.planes;
 			*kernel_ptr = (void *)&buf->m.planes;
-			*array_size = sizeof(struct v4l2_plane) * buf->length;
-			ret = 1;
+			size = sizeof(struct v4l2_plane) * buf->length;
+			if (unlikely(size < buf->length)) {
+				/* *array_size overflowed at multiplication */
+				*array_size = 0;
+				ret = -ENOMEM;
+			} else {
+				*array_size = size;
+				ret = 1;
+			}
 		}
 		break;
 	}
@@ -2228,9 +2236,15 @@ static int check_array_args(unsigned int cmd, void *parg, size_t *array_size,
 		if (ctrls->count != 0) {
 			*user_ptr = (void __user *)ctrls->controls;
 			*kernel_ptr = (void *)&ctrls->controls;
-			*array_size = sizeof(struct v4l2_ext_control)
-				    * ctrls->count;
-			ret = 1;
+			size = sizeof(struct v4l2_ext_control) * ctrls->count;
+			if (unlikely(size < ctrls->count)) {
+				/* *array_size overflowed at multiplication */
+				*array_size = 0;
+				ret = -ENOMEM;
+			} else {
+				*array_size = size;
+				ret = 1;
+			}
 		}
 		break;
 	}
