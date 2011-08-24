Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752904Ab1HXUce (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 16:32:34 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:32794 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751194Ab1HXUcc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 16:32:32 -0400
Date: Wed, 24 Aug 2011 16:32:31 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Greg KH <greg@kroah.com>
cc: Hans de Goede <hdegoede@redhat.com>, USB list <linux-usb@vger.kernel.org>,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: RFC: Add USBDEVFS_TRY_DISCONNECT ioctl
In-Reply-To: <20110821164108.GC6229@kroah.com>
Message-ID: <Pine.LNX.4.44L0.1108241612590.1643-200000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1559625215-2030559715-1314217951=:1643"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.
  Send mail to mime@docserver.cac.washington.edu for more info.

---1559625215-2030559715-1314217951=:1643
Content-Type: TEXT/PLAIN; charset=US-ASCII

On Sun, 21 Aug 2011, Greg KH wrote:

> On Fri, Aug 19, 2011 at 10:56:23PM -0400, Alan Stern wrote:
> > >  It's of course racey for userspace to check
> > > whether a device is busy and then disconnect the driver, but the "try
> > > disconnect" ioctl could cause the driver to disconnect itself.  In the end there
> > > wasn't a very good solution to this problem.
> > 
> > In principle it's quite doable.  The question is whether people will 
> > stand for it.  Greg KH has already come out against the idea, although 
> > perhaps he could be persuaded.  It doesn't help that this new mechanism 
> > would be used only for USB; if other subsystems could benefit from it 
> > too then it would be easier to sell.
> 
> I still don't think this would really work that well.  But it wouldn't
> be just USB devices that need it, in the future we will have lots of
> detatched storage devices that guests want access to in "native" mode
> (Thunderbolt being one good example.)
> 
> But feel free to change my mind with a patch showing just how this all
> would work :)

Okay, here's a sample patch.  Actually it's three patches, listed one 
after another, but people can apply it like a single patch.

     1.	Introduce the USBDEVFS_TRY_DISCONNECT ioctl and the check_busy
	callback it uses.  Implement the callback in the usbfs driver; 
	this gives a way for programs to unbind kernel drivers without
	unbinding other userspace drivers.

     2.	Implement device-file reference tracking in the SCSI layer,
	and the device_open and device_close callbacks it uses.

     3.	Implement both check_busy and device_{open,close} in 
	usb-storage.

Attached is a sample program that demonstrates how to use this.  It
will unbind usb-storage from a USB interface if the storage device
isn't open or mounted, otherwise it will fail with a "device busy"  
error.  It will also unbind any other USB kernel driver from an
interface -- but it won't unbind a usbfs userspace driver that has 
claimed an interface.

Alan Stern



Patch 1: USBDEVFS_TRY_DISCONNECT

 drivers/usb/core/devio.c     |   13 +++++++++++++
 include/linux/usb.h          |    5 +++++
 include/linux/usbdevice_fs.h |    1 +
 3 files changed, 19 insertions(+)

