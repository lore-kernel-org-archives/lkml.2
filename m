Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757149Ab0ETUKq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 May 2010 16:10:46 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:44867 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754606Ab0ETUKp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 May 2010 16:10:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject:references
         :in-reply-to:content-type:content-transfer-encoding;
        b=C/f8UPO8AXElC1FJq+zycMcRnR3wZSjki6nGEYJq6mYrBpEr208iGlAkhJIRuXOESW
         oTTMuQGI/IWIfA61mz6uEulvAC0U9OerqFAsLl1FUoS8l/1I3J2gre0H0nBpMqZW9Myw
         HdVP5MgEsFCsbN9KHxBEJ7l9tcWKou33DFHKs=
Message-ID: <4BF5974A.4050100@gmail.com>
Date: Thu, 20 May 2010 13:10:50 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091114 Lightning/1.0pre Thunderbird/3.0b4
MIME-Version: 1.0
To: Jens.Kuenzer@fpga.homeip.net, linux-pcmcia@lists.infradead.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH][bisected]pcmcia:yenta_socket.c fix broken wireless cards.
References: <1274303284-21529-1-git-send-email-justinmattock@gmail.com> <20100520145434.GA12166@comet.dominikbrodowski.net> <4BF55AC9.4000905@gmail.com> <20100520163419.GA16522@comet.dominikbrodowski.net>
In-Reply-To: <20100520163419.GA16522@comet.dominikbrodowski.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/20/2010 09:34 AM, Dominik Brodowski wrote:
> Jens, Justin,
>
> could both of you test this patch on top of 2.6.34, please?
>
> pcmcia: only keep saved I365_CSCING flag if there is no PCI irq
>
> Signed-off-by: Dominik Brodowski<linux@dominikbrodowski.net>
>
> diff --git a/drivers/pcmcia/yenta_socket.c b/drivers/pcmcia/yenta_socket.c
> index 424e576..151ca43 100644
> --- a/drivers/pcmcia/yenta_socket.c
> +++ b/drivers/pcmcia/yenta_socket.c
> @@ -371,8 +371,11 @@ static int yenta_set_socket(struct pcmcia_socket *sock, socket_state_t *state)
>   			exca_writeb(socket, I365_POWER, reg);
>
>   		/* CSC interrupt: no ISA irq for CSC */
> -		reg = exca_readb(socket, I365_CSCINT);
> -		reg&= I365_CSC_IRQ_MASK;
> +		reg = 0;
> +		if (!socket->dev->irq) {
> +			reg = exca_readb(socket, I365_CSCINT);
> +			reg&= I365_CSC_IRQ_MASK;
> +		}
>   		reg |= I365_CSC_DETECT;
>   		if (state->flags&  SS_IOCARD) {
>   			if (state->csc_mask&  SS_STSCHG)
>


hmm.. not sure if this is even being read or not
as a simple test:


    		/* CSC interrupt: no ISA irq for CSC */
  -		reg = exca_readb(socket, I365_CSCINT);
  -		reg&= I365_CSC_IRQ_MASK;
  +		reg = 0;
  +		if (!socket->dev->irq) {
  +			reg = exca_readb(socket, I365_STATUS);
  +			/*reg&= I365_CSC_IRQ_MASK;*/
  +		}

just a simple STATUS on this still errors out with the
unsupported card thing..


Justin P. Mattock
