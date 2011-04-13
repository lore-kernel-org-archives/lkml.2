Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932868Ab1DMQ2R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 12:28:17 -0400
Received: from kroah.org ([198.145.64.141]:52760 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932758Ab1DMQMp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 12:12:45 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Apr 13 09:10:44 2011
Message-Id: <20110413161043.915106145@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 13 Apr 2011 09:09:37 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Arjan Mels <arjan.mels@gmx.net>,
        Takahiro Hirofuchi <hirofuchi@users.sourceforge.net>,
        Max Vozeler <max@vozeler.com>
Subject: [14/71] staging: usbip: bugfix add number of packets for isochronous frames
In-Reply-To: <20110413161106.GA20405@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Arjan Mels <arjan.mels@gmx.net>

commit 1325f85fa49f57df034869de430f7c302ae23109 upstream.

The number_of_packets was not transmitted for RET_SUBMIT packets. The
linux client used the stored number_of_packet from the submitted
request. The windows userland client does not do this however and needs
to know the number_of_packets to determine the size of the transmission.

Signed-off-by: Arjan Mels <arjan.mels@gmx.net>
Cc: Takahiro Hirofuchi <hirofuchi@users.sourceforge.net>
Cc: Max Vozeler <max@vozeler.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/staging/usbip/usbip_common.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/drivers/staging/usbip/usbip_common.c
+++ b/drivers/staging/usbip/usbip_common.c
@@ -361,10 +361,11 @@ void usbip_dump_header(struct usbip_head
 		usbip_udbg("CMD_UNLINK: seq %u\n", pdu->u.cmd_unlink.seqnum);
 		break;
 	case USBIP_RET_SUBMIT:
-		usbip_udbg("RET_SUBMIT: st %d al %u sf %d ec %d\n",
+		usbip_udbg("RET_SUBMIT: st %d al %u sf %d #p %d ec %d\n",
 				pdu->u.ret_submit.status,
 				pdu->u.ret_submit.actual_length,
 				pdu->u.ret_submit.start_frame,
+				pdu->u.ret_submit.number_of_packets,
 				pdu->u.ret_submit.error_count);
 	case USBIP_RET_UNLINK:
 		usbip_udbg("RET_UNLINK: status %d\n", pdu->u.ret_unlink.status);
@@ -686,6 +687,7 @@ static void usbip_pack_ret_submit(struct
 		rpdu->status		= urb->status;
 		rpdu->actual_length	= urb->actual_length;
 		rpdu->start_frame	= urb->start_frame;
+		rpdu->number_of_packets = urb->number_of_packets;
 		rpdu->error_count	= urb->error_count;
 	} else {
 		/* vhci_rx.c */
@@ -693,6 +695,7 @@ static void usbip_pack_ret_submit(struct
 		urb->status		= rpdu->status;
 		urb->actual_length	= rpdu->actual_length;
 		urb->start_frame	= rpdu->start_frame;
+		urb->number_of_packets = rpdu->number_of_packets;
 		urb->error_count	= rpdu->error_count;
 	}
 }
@@ -761,11 +764,13 @@ static void correct_endian_ret_submit(st
 		cpu_to_be32s(&pdu->status);
 		cpu_to_be32s(&pdu->actual_length);
 		cpu_to_be32s(&pdu->start_frame);
+		cpu_to_be32s(&pdu->number_of_packets);
 		cpu_to_be32s(&pdu->error_count);
 	} else {
 		be32_to_cpus(&pdu->status);
 		be32_to_cpus(&pdu->actual_length);
 		be32_to_cpus(&pdu->start_frame);
+		cpu_to_be32s(&pdu->number_of_packets);
 		be32_to_cpus(&pdu->error_count);
 	}
 }


