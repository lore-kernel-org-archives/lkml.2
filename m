Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757544Ab0HCSmx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 14:42:53 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:25664 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753991Ab0HCSmv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 14:42:51 -0400
Date: Tue, 3 Aug 2010 11:41:05 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Mark Knecht <markknecht@gmail.com>
Cc: Tejun Heo <tj@kernel.org>, Paul Check <paul@thechecks.ca>,
        Linux Kernel List <linux-kernel@vger.kernel.org>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>
Subject: Re: Drives missing at boot
Message-Id: <20100803114105.7f199878.randy.dunlap@oracle.com>
In-Reply-To: <AANLkTinwJLE=jjwG5zL8UBO91tzDpX36_W9GORKag8RK@mail.gmail.com>
References: <AANLkTimVkG9TFgyOTTnrztBjqT4JoOzFaP268vWLAAm9@mail.gmail.com>
	<AANLkTinBn35687znO2_IxI3s1opkXrG2HpCRgsejNbMq@mail.gmail.com>
	<4C2F61AB.9030806@kernel.org>
	<AANLkTilYOT45q8OUJ-_V61_fnYy9HIk6GAv5ZPiomCaT@mail.gmail.com>
	<4C317C04.20500@kernel.org>
	<AANLkTilupyieml9yaWO9BUNPmQQ0g2w1HLWj6R9MwDZf@mail.gmail.com>
	<4C32CE50.6010501@kernel.org>
	<AANLkTikehTO1j6Gd7Y_g32_P6Yg9KB8Z8qwbNJh10aOU@mail.gmail.com>
	<4C341598.6040004@kernel.org>
	<AANLkTik4zkcIyVxwtX8GA1BsQSZaAeODpPlY3mRVBc-4@mail.gmail.com>
	<4C34A1D5.1090202@kernel.org>
	<AANLkTilgQSu3qi7qoTtjnV22r-8Sh1hbDAB_nlPImWNt@mail.gmail.com>
	<4C34B8BE.5080504@kernel.org>
	<AANLkTilDbrA6lLPSOAtA8_4mLNkUZibHweTliqU5jd03@mail.gmail.com>
	<4C44BD42.3030904@kernel.org>
	<7141c88bc8c27f26c2187252c0594318.squirrel@thechecks.ca>
	<4C45AF40.7030800@kernel.org>
	<AANLkTinxDjPCk46eItZrXziTbf6efqvNNNTbkZDXIbns@mail.gmail.com>
	<4C483BF4.3090006@kernel.org>
	<AANLkTinwJLE=jjwG5zL8UBO91tzDpX36_W9GORKag8RK@mail.gmail.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090205.4C586324.0129:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2 Aug 2010 15:07:11 -0700 Mark Knecht wrote:

> On Thu, Jul 22, 2010 at 5:39 AM, Tejun Heo <tj@kernel.org> wrote:
> 
> Hi Tejun,
>    I'm finally home and trying to get back to this. I'm really a bad
> programmer so I don't know what I've done wrong but it seems patch
> isn't happy with me.
> 
> c2stable linux # patch --dry-run -p1 <../ata_piix-sidpr-lock.patch
> patching file drivers/ata/ata_piix.c
> patch: **** malformed patch at line 13:

Whenever the patch file was saved on this system, line 13 of it was
split (probably by an email client).  Whenever I see this, I just
join (merge) that line and the next one and try again... sometimes
several lines are malformed and have to be fixed like this.

> 
> c2stable linux #
> 
>    Here's the change I tried to make to a copy of the file:
> 
> c2stable linux # cat ../ata_piix-sidpr-lock.patch
> diff --git a/drivers/ata/ata_piix.c b/drivers/ata/ata_piix.c
> index 7409f98..3971bc0 100644
> --- a/drivers/ata/ata_piix.c
> +++ b/drivers/ata/ata_piix.c
> @@ -158,6 +158,7 @@ struct piix_map_db {
>  struct piix_host_priv {
>         const int *map;
>         u32 saved_iocfg;
> +       spinlock_t sidpr_lock;  /* FIXME: remove once locking in EH is fixed */
> +       printk("MWK - ata_sidpr patch applied!\n");
>         void __iomem *sidpr;
>  };
> 
> @@ -951,12 +952,15 @@ static int piix_sidpr_scr_read(struct ata_link *link,
>                                unsigned int reg, u32 *val)
>  {
>         struct piix_host_priv *hpriv = link->ap->host->private_data;
> +       unsigned long flags;
> 
>         if (reg >= ARRAY_SIZE(piix_sidx_map))
>                 return -EINVAL;
> 
> +       spin_lock_irqsave(&hpriv->sidpr_lock, flags);
>         piix_sidpr_sel(link, reg);
>         *val = ioread32(hpriv->sidpr + PIIX_SIDPR_DATA);
> +       spin_unlock_irqrestore(&hpriv->sidpr_lock, flags);
>         return 0;
>  }
> 
> @@ -964,12 +968,15 @@ static int piix_sidpr_scr_write(struct ata_link *link,
>                                 unsigned int reg, u32 val)
>  {
>         struct piix_host_priv *hpriv = link->ap->host->private_data;
> +       unsigned long flags;
> 
>         if (reg >= ARRAY_SIZE(piix_sidx_map))
>                 return -EINVAL;
> 
> +       spin_lock_irqsave(&hpriv->sidpr_lock, flags);
>         piix_sidpr_sel(link, reg);
>         iowrite32(val, hpriv->sidpr + PIIX_SIDPR_DATA);
> +       spin_unlock_irqrestore(&hpriv->sidpr_lock, flags);
>         return 0;
>  }
> 
> @@ -1566,6 +1573,7 @@ static int __devinit piix_init_one(struct pci_dev *pdev,
>         hpriv = devm_kzalloc(dev, sizeof(*hpriv), GFP_KERNEL);
>         if (!hpriv)
>                 return -ENOMEM;
> +       spin_lock_init(&hpriv->sidpr_lock);
> 
>         /* Save IOCFG, this will be used for cable detection, quirk
>          * detection and restoration on detach.  This is necessary
> c2stable linux #
> 
>    Maybe you can shoot back something that's done correctly and I'll
> start testing.
> 
>    I've tried booting a few times. I've had 3 cold boot failures so
> far. No warm boot failures. Each time it failed on cold boot a warm
> boot fixed it.


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
