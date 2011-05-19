Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934358Ab1ESXxe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 19:53:34 -0400
Received: from qmta11.westchester.pa.mail.comcast.net ([76.96.59.211]:39397
	"EHLO QMTA11.westchester.pa.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934202Ab1ESXxc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 19:53:32 -0400
From: matt mooney <mfm@muteddisk.com>
To: Greg Kroah-Hartman <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH] staging: usbip: replace usbip_u{dbg,err,info} and printk with dev_ and pr_
Date: Thu, 19 May 2011 16:47:32 -0700
Message-Id: <2db81796703063c0816d0d99040c6fbd6da50007.1305847719.git.mfm@muteddisk.com>
X-Mailer: git-send-email 1.7.5.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This switches all of the usbip_u{dbg,err,info} and printk statements to
dev_<level>, if possible, or pr_<level> macros. And removes a few
unnecessary debug statements.

Signed-off-by: matt mooney <mfm@muteddisk.com>
---
Hi Greg,

Not as many of these could be changed to dev_* as I had initially
thought. A few were not changed to dev_* that could have possibly been
due to the struct device being deeply embedded within another
structure. I did not want to introduce any null pointer deferences, so
I played it safe for the time being. But as development continues I
will modify these.

I also wonder if anybody is currently using usbip because I get a kernel
crash on the remote side everytime I try to attach an exported device.
Of course, I am running the remote and host machines through kvm, but I
don't think that should make a difference. Anyway, I thought you should
know so that if this comes up, you know that it was in this state before
any of my changes ;)

Thanks,
matt

 drivers/staging/usbip/stub_dev.c     |   44 +++----
 drivers/staging/usbip/stub_main.c    |   19 ++--
 drivers/staging/usbip/stub_rx.c      |   23 ++--
 drivers/staging/usbip/stub_tx.c      |   17 ++--
 drivers/staging/usbip/usbip_common.c |  230 +++++++++++++++------------------
 drivers/staging/usbip/usbip_common.h |   46 +------
 drivers/staging/usbip/usbip_event.c  |    3 +-
 drivers/staging/usbip/vhci_hcd.c     |   89 +++++--------
 drivers/staging/usbip/vhci_rx.c      |   33 +++---
 drivers/staging/usbip/vhci_sysfs.c   |   14 +-
 drivers/staging/usbip/vhci_tx.c      |    8 +-
 11 files changed, 220 insertions(+), 306 deletions(-)

diff --git a/drivers/staging/usbip/stub_dev.c b/drivers/staging/usbip/stub_dev.c
index c71d0a3..6e99ec8 100644
--- a/drivers/staging/usbip/stub_dev.c
+++ b/drivers/staging/usbip/stub_dev.c
@@ -196,7 +196,8 @@ static void stub_shutdown_connection(struct usbip_device *ud)
 	 * step 1?
 	 */
 	if (ud->tcp_socket) {
-		usbip_udbg("shutdown tcp_socket %p\n", ud->tcp_socket);
+		dev_dbg(&sdev->udev->dev, "shutdown tcp_socket %p\n",
+			ud->tcp_socket);
 		kernel_sock_shutdown(ud->tcp_socket, SHUT_RDWR);
 	}
 
@@ -244,12 +245,11 @@ static void stub_device_reset(struct usbip_device *ud)
 	struct usb_device *udev = sdev->udev;
 	int ret;
 
-	usbip_udbg("device reset");
+	dev_dbg(&udev->dev, "device reset");
 
 	ret = usb_lock_device_for_reset(udev, sdev->interface);
 	if (ret < 0) {
 		dev_err(&udev->dev, "lock for reset\n");
-
 		spin_lock(&ud->lock);
 		ud->status = SDEV_ST_ERROR;
 		spin_unlock(&ud->lock);
@@ -336,7 +336,8 @@ static struct stub_device *stub_device_alloc(struct usb_device *udev,
 
 	usbip_start_eh(&sdev->ud);
 
-	usbip_udbg("register new interface\n");
+	dev_dbg(&interface->dev, "register new interface\n");
+
 	return sdev;
 }
 
@@ -346,7 +347,7 @@ static int stub_device_free(struct stub_device *sdev)
 		return -EINVAL;
 
 	kfree(sdev);
-	usbip_udbg("kfree udev ok\n");
+	pr_debug("kfree udev ok\n");
 
 	return 0;
 }
@@ -376,9 +377,8 @@ static int stub_probe(struct usb_interface *interface,
 	busid_priv = get_busid_priv(udev_busid);
 	if (!busid_priv  || (busid_priv->status == STUB_BUSID_REMOV) ||
 	    (busid_priv->status == STUB_BUSID_OTHER)) {
-		dev_info(&interface->dev,
-			 "this device %s is not in match_busid table. skip!\n",
-			 udev_busid);
+		dev_info(&interface->dev, "%s is not in match_busid table... "
+			 "skip!\n", udev_busid);
 
 		/*
 		 * Return value should be ENODEV or ENOXIO to continue trying
@@ -388,15 +388,15 @@ static int stub_probe(struct usb_interface *interface,
 		return -ENODEV;
 	}
 
-	if (udev->descriptor.bDeviceClass ==  USB_CLASS_HUB) {
-		usbip_udbg("this device %s is a usb hub device. skip!\n",
-			   udev_busid);
+	if (udev->descriptor.bDeviceClass == USB_CLASS_HUB) {
+		dev_dbg(&udev->dev, "%s is a usb hub device... skip!\n",
+			 udev_busid);
 		return -ENODEV;
 	}
 
 	if (!strcmp(udev->bus->bus_name, "vhci_hcd")) {
-		usbip_udbg("this device %s is attached on vhci_hcd. skip!\n",
-			   udev_busid);
+		dev_dbg(&udev->dev, "%s is attached on vhci_hcd... skip!\n",
+			 udev_busid);
 		return -ENODEV;
 	}
 
@@ -406,8 +406,7 @@ static int stub_probe(struct usb_interface *interface,
 			return -ENODEV;
 
 		busid_priv->interf_count++;
-		dev_info(&interface->dev,
-			 "USB/IP Stub: register a new interface "
+		dev_info(&interface->dev, "usbip-host: register new interface "
 			 "(bus %u dev %u ifn %u)\n",
 			 udev->bus->busnum, udev->devnum,
 			 interface->cur_altsetting->desc.bInterfaceNumber);
@@ -417,7 +416,7 @@ static int stub_probe(struct usb_interface *interface,
 
 		err = stub_add_files(&interface->dev);
 		if (err) {
-			dev_err(&interface->dev, "create sysfs files for %s\n",
+			dev_err(&interface->dev, "stub_add_files for %s\n",
 				udev_busid);
 			usb_set_intfdata(interface, NULL);
 			busid_priv->interf_count--;
@@ -434,7 +433,7 @@ static int stub_probe(struct usb_interface *interface,
 	if (!sdev)
 		return -ENOMEM;
 
-	dev_info(&interface->dev, "USB/IP Stub: register a new device "
+	dev_info(&interface->dev, "usbip-host: register new device "
 		 "(bus %u dev %u ifn %u)\n", udev->bus->busnum, udev->devnum,
 		 interface->cur_altsetting->desc.bInterfaceNumber);
 
@@ -449,8 +448,7 @@ static int stub_probe(struct usb_interface *interface,
 
 	err = stub_add_files(&interface->dev);
 	if (err) {
-		dev_err(&interface->dev, "create sysfs files for %s\n",
-			udev_busid);
+		dev_err(&interface->dev, "stub_add_files for %s\n", udev_busid);
 		usb_set_intfdata(interface, NULL);
 		usb_put_intf(interface);
 
@@ -486,10 +484,9 @@ static void stub_disconnect(struct usb_interface *interface)
 	const char *udev_busid = dev_name(interface->dev.parent);
 	struct bus_id_priv *busid_priv;
 
-	busid_priv = get_busid_priv(udev_busid);
-
-	usbip_udbg("Enter\n");
+	dev_dbg(&interface->dev, "Enter\n");
 
+	busid_priv = get_busid_priv(udev_busid);
 	if (!busid_priv) {
 		BUG();
 		return;
@@ -499,7 +496,7 @@ static void stub_disconnect(struct usb_interface *interface)
 
 	/* get stub_device */
 	if (!sdev) {
-		err(" could not get device from inteface data");
+		dev_err(&interface->dev, "could not get device");
 		/* BUG(); */
 		return;
 	}
@@ -543,5 +540,4 @@ static void stub_disconnect(struct usb_interface *interface)
 		busid_priv->status = STUB_BUSID_OTHER;
 		del_match_busid((char *)udev_busid);
 	}
-	usbip_udbg("bye\n");
 }
