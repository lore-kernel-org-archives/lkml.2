Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932284Ab0DHKKt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Apr 2010 06:10:49 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:53704 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932133Ab0DHKKn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Apr 2010 06:10:43 -0400
Date: Thu, 8 Apr 2010 11:13:10 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Claudio Scordino <claudio@evidence.eu.com>
Cc: Ryan Mallon <ryan@bluewatersys.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       John Nicholls <john@thinlinx.com>, Rick Bronson <rick@efn.org>,
       Sebastian Heutling <Sebastian.Heutling@who-ing.de>,
       michael trimarchi <michael@evidence.eu.com>, rmk@arm.linux.org.uk,
       hskinnemoen@atmel.com, linux@maxim.org.za
Subject: Re: [PATCH] atmel_serial: Atmel RS485 support v2
Message-ID: <20100408111310.524f7354@lxorguk.ukuu.org.uk>
In-Reply-To: <4BBD8C9D.3070401@evidence.eu.com>
References: <4BB053C4.7050700@evidence.eu.com>
	<4BB10304.6090006@bluewatersys.com>
	<4BB1BF49.2000609@evidence.eu.com>
	<4BB252E3.3030703@bluewatersys.com>
	<4BBD8C9D.3070401@evidence.eu.com>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

NAK - assorted problems, notably locking ones caused by the sysfs stuff
which should probably be dropped.

> +#define TIOCSRS485	0x5461

Please provide TIOCGRS485 as well



> +static ssize_t show_rs485(struct device *dev, struct device_attribute *attr,
> +			   char *buf)
> +{
> +	struct platform_device *pdev = to_platform_device(dev);
> +	struct uart_port *port = platform_get_drvdata(pdev);
> +	unsigned int current_mode;
> +
> +	current_mode = UART_GET_MR(port) & ATMEL_US_USMODE;
> +	return snprintf(buf, PAGE_SIZE, "%u\n", current_mode);
> +}

You should have TIOCGRS485 for providing the info back as part of the API

> +
> +static ssize_t set_rs485(struct device *dev, struct device_attribute *attr,
> +			  const char *buf, size_t len)

Expain the locking on this could you - I don't see what protects against
parallel ioctl and sysfs stuff ?

> +static DEVICE_ATTR(rs485, 0644, show_rs485, set_rs485);

Why should this be public read ?

> +	/* Resetting serial mode to RS232 (0x0) */
> +	mode &= ~ATMEL_US_USMODE;
> +
> +	if (atmel_port->rs485.flags & SER_RS485_ENABLED) {
> +		dev_dbg(port->dev, "Setting UART to RS485\n");
> +		UART_PUT_TTGR(port, atmel_port->rs485.delay_rts_before_send);
> +		mode |= ATMEL_US_USMODE_RS485;
> +	} else {
> +		dev_dbg(port->dev, "Setting UART to RS232\n");

Locking versus sysfs ?

> +	UART_PUT_IDR(port, atmel_port->tx_done_mask);
> +
> +	if (atmel_port->rs485.flags & SER_RS485_ENABLED)
> +		atmel_start_rx(port);
>  }

Ditto

> -		UART_PUT_IER(port, ATMEL_US_ENDTX | ATMEL_US_TXBUFE);
> +		if (atmel_port->rs485.flags & SER_RS485_ENABLED)
> +			atmel_stop_rx(port);
> +

Ditto


Given the locking mess you are going to create I would suggest dropping
the sysfs stuff.

Alan
