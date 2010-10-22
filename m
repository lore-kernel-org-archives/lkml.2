Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759310Ab0JVS4S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 14:56:18 -0400
Received: from kroah.org ([198.145.64.141]:34060 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759260Ab0JVS4P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 14:56:15 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Oct 22 11:52:30 2010
Message-Id: <20101022185230.308512391@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 22 Oct 2010 11:51:07 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [033/103] v4l1: fix 32-bit compat microcode loading translation
In-Reply-To: <20101022185455.GA9114@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Linus Torvalds <torvalds@linux-foundation.org>

commit 3e645d6b485446c54c6745c5e2cf5c528fe4deec upstream.

The compat code for the VIDIOCSMICROCODE ioctl is totally buggered.
It's only used by the VIDEO_STRADIS driver, and that one is scheduled to
staging and eventually removed unless somebody steps up to maintain it
(at which point it should use request_firmware() rather than some magic
ioctl).  So we'll get rid of it eventually.

But in the meantime, the compatibility ioctl code is broken, and this
tries to get it to at least limp along (even if Mauro suggested just
deleting it entirely, which may be the right thing to do - I don't think
the compatibility translation code has ever worked unless you were very
lucky).

Reported-by: Kees Cook <kees.cook@canonical.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/media/video/v4l2-compat-ioctl32.c |   32 +++++++++++++++++++-----------
 1 file changed, 21 insertions(+), 11 deletions(-)

--- a/drivers/media/video/v4l2-compat-ioctl32.c
+++ b/drivers/media/video/v4l2-compat-ioctl32.c
@@ -193,17 +193,24 @@ static int put_video_window32(struct vid
 struct video_code32 {
 	char		loadwhat[16];	/* name or tag of file being passed */
 	compat_int_t	datasize;
-	unsigned char	*data;
+	compat_uptr_t	data;
 };
 
-static int get_microcode32(struct video_code *kp, struct video_code32 __user *up)
+static struct video_code __user *get_microcode32(struct video_code32 *kp)
 {
-	if (!access_ok(VERIFY_READ, up, sizeof(struct video_code32)) ||
-		copy_from_user(kp->loadwhat, up->loadwhat, sizeof(up->loadwhat)) ||
-		get_user(kp->datasize, &up->datasize) ||
-		copy_from_user(kp->data, up->data, up->datasize))
-			return -EFAULT;
-	return 0;
+	struct video_code __user *up;
+
+	up = compat_alloc_user_space(sizeof(*up));
+
+	/*
+	 * NOTE! We don't actually care if these fail. If the
+	 * user address is invalid, the native ioctl will do
+	 * the error handling for us
+	 */
+	(void) copy_to_user(up->loadwhat, kp->loadwhat, sizeof(up->loadwhat));
+	(void) put_user(kp->datasize, &up->datasize);
+	(void) put_user(compat_ptr(kp->data), &up->data);
+	return up;
 }
 
 #define VIDIOCGTUNER32		_IOWR('v', 4, struct video_tuner32)
@@ -744,7 +751,7 @@ static long do_video_ioctl(struct file *
 		struct video_tuner vt;
 		struct video_buffer vb;
 		struct video_window vw;
-		struct video_code vc;
+		struct video_code32 vc;
 		struct video_audio va;
 #endif
 		struct v4l2_format v2f;
@@ -823,8 +830,11 @@ static long do_video_ioctl(struct file *
 		break;
 
 	case VIDIOCSMICROCODE:
-		err = get_microcode32(&karg.vc, up);
-		compatible_arg = 0;
+		/* Copy the 32-bit "video_code32" to kernel space */
+		if (copy_from_user(&karg.vc, up, sizeof(karg.vc)))
+			return -EFAULT;
+		/* Convert the 32-bit version to a 64-bit version in user space */
+		up = get_microcode32(&karg.vc);
 		break;
 
 	case VIDIOCSFREQ:


