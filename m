Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756571Ab2D3TWZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2012 15:22:25 -0400
Received: from citesht3.cites.illinois.edu ([192.17.212.153]:16986 "EHLO
	citesht3.cites.illinois.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755999Ab2D3TWY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2012 15:22:24 -0400
Message-ID: <4F9EE66E.1090009@illinois.edu>
Date: Mon, 30 Apr 2012 14:22:22 -0500
From: Matt Johnson <johnso87@illinois.edu>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120410 Thunderbird/11.0.1
MIME-Version: 1.0
To: <jgarzik@pobox.com>
CC: <linux-kernel@vger.kernel.org>, <linux-ide@vger.kernel.org>
Subject: Re: [PATCH 1/1] ahci: Detect Marvell 88SE9172 SATA controller
References: <4F9A3FD6.7060206@illinois.edu>
In-Reply-To: <4F9A3FD6.7060206@illinois.edu>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For a bit more context, the Z68X-UD3H-B3 has the SATA controllers provided
by the Z68 chipset plus an extra 2 SATA3 ports from a Marvell 88SE9172-NNX2.
The 4 lines on the chip on my board read:
88SE9172-NNX2
PAY4850.3
1116 A1P
TW

It seems that this chip is used on other boards as well
(see http://www.techpowerup.com/reviews/Gigabyte/G1_Sniper2/5.html).
I'm not sure whether 88SE9172-NNX2 is a distinct part from the 88SE9172, or
whether the 'NNX2' is manufacturing metadata.
In any case, drives connected to these 2 ports are not recognized at 
boot time
in the latest kernel.  I put /boot and the bootloader on a drive attached to
one of the Marvell ports.  Grub worked fine, but I couldn't boot the kernel;
it just dumped me to busybox.  Once in busybox, I could mount the drive with
'echo 1b4b 917a > /sys/bus/pci/drivers/ahci/new_id', and Ctrl+d would exit
busybox and boot the kernel successfully.

Others have run into similar issues (see
http://theangryangel.co.uk/blog/marvell-88se9172-sata3-under-linux-as-of-320 
,
which has been copy-pasted onto the Marvell chipset Wikipedia page
http://en.wikipedia.org/wiki/List_of_Marvell_Technology_Group_chipsets ).
The PCI ID suggested in the linked page (1b4b 9192) didn't work for me,
which suggests that either the poster's chip was not a 88se9172, there
are multiple revs of 88se9172 with different PCI IDs, or the -NNX2 is a
distinct model with its own PCI ID.

In any case, I think accepting this patch will make boards like mine work in
the near term, and we can add additional PCI IDs and clarify the comments
for similar chips as people report them or as we get clarification from
Marvell.

With this patch, the vanilla and Ubuntu kernels both boot flawlessly with
the boot partition hanging off the Marvell controller.

Thanks,
Matt

On 04/27/2012 01:42 AM, Matt Johnson wrote:
> The Marvell 88SE9172 SATA controller (PCI ID 1b4b 917a) already worked
> once it was detected, but was missing an ahci_pci_tbl entry.
>
> Boot tested on a Gigabyte Z68X-UD3H-B3 motherboard.
>
> Signed-off-by: Matt Johnson <johnso87@illinois.edu>
> ---
>  drivers/ata/ahci.c |    2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
> index 79a1e9d..ebaf67e 100644
> --- a/drivers/ata/ahci.c
> +++ b/drivers/ata/ahci.c
> @@ -394,6 +394,8 @@ static const struct pci_device_id ahci_pci_tbl[] = {
>           .driver_data = board_ahci_yes_fbs },                  /* 
> 88se9128 */
>         { PCI_DEVICE(0x1b4b, 0x9125),
>           .driver_data = board_ahci_yes_fbs },                  /* 
> 88se9125 */
> +       { PCI_DEVICE(0x1b4b, 0x917a),
> +         .driver_data = board_ahci_yes_fbs },                  /* 
> 88se9172 */
>         { PCI_DEVICE(0x1b4b, 0x91a3),
>           .driver_data = board_ahci_yes_fbs },
>