diff --git a/drivers/staging/usbip/stub_main.c b/drivers/staging/usbip/stub_main.c
index 5568110..e9085d6 100644
--- a/drivers/staging/usbip/stub_main.c
+++ b/drivers/staging/usbip/stub_main.c
@@ -178,14 +178,14 @@ static ssize_t store_match_busid(struct device_driver *dev, const char *buf,
 		if (add_match_busid(busid) < 0)
 			return -ENOMEM;
 		else {
-			usbip_udbg("add busid %s\n", busid);
+			pr_debug("add busid %s\n", busid);
 			return count;
 		}
 	} else if (!strncmp(buf, "del ", 4)) {
 		if (del_match_busid(busid) < 0)
 			return -ENODEV;
 		else {
-			usbip_udbg("del busid %s\n", busid);
+			pr_debug("del busid %s\n", busid);
 			return count;
 		}
 	} else
@@ -239,12 +239,12 @@ void stub_device_cleanup_urbs(struct stub_device *sdev)
 {
 	struct stub_priv *priv;
 
-	usbip_udbg("free sdev %p\n", sdev);
+	dev_dbg(&sdev->udev->dev, "free sdev %p\n", sdev);
 
 	while ((priv = stub_priv_pop(sdev))) {
 		struct urb *urb = priv->urb;
 
-		usbip_udbg("   free urb %p\n", urb);
+		dev_dbg(&sdev->udev->dev, "free urb %p\n", urb);
 		usb_kill_urb(urb);
 
 		kmem_cache_free(stub_priv_cache, priv);
@@ -265,20 +265,17 @@ static int __init usb_stub_init(void)
 					    SLAB_HWCACHE_ALIGN, NULL);
 
 	if (!stub_priv_cache) {
-		printk(KERN_ERR KBUILD_MODNAME
-		       ": create stub_priv_cache error\n");
+		pr_err("create stub_priv_cache error\n");
 		return -ENOMEM;
 	}
 
 	ret = usb_register(&stub_driver);
 	if (ret) {
-		printk(KERN_ERR KBUILD_MODNAME ": usb_register failed %d\n",
-		       ret);
+		pr_err("usb_register failed %d\n", ret);
 		goto error_usb_register;
 	}
 
-	printk(KERN_INFO KBUILD_MODNAME ": " DRIVER_DESC " " USBIP_VERSION
-	       "\n");
+	pr_info(DRIVER_DESC " " USBIP_VERSION "\n");
 
 	init_busid_table();
 
@@ -286,7 +283,7 @@ static int __init usb_stub_init(void)
 				 &driver_attr_match_busid);
 
 	if (ret) {
-		printk(KERN_ERR KBUILD_MODNAME ": create driver sysfs\n");
+		pr_err("create driver sysfs\n");
 		goto error_create_file;
 	}
 
diff --git a/drivers/staging/usbip/stub_rx.c b/drivers/staging/usbip/stub_rx.c
index e245609..a5c1fa1 100644
--- a/drivers/staging/usbip/stub_rx.c
+++ b/drivers/staging/usbip/stub_rx.c
@@ -102,11 +102,11 @@ static int tweak_clear_halt_cmd(struct urb *urb)
 
 	ret = usb_clear_halt(urb->dev, target_pipe);
 	if (ret < 0)
-		usbip_uinfo("clear_halt error: devnum %d endp %d, %d\n",
-			    urb->dev->devnum, target_endp, ret);
+		dev_err(&urb->dev->dev, "usb_clear_halt error: devnum %d endp "
+			"%d ret %d\n", urb->dev->devnum, target_endp, ret);
 	else
-		usbip_uinfo("clear_halt done: devnum %d endp %d\n",
-			    urb->dev->devnum, target_endp);
+		dev_info(&urb->dev->dev, "usb_clear_halt done: devnum %d endp "
+			 "%d\n", urb->dev->devnum, target_endp);
 
 	return ret;
 }
@@ -127,11 +127,11 @@ static int tweak_set_interface_cmd(struct urb *urb)
 
 	ret = usb_set_interface(urb->dev, interface, alternate);
 	if (ret < 0)
-		usbip_uinfo("set_interface error: inf %u alt %u, %d\n",
-			    interface, alternate, ret);
+		dev_err(&urb->dev->dev, "usb_set_interface error: inf %u alt "
+			"%u ret %d\n", interface, alternate, ret);
 	else
-		usbip_uinfo("set_interface done: inf %u alt %u\n",
-			    interface, alternate);
+		dev_info(&urb->dev->dev, "usb_set_interface done: inf %u alt "
+			 "%u\n", interface, alternate);
 
 	return ret;
 }
@@ -160,9 +160,8 @@ static int tweak_set_configuration_cmd(struct urb *urb)
 	 * A user may need to set a special configuration value before
 	 * exporting the device.
 	 */
-	usbip_uinfo("set_configuration %d to %s\n",
-		    config, dev_name(&urb->dev->dev));
-	usbip_uinfo("but, skip!\n");
+	dev_info(&urb->dev->dev, "usb_set_configuration %d to %s... skip!\n",
+		 config, dev_name(&urb->dev->dev));
 
 	return 0;
 	/* return usb_driver_set_configuration(urb->dev, config); */
@@ -173,7 +172,7 @@ static int tweak_reset_device_cmd(struct urb *urb)
 	struct stub_priv *priv = (struct stub_priv *) urb->context;
 	struct stub_device *sdev = priv->sdev;
 
-	usbip_uinfo("reset_device %s\n", dev_name(&urb->dev->dev));
+	dev_info(&urb->dev->dev, "usb_queue_reset_device\n");
 
 	/*
 	 * usb_lock_device_for_reset caused a deadlock: it causes the driver
diff --git a/drivers/staging/usbip/stub_tx.c b/drivers/staging/usbip/stub_tx.c
index 3c332c2..fda2bc9 100644
--- a/drivers/staging/usbip/stub_tx.c
+++ b/drivers/staging/usbip/stub_tx.c
@@ -75,22 +75,23 @@ void stub_complete(struct urb *urb)
 		/* OK */
 		break;
 	case -ENOENT:
-		usbip_uinfo("stopped by a call of usb_kill_urb() because of"
-			    "cleaning up a virtual connection\n");
+		dev_info(&urb->dev->dev, "stopped by a call to usb_kill_urb() "
+			 "because of cleaning up a virtual connection\n");
 		return;
 	case -ECONNRESET:
-		usbip_uinfo("unlinked by a call of usb_unlink_urb()\n");
+		dev_info(&urb->dev->dev, "unlinked by a call to "
+			 "usb_unlink_urb()\n");
 		break;
 	case -EPIPE:
-		usbip_uinfo("endpoint %d is stalled\n",
-			    usb_pipeendpoint(urb->pipe));
+		dev_info(&urb->dev->dev, "endpoint %d is stalled\n",
+			 usb_pipeendpoint(urb->pipe));
 		break;
 	case -ESHUTDOWN:
-		usbip_uinfo("device removed?\n");
+		dev_info(&urb->dev->dev, "device removed?\n");
 		break;
 	default:
-		usbip_uinfo("urb completion with non-zero status %d\n",
-			    urb->status);
+		dev_info(&urb->dev->dev, "urb completion with non-zero status "
+			 "%d\n", urb->status);
 		break;
 	}
 
