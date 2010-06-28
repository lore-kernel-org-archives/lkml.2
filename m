Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754103Ab0F1TNf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jun 2010 15:13:35 -0400
Received: from cpoproxy3-pub.bluehost.com ([67.222.54.6]:39787 "HELO
	cpoproxy3-pub.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751338Ab0F1TNd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jun 2010 15:13:33 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=HrzwRHJWsI2E/WGpj6Q4gyYeqDSvXdLZfvM1kxGnTzzAL6pMDICkvJyrUUveGV22f999yxPENm1qYA3ETn4Yy3g+YU8q/2vMKzDe3dHkCMuVqMREW6brDR0yauTvRtD6;
Date: Mon, 28 Jun 2010 12:11:20 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Alan Stern <stern@rowland.harvard.edu>,
       linux-pm@lists.linux-foundation.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Neil Brown <neilb@suse.de>, Matthew Garrett <mjg59@srcf.ucam.org>,
       mark gross <640e9920@gmail.com>,
       Arve =?UTF-8?B?SGrDuG5uZXbDpWc=?= <arve@android.com>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Florian Mickler <florian@mickler.org>, linux-pci@vger.kernel.org
Subject: Re: [update] Re: [PATCH] PM: Make it possible to avoid wakeup
 events from being lost
Message-ID: <20100628121120.4f764413@virtuousgeek.org>
In-Reply-To: <201006282101.54041.rjw@sisk.pl>
References: <Pine.LNX.4.44L0.1006281006360.1977-100000@iolanthe.rowland.org>
	<201006282101.54041.rjw@sisk.pl>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.110.194.140 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Jun 2010 21:01:53 +0200
"Rafael J. Wysocki" <rjw@sisk.pl> wrote:

> --- linux-2.6.orig/drivers/pci/pci.c
> +++ linux-2.6/drivers/pci/pci.c
> @@ -1275,6 +1275,22 @@ bool pci_check_pme_status(struct pci_dev
>  	return ret;
>  }
>  
> +/*
> + * Time to wait before the system can be put into a sleep state after reporting
> + * a wakeup event signaled by a PCI device.
> + */
> +#define PCI_WAKEUP_COOLDOWN	100
> +
> +/**
> + * pci_wakeup_event - Report a wakeup event related to a given PCI device.
> + * @dev: Device to report the wakeup event for.
> + */
> +void pci_wakeup_event(struct pci_dev *dev)
> +{
> +	if (device_may_wakeup(&dev->dev))
> +		pm_wakeup_event(&dev->dev, PCI_WAKEUP_COOLDOWN);
> +}
> +
>  /**
>   * pci_pme_wakeup - Wake up a PCI device if its PME Status bit is set.
>   * @dev: Device to handle.
> @@ -1285,8 +1301,10 @@ bool pci_check_pme_status(struct pci_dev
>   */
>  static int pci_pme_wakeup(struct pci_dev *dev, void *ign)
>  {
> -	if (pci_check_pme_status(dev))
> +	if (pci_check_pme_status(dev)) {
>  		pm_request_resume(&dev->dev);
> +		pci_wakeup_event(dev);
> +	}
>  	return 0;
>  }
>  

I assume the units here are ms?  And the wakeup event propagation check
is pushed down into pci_wakeup_event, is there no place to check
whether the device is configured to generate wakeups in the core device
or PM code?

Other than that, the PCI part is
Acked-by: Jesse Barnes <jbarnes@virtuousgeek.org>

-- 
Jesse Barnes, Intel Open Source Technology Center
