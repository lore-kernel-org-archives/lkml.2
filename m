Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755872Ab2F1WYz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2012 18:24:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:26960 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755805Ab2F1WYy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2012 18:24:54 -0400
Message-ID: <1340922292.3179.58.camel@ul30vt>
Subject: Re: [patch 2/3] vfio: make count unsigned to prevent integer
 underflow
From: Alex Williamson <alex.williamson@redhat.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Date: Thu, 28 Jun 2012 16:24:52 -0600
In-Reply-To: <20120628064458.GB11107@elgon.mountain>
References: <20120628064458.GB11107@elgon.mountain>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-06-28 at 09:44 +0300, Dan Carpenter wrote:
> In vfio_pci_ioctl() there is a potential integer underflow where we
> might allocate less data than intended.  We check that hdr.count is not
> too large, but we don't check whether it is negative:
> 
> drivers/vfio/pci/vfio_pci.c
>    312          if (hdr.argsz - minsz < hdr.count * size ||
>    313              hdr.count > vfio_pci_get_irq_count(vdev, hdr.index))
>    314                  return -EINVAL;
>    315
>    316          data = kmalloc(hdr.count * size, GFP_KERNEL);
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> 
> diff --git a/include/linux/vfio.h b/include/linux/vfio.h
> index 300d49b..86ef2da 100644
> --- a/include/linux/vfio.h
> +++ b/include/linux/vfio.h
> @@ -347,7 +347,7 @@ struct vfio_irq_set {
>  #define VFIO_IRQ_SET_ACTION_TRIGGER	(1 << 5) /* Trigger interrupt */
>  	__u32	index;
>  	__s32	start;
> -	__s32	count;
> +	__u32	count;
>  	__u8	data[];
>  };
>  #define VFIO_DEVICE_SET_IRQS		_IO(VFIO_TYPE, VFIO_BASE + 10)

Good find.  I've actually trickled this through to change a number of
the function params to unsigned from int.  Also in this struct, start
should be unsigned.  Thanks for the report!

Alex

