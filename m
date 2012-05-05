Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752659Ab2EEStB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2012 14:49:01 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:56225 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751207Ab2EEStA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2012 14:49:00 -0400
MIME-Version: 1.0
Date: Sat, 5 May 2012 21:48:59 +0300
Message-ID: <CAFp-nYipan9fja6Fp2oC5YAfEiBbAtYQLnVAkW3CDzpwKdz6zg@mail.gmail.com>
Subject: How can I compile and install that patched libata-eh.c file?
From: Servet Portakal <servetportakal@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello ,

I received a patched file ( /drivers/ata/libata-eh.c ) from a
developer. and now I have to compile and install it. But I'm not an
expert user really. Can anybody explain it simply ?

Note: I'm not subscribed to the list.

Thanks.

patch...

diff --git a/drivers/ata/libata-eh.c b/drivers/ata/libata-eh.c
index c61316e..a92da34 100644
--- a/drivers/ata/libata-eh.c
+++ b/drivers/ata/libata-eh.c
@@ -1279,6 +1279,7 @@ void ata_eh_qc_complete(struct ata_queued_cmd *qc)
       __ata_eh_qc_complete(qc);
 }

+static const char *ata_err_string(unsigned int err_mask);
 /**
 *     ata_eh_qc_retry - Tell midlayer to retry an ATA command after EH
 *     @qc: Command to retry
@@ -1293,6 +1294,40 @@ void ata_eh_qc_complete(struct ata_queued_cmd *qc)
 void ata_eh_qc_retry(struct ata_queued_cmd *qc)
 {
       struct scsi_cmnd *scmd = qc->scsicmd;
+       static int cnt;
+
+       if (cnt < 32) {
+               struct ata_taskfile *cmd = &qc->tf, *res = &qc->result_tf;
+               const u8 *cdb = qc->cdb;
+               char cdb_buf[70] = "";
+
+               snprintf(cdb_buf, sizeof(cdb_buf),
+                        "cdb %02x %02x %02x %02x %02x %02x %02x %02x  "
+                        "%02x %02x %02x %02x %02x %02x %02x %02x\n         ",
+                        cdb[0], cdb[1], cdb[2], cdb[3],
+                        cdb[4], cdb[5], cdb[6], cdb[7],
+                        cdb[8], cdb[9], cdb[10], cdb[11],
+                        cdb[12], cdb[13], cdb[14], cdb[15]);
+               ata_dev_err(qc->dev, "XXX ata_eh_qc_retry:
scmd->retries=%d\n         "
+                           "cmd
%02x/%02x:%02x:%02x:%02x:%02x/%02x:%02x:%02x:%02x:%02x/%02x "
+                           "tag %d%s\n         "
+                           "res
%02x/%02x:%02x:%02x:%02x:%02x/%02x:%02x:%02x:%02x:%02x/%02x "
+                           "Emask 0x%x (%s)%s\n",
+                           scmd->retries,
+                           cmd->command, cmd->feature, cmd->nsect,
+                           cmd->lbal, cmd->lbam, cmd->lbah,
+                           cmd->hob_feature, cmd->hob_nsect,
+                           cmd->hob_lbal, cmd->hob_lbam, cmd->hob_lbah,
+                           cmd->device, qc->tag, cdb_buf,
+                           res->command, res->feature, res->nsect,
+                           res->lbal, res->lbam, res->lbah,
+                           res->hob_feature, res->hob_nsect,
+                           res->hob_lbal, res->hob_lbam, res->hob_lbah,
+                           res->device, qc->err_mask,
ata_err_string(qc->err_mask),
+                           qc->err_mask & AC_ERR_NCQ ? " <F>" : "");
+               cnt++;
+       }
+
       if (!qc->err_mask && scmd->retries)
               scmd->retries--;
       __ata_eh_qc_complete(qc);
