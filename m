Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752988Ab0CWU0n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 16:26:43 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:61288 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752670Ab0CWU0k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 16:26:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=eEJAazXQ8Pgw3aVU8kZzPwmehSkO95LChiK2b7NOgLC9rOc6W/sCZqjORF+gLXtvM2
         xbA2MyucDotApUiwfTkz27+/Mb5UAEX07pY0QIqD2QSA+R4yhQr29Xd3O1kd471pgoqc
         k4rEa/jULu4NcI+NuGKuABeC8901D88jErecs=
MIME-Version: 1.0
In-Reply-To: <20100203143803.528679118@gmail.com>
References: <20100203143736.564974126@gmail.com>
	 <20100203143803.528679118@gmail.com>
Date: Tue, 23 Mar 2010 22:26:39 +0200
Message-ID: <cd73a99e1003231326r7623bbc0icba163f9b2e0e96e@mail.gmail.com>
Subject: Re: [patch v3 2/3] at91_udc HW glitch
From: Andrew Victor <avictor.za@gmail.com>
To: Harro Haan <hrhaan@gmail.com>
Cc: Ryan Mallon <ryan@bluewatersys.com>, Remy Bohmer <linux@bohmer.net>,
       Andrew Victor <linux@maxim.org.za>,
       David Brownell <dbrownell@users.sourceforge.net>,
       H Hartley Sweeten <hartleys@visionengravers.com>,
       Anti Sullin <anti.sullin@artecdesign.ee>,
       linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,

> Add some delay to avoid reading CSR TXCOUNT too early after updating it.
>
> Signed-off-by: Anti Sullin <anti.sullin@artecdesign.ee>
> Signed-off-by: Harro Haan <hrhaan@gmail.com>
> Acked-by: Remy Bohmer <linux@bohmer.net>
> ---
>  drivers/usb/gadget/at91_udc.c |    7 +++++++
>  1 file changed, 7 insertions(+)
>
> Index: linux-2.6.31/drivers/usb/gadget/at91_udc.c
> ===================================================================
> --- linux-2.6.31.orig/drivers/usb/gadget/at91_udc.c
> +++ linux-2.6.31/drivers/usb/gadget/at91_udc.c
> @@ -366,6 +366,13 @@ rescan:
>        if (is_done)
>                done(ep, req, 0);
>        else if (ep->is_pingpong) {
> +               /*
> +                * One dummy read to delay the code because of a HW glitch:
> +                * CSR returns bad RXCOUNT when read too soon after updating
> +                * RX_DATA_BK flags.
> +                */
> +               csr = __raw_readl(creg);
> +
>                bufferspace -= count;
>                buf += count;
>                goto rescan;

I see in the data-sheet (SAM9261 / SAM9263), the following for the
UDP_ CSRx registers:

"WARNING: Due to synchronization between MCK and UDPCK, the software
application must wait for the end of the write
operation before executing another write by polling the bits which
must be set/cleared."

//! Clear flags of UDP UDP_CSR register and waits for synchronization
#define Udp_ep_clr_flag(pInterface, endpoint, flags) { \
    while (pInterface->UDP_CSR[endpoint] & (flags)) \
        pInterface->UDP_CSR[endpoint] &= ~(flags); \
     }
//! Set flags of UDP UDP_CSR register and waits for synchronization
#define Udp_ep_set_flag(pInterface, endpoint, flags) { \
    while ( (pInterface->UDP_CSR[endpoint] & (flags)) != (flags) ) \
       pInterface->UDP_CSR[endpoint] |= (flags); \
    }

The at91_udc driver does not seem to do that for its CSR register writes.
So I was wondering if we implement what the datasheet says, would we
still need the "fix" above.


Regards,
  Andrew Victor