diff --git a/drivers/staging/usbip/usbip_common.c b/drivers/staging/usbip/usbip_common.c
index 68f5106..433a3b6 100644
--- a/drivers/staging/usbip/usbip_common.c
+++ b/drivers/staging/usbip/usbip_common.c
@@ -56,7 +56,7 @@ DEVICE_ATTR(usbip_debug, (S_IRUGO | S_IWUSR), show_flag, store_flag);
 
 static void usbip_dump_buffer(char *buff, int bufflen)
 {
-	print_hex_dump(KERN_DEBUG, "usb-ip", DUMP_PREFIX_OFFSET, 16, 4,
+	print_hex_dump(KERN_DEBUG, "usbip-core", DUMP_PREFIX_OFFSET, 16, 4,
 		       buff, bufflen, false);
 }
 
@@ -67,30 +67,25 @@ static void usbip_dump_pipe(unsigned int p)
 	unsigned char dev = usb_pipedevice(p);
 	unsigned char dir = usb_pipein(p);
 
-	printk(KERN_DEBUG "dev(%d) ", dev);
-	printk(KERN_DEBUG "ep(%d) ",  ep);
-	printk(KERN_DEBUG "%s ", dir ? "IN" : "OUT");
+	pr_debug("dev(%d) ep(%d) [%s] ", dev, ep, dir ? "IN" : "OUT");
 
 	switch (type) {
 	case PIPE_ISOCHRONOUS:
-		printk(KERN_DEBUG "%s ", "ISO");
+		pr_debug("ISO\n");
 		break;
 	case PIPE_INTERRUPT:
-		printk(KERN_DEBUG "%s ", "INT");
+		pr_debug("INT\n");
 		break;
 	case PIPE_CONTROL:
-		printk(KERN_DEBUG "%s ", "CTL");
+		pr_debug("CTRL\n");
 		break;
 	case PIPE_BULK:
-		printk(KERN_DEBUG "%s ", "BLK");
+		pr_debug("BULK\n");
 		break;
 	default:
-		printk(KERN_DEBUG "ERR");
+		pr_debug("ERR\n");
 		break;
 	}
-
-	printk(KERN_DEBUG "\n");
-
 }
 
 static void usbip_dump_usb_device(struct usb_device *udev)
@@ -98,61 +93,59 @@ static void usbip_dump_usb_device(struct usb_device *udev)
 	struct device *dev = &udev->dev;
 	int i;
 
-	dev_dbg(dev, "       devnum(%d) devpath(%s)",
+	dev_dbg(dev, "       devnum(%d) devpath(%s) ",
 		udev->devnum, udev->devpath);
 
 	switch (udev->speed) {
 	case USB_SPEED_HIGH:
-		printk(KERN_DEBUG " SPD_HIGH");
+		pr_debug("SPD_HIGH ");
 		break;
 	case USB_SPEED_FULL:
-		printk(KERN_DEBUG " SPD_FULL");
+		pr_debug("SPD_FULL ");
 		break;
 	case USB_SPEED_LOW:
-		printk(KERN_DEBUG " SPD_LOW");
+		pr_debug("SPD_LOW ");
 		break;
 	case USB_SPEED_UNKNOWN:
-		printk(KERN_DEBUG " SPD_UNKNOWN");
+		pr_debug("SPD_UNKNOWN ");
 		break;
 	default:
-		printk(KERN_DEBUG " SPD_ERROR");
+		pr_debug("SPD_ERROR ");
 		break;
 	}
 
-	printk(KERN_DEBUG " tt %p, ttport %d", udev->tt, udev->ttport);
-	printk(KERN_DEBUG "\n");
+	pr_debug("tt %p, ttport %d\n", udev->tt, udev->ttport);
 
 	dev_dbg(dev, "                    ");
 	for (i = 0; i < 16; i++)
-		printk(KERN_DEBUG " %2u", i);
-	printk(KERN_DEBUG "\n");
+		pr_debug(" %2u", i);
+	pr_debug("\n");
 
 	dev_dbg(dev, "       toggle0(IN) :");
 	for (i = 0; i < 16; i++)
-		printk(KERN_DEBUG " %2u", (udev->toggle[0] & (1 << i)) ? 1 : 0);
-	printk(KERN_DEBUG "\n");
+		pr_debug(" %2u", (udev->toggle[0] & (1 << i)) ? 1 : 0);
+	pr_debug("\n");
 
 	dev_dbg(dev, "       toggle1(OUT):");
 	for (i = 0; i < 16; i++)
-		printk(KERN_DEBUG " %2u", (udev->toggle[1] & (1 << i)) ? 1 : 0);
-	printk(KERN_DEBUG "\n");
-
+		pr_debug(" %2u", (udev->toggle[1] & (1 << i)) ? 1 : 0);
+	pr_debug("\n");
 
 	dev_dbg(dev, "       epmaxp_in   :");
 	for (i = 0; i < 16; i++) {
 		if (udev->ep_in[i])
-			printk(KERN_DEBUG " %2u",
-			     le16_to_cpu(udev->ep_in[i]->desc.wMaxPacketSize));
+			pr_debug(" %2u",
+			    le16_to_cpu(udev->ep_in[i]->desc.wMaxPacketSize));
 	}
-	printk(KERN_DEBUG "\n");
+	pr_debug("\n");
 
 	dev_dbg(dev, "       epmaxp_out  :");
 	for (i = 0; i < 16; i++) {
 		if (udev->ep_out[i])
-			printk(KERN_DEBUG " %2u",
-			     le16_to_cpu(udev->ep_out[i]->desc.wMaxPacketSize));
+			pr_debug(" %2u",
+			    le16_to_cpu(udev->ep_out[i]->desc.wMaxPacketSize));
 	}
-	printk(KERN_DEBUG "\n");
+	pr_debug("\n");
 
 	dev_dbg(dev, "parent %p, bus %p\n", udev->parent, udev->bus);
 
@@ -171,19 +164,19 @@ static void usbip_dump_request_type(__u8 rt)
 {
 	switch (rt & USB_RECIP_MASK) {
 	case USB_RECIP_DEVICE:
-		printk(KERN_DEBUG "DEVICE");
+		pr_debug("DEVICE");
 		break;
 	case USB_RECIP_INTERFACE:
-		printk(KERN_DEBUG "INTERF");
+		pr_debug("INTERF");
 		break;
 	case USB_RECIP_ENDPOINT:
-		printk(KERN_DEBUG "ENDPOI");
+		pr_debug("ENDPOI");
 		break;
 	case USB_RECIP_OTHER:
-		printk(KERN_DEBUG "OTHER ");
+		pr_debug("OTHER ");
 		break;
 	default:
-		printk(KERN_DEBUG "------");
+		pr_debug("------");
 		break;
 	}
 }
@@ -191,73 +184,64 @@ static void usbip_dump_request_type(__u8 rt)
 static void usbip_dump_usb_ctrlrequest(struct usb_ctrlrequest *cmd)
 {
 	if (!cmd) {
-		printk(KERN_DEBUG "      %s : null pointer\n", __func__);
+		pr_debug("       : null pointer\n");
 		return;
 	}
 
-	printk(KERN_DEBUG "       ");
-	printk(KERN_DEBUG "bRequestType(%02X) ", cmd->bRequestType);
-	printk(KERN_DEBUG "bRequest(%02X) " , cmd->bRequest);
-	printk(KERN_DEBUG "wValue(%04X) ", cmd->wValue);
-	printk(KERN_DEBUG "wIndex(%04X) ", cmd->wIndex);
-	printk(KERN_DEBUG "wLength(%04X) ", cmd->wLength);
-
-	printk(KERN_DEBUG "\n       ");
+	pr_debug("       ");
+	pr_debug("bRequestType(%02X) bRequest(%02X) wValue(%04X) wIndex(%04X) "
+		 "wLength(%04X) ", cmd->bRequestType, cmd->bRequest,
+		 cmd->wValue, cmd->wIndex, cmd->wLength);
+	pr_debug("\n       ");
 
 	if ((cmd->bRequestType & USB_TYPE_MASK) == USB_TYPE_STANDARD) {
-		printk(KERN_DEBUG "STANDARD ");
+		pr_debug("STANDARD ");
 		switch (cmd->bRequest) {
 		case USB_REQ_GET_STATUS:
-			printk(KERN_DEBUG "GET_STATUS");
+			pr_debug("GET_STATUS\n");
 			break;
 		case USB_REQ_CLEAR_FEATURE:
-			printk(KERN_DEBUG "CLEAR_FEAT");
+			pr_debug("CLEAR_FEAT\n");
 			break;
 		case USB_REQ_SET_FEATURE:
-			printk(KERN_DEBUG "SET_FEAT  ");
+			pr_debug("SET_FEAT  \n");
 			break;
 		case USB_REQ_SET_ADDRESS:
-			printk(KERN_DEBUG "SET_ADDRRS");
+			pr_debug("SET_ADDRRS\n");
 			break;
 		case USB_REQ_GET_DESCRIPTOR:
-			printk(KERN_DEBUG "GET_DESCRI");
+			pr_debug("GET_DESCRI\n");
 			break;
 		case USB_REQ_SET_DESCRIPTOR:
-			printk(KERN_DEBUG "SET_DESCRI");
+			pr_debug("SET_DESCRI\n");
 			break;
 		case USB_REQ_GET_CONFIGURATION:
-			printk(KERN_DEBUG "GET_CONFIG");
+			pr_debug("GET_CONFIG\n");
 			break;
 		case USB_REQ_SET_CONFIGURATION:
-			printk(KERN_DEBUG "SET_CONFIG");
+			pr_debug("SET_CONFIG\n");
 			break;
 		case USB_REQ_GET_INTERFACE:
-			printk(KERN_DEBUG "GET_INTERF");
+			pr_debug("GET_INTERF\n");
 			break;
 		case USB_REQ_SET_INTERFACE:
-			printk(KERN_DEBUG "SET_INTERF");
+			pr_debug("SET_INTERF\n");
 			break;
 		case USB_REQ_SYNCH_FRAME:
-			printk(KERN_DEBUG "SYNC_FRAME");
+			pr_debug("SYNC_FRAME\n");
 			break;
 		default:
-			printk(KERN_DEBUG "REQ(%02X) ", cmd->bRequest);
+			pr_debug("REQ(%02X) \n", cmd->bRequest);
 			break;
 		}
-
-		printk(KERN_DEBUG " ");
 		usbip_dump_request_type(cmd->bRequestType);
-
-	} else if ((cmd->bRequestType & USB_TYPE_MASK) == USB_TYPE_CLASS)
-		printk(KERN_DEBUG "CLASS   ");
-
-	else if ((cmd->bRequestType & USB_TYPE_MASK) == USB_TYPE_VENDOR)
-		printk(KERN_DEBUG "VENDOR  ");
-
-	else if ((cmd->bRequestType & USB_TYPE_MASK) == USB_TYPE_RESERVED)
-		printk(KERN_DEBUG "RESERVED");
-
-	printk(KERN_DEBUG "\n");
+	} else if ((cmd->bRequestType & USB_TYPE_MASK) == USB_TYPE_CLASS) {
+		pr_debug("CLASS   \n");
+	} else if ((cmd->bRequestType & USB_TYPE_MASK) == USB_TYPE_VENDOR) {
+		pr_debug("VENDOR  \n");
+	} else if ((cmd->bRequestType & USB_TYPE_MASK) == USB_TYPE_RESERVED) {
+		pr_debug("RESERVED\n");
+	}
 }
 
 void usbip_dump_urb(struct urb *urb)
