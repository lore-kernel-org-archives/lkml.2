Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946883Ab2LFTE0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 14:04:26 -0500
Received: from mo-p00-ob.rzone.de ([81.169.146.161]:64351 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754533Ab2LFTEZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 14:04:25 -0500
X-RZG-AUTH: :P2EQZWCpfu+qG7CngxMFH1J+zrwiavkK6tmQaLfmwtM48/lk2c7ofw==
X-RZG-CLASS-ID: mo00
Date: Thu, 6 Dec 2012 20:04:23 +0100
From: Olaf Hering <olaf@aepfle.de>
To: Jan Beulich <JBeulich@suse.com>
Cc: xen-devel@lists.xen.org, konrad.wilk@oracle.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] xen/blkback: prevent leak of mode during multiple
 backend_changed calls
Message-ID: <20121206190423.GA27952@aepfle.de>
References: <1354701697-5815-1-git-send-email-olaf@aepfle.de>
 <50BF2E3802000078000AE162@nat28.tlf.novell.com>
 <20121206162304.GA3989@aepfle.de>
 <50C0DDCA02000078000AEBA9@nat28.tlf.novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <50C0DDCA02000078000AEBA9@nat28.tlf.novell.com>
User-Agent: Mutt/1.5.21.rev5558 (2012-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 06, Jan Beulich wrote:

> >>> On 06.12.12 at 17:23, Olaf Hering <olaf@aepfle.de> wrote:
> > On Wed, Dec 05, Jan Beulich wrote:
> > 
> >> >>> On 05.12.12 at 11:01, Olaf Hering <olaf@aepfle.de> wrote:
> >> > backend_changed might be called multiple times, which will leak
> >> > be->mode. free the previous value before storing the current mode value.
> >> 
> >> As said before - this is one possible route to take. But did you
> >> consider at all the alternative of preventing the function from
> >> getting called more than once for a given device? As also said
> >> before, I think that would have other bad effects, and hence
> >> should be preferred (and would likely also result in a smaller
> >> patch).
> > 
> > Maybe it could be done like this, adding a flag to the backend device
> > and exit early if its called twice.
> 
> Maybe, but it looks odd to me. But then again I had hoped Konrad
> would have an opinion here...

Looking at this some more, if backend_changed is supposed to be called
exactly once then major/minor checks can be removed because they will be
always zero, like this:


 drivers/block/xen-blkback/xenbus.c | 68 ++++++++++++++++++--------------------
 1 file changed, 32 insertions(+), 36 deletions(-)

diff --git a/drivers/block/xen-blkback/xenbus.c b/drivers/block/xen-blkback/xenbus.c
index a6585a4..5ca77c3 100644
--- a/drivers/block/xen-blkback/xenbus.c
+++ b/drivers/block/xen-blkback/xenbus.c
@@ -28,6 +28,7 @@ struct backend_info {
 	unsigned		major;
 	unsigned		minor;
 	char			*mode;
+	unsigned		alive;
 };
 
 static struct kmem_cache *xen_blkif_cachep;
@@ -502,10 +503,14 @@ static void backend_changed(struct xenbus_watch *watch,
 		= container_of(watch, struct backend_info, backend_watch);
 	struct xenbus_device *dev = be->dev;
 	int cdrom = 0;
-	char *device_type;
+	char *device_type, *p;
+	long handle;
 
 	DPRINTK("");
 
+	if (be->alive)
+		return;
+
 	err = xenbus_scanf(XBT_NIL, dev->nodename, "physical-device", "%x:%x",
 			   &major, &minor);
 	if (XENBUS_EXIST_ERR(err)) {
@@ -521,12 +526,7 @@ static void backend_changed(struct xenbus_watch *watch,
 		return;
 	}
 
-	if ((be->major || be->minor) &&
-	    ((be->major != major) || (be->minor != minor))) {
-		pr_warn(DRV_PFX "changing physical device (from %x:%x to %x:%x) not supported.\n",
-			be->major, be->minor, major, minor);
-		return;
-	}
+	be->alive = 1;
 
 	be->mode = xenbus_read(XBT_NIL, dev->nodename, "mode", NULL);
 	if (IS_ERR(be->mode)) {
@@ -542,39 +542,35 @@ static void backend_changed(struct xenbus_watch *watch,
 		kfree(device_type);
 	}
 
-	if (be->major == 0 && be->minor == 0) {
-		/* Front end dir is a number, which is used as the handle. */
-
-		char *p = strrchr(dev->otherend, '/') + 1;
-		long handle;
-		err = strict_strtoul(p, 0, &handle);
-		if (err)
-			return;
-
-		be->major = major;
-		be->minor = minor;
+	/* Front end dir is a number, which is used as the handle. */
+	p = strrchr(dev->otherend, '/') + 1;
+	err = strict_strtoul(p, 0, &handle);
+	if (err)
+		return;
 
-		err = xen_vbd_create(be->blkif, handle, major, minor,
-				 (NULL == strchr(be->mode, 'w')), cdrom);
-		if (err) {
-			be->major = 0;
-			be->minor = 0;
-			xenbus_dev_fatal(dev, err, "creating vbd structure");
-			return;
-		}
+	be->major = major;
+	be->minor = minor;
 
-		err = xenvbd_sysfs_addif(dev);
-		if (err) {
-			xen_vbd_free(&be->blkif->vbd);
-			be->major = 0;
-			be->minor = 0;
-			xenbus_dev_fatal(dev, err, "creating sysfs entries");
-			return;
-		}
+	err = xen_vbd_create(be->blkif, handle, major, minor,
+			 (NULL == strchr(be->mode, 'w')), cdrom);
+	if (err) {
+		be->major = 0;
+		be->minor = 0;
+		xenbus_dev_fatal(dev, err, "creating vbd structure");
+		return;
+	}
 
-		/* We're potentially connected now */
-		xen_update_blkif_status(be->blkif);
+	err = xenvbd_sysfs_addif(dev);
+	if (err) {
+		xen_vbd_free(&be->blkif->vbd);
+		be->major = 0;
+		be->minor = 0;
+		xenbus_dev_fatal(dev, err, "creating sysfs entries");
+		return;
 	}
+
+	/* We're potentially connected now */
+	xen_update_blkif_status(be->blkif);
 }
 
 
-- 
1.8.0.1


