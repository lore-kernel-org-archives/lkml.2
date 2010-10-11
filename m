Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754711Ab0JKXfJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Oct 2010 19:35:09 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39879 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753449Ab0JKXfG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Oct 2010 19:35:06 -0400
Date: Mon, 11 Oct 2010 16:34:40 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: James Hogan <james@albanarts.com>
Cc: Gary Zambrano <zambrano@broadcom.com>, Jiri Pirko <jpirko@redhat.com>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Larry Finger <Larry.Finger@lwfinger.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH] b44: fix resume, request_irq after hw reset
Message-Id: <20101011163440.072e0227.akpm@linux-foundation.org>
In-Reply-To: <201010120022.13171.james@albanarts.com>
References: <201010120022.13171.james@albanarts.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 12 Oct 2010 00:22:12 +0100
James Hogan <james@albanarts.com> wrote:

> This driver was hanging on resume because it was requesting a shared irq
> that it wasn't ready to immediately handle, which was tested in
> request_irq because of the CONFIG_DEBUG_SHIRQ config option. The
> interrupt handler tried to read the interrupt status register but for
> some reason it hung the system.
> 
> The request_irq is now moved a bit later after resetting the hardware
> which seems to fix it.
> 
> Signed-off-by: James Hogan <james@albanarts.com>
> ---
>  drivers/net/b44.c |   12 ++++++------
>  1 files changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/net/b44.c b/drivers/net/b44.c
> index 1e620e2..dbba981 100644
> --- a/drivers/net/b44.c
> +++ b/drivers/net/b44.c
> @@ -2296,12 +2296,6 @@ static int b44_resume(struct ssb_device *sdev)
>  	if (!netif_running(dev))
>  		return 0;
>  
> -	rc = request_irq(dev->irq, b44_interrupt, IRQF_SHARED, dev->name, dev);
> -	if (rc) {
> -		netdev_err(dev, "request_irq failed\n");
> -		return rc;
> -	}
> -
>  	spin_lock_irq(&bp->lock);
>  
>  	b44_init_rings(bp);
> @@ -2309,6 +2303,12 @@ static int b44_resume(struct ssb_device *sdev)
>  	netif_device_attach(bp->dev);
>  	spin_unlock_irq(&bp->lock);
>  
> +	rc = request_irq(dev->irq, b44_interrupt, IRQF_SHARED, dev->name, dev);
> +	if (rc) {
> +		netdev_err(dev, "request_irq failed\n");
> +		return rc;
> +	}
> +
>  	b44_enable_ints(bp);
>  	netif_wake_queue(dev);

OK, running the interrupt handler before b44_init_hw() is presumably
the problem here.

The hardware surely won't be generating interrupts until we've run
b44_init_hw() and b44_enable_ints(), so this patch really is only to
keep CONFIG_DEBUG_SHIRQ happy.

