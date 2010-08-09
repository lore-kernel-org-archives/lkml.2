Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756770Ab0HIU2e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Aug 2010 16:28:34 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:41313 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753945Ab0HIU2d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Aug 2010 16:28:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=vpj/Y8sAehO/ow7tPtfelx1s4gGhyaJQdJ+HKYGyqGtLpXQ80yi+fT2UPnQ89ldEz1
         s26wEP3JG91kTBHIdhp7B8xmXpyvqcZzxUNPY5ccvC0fMYHloQrkOZ3q/Ls8UtquK/Tu
         h1q9TqivnIIPl9C6AI0NviUS9Shk6djqp1zFk=
Date: Mon, 9 Aug 2010 22:27:28 +0200
From: Dan Carpenter <error27@gmail.com>
To: Kulikov Vasiliy <segooon@gmail.com>
Cc: kernel-janitors@vger.kernel.org, Jiri Slaby <jirislaby@gmail.com>,
        Greg Kroah-Hartman <gregkh@suse.de>, Alan Cox <alan@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 02/18 v2] char: mxser: call disable_pci_device() if
	pci_probe() failed
Message-ID: <20100809202634.GL9031@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Kulikov Vasiliy <segooon@gmail.com>,
	kernel-janitors@vger.kernel.org, Jiri Slaby <jirislaby@gmail.com>,
	Greg Kroah-Hartman <gregkh@suse.de>,
	Alan Cox <alan@linux.intel.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org
References: <1281383369-13613-1-git-send-email-segooon@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1281383369-13613-1-git-send-email-segooon@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 09, 2010 at 11:49:27PM +0400, Kulikov Vasiliy wrote:
> @@ -2564,8 +2564,11 @@ static int __devinit mxser_probe(struct pci_dev *pdev,
>  	/* vector */
>  	ioaddress = pci_resource_start(pdev, 3);
>  	retval = pci_request_region(pdev, 3, "mxser(vector)");
> -	if (retval)
> -		goto err_relio;
> +	if (retval) {
> +		pci_release_region(pdev, 2);
> +		brd->info = NULL;
> +		goto err_release;

This should just be goto err_null.  The original err_null had a bug that
it didn't call pci_release_region(pdev, 2); but you already fixed that.

regards,
dan carpenter

> +	}
>  	brd->vector = ioaddress;
>  
>  	/* irq */
> @@ -2616,10 +2619,13 @@ static int __devinit mxser_probe(struct pci_dev *pdev,
>  	pci_set_drvdata(pdev, brd);
>  
>  	return 0;
> -err_relio:
> -	pci_release_region(pdev, 2);
>  err_null:
>  	brd->info = NULL;
> +	pci_release_region(pdev, 2);
> +err_release:
> +	pci_release_region(pdev, 3);
> +err_disable:
> +	pci_disable_device(pdev);
>  err:
>  	return retval;
>  #else

