Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756129Ab0LHTzr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 14:55:47 -0500
Received: from hera.kernel.org ([140.211.167.34]:34380 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755862Ab0LHTzp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 14:55:45 -0500
Message-ID: <4CFFE29C.7080205@kernel.org>
Date: Wed, 08 Dec 2010 20:55:08 +0100
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.12) Gecko/20101027 Lightning/1.0b2 Thunderbird/3.1.6
MIME-Version: 1.0
To: Jian Peng <jipeng@broadcom.com>
CC: Robert Hancock <hancockrwd@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "jgarzik@pobox.com" <jgarzik@pobox.com>,
        ide <linux-ide@vger.kernel.org>
Subject: Re: questions regarding possible violation of AHCI spec in AHCI driver
References: <E18F441196CA634DB8E1F1C56A50A874319F70C1F2@IRVEXCHCCR01.corp.ad.broadcom.com> <4CFEE569.4030204@gmail.com> <4CFF58D2.4040006@kernel.org> <E18F441196CA634DB8E1F1C56A50A874319FA38C43@IRVEXCHCCR01.corp.ad.broadcom.com>,<4CFFCD56.6050608@kernel.org> <E18F441196CA634DB8E1F1C56A50A874319FA7E36E@IRVEXCHCCR01.corp.ad.broadcom.com>,<4CFFD3EB.10800@kernel.org> <E18F441196CA634DB8E1F1C56A50A874319FA7E36F@IRVEXCHCCR01.corp.ad.broadcom.com>
In-Reply-To: <E18F441196CA634DB8E1F1C56A50A874319FA7E36F@IRVEXCHCCR01.corp.ad.broadcom.com>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 08 Dec 2010 19:55:10 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 12/08/2010 08:49 PM, Jian Peng wrote:
> I agree. I have AHCI based PCI card using HBA from Marvell, Via and
> Silicon Image, and am going to test my patch.  Before this patch can
> be applied universally, I like to use it for specific PCI_VENDOR_ID
> first. Here is my new patch to limit it to Broadcom's AHCI core

Hmmm... is the change actually necessary for broadcom controllers?  As
I wrote before, any ahci controller should just work without the above
checks because,

> +	/* avoid race condition per spec (end of section 10.1.2) */
> +	if (pdev->vendor == PCI_VENDOR_ID_BROADCOM) {
> +		u8 status = readl(port_mmio + PORT_TFDATA) & 0xFF;
> +
> +		if (status & (ATA_BUSY | ATA_DRQ) ||
> +		    ahci_scr_read(&ap->link, SCR_STATUS, &tmp) ||
> +		    (tmp & 0x0f) != 0x03)
> +			return;

PHY event can occur here which causes the device to send D2H Reg FIS
w/ BSY set.

1. So, the controller _MUST NOT_ fail in irrecoverable way even if the
   driver sets ST while BSY is set.

2. The driver guarantees the final ST setting before entering normal
   operation is done when the prerequisites are met.

If you combine 1 and 2, the current behavior is perfectly fine.  Do
broadcom controllers actually fail without the above change?

Thanks.

-- 
tejun
