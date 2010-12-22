Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751937Ab0LVTuE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Dec 2010 14:50:04 -0500
Received: from relay01.digicable.hu ([92.249.128.189]:48062 "EHLO
	relay01.digicable.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751187Ab0LVTuB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Dec 2010 14:50:01 -0500
Message-ID: <4D125663.3070104@freemail.hu>
Date: Wed, 22 Dec 2010 20:49:55 +0100
From: =?UTF-8?B?TsOpbWV0aCBNw6FydG9u?= <nm127@freemail.hu>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; hu-HU; rv:1.8.1.21) Gecko/20090402 SeaMonkey/1.1.16
MIME-Version: 1.0
To: Max Vozeler <max@vozeler.com>
CC: gregkh <gregkh@suse.de>, devel@driverdev.osuosl.org,
        LKML <linux-kernel@vger.kernel.org>, usbip-devel@lists.sourceforge.net
Subject: Re: usbip: sometimes stalls at kernel_recvmsg()
References: <4D06A004.8070502@freemail.hu> <4D09C056.5020305@freemail.hu> <4D0A97B3.2090701@vozeler.com> <4D0AF910.8070202@freemail.hu> <4D0FD725.5000609@vozeler.com> <4D105F3F.5070702@freemail.hu>
In-Reply-To: <4D105F3F.5070702@freemail.hu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Original: 92.249.250.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Németh Márton wrote:
> Hello Max,
> Max Vozeler wrote:
>> Hi Németh,
>>
>> On 17.12.2010 06:45, Németh Márton wrote:
>>>>> Németh Márton wrote:
>>>>>> I'm working with usbip and I sometimes see a stall when I run
>>>>>> the "lsusb" command from the userspace. 
>>>> Does it eventually recover?
>>> No, it doesn't. After 120 seconds messages are printed in dmesg
>>> that the "lsusb" process is blocked more than 120 seconds.
>> Can you describe the sequence of events which
>> happened before the hang?
> 
> Boot EeePC 901. Attach hama AC-150 webcam. Execute the following
> commands as root:
> 
> echo 0 >/sys/devices/platform/eeepc/camera
> insmod /usr/src/linux/drivers/staging/usbip/usbip_common_mod.ko
> insmod /usr/src/linux/drivers/staging/usbip/usbip.ko
> usbip_bind_driver --list
> usbip_bind_driver --usbip 3-2
> usbipd
> 
> On a second xterm window execute the following commands:
> insmod /usr/src/linux/drivers/staging/usbip/vhci-hcd.ko
> lsusb
> usbip --list localhost
> usbip -a localhost 3-2
> usbip -p
> strace lsusb
> 
> Note that the hama AC-150 webcam has a snapshot button on it which
> uses the interrupt endpoint. The interrupt URB is sent in when the
> gspca_sonixj driver activates in order to catch the button events.
> The hang maybe related, I don't know.
> 
>> Was the device detached before or during lsusb?
>>
>> Perhaps try echo t > /proc/sysrq-trigger to see
>> where exactly lsusb gets stuck.
>>
>> I found processes can get stuck in usb_kill_urb 
>> if they tried to unlink an URB, but the unlink
>> request was not answered before detach.
>>
>> Perhaps this is related. I am attaching a patch
>> which fixes that bug for me, perhaps you could 
>> try if it makes a difference?
> 
> I'll try your patch later, thanks.

I have tried your patch with a little modification to access
the symbol pickup_urb_and_free_priv, for details see the patch
later in this mail.

Unfortunately "strace lsusb" still freezes. The last line shown
by strace is:

open("/dev/bus/usb/006/001", O_RDWR

where 006 is the bus ID of the virtual USB bus, the 001 is the attached
virtual USB device.

At this time the list of virtual USB port status is as follows:

# usbip -p
8 ports available

Port 00: <Port Initializing>
Port 01: <Port Available>
Port 02: <Port Available>
Port 03: <Port Available>
Port 04: <Port Available>
Port 05: <Port Available>
Port 06: <Port Available>
Port 07: <Port Available>


	Márton Németh

---
diff -upr linux-2.6.37-rc5-orig/drivers/staging/usbip/vhci_hcd.c linux-2.6.37-rc5/drivers/staging/usbip/vhci_hcd.c
--- linux-2.6.37-rc5-orig/drivers/staging/usbip/vhci_hcd.c	2010-12-14 20:17:16.000000000 +0100
+++ linux-2.6.37-rc5/drivers/staging/usbip/vhci_hcd.c	2010-12-22 20:12:21.000000000 +0100
@@ -805,6 +805,8 @@ static int vhci_urb_dequeue(struct usb_h
 	return 0;
 }

+struct urb *pickup_urb_and_free_priv(struct vhci_device *vdev,
+					    __u32 seqnum);

 static void vhci_device_unlink_cleanup(struct vhci_device *vdev)
 {
@@ -813,11 +815,34 @@ static void vhci_device_unlink_cleanup(s
 	spin_lock(&vdev->priv_lock);

 	list_for_each_entry_safe(unlink, tmp, &vdev->unlink_tx, list) {
+		usbip_uinfo("unlink cleanup tx %lu\n", unlink->unlink_seqnum);
 		list_del(&unlink->list);
 		kfree(unlink);
 	}

 	list_for_each_entry_safe(unlink, tmp, &vdev->unlink_rx, list) {
+		struct urb *urb;
+
+		/* give back URB of unanswered unlink request */
+		usbip_uinfo("unlink cleanup rx %lu\n", unlink->unlink_seqnum);
+
+		urb = pickup_urb_and_free_priv(vdev, unlink->unlink_seqnum);
+		if (!urb) {
+			usbip_uinfo("the urb (seqnum %lu) was already given back\n",
+							unlink->unlink_seqnum);
+			list_del(&unlink->list);
+			kfree(unlink);
+			continue;
+		}
+
+		urb->status = -ENODEV;
+
+		spin_lock(&the_controller->lock);
+		usb_hcd_unlink_urb_from_ep(vhci_to_hcd(the_controller), urb);
+		spin_unlock(&the_controller->lock);
+
+		usb_hcd_giveback_urb(vhci_to_hcd(the_controller), urb, urb->status);
+
 		list_del(&unlink->list);
 		kfree(unlink);
 	}
diff -upr linux-2.6.37-rc5-orig/drivers/staging/usbip/vhci_rx.c linux-2.6.37-rc5/drivers/staging/usbip/vhci_rx.c
--- linux-2.6.37-rc5-orig/drivers/staging/usbip/vhci_rx.c	2010-10-20 22:30:22.000000000 +0200
+++ linux-2.6.37-rc5/drivers/staging/usbip/vhci_rx.c	2010-12-22 20:12:05.000000000 +0100
@@ -24,7 +24,7 @@


 /* get URB from transmitted urb queue */
-static struct urb *pickup_urb_and_free_priv(struct vhci_device *vdev,
+struct urb *pickup_urb_and_free_priv(struct vhci_device *vdev,
 					    __u32 seqnum)
 {
 	struct vhci_priv *priv, *tmp;

