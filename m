Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933063Ab1ERMVD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 08:21:03 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:60882 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932624Ab1ERMVB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 08:21:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=VsPNEI2iqlwavCmlldcLpSafZuxwi48nrJT5wELUzD45Fl3pEmiTrNciGk8V7LvroZ
         HDQPvWSpdDkEID8VA2bo8KPYb0OL/c/2YMjYWEN5soiZKrkKClOFQCDJasXHjOYHXpUq
         DrBv0Vbf8DU6TuxC2l086UQXO8U2CrfY2UNfo=
MIME-Version: 1.0
In-Reply-To: <4DD20D89.9020402@st.com>
References: <f06f05e982c6182565a7fee1f7d6396cae895133.1305521318.git.viresh.kumar@st.com>
	<1305561993.28926.73.camel@vkoul-udesk3>
	<4DD1F443.1040205@st.com>
	<1305603818.28926.82.camel@vkoul-udesk3>
	<4DD20D89.9020402@st.com>
Date: Wed, 18 May 2011 14:21:00 +0200
X-Google-Sender-Auth: g6CDZikkdGAAhxsBddSUlJs7i1U
Message-ID: <BANLkTi=zrr4==Uatq3zbdE1K+1_9ELOBZQ@mail.gmail.com>
Subject: Re: [PATCH] dw_dmac: Replace subsys_init() with arch_initcall()
From: Linus Walleij <linus.walleij@linaro.org>
To: viresh kumar <viresh.kumar@st.com>
Cc: "Koul, Vinod" <vinod.koul@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        Armando VISCONTI <armando.visconti@st.com>,
        Shiraz HASHIM <shiraz.hashim@st.com>,
        "viresh.linux@gmail.com" <viresh.linux@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/5/17 viresh kumar <viresh.kumar@st.com>:

> SPI bus is required for regulators and so probably he can't have
> module_init() for amba-pl022.

Nope. Regulators have to be at subsystem_init() because lots
of  drivers called in module_init() == driver_init() will need
to enable them to even be able to talk to the hardware they
are regulating.

e.g. an externally powered I2C device. If you cannot put power
to it you cannot probe it.

Then you end up in a dependency: we need to have SPI
to enble the regulators - the SPI device containing the
regulators is a device that is self-powered.

So then of course the SPI bus controller has to be
available, so it has to be subsys_initcall() as well.
Luckily as it happens it is earlier in the linkfile than
regulators, so using the same initlevel as regulators
will work (else we would be in hell).

But since the PL022 uses DMA, we have to have DMA
before SPI, and it is currently linked *after* SPI in the
Makefile.

> @Linus: What do you say? Can we get back to module_init() for amba-pl022?
> And subsys_initcall() for DMA.

No, but I sent a patch that will make it possible to have both
as subsys_init(), check it out, it seems to work for me.

Can you test it? (Sorry forgot to add you on CC, title is
"[PATCH] dmaengine: move link order".

Yours,
Linus Walleij
