Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752046Ab2LTKbY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 05:31:24 -0500
Received: from nat28.tlf.novell.com ([130.57.49.28]:38461 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751326Ab2LTKbR (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:5:1>);
	Thu, 20 Dec 2012 05:31:17 -0500
Message-Id: <50D2F6FF02000078000B1BC5@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.1 
Date: Thu, 20 Dec 2012 10:31:11 +0000
From: "Jan Beulich" <JBeulich@suse.com>
To: "Konrad Rzeszutek Wilk" <konrad.wilk@oracle.com>
Cc: "Olaf Hering" <olaf@aepfle.de>, "Jens Axboe" <axboe@kernel.dk>,
        "xen-devel" <xen-devel@lists.xen.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] xen-blkback: do not leak mode property
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=__PartFDCC72FF.4__="
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME message. If you are reading this text, you may want to 
consider changing to a mail reader or gateway that understands how to 
properly handle MIME multipart messages.

--=__PartFDCC72FF.4__=
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

"be->mode" is obtained from xenbus_read(), which does a kmalloc() for
the message body. The short string is never released, so do it along
with freeing "be" itself, and make sure the string isn't kept when
backend_changed() doesn't complete successfully (which made it
desirable to slightly re-structure that function, so that the error
cleanup can be done in one place).

Reported-by: Olaf Hering <olaf@aepfle.de>
Signed-off-by: Jan Beulich <jbeulich@suse.com>

---
 drivers/block/xen-blkback/xenbus.c |   49 ++++++++++++++++++--------------=
-----
 1 file changed, 24 insertions(+), 25 deletions(-)

--- 3.7/drivers/block/xen-blkback/xenbus.c
+++ 3.7-xen-blkback-mode-leak/drivers/block/xen-blkback/xenbus.c
@@ -366,6 +366,7 @@ static int xen_blkbk_remove(struct xenbu
 		be->blkif =3D NULL;
 	}
=20
+	kfree(be->mode);
 	kfree(be);
 	dev_set_drvdata(&dev->dev, NULL);
 	return 0;
@@ -501,6 +502,7 @@ static void backend_changed(struct xenbu
 		=3D container_of(watch, struct backend_info, backend_watch)=
;
 	struct xenbus_device *dev =3D be->dev;
 	int cdrom =3D 0;
+	unsigned long handle;
 	char *device_type;
=20
 	DPRINTK("");
@@ -520,10 +522,10 @@ static void backend_changed(struct xenbu
 		return;
 	}
=20
-	if ((be->major || be->minor) &&
-	    ((be->major !=3D major) || (be->minor !=3D minor))) {
-		pr_warn(DRV_PFX "changing physical device (from %x:%x to =
%x:%x) not supported.\n",
-			be->major, be->minor, major, minor);
+	if (be->major | be->minor) {
+		if (be->major !=3D major || be->minor !=3D minor)
+			pr_warn(DRV_PFX "changing physical device (from =
%x:%x to %x:%x) not supported.\n",
+				be->major, be->minor, major, minor);
 		return;
 	}
=20
@@ -541,36 +543,33 @@ static void backend_changed(struct xenbu
 		kfree(device_type);
 	}
