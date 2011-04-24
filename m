Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757519Ab1DXCrh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Apr 2011 22:47:37 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:32870 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757491Ab1DXCre (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Apr 2011 22:47:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=T3ww5n8PPYdnOj9ALg32bhxXNy6LLAzLJdO33SDfvobMEp7AjVUKqI8BRmWto9Gfyh
         8aCb0XlzgUerZ9bmD0ToW+B6eTtq+WwDiHQX/301TfduqgFedKFGQr95/O5bghWOrZwh
         Zit4RvSbdfMd5MBZ6vygUayTlM8bXlBKE7vi4=
MIME-Version: 1.0
Date: Sun, 24 Apr 2011 10:47:33 +0800
Message-ID: <BANLkTiniTy862jPL=e_FGcRtPO27r8xVEA@mail.gmail.com>
Subject: [PATCH] scsi/libfc: fix mm leak in handling incoming request for
 target discovery
From: Hillf Danton <dhillf@gmail.com>
To: devel@open-fcoe.org
Cc: Robert Love <robert.w.love@intel.com>,
        "James E.J. Bottomley" <James.Bottomley@suse.de>,
        Mike Christie <michaelc@cs.wisc.edu>, linux-scsi@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When handling incoming request, if the operation code carried by the
received frame is not RSCN, the frame should be freed as in the RSCN
case, or there is memory leakage.

Signed-off-by: Hillf Danton <dhillf@gmail.com>
---

--- a/drivers/scsi/libfc/fc_disc.c	2011-03-30 03:09:48.000000000 +0800
+++ b/drivers/scsi/libfc/fc_disc.c	2011-04-24 10:36:14.000000000 +0800
@@ -205,6 +205,7 @@ static void fc_disc_recv_req(struct fc_l
 	default:
 		FC_DISC_DBG(disc, "Received an unsupported request, "
 			    "the opcode is (%x)\n", op);
+		fc_frame_free(fp);
 		break;
 	}
 }
