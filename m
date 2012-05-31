Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753265Ab2EaGpQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 02:45:16 -0400
Received: from merlin.infradead.org ([205.233.59.134]:37078 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750955Ab2EaGpP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 02:45:15 -0400
Message-ID: <4FC71347.3030107@kernel.dk>
Date: Thu, 31 May 2012 08:44:23 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Asai Thambi S P <asamymuthupa@micron.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sam Bradshaw <sbradshaw@micron.com>
Subject: Re: [PATCH 06/11] mtip32xx: Use plain spinlock for 'cmd_issue_lock'
References: <4FC57B34.3020405@micron.com>
In-Reply-To: <4FC57B34.3020405@micron.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/30/2012 03:43 AM, Asai Thambi S P wrote:
> 
> 'cmd_issue_lock' is for only acquiring a free slot, and it is not used
> in interrupt context. So replaced irq version with non-irq version of spinlock.
> 
> Signed-off-by: Asai Thambi S P <asamymuthupa@micron.com>
> ---
>  drivers/block/mtip32xx/mtip32xx.c |    6 ++----
>  1 files changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/block/mtip32xx/mtip32xx.c b/drivers/block/mtip32xx/mtip32xx.c
> index 801e70c..a8a5522 100644
> --- a/drivers/block/mtip32xx/mtip32xx.c
> +++ b/drivers/block/mtip32xx/mtip32xx.c
> @@ -294,18 +294,16 @@ static int hba_reset_nosleep(struct driver_data *dd)
>   */
>  static inline void mtip_issue_ncq_command(struct mtip_port *port, int tag)
>  {
> -	unsigned long flags = 0;
> -
>  	atomic_set(&port->commands[tag].active, 1);
>  
> -	spin_lock_irqsave(&port->cmd_issue_lock, flags);
> +	spin_lock(&port->cmd_issue_lock);
>  
>  	writel((1 << MTIP_TAG_BIT(tag)),
>  			port->s_active[MTIP_TAG_INDEX(tag)]);
>  	writel((1 << MTIP_TAG_BIT(tag)),
>  			port->cmd_issue[MTIP_TAG_INDEX(tag)]);
>  
> -	spin_unlock_irqrestore(&port->cmd_issue_lock, flags);
> +	spin_unlock(&port->cmd_issue_lock);

Looks fine - wasn't going to comment specifically on this one, but
wanted to say, that in general you don't need to pre-clear the flags
variable before passing it to _irqsave().

-- 
Jens Axboe

