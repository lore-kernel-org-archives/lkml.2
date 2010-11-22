Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756816Ab0KVQSA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Nov 2010 11:18:00 -0500
Received: from sunjammer.sugarlabs.org ([140.186.70.53]:43259 "EHLO
	sunjammer.sugarlabs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751176Ab0KVQR7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Nov 2010 11:17:59 -0500
Subject: Re: pc300too on a modern kernel?
From: Bernie Innocenti <bernie@codewiz.org>
To: Krzysztof Halasa <khc@pm.waw.pl>
Cc: Ward Vandewege <ward@gnu.org>, lkml <linux-kernel@vger.kernel.org>,
        Jan Seiffert <kaffeemonster@googlemail.com>
In-Reply-To: <m3tyjd7za9.fsf@intrepid.localdomain>
References: <20100902131531.GA19028@countzero.vandewege.net>
	 <m3mxrw1lg0.fsf@intrepid.localdomain>
	 <1289421869.9336.49.camel@giskard.codewiz.org>
	 <m3sjz34mka.fsf@intrepid.localdomain>
	 <1289944619.2677.22.camel@giskard.codewiz.org>
	 <m3tyjd7za9.fsf@intrepid.localdomain>
Content-Type: text/plain; charset="UTF-8"
Organization: Sugar Labs - http://www.sugarlabs.org/
Date: Mon, 22 Nov 2010 11:17:55 -0500
Message-ID: <1290442675.5515.92.camel@giskard.codewiz.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.0 (2.32.0-2.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-11-19 at 22:56 +0100, Krzysztof Halasa wrote:

> It seems it happens this way:
> - sca_xmit() fills the whole ring (leaving one descriptor empty as
>   designed - for EDA to work)
> - the chip transmits something and signals IRQ->sca_tx_done()
> - sca_tx_done can't see any descriptor processed and only wakes the
>   queue. Perhaps we should only wake the queue if at least one
>   descriptor has been processed - though sca_tx_done() should never be
>   called otherwise.
> - sca_xmit is called again with full ring, thus BUG().
> 
> I wonder if the following helps (untested):
> 
> --- a/drivers/net/wan/hd64572.c
> +++ b/drivers/net/wan/hd64572.c
> @@ -293,6 +293,7 @@ static inline void sca_tx_done(port_t *port)
>  	struct net_device *dev = port->netdev;
>  	card_t* card = port->card;
>  	u8 stat;
> +	int wake = 0;
>  
>  	spin_lock(&port->lock);
>  
> @@ -316,10 +317,12 @@ static inline void sca_tx_done(port_t *port)
>  			dev->stats.tx_bytes += readw(&desc->len);
>  		}
>  		writeb(0, &desc->stat);	/* Free descriptor */
> +		wake = 1;
>  		port->txlast = (port->txlast + 1) % card->tx_ring_buffers;
>  	}
>  
> -	netif_wake_queue(dev);
> +	if (wake)
> +		netif_wake_queue(dev);
>  	spin_unlock(&port->lock);
>  }

Last Friday I applied a patch very similar to this one, with a printk on
the no-wake case.

As you predicted, this made the BUG_ON() disappear. My printk fired
approximately at same frequency of the debug statements I had in
sca_xmit(), thus confirming your hypothesis.

Now the question is: why do we get so many spurious interrupts?

With this workaround applied, we're st seeing occasional clusters of
packet loss. We're working to graph the ping loss alongside traffic to
see if there's any correlation.

-- 
   // Bernie Innocenti - http://codewiz.org/
 \X/  Sugar Labs       - http://sugarlabs.org/

