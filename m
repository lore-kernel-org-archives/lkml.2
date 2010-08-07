Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756910Ab0HGHWs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Aug 2010 03:22:48 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:46787 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752498Ab0HGHWp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Aug 2010 03:22:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=m4ZZGjDrFznm3kNZTU9K3qEfy2FvCLN7nzf7hU+CqFjThvZWm+wzrLp/H0/sqMtVcZ
         tPa2PaCcNUmX5f/3m2aQUf2jh+Q5up6l5qZYnYbnrC6A8F5XT6tSPXUI1D3/D3osbikM
         h0JhOl9+ZO0TOGjkS+e3aH4QKd6aj1v1SeAKs=
Date: Sat, 7 Aug 2010 09:22:05 +0200
From: Dan Carpenter <error27@gmail.com>
To: Kulikov Vasiliy <segooon@gmail.com>
Cc: kernel-janitors@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>,
        Alan Cox <alan@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rakib Mullick <rakib.mullick@gmail.com>,
        Ben Hutchings <ben@decadent.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/18] char: moxa: call disable_pci_device() if
	pci_probe() failed
Message-ID: <20100807072205.GW9031@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Kulikov Vasiliy <segooon@gmail.com>,
	kernel-janitors@vger.kernel.org,
	Greg Kroah-Hartman <gregkh@suse.de>,
	Alan Cox <alan@linux.intel.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Rakib Mullick <rakib.mullick@gmail.com>,
	Ben Hutchings <ben@decadent.org.uk>, linux-kernel@vger.kernel.org
References: <1281124152-12630-1-git-send-email-segooon@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1281124152-12630-1-git-send-email-segooon@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 06, 2010 at 11:49:10PM +0400, Kulikov Vasiliy wrote:
> Driver should call disable_pci_device() if it returns from pci_probe()
> with error. Also it must not be called if pci_request_region() fails as
> it means that somebody uses device resources and rules the device.
> 

I think we should disable it actually.  The comments on
pci_enable_device() and pci_disable_device() say that only the first and
last callers actually enable and disable it.  The others just increment
or decrement a counter.

regards,
dan carpenter

> Move pci_enable_device() after checking moxa_boards[] to remove senseless
> pci_enable_device()/pci_disable_device().
> 
> Signed-off-by: Kulikov Vasiliy <segooon@gmail.com>
> ---
>  drivers/char/moxa.c |   12 +++++++-----
>  1 files changed, 7 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/char/moxa.c b/drivers/char/moxa.c
> index 107b0bd..0ea5aeb 100644
> --- a/drivers/char/moxa.c
> +++ b/drivers/char/moxa.c
> @@ -939,11 +939,6 @@ static int __devinit moxa_pci_probe(struct pci_dev *pdev,
>  	int board_type = ent->driver_data;
>  	int retval;
>  
> -	retval = pci_enable_device(pdev);
> -	if (retval) {
> -		dev_err(&pdev->dev, "can't enable pci device\n");
> -		goto err;
> -	}
>  
>  	for (i = 0; i < MAX_BOARDS; i++)
>  		if (moxa_boards[i].basemem == NULL)
> @@ -956,6 +951,12 @@ static int __devinit moxa_pci_probe(struct pci_dev *pdev,
>  		goto err;
>  	}
>  
> +	retval = pci_enable_device(pdev);
> +	if (retval) {
> +		dev_err(&pdev->dev, "can't enable pci device\n");
> +		goto err;
> +	}
> +
>  	board = &moxa_boards[i];
>  
>  	retval = pci_request_region(pdev, 2, "moxa-base");
> @@ -1001,6 +1002,7 @@ err_base:
>  	board->basemem = NULL;
>  err_reg:
>  	pci_release_region(pdev, 2);
> +	pci_disable_device(pdev);
>  err:
>  	return retval;
>  }
> -- 
> 1.7.0.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe kernel-janitors" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
