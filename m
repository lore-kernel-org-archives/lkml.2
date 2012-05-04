Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759387Ab2EDSzw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 14:55:52 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:42175 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753876Ab2EDSzt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 14:55:49 -0400
Message-ID: <4FA42631.6060304@wwwdotorg.org>
Date: Fri, 04 May 2012 12:55:45 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.28) Gecko/20120313 Thunderbird/3.1.20
MIME-Version: 1.0
To: Tony Lindgren <tony@atomide.com>
CC: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Linus Walleij <linus.walleij@linaro.org>, linux-omap@vger.kernel.org,
        Stephen Warren <swarren@nvidia.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] pinctrl: Add generic pinctrl-simple driver that supports
 omap2+ padconf
References: <20120502172401.GG3739@atomide.com> <20120503065131.GA3738@game.jcrosoft.org> <20120503152708.GC5140@atomide.com> <4FA30805.5050804@wwwdotorg.org> <20120504044305.GD7788@game.jcrosoft.org> <20120504150342.GI5140@atomide.com> <20120504153251.GE7788@game.jcrosoft.org> <20120504163420.GA5613@atomide.com>
In-Reply-To: <20120504163420.GA5613@atomide.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/04/2012 10:34 AM, Tony Lindgren wrote:
> * Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com> [120504 08:58]:
>> On 08:03 Fri 04 May     , Tony Lindgren wrote:
>>>>
>>>> so I was thinking to do like on gpio
>>>>
>>>> uart {
>>>> 	pin = < &pioA 12 {pararms} >
>>>>
>>>> }
>>>
>>> Hmm I assume the "12" above the gpio number?
>> no pin number in the bank because it could not be gpio
> 
> Yes OK, but pin number 12 in the gpio bank, not in the mux register.
> Got it.

I'd prefer to avoid any references to GPIOs here; not all muxable pins
are GPIOs and not all GPIOs are muxable pins. Lets keep the two concepts
independent.

>> 	pioD: gpio@fffff800 {
>> 		compatible = "atmel,at91rm9200-gpio";
>> 		reg = <0xfffff800 0x100>;
>> 		interrupts = <5 4>;
>> 		#gpio-cells = <2>;
>> 		gpio-controller;
>> 		interrupt-controller;
>> 	};
>>
>> 	pioE: gpio@fffffa00 {
>> 		compatible = "atmel,at91rm9200-gpio";
>> 		reg = <0xfffffa00 0x100>;
>> 		interrupts = <5 4>;
>> 		#gpio-cells = <2>;
>> 		gpio-controller;
>> 		interrupt-controller;
>> 	};
>>
>> 	dbgu {
>> 		pins = < &pioB 12 0 0
>> 			 &pioB 13 0 2 >;
>> 	/* with macro */
>> 		pins = < &pioB 12 MUX_A NO_PULL_UP
>> 			 &pioB 13 MUX_A PULL_UP >;
>> 	};
> 
> I could change to use this too no problem. The only concern I have is
> that is "&pioB 12" immutable for all gpio controllers?

You mean is the number of cells used to specify a GPIO the same
everywhere? No. It's defined by #gpio-cells in the GPIO controller node.

But again, the GPIO binding shouldn't be related to the pinctrl binding
directly.

> Grepping the *.dts* files, at least exynos is using the following
> for gpios:
> 
> gpios = <&gpx2 0 0 0 2>;
> 
> If we can conclude that phandle to the gpio controller instance and
> the register offset is always enough here, then I'm OK changing to
> that format. It would actually save some parsing in most cases.
>  
>> 	/* and also the notion of linked group
>> 	 * as on uart of network you have often the same subset of pin use.
>> 	 *
>> 	 * As example on uart rxd/txd is use for the group without rts/cts
>> 	 * and the one with it
>> 	 * on ethernet the RMII pin are use also on MII
>> 	 */
>>
>> 	uart0_rxd_txd {
>> 		pins = < &pioB 19 MUX_A PULL_UP		/* rxd */
>> 			 &pioB 18 MUX_A NO_PULL_UP >;	/* txd */
>> 	};

I don't really see how that DT format represents pins, functions, and
nodes directly, and separately from which of those a board chooses to
use. I think this binding and the one Tony originally proposed are
eseentially semantically identical.

Going back to my idea of separating SoC and board configurations, if we
did that, I'd expect to see something more like:

soc.dtsi or board.dts:

This is the data that the pin controller driver needs to export to
pinctrl core. This can be completely enumerated in the soc.dtsi, or
perhaps for uncommonly used pins/groups/functions, only included in the
board.dts that actually uses it to cut down on soc.dtsi's size:

This data is not needed for SoCs whose pinctrl drivers include it in
their driver file instead of DT.

/ {
    pinctrl@... {
        pins {
            uart1_rx_pin: uart1_rx {
                /* register to program the pin if per-pin muxing*/
                reg = ...;
                name = "UART1_RX";
                ...;
            }
            uart1_tx_pin: uart1_tx {
                reg = ...;
                name = "UART1_TX";
                ...;
            }
            uart2_rx_pin: uart2_rx {
                reg = ...;
                name = "UART2_RX";
                ...;
            }
            uart2_tx_pin: uart2_tx {
                reg = ...;
                name = "UART2_TX";
                ...;
            }
        };
        pingroups {
            uart1_pg: uart1 {
                /* register to program the group, if per-grouop muxing */
                reg = ...;
                pins = <&pin_uart1_rx &pin_uart1_tx>;
            }
            uart2_pg: uart2 {
                pins = <&pin_uart2_rx &pin_uart2_tx>;
            }
        };
        functions {
            uart1_func: uart1 {
                selectable-on = <&uart1_pg 0>; /* where, mux value */
            };
            uart2_func: uart2 {
                selectable-on = <&uart2_pg 0>;
            };
            spi_func: spi {
                selectable-on = <&uart1_pg 1 &uart2_pg 1>;
            };
    };

soc.dtsi or board.dts:

This is part of the data used to construct the mapping table. Common
options for function X on pin/pingroup Y can be included in soc.dtsi to
reduce duplication in board files. Uncommon options can be included
directly in the board.dts that uses them, to avoid bloating soc.dtsi:

This data is needed irrespective of whether a SoC pinctrl driver stores
the pin/function/group information in DT or in the driver itself.

/ {
    pinctrl@... {
        uart1_uart1 {
            muxing = <&uart1_pg &uart1_func>;
            ... other pinconfig stuff perhaps;
        }
        spi1_uart2 {
            muxing = <&uart2_pg &uart2_func>;
            ... other pinconfig stuff perhaps;
        }
    }
};

board.dts:

Finally, each board defines which of the muxing options to actually use.

This data is needed irrespective of whether a SoC pinctrl driver stores
the pin/function/group information in DT or in the driver itself.

/ {
    uart@... {
        pinctrl-names = "default";
        pinctrl-0 = <&uart1_uart1>;
    };
    spi@... {
        pinctrl-names = "default";
        pinctrl-0 = <&spi1_uart2>;
    };
};

>> 	uart0_rts_cts {
>> 		groups = < &uart0_rxd_txd >;
>> 		pins = < &pioB 17 MUX_B NO_PULL_UP	/* rts */
>> 			 &pioB 15 MUX_B NO_PULL_UP >;	/* cts */
>> 	};
>>
>> 	uart0_rts_cts_external_pull_up {
>> 		groups = < &uart0_rts_cts >;
>> 		gpios = <&pioC 1 0>;
>> 	};
>> };
>>
>> The idea is to avoid duplication the xlate for pins will be driver specific
>> with maybe a common implementation
>>
>> the 3 or 4 first fix as done on gpio
> 
> Yeah sounds doable to me, but can probably be added later?
> 
> Regarding grouping, basically for most cases it makes sense to have
> three states: default, active, idle instead of just active and idle.

The set of state names should be determined by the client driver, not
the pinctrl core or driver binding, any pinctrl code.
