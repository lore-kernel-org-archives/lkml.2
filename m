Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753339Ab0L0D6L (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Dec 2010 22:58:11 -0500
Received: from mms2.broadcom.com ([216.31.210.18]:1843 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752769Ab0L0D6I convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Dec 2010 22:58:08 -0500
X-Server-Uuid: D3C04415-6FA8-4F2C-93C1-920E106A2031
From: "Michael Chan" <mchan@broadcom.com>
To: "'Jesper Juhl'" <jj@chaosbits.net>, "'Joe Perches'" <joe@perches.com>,
        "'davem@davemloft.net'" <davem@davemloft.net>
cc: "'netdev@vger.kernel.org'" <netdev@vger.kernel.org>,
        "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
        "'John(Zongxi) Chen'" <zongxi@broadcom.com>
Date: Sun, 26 Dec 2010 19:57:52 -0800
Subject: Re: [PATCH v2] Broadcom CNIC core network driver: fix mem leak
 on allocation failures in cnic_alloc_uio_rings()
Thread-Topic: [PATCH v2] Broadcom CNIC core network driver: fix mem leak
 on allocation failures in cnic_alloc_uio_rings()
Thread-Index: AculQrCQtPg6itDHRvikAD3iXOeIMAANqQhA
Message-ID: <C27F8246C663564A84BB7AB34397724240CE6BCAD8@IRVEXCHCCR01.corp.ad.broadcom.com>
References: <alpine.LNX.2.00.1012262124320.20797@swampdragon.chaosbits.net>
 <1293396850.7726.14.camel@Joe-Laptop>
 <alpine.LNX.2.00.1012262154420.20797@swampdragon.chaosbits.net>
In-Reply-To: <alpine.LNX.2.00.1012262154420.20797@swampdragon.chaosbits.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
MIME-Version: 1.0
X-WSS-ID: 6106D17E5L89549751-01-01
Content-Type: text/plain;
 charset=us-ascii
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jesper Juhl wrote:

> 
> We are leaking memory in drivers/net/cnic.c::cnic_alloc_uio_rings() if
> either of the calls to dma_alloc_coherent() fail. This patch fixes it
> by
> freeing both the memory allocated with kzalloc() and memory allocated
> with
> previous calls to dma_alloc_coherent() when there's a failure.
> 
> Thanks to  Joe Perches <joe@perches.com>  for suggesting a better
> implementation than my initial version.
> 
> 
> Signed-off-by: Jesper Juhl <jj@chaosbits.net>

Thanks.

Acked-by: Michael Chan <mchan@broadcom.com>

> ---
>  cnic.c |   10 ++++++++--
>  1 file changed, 8 insertions(+), 2 deletions(-)
> 
>   compile tested only since I don't have the hardware to do a proper
> test.
> 
> diff --git a/drivers/net/cnic.c b/drivers/net/cnic.c
> index 92bac19..952afac 100644
> --- a/drivers/net/cnic.c
> +++ b/drivers/net/cnic.c
> @@ -940,7 +940,7 @@ static int cnic_alloc_uio_rings(struct cnic_dev
> *dev, int pages)
>  					   &udev->l2_ring_map,
>  					   GFP_KERNEL | __GFP_COMP);
>  	if (!udev->l2_ring)
> -		return -ENOMEM;
> +		goto err_udev;
> 
>  	udev->l2_buf_size = (cp->l2_rx_ring_size + 1) * cp-
> >l2_single_buf_size;
>  	udev->l2_buf_size = PAGE_ALIGN(udev->l2_buf_size);
> @@ -948,7 +948,7 @@ static int cnic_alloc_uio_rings(struct cnic_dev
> *dev, int pages)
>  					  &udev->l2_buf_map,
>  					  GFP_KERNEL | __GFP_COMP);
>  	if (!udev->l2_buf)
> -		return -ENOMEM;
> +		goto err_dma;
> 
>  	write_lock(&cnic_dev_lock);
>  	list_add(&udev->list, &cnic_udev_list);
> @@ -959,6 +959,12 @@ static int cnic_alloc_uio_rings(struct cnic_dev
> *dev, int pages)
>  	cp->udev = udev;
> 
>  	return 0;
> + err_dma:
> +	dma_free_coherent(&udev->pdev->dev, udev->l2_ring_size,
> +       			  udev->l2_ring, udev->l2_ring_map);
> + err_udev:
> +	kfree(udev);
> +	return -ENOMEM;
>  }
> 
>  static int cnic_init_uio(struct cnic_dev *dev)
> 
> 
> 



