Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754977Ab0F1IBR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jun 2010 04:01:17 -0400
Received: from smtp.extricom.com ([192.114.46.18]:34584 "HELO
	smtp.extricom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752794Ab0F1IBQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jun 2010 04:01:16 -0400
X-Greylist: delayed 398 seconds by postgrey-1.27 at vger.kernel.org; Mon, 28 Jun 2010 04:01:15 EDT
Message-ID: <4C2855D4.5050507@extricom.com>
Date: Mon, 28 Jun 2010 10:57:08 +0300
From: Eran Liberty <liberty@extricom.com>
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20090706)
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: linux-kernel@vger.kernel.org, galak@kernel.crashing.org
Subject: Re: [PATCH] gainfar.c : skb_over_panic (kernel-2.6.32.15)
References: <4C232B13.5000706@extricom.com> <20100624.145225.70206491.davem@davemloft.net>
In-Reply-To: <20100624.145225.70206491.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller wrote:
> From: Eran Liberty <liberty@extricom.com>
> Date: Thu, 24 Jun 2010 12:53:23 +0300
>
>   
>> Fix possible skb_over_panic event in Freescale's "gianfar" driver. 
>>
>> The skb_over_panic occurs due to calling skb_put() within
>> gfar_clean_rx_ring(). This happens if (and only if) shortly prior to
>> the event and a few lined above the skb_put(), an skb was queued back
>> to the priv->rx_recycle queue due to RXBD_LAST or RXBD_ERR status.
>> The skb is queued without properly re-setting its state.
>>
>> The patch properly reset the skb state.
>>
>> I have tested this patch on MPC8548 based product and asserted it
>> avoided the skb_over_panic event.
>>
>> Signed-off-by: Eran Liberty <liberty@extricom.com>
>>     
>
> Eran, this seems to be fixed already.  The code in the current
> tree now reads:
>
> 				/*
> 				 * We need to un-reserve() the skb to what it
> 				 * was before gfar_new_skb() re-aligned
> 				 * it to an RXBUF_ALIGNMENT boundary
> 				 * before we put the skb back on the
> 				 * recycle list.
> 				 */
> 				skb_reserve(skb, -GFAR_CB(skb)->alignamount);
> 				__skb_queue_head(&priv->rx_recycle, skb);
>
>
>   
This code has proved to be insufficient and produce skb_over_panic. The 
proposed patch fix this.

-- Liberty

