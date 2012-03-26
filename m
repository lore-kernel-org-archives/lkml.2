Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752887Ab2CZFWw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 01:22:52 -0400
Received: from imx9.toshiba.co.jp ([202.33.96.51]:52140 "EHLO
	imx9.toshiba.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752636Ab2CZFWh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 01:22:37 -0400
X-Greylist: delayed 2101 seconds by postgrey-1.27 at vger.kernel.org; Mon, 26 Mar 2012 01:22:35 EDT
Message-ID: <4F6FF1E3.7080908@toshiba.co.jp>
Date: Mon, 26 Mar 2012 13:34:43 +0900
From: KOBAYASHI Yoshitake <yoshitake.kobayashi@toshiba.co.jp>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:11.0) Gecko/20120312 Thunderbird/11.0
MIME-Version: 1.0
To: Santosh Y <santoshsy@gmail.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>,
        linux-scsi@vger.kernel.org, patches@linaro.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        arnd.bergmann@linaro.org, saugata.das@linaro.org, dsaxena@linaro.org,
        stephen.doel@linaro.org, venkat@linaro.org, ilho215.lee@samsung.com,
        nala.la@samsung.com, girish.shivananjappa@linaro.org,
        vishak.g@samsung.com, k.rajesh@samsung.com, yejin.moon@samsung.com,
        sreekumar.c@samsung.com, vinholikatti@gmail.com, linkinjeon@gmail.com,
        michaelc@cs.wisc.edu
Subject: Re: [PATCH v3 2/5] [SCSI] ufshcd: UFS UTP Transfer requests handling
References: <1330497714-26504-3-git-send-email-santoshsy@gmail.com>
In-Reply-To: <1330497714-26504-3-git-send-email-santoshsy@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Santosh Y wrote:
> +        ucd_cmd_ptr->exp_data_transfer_len =
> +            cpu_to_be32(lrbp->cmd->transfersize);
> +
> +        memcpy(ucd_cmd_ptr->cdb,
> +               lrbp->cmd->cmnd,
> +               (min_t(unsigned short,
> +                  lrbp->cmd->cmd_len,
> +                  MAX_CDB_SIZE)));

"Exptected Data Transfer Length" field contains a value that
represents the number of bytes that are required to complete the
SCSI command request and the number of bytes that the Initiator
expects to be transferred to/from the Target.
(JEDEC Standard 220 Table7-7)
On the other hand, "transfersize" in a scsi_cmnd struct is trimmed
to the sector size when requested transfer length exceeds it.
You may derive the actual transfer length from SCSI command itself like following.

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index feffe65..e63fecb 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -647,6 +647,34 @@ static void ufshcd_compose_upiu(struct ufshcd_lrb *lrbp)
                        (min_t(unsigned short,
                               lrbp->cmd->cmd_len,
                               MAX_CDB_SIZE)));
+
+               /* Overwrite exptected transfer length by using TRANSFER_LENGTH in SCSI commands */
+               switch(ucd_cmd_ptr->cdb[0]) {
+               case READ_6:
+               case WRITE_6:
+                       ucd_cmd_ptr->exp_data_transfer_len =
+                               cpu_to_be32(lrbp->cmd->transfersize *
+                                           ucd_cmd_ptr->cdb[4]);
+                       break;
+               case READ_10:
+               case WRITE_10:
+                       ucd_cmd_ptr->exp_data_transfer_len =
+                               cpu_to_be32(lrbp->cmd->transfersize *
+                                           ((ucd_cmd_ptr->cdb[7] << 8) |
+                                            ucd_cmd_ptr->cdb[8]));
+                       break;
+               case READ_12:
+               case WRITE_12:
+                       ucd_cmd_ptr->exp_data_transfer_len =
+                               cpu_to_be32(lrbp->cmd->transfersize *
+                                           ((ucd_cmd_ptr->cdb[10] << 24) |
+                                            (ucd_cmd_ptr->cdb[11] << 16) |
+                                            (ucd_cmd_ptr->cdb[12] << 8) |
+                                            ucd_cmd_ptr->cdb[13]));
+                       break;
+               default:
+                       break;
+               }
                 break;
         case UTP_CMD_TYPE_DEV_MANAGE:
                 /* For query function implementation */

