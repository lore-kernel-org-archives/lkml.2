Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758282Ab0KSWFf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 17:05:35 -0500
Received: from khc.piap.pl ([195.187.100.11]:46109 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758251Ab0KSWF3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 17:05:29 -0500
X-Greylist: delayed 520 seconds by postgrey-1.27 at vger.kernel.org; Fri, 19 Nov 2010 17:05:29 EST
From: Krzysztof Halasa <khc@pm.waw.pl>
To: Bernie Innocenti <bernie@codewiz.org>
Cc: Ward Vandewege <ward@gnu.org>, lkml <linux-kernel@vger.kernel.org>
Subject: Re: pc300too on a modern kernel?
References: <20100902131531.GA19028@countzero.vandewege.net>
	<m3mxrw1lg0.fsf@intrepid.localdomain>
	<1289421869.9336.49.camel@giskard.codewiz.org>
	<m3sjz34mka.fsf@intrepid.localdomain>
	<1289944619.2677.22.camel@giskard.codewiz.org>
Date: Fri, 19 Nov 2010 22:56:46 +0100
In-Reply-To: <1289944619.2677.22.camel@giskard.codewiz.org> (Bernie
	Innocenti's message of "Tue, 16 Nov 2010 16:56:59 -0500")
Message-ID: <m3tyjd7za9.fsf@intrepid.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bernie Innocenti <bernie@codewiz.org> writes:

>> Also... it's rather improbable, but I'd look at the SCA-II chip. There
>> were certain chips with a hardware bug which could cause such problems.
>> Chips with Hitachi logo and "R" letter after the lot code were ok, and
>> all later chips made by Renesas (either missing any logo or with
>> Renesas' - no "R" letter there) were ok.
>> 
>> The faulty chips were marked with Hitachi logo and were missing the "R"
>> letter after the lot code. I think Hitachi fixed it in 1999 or so.
>> I'm not sure if this bug could manifest itself when only one SCA channel
>> was in use. The app note doesn't say a word about it, but I think I only
>> experienced the problem (with an older card, not PC300) when both
>> channels were simultaneously in use.
>
> Looks like we've hit this bug! Here's a photo of the board to confirm
> it's the bogus chip:
>
>  http://people.sugarlabs.org/bernie/pc300too-photo.jpg

It's weird. Hitachi's app note TN-PSC-337B/E dated Dec 10, 1998 shows
example lot codes for unfixed chips - "8A3" and fixed - "9A3 R". I don't
really remember the details, but I think the first digit is year (+1990)
and the last digit is quarter#. 0M1 would mean Q1 2000. I personally
have (different) cards with chips marked "9H1 R" and "0C1 R". I remember
a prototype card with something like 7** lot code (faulty, without the
"R") though I can't look up the code anymore. I'd never expect a faulty
chip dated 2000.

BTW their (now Renesas) errata is at
http://www.renesas.eu/products/assp/for_information_and_communication_equipment/com_control/Technical_Update.jsp
(I have the datasheet / prog manual as well). TN-PSC-337B/E seems to
indicate that the bug is present in chips made till March 31, 1999.

Your card has "SFL33" chip while my cards are "FL33". I have a card with
"SFL33" but it's dated 2005 and it's a newer chip, missing the "R" and
Hitachi logo because of Hitachi -> Renesas transition. I don't know what
"S" means. The datasheet (1998) only lists "FL33" = 25 Mb/s max transfer
rate and "AFL33" is 30 Mb/s.

> [   59.175900] bernie: stat=0x80, desc_address=ffffc900111003a8, port->chan=0
> [   59.176639] bernie: cp=3b4, bp=1ef18, len=56, unused=12
> [   67.159314] bernie: stat=0x80, desc_address=ffffc90011100390, port->chan=0
> [   67.163214] bernie: cp=39c, bp=1e298, len=56, unused=12
> [   68.425601] bernie: stat=0x80, desc_address=ffffc90011100390, port->chan=0
> [   68.426123] bernie: cp=39c, bp=1e298, len=77, unused=12
> [   70.312068] bernie: stat=0x80, desc_address=ffffc900111003b4, port->chan=0
> [   70.314393] bernie: cp=3c0, bp=1f558, len=1504, unused=12
>
> So it seems that sometimes the controller doesn't always clear the EOM
> (0x80) status bit after transmitting a frame. Size and contents of the
> packet doesn't seem to matter We're using a single T1 channel.

Actually, the SCA-II never clears EOM. sca_tx_done() does, after it sees
the "ownership" bit set by SCA-II. Then it does netif_wake_queue().

It seems it happens this way:
- sca_xmit() fills the whole ring (leaving one descriptor empty as
  designed - for EDA to work)
- the chip transmits something and signals IRQ->sca_tx_done()
- sca_tx_done can't see any descriptor processed and only wakes the
  queue. Perhaps we should only wake the queue if at least one
  descriptor has been processed - though sca_tx_done() should never be
  called otherwise.
- sca_xmit is called again with full ring, thus BUG().

I wonder if the following helps (untested):

--- a/drivers/net/wan/hd64572.c
+++ b/drivers/net/wan/hd64572.c
@@ -293,6 +293,7 @@ static inline void sca_tx_done(port_t *port)
 	struct net_device *dev = port->netdev;
 	card_t* card = port->card;
 	u8 stat;
+	int wake = 0;
 
 	spin_lock(&port->lock);
 
@@ -316,10 +317,12 @@ static inline void sca_tx_done(port_t *port)
 			dev->stats.tx_bytes += readw(&desc->len);
 		}
 		writeb(0, &desc->stat);	/* Free descriptor */
+		wake = 1;
 		port->txlast = (port->txlast + 1) % card->tx_ring_buffers;
 	}
 
-	netif_wake_queue(dev);
+	if (wake)
+		netif_wake_queue(dev);
 	spin_unlock(&port->lock);
 }
 