=20
-	if (be->major =3D=3D 0 && be->minor =3D=3D 0) {
-		/* Front end dir is a number, which is used as the handle. =
*/
+	/* Front end dir is a number, which is used as the handle. */
+	err =3D strict_strtoul(strrchr(dev->otherend, '/') + 1, 0, =
&handle);
+	if (err)
+		return;
=20
-		char *p =3D strrchr(dev->otherend, '/') + 1;
-		long handle;
-		err =3D strict_strtoul(p, 0, &handle);
-		if (err)
-			return;
+	be->major =3D major;
+	be->minor =3D minor;
=20
-		be->major =3D major;
-		be->minor =3D minor;
-
-		err =3D xen_vbd_create(be->blkif, handle, major, minor,
-				 (NULL =3D=3D strchr(be->mode, 'w')), =
cdrom);
-		if (err) {
-			be->major =3D 0;
-			be->minor =3D 0;
-			xenbus_dev_fatal(dev, err, "creating vbd structure"=
);
-			return;
-		}
+	err =3D xen_vbd_create(be->blkif, handle, major, minor,
+			     !strchr(be->mode, 'w'), cdrom);
=20
+	if (err)
+		xenbus_dev_fatal(dev, err, "creating vbd structure");
+	else {
 		err =3D xenvbd_sysfs_addif(dev);
 		if (err) {
 			xen_vbd_free(&be->blkif->vbd);
-			be->major =3D 0;
-			be->minor =3D 0;
 			xenbus_dev_fatal(dev, err, "creating sysfs =
entries");
-			return;
 		}
+	}
=20
+	if (err) {
+		kfree(be->mode);
+		be->mode =3D NULL;
+		be->major =3D 0;
+		be->minor =3D 0;
+	} else {
 		/* We're potentially connected now */
 		xen_update_blkif_status(be->blkif);
 	}




--=__PartFDCC72FF.4__=
Content-Type: text/plain; name="linux-3.7-xen-blkback-mode-leak.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment; filename="linux-3.7-xen-blkback-mode-leak.patch"

xen-blkback: do not leak mode property=0A=0A"be->mode" is obtained from =
xenbus_read(), which does a kmalloc() for=0Athe message body. The short =
string is never released, so do it along=0Awith freeing "be" itself, and =
make sure the string isn't kept when=0Abackend_changed() doesn't complete =
successfully (which made it=0Adesirable to slightly re-structure that =
function, so that the error=0Acleanup can be done in one place).=0A=0ARepor=
ted-by: Olaf Hering <olaf@aepfle.de>=0ASigned-off-by: Jan Beulich =
<jbeulich@suse.com>=0A=0A---=0A drivers/block/xen-blkback/xenbus.c |   49 =
++++++++++++++++++-------------------=0A 1 file changed, 24 insertions(+), =
25 deletions(-)=0A=0A--- 3.7/drivers/block/xen-blkback/xenbus.c=0A+++ =
3.7-xen-blkback-mode-leak/drivers/block/xen-blkback/xenbus.c=0A@@ -366,6 =
+366,7 @@ static int xen_blkbk_remove(struct xenbu=0A 		be->blkif =
=3D NULL;=0A 	}=0A =0A+	kfree(be->mode);=0A 	kfree(be);=0A 	=
dev_set_drvdata(&dev->dev, NULL);=0A 	return 0;=0A@@ -501,6 +502,7 @@ =
static void backend_changed(struct xenbu=0A 		=3D container_of(wa=
tch, struct backend_info, backend_watch);=0A 	struct xenbus_device *dev =
=3D be->dev;=0A 	int cdrom =3D 0;=0A+	unsigned long handle;=0A 	=
char *device_type;=0A =0A 	DPRINTK("");=0A@@ -520,10 +522,10 @@ =
static void backend_changed(struct xenbu=0A 		return;=0A 	=
}=0A =0A-	if ((be->major || be->minor) &&=0A-	    ((be->major =
!=3D major) || (be->minor !=3D minor))) {=0A-		pr_warn(DRV_PFX =
"changing physical device (from %x:%x to %x:%x) not supported.\n",=0A-		=
	be->major, be->minor, major, minor);=0A+	if (be->major | =
be->minor) {=0A+		if (be->major !=3D major || be->minor !=3D =
minor)=0A+			pr_warn(DRV_PFX "changing physical device =
(from %x:%x to %x:%x) not supported.\n",=0A+				=
be->major, be->minor, major, minor);=0A 		return;=0A 	=
}=0A =0A@@ -541,36 +543,33 @@ static void backend_changed(struct xenbu=0A 	=
	kfree(device_type);=0A 	}=0A =0A-	if (be->major =3D=3D 0 && =
be->minor =3D=3D 0) {=0A-		/* Front end dir is a number, =
which is used as the handle. */=0A+	/* Front end dir is a number, =
which is used as the handle. */=0A+	err =3D strict_strtoul(strrchr(dev-=
>otherend, '/') + 1, 0, &handle);=0A+	if (err)=0A+		return;=0A =
=0A-		char *p =3D strrchr(dev->otherend, '/') + 1;=0A-		=
long handle;=0A-		err =3D strict_strtoul(p, 0, &handle);=0A-	=
	if (err)=0A-			return;=0A+	be->major =3D =
major;=0A+	be->minor =3D minor;=0A =0A-		be->major =3D =
major;=0A-		be->minor =3D minor;=0A-=0A-		err =3D =
xen_vbd_create(be->blkif, handle, major, minor,=0A-				=
 (NULL =3D=3D strchr(be->mode, 'w')), cdrom);=0A-		if (err) =
{=0A-			be->major =3D 0;=0A-			be->minor =
=3D 0;=0A-			xenbus_dev_fatal(dev, err, "creating vbd =
structure");=0A-			return;=0A-		}=0A+	=
err =3D xen_vbd_create(be->blkif, handle, major, minor,=0A+			=
     !strchr(be->mode, 'w'), cdrom);=0A =0A+	if (err)=0A+		=
xenbus_dev_fatal(dev, err, "creating vbd structure");=0A+	else {=0A 	=
	err =3D xenvbd_sysfs_addif(dev);=0A 		if (err) {=0A 		=
	xen_vbd_free(&be->blkif->vbd);=0A-			be->major =
=3D 0;=0A-			be->minor =3D 0;=0A 			=
xenbus_dev_fatal(dev, err, "creating sysfs entries");=0A-			=
return;=0A 		}=0A+	}=0A =0A+	if (err) {=0A+		=
kfree(be->mode);=0A+		be->mode =3D NULL;=0A+		be->major =
=3D 0;=0A+		be->minor =3D 0;=0A+	} else {=0A 		/* =
We're potentially connected now */=0A 		xen_update_blkif_status(be-=
>blkif);=0A 	}=0A
--=__PartFDCC72FF.4__=--
