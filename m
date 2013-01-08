Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756975Ab3AHTHL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 14:07:11 -0500
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:21540 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756641Ab3AHTHJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 14:07:09 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 72.84.113.162
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX195Dxo+mHNP87GqwrbVxKHbJzYg1795ipQ=
Date: Tue, 8 Jan 2013 14:06:58 -0500
From: Jason Cooper <jason@lakedaemon.net>
To: Joshua Coombs <josh.coombs@gmail.com>
Cc: cooloney@gmail.com, rpurdie@rpsys.net, linux-leds@vger.kernel.org,
        linux-kernel@vger.kernel.org, jgarzik@pobox.com,
        linux-ide@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] Allow Marvell SATA driver to work with
 LEDS_TRIGGER_IDE_DISK
Message-ID: <20130108190657.GW5075@titan.lakedaemon.net>
References: <1357668987-3610-1-git-send-email-josh.coombs@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1357668987-3610-1-git-send-email-josh.coombs@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 08, 2013 at 01:16:27PM -0500, Joshua Coombs wrote:
> Add a call to the IDE LED Trigger within the Marvell SATA driver to allow
> Marvell SoC devices to show SATA activity via GPIO connected LEDs.
> 
> Signed-off-by: Joshua Coombs <josh.coombs@gmail.com>
> ---
>  drivers/ata/sata_mv.c | 3 +++
>  drivers/leds/Kconfig  | 3 +--
>  2 files changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/ata/sata_mv.c b/drivers/ata/sata_mv.c
> index 68f4fb5..4aaf6f0 100644
> --- a/drivers/ata/sata_mv.c
> +++ b/drivers/ata/sata_mv.c
> @@ -71,6 +71,7 @@
>  #include <scsi/scsi_cmnd.h>
>  #include <scsi/scsi_device.h>
>  #include <linux/libata.h>
> +#include <linux/leds.h>
>  
>  #define DRV_NAME	"sata_mv"
>  #define DRV_VERSION	"1.28"
> @@ -1156,6 +1157,8 @@ static void mv_start_edma(struct ata_port *ap, void __iomem *port_mmio,
>  {
>  	int want_ncq = (protocol == ATA_PROT_NCQ);
>  
> +	ledtrig_ide_activity();
> +
>  	if (pp->pp_flags & MV_PP_FLAG_EDMA_EN) {
>  		int using_ncq = ((pp->pp_flags & MV_PP_FLAG_NCQ_EN) != 0);
>  		if (want_ncq != using_ncq)
> diff --git a/drivers/leds/Kconfig b/drivers/leds/Kconfig
> index b58bc8a..d2071d0 100644
> --- a/drivers/leds/Kconfig
> +++ b/drivers/leds/Kconfig
> @@ -496,10 +496,9 @@ config LEDS_TRIGGER_ONESHOT
>  
>  config LEDS_TRIGGER_IDE_DISK
>  	bool "LED IDE Disk Trigger"
> -	depends on IDE_GD_ATA
>  	depends on LEDS_TRIGGERS
>  	help
> -	  This allows LEDs to be controlled by IDE disk activity.
> +	  This allows LEDs to be controlled by IDE or SATA disk activity.
>  	  If unsure, say Y.
>  
>  config LEDS_TRIGGER_HEARTBEAT


Hmmm, I'm not sure about this.  Ideally, wouldn't all sata users want to
have this option?  In which case, it should be changed to
LEDS_TRIGGER_DISK_IO or similar.  However, this seems to be the first
attempt at it:

$ git grep ledtrig_ide_activity -- drivers/ata/*.c
...nada...
$ 

At any rate, I'd like to see this patch extended to facilitate other
sata drivers using it.  eg adjusting the naming more appropriately, and
'depends on IDE_GD_ATA || ATA' or similar.  In it's current state, it
should depend on IDE_GD_ATA || SATA_MV.

thx,

Jason.
