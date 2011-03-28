Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932213Ab1C1TaJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 15:30:09 -0400
Received: from mx4.wp.pl ([212.77.101.8]:10926 "EHLO mx4.wp.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754735Ab1C1TaH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 15:30:07 -0400
Date: Mon, 28 Mar 2011 21:29:55 +0200
From: Stanislaw Gruszka <stf_xl@wp.pl>
To: Igor Plyatov <plyatov@gmail.com>
Cc: Jeff Garzik <jgarzik@pobox.com>, linux-ide@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] ata: pata_at91.c bugfix for high master clock
Message-ID: <20110328192955.GA2291@localhost.localdomain>
References: <1301313595-23156-1-git-send-email-plyatov@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1301313595-23156-1-git-send-email-plyatov@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-WP-AV: skaner antywirusowy poczty Wirtualnej Polski S. A.
X-WP-SPAM: NO 0000000 [wQME]                               
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 28, 2011 at 03:59:55PM +0400, Igor Plyatov wrote:
> The AT91SAM9 microcontrollers with master clock higher then 105 MHz
> and PIO0, have overflow of the NCS_RD_PULSE value in the MSB. This
> lead to "NCS_RD_PULSE" pulse longer then "NRD_CYCLE" pulse and driver
> does not detect ATA device.
> 
> Signed-off-by: Igor Plyatov <plyatov@gmail.com>
> ---
>  drivers/ata/pata_at91.c |    8 +++++++-
>  1 files changed, 7 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/ata/pata_at91.c b/drivers/ata/pata_at91.c
> index d1aaeb5..3c2bf86 100644
> --- a/drivers/ata/pata_at91.c
> +++ b/drivers/ata/pata_at91.c
> @@ -33,11 +33,12 @@
>  
>  
>  #define DRV_NAME "pata_at91"
> -#define DRV_VERSION "0.1"
> +#define DRV_VERSION "0.2"
>  
>  #define CF_IDE_OFFSET	    0x00c00000
>  #define CF_ALT_IDE_OFFSET   0x00e00000
>  #define CF_IDE_RES_SIZE     0x08
> +#define NCS_RD_PULSE_LIMIT  0x3f /* maximal value for pulse bitfields */
>  
>  struct at91_ide_info {
>  	unsigned long mode;
> @@ -110,6 +111,11 @@ static void set_smc_timing(struct device *dev,
>  	/* (CS0, CS1, DIR, OE) <= (CFCE1, CFCE2, CFRNW, NCSX) timings */
>  	ncs_read_setup = 1;
>  	ncs_read_pulse = read_cycle - 2;
> +	if (ncs_read_pulse > NCS_RD_PULSE_LIMIT) {
> +		ncs_read_pulse = NCS_RD_PULSE_LIMIT;

It's ATA specification break, I explained this already here:
http://marc.info/?l=linux-ide&m=129254321006232&w=2
Do we want fix that do not conform specification?

Stanislaw
