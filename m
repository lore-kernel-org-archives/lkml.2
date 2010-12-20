Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933286Ab0LTWWe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Dec 2010 17:22:34 -0500
Received: from [80.69.43.34] ([80.69.43.34]:51399 "EHLO imap.vp5.hinterhof.net"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1758233Ab0LTWWc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Dec 2010 17:22:32 -0500
Message-ID: <4D0FD725.5000609@vozeler.com>
Date: Mon, 20 Dec 2010 23:22:29 +0100
From: Max Vozeler <max@vozeler.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101110 Icedove/3.1.6
MIME-Version: 1.0
To: =?UTF-8?B?TsOpbWV0aCBNw6FydG9u?= <nm127@freemail.hu>
CC: gregkh <gregkh@suse.de>, devel@driverdev.osuosl.org,
        LKML <linux-kernel@vger.kernel.org>, usbip-devel@lists.sourceforge.net
Subject: Re: usbip: sometimes stalls at kernel_recvmsg()
References: <4D06A004.8070502@freemail.hu> <4D09C056.5020305@freemail.hu> <4D0A97B3.2090701@vozeler.com> <4D0AF910.8070202@freemail.hu>
In-Reply-To: <4D0AF910.8070202@freemail.hu>
Content-Type: multipart/mixed;
 boundary="------------090403030201020102040108"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------090403030201020102040108
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hi Németh,

On 17.12.2010 06:45, Németh Márton wrote:
>>> Németh Márton wrote:
>>>> I'm working with usbip and I sometimes see a stall when I run
>>>> the "lsusb" command from the userspace. 
>>
>> Does it eventually recover?
> 
> No, it doesn't. After 120 seconds messages are printed in dmesg
> that the "lsusb" process is blocked more than 120 seconds.

Can you describe the sequence of events which
happened before the hang?

Was the device detached before or during lsusb?

Perhaps try echo t > /proc/sysrq-trigger to see
where exactly lsusb gets stuck.

I found processes can get stuck in usb_kill_urb 
if they tried to unlink an URB, but the unlink
request was not answered before detach.

Perhaps this is related. I am attaching a patch
which fixes that bug for me, perhaps you could 
try if it makes a difference?

>>>> I added some debug messages
>>>> and it seems that the kernel_recvmsg() in
>>>> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=blob;f=drivers/staging/usbip/usbip_common.c;h=210ef16bab8d271a52e5d36cd1994aad57ad99e1;hb=HEAD
>>>>
>>>> This is the only place I could find where the TCP messages are arriving in
>>>> the usbip code.
>>>>
>>>> What happens if a message does not arrive? Does it stall forever? 
>>
>> Yes, it will block until detached or until a TCP
>> timeout or error closes the connection.
>>
>> The TCP timeout can take several minutes.
> 
> What I don't really understand is that how is it possible that
> a packet from TCP communication is lost? TCP resends the lost
> packets automatically. In my case I run both the usbip server
> and client on the same machine using the host name "localhost".
> So I assume that there might be a protocol handshake problem
> here.

Agreed, it doesn't seem like a TCP error is 
causing the hang in this case.

	Max

-- 
Max Vozeler - Open Source Consulting and Development, http://vozeler.com
Post address: Max Vozeler, Lauteschlaegerstr. 8, 64289 Darmstadt, Germany
Phone: +49-6151-608186-0, Fax: +49-6151-608186-9, Mobile: +49-176-62450045
OpenPGP: 4096R/A3DBC803 - E37CFDA9A29DFF71E1D5 47A679F30022A3DBC803

--------------090403030201020102040108
Content-Type: text/x-patch;
 name="0001-vhci-give-back-URBs-from-in-flight-unlink-requests.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0001-vhci-give-back-URBs-from-in-flight-unlink-requests.patc";
 filename*1="h"

>From 7ea54034c1d477f17ccc799d23eb3cf837a0475d Mon Sep 17 00:00:00 2001
From: Max Vozeler <max@vozeler.com>
Date: Sun, 12 Dec 2010 18:43:38 +0100
Subject: [PATCH 01/10] vhci: give back URBs from in-flight unlink requests

If we never received a RET_UNLINK because the TCP
connection broke the pending URBs still need to be
unlinked and given back.

Previously processes would be stuck trying to kill
the URB even after the device was detached.
---
 vhci_hcd.c |   24 +++++++++++++++++++++++-
 1 files changed, 23 insertions(+), 1 deletions(-)

diff --git a/vhci_hcd.c b/vhci_hcd.c
index d83adbc..4b4c8a9 100644
--- a/vhci_hcd.c
+++ b/vhci_hcd.c
@@ -815,7 +815,6 @@ static int vhci_urb_dequeue(struct usb_hcd *hcd, struct urb *urb, int status)
 	return 0;
 }
 
-
 static void vhci_device_unlink_cleanup(struct vhci_device *vdev)
 {
 	struct vhci_unlink *unlink, *tmp;
@@ -823,11 +822,34 @@ static void vhci_device_unlink_cleanup(struct vhci_device *vdev)
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
-- 
1.7.2.3


--------------090403030201020102040108--