Index: usb-3.1/include/linux/usbdevice_fs.h
===================================================================
--- usb-3.1.orig/include/linux/usbdevice_fs.h
+++ usb-3.1/include/linux/usbdevice_fs.h
@@ -204,4 +204,5 @@ struct usbdevfs_ioctl32 {
 #define USBDEVFS_CONNECT           _IO('U', 23)
 #define USBDEVFS_CLAIM_PORT        _IOR('U', 24, unsigned int)
 #define USBDEVFS_RELEASE_PORT      _IOR('U', 25, unsigned int)
+#define USBDEVFS_TRY_DISCONNECT    _IO('U', 26)
 #endif /* _LINUX_USBDEVICE_FS_H */
Index: usb-3.1/include/linux/usb.h
===================================================================
--- usb-3.1.orig/include/linux/usb.h
+++ usb-3.1/include/linux/usb.h
@@ -812,6 +812,9 @@ struct usbdrv_wrap {
  *	post_reset method is called.
  * @post_reset: Called by usb_reset_device() after the device
  *	has been reset
+ * @check_busy: Called to see whether the device is currently
+ *	busy before doing a user-initiated unbind.  The driver must not
+ *	allow the device to become busy after this routine returns 0.
  * @id_table: USB drivers use ID table to support hotplugging.
  *	Export this with MODULE_DEVICE_TABLE(usb,...).  This must be set
  *	or your driver's probe function will never get called.
@@ -858,6 +861,8 @@ struct usb_driver {
 	int (*pre_reset)(struct usb_interface *intf);
 	int (*post_reset)(struct usb_interface *intf);
 
+	int (*check_busy)(struct usb_interface *intf);
+
 	const struct usb_device_id *id_table;
 
 	struct usb_dynids dynids;
Index: usb-3.1/drivers/usb/core/devio.c
===================================================================
--- usb-3.1.orig/drivers/usb/core/devio.c
+++ usb-3.1/drivers/usb/core/devio.c
@@ -516,12 +516,18 @@ static int driver_resume(struct usb_inte
 	return 0;
 }
 
+static int driver_check_busy(struct usb_interface *intf)
+{
+	return -EBUSY;
+}
+
 struct usb_driver usbfs_driver = {
 	.name =		"usbfs",
 	.probe =	driver_probe,
 	.disconnect =	driver_disconnect,
 	.suspend =	driver_suspend,
 	.resume =	driver_resume,
+	.check_busy =	driver_check_busy,
 };
 
 static int claimintf(struct dev_state *ps, unsigned int ifnum)
@@ -1647,9 +1653,16 @@ static int proc_ioctl(struct dev_state *
 	else switch (ctl->ioctl_code) {
 
 	/* disconnect kernel driver from interface */
+	case USBDEVFS_TRY_DISCONNECT:
 	case USBDEVFS_DISCONNECT:
 		if (intf->dev.driver) {
 			driver = to_usb_driver(intf->dev.driver);
+			if (ctl->ioctl_code == USBDEVFS_TRY_DISCONNECT &&
+					driver->check_busy) {
+				retval = driver->check_busy(intf);
+				if (retval)
+					break;
+			}
 			dev_dbg(&intf->dev, "disconnect by usbfs\n");
 			usb_driver_release_interface(driver, intf);
 		} else



Patch 2: SCSI device file open reference tracking

 drivers/scsi/hosts.c       |   32 ++++++++++++++++++++++++++++++++
 drivers/scsi/sd.c          |    7 +++++++
 drivers/scsi/sg.c          |    8 +++++++-
 drivers/scsi/sr.c          |    3 ++-
 include/scsi/scsi_device.h |    2 ++
 include/scsi/scsi_host.h   |   19 +++++++++++++++++++
 6 files changed, 69 insertions(+), 2 deletions(-)

Index: usb-3.1/include/scsi/scsi_host.h
===================================================================
--- usb-3.1.orig/include/scsi/scsi_host.h
+++ usb-3.1/include/scsi/scsi_host.h
@@ -356,6 +356,25 @@ struct scsi_host_template {
 	enum blk_eh_timer_return (*eh_timed_out)(struct scsi_cmnd *);
 
 	/*
+	 * This function is called when a device file is about to be opened;
+	 * if the function returns nonzero then the open fails.  The low
+	 * level driver can use this to track the number of open device file
+	 * references (including mounts), and thereby know when it is safe to
+	 * unregister the host without disrupting mounted filesystems or
+	 * the like.
+	 *
+	 * Status: OPTIONAL
+	 */
+	int (*device_open)(struct Scsi_Host *, struct scsi_device *);
+
+	/*
+	 * This function is called after a device file is closed.
+	 *
+	 * Status: OPTIONAL
+	 */
+	void (*device_close)(struct Scsi_Host *, struct scsi_device *);
+
+	/*
 	 * Name of proc directory
 	 */
 	const char *proc_name;
Index: usb-3.1/include/scsi/scsi_device.h
===================================================================
--- usb-3.1.orig/include/scsi/scsi_device.h
+++ usb-3.1/include/scsi/scsi_device.h
@@ -361,6 +361,8 @@ extern struct scsi_event *sdev_evt_alloc
 extern void sdev_evt_send(struct scsi_device *sdev, struct scsi_event *evt);
 extern void sdev_evt_send_simple(struct scsi_device *sdev,
 			  enum scsi_device_event evt_type, gfp_t gfpflags);
+extern int scsi_device_open(struct scsi_device *sdev);
+extern void scsi_device_close(struct scsi_device *sdev);
 extern int scsi_device_quiesce(struct scsi_device *sdev);
 extern void scsi_device_resume(struct scsi_device *sdev);
 extern void scsi_target_quiesce(struct scsi_target *);
Index: usb-3.1/drivers/scsi/hosts.c
===================================================================
--- usb-3.1.orig/drivers/scsi/hosts.c
+++ usb-3.1/drivers/scsi/hosts.c
@@ -577,3 +577,35 @@ void scsi_flush_work(struct Scsi_Host *s
 	flush_workqueue(shost->work_q);
 }
 EXPORT_SYMBOL_GPL(scsi_flush_work);
+
+/**
+ * scsi_device_open - Check whether it's okay to open a device file
+ * @sdev:	Device whose file will be opened.
+ *
+ * Return value:
+ *	0 if open is allowed; negative errno otherwise
+ **/
+int scsi_device_open(struct scsi_device *sdev)
+{
+	struct Scsi_Host *shost = sdev->host;
+	struct scsi_host_template *sht = shost->hostt;
+
+	if (!sht->device_open)
+		return 0;
+	return sht->device_open(shost, sdev);
+}
+EXPORT_SYMBOL_GPL(scsi_device_open);
+
+/**
+ * scsi_device_close - Announce that a device file has been closed
+ * @sdev:	Device whose file has been closed.
+ **/
+void scsi_device_close(struct scsi_device *sdev)
+{
+	struct Scsi_Host *shost = sdev->host;
+	struct scsi_host_template *sht = shost->hostt;
+
+	if (sht->device_close)
+		sht->device_close(shost, sdev);
+}
+EXPORT_SYMBOL_GPL(scsi_device_close);
Index: usb-3.1/drivers/scsi/sd.c
===================================================================
--- usb-3.1.orig/drivers/scsi/sd.c
+++ usb-3.1/drivers/scsi/sd.c
@@ -935,6 +935,10 @@ static int sd_open(struct block_device *
 
 	sdev = sdkp->device;
 
+	retval = scsi_device_open(sdev);
+	if (retval)
+		goto error_open;
+
 	retval = scsi_autopm_get_device(sdev);
 	if (retval)
 		goto error_autopm;
@@ -985,6 +989,8 @@ static int sd_open(struct block_device *
 error_out:
 	scsi_autopm_put_device(sdev);
 error_autopm:
+	scsi_device_close(sdev);
+error_open:
 	scsi_disk_put(sdkp);
 	return retval;	
 }
@@ -1020,6 +1026,7 @@ static int sd_release(struct gendisk *di
 	 */
 
 	scsi_autopm_put_device(sdev);
+	scsi_device_close(sdev);
 	scsi_disk_put(sdkp);
 	return 0;
 }
Index: usb-3.1/drivers/scsi/sr.c
===================================================================
--- usb-3.1.orig/drivers/scsi/sr.c
+++ usb-3.1/drivers/scsi/sr.c
@@ -623,7 +623,7 @@ static int sr_open(struct cdrom_device_i
 	if (!scsi_block_when_processing_errors(sdev))
 		goto error_out;
 
-	return 0;
+	retval = scsi_device_open(sdev);
 
 error_out:
 	return retval;	
@@ -636,6 +636,7 @@ static void sr_release(struct cdrom_devi
 	if (cd->device->sector_size > 2048)
 		sr_set_blocklength(cd, 2048);
 
+	scsi_device_close(cd->device);
 }
 
 static int sr_probe(struct device *dev)
Index: usb-3.1/drivers/scsi/sg.c
===================================================================
--- usb-3.1.orig/drivers/scsi/sg.c
+++ usb-3.1/drivers/scsi/sg.c
@@ -247,10 +247,14 @@ sg_open(struct inode *inode, struct file
 	if (retval)
 		goto sg_put;
 
-	retval = scsi_autopm_get_device(sdp->device);
+	retval = scsi_device_open(sdp->device);
 	if (retval)
 		goto sdp_put;
 
+	retval = scsi_autopm_get_device(sdp->device);
+	if (retval)
+		goto scsi_device_close;
+
 	if (!((flags & O_NONBLOCK) ||
 	      scsi_block_when_processing_errors(sdp->device))) {
 		retval = -ENXIO;
@@ -310,6 +314,8 @@ sg_open(struct inode *inode, struct file
 error_out:
 	if (retval) {
 		scsi_autopm_put_device(sdp->device);
+scsi_device_close:
+		scsi_device_close(sdp->device);
 sdp_put:
 		scsi_device_put(sdp->device);
 	}



Patch 3: implementation for usb-storage

 drivers/usb/storage/scsiglue.c |   30 ++++++++++++++++++++++++++++++
 drivers/usb/storage/usb.c      |   21 +++++++++++++++++++++
 drivers/usb/storage/usb.h      |    1 +
 3 files changed, 52 insertions(+)

Index: usb-3.1/drivers/usb/storage/usb.h
===================================================================
--- usb-3.1.orig/drivers/usb/storage/usb.h
+++ usb-3.1/drivers/usb/storage/usb.h
@@ -135,6 +135,7 @@ struct us_data {
 	struct scsi_cmnd	*srb;		 /* current srb		*/
 	unsigned int		tag;		 /* current dCBWTag	*/
 	char			scsi_name[32];	 /* scsi_host name	*/
+	int			open_count;	 /* open file refs	*/
 
 	/* control and bulk communications data */
 	struct urb		*current_urb;	 /* USB requests	 */
Index: usb-3.1/drivers/usb/storage/usb.c
===================================================================
--- usb-3.1.orig/drivers/usb/storage/usb.c
+++ usb-3.1/drivers/usb/storage/usb.c
@@ -217,6 +217,26 @@ int usb_stor_post_reset(struct usb_inter
 }
 EXPORT_SYMBOL_GPL(usb_stor_post_reset);
 
+int usb_stor_check_busy(struct usb_interface *iface)
+{
+	struct us_data *us = usb_get_intfdata(iface);
+	struct Scsi_Host *host = us_to_host(us);
+	int rc = -EBUSY;
+
+	US_DEBUGP("%s\n", __func__);
+
+	/* If there are no open file references then we aren't busy */
+	scsi_lock(host);
+	if (us->open_count <= 0) {
+		us->open_count = -1;	/* No more opens allowed */
+		rc = 0;
+	}
+	scsi_unlock(host);
+
+	return rc;
+}
+EXPORT_SYMBOL_GPL(usb_stor_check_busy);
+
 /*
  * fill_inquiry_response takes an unsigned char array (which must
  * be at least 36 characters) and populates the vendor name,
@@ -1060,6 +1080,7 @@ static struct usb_driver usb_storage_dri
 	.reset_resume =	usb_stor_reset_resume,
 	.pre_reset =	usb_stor_pre_reset,
 	.post_reset =	usb_stor_post_reset,
+	.check_busy =	usb_stor_check_busy,
 	.id_table =	usb_storage_usb_ids,
 	.supports_autosuspend = 1,
 	.soft_unbind =	1,
Index: usb-3.1/drivers/usb/storage/scsiglue.c
===================================================================
--- usb-3.1.orig/drivers/usb/storage/scsiglue.c
+++ usb-3.1/drivers/usb/storage/scsiglue.c
@@ -411,6 +411,32 @@ void usb_stor_report_bus_reset(struct us
 	scsi_unlock(host);
 }
 
+/* Check whether to allow a device file to be opened. */
+static int device_open(struct Scsi_Host *host, struct scsi_device *sdev)
+{
+	struct us_data *us = host_to_us(host);
+	int rc = -EIO;
+
+	/* Allow the open if a disconnect hasn't been requested */
+	scsi_lock(host);
+	if (us->open_count >= 0) {
+		++us->open_count;
+		rc = 0;
+	}
+	scsi_unlock(host);
+	return rc;
+}
+
+/* A device file has been closed. */
+static void device_close(struct Scsi_Host *host, struct scsi_device *sdev)
+{
+	struct us_data *us = host_to_us(host);
+
+	scsi_lock(host);
+		--us->open_count;
+	scsi_unlock(host);
+}
+
 /***********************************************************************
  * /proc/scsi/ functions
  ***********************************************************************/
@@ -537,6 +563,10 @@ struct scsi_host_template usb_stor_host_
 	.eh_device_reset_handler =	device_reset,
 	.eh_bus_reset_handler =		bus_reset,
 
+	/* open file reference notifiers */
+	.device_open =			device_open,
+	.device_close =			device_close,
+
 	/* queue commands only, only one command per LUN */
 	.can_queue =			1,
 	.cmd_per_lun =			1,

---1559625215-2030559715-1314217951=:1643
Content-Type: TEXT/plain; name="usb-try-discon.c"
Content-Transfer-Encoding: BASE64
Content-ID: <Pine.LNX.4.44L0.1108241632310.1643@iolanthe.rowland.org>
Content-Description: 
Content-Disposition: attachment; filename="usb-try-discon.c"

LyogdXNiLXRyeS1kaXNjb24gLS0gdHJ5IHRvIGNsYWltIGEgVVNCIG1hc3Mt
c3RvcmFnZSBpbnRlcmZhY2UgKi8NCg0KI2luY2x1ZGUgPHN0ZGlvLmg+DQoj
aW5jbHVkZSA8dW5pc3RkLmg+DQojaW5jbHVkZSA8c3RkbGliLmg+DQojaW5j
bHVkZSA8ZmNudGwuaD4NCiNpbmNsdWRlIDxlcnJuby5oPg0KI2luY2x1ZGUg
PHN5cy9pb2N0bC5oPg0KDQojaW5jbHVkZSA8bGludXgvdXNiZGV2aWNlX2Zz
Lmg+DQojZGVmaW5lIFVTQkRFVkZTX1RSWV9ESVNDT05ORUNUICAgICAgICBf
SU8oJ1UnLCAyNikNCg0KDQppbnQgbWFpbihpbnQgYXJnYywgY2hhciAqKmFy
Z3YpDQp7DQoJY29uc3QgY2hhciAqZmlsZW5hbWU7DQoJdW5zaWduZWQgaW50
ZjsNCglpbnQgZmQ7DQoJaW50IHJjOw0KCWludCBjOw0KCXN0cnVjdCB1c2Jk
ZXZmc19pb2N0bCB1aW9jdGw7DQoNCglpZiAoYXJnYyAhPSAzKSB7DQoJCWZw
cmludGYoc3RkZXJyLCAiVXNhZ2U6IHVzYi10cnktZGlzY29uIGRldnBhdGgg
aW50Zi1udW1cbiIpOw0KCQlyZXR1cm4gMTsNCgl9DQoJZmlsZW5hbWUgPSBh
cmd2WzFdOw0KCWludGYgPSBhdG9pKGFyZ3ZbMl0pOw0KDQoJZmQgPSBvcGVu
KGZpbGVuYW1lLCBPX1dST05MWSk7DQoJaWYgKGZkIDwgMCkgew0KCQlwZXJy
b3IoIkVycm9yIG9wZW5pbmcgZGV2aWNlIGZpbGUiKTsNCgkJcmV0dXJuIDE7
DQoJfQ0KDQoJcHJpbnRmKCJUcnlpbmcgdG8gZGlzY29ubmVjdCBkcml2ZXIg
b2YgJXMgaW50ZXJmYWNlICVkXG4iLA0KCQkJZmlsZW5hbWUsIGludGYpOw0K
CXVpb2N0bC5pZm5vID0gaW50ZjsNCgl1aW9jdGwuaW9jdGxfY29kZSA9IFVT
QkRFVkZTX1RSWV9ESVNDT05ORUNUOw0KCXVpb2N0bC5kYXRhID0gTlVMTDsN
CglyYyA9IGlvY3RsKGZkLCBVU0JERVZGU19JT0NUTCwgJnVpb2N0bCk7DQoJ
aWYgKHJjIDwgMCAmJiBlcnJubyA9PSBFTk9EQVRBKSB7DQoJCXByaW50Zigi
Tm8gZHJpdmVyIHdhcyBjb25uZWN0ZWQuXG4iKTsNCgl9IGVsc2UgaWYgKHJj
IDwgMCkgew0KCQlwZXJyb3IoIkVycm9yIGluIGlvY3RsIik7DQoJCXJldHVy
biAxOw0KCX0gZWxzZSB7DQoJCXByaW50ZigiRGlzY29ubmVjdCBzdWNjZXNz
ZnVsXG4iKTsNCgl9DQoNCglwcmludGYoIlRyeWluZyB0byBjbGFpbSB0aGUg
aW50ZXJmYWNlXG4iKTsNCglyYyA9IGlvY3RsKGZkLCBVU0JERVZGU19DTEFJ
TUlOVEVSRkFDRSwgJmludGYpOw0KCWlmIChyYyA8IDApIHsNCgkJcGVycm9y
KCJFcnJvciBpbiBpb2N0bCIpOw0KCQlyZXR1cm4gMTsNCgl9DQoJcHJpbnRm
KCJDbGFpbSBzdWNjZXNzZnVsXG4iKTsNCg0KCXByaW50ZigiUHJlc3MgRW50
ZXIgdG8gY29udGludWUuLi4iKTsNCglkbyB7DQoJCWMgPSBnZXRjKHN0ZGlu
KTsNCgl9IHdoaWxlIChjICE9ICdcbicgJiYgYyAhPSBFT0YpOw0KDQoJcHJp
bnRmKCJSZWxlYXNpbmcgaW50ZXJmYWNlXG4iKTsNCglyYyA9IGlvY3RsKGZk
LCBVU0JERVZGU19SRUxFQVNFSU5URVJGQUNFLCAmaW50Zik7DQoJaWYgKHJj
IDwgMCkgew0KCQlwZXJyb3IoIkVycm9yIGluIGlvY3RsIik7DQoJCXJldHVy
biAxOw0KCX0NCglwcmludGYoIlJlbGVhc2Ugc3VjY2Vzc2Z1bFxuIik7DQoN
CgljbG9zZShmZCk7DQoJcmV0dXJuIDA7DQp9DQo=
---1559625215-2030559715-1314217951=:1643--
