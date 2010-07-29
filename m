Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758017Ab0G2QNX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jul 2010 12:13:23 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:35524 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757955Ab0G2QNW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jul 2010 12:13:22 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <4C51A88B.3040807@s5r6.in-berlin.de>
Date: Thu, 29 Jul 2010 18:12:59 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.23) Gecko/20100627 SeaMonkey/1.1.18
MIME-Version: 1.0
To: linux1394-devel@lists.sourceforge.net
CC: linux-kernel@vger.kernel.org, Jay Fenlason <fenlason@redhat.com>
Subject: Re: [PATCH rfc] firewire: add isochronous multichannel reception
References: <tkrat.c7f7ffc33f9f1ed2@s5r6.in-berlin.de>
In-Reply-To: <tkrat.c7f7ffc33f9f1ed2@s5r6.in-berlin.de>
X-Enigmail-Version: 0.96.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stefan Richter wrote:
>  static int ohci_queue_iso(struct fw_iso_context *base,
>  			  struct fw_iso_packet *packet,
>  			  struct fw_iso_buffer *buffer,
> @@ -2587,14 +2761,17 @@ static int ohci_queue_iso(struct fw_iso_
>  {
>  	struct iso_context *ctx = container_of(base, struct iso_context, base);
>  	unsigned long flags;
> -	int ret;
> +	int ret = -ENOSYS;
>  
>  	spin_lock_irqsave(&ctx->context.ohci->lock, flags);
> -	if (base->type == FW_ISO_CONTEXT_TRANSMIT)
> -		ret = ohci_queue_iso_transmit(base, packet, buffer, payload);
> -	else
> -		ret = ohci_queue_iso_receive_packet_per_buffer(base, packet,
> -							buffer, payload);
> +	switch (base->type) {
> +	case FW_ISO_CONTEXT_TRANSMIT:
> +		ret = queue_iso_transmit(base, packet, buffer, payload);
> +	case FW_ISO_CONTEXT_RECEIVE:
> +		ret = queue_iso_packet_per_buffer(base, packet, buffer, payload);
> +	case FW_ISO_CONTEXT_RECEIVE_MULTICHANNEL:
> +		ret = queue_iso_buffer_fill(base, packet, buffer, payload);
> +	}
>  	spin_unlock_irqrestore(&ctx->context.ohci->lock, flags);
>  
>  	return ret;

Where is the brown paper bag...
There should be break; at each case.  Updated patch is at
http://user.in-berlin.de/~s5r6/linux1394/pending/1171-firewire-add-isochronous-multichannel-reception.patch
-- 
Stefan Richter
-=====-==-=- -=== ===-=
http://arcgraph.de/sr/
