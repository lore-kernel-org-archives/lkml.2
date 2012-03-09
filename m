Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758447Ab2CIVnm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 16:43:42 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:53989 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752875Ab2CIVnk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 16:43:40 -0500
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH v2] spi-topcliff-pch: fix -Wuninitialized warning
To: Danny Kukawka <danny.kukawka@bisect.de>
Cc: Danny Kukawka <dkukawka@suse.de>, Jiri Kosina <trivial@kernel.org>,
        spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org
In-Reply-To: <1329230103-26465-1-git-send-email-danny.kukawka@bisect.de>
References: <1329230103-26465-1-git-send-email-danny.kukawka@bisect.de>
Date: Fri, 09 Mar 2012 14:43:37 -0700
Message-Id: <20120309214337.A06483E0880@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 14 Feb 2012 15:35:03 +0100, Danny Kukawka <danny.kukawka@bisect.de> wrote:
> Fix for:
> drivers/spi/spi-topcliff-pch.c: In function ‘pch_spi_handler_sub’:
> drivers/spi/spi-topcliff-pch.c:325:17: warning: ‘bpw_len’ may be
>   used uninitialized in this function [-Wuninitialized]
> drivers/spi/spi-topcliff-pch.c:325:42: warning: ‘rx_index’ may be
>   used uninitialized in this function [-Wuninitialized]
> drivers/spi/spi-topcliff-pch.c:325:42: warning: ‘tx_index’ may be
>   used uninitialized in this function [-Wuninitialized]
> 
> Move usage of tx_index, rx_index and bpw_len into the same
> block as where they are set to prevent uninitialized usage.
> 
> v2: instead of init variables with 0 move the whole block
> 
> Signed-off-by: Danny Kukawka <danny.kukawka@bisect.de>

Applied, thanks

g.

> ---
>  drivers/spi/spi-topcliff-pch.c |   33 +++++++++++++++----------------
>  1 files changed, 17 insertions(+), 16 deletions(-)
> 
> diff --git a/drivers/spi/spi-topcliff-pch.c b/drivers/spi/spi-topcliff-pch.c
> index 10182eb..1107469 100644
> --- a/drivers/spi/spi-topcliff-pch.c
> +++ b/drivers/spi/spi-topcliff-pch.c
> @@ -318,22 +318,23 @@ static void pch_spi_handler_sub(struct pch_spi_data *data, u32 reg_spsr_val,
>  		data->tx_index = tx_index;
>  		data->rx_index = rx_index;
>  
> -	}
> -
> -	/* if transfer complete interrupt */
> -	if (reg_spsr_val & SPSR_FI_BIT) {
> -		if ((tx_index == bpw_len) && (rx_index == tx_index)) {
> -			/* disable interrupts */
> -			pch_spi_setclr_reg(data->master, PCH_SPCR, 0, PCH_ALL);
> -
> -			/* transfer is completed;
> -			   inform pch_spi_process_messages */
> -			data->transfer_complete = true;
> -			data->transfer_active = false;
> -			wake_up(&data->wait);
> -		} else {
> -			dev_err(&data->master->dev,
> -				"%s : Transfer is not completed", __func__);
> +		/* if transfer complete interrupt */
> +		if (reg_spsr_val & SPSR_FI_BIT) {
> +			if ((tx_index == bpw_len) && (rx_index == tx_index)) {
> +				/* disable interrupts */
> +				pch_spi_setclr_reg(data->master, PCH_SPCR, 0,
> +						   PCH_ALL);
> +
> +				/* transfer is completed;
> +				   inform pch_spi_process_messages */
> +				data->transfer_complete = true;
> +				data->transfer_active = false;
> +				wake_up(&data->wait);
> +			} else {
> +				dev_err(&data->master->dev,
> +					"%s : Transfer is not completed",
> +					__func__);
> +			}
>  		}
>  	}
>  }
> -- 
> 1.7.7.3
> 

-- 
Grant Likely, B.Sc, P.Eng.
Secret Lab Technologies,Ltd.
