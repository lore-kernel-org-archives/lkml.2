Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757281Ab1I2Sgo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 14:36:44 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:59861 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754414Ab1I2Sgm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 14:36:42 -0400
Subject: Re: [PATCH 02/11] virtio-pci: add PM notification handlers for
 restore, freeze, thaw, poweroff
From: Sasha Levin <levinsasha928@gmail.com>
To: Amit Shah <amit.shah@redhat.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>
In-Reply-To: <9f89dedd5e4e77c9244afde0ce22c1216a35c193.1317309123.git.amit.shah@redhat.com>
References: <cover.1317309123.git.amit.shah@redhat.com>
	 <9f89dedd5e4e77c9244afde0ce22c1216a35c193.1317309123.git.amit.shah@redhat.com>
Content-Type: text/plain; charset="us-ascii"
Date: Thu, 29 Sep 2011 21:36:38 +0300
Message-ID: <1317321398.21918.7.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-09-29 at 20:55 +0530, Amit Shah wrote:
> Handle restore and freeze notification from the PM core.  Expose these
> to individual virtio drivers that can quiesce and resume vq operations.
> 
> These functions also save device-specific data so that the device can be
> put in pre-suspend state after resume.
> 
> Signed-off-by: Amit Shah <amit.shah@redhat.com>
> ---
>  drivers/virtio/virtio_pci.c |   41 +++++++++++++++++++++++++++++++++++++++++
>  include/linux/virtio.h      |    4 ++++
>  2 files changed, 45 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/virtio/virtio_pci.c b/drivers/virtio/virtio_pci.c
> index 6947620..cc70662 100644
> --- a/drivers/virtio/virtio_pci.c
> +++ b/drivers/virtio/virtio_pci.c
> @@ -55,6 +55,10 @@ struct virtio_pci_device
>  	unsigned msix_vectors;
>  	/* Vectors allocated, excluding per-vq vectors if any */
>  	unsigned msix_used_vectors;
> +
> +	/* Status saved during hibernate/restore */
> +	u8 saved_status;
> +
>  	/* Whether we have vector per vq */
>  	bool per_vq_vectors;
>  };
> @@ -703,9 +707,46 @@ static int virtio_pci_resume(struct device *dev)
>  	return 0;
>  }
>  
> +static int virtio_pci_freeze(struct device *dev)
> +{
> +	struct pci_dev *pci_dev = to_pci_dev(dev);
> +	struct virtio_pci_device *vp_dev = pci_get_drvdata(pci_dev);
> +	struct virtio_driver *drv;
> +
> +	drv = container_of(vp_dev->vdev.dev.driver,
> +			   struct virtio_driver, driver);
> +
> +	vp_dev->saved_status = vp_get_status(&vp_dev->vdev);
> +	if (drv && drv->freeze)
> +		return drv->freeze(&vp_dev->vdev);
> +
> +	return 0;
> +}

After drv->freeze() completes, the vq is freed from guest memory, but is
there anything that prevents from the device to keep writing into that
vq?

Shouldn't we set status to '0' before we free vqs?

-- 

Sasha.

