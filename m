Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754630Ab2HPK1U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 06:27:20 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:48618 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750854Ab2HPK1R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 06:27:17 -0400
Date: Thu, 16 Aug 2012 11:31:52 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Tomas Hlavacek <tmshlvck@gmail.com>
Cc: gregkh@linuxfoundation.org, alan@linux.intel.com,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        marek.vasut@gmail.com
Subject: Re: [PATCH 1/1] [RFC] uartclk from serial_core exposed to sysfs
Message-ID: <20120816113152.73838695@pyramind.ukuu.org.uk>
In-Reply-To: <1344929718-22736-1-git-send-email-tmshlvck@gmail.com>
References: <CAEB7QLAJXkK6NDPVDi36n_U_X_DGh5niHJhH6FpqBUZFmXQ2Xg@mail.gmail.com>
	<1344929718-22736-1-git-send-email-tmshlvck@gmail.com>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> +	/*
> +	 * Check value: baud_base has to be more than 9600
> +	 * and uartclock = baud_base * 16 .
> +	 */
> +	if (val >= 153600)
> +		state->uart_port->uartclk = val;
> +
> +	mutex_unlock(&state->port.mutex);
> +
> +	return count;

This breaks if for example the port is in use. Fixing that looks pretty
horrible as you need a valid tty pointer to stop and restart the pot.

It's also not calling the verfy method of the port as is expected.

At minimum I think you need to be able to do the same work
uart_get_info/uart_set_info perform and with the same checks on ->verify
etc.

I'm not 100% sure the drvdata on the tty_dev is clear to use. It does
seem to be in all the drivers I looked at. I'd rather however it pointed
to the tty_port that each tty device has (or very soon will be required
to have). You can still find the uart_foo structs from that but it means
we can do the dev_set_drvdata() in a consistent manner for all tty
devices in the kernel. That in turn means we can make some of the sysfs
valid the same way.

I want to have think about the setting side of it. Can you submit a
revised version that just allows the user to read the value this way but
does the drvdata setting etc and sysfs node create/delete.

I'll merge that and we can throw it over the parapet and see if anything
explodes.

To make the setting part work properly I think I need to sort out
uart_get_info/set_info so the core part of it can be called with kernel
space structures and the caller handling locks.

Alan
