Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757947Ab1JEHfR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Oct 2011 03:35:17 -0400
Received: from mail.sf-mail.de ([62.27.20.61]:52073 "EHLO mail.sf-mail.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752624Ab1JEHfQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Oct 2011 03:35:16 -0400
Message-ID: <d97a34694e741dc6a2a71fbcd49bab49.squirrel@webmail.sf-mail.de>
In-Reply-To: <20111005055046.GD32077@elgon.mountain>
References: <20111005055046.GD32077@elgon.mountain>
Date: Wed, 5 Oct 2011 09:35:13 +0200
Subject: Re: [patch] [SCSI] aacraid: use lower snprintf() limit
From: "Rolf Eike Beer" <eike-kernel@sf-tec.de>
To: "Dan Carpenter" <dan.carpenter@oracle.com>
Cc: "Adaptec OEM Raid Solutions" <aacraid@adaptec.com>,
        "James E.J. Bottomley" <jbottomley@parallels.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
User-Agent: SquirrelMail/1.4.22
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This is just a cleanup, to silence static checker warnings.  It
> doesn't change how the code works.
>
> buf[] can either be BUF_SIZE if this is called from sysfs, or it can
> be 16 if it's called from aac_get_adapter_info() via
> aac_get_serial_number().  We use the smaller limit here.
>
> sizeof(dev->supplement_adapter_info.MfgPcbaSerialNo) is 12 so there
> is actually no chance of hitting either limit.
>
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
>
> diff --git a/drivers/scsi/aacraid/linit.c b/drivers/scsi/aacraid/linit.c
> index 3382475..ea8d96e 100644
> --- a/drivers/scsi/aacraid/linit.c
> +++ b/drivers/scsi/aacraid/linit.c
> @@ -894,15 +894,20 @@ static ssize_t aac_show_serial_number(struct device
> *device,
>  	int len = 0;
>
>  	if (le32_to_cpu(dev->adapter_info.serial[0]) != 0xBAD0)
> -		len = snprintf(buf, PAGE_SIZE, "%06X\n",
> +		len = snprintf(buf, 16, "%06X\n",
>  		  le32_to_cpu(dev->adapter_info.serial[0]));
>  	if (len &&
>  	  !memcmp(&dev->supplement_adapter_info.MfgPcbaSerialNo[
>  	    sizeof(dev->supplement_adapter_info.MfgPcbaSerialNo)-len],
>  	  buf, len-1))
> -		len = snprintf(buf, PAGE_SIZE, "%.*s\n",
> +		len = snprintf(buf, 16, "%.*s\n",
>  		  (int)sizeof(dev->supplement_adapter_info.MfgPcbaSerialNo),
>  		  dev->supplement_adapter_info.MfgPcbaSerialNo);
> +
> +

One newline too much.

> +	if (len > 16)
> +		len = 16;

max()?

Eike
