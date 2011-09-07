Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756014Ab1IGQDI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 12:03:08 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:36600 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755599Ab1IGQC1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 12:02:27 -0400
MIME-Version: 1.0
In-Reply-To: <4E67402D.2030302@ru.mvista.com>
References: <1315336919-2737-1-git-send-email-dpmcgee@gmail.com>
	<4E67402D.2030302@ru.mvista.com>
Date: Wed, 7 Sep 2011 11:02:25 -0500
Message-ID: <CAEik5nNNb3wLRmgPWEvYc0SpGb=hWoqLWXOKwSreq9PJ16PjkA@mail.gmail.com>
Subject: Re: [PATCH 1/2] pata_sis: extract a sis_port_base() method
From: Dan McGee <dpmcgee@gmail.com>
To: Sergei Shtylyov <sshtylyov@mvista.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jeff Garzik <jgarzik@pobox.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 7, 2011 at 4:58 AM, Sergei Shtylyov <sshtylyov@mvista.com> wrote:
> Hello.
>
> On 06-09-2011 23:21, Dan McGee wrote:
>
>> This is similar to the existing sis_old_port_base() method. We do this
>> same calculation and logic in multiple places (with one more to come in
>> a future patch), so extracting it into a method makes sense.
>
>> Reviewed-by: Bartlomiej Zolnierkiewicz<bzolnier@gmail.com>
>> Signed-off-by: Dan McGee<dpmcgee@gmail.com>
>> ---
>>  drivers/ata/pata_sis.c |   46
>> ++++++++++++++++++++++++++++------------------
>>  1 files changed, 28 insertions(+), 18 deletions(-)
>
>> diff --git a/drivers/ata/pata_sis.c b/drivers/ata/pata_sis.c
>> index 533f2ae..9374400 100644
>> --- a/drivers/ata/pata_sis.c
>> +++ b/drivers/ata/pata_sis.c
>> @@ -89,6 +89,29 @@ static int sis_old_port_base(struct ata_device *adev)
>> +       /* If bit 14 is set then the registers are mapped at 0x70 not 0x40
>> */
>> +       pci_read_config_dword(pdev, 0x54,&reg54);
>> +       if (reg54 & 0x40000000)
>
>   This is bit 30, not bit 14.
You've snipped the rest of the patch where I simply cut this comment
from the three other places it was stated. I'm simply moving code and
text around here. I will update the apparently erroneous comment.

>
>> +               port = 0x70;
>> +
>> +       return  port + (8 * ap->port_no) +  (4 * adev->devno);
>
>   Why two spaces at some places?
It is from the odd style of the method right above it. This driver has
a lot of odd styling. I'll "fix" it.

>
> [...]
>>
>> @@ -465,21 +482,14 @@ static void sis_133_early_set_dmamode (struct
>> ata_port *ap, struct ata_device *a
>>  static void sis_133_set_dmamode (struct ata_port *ap, struct ata_device
>> *adev)
>>  {
>>        struct pci_dev *pdev    = to_pci_dev(ap->host->dev);
>> -       int speed = adev->dma_mode - XFER_MW_DMA_0;
>
>   Unrelated change.
In context this change makes perfect sense- I'm cleaning up the rest
of the locals after extracting the method, and this one is out of
place and a totally dead assignment.

>
> [...]
>>
>> @@ -487,7 +497,7 @@ static void sis_133_set_dmamode (struct ata_port *ap,
>> struct ata_device *adev)
>>                /* FIXME: need data sheet to add MWDMA here. Also lacking
>> on
>>                   ide/pci driver */
>>        } else {
>> -               speed = adev->dma_mode - XFER_UDMA_0;
>> +               int speed = adev->dma_mode - XFER_UDMA_0;
>
>   Same here.
>
> WBR, Sergei
