Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756570Ab0ITPK6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Sep 2010 11:10:58 -0400
Received: from cantor.suse.de ([195.135.220.2]:47810 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752008Ab0ITPK4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Sep 2010 11:10:56 -0400
Date: Mon, 20 Sep 2010 17:10:52 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Mat <jackdachef@gmail.com>
Cc: Guillaume Chazarain <guichaz@gmail.com>, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Alan Stern <stern@rowland.harvard.edu>,
        Oliver Neukum <oliver@neukum.org>, Alan Ott <alan@signal11.us>,
        linux-usb@vger.kernel.org, linux-input@vger.kernel.org,
        Andreas Bombe <aeb@debian.org>, Alex Riesen <raa.lkml@gmail.com>,
        Phil Turmel <philip@turmel.org>
Subject: Re: [BUG, Regression, bisected] USB mouse causes bug on 1st insert,
 ignored on 2nd insert, lsusb stuck at usbdev_open
In-Reply-To: <AANLkTim6PBGEBz8_PVpK2YajgtejsbAgL11i+DMN-7jh@mail.gmail.com>
Message-ID: <alpine.LNX.2.00.1009201708340.26813@pobox.suse.cz>
References: <4C96B9DB.8030403@turmel.org> <AANLkTi=1zh4hD-1uzpgjAsnKZBE=qi_ZAX-ug=2XMkW0@mail.gmail.com> <alpine.LNX.2.00.1009201440140.26813@pobox.suse.cz> <4C975F79.9060609@turmel.org> <alpine.LNX.2.00.1009201524340.26813@pobox.suse.cz>
 <AANLkTim6PBGEBz8_PVpK2YajgtejsbAgL11i+DMN-7jh@mail.gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 20 Sep 2010, Mat wrote:

> >> >>> The USB mouse I use with my laptop is causing a BUG when inserted.  It works at that
> >> >>> point, but if removed and re-inserted, it is ignored.  Also, after the 2nd insert,
> >> >>> other USB devices (like my thumb drive) are also ignored.
> >> >>>
> >> >>> [   37.450777] BUG: unable to handle kernel NULL pointer dereference at (null)
> >> >>> [   37.451148] IP: [<ffffffff817d0991>] hiddev_open+0xc1/0x220
> >> >>> [   37.452036] PGD 1131a0067 PUD 113036067 PMD 0
> >> >>> [   37.452924] Oops: 0000 [#1] PREEMPT SMP
> >> >>> [   37.453336] last sysfs file: /sys/devices/platform/toshiba_acpi/backlight/toshiba/max_brightness
> >> >>> [   37.453336] CPU 1
> >> >>> [   37.453336] Modules linked in: tpm_infineon iwlagn iwlcore tifm_7xx1 tpm_tis toshiba_bluetooth toshiba_acpi tifm_core pcmcia sdhci_pci yenta_socket sdhci [last unloaded: scsi_wait_scan]
> >> >>> [   37.453336]
> >> >>> [   37.453336] Pid: 3117, comm: hald-probe-hidd Not tainted 2.6.36-rc4-00166-g151b6a5 #28 Portable PC/TECRA A9
> >> >>> [   37.453336] RIP: 0010:[<ffffffff817d0991>]  [<ffffffff817d0991>] hiddev_open+0xc1/0x220
> >> >
> >> > Could please those of you who are able to reproduce the problem (from a
> >> > quick test seems that I am not) use 'addr2line' utility to convert the RIP
> >> > value (ffffffff817d0991 in this case) to the line number inside of
> >> > hiddev_open(), so that we can see whether it's something behind
> >> > usbhid_find_interface() causing NULL pointer dereference, or whether it is
> >> > intfdata being NULL and thus going to hid->hiddev faults?
> 
> [snip]
> 
> hope that's the information you need - I rebuilt a debug-kernel so if
> you need more information, just ask:
> 
> 
> ls -l /usr/src/linux-2.6.36-rc4_hiddev/vmlinux
> -rwxrwx--- 1 root root 174167283 Sep 20 15:17
> /usr/src/linux-2.6.36-rc4_hiddev/vmlinux
> wolf ~ # addr2line -e /usr/src/linux-2.6.36-rc4_hiddev/vmlinux -i
> ffffffff815a0815
> /usr/src/linux/drivers/hid/usbhid/hiddev.c:289
> 
> the relevant line is marked "==>	if (list->hiddev->exist) {"

Thanks Matt and Phill for confirming the line that triggers the oops. As I 
am not able to reproduce it myself, it's a bit tricky to track down what 
went wrong.

Could you please apply the patch below? It's printing the hid <-> hiddev 
<-> usb_interface connections at various stages of probing and open. 
Hopefully it'll reveal a little bit what goes wrong and where.

Thanks.


diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
index 3f72924..3159a63 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -1155,6 +1155,8 @@ int hid_connect(struct hid_device *hdev, unsigned int connect_mask)
 	unsigned int i;
 	int len;
 
+	printk("HID debug: hid_connect() -- hid: %p\n", hdev);
+
 	if (hdev->quirks & HID_QUIRK_HIDDEV_FORCE)
 		connect_mask |= (HID_CONNECT_HIDDEV_FORCE | HID_CONNECT_HIDDEV);
 	if (hdev->quirks & HID_QUIRK_HIDINPUT_FORCE)
@@ -1169,8 +1171,11 @@ int hid_connect(struct hid_device *hdev, unsigned int connect_mask)
 		hdev->claimed |= HID_CLAIMED_INPUT;
 	if ((connect_mask & HID_CONNECT_HIDDEV) && hdev->hiddev_connect &&
 			!hdev->hiddev_connect(hdev,
-				connect_mask & HID_CONNECT_HIDDEV_FORCE))
+				connect_mask & HID_CONNECT_HIDDEV_FORCE)) {
 		hdev->claimed |= HID_CLAIMED_HIDDEV;
+		printk("HID debug: hid_connect() -- after hiddev_connect(), hid: %p, hiddev: %p\n",
+				hdev, hdev->hiddev);
+	}
 	if ((connect_mask & HID_CONNECT_HIDRAW) && !hidraw_connect(hdev))
 		hdev->claimed |= HID_CLAIMED_HIDRAW;
 
