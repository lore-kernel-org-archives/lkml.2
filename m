Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752085Ab2LWNeR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Dec 2012 08:34:17 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:42183 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751762Ab2LWNeO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Dec 2012 08:34:14 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: [Regression w/ patch] Media commit causes user space to misbahave (was: Re: Linux 3.8-rc1)
Date: Sun, 23 Dec 2012 14:39:32 +0100
Message-ID: <2183382.xv2VGtqdUf@vostro.rjw.lan>
User-Agent: KMail/4.9.4 (Linux/3.8.0-rc1+; KDE/4.9.4; x86_64; ; )
In-Reply-To: <CA+55aFyd0Wk=hPqiRmk5MMnrwPhse5k1Aih9P-j-Badr7kwhbw@mail.gmail.com>
References: <CA+55aFyd0Wk=hPqiRmk5MMnrwPhse5k1Aih9P-j-Badr7kwhbw@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Laurent,

Commit f0ed2ce ([media] uvcvideo: Set error_idx properly for extended
controls API failures) of yours unfortunately causes user space to misbehave
on one of my test systems.  Namely, there's no sound under KDE 4.9.4
(Tumbleweed version using pulseaudio) and there's a knotify4 process occupying
one of the CPU cores entirely 100% of the time.

I used the patch below to fix the problem for me.

Thanks,
Rafael


---
From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Subject: [media]: Revert part of commit f0ed2ce to fix user space breakage

Commit f0ed2ce ([media] uvcvideo: Set error_idx properly for extended
controls API failures) causes user space to behave incorrectly on one
of my test machines (there is no sound under KDE 4.9.4 using
pulseaudio and there is a knotify4 process occupying one of the CPU
cores 100% of the time).  Reverting that commit entirely fixes the
problem for me.

However, commit f0ed2ce appears to do more than it follows from its
changelog, because the changelog only says about the changes related
to ctrls->error_idx, while the commit additionally changes error
codes returned by various functions in uvc_ctrl.c and uvc_v4l2.c.  It
turns out that the changes of the returned error codes confuse the
user spce, so it is sufficient to revert the part of commit f0ed2ce
not mentioned in its changelog to fix the problem.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/media/usb/uvc/uvc_ctrl.c |   19 ++++++++-----------
 drivers/media/usb/uvc/uvc_v4l2.c |   12 +++++-------
 2 files changed, 13 insertions(+), 18 deletions(-)

Index: linux/drivers/media/usb/uvc/uvc_ctrl.c
===================================================================
--- linux.orig/drivers/media/usb/uvc/uvc_ctrl.c
+++ linux/drivers/media/usb/uvc/uvc_ctrl.c
@@ -1061,7 +1061,7 @@ int uvc_query_v4l2_ctrl(struct uvc_video
 
 	ctrl = uvc_find_control(chain, v4l2_ctrl->id, &mapping);
 	if (ctrl == NULL) {
-		ret = -ENOENT;
+		ret = -EINVAL;
 		goto done;
 	}
 
@@ -1099,13 +1099,12 @@ int uvc_query_v4l2_menu(struct uvc_video
 		return -ERESTARTSYS;
 
 	ctrl = uvc_find_control(chain, query_menu->id, &mapping);
-	if (ctrl == NULL) {
-		ret = -ENOENT;
+	if (ctrl == NULL || mapping->v4l2_type != V4L2_CTRL_TYPE_MENU) {
+		ret = -EINVAL;
 		goto done;
 	}
 
-	if (mapping->v4l2_type != V4L2_CTRL_TYPE_MENU ||
-	    query_menu->index >= mapping->menu_count) {
+	if (query_menu->index >= mapping->menu_count) {
 		ret = -EINVAL;
 		goto done;
 	}
@@ -1264,7 +1263,7 @@ static int uvc_ctrl_add_event(struct v4l
 
 	ctrl = uvc_find_control(handle->chain, sev->id, &mapping);
 	if (ctrl == NULL) {
-		ret = -ENOENT;
+		ret = -EINVAL;
 		goto done;
 	}
 
@@ -1415,7 +1414,7 @@ int uvc_ctrl_get(struct uvc_video_chain
 
 	ctrl = uvc_find_control(chain, xctrl->id, &mapping);
 	if (ctrl == NULL)
-		return -ENOENT;
+		return -EINVAL;
 
 	return __uvc_ctrl_get(chain, ctrl, mapping, &xctrl->value);
 }
@@ -1432,10 +1431,8 @@ int uvc_ctrl_set(struct uvc_video_chain
 	int ret;
 
 	ctrl = uvc_find_control(chain, xctrl->id, &mapping);
-	if (ctrl == NULL)
-		return -ENOENT;
-	if (!(ctrl->info.flags & UVC_CTRL_FLAG_SET_CUR))
-		return -EACCES;
+	if (ctrl == NULL || (ctrl->info.flags & UVC_CTRL_FLAG_SET_CUR) == 0)
+		return -EINVAL;
 
 	/* Clamp out of range values. */
 	switch (mapping->v4l2_type) {
Index: linux/drivers/media/usb/uvc/uvc_v4l2.c
===================================================================
--- linux.orig/drivers/media/usb/uvc/uvc_v4l2.c
+++ linux/drivers/media/usb/uvc/uvc_v4l2.c
@@ -607,10 +607,8 @@ static long uvc_v4l2_do_ioctl(struct fil
 
 		ret = uvc_ctrl_get(chain, &xctrl);
 		uvc_ctrl_rollback(handle);
-		if (ret < 0)
-			return ret == -ENOENT ? -EINVAL : ret;
-
-		ctrl->value = xctrl.value;
+		if (ret >= 0)
+			ctrl->value = xctrl.value;
 		break;
 	}
 
@@ -634,7 +632,7 @@ static long uvc_v4l2_do_ioctl(struct fil
 		ret = uvc_ctrl_set(chain, &xctrl);
 		if (ret < 0) {
 			uvc_ctrl_rollback(handle);
-			return ret == -ENOENT ? -EINVAL : ret;
+			return ret;
 		}
 		ret = uvc_ctrl_commit(handle, &xctrl, 1);
 		if (ret == 0)
@@ -661,7 +659,7 @@ static long uvc_v4l2_do_ioctl(struct fil
 				uvc_ctrl_rollback(handle);
 				ctrls->error_idx = ret == -ENOENT
 						 ? ctrls->count : i;
-				return ret == -ENOENT ? -EINVAL : ret;
+				return ret;
 			}
 		}
 		ctrls->error_idx = 0;
@@ -691,7 +689,7 @@ static long uvc_v4l2_do_ioctl(struct fil
 				ctrls->error_idx = (ret == -ENOENT &&
 						    cmd == VIDIOC_S_EXT_CTRLS)
 						 ? ctrls->count : i;
-				return ret == -ENOENT ? -EINVAL : ret;
+				return ret;
 			}
 		}
 


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
