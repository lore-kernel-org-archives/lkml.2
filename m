Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755651Ab2F1WYg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2012 18:24:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25591 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754072Ab2F1WYf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2012 18:24:35 -0400
Message-ID: <1340922269.3179.57.camel@ul30vt>
Subject: Re: [patch 1/3 v2] vfio: signedness bug in vfio_config_do_rw()
From: Alex Williamson <alex.williamson@redhat.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org, walter harms <wharms@bfs.de>
Date: Thu, 28 Jun 2012 16:24:29 -0600
In-Reply-To: <20120628080725.GA22595@elgon.mountain>
References: <20120628080725.GA22595@elgon.mountain>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-06-28 at 11:07 +0300, Dan Carpenter wrote:
> The "count" variable needs to be signed here because we use it to store
> negative error codes.
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---
> v2: Just declare count as signed.
> 
> diff --git a/drivers/vfio/pci/vfio_pci_config.c b/drivers/vfio/pci/vfio_pci_config.c
> index a4f7321..2e00aa8 100644
> --- a/drivers/vfio/pci/vfio_pci_config.c
> +++ b/drivers/vfio/pci/vfio_pci_config.c
> @@ -1419,7 +1419,7 @@ void vfio_config_free(struct vfio_pci_device *vdev)
>  }
>  
>  static ssize_t vfio_config_do_rw(struct vfio_pci_device *vdev, char __user *buf,
> -				 size_t count, loff_t *ppos, bool iswrite)
> +				 ssize_t count, loff_t *ppos, bool iswrite)
>  {
>  	struct pci_dev *pdev = vdev->pdev;
>  	struct perm_bits *perm;

signed doesn't seem right for count since just below this chunk we do:

        if (*ppos < 0 || *ppos + count > pdev->cfg_size)
                return -EFAULT;

So then we have to start testing for negative count.  I've added a
ssize_t variable for return that should clear things up.  Thanks for the
report!

Alex