Perhaps the chip sets the bit in ISR0 register before ST_TX_OWNRSHP is
written to device RAM. With this patch sca_tx_done() should be called
again shortly, in the worst case after the next packed is transmitted.

> +++ linux-2.6.36/drivers/net/wan/hd64572.c	2010-11-12 20:48:03.000000000 -0500
> @@ -567,11 +567,20 @@ static netdev_tx_t sca_xmit(struct sk_bu
>  	card_t *card = port->card;
>  	pkt_desc __iomem *desc;
>  	u32 buff, len;
> +	uint8_t stat;
>  
>  	spin_lock_irq(&port->lock);
>  
>  	desc = desc_address(port, port->txin + 1, 1);
> -	BUG_ON(readb(&desc->stat)); /* previous xmit should stop queue */
> +
> +	//BUG_ON(readb(&desc->stat)); /* previous xmit should stop queue */
> +	stat = readb(&desc->stat); /* previous xmit should stop queue */
> +	if (stat) {
> +		printk(KERN_EMERG "bernie: stat=0x%02x, desc_address=%p, port->chan=%d\n", stat, desc, port->chan);
> +		printk(KERN_EMERG "bernie: cp=%x, bp=%x, len=%d, unused=%x\n", readw(&desc->cp), readl(&desc->bp), readw(&desc->len), readb(&desc->unused));
> +		printk(KERN_EMERG "bernie: %s TX(%i):", dev->name, skb->len);
> +		debug_frame(skb);
> +	}
>  
>  #ifdef DEBUG_PKT
>  	printk(KERN_DEBUG "%s TX(%i):", dev->name, skb->len);

This could send corrupted data, we don't want to overwrite buffers being
transmitted (or queued for TX).

Anyway, I think it has nothing to do with the "non-R" bug. That one
corrupts CDA register rendering any ring operation impossible and
probably corrupting system RAM (my experience is a single channel with
up to 2 Mb/s doesn't trigger it, two channels trigger it several times
a day). IOW, trying to use two channels with buggy chip is pointless.
OTOH I'm not sure your chip is buggy, perhaps SFL33 were always fixed
and thus not marked with "R"?
-- 
Krzysztof Halasa
