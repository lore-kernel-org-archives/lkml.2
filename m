Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751924Ab1DWHIM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Apr 2011 03:08:12 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:37904 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751286Ab1DWHIK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Apr 2011 03:08:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=PBrtMCenHEDu0Zj1h4K4/0jwpPiDtGV5fkpOWaecBVlMrYKY2aDD1zoDsVRWraBgdz
         5ZITYYyd2yHlGBEdg3/LTKTMzhP0Bj4btyxiOovSUWXkpv5iwRWuDtOQvklqlT+xl5zj
         8xcNcns535Q1EV03BvSvBlw+vF2+wPOXPwWfg=
Message-ID: <4DB27AD4.2030403@pobox.com>
Date: Sat, 23 Apr 2011 03:08:04 -0400
From: Jeff Garzik <jgarzik@pobox.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110307 Fedora/3.1.9-0.39.b3pre.fc14 Thunderbird/3.1.9
MIME-Version: 1.0
To: Jian Peng <jipeng2005@gmail.com>
CC: Tejun Heo <htejun@gmail.com>, linux-ide@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] libata: ahci_start_engine compliant to AHCI spec
References: <1303541890-14528-1-git-send-email-jipeng2005@gmail.com>
In-Reply-To: <1303541890-14528-1-git-send-email-jipeng2005@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/23/2011 02:58 AM, Jian Peng wrote:
> At the end of section 10.1 of AHCI spec (rev 1.3), it states
>
> Software shall not set PxCMD.ST to 1 until it is determined that
> a functoinal device is present on the port as determined by
> PxTFD.STS.BSY=0, PxTFD.STS.DRQ=0 and PxSSTS.DET=3h
>
> Even though most AHCI host controller works without this check,
> specific controller will fail under this condition.
>
> Signed-off-by: Jian Peng<jipeng2005@gmail.com>
> ---
>   drivers/ata/libahci.c |   21 +++++++++++++++++++++
>   1 files changed, 21 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/ata/libahci.c b/drivers/ata/libahci.c
> index 26d4523..83ed544 100644
> --- a/drivers/ata/libahci.c
> +++ b/drivers/ata/libahci.c
> @@ -539,6 +539,27 @@ void ahci_start_engine(struct ata_port *ap)
>   {
>   	void __iomem *port_mmio = ahci_port_base(ap);
>   	u32 tmp;
> +	u8 status;
> +
> +	status = readl(port_mmio + PORT_TFDATA)&  0xFF;
> +
> +	/*
> +	 * At end of section 10.1 of AHCI spec (rev 1.3), it states
> +	 * Software shall not set PxCMD.ST to 1 until it is determined
> +	 * that a functoinal device is present on the port as determined by
> +	 * PxTFD.STS.BSY=0, PxTFD.STS.DRQ=0 and PxSSTS.DET=3h
> +	 *
> +	 * Even though most AHCI host controllers work without this check,
> +	 * specific controller will fail under this condition
> +	 */
> +	if (status&  (ATA_BUSY | ATA_DRQ))
> +		return;
> +	else {
> +		ahci_scr_read(&ap->link, SCR_STATUS,&tmp);
> +
> +		if ((tmp&  0xf) != 0x3)
> +			return;
> +	}

Looks good, I'll get this queued up...
