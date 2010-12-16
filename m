Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752578Ab0LPW5S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 17:57:18 -0500
Received: from [80.69.43.34] ([80.69.43.34]:40158 "EHLO imap.vp5.hinterhof.net"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751608Ab0LPW5R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 17:57:17 -0500
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Thu, 16 Dec 2010 17:57:17 EST
Message-ID: <4D0A97B3.2090701@vozeler.com>
Date: Thu, 16 Dec 2010 23:50:27 +0100
From: Max Vozeler <max@vozeler.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101110 Icedove/3.1.6
MIME-Version: 1.0
To: =?UTF-8?B?TsOpbWV0aCBNw6FydG9u?= <nm127@freemail.hu>
CC: gregkh <gregkh@suse.de>, devel@driverdev.osuosl.org,
        LKML <linux-kernel@vger.kernel.org>, usbip-devel@lists.sourceforge.net
Subject: Re: usbip: somtimes stalls at kernel_recvmsg()
References: <4D06A004.8070502@freemail.hu> <4D09C056.5020305@freemail.hu>
In-Reply-To: <4D09C056.5020305@freemail.hu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Németh,

On 16.12.2010 08:31, Németh Márton wrote:
> Németh Márton wrote:
>> I'm working with usbip and I sometimes see a stall when I run
>> the "lsusb" command from the userspace. 

Does it eventually recover?

>> I added some debug messages
>> and it seems that the kernel_recvmsg() in
>> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=blob;f=drivers/staging/usbip/usbip_common.c;h=210ef16bab8d271a52e5d36cd1994aad57ad99e1;hb=HEAD
>>
>> This is the only place I could find where the TCP messages are arriving in
>> the usbip code.
>>
>> What happens if a message does not arrive? Does it stall forever? 

Yes, it will block until detached or until a TCP
timeout or error closes the connection.

The TCP timeout can take several minutes.

>> yes, how can the kernel_recvmsg() call changed to handle some timeout?
> 
> I found that the userspace manpage of recvmsg(2) ("man recvmsg") contains description
> of the "flags" parameter. I suppose the parameters and behaviour of the userspace
> recvmsg() is the same as the kernelspace kernel_recvmsg().

I recently faced this problem, too.

The solution I arrived at was to set SO_RCVTIMEO
and SO_SNDTIMEO socket opts in the tools together
with the patch below.

The patch works around a lack of heart-beat in 
the usbip protocol which would otherwise make idle
connections time out.

(It wont apply cleanly but hopefully conveys the idea.).

Extending the protocol for a heart-beat message
doesn't seem to be possible without breaking the
compatibility at the same time.

I was planning to submit it on the weekend along 
with the tool changes to set the timeouts. 

	Max

---
From: Max Vozeler <max@vozeler.com>
Date: Mon, 13 Dec 2010 00:39:14 +0100
Subject: [PATCH 1/3] vhci: allow SO_RCVTIMEO on the socket

In case of unanswered replies, a receive timeout is
considered a connection error and the device will be
shut down and removed.

This is a workaround for the lack of heart-beat
messages in the USBIP protocol. It allows userspace
to set a maximum latency for the connection.
---
 vhci_rx.c |   21 ++++++++++++++++++++-
 1 files changed, 20 insertions(+), 1 deletions(-)

diff --git a/vhci_rx.c b/vhci_rx.c
index bc16dc4..9a1fe80 100644
--- a/vhci_rx.c
+++ b/vhci_rx.c
@@ -197,6 +197,19 @@ static void vhci_recv_ret_unlink(struct vhci_device *vdev,
 	return;
 }
 
+static int vhci_priv_tx_empty(struct vhci_device *vdev)
+{
+	int empty = 0;
+
+	spin_lock(&vdev->priv_lock);
+
+	empty = list_empty(&vdev->priv_rx);
+
+	spin_unlock(&vdev->priv_lock);
+
+	return empty;
+}
+
 /* recv a pdu */
 static void vhci_rx_pdu(struct usbip_device *ud)
 {
@@ -216,8 +229,14 @@ static void vhci_rx_pdu(struct usbip_device *ud)
 			usbip_uinfo("connection reset by peer\n");
 		else if (ret == -ETIMEDOUT)
 			usbip_uinfo("connection timed out\n");
-		else if (ret != -ERESTARTSYS)
+		else if (ret == -EAGAIN) {
+			/* connection was idle? */
+			if (vhci_priv_tx_empty(vdev))
+				return;
+			usbip_uinfo("connection timed out with pending urbs\n");
+		} else if (ret != -ERESTARTSYS)
 			usbip_uinfo("xmit failed %d\n", ret);
+
 		usbip_event_add(ud, VDEV_EVENT_ERROR_TCP);
 		return;
 	}
-- 
1.7.2.3

