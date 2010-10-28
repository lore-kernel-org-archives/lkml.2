Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934433Ab0J1Ueu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Oct 2010 16:34:50 -0400
Received: from am1ehsobe003.messaging.microsoft.com ([213.199.154.206]:45273
	"EHLO AM1EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933788Ab0J1Uen (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Oct 2010 16:34:43 -0400
X-SpamScore: -11
X-BigFish: VS-11(z3b68iz1432N98dNzz1202hzzz2dh2a8h62h)
X-Spam-TCS-SCL: 1:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:de01egw01.freescale.net;RD:de01egw01.freescale.net;EFVD:NLI
Message-ID: <4CC9DE56.8070707@freescale.com>
Date: Thu, 28 Oct 2010 15:34:30 -0500
From: Timur Tabi <timur@freescale.com>
Organization: Freescale
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.13) Gecko/20101013 Fedora/2.0.8-2.fc13 SeaMonkey/2.0.8
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: gregkh <gregkh@suse.de>, lkml <linux-kernel@vger.kernel.org>
Subject: Re: Writing a console/tty driver -- how to use tty_port?
References: <4CC893CD.7020701@freescale.com> <20101027231948.5e62dd09@lxorguk.ukuu.org.uk>
In-Reply-To: <20101027231948.5e62dd09@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 28 Oct 2010 20:35:02.0185 (UTC) FILETIME=[98B31990:01CB76DF]
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
> drivers/mmc/card/sdio_uart.c
> 
> is in some ways the best example, it handles all the horrible cases
> including unloading of hardware v open races, its way more than you'd
> need but does illustrate it all.

I see something weird in sdio_uart_install():

	int ret = tty_init_termios(tty);

	if (ret == 0) {
		tty_driver_kref_get(driver);
		tty->count++;
		/* This is the ref sdio_uart_port get provided */
		tty->driver_data = port;
		driver->ttys[idx] = tty;


This function is called by tty_driver_install_tty(), which also does this:

	if (tty_init_termios(tty) == 0) {
		lock_kernel();
		tty_driver_kref_get(driver);
		tty->count++;
		driver->ttys[idx] = tty;
		unlock_kernel();
		return 0;
	}

Assuming that both calls to tty_init_termios(tty) return 0, these three lines
will be executed twice:

		tty_driver_kref_get(driver);
		tty->count++;
		driver->ttys[idx] = tty;

Is that right?

-- 
Timur Tabi
Linux kernel developer at Freescale

