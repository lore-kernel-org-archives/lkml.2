Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932476Ab1ALNWH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jan 2011 08:22:07 -0500
Received: from mail.nusquama.org ([85.131.211.20]:54686 "EHLO
	mail.nusquama.org" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756198Ab1ALNVv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jan 2011 08:21:51 -0500
From: Max Vozeler <max@vozeler.com>
To: gregkh@suse.de
Cc: hirofuchi@users.sourceforge.net, rpjday@crashcourse.ca,
        bgmerrell@novell.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, mwehby@luxotticaRetail.com,
        marco@optikam.com, Max Vozeler <max@vozeler.com>
Subject: [PATCH 1/7] staging: usbip: stub: update refcounts for devices and interfaces
Date: Wed, 12 Jan 2011 15:01:59 +0200
Message-Id: <1294837325-26187-2-git-send-email-max@vozeler.com>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1294837325-26187-1-git-send-email-max@vozeler.com>
References: <1294837325-26187-1-git-send-email-max@vozeler.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The stub driver expects to access the usb interface
and usb device structures even if the device has been
disconnected in the meantime.

This change gets a reference to them in the stub probe
function using usb_get_intf()/usb_get_dev() and drops them
in the disconnect function.

This fixes an oops observed with a Logic Controls Line
display (0fa8:a030) which disconnects itself when it is
reset:

[ 1348.562274] BUG: unable to handle kernel paging request at 5f7433e5
[ 1348.562327] IP: [<c0393b02>] usb_lock_device_for_reset+0x22/0xd0
[ 1348.562374] *pde = 00000000
[ 1348.562397] Oops: 0000 [#1]
[ 1348.562418] last sysfs file: /sys/devices/pci0000:00/0000:00:10.2/usb4/4-1/bConfigurationValue
[ 1348.562454] Modules linked in: usbip vhci_hcd usbip_common_mod fbcon tileblit font bitblit softcursor serio_raw uvesafb pcspkr via_rng snd_via82xx gameport snd_ac97_codec ac97_bus snd_pcm_oss snd_mixer_oss snd_pcm snd_page_alloc snd_mpu401_uart snd_rawmidi snd_seq_oss snd_seq_midi_event snd_seq snd_timer snd_seq_device snd usbhid hid via_rhine soundcore mii igel_flash aufs pata_via
[ 1348.562649]
[ 1348.562670] Pid: 2855, comm: usbip_eh Not tainted (2.6.32 #23.37-ud-r113) M300C
[ 1348.562704] EIP: 0060:[<c0393b02>] EFLAGS: 00010216 CPU: 0
[ 1348.562734] EIP is at usb_lock_device_for_reset+0x22/0xd0
[ 1348.562762] EAX: 5f7433cd EBX: 5f7433cd ECX: de293a5c EDX: dd326a00
[ 1348.562793] ESI: 5f7433cd EDI: 000400f6 EBP: cf43ff48 ESP: cf43ff38
[ 1348.562824]  DS: 007b ES: 007b FS: 0000 GS: 00e0 SS: 0068
[ 1348.562854] Process usbip_eh (pid: 2855, ti=cf43e000 task=d2c7f230 task.ti=cf43e000)
[ 1348.562884] Stack:
[ 1348.562900]  d6ec9960 de2939cc 5f7433cd 5f743431 cf43ff70 df8fd32f de2939cc d2c7f230
[ 1348.562940] <0> cf43ff70 00000282 00000282 de2939cc d2c7f230 d2c7f230 cf43ffa8 df84416d
[ 1348.562987] <0> cf43ff88 d2c7f230 de293a24 d2c7f230 00000000 d2c7f230 c014e760 cf43ff94
[ 1348.563042] Call Trace:
[ 1348.563073]  [<df8fd32f>] ? stub_device_reset+0x3f/0x110 [usbip]
[ 1348.563114]  [<df84416d>] ? event_handler_loop+0xcd/0xe8 [usbip_common_mod]
[ 1348.563156]  [<c014e760>] ? autoremove_wake_function+0x0/0x50
[ 1348.563193]  [<df843d80>] ? usbip_thread+0x0/0x60 [usbip_common_mod]
[ 1348.563230]  [<df843dd1>] ? usbip_thread+0x51/0x60 [usbip_common_mod]
[ 1348.563265]  [<c014e374>] ? kthread+0x74/0x80
[ 1348.563294]  [<c014e300>] ? kthread+0x0/0x80
[ 1348.563326]  [<c0103c47>] ? kernel_thread_helper+0x7/0x10
[ 1348.563351] Code: 00 e8 73 4d 00 00 5d c3 90 55 89 e5 83 ec 10 89 5d f4 89 75 f8 89 7d fc 0f 1f 44 00 00 8b 3d c0 2e 67 c0 81 c7 fa 00 00 00 89 c3 <8b> 40 18 89 d6 85 c0 75 15 b8 ed ff ff ff 8b 5d f4 8b 75 f8 8b
[ 1348.563528] EIP: [<c0393b02>] usb_lock_device_for_reset+0x22/0xd0 SS:ESP 0068:cf43ff38
[ 1348.563570] CR2: 000000005f7433e5
[ 1348.563593] ---[ end trace 9c3f1e3a2e5299d9 ]---

Signed-off-by: Max Vozeler <max@vozeler.com>
Tested-by: Mark Wehby <MWehby@luxotticaRetail.com>
Tested-by: Steven Harms <sharms@luxotticaRetail.com>
---
 drivers/staging/usbip/stub.h     |    1 +
 drivers/staging/usbip/stub_dev.c |   18 ++++++++++++++----
 drivers/staging/usbip/stub_rx.c  |    4 ++--
 3 files changed, 17 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/usbip/stub.h b/drivers/staging/usbip/stub.h
index 30dbfb6..d732679 100644
--- a/drivers/staging/usbip/stub.h
+++ b/drivers/staging/usbip/stub.h
@@ -32,6 +32,7 @@
 
 struct stub_device {
 	struct usb_interface *interface;
+	struct usb_device *udev;
 	struct list_head list;
 
 	struct usbip_device ud;
diff --git a/drivers/staging/usbip/stub_dev.c b/drivers/staging/usbip/stub_dev.c
index b186b5f..a7ce51c 100644
--- a/drivers/staging/usbip/stub_dev.c
+++ b/drivers/staging/usbip/stub_dev.c
@@ -258,10 +258,11 @@ static void stub_shutdown_connection(struct usbip_device *ud)
 static void stub_device_reset(struct usbip_device *ud)
 {
 	struct stub_device *sdev = container_of(ud, struct stub_device, ud);
-	struct usb_device *udev = interface_to_usbdev(sdev->interface);
+	struct usb_device *udev = sdev->udev;
 	int ret;
 
 	usbip_udbg("device reset");
+
 	ret = usb_lock_device_for_reset(udev, sdev->interface);
 	if (ret < 0) {
 		dev_err(&udev->dev, "lock for reset\n");
@@ -309,7 +310,8 @@ static void stub_device_unusable(struct usbip_device *ud)
  *
  * Allocates and initializes a new stub_device struct.
  */
-static struct stub_device *stub_device_alloc(struct usb_interface *interface)
+static struct stub_device *stub_device_alloc(struct usb_device *udev,
+					     struct usb_interface *interface)
 {
 	struct stub_device *sdev;
 	int busnum = interface_to_busnum(interface);
@@ -324,7 +326,8 @@ static struct stub_device *stub_device_alloc(struct usb_interface *interface)
 		return NULL;
 	}
 
-	sdev->interface = interface;
+	sdev->interface = usb_get_intf(interface);
+	sdev->udev = usb_get_dev(udev);
 
 	/*
 	 * devid is defined with devnum when this driver is first allocated.
@@ -450,11 +453,12 @@ static int stub_probe(struct usb_interface *interface,
 			return err;
 		}
 
+		usb_get_intf(interface);
 		return 0;
 	}
 
 	/* ok. this is my device. */
-	sdev = stub_device_alloc(interface);
+	sdev = stub_device_alloc(udev, interface);
 	if (!sdev)
 		return -ENOMEM;
 
@@ -476,6 +480,8 @@ static int stub_probe(struct usb_interface *interface,
 		dev_err(&interface->dev, "create sysfs files for %s\n",
 			udev_busid);
 		usb_set_intfdata(interface, NULL);
+		usb_put_intf(interface);
+
 		busid_priv->interf_count = 0;
 
 		busid_priv->sdev = NULL;
@@ -545,6 +551,7 @@ static void stub_disconnect(struct usb_interface *interface)
 	if (busid_priv->interf_count > 1) {
 		busid_priv->interf_count--;
 		shutdown_busid(busid_priv);
+		usb_put_intf(interface);
 		return;
 	}
 
@@ -554,6 +561,9 @@ static void stub_disconnect(struct usb_interface *interface)
 	/* 1. shutdown the current connection */
 	shutdown_busid(busid_priv);
 
+	usb_put_dev(sdev->udev);
+	usb_put_intf(interface);
+
 	/* 3. free sdev */
 	busid_priv->sdev = NULL;
 	stub_device_free(sdev);
diff --git a/drivers/staging/usbip/stub_rx.c b/drivers/staging/usbip/stub_rx.c
index 3de6fd2..ae6ac82 100644
--- a/drivers/staging/usbip/stub_rx.c
+++ b/drivers/staging/usbip/stub_rx.c
@@ -364,7 +364,7 @@ static struct stub_priv *stub_priv_alloc(struct stub_device *sdev,
 
 static int get_pipe(struct stub_device *sdev, int epnum, int dir)
 {
-	struct usb_device *udev = interface_to_usbdev(sdev->interface);
+	struct usb_device *udev = sdev->udev;
 	struct usb_host_endpoint *ep;
 	struct usb_endpoint_descriptor *epd = NULL;
 
@@ -484,7 +484,7 @@ static void stub_recv_cmd_submit(struct stub_device *sdev,
 	int ret;
 	struct stub_priv *priv;
 	struct usbip_device *ud = &sdev->ud;
-	struct usb_device *udev = interface_to_usbdev(sdev->interface);
+	struct usb_device *udev = sdev->udev;
 	int pipe = get_pipe(sdev, pdu->base.ep, pdu->base.direction);
 
 
-- 
1.7.2.3

