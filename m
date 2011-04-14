Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756849Ab1DNGHL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 02:07:11 -0400
Received: from na3sys009aog106.obsmtp.com ([74.125.149.77]:48755 "EHLO
	na3sys009aog106.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756410Ab1DNGHK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 02:07:10 -0400
From: "Desai, Kashyap" <Kashyap.Desai@lsi.com>
To: Dan Rosenberg <drosenberg@vsecurity.com>,
        "Moore, Eric" <Eric.Moore@lsi.com>,
        "james.bottomley@suse.de" <james.bottomley@suse.de>
CC: "security@kernel.org" <security@kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Thu, 14 Apr 2011 11:38:22 +0530
Subject: RE: [PATCH] drivers/scsi/mpt2sas: prevent heap overflows and
 unchecked reads
Thread-Topic: [PATCH] drivers/scsi/mpt2sas: prevent heap overflows and
 unchecked reads
Thread-Index: AcvzsSk52ESdijBbQeKRGykB5baWsQGuQmYw
Message-ID: <B2FD678A64EAAD45B089B123FDFC3ED70157F09188@inbmail01.lsi.com>
References: <1302021959.2082.8.camel@dan>
In-Reply-To: <1302021959.2082.8.camel@dan>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id p3E67NdH017875


This patch has been tested by Eric Moore and it works fine.

Please consider this patch "Acked-by: Eric Moore <eric.moore@lsi.com>" 

Thanks, Kashyap

> -----Original Message-----
> From: Dan Rosenberg [mailto:drosenberg@vsecurity.com]
> Sent: Tuesday, April 05, 2011 10:16 PM
> To: Moore, Eric; james.bottomley@suse.de; Desai, Kashyap
> Cc: security@kernel.org; linux-scsi@vger.kernel.org; linux-
> kernel@vger.kernel.org
> Subject: [PATCH] drivers/scsi/mpt2sas: prevent heap overflows and
> unchecked reads
> 
> At two points in handling device ioctls via /dev/mpt2ctl, user-supplied
> length values are used to copy data from userspace into heap buffers
> without bounds checking, allowing controllable heap corruption and
> subsequently privilege escalation.
> 
> Additionally, user-supplied values are used to determine the size of a
> copy_to_user() as well as the offset into the buffer to be read, with
> no
> bounds checking, allowing users to read arbitrary kernel memory.
> 
> Compile-tested only.  Thanks to Eric Moore for suggestions on how to
> fix
> this.
> 
> Signed-off-by: Dan Rosenberg <drosenberg@vsecurity.com>
> Cc: stable@kernel.org
> ---
>  drivers/scsi/mpt2sas/mpt2sas_ctl.c |   23 +++++++++++++++++++++--
>  1 files changed, 21 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/mpt2sas/mpt2sas_ctl.c
> b/drivers/scsi/mpt2sas/mpt2sas_ctl.c
> index e92b77a..3834c95 100644
> --- a/drivers/scsi/mpt2sas/mpt2sas_ctl.c
> +++ b/drivers/scsi/mpt2sas/mpt2sas_ctl.c
> @@ -688,6 +688,13 @@ _ctl_do_mpt_command(struct MPT2SAS_ADAPTER *ioc,
>  		goto out;
>  	}
> 
> +	/* Check for overflow and wraparound */
> +	if (karg.data_sge_offset * 4 > ioc->request_sz ||
> +	    karg.data_sge_offset > (UINT_MAX / 4)) {
> +		ret = -EINVAL;
> +		goto out;
> +	}
> +
>  	/* copy in request message frame from user */
>  	if (copy_from_user(mpi_request, mf, karg.data_sge_offset*4)) {
>  		printk(KERN_ERR "failure at %s:%d/%s()!\n", __FILE__,
> __LINE__,
> @@ -1963,7 +1970,7 @@ _ctl_diag_read_buffer(void __user *arg, enum
> block_state state)
>  	Mpi2DiagBufferPostReply_t *mpi_reply;
>  	int rc, i;
>  	u8 buffer_type;
> -	unsigned long timeleft;
> +	unsigned long timeleft, request_size, copy_size;
>  	u16 smid;
>  	u16 ioc_status;
>  	u8 issue_reset = 0;
> @@ -1999,6 +2006,8 @@ _ctl_diag_read_buffer(void __user *arg, enum
> block_state state)
>  		return -ENOMEM;
>  	}
> 
> +	request_size = ioc->diag_buffer_sz[buffer_type];
> +
>  	if ((karg.starting_offset % 4) || (karg.bytes_to_read % 4)) {
>  		printk(MPT2SAS_ERR_FMT "%s: either the starting_offset "
>  		    "or bytes_to_read are not 4 byte aligned\n", ioc->name,
> @@ -2006,13 +2015,23 @@ _ctl_diag_read_buffer(void __user *arg, enum
> block_state state)
>  		return -EINVAL;
>  	}
> 
> +	if (karg.starting_offset > request_size)
> +		return -EINVAL;
> +
>  	diag_data = (void *)(request_data + karg.starting_offset);
>  	dctlprintk(ioc, printk(MPT2SAS_INFO_FMT "%s: diag_buffer(%p), "
>  	    "offset(%d), sz(%d)\n", ioc->name, __func__,
>  	    diag_data, karg.starting_offset, karg.bytes_to_read));
> 
> +	/* Truncate data on requests that are too large */
> +	if ((diag_data + karg.bytes_to_read < diag_data) ||
> +	    (diag_data + karg.bytes_to_read > request_data +
> request_size))
> +		copy_size = request_size - karg.starting_offset;
> +	else
> +		copy_size = karg.bytes_to_read;
> +
>  	if (copy_to_user((void __user *)uarg->diagnostic_data,
> -	    diag_data, karg.bytes_to_read)) {
> +	    diag_data, copy_size)) {
>  		printk(MPT2SAS_ERR_FMT "%s: Unable to write "
>  		    "mpt_diag_read_buffer_t data @ %p\n", ioc->name,
>  		    __func__, diag_data);
> 
> 
> 

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
