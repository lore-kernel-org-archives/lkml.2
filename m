Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754346Ab0G1IJt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jul 2010 04:09:49 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:39510 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753978Ab0G1IJn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jul 2010 04:09:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=uZ7KylCNV6ypgItloT4INmszBdmgM+mwljs7iQQ7jjdnGtfhV9T9+tJkjceNWwYcpO
         xFwQTL+q0UY3itNkMHF0hy9ECfKzr1Rpxd20vUzt8soQZDZnrlyPSMrS9bHZHZq6hANo
         9gV+BuVgyKjsM4m/7TnKWGkj3ZYhy0IxeuXrs=
MIME-Version: 1.0
In-Reply-To: <1277811391-17966-1-git-send-email-linus.walleij@stericsson.com>
References: <1277811391-17966-1-git-send-email-linus.walleij@stericsson.com>
Date: Wed, 28 Jul 2010 01:09:42 -0700
X-Google-Sender-Auth: EAJv9sBSgWOUoR8cj5wB8zUyAMU
Message-ID: <AANLkTi=jStVGbJC7jUyhOG3og14F58rw+LEN2UqnP-X0@mail.gmail.com>
Subject: Re: [PATCH 2/2] DMAENGINE: driver for the ARM PL080/PL081 PrimeCells
From: Dan Williams <dan.j.williams@intel.com>
To: Linus Walleij <linus.walleij@stericsson.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        yuanyabin1978@sina.com, Peter Pearse <peter.pearse@arm.com>,
        Ben Dooks <ben-linux@fluff.org>, Kukjin Kim <kgene.kim@samsung.com>,
        Alessandro Rubini <rubini@unipv.it>,
        Viresh Kumar <viresh.kumar@st.com>,
        Russell King <rmk@arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 29, 2010 at 4:36 AM, Linus Walleij
<linus.walleij@stericsson.com> wrote:
> This creates a DMAengine driver for the ARM PL080/PL081 PrimeCells
> based on the implementation earlier submitted by Peter Pearse.
> This is working like a charm for memcpy and slave DMA to the PL011
> PrimeCell on the PB11MPCore.
>
> This DMA controller is used in mostly unmodified form in the ARM
> RealView and Versatile platforms, in the ST-Ericsson Nomadik, and
> in the ST SPEAr platform.
>
> It has been converted to use the header from the Samsung PL080
> derivate instead of its own defintions. The Samsungs have a custom
> driver in their mach-* folders though, atleast we can share the
> register definitions.
>
> Cc: Peter Pearse <peter.pearse@arm.com>
> Cc: Ben Dooks <ben-linux@fluff.org>
> Cc: Kukjin Kim <kgene.kim@samsung.com>
> Cc: Alessandro Rubini <rubini@unipv.it>
> Cc: Viresh Kumar <viresh.kumar@st.com>
> Signed-off-by: Linus Walleij <linus.walleij@stericsson.com>
> ---
> Changes since last revision: this has now been successfully tested
> with PL011 UART on the PB11MPCore.
>
> It now uses the generic runtime slave control and not the PrimeCell
> extensions, and thus depends only on that patch set. With the previous
> patch to the header file this is cleanly separated from the ARM tree
> and any PrimeCell drivers and can go into the async_tx tree as it is
> without further dependencies.
> ---

Russell I am assuming this implementation and testing is sufficient to
allay your prior nak [1]?  Linus is oversubscribing virtual channels
to physical channels to handle muxing.

> +#ifdef MODULE
> +
> +# error "AMBA PL08X DMA CANNOT BE COMPILED AS A LOADABLE MODULE AT PRESENT"
> +
> +/*
> +       a) Some devices might make use of DMA during boot
> +          (esp true for DMAENGINE implementation)
> +       b) Memory allocation will need much more attention
> +          before load/unload can be supported
> + */
> +#endif

This is taken care of by being "config bool", but I assume you want
this for documentation purposes?

> +       txd = kzalloc(sizeof(struct pl08x_txd), GFP_KERNEL);

...appears in the prep routines.  Will this driver be used by any
storage controllers on the platfom?  Might we deadlock waiting on i/o
that needs to allocate a descriptor to complete?

--
Dan

[1]: http://marc.info/?l=linux-arm-kernel&m=127350477914098&w=2
