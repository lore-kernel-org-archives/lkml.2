Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755885Ab0FXVwO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jun 2010 17:52:14 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:60816
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754243Ab0FXVwN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jun 2010 17:52:13 -0400
Date: Thu, 24 Jun 2010 14:52:25 -0700 (PDT)
Message-Id: <20100624.145225.70206491.davem@davemloft.net>
To: liberty@extricom.com
Cc: linux-kernel@vger.kernel.org, galak@kernel.crashing.org
Subject: Re: [PATCH] gainfar.c : skb_over_panic (kernel-2.6.32.15)
From: David Miller <davem@davemloft.net>
In-Reply-To: <4C232B13.5000706@extricom.com>
References: <4C232B13.5000706@extricom.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eran Liberty <liberty@extricom.com>
Date: Thu, 24 Jun 2010 12:53:23 +0300

> Fix possible skb_over_panic event in Freescale's "gianfar" driver. 
> 
> The skb_over_panic occurs due to calling skb_put() within
> gfar_clean_rx_ring(). This happens if (and only if) shortly prior to
> the event and a few lined above the skb_put(), an skb was queued back
> to the priv->rx_recycle queue due to RXBD_LAST or RXBD_ERR status.
> The skb is queued without properly re-setting its state.
> 
> The patch properly reset the skb state.
> 
> I have tested this patch on MPC8548 based product and asserted it
> avoided the skb_over_panic event.
> 
> Signed-off-by: Eran Liberty <liberty@extricom.com>

Eran, this seems to be fixed already.  The code in the current
tree now reads:

				/*
				 * We need to un-reserve() the skb to what it
				 * was before gfar_new_skb() re-aligned
				 * it to an RXBUF_ALIGNMENT boundary
				 * before we put the skb back on the
				 * recycle list.
				 */
				skb_reserve(skb, -GFAR_CB(skb)->alignamount);
				__skb_queue_head(&priv->rx_recycle, skb);
