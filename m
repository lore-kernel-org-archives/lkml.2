Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756255Ab0FGMVq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jun 2010 08:21:46 -0400
Received: from mail-ew0-f223.google.com ([209.85.219.223]:47837 "EHLO
	mail-ew0-f223.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751983Ab0FGMVo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jun 2010 08:21:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=tj6rE2UcceijrHQIuW2piWlK4FCXInCGVLf0vpLJUn5IsJBRvJozt8XBoTqsCjEtdR
         Z4b+IXDYaQr3BEg9VJrBzz8fVBscfOfZIBNpxP0Q7E6B1Yh3JB3TGyJI/yIKaszpl8sf
         SGUUj4VALsTP6VjochS2OeuWFKvkBpenidC1w=
MIME-Version: 1.0
In-Reply-To: <4C0CBA5D.5000900@kernel.org>
References: <AANLkTiktNufXK_pn6mP2-zyowAIbHlUy5TGu3AtpALv-@mail.gmail.com>
	<20100603020006.GB19123@srcf.ucam.org>
	<AANLkTikpv86r5BBPCEOHujpm8uCgY0DxghSKjBufBWiM@mail.gmail.com>
	<4C08760B.8050002@gmail.com>
	<AANLkTimFY5YQv8DC-zTQ1RF84rno6svvcyLzHGWL6HOk@mail.gmail.com>
	<AANLkTimXcF1pafrSt8dMbUs59AjnqaRwpzDnPIPjdjsn@mail.gmail.com>
	<AANLkTinZ7d3WWyO3m9A7GVnaTuSbn1G33ADFW6ixywcT@mail.gmail.com>
	<AANLkTinIM8swHZTide7MAQsaYbWcFD90FrKUXE9NFG-5@mail.gmail.com>
	<4C0CBA5D.5000900@kernel.org>
Date: Mon, 7 Jun 2010 08:21:42 -0400
Message-ID: <AANLkTilwtazg_T4cX2EMb2xterwV1lhXdqUe3Q1UcsDN@mail.gmail.com>
Subject: Re: Hang during boot, bisected to commit 96d60303fd
From: Marc Dionne <marc.c.dionne@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: Robert Hancock <hancockrwd@gmail.com>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-ide@vger.kernel.org, garzik@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 7, 2010 at 5:22 AM, Tejun Heo <tj@kernel.org> wrote:
> Hello,
>
> On 06/07/2010 06:34 AM, Robert Hancock wrote:
>> I'm thinking that the hardreset and device classification makes more
>> sense as a place to do this anyways, since that's the point where we
>> really know if there's a device connected or not.. Tejun, any
>> thoughts?
>
> Heh, of course it doesn't work.  Device presence can't be reliably
> determined by sampling status once like that.  We don't have all the
> crap in libata-eh for nothing.  :-)
>
> Marc, can you please try the following patch?
>
> Thanks.
>
> diff --git a/drivers/ata/libahci.c b/drivers/ata/libahci.c
> index 1984a6e..261f86d 100644
> --- a/drivers/ata/libahci.c
> +++ b/drivers/ata/libahci.c
> @@ -541,29 +541,11 @@ static int ahci_scr_write(struct ata_link *link, unsigned int sc_reg, u32 val)
>        return -EINVAL;
>  }
>
> -static int ahci_is_device_present(void __iomem *port_mmio)
> -{
> -       u8 status = readl(port_mmio + PORT_TFDATA) & 0xff;
> -
> -       /* Make sure PxTFD.STS.BSY and PxTFD.STS.DRQ are 0 */
> -       if (status & (ATA_BUSY | ATA_DRQ))
> -               return 0;
> -
> -       /* Make sure PxSSTS.DET is 3h */
> -       status = readl(port_mmio + PORT_SCR_STAT) & 0xf;
> -       if (status != 3)
> -               return 0;
> -       return 1;
> -}
> -
>  void ahci_start_engine(struct ata_port *ap)
>  {
>        void __iomem *port_mmio = ahci_port_base(ap);
>        u32 tmp;
>
> -       if (!ahci_is_device_present(port_mmio))
> -               return;
> -
>        /* start DMA */
>        tmp = readl(port_mmio + PORT_CMD);
>        tmp |= PORT_CMD_START;
> @@ -1892,6 +1874,9 @@ static void ahci_error_handler(struct ata_port *ap)
>        }
>
>        sata_pmp_error_handler(ap);
> +
> +       if (!ata_dev_enabled(ap->link.device))
> +               ahci_stop_engine(ap);
>  }
>
>  static void ahci_post_internal_cmd(struct ata_queued_cmd *qc)
>
> --
> tejun

Hi Tejun,

With that patch the system boots normally.  Out of curiosity I also
instrumented ahci_error_handler a bit, and the stop_engine case
triggers once for the 6 unused ports, but doesn't trigger for the 2
ports with devices (SSD and DVD), as expected.

Feel free to add a Tested-by if you submit it.

Thanks,
Marc
