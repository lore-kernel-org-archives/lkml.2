Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755247Ab1B1UdS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 15:33:18 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:37409 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755190Ab1B1UdP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 15:33:15 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Johan Wessfeldt <johan.wessfeldt@gmail.com>
Subject: Re: [PATCH] acpi: Corrections of unchecked calls to request_region
Date: Mon, 28 Feb 2011 21:33:04 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.38-rc6+; KDE/4.4.4; x86_64; ; )
Cc: lenb@kernel.org, linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1298923008-16796-1-git-send-email-johan.wessfeldt@gmail.com>
In-Reply-To: <1298923008-16796-1-git-send-email-johan.wessfeldt@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <201102282133.04533.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, February 28, 2011, Johan Wessfeldt wrote:
> This patch introduces checks when acpi osl reserves resources by calling
> request_region.

Why is the patch necessary?

> Please review:
> Is it valid to return early when acpi_request_region() fails?

What do you mean by "return early"?

Rafael


> Signed-off-by: Johan Wessfeldt <johan.wessfeldt@gmail.com>
> ---
>  drivers/acpi/osl.c |   85 +++++++++++++++++++++++++++++++++++-----------------
>  1 files changed, 57 insertions(+), 28 deletions(-)
> 
> diff --git a/drivers/acpi/osl.c b/drivers/acpi/osl.c
> index c90c76a..5c8c521 100644
> --- a/drivers/acpi/osl.c
> +++ b/drivers/acpi/osl.c
> @@ -166,48 +166,77 @@ static u32 acpi_osi_handler(acpi_string interface, u32 supported)
>  	return supported;
>  }
>  
> -static void __init acpi_request_region (struct acpi_generic_address *addr,
> +static int __init acpi_request_region(struct acpi_generic_address *addr,
>  	unsigned int length, char *desc)
>  {
> +	struct resource *pRes;
> +
>  	if (!addr->address || !length)
> -		return;
> +		return -EIO;
>  
>  	/* Resources are never freed */
> -	if (addr->space_id == ACPI_ADR_SPACE_SYSTEM_IO)
> -		request_region(addr->address, length, desc);
> -	else if (addr->space_id == ACPI_ADR_SPACE_SYSTEM_MEMORY)
> -		request_mem_region(addr->address, length, desc);
> +	if (addr->space_id == ACPI_ADR_SPACE_SYSTEM_IO) {
> +		pRes = request_region(addr->address, length, desc);
> +		if (pRes == NULL)
> +			return -EIO;
> +
> +	} else if (addr->space_id == ACPI_ADR_SPACE_SYSTEM_MEMORY) {
> +		pRes = request_mem_region(addr->address, length, desc);
> +		if (pRes == NULL)
> +			return -EIO;
> +	}
> +
> +	return 0;
>  }
>  
>  static int __init acpi_reserve_resources(void)
>  {
> -	acpi_request_region(&acpi_gbl_FADT.xpm1a_event_block, acpi_gbl_FADT.pm1_event_length,
> -		"ACPI PM1a_EVT_BLK");
> +	if (!acpi_request_region(&acpi_gbl_FADT.xpm1a_event_block,
> +				 acpi_gbl_FADT.pm1_event_length,
> +				 "ACPI PM1a_EVT_BLK"))
> +		return -EIO;
>  
> -	acpi_request_region(&acpi_gbl_FADT.xpm1b_event_block, acpi_gbl_FADT.pm1_event_length,
> -		"ACPI PM1b_EVT_BLK");
> +	if (!acpi_request_region(&acpi_gbl_FADT.xpm1b_event_block,
> +				 acpi_gbl_FADT.pm1_event_length,
> +				 "ACPI PM1b_EVT_BLK"))
> +		return -EIO;
>  
> -	acpi_request_region(&acpi_gbl_FADT.xpm1a_control_block, acpi_gbl_FADT.pm1_control_length,
> -		"ACPI PM1a_CNT_BLK");
> +	if (!acpi_request_region(&acpi_gbl_FADT.xpm1a_control_block,
> +				 acpi_gbl_FADT.pm1_control_length,
> +				 "ACPI PM1a_CNT_BLK"))
> +		return -EIO;
>  
> -	acpi_request_region(&acpi_gbl_FADT.xpm1b_control_block, acpi_gbl_FADT.pm1_control_length,
> -		"ACPI PM1b_CNT_BLK");
> +	if (!acpi_request_region(&acpi_gbl_FADT.xpm1b_control_block,
> +				 acpi_gbl_FADT.pm1_control_length,
> +				 "ACPI PM1b_CNT_BLK"))
> +		return -EIO;
>  
> -	if (acpi_gbl_FADT.pm_timer_length == 4)
> -		acpi_request_region(&acpi_gbl_FADT.xpm_timer_block, 4, "ACPI PM_TMR");
> +	if (acpi_gbl_FADT.pm_timer_length == 4) {
> +		if (!acpi_request_region(&acpi_gbl_FADT.xpm_timer_block,
> +					 4, "ACPI PM_TMR"))
> +			return -EIO;
> +	}
>  
> -	acpi_request_region(&acpi_gbl_FADT.xpm2_control_block, acpi_gbl_FADT.pm2_control_length,
> -		"ACPI PM2_CNT_BLK");
> +	if (!acpi_request_region(&acpi_gbl_FADT.xpm2_control_block,
> +				 acpi_gbl_FADT.pm2_control_length,
> +				 "ACPI PM2_CNT_BLK"))
> +		return -EIO;
>  
>  	/* Length of GPE blocks must be a non-negative multiple of 2 */
>  
> -	if (!(acpi_gbl_FADT.gpe0_block_length & 0x1))
> -		acpi_request_region(&acpi_gbl_FADT.xgpe0_block,
> -			       acpi_gbl_FADT.gpe0_block_length, "ACPI GPE0_BLK");
> +	if (!(acpi_gbl_FADT.gpe0_block_length & 0x1)) {
> +		if (!acpi_request_region(&acpi_gbl_FADT.xgpe0_block,
> +					 acpi_gbl_FADT.gpe0_block_length,
> +					 "ACPI GPE0_BLK"))
> +			return -EIO;
> +	}
>  
> -	if (!(acpi_gbl_FADT.gpe1_block_length & 0x1))
> -		acpi_request_region(&acpi_gbl_FADT.xgpe1_block,
> -			       acpi_gbl_FADT.gpe1_block_length, "ACPI GPE1_BLK");
> +	if (!(acpi_gbl_FADT.gpe1_block_length & 0x1)) {
> +		if (!acpi_request_region(&acpi_gbl_FADT.xgpe1_block,
> +					 acpi_gbl_FADT.gpe1_block_length,
> +					 "ACPI GPE1_BLK"))
> +			return -EIO;
> +	}
>  
>  	return 0;
>  }
> 

