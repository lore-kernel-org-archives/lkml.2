Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965900Ab2EPI25 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 04:28:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13628 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932600Ab2EPI2y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 04:28:54 -0400
Date: Wed, 16 May 2012 11:28:41 +0300
From: Gleb Natapov <gleb@redhat.com>
To: Hannes Reinecke <hare@suse.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] EDD: Check for correct EDD 3.0 length
Message-ID: <20120516082841.GS32036@redhat.com>
References: <1337151096-38511-1-git-send-email-hare@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1337151096-38511-1-git-send-email-hare@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 16, 2012 at 08:51:36AM +0200, Hannes Reinecke wrote:
> There are two competing EDD 3.0 specifications,
> the original one from Phoenix
> <http://mbldr.sourceforge.net/specsedd30.pdf>
> and the T-13 approved one
> <http://www.t13.org/documents/UploadedDocuments/docs2004/d1572r3-EDD3.pdf>
> 
> They differ in the length of the device_path field, which
> is one quad word for the Phoenix spec and two quad words
> for the T-13 spec. So we need to test for both lengths
> and blank out the second quad word when a Phoenix
> version is detected.
> 
Can you please clarify what practical problem are you seeing that
you are trying to fix with this patch?

> Signed-off-by: Hannes Reinecke <hare@suse.de>
> Cc: Gleb Natapov <gleb@redhat.com>
> Cc: H. Peter Anvin <hpa@linux.intel.com>
> Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
> 
> diff --git a/drivers/firmware/edd.c b/drivers/firmware/edd.c
> index e229576..beedf4c 100644
> --- a/drivers/firmware/edd.c
> +++ b/drivers/firmware/edd.c
> @@ -192,6 +192,13 @@ edd_show_interface(struct edd_device *edev, char *buf)
>  			p += scnprintf(p, left, " ");
>  		}
>  	}
> +	/*
> +	 * Phoenix EDD 3.0 reserves only one quad word for the
> +	 * device path, so blank out the second quad word.
> +	 */
> +	if (info->params.device_path_info_length == 36)
> +		info->params.device_path.unknown.reserved2 = 0;
> +
You overwrite checksum here. Hope it will not be checked after that point.
This will work for all interface types defined by Phoenix spec except
SCSI as far as I see. In Phoenix spec SCSI interface is one byte LUN,
in T13 it is changed to be: word SCSI ID, qword LUN.

>  	if (!strncmp(info->params.interface_type, "ATAPI", 5)) {
>  		p += scnprintf(p, left, "\tdevice: %u  lun: %u\n",
>  			     info->params.device_path.atapi.device,
> @@ -545,8 +552,12 @@ edd_has_edd30(struct edd_device *edev)
>  	}
>  
>  
> -	/* We support only T13 spec */
> -	if (info->params.device_path_info_length != 44)
> +	/*
> +	 * Phoenix EDD 3.0 specifies this to be 36,
> +	 * T-13 EDD 3.0 uses 44. So check for both.
> +	 */
> +	if (info->params.device_path_info_length != 36 &&
> +	    info->params.device_path_info_length != 44)
>  		return 0;
>  
>  	for (i = 30; i < info->params.device_path_info_length + 30; i++)

--
			Gleb.
