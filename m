Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756236Ab0ERF57 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 01:57:59 -0400
Received: from mail-pz0-f194.google.com ([209.85.222.194]:51704 "EHLO
	mail-pz0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754579Ab0ERF56 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 01:57:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=FU/7MGHJPV2Rdb/Ehti4LjtVYBQDL4VcE3omk2U5zD3BuVp/HfnQSCQgQ0ANF2aiNC
         SqU01MhGKEtg4PZu38A7lWGGVohkBkQUBfoj8do4E0WIi0mEnGwiP9WtUtp8ZdiZRADs
         I3AUtxgWWjZbC/UAk2OnTnlTKPs862CXi0PUY=
MIME-Version: 1.0
Date: Tue, 18 May 2010 13:57:57 +0800
Message-ID: <AANLkTilN3PuzIweiocSMOsYkYtcOHeQbh_KrOkLiAigk@mail.gmail.com>
Subject: [PATCH] cciss: fix code style in drivers/block/cciss_scsi.c
From: Steven Liu <lingjiujianke@gmail.com>
To: mike.miller@hp.com, linux-kernel@vger.kernel.org, iss_storagedev@hp.com,
       liuqi@thunderst.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Mike Miller,

if kmalloc memory for ld_buff failed,it will free currentsd  and
ld_buff once more
so i think this patch may be better

fix code style in drivers/block/cciss_scsi.c

Signed-off-by: Liu Qi <lingjiujianke@gmail.com>
---
 drivers/block/cciss_scsi.c |   20 +++++++++++++++++---
 1 files changed, 17 insertions(+), 3 deletions(-)

diff --git a/drivers/block/cciss_scsi.c b/drivers/block/cciss_scsi.c
index e1d0e2c..ad2417f 100644
--- a/drivers/block/cciss_scsi.c
+++ b/drivers/block/cciss_scsi.c
@@ -1198,13 +1198,24 @@ cciss_update_non_disk_devices(int cntl_num, int hostno)

        c = (ctlr_info_t *) hba[cntl_num];
        ld_buff = kzalloc(reportlunsize, GFP_KERNEL);
+       if(ld_buff == NULL){
+               printk(KERN_ERR "cciss: out of memory\n");
+               goto out1;
+       }
+
        inq_buff = kmalloc(OBDR_TAPE_INQ_SIZE, GFP_KERNEL);
+       if(inq_buff == NULL){
+               printk(KERN_ERR "cciss: out of memory\n");
+               goto out2;
+       }
+
        currentsd = kzalloc(sizeof(*currentsd) *
                        (CCISS_MAX_SCSI_DEVS_PER_HBA+1), GFP_KERNEL);
-       if (ld_buff == NULL || inq_buff == NULL || currentsd == NULL) {
+       if(currentsd == NULL){
                printk(KERN_ERR "cciss: out of memory\n");
-               goto out;
+               goto out3;
        }
+
        this_device = &currentsd[CCISS_MAX_SCSI_DEVS_PER_HBA];
        if (cciss_scsi_do_report_phys_luns(c, ld_buff, reportlunsize) == 0) {
                ch = &ld_buff->LUNListLength[0];
@@ -1289,9 +1300,12 @@ cciss_update_non_disk_devices(int cntl_num, int hostno)

        adjust_cciss_scsi_table(cntl_num, hostno, currentsd, ncurrent);
 out:
+       kfree(currentsd);
+out3:
        kfree(inq_buff);
+out2:
        kfree(ld_buff);
-       kfree(currentsd);
+out1:
        return;
 }

--
1.7.1
