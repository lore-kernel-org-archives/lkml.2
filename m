Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755468Ab2IGSJn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 14:09:43 -0400
Received: from mail.linux-iscsi.org ([67.23.28.174]:48988 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753507Ab2IGSJj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 14:09:39 -0400
Subject: Re: [PATCH 03/11] target: fail REPORT LUNS with less than 16 bytes
 of payload
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, target-devel@vger.kernel.org, hch@lst.de,
        roland@kernel.org
In-Reply-To: <1347031842-2531-4-git-send-email-pbonzini@redhat.com>
References: <1347031842-2531-1-git-send-email-pbonzini@redhat.com>
	 <1347031842-2531-4-git-send-email-pbonzini@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 07 Sep 2012 11:09:37 -0700
Message-ID: <1347041377.4162.627.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-09-07 at 17:30 +0200, Paolo Bonzini wrote:
> SPC says:
> 
> "The ALLOCATION LENGTH field is defined in 4.3.5.6. The allocation length
> should be at least 16.  Device servers compliant with SPC return CHECK
> CONDITION status, with the sense key set to ILLEGAL REQUEST, and the
> additional sense code set to INVALID FIELD IN CDB when the allocation
> length is less than 16 bytes".
> 
> Testcase: sg_raw -r8 /dev/sdb a0 00 00 00 00 00 00 00 00 08 00 00
>     should fail with ILLEGAL REQUEST / INVALID FIELD IN CDB sense
>     does not fail without the patch
>     fails correctly with the patch
> 
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---

Looks good.  Applied to master.

Thanks Paolo!

>  drivers/target/target_core_device.c |    7 +++++++
>  1 files changed, 7 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/target/target_core_device.c b/drivers/target/target_core_device.c
> index cf2c66f..9fc9a60 100644
> --- a/drivers/target/target_core_device.c
> +++ b/drivers/target/target_core_device.c
> @@ -669,6 +669,13 @@ int target_report_luns(struct se_cmd *se_cmd)
>  	unsigned char *buf;
>  	u32 lun_count = 0, offset = 8, i;
>  
> +	if (se_cmd->data_length < 16) {
> +		pr_warn("REPORT LUNS allocation length %u too small\n",
> +			se_cmd->data_length);
> +		se_cmd->scsi_sense_reason = TCM_INVALID_CDB_FIELD;
> +		return -EINVAL;
> +	}
> +
>  	buf = transport_kmap_data_sg(se_cmd);
>  	if (!buf)
>  		return -ENOMEM;


