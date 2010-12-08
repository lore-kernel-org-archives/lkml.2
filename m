Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754050Ab0LHUMH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 15:12:07 -0500
Received: from mail.bluewatersys.com ([202.124.120.130]:28781 "EHLO
	hayes.bluewaternz.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752108Ab0LHUMF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 15:12:05 -0500
Message-ID: <4CFFE6EC.5020008@bluewatersys.com>
Date: Thu, 09 Dec 2010 09:13:32 +1300
From: Ryan Mallon <ryan@bluewatersys.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.12) Gecko/20100915 Thunderbird/3.0.8
MIME-Version: 1.0
To: Igor Plyatov <plyatov@gmail.com>
CC: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux@maxim.org.za, nicolas.ferre@atmel.com, linux@arm.linux.org.uk,
        costa.antonior@gmail.com, plagnioj@jcrosoft.com,
        christian.glindkamp@taskit.de, pgsellmann@portner-elektronik.at
Subject: Re: [PATCH v3] mach-at91: Support for gms board added
References: <1291837552-8389-1-git-send-email-plyatov@gmail.com>
In-Reply-To: <1291837552-8389-1-git-send-email-plyatov@gmail.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/09/2010 08:45 AM, Igor Plyatov wrote:
> Code for the Stamp9G20 SoM separated into the board-stamp9g20.c, and following
> files correspond to carrier boards for Stamp9G20:
> * carrier-board-gms.c - "GMS", Seismograph from GeoSIG.
> * carrier-board-panelcardevb.c - "Panel Card EVB", Taskit's eval. board.
> * carrier-board-portuxg20.c - "Portux G20", derivative from Stamp9G20.
> * carrier-board-pcontrol_g20.c - "Pcontrol G20", PORTNER-Elektronik.
> .
> All stuff specific to carrier board encapsulated into functions:
> * carrier_board_map_io()
> * carrier_board_init()
> which used in the board-stamp9g20.c
> .
> There is only one choice for Stamp9G20 carrier board from:
> * CONFIG_CARRIERBOARD_GMS
> * CONFIG_CARRIERBOARD_PANELCARDEVB
> * CONFIG_CARRIERBOARD_PCONTROL_G20
> * CONFIG_CARRIERBOARD_PORTUXG20

It is useful to be able to build multiple boards into a single kernel.

> --- /dev/null
> +++ b/arch/arm/mach-at91/carrier-board-gms.c
> @@ -0,0 +1,556 @@
> +/*
> + *  Copyright (C) 2010 Christian Glindkamp <christian.glindkamp@taskit.de>
> + *			taskit GmbH
> + *                2010 Igor Plyatov <plyatov@gmail.com>
> + *			GeoSIG Ltd
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write to the Free Software
> + * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
> + */
> +
> +#include <linux/platform_device.h>
> +#include <linux/gpio.h>
> +#include <linux/gpio_keys.h>
> +#include <linux/input.h>
> +#include <linux/i2c/pcf857x.h>
> +
> +#include <mach/board.h>
> +#include <mach/gms.h>
> +
> +void __init carrier_board_map_io(void)
> +{

This approach won't work. If you have more than one carrier board
compiled into your kernel then you will get multiple definition errors.
The name carrier_board_map_io is also way too generic.

The better approach would be to do this the other way so that the
carrier board calls the SoM map_io function.

> +	/*
> +	 * USART0 on ttyS1 (Rx, Tx, CTS, RTS, DTR, DSR, DCD, RI).
> +	 * Used for Internal Analog Modem.
> +	 */
> +	at91_register_uart(AT91SAM9260_ID_US0, 1,
> +			     ATMEL_UART_CTS | ATMEL_UART_RTS
> +			   | ATMEL_UART_DTR | ATMEL_UART_DSR
> +			   | ATMEL_UART_DCD | ATMEL_UART_RI);
> +	/*
> +	 * USART1 on ttyS2 (Rx, Tx, CTS, RTS).
> +	 * Used for GPS or WiFi or Data stream.
> +	 */
> +	at91_register_uart(AT91SAM9260_ID_US1, 2,
> +			   ATMEL_UART_CTS | ATMEL_UART_RTS);
> +	/*
> +	 * USART2 on ttyS3 (Rx, Tx, CTS, RTS).
> +	 * Used for External Modem.
> +	 */
> +	at91_register_uart(AT91SAM9260_ID_US2, 3,
> +			   ATMEL_UART_CTS | ATMEL_UART_RTS);
> +	/*
> +	 * USART3 on ttyS4 (Rx, Tx, RTS).
> +	 * Used for RS-485.
> +	 */
> +	at91_register_uart(AT91SAM9260_ID_US3, 4, ATMEL_UART_RTS);
> +
> +	/*
> +	 * USART4 on ttyS5 (Rx, Tx).
> +	 * Used for TRX433 Radio Module.
> +	 */
> +	at91_register_uart(AT91SAM9260_ID_US4, 5, 0);
> +}

~Ryan

-- 
Bluewater Systems Ltd - ARM Technology Solution Centre

Ryan Mallon         		5 Amuri Park, 404 Barbadoes St
ryan@bluewatersys.com         	PO Box 13 889, Christchurch 8013
http://www.bluewatersys.com	New Zealand
Phone: +64 3 3779127		Freecall: Australia 1800 148 751
Fax:   +64 3 3779135			  USA 1800 261 2934
