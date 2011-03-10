Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752642Ab1CJGs5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 01:48:57 -0500
Received: from mx1.redhat.com ([209.132.183.28]:19783 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752465Ab1CJGsy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 01:48:54 -0500
Date: Thu, 10 Mar 2011 01:49:52 -0500
From: Chuck Ebbert <cebbert@redhat.com>
To: "Mario 'BitKoenig' Holbe" <Mario.Holbe@TU-Ilmenau.DE>
Cc: linux-kernel@vger.kernel.org
Subject: Re: kernel BUG and freeze on cat /proc/tty/driver/serial
Message-ID: <20110310014952.38b7a6ef@redhat.com>
In-Reply-To: <20110216161728.GA8431@darkside.kls.lan>
References: <20110216161728.GA8431@darkside.kls.lan>
Organization: Red Hat, Inc.
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 Feb 2011 17:17:28 +0100
"Mario 'BitKoenig' Holbe" <Mario.Holbe@TU-Ilmenau.DE> wrote:

> reading /proc/tty/driver/serial leads to a NULL pointer dereference
> BUG and freeze on a serial-console enabled 2.6.35.{4,10,11} and
> 2.6.37. 2.6.32.28 does fine without BUG and freeze.
> 
> Fresh boot 2.6.35.11 into emergency...
> # cat /proc/tty/driver/serial
> [   73.199568] BUG: unable to handle kernel NULL pointer dereference
> at 00000099 [   73.227373] IP: [<c11a8969>] tty_ldisc_try+0x10/0x35

The oops is here, in uart_handle_dcd_change() in serial_core.h:

        struct tty_ldisc *ld = tty_ldisc_ref(port->tty);

(port->tty is NULL)

Called from check_modem_status() in 8250.c:

                if (status & UART_MSR_DDCD)
                        uart_handle_dcd_change(&up->port, status & UART_MSR_DCD);

So apparently the port has no tty, until you run "setserial -g", or else
that somehow makes the DCD status appear unchanged later when reading
/proc/tty/driver/serial.
