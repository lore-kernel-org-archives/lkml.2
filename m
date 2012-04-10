Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758597Ab2DJLIx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 07:08:53 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:64776 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755161Ab2DJLIv convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 07:08:51 -0400
MIME-Version: 1.0
In-Reply-To: <4F6FF1E3.7080908@toshiba.co.jp>
References: <1330497714-26504-3-git-send-email-santoshsy@gmail.com>
	<4F6FF1E3.7080908@toshiba.co.jp>
Date: Tue, 10 Apr 2012 16:38:46 +0530
Message-ID: <CAFSEfh3vunABGrPW0_80tuTMvc1PnLHdR80HASXW=v0f_0bLAQ@mail.gmail.com>
Subject: Re: [PATCH v3 2/5] [SCSI] ufshcd: UFS UTP Transfer requests handling
From: Venkatraman S <venkat@linaro.org>
To: KOBAYASHI Yoshitake <yoshitake.kobayashi@toshiba.co.jp>
Cc: Santosh Y <santoshsy@gmail.com>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, patches@linaro.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        arnd.bergmann@linaro.org, saugata.das@linaro.org, dsaxena@linaro.org,
        stephen.doel@linaro.org, ilho215.lee@samsung.com, nala.la@samsung.com,
        girish.shivananjappa@linaro.org, vishak.g@samsung.com,
        k.rajesh@samsung.com, yejin.moon@samsung.com, sreekumar.c@samsung.com,
        vinholikatti@gmail.com, linkinjeon@gmail.com, michaelc@cs.wisc.edu
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26 March 2012 10:04, KOBAYASHI Yoshitake
<yoshitake.kobayashi@toshiba.co.jp> wrote:
> Santosh Y wrote:
>>
>> +        ucd_cmd_ptr->exp_data_transfer_len =
>> +            cpu_to_be32(lrbp->cmd->transfersize);
>> +
>> +        memcpy(ucd_cmd_ptr->cdb,
>> +               lrbp->cmd->cmnd,
>> +               (min_t(unsigned short,
>> +                  lrbp->cmd->cmd_len,
>> +                  MAX_CDB_SIZE)));
>
>
> "Exptected Data Transfer Length" field contains a value that
> represents the number of bytes that are required to complete the
> SCSI command request and the number of bytes that the Initiator
> expects to be transferred to/from the Target.
> (JEDEC Standard 220 Table7-7)
> On the other hand, "transfersize" in a scsi_cmnd struct is trimmed
> to the sector size when requested transfer length exceeds it.
> You may derive the actual transfer length from SCSI command itself like
> following.
Hi,
  Can you please send signed-off patches for the two issues that you reported ?
I would like to use them on my development tree.

Thanks and regards,
Venkat.

>
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index feffe65..e63fecb 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -647,6 +647,34 @@ static void ufshcd_compose_upiu(struct ufshcd_lrb
> *lrbp)
>                       (min_t(unsigned short,
>                              lrbp->cmd->cmd_len,
>                              MAX_CDB_SIZE)));
> +
> +               /* Overwrite exptected transfer length by using
> TRANSFER_LENGTH in SCSI commands */
> +               switch(ucd_cmd_ptr->cdb[0]) {
> +               case READ_6:
> +               case WRITE_6:
> +                       ucd_cmd_ptr->exp_data_transfer_len =
> +                               cpu_to_be32(lrbp->cmd->transfersize *
> +                                           ucd_cmd_ptr->cdb[4]);
> +                       break;
> +               case READ_10:
> +               case WRITE_10:
> +                       ucd_cmd_ptr->exp_data_transfer_len =
> +                               cpu_to_be32(lrbp->cmd->transfersize *
> +                                           ((ucd_cmd_ptr->cdb[7] << 8) |
> +                                            ucd_cmd_ptr->cdb[8]));
> +                       break;
> +               case READ_12:
> +               case WRITE_12:
> +                       ucd_cmd_ptr->exp_data_transfer_len =
> +                               cpu_to_be32(lrbp->cmd->transfersize *
> +                                           ((ucd_cmd_ptr->cdb[10] << 24) |
> +                                            (ucd_cmd_ptr->cdb[11] << 16) |
> +                                            (ucd_cmd_ptr->cdb[12] << 8) |
> +                                            ucd_cmd_ptr->cdb[13]));
> +                       break;
> +               default:
> +                       break;
> +               }
>                break;
>        case UTP_CMD_TYPE_DEV_MANAGE:
>
>                /* For query function implementation */
>
