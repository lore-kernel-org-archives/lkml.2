Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933146Ab0HXXAA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 19:00:00 -0400
Received: from kroah.org ([198.145.64.141]:40616 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933092Ab0HXW7p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 18:59:45 -0400
X-Mailbox-Line: From gregkh@clark.site Tue Aug 24 15:42:18 2010
Message-Id: <20100824224218.773373561@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 24 Aug 2010 15:42:40 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Dave Airlie <airlied@redhat.com>
Subject: [78/91] drm: stop information leak of old kernel stack.
In-Reply-To: <20100824224617.GA5440@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.34-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Dave Airlie <airlied@redhat.com>

commit b9f0aee83335db1f3915f4e42a5e21b351740afd upstream.

non-critical issue, CVE-2010-2803

Userspace controls the amount of memory to be allocate, so it can
get the ioctl to allocate more memory than the kernel uses, and get
access to kernel stack. This can only be done for processes authenticated
to the X server for DRI access, and if the user has DRI access.

Fix is to just memset the data to 0 if the user doesn't copy into
it in the first place.

Reported-by: Kees Cook <kees@ubuntu.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/drm_drv.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/drm_drv.c
+++ b/drivers/gpu/drm/drm_drv.c
@@ -502,7 +502,9 @@ long drm_ioctl(struct file *filp,
 				retcode = -EFAULT;
 				goto err_i1;
 			}
-		}
+		} else
+			memset(kdata, 0, _IOC_SIZE(cmd));
+
 		if (ioctl->flags & DRM_UNLOCKED)
 			retcode = func(dev, kdata, file_priv);
 		else {