diff --git a/drivers/hid/usbhid/hid-core.c b/drivers/hid/usbhid/hid-core.c
index 599041a..d2491a1 100644
--- a/drivers/hid/usbhid/hid-core.c
+++ b/drivers/hid/usbhid/hid-core.c
@@ -1148,6 +1148,7 @@ static int usbhid_probe(struct usb_interface *intf, const struct usb_device_id *
 	if (IS_ERR(hid))
 		return PTR_ERR(hid);
 
+	printk("HID debug: usbhid_probe() -- set intfdata(%p, %p)\n", intf, hid);
 	usb_set_intfdata(intf, hid);
 	hid->ll_driver = &usb_hid_driver;
 	hid->hid_output_raw_report = usbhid_output_raw_report;
diff --git a/drivers/hid/usbhid/hiddev.c b/drivers/hid/usbhid/hiddev.c
index 681e620..9aab39a 100644
--- a/drivers/hid/usbhid/hiddev.c
+++ b/drivers/hid/usbhid/hiddev.c
@@ -282,6 +282,8 @@ static int hiddev_open(struct inode *inode, struct file *file)
 	list->hiddev = hiddev;
 	file->private_data = list;
 
+	printk("HID debug: hiddev_open(): hid: %p, hiddev: %p, intf: %p\n",
+			hid, hiddev, intf);
 	/*
 	 * no need for locking because the USB major number
 	 * is shared which usbcore guards against disconnect
@@ -892,6 +894,8 @@ int hiddev_connect(struct hid_device *hid, unsigned int force)
 	hid->hiddev = hiddev;
 	hiddev->hid = hid;
 	hiddev->exist = 1;
+	printk("HID debug: hiddev_connect() -- hid: %p, hiddev: %p, intf: %p\n",
+			hid, hiddev, usbhid->intf);
 	retval = usb_register_dev(usbhid->intf, &hiddev_class);
 	if (retval) {
 		err_hid("Not able to get a minor for this device.");
@@ -912,6 +916,8 @@ void hiddev_disconnect(struct hid_device *hid)
 	struct hiddev *hiddev = hid->hiddev;
 	struct usbhid_device *usbhid = hid->driver_data;
 
+	printk("HID debug: hiddev_disconnect() -- hid: %p, usbhid: %p, hiddev: %p\n",
+			hid, usbhid, hiddev);
 	mutex_lock(&hiddev->existancelock);
 	hiddev->exist = 0;
 	mutex_unlock(&hiddev->existancelock);

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
