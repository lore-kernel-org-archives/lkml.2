Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754491Ab1LWU0m (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Dec 2011 15:26:42 -0500
Received: from andromeda.dapyr.net ([206.212.254.10]:37564 "EHLO
	andromeda.dapyr.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752880Ab1LWU0k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Dec 2011 15:26:40 -0500
Date: Fri, 23 Dec 2011 16:26:35 -0400
From: Konrad Rzeszutek Wilk <konrad@darnok.org>
To: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        linux-pm@vger.kernel.org
Subject: Re: Print PCI device in power management warning.
Message-ID: <20111223202635.GA20991@andromeda.dapyr.net>
References: <20111223181626.GA18647@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111223181626.GA18647@redhat.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 23, 2011 at 01:16:26PM -0500, Dave Jones wrote:
> When the WARN_ON in pci_has_legacy_pm_support() triggers, we get
> users filing backtraces, but it's not obvious which driver is
> triggering the trace. This adds a printk before the BUG.

Well, and adds a BUG!
> This still isn't perfect (automated tools like abrt will still miss it)
> but we can at least ask the user to look through their dmesg when
> we get these traces reported.
> 
> Signed-off-by: Dave Jones <davej@redhat.com>
> 
> diff --git a/drivers/pci/pci-driver.c b/drivers/pci/pci-driver.c
> index 12d1e81..b638244 100644
> --- a/drivers/pci/pci-driver.c
> +++ b/drivers/pci/pci-driver.c
> @@ -604,7 +604,12 @@ static bool pci_has_legacy_pm_support(struct pci_dev *pci_dev)
>  	 * supported as well.  Drivers are supposed to support either the
>  	 * former, or the latter, but not both at the same time.
>  	 */
> -	WARN_ON(ret && drv->driver.pm);
> +	if (ret && drv->driver.pm) {
> +		printk(KERN_WARNING "pci: %s has both legacy and new PM support.\n",
> +			drv->name);
> +		BUG();

Um, so this will hang the machine.

don't you just want:

	WARN(ret && drv->driver.pm, "pci: %s Has both legacy and new PM
support!\n", drv_name(drv));

which will do what it previously does and also add the message you
wanted to add?

> +	}
> +
>  
>  	return ret;
>  }
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
