Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933704Ab0I1CH5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 22:07:57 -0400
Received: from smtp106.sbc.mail.mud.yahoo.com ([68.142.198.104]:34037 "HELO
	smtp106.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S933680Ab0I1CHq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 22:07:46 -0400
X-Yahoo-SMTP: fzDSGlOswBCWnIOrNw7KwwK1j9PqyNbe5PtLKiS4dDU.UNl_t6bdEZu9tTLW
X-YMail-OSG: XJOv1hIVM1m60FeMybk031tcsfky4VMCj.nTLfSPm7Mqg0t
 6JdfVcvOC_vmA9YNdjW61B2P7xXOMorupsDghRIipJaHMbG3IC1QrS_og_M_
 zYeJ.VX.L4q2Xbhx..ihs_0Nw8qOwvaLyr_gsx3ev9kW.9SRVgd6Wg1B0.ig
 VXSv5DewqgL98tSK_G9A5PhMFjNh7EsP4_ja97TwzMIppt__QAqWlUYhykGV
 cy7v4E254L6GZGA1lHhcWcBhlgu3X.wHnEygZSpDXA0W6SWvh59sZ521syGT
 R7SuSmrzZRQdODPw8aFc_naxHleJMHOYNRy1ymvFgJi4-
X-Yahoo-Newman-Property: ymail-3
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Vasu Dev <vasu.dev@linux.intel.com>,
        Tim Chen <tim.c.chen@linux.intel.com>, Andi Kleen <ak@linux.intel.com>,
        Matthew Wilcox <willy@linux.intel.com>,
        James Bottomley <James.Bottomley@suse.de>,
        Mike Christie <michaelc@cs.wisc.edu>, Jens Axboe <jaxboe@fusionio.com>
Cc: James Smart <james.smart@emulex.com>,
        Andrew Vasquez <andrew.vasquez@qlogic.com>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        Hannes Reinecke <hare@suse.de>, Joe Eykholt <jeykholt@cisco.com>,
        Christoph Hellwig <hch@lst.de>, Jon Hawley <warthog9@kernel.org>,
        MPTFusionLinux <DL-MPTFusionLinux@lsi.com>,
        "eata.c maintainer" <dario.ballabio@inwind.it>,
        Luben Tuikov <ltuikov@yahoo.com>, mvsas maintainer <kewei@marvell.com>,
        pm8001 maintainer Jack Wang <jack_wang@usish.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: [RFC v4 15/19] mpt2sas: Add scsi_cmd_get_serial() call
Date: Mon, 27 Sep 2010 19:07:41 -0700
Message-Id: <1285639661-7505-1-git-send-email-nab@linux-iscsi.org>
X-Mailer: git-send-email 1.5.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch adds a scsi_cmd_get_serial() call in _scsih_qcmd() to setup a
valid struct scsi_cmnd->serial_number because mpt2sas_scsih_issue_tm()
still depends upon this being set.

This also includes setting the SHT->unlocked_qcmd=1 for host_lock less mpt2sas
_scsih_qcmd() operation.

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/scsi/mpt2sas/mpt2sas_scsih.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/mpt2sas/mpt2sas_scsih.c b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
index 16e99b6..4bedbf2 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_scsih.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
@@ -3325,6 +3325,11 @@ _scsih_qcmd(struct scsi_cmnd *scmd, void (*done)(struct scsi_cmnd *))
 	u16 smid;
 
 	scmd->scsi_done = done;
+	/*
+	 * Call scsi_cmd_get_serial() because we need a valid serial number
+	 * in mpt2sas_scsih_issue_tm()
+	 */
+	scsi_cmd_get_serial(scmd);
 	sas_device_priv_data = scmd->device->hostdata;
 	if (!sas_device_priv_data || !sas_device_priv_data->sas_target) {
 		scmd->result = DID_NO_CONNECT << 16;
@@ -6464,6 +6469,7 @@ static struct scsi_host_template scsih_driver_template = {
 	.eh_host_reset_handler		= _scsih_host_reset,
 	.bios_param			= _scsih_bios_param,
 	.can_queue			= 1,
+	.unlocked_qcmd			= 1,
 	.this_id			= -1,
 	.sg_tablesize			= MPT2SAS_SG_DEPTH,
 	.max_sectors			= 8192,
-- 
1.7.3

