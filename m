Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756504Ab1BJOZA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 09:25:00 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:61722 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756211Ab1BJOY6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 09:24:58 -0500
Message-ID: <4D53F4ED.10903@ru.mvista.com>
Date: Thu, 10 Feb 2011 17:23:41 +0300
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-GB; rv:1.9.2.13) Gecko/20101207 Thunderbird/3.1.7
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
CC: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 05/20] pata_efar: always program master_data before slave_data
References: <20110208122314.19110.4092.sendpatchset@linux-mhg7.site> <20110208122409.19110.4233.sendpatchset@linux-mhg7.site>
In-Reply-To: <20110208122409.19110.4233.sendpatchset@linux-mhg7.site>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 08-02-2011 15:24, Bartlomiej Zolnierkiewicz wrote:
[...]

> We may need to set SITRE before programming slave_data.

> This makes pata_efar match the behavior of IDE's slc90e66 host driver
> and also of libata's ata_piix one.

> Signed-off-by: Bartlomiej Zolnierkiewicz<bzolnier@gmail.com>
[...]

> diff --git a/drivers/ata/pata_efar.c b/drivers/ata/pata_efar.c
> index 1e2ff7d..7f564d7 100644
> --- a/drivers/ata/pata_efar.c
> +++ b/drivers/ata/pata_efar.c
> @@ -74,10 +74,12 @@ static void efar_set_timings(struct ata_port *ap, struct ata_device *adev,
>   			     u8 pio, bool use_mwdma)
>   {
>   	struct pci_dev *dev	= to_pci_dev(ap->host->dev);
> +	unsigned int is_slave	= (adev->devno != 0);

    What's the point of this variable? To save one pointer dereference? :-)

>   	unsigned long flags;
>   	u8 master_port		= ap->port_no ? 0x42 : 0x40;
>   	u16 master_data;
>   	u8 udma_enable;
> +	u8 slave_data;
>   	int control = 0;
>
>   	/*
> @@ -110,14 +112,13 @@ static void efar_set_timings(struct ata_port *ap, struct ata_device *adev,
>   	pci_read_config_word(dev, master_port,&master_data);
>
>   	/* Set PPE, IE, and TIME as appropriate */
> -	if (adev->devno == 0) {
> +	if (is_slave == 0) {

    !is_slave appeals more to me. :-)

> @@ -126,12 +127,14 @@ static void efar_set_timings(struct ata_port *ap, struct ata_device *adev,
>   		pci_read_config_byte(dev, 0x44,&slave_data);
>   		slave_data&= ap->port_no ? 0x0F : 0xF0;
>   		slave_data |= ((timings[pio][0]<<  2) | timings[pio][1])<<  shift;
> -		pci_write_config_byte(dev, 0x44, slave_data);
>   	}
>
>   	master_data |= 0x4000;	/* Ensure SITRE is set */
>   	pci_write_config_word(dev, master_port, master_data);
>
> +	if (is_slave)
> +		pci_write_config_byte(dev, 0x44, slave_data);
> +
>   	pci_read_config_byte(dev, 0x48,&udma_enable);
>   	udma_enable&= ~(1<<  (2 * ap->port_no + adev->devno));
>   	pci_write_config_byte(dev, 0x48, udma_enable);

WBR, Sergei
