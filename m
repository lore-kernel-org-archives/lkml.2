Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753103Ab0ETO7b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 May 2010 10:59:31 -0400
Received: from isilmar-3.linta.de ([188.40.101.200]:55370 "EHLO linta.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752340Ab0ETO73 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 May 2010 10:59:29 -0400
Date: Thu, 20 May 2010 16:54:34 +0200
From: Dominik Brodowski <linux@dominikbrodowski.net>
To: "Justin P. Mattock" <justinmattock@gmail.com>
Cc: linux-pcmcia@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH][bisected]pcmcia:yenta_socket.c fix broken wireless
 cards.
Message-ID: <20100520145434.GA12166@comet.dominikbrodowski.net>
Mail-Followup-To: "Justin P. Mattock" <justinmattock@gmail.com>,
	linux-pcmcia@lists.infradead.org, linux-kernel@vger.kernel.org
References: <1274303284-21529-1-git-send-email-justinmattock@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1274303284-21529-1-git-send-email-justinmattock@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Justin,

On Wed, May 19, 2010 at 02:08:04PM -0700, Justin P. Mattock wrote:
> I've an old dell inspiron 1200(amazingly still works), that use's
> a D-Link DWL-G650, and/or a Dell Wireless 1350 for it's wireless
> connection.
> 
> With using opensuse11.2(kernel:2.6.32*), the card(s) work fine, but as soon
> as I pulled the latest HEAD, all hell broke loose. So after doing a
> days worth of bisecting with this machine(painfully slow), it finally
> came down to this commit:
> 
> commit 28ca8dd71fc170090edca62cb8129625d01b7760
> Author: Jens K<C3><BC>nzer <Jens.Kuenzer@fpga.homeip.net>
> Date:   Sat Mar 6 07:46:16 2010 +0100
> 
>     pcmcia: honor saved flags in yenta_socket's I365_CSCINT register
>     
>     Instead of overwriting the I365_CSCINT register, save the old value and
>     merely change the bits we care about.
>     
>     Part 1 of a series to allow the ISA irq to be used for Cardbus devices
>     if the socket's PCI irq is unusable.
>     
>     [linux@dominikbrodowski.net: split up the original patch, commit message]
>     
>     Signed-off-by: Jens Kuenzer <Jens.Kuenzer@fpga.homeip.net>
>     Signed-off-by: Dominik Brodowski <linux@dominikbrodowski.net>
>  
> so after fussing around with this commit, and yenta_socket.c
> I come up with something, that does get my cards
> powered up, and all good(hopefully).
> 
> Anyways please have a look, if you need me to test something
> different let me know. 
>  
>  Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

Thanks for tracking this issue down! Could you check what "reg" returned
before you applied your patch, and what it is after you applied your patch?

> diff --git a/drivers/pcmcia/yenta_socket.c b/drivers/pcmcia/yenta_socket.c
> index 83ace27..7d6f43b 100644
> --- a/drivers/pcmcia/yenta_socket.c
> +++ b/drivers/pcmcia/yenta_socket.c
> @@ -989,7 +989,7 @@ static int yenta_probe_cb_irq(struct yenta_socket *socket)
>  	}
>  
>  	/* generate interrupt, wait */
> -	reg = exca_readb(socket, I365_CSCINT);
> +	reg = exca_readb(socket, I365_CSCINT | I365_CSC_ANY);

the second parameter to exca_readb() is the address which we read from.
I365_CSCINT is the register at offset 0x05; CSC_ANY isn't a register offset,
but 0x0f ... so you're reading now from a register at offset 0x0f.

Still, something needs to be fixed -- and to do that, it'd be great if you
could tell us the value of "reg" which works, and the value which doesn't.
Then I'll prepare a patch for testing, so that it hopefully not only works
on your system, but also on Jens'.

Best,
	Dominik