@@ -265,16 +249,15 @@ void usbip_dump_urb(struct urb *urb)
 	struct device *dev;
 
 	if (!urb) {
-		printk(KERN_DEBUG KBUILD_MODNAME
-		       ":%s: urb: null pointer!!\n", __func__);
+		pr_debug("urb: null pointer!!\n");
 		return;
 	}
 
 	if (!urb->dev) {
-		printk(KERN_DEBUG KBUILD_MODNAME
-		       ":%s: urb->dev: null pointer!!\n", __func__);
+		pr_debug("urb->dev: null pointer!!\n");
 		return;
 	}
+
 	dev = &urb->dev->dev;
 
 	dev_dbg(dev, "   urb                   :%p\n", urb);
@@ -309,39 +292,42 @@ EXPORT_SYMBOL_GPL(usbip_dump_urb);
 
 void usbip_dump_header(struct usbip_header *pdu)
 {
-	usbip_udbg("BASE: cmd %u seq %u devid %u dir %u ep %u\n",
-		   pdu->base.command,
-		   pdu->base.seqnum,
-		   pdu->base.devid,
-		   pdu->base.direction,
-		   pdu->base.ep);
+	pr_debug("BASE: cmd %u seq %u devid %u dir %u ep %u\n",
+		 pdu->base.command,
+		 pdu->base.seqnum,
+		 pdu->base.devid,
+		 pdu->base.direction,
+		 pdu->base.ep);
 
 	switch (pdu->base.command) {
 	case USBIP_CMD_SUBMIT:
-		usbip_udbg("CMD_SUBMIT: "
-			   "x_flags %u x_len %u sf %u #p %u iv %u\n",
-			   pdu->u.cmd_submit.transfer_flags,
-			   pdu->u.cmd_submit.transfer_buffer_length,
-			   pdu->u.cmd_submit.start_frame,
-			   pdu->u.cmd_submit.number_of_packets,
-			   pdu->u.cmd_submit.interval);
+		pr_debug("USBIP_CMD_SUBMIT: "
+			 "x_flags %u x_len %u sf %u #p %d iv %d\n",
+			 pdu->u.cmd_submit.transfer_flags,
+			 pdu->u.cmd_submit.transfer_buffer_length,
+			 pdu->u.cmd_submit.start_frame,
+			 pdu->u.cmd_submit.number_of_packets,
+			 pdu->u.cmd_submit.interval);
 		break;
 	case USBIP_CMD_UNLINK:
-		usbip_udbg("CMD_UNLINK: seq %u\n", pdu->u.cmd_unlink.seqnum);
+		pr_debug("USBIP_CMD_UNLINK: seq %u\n",
+			 pdu->u.cmd_unlink.seqnum);
 		break;
 	case USBIP_RET_SUBMIT:
-		usbip_udbg("RET_SUBMIT: st %d al %u sf %d #p %d ec %d\n",
-			   pdu->u.ret_submit.status,
-			   pdu->u.ret_submit.actual_length,
-			   pdu->u.ret_submit.start_frame,
-			   pdu->u.ret_submit.number_of_packets,
-			   pdu->u.ret_submit.error_count);
+		pr_debug("USBIP_RET_SUBMIT: st %d al %u sf %d #p %d ec %d\n",
+			 pdu->u.ret_submit.status,
+			 pdu->u.ret_submit.actual_length,
+			 pdu->u.ret_submit.start_frame,
+			 pdu->u.ret_submit.number_of_packets,
+			 pdu->u.ret_submit.error_count);
+		break;
 	case USBIP_RET_UNLINK:
-		usbip_udbg("RET_UNLINK: status %d\n", pdu->u.ret_unlink.status);
+		pr_debug("USBIP_RET_UNLINK: status %d\n",
+			 pdu->u.ret_unlink.status);
 		break;
 	default:
 		/* NOT REACHED */
-		usbip_udbg("unknown command\n");
+		pr_err("unknown command\n");
 		break;
 	}
 }
