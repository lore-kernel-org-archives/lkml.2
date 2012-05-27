Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933498Ab2E0BKw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2012 21:10:52 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:54259 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965232Ab2E0BKn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2012 21:10:43 -0400
Message-Id: <20120527010432.238781465@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Sun, 27 May 2012 10:05:23 +0900
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Hans de Goede <hdegoede@redhat.com>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>
Subject: [ 60/94] usb-xhci: Handle COMP_TX_ERR for isoc tds
In-Reply-To: <20120527010332.GA11170@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans de Goede <hdegoede@redhat.com>

commit 9c745995ae5c4ff787f34a359de908facc11ee00 upstream.

While testing unplugging an UVC HD webcam with usb-redirection (so through
usbdevfs), my userspace usb-redir code was getting a value of -1 in
iso_frame_desc[n].status, which according to Documentation/usb/error-codes.txt
is not a valid value.

The source of this -1 is the default case in xhci-ring.c:process_isoc_td()
adding a kprintf there showed the value of trb_comp_code to be COMP_TX_ERR
in this case, so this patch adds handling for that completion code to
process_isoc_td().

This was observed and tested with the following xhci controller:
1033:0194 NEC Corporation uPD720200 USB 3.0 Host Controller (rev 04)

Note: I also wonder if setting frame->status to -1 (-EPERM) is the best we can
do, but since I cannot come up with anything better I've left that as is.

This patch should be backported to kernels as old as 2.6.36, which contain the
commit 04e51901dd44f40a5a385ced897f6bca87d5f40a "USB: xHCI: Isochronous
transfer implementation".

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/host/xhci-ring.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/usb/host/xhci-ring.c
+++ b/drivers/usb/host/xhci-ring.c
@@ -1739,6 +1739,7 @@ static int process_isoc_td(struct xhci_h
 		break;
 	case COMP_DEV_ERR:
 	case COMP_STALL:
+	case COMP_TX_ERR:
 		frame->status = -EPROTO;
 		skip_td = true;
 		break;


