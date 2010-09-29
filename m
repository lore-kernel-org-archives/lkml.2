Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755993Ab0I2VVI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Sep 2010 17:21:08 -0400
Received: from smtp128.sbc.mail.sp1.yahoo.com ([69.147.65.187]:45989 "HELO
	smtp128.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755968Ab0I2VVF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Sep 2010 17:21:05 -0400
X-Yahoo-SMTP: fzDSGlOswBCWnIOrNw7KwwK1j9PqyNbe5PtLKiS4dDU.UNl_t6bdEZu9tTLW
X-YMail-OSG: 9zqNCSQVM1lWGXhxFO7K2_ZQOWBpyTtMZAtqIIS8HHGmwsK
 oLs.3uUJZaGgHe0nC1l_pEcpHb27slfeiXr.qNmWEoK58fBIUUP2vsBcQOSi
 5WEa3zGHCvLJz9sViTb2Vw6JjelXaJIW06DWgiE2lhbw9NZbrgPgMRzSypyw
 6vdKZapPQq2i6SyxUaTeS8LKk0vp951FWy_SZy.x2VwB6kvlnKZ0qUPy7ySW
 d2quIl.45GyDx5wtxoXiFBePNnh1WNeb9afzw0CTqdzSYV9tR.jCll9yCjFN
 CuxUwib_MgMmDbsHxVChb_cfzdFpV6OJtI_jxUUB2x3kzBM9OMyhj4.vBq0h
 KbjQ6khJ85s5rqwEVhQ--
X-Yahoo-Newman-Property: ymail-3
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Cc: Christoph Hellwig <hch@lst.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Douglas Gilbert <dgilbert@interlog.com>, Jens Axboe <axboe@kernel.dk>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        Mike Christie <michaelc@cs.wisc.edu>, Hannes Reinecke <hare@suse.de>,
        James Bottomley <James.Bottomley@suse.de>,
        Konrad Rzeszutek Wilk <konrad@darnok.org>,
        Boaz Harrosh <bharrosh@panasas.com>,
        Richard Sharpe <realrichardsharpe@gmail.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: [PATCH 2/3] tcm: Add Thin Provisioning VPD page emulation
Date: Wed, 29 Sep 2010 14:21:03 -0700
Message-Id: <1285795263-30983-1-git-send-email-nab@linux-iscsi.org>
X-Mailer: git-send-email 1.5.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch adds Thin Provisioning VPD page (0xb2) emulation for EVPD
INQUIRY emulation following sbcr22 section 6.5.4 Thin Provisioning VPD page.
This code currently sets:

	*) Descriptor Present bit to DP=0 to signal no attached
	   PROVISIONING GROUP DESCRIPTORs.
	*) Leaves the THRESHOLD EXPONENT set to 0x00 following mkp's
	   lead in sd.c and recommendation that this may be changing
	   again in the future.

Here is how it looks in action with sg_vpd with TCM_Loop -> TCM/IBLOCK ->
scsi_debug w/ TPE + TPU enabled:

target# sg_vpd --page=0xb2 /dev/sdh
Thin provisioning VPD page (SBC):
  Unmap supported (TPU): 1
  Write same with unmap supported (TPWS): 0
  Anchored LBAs not supported
  Threshold exponent: 0
  Descriptor present (DP): 0

Many thanks to Martin Petersen for answering questions here!

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_transport.c |   32 ++++++++++++++++++++++++++++++++
 1 files changed, 32 insertions(+), 0 deletions(-)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 2093563..57fbbf9 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -4984,6 +4984,38 @@ set_len:
 		if (DEV_ATTRIB(dev)->unmap_granularity_alignment != 0)
 			buf[32] |= 0x80; /* Set the UGAVALID bit */
 		break;
+	case 0xb2: /* Thin Provisioning VPD */
+		/*
+		 * From sbc3r22 section 6.5.4 Thin Provisioning VPD page:
+		 *
+		 * The PAGE LENGTH field is defined in SPC-4. If the DP bit is
+		 * set to zero, then the page length shall be set to 0004h. If the
+		 * DP bit is set to one, then the page length shall be set to the value
+		 * defined in table 162.
+		 */
+		buf[0] = TRANSPORT(dev)->get_device_type(dev);
+		buf[1] = 0xb2;
+		/*
+		 * Set Hardcoded length mentioned above for DP=0
+		 */
+		put_unaligned_be16(0x0004, &buf[2]);
+		/*
+		 * The THRESHOLD EXPONENT field indicates the threshold set size in LBAs
+		 * as a power of 2 (i.e., the threshold set size is equal to 2(threshold exponent)).
+		 *
+		 * Note that this is currently set to 0x00 as mkp says it will be
+		 * changing again.  We can enable this once it has settled in T10
+		 * and is actually used by Linux/SCSI ML code.
+		 */
+		buf[4] = 0x00;
+		/*
+		 * A TPU bit set to one indicates that the device server supports
+		 * the UNMAP command (see 5.25). A TPU bit set to zero indicates
+		 * that the device server does not support the UNMAP command.
+		 */
+		if (DEV_ATTRIB(dev)->emulate_tpu != 0)
+			buf[5] = 0x80;
+		break;
 	default:
 		printk(KERN_ERR "Unknown VPD Code: 0x%02x\n", cdb[2]);
 		return -1;
-- 
1.5.6.5

