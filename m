Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756220Ab1JALF7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Oct 2011 07:05:59 -0400
Received: from violet.fr.zoreil.com ([92.243.8.30]:53066 "EHLO
	violet.fr.zoreil.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755160Ab1JALFw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Oct 2011 07:05:52 -0400
Date: Sat, 1 Oct 2011 13:03:57 +0200
From: Francois Romieu <romieu@fr.zoreil.com>
To: Mark Einon <mark.einon@gmail.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, gregkh@suse.de,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        o.hartmann@telovital.com, alan@linux.intel.com
Subject: Re: [PATCH 4/8] staging: et131x: Add pci suspend & resume functions
Message-ID: <20111001110357.GA10696@electric-eye.fr.zoreil.com>
References: <1317464057-18231-1-git-send-email-mark.einon@gmail.com> <1317464057-18231-4-git-send-email-mark.einon@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1317464057-18231-4-git-send-email-mark.einon@gmail.com>
User-Agent: Mutt/1.4.2.2i
X-Organisation: Land of Sunshine Inc.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Einon <mark.einon@gmail.com> :
> Added basic suspend & resume functionality.
> Tested on an et1310 device, and putting Fedora15 host in and out of
> hibernation successfully.
> 
> Signed-off-by: Mark Einon <mark.einon@gmail.com>
[...]
> diff --git a/drivers/staging/et131x/et131x_initpci.c b/drivers/staging/et131x/et131x_initpci.c
> index 10283a3..e166fde 100644
> --- a/drivers/staging/et131x/et131x_initpci.c
> +++ b/drivers/staging/et131x/et131x_initpci.c
> @@ -869,6 +869,45 @@ static void __devexit et131x_pci_remove(struct pci_dev *pdev)
>  	pci_disable_device(pdev);
>  }
>  
> +static int et131x_pci_suspend(struct pci_dev *pdev, pm_message_t state)
> +{
> +	struct net_device *netdev = pci_get_drvdata(pdev);
> +
> +	if (!netif_running(netdev))
> +		return 0;
> +
> +	et131x_close(netdev);
> +	netif_device_detach(netdev);
> +
> +	pci_save_state(pdev);
> +	pci_set_power_state(pdev, pci_choose_state(pdev, state));
> +
> +	return 0;
> +}
> +
> +static int et131x_pci_resume(struct pci_dev *pdev)
> +{
> +	struct net_device *netdev = pci_get_drvdata(pdev);
> +	int err = 0;
> +
> +	if (!netif_running(netdev))
> +		return 0;
> +
> +	pci_set_power_state(pdev, PCI_D0);
> +	pci_restore_state(pdev);
> +
> +	err = et131x_open(netdev);
> +	if (err) {
> +		dev_err(&pdev->dev, "Can't resume interface!\n");
> +		goto out;
> +	}

You can/should split et131x_{open/close} to remove this failure point.

[...]
> @@ -884,8 +923,10 @@ static struct pci_driver et131x_driver = {
>  	.id_table	= et131x_pci_table,
>  	.probe		= et131x_pci_setup,
>  	.remove		= __devexit_p(et131x_pci_remove),
> -	.suspend	= NULL,		/* et131x_pci_suspend */
> -	.resume		= NULL,		/* et131x_pci_resume */
> +#ifdef CONFIG_PM
> +	.suspend	= et131x_pci_suspend,
> +	.resume		= et131x_pci_resume,
> +#endif

There is not much driver specific there. It should probably go through
pci_driver.driver.pm.

-- 
Ueimor
