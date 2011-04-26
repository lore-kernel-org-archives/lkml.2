Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758905Ab1DZVlB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 17:41:01 -0400
Received: from mga02.intel.com ([134.134.136.20]:43637 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758506Ab1DZVNc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 17:13:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,270,1301900400"; 
   d="scan'208";a="738831523"
From: Andi Kleen <andi@firstfloor.org>
References: <20110426212.641772347@firstfloor.org>
In-Reply-To: <20110426212.641772347@firstfloor.org>
To: arjan.mels@gmx.net, ak@linux.intel.com, hirofuchi@users.sourceforge.net,
        max@vozeler.com, gregkh@suse.de, linux-kernel@vger.kernel.org,
        stable@kernel.org, tim.bird@am.sony.com
Subject: [PATCH] [4/106] staging: usbip: bugfix add number of packets for isochronous frames
Message-Id: <20110426211241.E98163E1886@tassilo.jf.intel.com>
Date: Tue, 26 Apr 2011 14:12:41 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Arjan Mels <arjan.mels@gmx.net>

commit 1325f85fa49f57df034869de430f7c302ae23109 upstream.

The number_of_packets was not transmitted for RET_SUBMIT packets. The
linux client used the stored number_of_packet from the submitted
request. The windows userland client does not do this however and needs
to know the number_of_packets to determine the size of the transmission.

Signed-off-by: Arjan Mels <arjan.mels@gmx.net>
Signed-off-by: Andi Kleen <ak@linux.intel.com>
Cc: Takahiro Hirofuchi <hirofuchi@users.sourceforge.net>
Cc: Max Vozeler <max@vozeler.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/staging/usbip/usbip_common.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

Index: linux-2.6.35.y/drivers/staging/usbip/usbip_common.c
===================================================================
--- linux-2.6.35.y.orig/drivers/staging/usbip/usbip_common.c
+++ linux-2.6.35.y/drivers/staging/usbip/usbip_common.c
@@ -334,10 +334,11 @@ void usbip_dump_header(struct usbip_head
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
@@ -625,6 +626,7 @@ static void usbip_pack_ret_submit(struct
 		rpdu->status		= urb->status;
 		rpdu->actual_length	= urb->actual_length;
 		rpdu->start_frame	= urb->start_frame;
+		rpdu->number_of_packets = urb->number_of_packets;
 		rpdu->error_count	= urb->error_count;
 	} else {
 		/* vhci_rx.c */
@@ -632,6 +634,7 @@ static void usbip_pack_ret_submit(struct
 		urb->status		= rpdu->status;
 		urb->actual_length	= rpdu->actual_length;
 		urb->start_frame	= rpdu->start_frame;
+		urb->number_of_packets = rpdu->number_of_packets;
 		urb->error_count	= rpdu->error_count;
 	}
 }
@@ -700,11 +703,13 @@ static void correct_endian_ret_submit(st
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
