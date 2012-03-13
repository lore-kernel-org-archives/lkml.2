Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759299Ab2CMBGm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 21:06:42 -0400
Received: from mail.windriver.com ([147.11.1.11]:46705 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758029Ab2CMARu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 20:17:50 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Arjan Mels <arjan.mels@gmx.net>,
        Takahiro Hirofuchi <hirofuchi@users.sourceforge.net>,
        Max Vozeler <max@vozeler.com>, Greg Kroah-Hartman <gregkh@suse.de>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 017/196] staging: usbip: bugfix add number of packets for isochronous frames
Date: Mon, 12 Mar 2012 20:12:25 -0400
Message-Id: <1331597724-31358-18-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.9.3
In-Reply-To: <1331597724-31358-1-git-send-email-paul.gortmaker@windriver.com>
References: <1331597724-31358-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arjan Mels <arjan.mels@gmx.net>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 1325f85fa49f57df034869de430f7c302ae23109 upstream.

The number_of_packets was not transmitted for RET_SUBMIT packets. The
linux client used the stored number_of_packet from the submitted
request. The windows userland client does not do this however and needs
to know the number_of_packets to determine the size of the transmission.

Signed-off-by: Arjan Mels <arjan.mels@gmx.net>
Cc: Takahiro Hirofuchi <hirofuchi@users.sourceforge.net>
Cc: Max Vozeler <max@vozeler.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/staging/usbip/usbip_common.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/usbip/usbip_common.c b/drivers/staging/usbip/usbip_common.c
index e3fa421..4d0eb92 100644
--- a/drivers/staging/usbip/usbip_common.c
+++ b/drivers/staging/usbip/usbip_common.c
@@ -334,10 +334,11 @@ void usbip_dump_header(struct usbip_header *pdu)
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
@@ -605,6 +606,7 @@ static void usbip_pack_ret_submit(struct usbip_header *pdu, struct urb *urb,
 		rpdu->status		= urb->status;
 		rpdu->actual_length	= urb->actual_length;
 		rpdu->start_frame	= urb->start_frame;
+		rpdu->number_of_packets = urb->number_of_packets;
 		rpdu->error_count	= urb->error_count;
 	} else {
 		/* vhci_rx.c */
@@ -612,6 +614,7 @@ static void usbip_pack_ret_submit(struct usbip_header *pdu, struct urb *urb,
 		urb->status		= rpdu->status;
 		urb->actual_length	= rpdu->actual_length;
 		urb->start_frame	= rpdu->start_frame;
+		urb->number_of_packets = rpdu->number_of_packets;
 		urb->error_count	= rpdu->error_count;
 	}
 }
@@ -680,11 +683,13 @@ static void correct_endian_ret_submit(struct usbip_header_ret_submit *pdu,
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
-- 
1.7.9.3