@@ -363,21 +349,20 @@ int usbip_xmit(int send, struct socket *sock, char *buf,
 	usbip_dbg_xmit("enter\n");
 
 	if (!sock || !buf || !size) {
-		printk(KERN_ERR "%s: invalid arg, sock %p buff %p size %d\n",
-		       __func__, sock, buf, size);
+		pr_err("invalid arg, sock %p buff %p size %d\n", sock, buf,
+		       size);
 		return -EINVAL;
 	}
 
 	if (usbip_dbg_flag_xmit) {
 		if (send) {
 			if (!in_interrupt())
-				printk(KERN_DEBUG "%-10s:", current->comm);
+				pr_debug("%-10s:", current->comm);
 			else
-				printk(KERN_DEBUG "interrupt  :");
+				pr_debug("interrupt  :");
 
-			printk(KERN_DEBUG "%s: sending... , sock %p, buf %p, "
-			       "size %d, msg_flags %d\n", __func__,
-			       sock, buf, size, msg_flags);
+			pr_debug("sending... , sock %p, buf %p, size %d, "
+				 "msg_flags %d\n", sock, buf, size, msg_flags);
 			usbip_dump_buffer(buf, size);
 		}
 	}
@@ -400,9 +385,9 @@ int usbip_xmit(int send, struct socket *sock, char *buf,
 						MSG_WAITALL);
 
 		if (result <= 0) {
-			usbip_udbg("usbip_xmit: %s sock %p buf %p size %u ret "
-				   "%d total %d\n", send ? "send" : "receive",
-				   sock, buf, size, result, total);
+			pr_debug("%s sock %p buf %p size %u ret %d total %d\n",
+				 send ? "send" : "receive", sock, buf, size,
+				 result, total);
 			goto err;
 		}
 
@@ -415,20 +400,18 @@ int usbip_xmit(int send, struct socket *sock, char *buf,
 	if (usbip_dbg_flag_xmit) {
 		if (!send) {
 			if (!in_interrupt())
-				printk(KERN_DEBUG "%-10s:", current->comm);
+				pr_debug("%-10s:", current->comm);
 			else
-				printk(KERN_DEBUG "interrupt  :");
+				pr_debug("interrupt  :");
 
-			printk(KERN_DEBUG "usbip_xmit: receiving....\n");
+			pr_debug("receiving....\n");
 			usbip_dump_buffer(bp, osize);
-			printk(KERN_DEBUG "usbip_xmit: received, osize %d ret "
-			       "%d size %d total %d\n", osize, result, size,
-			       total);
+			pr_debug("received, osize %d ret %d size %d total %d\n",
+				 osize, result, size, total);
 		}
 
 		if (send)
-			printk(KERN_DEBUG "usbip_xmit: send, total %d\n",
-			       total);
+			pr_debug("send, total %d\n", total);
 	}
 
 	return total;
@@ -446,7 +429,7 @@ struct socket *sockfd_to_socket(unsigned int sockfd)
 
 	file = fget(sockfd);
 	if (!file) {
-		printk(KERN_ERR "%s: invalid sockfd\n", __func__);
+		pr_err("invalid sockfd\n");
 		return NULL;
 	}
 
@@ -532,8 +515,7 @@ void usbip_pack_pdu(struct usbip_header *pdu, struct urb *urb, int cmd,
 		break;
 	default:
 		/* NOT REACHED */
-		err("unknown command");
-		/* BUG(); */
+		pr_err("unknown command\n");
 		break;
 	}
 }
@@ -639,8 +621,7 @@ void usbip_header_correct_endian(struct usbip_header *pdu, int send)
 		break;
 	default:
 		/* NOT REACHED */
-		err("unknown command in pdu header: %d", cmd);
-		/* BUG(); */
+		pr_err("unknown command\n");
 		break;
 	}
 }
@@ -722,7 +703,7 @@ int usbip_recv_iso(struct usbip_device *ud, struct urb *urb)
 
 	/* my Bluetooth dongle gets ISO URBs which are np = 0 */
 	if (np == 0) {
-		/* usbip_uinfo("iso np == 0\n"); */
+		/* pr_info("iso np == 0\n"); */
 		/* usbip_dump_urb(urb); */
 		return 0;
 	}
@@ -860,8 +841,7 @@ EXPORT_SYMBOL_GPL(usbip_recv_xbuff);
 
 static int __init usbip_common_init(void)
 {
-	printk(KERN_INFO KBUILD_MODNAME ": " DRIVER_DESC " " USBIP_VERSION
-	       "\n");
+	pr_info(DRIVER_DESC " v" USBIP_VERSION "\n");
 	return 0;
 }
 
diff --git a/drivers/staging/usbip/usbip_common.h b/drivers/staging/usbip/usbip_common.h
index fd84ab2..4a641c5 100644
--- a/drivers/staging/usbip/usbip_common.h
+++ b/drivers/staging/usbip/usbip_common.h
@@ -32,25 +32,13 @@
 
 #define USBIP_VERSION "1.0.0"
 
