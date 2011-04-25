Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758266Ab1DYK16 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 06:27:58 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:33461 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758208Ab1DYK15 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 06:27:57 -0400
Message-ID: <4DB54C49.7020604@ru.mvista.com>
Date: Mon, 25 Apr 2011 14:26:17 +0400
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-GB; rv:1.9.2.15) Gecko/20110303 Thunderbird/3.1.9
MIME-Version: 1.0
To: Jian Peng <jipeng2005@gmail.com>
CC: Jeff Garzik <jgarzik@pobox.com>, Tejun Heo <htejun@gmail.com>,
        linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] libata: ahci_start_engine compliant to AHCI spec
References: <1303541890-14528-1-git-send-email-jipeng2005@gmail.com>
In-Reply-To: <1303541890-14528-1-git-send-email-jipeng2005@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 23-04-2011 10:58, Jian Peng wrote:

> At the end of section 10.1 of AHCI spec (rev 1.3), it states

> Software shall not set PxCMD.ST to 1 until it is determined that
> a functoinal device is present on the port as determined by
> PxTFD.STS.BSY=0, PxTFD.STS.DRQ=0 and PxSSTS.DET=3h

> Even though most AHCI host controller works without this check,

    "Most" requires plural noun, no?

> specific controller will fail under this condition.

> Signed-off-by: Jian Peng<jipeng2005@gmail.com>
[...]

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
> +	status = readl(port_mmio + PORT_TFDATA) & 0xFF;

    Masking is not necessary.

> +
> +	/*
> +	 * At end of section 10.1 of AHCI spec (rev 1.3), it states
> +	 * Software shall not set PxCMD.ST to 1 until it is determined
> +	 * that a functoinal device is present on the port as determined by
> +	 * PxTFD.STS.BSY=0, PxTFD.STS.DRQ=0 and PxSSTS.DET=3h
> +	 *
> +	 * Even though most AHCI host controllers work without this check,

    Same about grammar here.

> +	 * specific controller will fail under this condition
> +	 */
> +	if (status&  (ATA_BUSY | ATA_DRQ))
> +		return;
> +	else {

    {} should be used on both branches, according to CodingStyle.

WBR, Sergei
