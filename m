Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756207Ab0LHSxA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 13:53:00 -0500
Received: from hera.kernel.org ([140.211.167.34]:37739 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754912Ab0LHSw7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 13:52:59 -0500
Message-ID: <4CFFD3EB.10800@kernel.org>
Date: Wed, 08 Dec 2010 19:52:27 +0100
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.12) Gecko/20101027 Lightning/1.0b2 Thunderbird/3.1.6
MIME-Version: 1.0
To: Jian Peng <jipeng@broadcom.com>
CC: Robert Hancock <hancockrwd@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "jgarzik@pobox.com" <jgarzik@pobox.com>,
        ide <linux-ide@vger.kernel.org>
Subject: Re: questions regarding possible violation of AHCI spec in AHCI driver
References: <E18F441196CA634DB8E1F1C56A50A874319F70C1F2@IRVEXCHCCR01.corp.ad.broadcom.com> <4CFEE569.4030204@gmail.com> <4CFF58D2.4040006@kernel.org> <E18F441196CA634DB8E1F1C56A50A874319FA38C43@IRVEXCHCCR01.corp.ad.broadcom.com>,<4CFFCD56.6050608@kernel.org> <E18F441196CA634DB8E1F1C56A50A874319FA7E36E@IRVEXCHCCR01.corp.ad.broadcom.com>
In-Reply-To: <E18F441196CA634DB8E1F1C56A50A874319FA7E36E@IRVEXCHCCR01.corp.ad.broadcom.com>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 08 Dec 2010 18:52:28 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 12/08/2010 07:48 PM, Jian Peng wrote:
> So it is reasonable to add extra check in ahci_start_engine() without returning status of ST bit. If so, here is my patch
> 
> --- libahci.c.orig	2010-12-08 10:42:48.383976763 -0800
> +++ libahci.c	2010-12-08 10:45:17.495156944 -0800
> @@ -542,6 +542,13 @@
>  {
>  	void __iomem *port_mmio = ahci_port_base(ap);
>  	u32 tmp;
> +	u8 status = readl(port_mmio + PORT_TFDATA) & 0xFF;
> +
> +	/* avoid race condition per spec (end of section 10.1.2) */
> +	if (status & (ATA_BUSY | ATA_DRQ) ||
> +	    ahci_scr_read(&ap->link, SCR_STATUS, &tmp) ||
> +	    (tmp & 0x0f) != 0x03)
> +		return;
>  
>  	/* start DMA */
>  	tmp = readl(port_mmio + PORT_CMD);

Yes, it is reasonable but I want to see that it actually fixes
something.  There are just too many controllers which use this path to
blindly apply the above change and given my previous explanation even
without the above change any ahci controller _should_ work fine.

Thanks.

-- 
tejun