-/**
- * usbip_udbg - print debug messages if CONFIG_USB_IP_DEBUG is defined
- * @fmt:
- * @args:
- */
-#ifdef CONFIG_USB_IP_DEBUG
-
-#define usbip_udbg(fmt, args...)					\
-	do {								\
-		printk(KERN_DEBUG "%-10s:(%s,%d) %s: " fmt,		\
-		       (in_interrupt() ? "interrupt" : (current)->comm),\
-		       __FILE__, __LINE__, __func__, ##args);		\
-	} while (0)
+#undef pr_fmt
 
+#ifdef DEBUG
+#define pr_fmt(fmt)     KBUILD_MODNAME ": %s:%d: " fmt, __func__, __LINE__
 #else
-
-#define usbip_udbg(fmt, args...)	do { } while (0)
-
-#endif /* CONFIG_USB_IP_DEBUG */
+#define pr_fmt(fmt)     KBUILD_MODNAME ": " fmt
+#endif
 
 enum {
 	usbip_debug_xmit	= (1 << 0),
@@ -85,7 +73,7 @@ extern struct device_attribute dev_attr_usbip_debug;
 #define usbip_dbg_with_flag(flag, fmt, args...)		\
 	do {						\
 		if (flag & usbip_debug_flag)		\
-			usbip_udbg(fmt , ##args);	\
+			pr_debug(fmt, ##args);		\
 	} while (0)
 
 #define usbip_dbg_sysfs(fmt, args...) \
@@ -115,28 +103,6 @@ extern struct device_attribute dev_attr_usbip_debug;
 #define usbip_dbg_stub_tx(fmt, args...) \
 	usbip_dbg_with_flag(usbip_debug_stub_tx, fmt , ##args)
 
-/**
- * usbip_uerr - print error messages
- * @fmt:
- * @args:
- */
-#define usbip_uerr(fmt, args...)					\
-	do {								\
-		printk(KERN_ERR "%-10s: ***ERROR*** (%s,%d) %s: " fmt,	\
-		       (in_interrupt() ? "interrupt" : (current)->comm),\
-		       __FILE__, __LINE__, __func__, ##args);		\
-	} while (0)
-
-/**
- * usbip_uinfo - print information messages
- * @fmt:
- * @args:
- */
-#define usbip_uinfo(fmt, args...)				\
-	do {							\
-		printk(KERN_INFO "usbip: " fmt , ## args);	\
-	} while (0)
-
 /*
  * USB/IP request headers.
  * Currently, we define 4 request types:
diff --git a/drivers/staging/usbip/usbip_event.c b/drivers/staging/usbip/usbip_event.c
index da6074d..ecd1862 100644
--- a/drivers/staging/usbip/usbip_event.c
+++ b/drivers/staging/usbip/usbip_event.c
@@ -84,8 +84,7 @@ int usbip_start_eh(struct usbip_device *ud)
 
 	ud->eh = kthread_run(event_handler_loop, ud, "usbip_eh");
 	if (IS_ERR(ud->eh)) {
-		printk(KERN_WARNING
-		       "Unable to start control thread\n");
+		pr_warning("Unable to start control thread\n");
 		return PTR_ERR(ud->eh);
 	}
 
diff --git a/drivers/staging/usbip/vhci_hcd.c b/drivers/staging/usbip/vhci_hcd.c
index 0864b27..a76e8fa 100644
--- a/drivers/staging/usbip/vhci_hcd.c
+++ b/drivers/staging/usbip/vhci_hcd.c
@@ -96,12 +96,12 @@ static void dump_port_status(u32 status)
 {
 	int i = 0;
 
-	printk(KERN_DEBUG "status %08x:", status);
+	pr_debug("status %08x:", status);
 	for (i = 0; i < 32; i++) {
 		if (status & (1 << i))
-			printk(KERN_DEBUG " %s", bit_desc[i]);
+			pr_debug(" %s", bit_desc[i]);
 	}
-	printk(KERN_DEBUG "\n");
+	pr_debug("\n");
 }
 
 void rh_port_connect(int rhport, enum usb_device_speed speed)
@@ -216,7 +216,7 @@ static int vhci_hub_status(struct usb_hcd *hcd, char *buf)
 		}
 	}
 
-	usbip_uinfo("changed %d\n", changed);
+	pr_info("changed %d\n", changed);
 
 	if (hcd->state == HC_STATE_SUSPENDED)
 		usb_hcd_resume_root_hub(hcd);
@@ -264,8 +264,7 @@ static int vhci_hub_control(struct usb_hcd *hcd, u16 typeReq, u16 wValue,
 	usbip_dbg_vhci_rh("typeReq %x wValue %x wIndex %x\n", typeReq, wValue,
 			  wIndex);
 	if (wIndex > VHCI_NPORTS)
-		printk(KERN_ERR "%s: invalid port number %d\n", __func__,
-		       wIndex);
+		pr_err("invalid port number %d\n", wIndex);
 	rhport = ((__u8)(wIndex & 0x00ff)) - 1;
 
 	dum = hcd_to_vhci(hcd);
@@ -334,8 +333,7 @@ static int vhci_hub_control(struct usb_hcd *hcd, u16 typeReq, u16 wValue,
 	case GetPortStatus:
 		usbip_dbg_vhci_rh(" GetPortStatus port %x\n", wIndex);
 		if (wIndex > VHCI_NPORTS || wIndex < 1) {
-			printk(KERN_ERR "%s: invalid port number %d\n",
-			       __func__, wIndex);
+			pr_err("invalid port number %d\n", wIndex);
 			retval = -EPIPE;
 		}
 
@@ -345,7 +343,6 @@ static int vhci_hub_control(struct usb_hcd *hcd, u16 typeReq, u16 wValue,
 		 * complete it!!
 		 *                                   */
 		if (dum->resuming && time_after(jiffies, dum->re_timeout)) {
-			printk(KERN_ERR "%s: not yet\n", __func__);
 			dum->port_status[rhport] |=
 					(1 << USB_PORT_FEAT_C_SUSPEND);
 			dum->port_status[rhport] &=
@@ -415,7 +412,6 @@ static int vhci_hub_control(struct usb_hcd *hcd, u16 typeReq, u16 wValue,
 		case USB_PORT_FEAT_SUSPEND:
 			usbip_dbg_vhci_rh(" SetPortFeature: "
 					  "USB_PORT_FEAT_SUSPEND\n");
-			printk(KERN_ERR "%s: not yet\n", __func__);
 #if 0
 			dum->port_status[rhport] |=
 				(1 << USB_PORT_FEAT_SUSPEND);
@@ -457,7 +453,7 @@ static int vhci_hub_control(struct usb_hcd *hcd, u16 typeReq, u16 wValue,
 		break;
 
 	default:
-		printk(KERN_ERR "%s: default: no such request\n", __func__);
+		pr_err("default: no such request\n");
 		/* dev_dbg (hardware,
 		 *		"hub control req%04x v%04x i%04x l%d\n",
 		 *		typeReq, wValue, wIndex, wLength); */
@@ -467,7 +463,7 @@ static int vhci_hub_control(struct usb_hcd *hcd, u16 typeReq, u16 wValue,
 	}
 
 	if (usbip_dbg_flag_vhci_rh) {
-		printk(KERN_DEBUG "port %d\n", rhport);
+		pr_debug("port %d\n", rhport);
 		dump_port_status(prev_port_status[rhport]);
 		dump_port_status(dum->port_status[rhport]);
 	}
@@ -499,7 +495,7 @@ static void vhci_tx_urb(struct urb *urb)
 	unsigned long flag;
 
 	if (!vdev) {
-		err("could not get virtual device");
+		pr_err("could not get virtual device");
 		/* BUG(); */
 		return;
 	}
@@ -517,7 +513,7 @@ static void vhci_tx_urb(struct urb *urb)
 
 	priv->seqnum = atomic_inc_return(&the_controller->seqnum);
 	if (priv->seqnum == 0xffff)
-		usbip_uinfo("seqnum max\n");
+		dev_info(&urb->dev->dev, "seqnum max\n");
 
 	priv->vdev = vdev;
 	priv->urb = urb;
@@ -558,7 +554,7 @@ static int vhci_urb_enqueue(struct usb_hcd *hcd, struct urb *urb,
 	spin_lock(&vdev->ud.lock);
 	if (vdev->ud.status == VDEV_ST_NULL ||
 	    vdev->ud.status == VDEV_ST_ERROR) {
-		usbip_uerr("enqueue for inactive port %d\n", vdev->rhport);
+		dev_err(dev, "enqueue for inactive port %d\n", vdev->rhport);
 		spin_unlock(&vdev->ud.lock);
 		spin_unlock_irqrestore(&the_controller->lock, flags);
 		return -ENODEV;
@@ -701,7 +697,7 @@ static int vhci_urb_dequeue(struct usb_hcd *hcd, struct urb *urb, int status)
 	struct vhci_priv *priv;
 	struct vhci_device *vdev;
 
-	usbip_uinfo("vhci_hcd: dequeue a urb %p\n", urb);
+	pr_info("dequeue a urb %p\n", urb);
 
 	spin_lock_irqsave(&the_controller->lock, flags);
 
@@ -731,8 +727,7 @@ static int vhci_urb_dequeue(struct usb_hcd *hcd, struct urb *urb, int status)
 
 		spin_lock_irqsave(&vdev->priv_lock, flags2);
 
-		usbip_uinfo("vhci_hcd: device %p seems to be disconnected\n",
-			    vdev);
+		pr_info("device %p seems to be disconnected\n", vdev);
 		list_del(&priv->list);
 		kfree(priv);
 		urb->hcpriv = NULL;
@@ -744,8 +739,7 @@ static int vhci_urb_dequeue(struct usb_hcd *hcd, struct urb *urb, int status)
 		 * vhci_rx will receive RET_UNLINK and give back the URB.
 		 * Otherwise, we give back it here.
 		 */
-		usbip_uinfo("vhci_hcd: vhci_urb_dequeue() gives back urb %p\n",
-			    urb);
+		pr_info("gives back urb %p\n", urb);
 
 		usb_hcd_unlink_urb_from_ep(hcd, urb);
 
@@ -764,7 +758,7 @@ static int vhci_urb_dequeue(struct usb_hcd *hcd, struct urb *urb, int status)
 		/* setup CMD_UNLINK pdu */
 		unlink = kzalloc(sizeof(struct vhci_unlink), GFP_ATOMIC);
 		if (!unlink) {
-			usbip_uerr("malloc vhci_unlink\n");
+			pr_err("malloc vhci_unlink\n");
 			spin_unlock_irqrestore(&vdev->priv_lock, flags2);
 			spin_unlock_irqrestore(&the_controller->lock, flags);
 			usbip_event_add(&vdev->ud, VDEV_EVENT_ERROR_MALLOC);
@@ -773,12 +767,11 @@ static int vhci_urb_dequeue(struct usb_hcd *hcd, struct urb *urb, int status)
 
 		unlink->seqnum = atomic_inc_return(&the_controller->seqnum);
 		if (unlink->seqnum == 0xffff)
-			usbip_uinfo("seqnum max\n");
+			pr_info("seqnum max\n");
 
 		unlink->unlink_seqnum = priv->seqnum;
 
-		usbip_uinfo("vhci_hcd: device %p seems to be still connected\n",
-			    vdev);
+		pr_info("device %p seems to be still connected\n", vdev);
 
 		/* send cmd_unlink and try to cancel the pending URB in the
 		 * peer */
@@ -801,7 +794,7 @@ static void vhci_device_unlink_cleanup(struct vhci_device *vdev)
 	spin_lock(&vdev->priv_lock);
 
 	list_for_each_entry_safe(unlink, tmp, &vdev->unlink_tx, list) {
-		usbip_uinfo("unlink cleanup tx %lu\n", unlink->unlink_seqnum);
+		pr_info("unlink cleanup tx %lu\n", unlink->unlink_seqnum);
 		list_del(&unlink->list);
 		kfree(unlink);
 	}
@@ -810,12 +803,12 @@ static void vhci_device_unlink_cleanup(struct vhci_device *vdev)
 		struct urb *urb;
 
 		/* give back URB of unanswered unlink request */
-		usbip_uinfo("unlink cleanup rx %lu\n", unlink->unlink_seqnum);
+		pr_info("unlink cleanup rx %lu\n", unlink->unlink_seqnum);
 
 		urb = pickup_urb_and_free_priv(vdev, unlink->unlink_seqnum);
 		if (!urb) {
-			usbip_uinfo("the urb (seqnum %lu) was already given "
-				    "back\n", unlink->unlink_seqnum);
+			pr_info("the urb (seqnum %lu) was already given back\n",
+				unlink->unlink_seqnum);
 			list_del(&unlink->list);
 			kfree(unlink);
 			continue;
@@ -848,7 +841,7 @@ static void vhci_shutdown_connection(struct usbip_device *ud)
 
 	/* need this? see stub_dev.c */
 	if (ud->tcp_socket) {
-		usbip_udbg("shutdown tcp_socket %p\n", ud->tcp_socket);
+		pr_debug("shutdown tcp_socket %p\n", ud->tcp_socket);
 		kernel_sock_shutdown(ud->tcp_socket, SHUT_RDWR);
 	}
 
@@ -858,14 +851,14 @@ static void vhci_shutdown_connection(struct usbip_device *ud)
 	if (vdev->ud.tcp_tx)
 		kthread_stop(vdev->ud.tcp_tx);
 
-	usbip_uinfo("stop threads\n");
+	pr_info("stop threads\n");
 
 	/* active connection is closed */
 	if (vdev->ud.tcp_socket != NULL) {
 		sock_release(vdev->ud.tcp_socket);
 		vdev->ud.tcp_socket = NULL;
 	}
-	usbip_uinfo("release socket\n");
+	pr_info("release socket\n");
 
 	vhci_device_unlink_cleanup(vdev);
 
@@ -891,7 +884,7 @@ static void vhci_shutdown_connection(struct usbip_device *ud)
 	 */
 	rh_port_disconnect(vdev->rhport);
 
-	usbip_uinfo("disconnect device\n");
+	pr_info("disconnect device\n");
 }
 
 
@@ -972,7 +965,7 @@ static int vhci_start(struct usb_hcd *hcd)
 	/* vhci_hcd is now ready to be controlled through sysfs */
 	err = sysfs_create_group(&vhci_dev(vhci)->kobj, &dev_attr_group);
 	if (err) {
-		usbip_uerr("create sysfs files\n");
+		pr_err("create sysfs files\n");
 		return err;
 	}
 
@@ -996,13 +989,11 @@ static void vhci_stop(struct usb_hcd *hcd)
 		usbip_event_add(&vdev->ud, VDEV_EVENT_REMOVED);
 		usbip_stop_eh(&vdev->ud);
 	}
-
-	usbip_uinfo("vhci_stop done\n");
 }
 
 static int vhci_get_frame_number(struct usb_hcd *hcd)
 {
-	usbip_uerr("Not yet implemented\n");
+	pr_err("Not yet implemented\n");
 	return 0;
 }
 
@@ -1079,8 +1070,6 @@ static int vhci_hcd_probe(struct platform_device *pdev)
 	struct usb_hcd		*hcd;
 	int			ret;
 
-	usbip_uinfo("proving...\n");
-
 	usbip_dbg_vhci_hc("name %s id %d\n", pdev->name, pdev->id);
 
 	/* will be removed */
@@ -1095,7 +1084,7 @@ static int vhci_hcd_probe(struct platform_device *pdev)
 	 */
 	hcd = usb_create_hcd(&vhci_hc_driver, &pdev->dev, dev_name(&pdev->dev));
 	if (!hcd) {
-		usbip_uerr("create hcd failed\n");
+		pr_err("create hcd failed\n");
 		return -ENOMEM;
 	}
 	hcd->has_tt = 1;
@@ -1109,7 +1098,7 @@ static int vhci_hcd_probe(struct platform_device *pdev)
 	 */
 	ret = usb_add_hcd(hcd, 0, 0);
 	if (ret != 0) {
-		usbip_uerr("usb_add_hcd failed %d\n", ret);
+		pr_err("usb_add_hcd failed %d\n", ret);
 		usb_put_hcd(hcd);
 		the_controller = NULL;
 		return ret;
@@ -1149,8 +1138,6 @@ static int vhci_hcd_suspend(struct platform_device *pdev, pm_message_t state)
 	int connected = 0;
 	int ret = 0;
 
-	dev_dbg(&pdev->dev, "%s\n", __func__);
-
 	hcd = platform_get_drvdata(pdev);
 
 	spin_lock(&the_controller->lock);
@@ -1163,11 +1150,11 @@ static int vhci_hcd_suspend(struct platform_device *pdev, pm_message_t state)
 	spin_unlock(&the_controller->lock);
 
 	if (connected > 0) {
-		usbip_uinfo("We have %d active connection%s. Do not suspend.\n",
-			    connected, (connected == 1 ? "" : "s"));
+		dev_info(&pdev->dev, "We have %d active connection%s. Do not "
+			 "suspend.\n", connected, (connected == 1 ? "" : "s"));
 		ret =  -EBUSY;
 	} else {
-		usbip_uinfo("suspend vhci_hcd");
+		dev_info(&pdev->dev, "suspend vhci_hcd");
 		clear_bit(HCD_FLAG_HW_ACCESSIBLE, &hcd->flags);
 	}
 
@@ -1229,13 +1216,9 @@ static int __init vhci_init(void)
 {
 	int ret;
 
-	usbip_dbg_vhci_hc("enter\n");
 	if (usb_disabled())
 		return -ENODEV;
 
-	printk(KERN_INFO KBUILD_MODNAME ": %s, %s\n", driver_name,
-	       USBIP_VERSION);
-
 	ret = platform_driver_register(&vhci_driver);
 	if (ret < 0)
 		goto err_driver_register;
@@ -1244,25 +1227,19 @@ static int __init vhci_init(void)
 	if (ret < 0)
 		goto err_platform_device_register;
 
-	usbip_dbg_vhci_hc("bye\n");
+	pr_info(DRIVER_DESC " v" USBIP_VERSION "\n");
 	return ret;
 
-	/* error occurred */
 err_platform_device_register:
 	platform_driver_unregister(&vhci_driver);
 err_driver_register:
-	usbip_dbg_vhci_hc("bye\n");
 	return ret;
 }
 
 static void __exit vhci_cleanup(void)
 {
-	usbip_dbg_vhci_hc("enter\n");
-
 	platform_device_unregister(&the_pdev);
 	platform_driver_unregister(&vhci_driver);
-
-	usbip_dbg_vhci_hc("bye\n");
 }
 
 module_init(vhci_init);
diff --git a/drivers/staging/usbip/vhci_rx.c b/drivers/staging/usbip/vhci_rx.c
index 2fe6cbf..e42ce9d 100644
--- a/drivers/staging/usbip/vhci_rx.c
+++ b/drivers/staging/usbip/vhci_rx.c
@@ -74,10 +74,9 @@ static void vhci_recv_ret_submit(struct vhci_device *vdev,
 	spin_unlock(&vdev->priv_lock);
 
 	if (!urb) {
-		usbip_uerr("cannot find a urb of seqnum %u\n",
-			   pdu->base.seqnum);
-		usbip_uinfo("max seqnum %d\n",
-			    atomic_read(&the_controller->seqnum));
+		pr_err("cannot find a urb of seqnum %u\n", pdu->base.seqnum);
+		pr_info("max seqnum %d\n",
+			atomic_read(&the_controller->seqnum));
 		usbip_event_add(ud, VDEV_EVENT_ERROR_TCP);
 		return;
 	}
@@ -121,7 +120,7 @@ static struct vhci_unlink *dequeue_pending_unlink(struct vhci_device *vdev,
 	spin_lock(&vdev->priv_lock);
 
 	list_for_each_entry_safe(unlink, tmp, &vdev->unlink_rx, list) {
-		usbip_uinfo("unlink->seqnum %lu\n", unlink->seqnum);
+		pr_info("unlink->seqnum %lu\n", unlink->seqnum);
 		if (unlink->seqnum == pdu->base.seqnum) {
 			usbip_dbg_vhci_rx("found pending unlink, %lu\n",
 					  unlink->seqnum);
@@ -147,8 +146,8 @@ static void vhci_recv_ret_unlink(struct vhci_device *vdev,
 
 	unlink = dequeue_pending_unlink(vdev, pdu);
 	if (!unlink) {
-		usbip_uinfo("cannot find the pending unlink %u\n",
-			    pdu->base.seqnum);
+		pr_info("cannot find the pending unlink %u\n",
+			pdu->base.seqnum);
 		return;
 	}
 
@@ -162,14 +161,14 @@ static void vhci_recv_ret_unlink(struct vhci_device *vdev,
 		 * already received the result of its submit result and gave
 		 * back the URB.
 		 */
-		usbip_uinfo("the urb (seqnum %d) was already given backed\n",
-			    pdu->base.seqnum);
+		pr_info("the urb (seqnum %d) was already given backed\n",
+			pdu->base.seqnum);
 	} else {
 		usbip_dbg_vhci_rx("now giveback urb %p\n", urb);
 
 		/* If unlink is succeed, status is -ECONNRESET */
 		urb->status = pdu->u.ret_unlink.status;
-		usbip_uinfo("%d\n", urb->status);
+		pr_info("urb->status %d\n", urb->status);
 
 		spin_lock(&the_controller->lock);
 		usb_hcd_unlink_urb_from_ep(vhci_to_hcd(the_controller), urb);
@@ -210,26 +209,26 @@ static void vhci_rx_pdu(struct usbip_device *ud)
 	ret = usbip_xmit(0, ud->tcp_socket, (char *) &pdu, sizeof(pdu), 0);
 	if (ret < 0) {
 		if (ret == -ECONNRESET)
-			usbip_uinfo("connection reset by peer\n");
+			pr_info("connection reset by peer\n");
 		else if (ret == -EAGAIN) {
 			/* ignore if connection was idle */
 			if (vhci_priv_tx_empty(vdev))
 				return;
-			usbip_uinfo("connection timed out with pending urbs\n");
+			pr_info("connection timed out with pending urbs\n");
 		} else if (ret != -ERESTARTSYS)
-			usbip_uinfo("xmit failed %d\n", ret);
+			pr_info("xmit failed %d\n", ret);
 
 		usbip_event_add(ud, VDEV_EVENT_ERROR_TCP);
 		return;
 	}
 	if (ret == 0) {
-		usbip_uinfo("connection closed");
+		pr_info("connection closed");
 		usbip_event_add(ud, VDEV_EVENT_DOWN);
 		return;
 	}
 	if (ret != sizeof(pdu)) {
-		usbip_uerr("received pdu size is %d, should be %d\n",
-			   ret, (unsigned int)sizeof(pdu));
+		pr_err("received pdu size is %d, should be %d\n", ret,
+		       (unsigned int)sizeof(pdu));
 		usbip_event_add(ud, VDEV_EVENT_ERROR_TCP);
 		return;
 	}
@@ -248,7 +247,7 @@ static void vhci_rx_pdu(struct usbip_device *ud)
 		break;
 	default:
 		/* NOT REACHED */
-		usbip_uerr("unknown pdu %u\n", pdu.base.command);
+		pr_err("unknown pdu %u\n", pdu.base.command);
 		usbip_dump_header(&pdu);
 		usbip_event_add(ud, VDEV_EVENT_ERROR_TCP);
 		break;
diff --git a/drivers/staging/usbip/vhci_sysfs.c b/drivers/staging/usbip/vhci_sysfs.c
index 83f61ed..d9736f9 100644
--- a/drivers/staging/usbip/vhci_sysfs.c
+++ b/drivers/staging/usbip/vhci_sysfs.c
@@ -89,7 +89,7 @@ static int vhci_port_disconnect(__u32 rhport)
 
 	spin_lock(&vdev->ud.lock);
 	if (vdev->ud.status == VDEV_ST_NULL) {
-		usbip_uerr("not connected %d\n", vdev->ud.status);
+		pr_err("not connected %d\n", vdev->ud.status);
 
 		/* unlock */
 		spin_unlock(&vdev->ud.lock);
@@ -117,7 +117,7 @@ static ssize_t store_detach(struct device *dev, struct device_attribute *attr,
 
 	/* check rhport */
 	if (rhport >= VHCI_NPORTS) {
-		usbip_uerr("invalid port %u\n", rhport);
+		dev_err(dev, "invalid port %u\n", rhport);
 		return -EINVAL;
 	}
 
@@ -136,7 +136,7 @@ static int valid_args(__u32 rhport, enum usb_device_speed speed)
 {
 	/* check rhport */
 	if ((rhport < 0) || (rhport >= VHCI_NPORTS)) {
-		usbip_uerr("port %u\n", rhport);
+		pr_err("port %u\n", rhport);
 		return -EINVAL;
 	}
 
@@ -148,7 +148,7 @@ static int valid_args(__u32 rhport, enum usb_device_speed speed)
 	case USB_SPEED_WIRELESS:
 		break;
 	default:
-		usbip_uerr("speed %d\n", speed);
+		pr_err("speed %d\n", speed);
 		return -EINVAL;
 	}
 
@@ -206,12 +206,12 @@ static ssize_t store_attach(struct device *dev, struct device_attribute *attr,
 		spin_unlock(&vdev->ud.lock);
 		spin_unlock(&the_controller->lock);
 
-		usbip_uerr("port %d already used\n", rhport);
+		dev_err(dev, "port %d already used\n", rhport);
 		return -EINVAL;
 	}
 
-	usbip_uinfo("rhport(%u) sockfd(%d) devid(%u) speed(%u)\n",
-		    rhport, sockfd, devid, speed);
+	dev_info(dev, "rhport(%u) sockfd(%d) devid(%u) speed(%u)\n",
+		 rhport, sockfd, devid, speed);
 
 	vdev->devid         = devid;
 	vdev->speed         = speed;
diff --git a/drivers/staging/usbip/vhci_tx.c b/drivers/staging/usbip/vhci_tx.c
index c1aa03b..9b437e7 100644
--- a/drivers/staging/usbip/vhci_tx.c
+++ b/drivers/staging/usbip/vhci_tx.c
@@ -118,8 +118,8 @@ static int vhci_send_cmd_submit(struct vhci_device *vdev)
 
 		ret = kernel_sendmsg(vdev->ud.tcp_socket, &msg, iov, 3, txsize);
 		if (ret != txsize) {
-			usbip_uerr("sendmsg failed!, retval %d for %zd\n", ret,
-				   txsize);
+			pr_err("sendmsg failed!, ret=%d for %zd\n", ret,
+			       txsize);
 			kfree(iso_buffer);
 			usbip_event_add(&vdev->ud, VDEV_EVENT_ERROR_TCP);
 			return -1;
@@ -188,8 +188,8 @@ static int vhci_send_cmd_unlink(struct vhci_device *vdev)
 
 		ret = kernel_sendmsg(vdev->ud.tcp_socket, &msg, iov, 1, txsize);
 		if (ret != txsize) {
-			usbip_uerr("sendmsg failed!, retval %d for %zd\n", ret,
-									txsize);
+			pr_err("sendmsg failed!, ret=%d for %zd\n", ret,
+			       txsize);
 			usbip_event_add(&vdev->ud, VDEV_EVENT_ERROR_TCP);
 			return -1;
 		}
-- 
1.7.5.1

