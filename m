Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754741Ab1EWMNS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 08:13:18 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:57538 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754555Ab1EWMNQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 08:13:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Se58TkkpCSMbe1NyyNnW+p1h+NSahE4FSKXfzjjB17/xv+V/503Eaz/NMGhVxJlRib
         sE72F7GAo4ivfXdV42cYxWx73JGNWiScjojMTQgSHgO/P5bo4LAN+TRbhqHV4xS2EjQ4
         8yYJrqXbvQGvyTjq7rZ1HSLfFf9gO9ClIDSLI=
Date: Mon, 23 May 2011 14:13:10 +0200
From: Tejun Heo <tj@kernel.org>
To: Jian Peng <jipeng2005@gmail.com>
Cc: Valdis.Kletnieks@vt.edu, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Jeff Garzik <jgarzik@pobox.com>,
        Michael Leun <lkml20100708@newton.leun.net>, linux-ide@vger.kernel.org,
        Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2.6.38-rc7] Revert "libata: ahci_start_engine
 compliant to AHCI spec"
Message-ID: <20110523121310.GA24439@htj.dyndns.org>
References: <201105120025.34531.rjw@sisk.pl>
 <20633.1305565337@localhost>
 <BANLkTin7NgUMXSVyKn6P0TCrFZ5uaaRL1w@mail.gmail.com>
 <201105182144.37713.rjw@sisk.pl>
 <BANLkTimZ9pe-FhkJYHTG1Jx8MUPrMHSFbA@mail.gmail.com>
 <BANLkTim9_1Xt8oE4awbCO1iKUW96YUOv_A@mail.gmail.com>
 <10124.1305906020@localhost>
 <20110520154341.GL31426@htj.dyndns.org>
 <BANLkTi=iNjWsaYCJqP057FkhAXtab5nS=Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTi=iNjWsaYCJqP057FkhAXtab5nS=Q@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Fri, May 20, 2011 at 10:02:56AM -0700, Jian Peng wrote:
> Hi, Tejun/Valdis,
> 
> Since this is an interoperability issue of SATA host controller, the first
> step I want to try it to make sure the tweak that MAKE my controller WORK
> does not break other controllers.
> You are both right that adding this majic 5ms delay at this place should not
> be the final solution.
> 
> If this magic 5ms delay works on other affected systems, I plan to post a
> new patch that inside ahci_start_engine(), still perform same check, and
> show warning message if failed, but will set a flag, then still set START
> bit, and if there is such failure flag, add 5ms delay.

Yeah, sounds like a plan but please add ample comment explaining
what's going on for which controller including link to the mailing
list threads.  As we're basically adding a black magic, I would still
like to enable it only for the affected controllers so that we don't
have to worry whether there are controllers which are affected by this
problem but we don't know about.

> --- a/drivers/ata/libahci.c 2011-05-18 14:23:36.564665643 -0700
> +++ c/drivers/ata/libahci.c 2011-05-20 09:48:06.194663506 -0700
> @@ -540,6 +540,7 @@
>   void __iomem *port_mmio = ahci_port_base(ap);
>   u32 tmp;
>   u8 status;
> + int err = 0;

I think

 bool stat_failed = false;

would be more in line with recent coding style.

>   status = readl(port_mmio + PORT_TFDATA) & 0xFF;
> 
> @@ -553,12 +554,12 @@
>    * specific controller will fail under this condition
>    */
>   if (status & (ATA_BUSY | ATA_DRQ))
> -  return;
> +  err = 1;
>   else {
>    ahci_scr_read(&ap->link, SCR_STATUS, &tmp);
> 
>    if ((tmp & 0xf) != 0x3)
> -   return;
> +   err = 1;
>   }
> 
>   /* start DMA */
> @@ -566,6 +567,13 @@
>   tmp |= PORT_CMD_START;
>   writel(tmp, port_mmio + PORT_CMD);
>   readl(port_mmio + PORT_CMD); /* flush */
> +
> + /* Some controllers need longer time to be ready */
> + if(err) {
> +  printk(KERN_WARNING
> +   "Controller in wrong state when setting START bit\n");
> +  msleep(5);

 ata_port_printk()?

Thanks.

-- 
tejun
