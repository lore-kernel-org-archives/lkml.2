Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759146Ab2EDQe1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 12:34:27 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:54290 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751182Ab2EDQe0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 12:34:26 -0400
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+4A+SFbzZyoRm03rl/pV3u
Date: Fri, 4 May 2012 09:34:20 -0700
From: Tony Lindgren <tony@atomide.com>
To: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Cc: Stephen Warren <swarren@wwwdotorg.org>,
        Linus Walleij <linus.walleij@linaro.org>, linux-omap@vger.kernel.org,
        Stephen Warren <swarren@nvidia.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] pinctrl: Add generic pinctrl-simple driver that
 supports omap2+ padconf
Message-ID: <20120504163420.GA5613@atomide.com>
References: <20120502172401.GG3739@atomide.com>
 <20120503065131.GA3738@game.jcrosoft.org>
 <20120503152708.GC5140@atomide.com>
 <4FA30805.5050804@wwwdotorg.org>
 <20120504044305.GD7788@game.jcrosoft.org>
 <20120504150342.GI5140@atomide.com>
 <20120504153251.GE7788@game.jcrosoft.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120504153251.GE7788@game.jcrosoft.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com> [120504 08:58]:
> On 08:03 Fri 04 May     , Tony Lindgren wrote:
> > > 
> > > so I was thinking to do like on gpio
> > > 
> > > uart {
> > > 	pin = < &pioA 12 {pararms} >
> > > 
> > > }
> > 
> > Hmm I assume the "12" above the gpio number?
> no pin number in the bank because it could not be gpio

Yes OK, but pin number 12 in the gpio bank, not in the mux register.
Got it.
 
> 	pioD: gpio@fffff800 {
> 		compatible = "atmel,at91rm9200-gpio";
> 		reg = <0xfffff800 0x100>;
> 		interrupts = <5 4>;
> 		#gpio-cells = <2>;
> 		gpio-controller;
> 		interrupt-controller;
> 	};
> 
> 	pioE: gpio@fffffa00 {
> 		compatible = "atmel,at91rm9200-gpio";
> 		reg = <0xfffffa00 0x100>;
> 		interrupts = <5 4>;
> 		#gpio-cells = <2>;
> 		gpio-controller;
> 		interrupt-controller;
> 	};
> 
> 	dbgu {
> 		pins = < &pioB 12 0 0
> 			 &pioB 13 0 2 >;
> 	/* with macro */
> 		pins = < &pioB 12 MUX_A NO_PULL_UP
> 			 &pioB 13 MUX_A PULL_UP >;
> 	};

I could change to use this too no problem. The only concern I have is
that is "&pioB 12" immutable for all gpio controllers?

Grepping the *.dts* files, at least exynos is using the following
for gpios:

gpios = <&gpx2 0 0 0 2>;

If we can conclude that phandle to the gpio controller instance and
the register offset is always enough here, then I'm OK changing to
that format. It would actually save some parsing in most cases.
 
> 	/* and also the notion of linked group
> 	 * as on uart of network you have often the same subset of pin use.
> 	 *
> 	 * As example on uart rxd/txd is use for the group without rts/cts
> 	 * and the one with it
> 	 * on ethernet the RMII pin are use also on MII
> 	 */
> 
> 	uart0_rxd_txd {
> 		pins = < &pioB 19 MUX_A PULL_UP		/* rxd */
> 			 &pioB 18 MUX_A NO_PULL_UP >;	/* txd */
> 	};
> 
> 	uart0_rts_cts {
> 		groups = < &uart0_rxd_txd >;
> 		pins = < &pioB 17 MUX_B NO_PULL_UP	/* rts */
> 			 &pioB 15 MUX_B NO_PULL_UP >;	/* cts */
> 	};
> 
> 	uart0_rts_cts_external_pull_up {
> 		groups = < &uart0_rts_cts >;
> 		gpios = <&pioC 1 0>;
> 	};
> };
> 
> The idea is to avoid duplication the xlate for pins will be driver specific
> with maybe a common implementation
> 
> the 3 or 4 first fix as done on gpio

Yeah sounds doable to me, but can probably be added later?

Regarding grouping, basically for most cases it makes sense to have
three states: default, active, idle instead of just active and idle.
The reason is that for most cases the default pins only need to be
set once for each devices. Only few pins need to toggle between
active and idle states.

For example, omap2 uart needs to toggle rx pin to gpio input everytime
it hits idle to provide wake-up events. Other pins do not need to change.
As this is done all the time, the active and idle toggling should be kept
to minimum.

Regards,

Tony
