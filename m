Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161959Ab1FAIQE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 04:16:04 -0400
Received: from cantor2.suse.de ([195.135.220.15]:43327 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161945Ab1FAIP6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 04:15:58 -0400
X-Mailbox-Line: From linux@blue.kroah.org Wed Jun  1 17:10:54 2011
Message-Id: <20110601081053.534624320@blue.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 01 Jun 2011 17:09:40 +0900
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Andrew Vasquez <andrew.vasquez@qlogic.com>,
        Madhuranath Iyengar <Madhu.Iyengar@qlogic.com>,
        James Bottomley <jbottomley@parallels.com>,
        James Bottomley <James.Bottomley@suse.de>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [010/165] [SCSI] qla2xxx: Properly set the dsd_list_len for dsd_chaining in cmd type 6.
In-Reply-To: <20110601081349.GA10017@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.39-stable review patch.  If anyone has any objections, please let us know.

------------------
Content-Length: 1794
Lines: 48

From: Andrew Vasquez <andrew.vasquez@qlogic.com>

commit fa96d927362a422405d65491326f8ef763572e84 upstream.

The firmware spec has the fcp_data_dseg_len defined as a 32-bit
value, while the corresponding field in the driver structure has
it defined as a 16-bit value.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
Signed-off-by: Madhuranath Iyengar <Madhu.Iyengar@qlogic.com>
Signed-off-by: James Bottomley <jbottomley@parallels.com>
Signed-off-by: James Bottomley <James.Bottomley@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/scsi/qla2xxx/qla_fw.h |    3 +--
 drivers/scsi/qla2xxx/qla_nx.c |    4 ++--
 2 files changed, 3 insertions(+), 4 deletions(-)

--- a/drivers/scsi/qla2xxx/qla_fw.h
+++ b/drivers/scsi/qla2xxx/qla_fw.h
@@ -416,8 +416,7 @@ struct cmd_type_6 {
 	uint8_t vp_index;
 
 	uint32_t fcp_data_dseg_address[2];	/* Data segment address. */
-	uint16_t fcp_data_dseg_len;		/* Data segment length. */
-	uint16_t reserved_1;			/* MUST be set to 0. */
+	uint32_t fcp_data_dseg_len;		/* Data segment length. */
 };
 
 #define COMMAND_TYPE_7	0x18		/* Command Type 7 entry */
--- a/drivers/scsi/qla2xxx/qla_nx.c
+++ b/drivers/scsi/qla2xxx/qla_nx.c
@@ -2548,11 +2548,11 @@ qla2xx_build_scsi_type_6_iocbs(srb_t *sp
 			dsd_seg = (uint32_t *)&cmd_pkt->fcp_data_dseg_address;
 			*dsd_seg++ = cpu_to_le32(LSD(dsd_ptr->dsd_list_dma));
 			*dsd_seg++ = cpu_to_le32(MSD(dsd_ptr->dsd_list_dma));
-			cmd_pkt->fcp_data_dseg_len = dsd_list_len;
+			*dsd_seg++ = cpu_to_le32(dsd_list_len);
 		} else {
 			*cur_dsd++ = cpu_to_le32(LSD(dsd_ptr->dsd_list_dma));
 			*cur_dsd++ = cpu_to_le32(MSD(dsd_ptr->dsd_list_dma));
-			*cur_dsd++ = dsd_list_len;
+			*cur_dsd++ = cpu_to_le32(dsd_list_len);
 		}
 		cur_dsd = (uint32_t *)next_dsd;
 		while (avail_dsds) {


