Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755159Ab1LFWJk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 17:09:40 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:45782 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753822Ab1LFWJj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 17:09:39 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Amit Shah <amit.shah@redhat.com>
Subject: Re: [PATCH v4 01/12] virtio: pci: switch to new PM API
Date: Tue, 6 Dec 2011 23:12:36 +0100
User-Agent: KMail/1.13.6 (Linux/3.2.0-rc4+; KDE/4.6.0; x86_64; ; )
Cc: Virtualization List <virtualization@lists.linux-foundation.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        "Michael S. Tsirkin" <mst@redhat.com>, levinsasha928@gmail.com,
        linux-kernel@vger.kernel.org
References: <cover.1323199985.git.amit.shah@redhat.com> <f34bcde3d5103640176cf6a2cf8c534417771f08.1323199985.git.amit.shah@redhat.com>
In-Reply-To: <f34bcde3d5103640176cf6a2cf8c534417771f08.1323199985.git.amit.shah@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <201112062312.36498.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tuesday, December 06, 2011, Amit Shah wrote:
> The older PM API doesn't have a way to get notifications on hibernate
> events.  Switch to the newer one that gives us those notifications.
> 
> Signed-off-by: Amit Shah <amit.shah@redhat.com>
> ---
>  drivers/virtio/virtio_pci.c |   16 ++++++++++++----
>  1 files changed, 12 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/virtio/virtio_pci.c b/drivers/virtio/virtio_pci.c
> index 03d1984..23e1532 100644
> --- a/drivers/virtio/virtio_pci.c
> +++ b/drivers/virtio/virtio_pci.c
> @@ -708,19 +708,28 @@ static void __devexit virtio_pci_remove(struct pci_dev *pci_dev)
>  }
>  
>  #ifdef CONFIG_PM
> -static int virtio_pci_suspend(struct pci_dev *pci_dev, pm_message_t state)
> +static int virtio_pci_suspend(struct device *dev)
>  {
> +	struct pci_dev *pci_dev = to_pci_dev(dev);
> +
>  	pci_save_state(pci_dev);
>  	pci_set_power_state(pci_dev, PCI_D3hot);
>  	return 0;
>  }
>  
> -static int virtio_pci_resume(struct pci_dev *pci_dev)
> +static int virtio_pci_resume(struct device *dev)
>  {
> +	struct pci_dev *pci_dev = to_pci_dev(dev);
> +
>  	pci_restore_state(pci_dev);
>  	pci_set_power_state(pci_dev, PCI_D0);
>  	return 0;
>  }
> +
> +static const struct dev_pm_ops virtio_pci_pm_ops = {
> +	.suspend = virtio_pci_suspend,
> +	.resume  = virtio_pci_resume,
> +};
>  #endif

You seem to have forgotten about hibernation callbacks.  Please use
one the macros defined in include/linux/pm.h if you want to use the same
callback routines for hibernation.

>  static struct pci_driver virtio_pci_driver = {
> @@ -729,8 +738,7 @@ static struct pci_driver virtio_pci_driver = {
>  	.probe		= virtio_pci_probe,
>  	.remove		= __devexit_p(virtio_pci_remove),
>  #ifdef CONFIG_PM
> -	.suspend	= virtio_pci_suspend,
> -	.resume		= virtio_pci_resume,
> +	.driver.pm	= &virtio_pci_pm_ops,
>  #endif
>  };

Thanks,
Rafael
