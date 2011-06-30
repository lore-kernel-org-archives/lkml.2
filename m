Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753999Ab1F3Tir (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 15:38:47 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:49845
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753892Ab1F3Tiq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 15:38:46 -0400
Date: Thu, 30 Jun 2011 15:38:43 -0400
From: Christoph Hellwig <hch@infradead.org>
To: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org, Haiyang Zhang <haiyangz@microsoft.com>,
        Abhishek Kane <v-abkane@microsoft.com>,
        Hank Janssen <hjanssen@microsoft.com>
Subject: Re: [PATCH 23/40] Staging: hv: storvsc: Introduce code to manage IDE
 devices using storvsc HBA
Message-ID: <20110630193843.GB22707@infradead.org>
References: <1309358301-8488-1-git-send-email-kys@microsoft.com>
 <1309358377-8537-1-git-send-email-kys@microsoft.com>
 <1309358377-8537-23-git-send-email-kys@microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1309358377-8537-23-git-send-email-kys@microsoft.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +/*
> + * We want to manage the IDE devices using standard Linux SCSI drivers
> + * using the storvsc driver.
> + * Define special channels to support this.
> + */
> +
> +#define HV_MAX_IDE_DEVICES	4
> +#define HV_IDE_BASE_CHANNEL	10
> +#define HV_IDE0_DEV1		HV_IDE_BASE_CHANNEL
> +#define HV_IDE0_DEV2		(HV_IDE_BASE_CHANNEL + 1)
> +#define HV_IDE1_DEV1		(HV_IDE_BASE_CHANNEL + 2)
> +#define HV_IDE1_DEV2		(HV_IDE_BASE_CHANNEL + 3)

This at last needs a good explanation of why these devices are called
IDE if they actually aren't.  I know you've explained the reason to me
before, but it should also be in the code.

The HV_IDE1_DEVn defines don't seem to useful to me.  They are just
used in one place, and doing an opencoded HV_IDE_BASE_CHANNEL +
channel_nr would seem a lot easier to understand to me.

> +static struct  Scsi_Host *storvsc_host;
> +
> +/*
> + * State to manage IDE devices that register with the storvsc driver.
> + *
> + */
> +static struct hv_device *ide_devices[HV_MAX_IDE_DEVICES];
> +
> +static void storvsc_get_ide_info(struct hv_device *dev, int *target, int *path)
> +{
> +	*target =
> +	dev->dev_instance.data[5] << 8 | dev->dev_instance.data[4];
> +
> +	*path =
> +	dev->dev_instance.data[3] << 24 | dev->dev_instance.data[2] << 16 |
> +	dev->dev_instance.data[1] << 8  | dev->dev_instance.data[0];

Pretty odd formatting, I'd rather do it as:

	*target =
		dev->dev_instance.data[5] << 8 |
		dev->dev_instance.data[4];

but more importanly what does path actually stand for here?  Opencoding
this into the caller and adding proper comments explaining the scheme
might be more readable.

> @@ -469,7 +517,6 @@ static int storvsc_queuecommand_lck(struct scsi_cmnd *scmnd,
>  	unsigned int sg_count = 0;
>  	struct vmscsi_request *vm_srb;
>  
> -
>  	/* If retrying, no need to prep the cmd */
>  	if (scmnd->host_scribble) {
>  
> @@ -707,7 +754,6 @@ static int storvsc_probe(struct hv_device *device)
>  		scsi_host_put(host);
>  		return -ENODEV;
>  	}
> -
>  	scsi_scan_host(host);
>  	return ret;

Completely unrelated whitespace changes.
