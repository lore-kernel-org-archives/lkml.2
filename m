Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753666Ab2ALOi2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jan 2012 09:38:28 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:59580 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753168Ab2ALOi0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jan 2012 09:38:26 -0500
Date: Thu, 12 Jan 2012 14:39:00 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Rajanikanth H V <rajanikanth.hv@stericsson.com>
Cc: "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "gregkh@sude.de" <gregkh@sude.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: tty/serial: Need clarification on Support for 4+M Baudrate
Message-ID: <20120112143900.27b92668@pyramind.ukuu.org.uk>
In-Reply-To: <2B1D156D95AE9B4EAD379CB9E465FE7324AF2A630D@EXDCVYMBSTM005.EQ1STM.local>
References: <20120111121901.GA4034@bnru05>
	<20120111123025.244a9cf5@pyramind.ukuu.org.uk>
	<2B1D156D95AE9B4EAD379CB9E465FE7324AF2A605A@EXDCVYMBSTM005.EQ1STM.local>
	<20120112114913.21809bed@pyramind.ukuu.org.uk>
	<2B1D156D95AE9B4EAD379CB9E465FE7324AF2A630D@EXDCVYMBSTM005.EQ1STM.local>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Jan 2012 15:20:46 +0100
Rajanikanth H V <rajanikanth.hv@stericsson.com> wrote:

> Alan,
> 
> FYI: I am not using application, rather I have a Bluetooth driver invoking
> encode_baud_rate(...), please find log below.
> 
> I made sure that c_ispeed = c_ospeed = 4.05M Baud, however I see 
> tty_termios_encode_baud_rate(...) is normalizing to 4.0
> 
> 
> manual trace log below:
> ======================================================================================
> 
> 4.05M Arbitrary Baud Setting Sequence:
> [    9.664703] alloc_set_baud_rate_cmd Setting arbitrary baudrate using BOTHER baudrate:89 c_cflag:020000016262
> [    9.774658] XXXXXX_hci_uart_set_baudrate c_cflag:020000016262 baud:4050000

4050000 seems a bit odd - you want cflag&CBAUD == BOTHER so I'd expect
the low bits to end rather different things to 6262 ?

So something like

	struct ktermios new = *tty->termios;
	new.c_cflag &= ~(CBAUD|CIBAUD);
	new.c_cflag |= BOTHER;
	new.c_ispeed = 4050000;
	new.c_ospeed = 4050000;
	tty_set_termios(tty, &new);	/* Can sleep */

	/* Returned new will now hold actual values selected */

should do the trick providing the low level driver supports the rate.

Alan
