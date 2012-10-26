Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933225Ab2JZOOD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 10:14:03 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:55383 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933043Ab2JZOOA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 10:14:00 -0400
Date: Fri, 26 Oct 2012 15:19:02 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Min Zhang <mzhang@mvista.com>
Cc: gregkh@linuxfoundation.org, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] serial: 8250 check iir rdi in interrupt
Message-ID: <20121026151902.0a382d16@pyramind.ukuu.org.uk>
In-Reply-To: <CAJ0e-Fofs48N9VnYr1_8Kch6+yHjGx9iCWBRtRsqpD-B_rWutQ@mail.gmail.com>
References: <alpine.LFD.2.02.1210221633450.28146@nightowl>
	<20121023110133.62bed522@pyramind.ukuu.org.uk>
	<CAJ0e-Fofs48N9VnYr1_8Kch6+yHjGx9iCWBRtRsqpD-B_rWutQ@mail.gmail.com>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> It is racing. For "too much work for irq", here is sequence events
> analyzed by a Motorola engineer:

Thanks - this is enormously helpful in understanding the report.

>         5) The LSR indicates that the transmitter needs data,
> but also indicates the presence of data in the FIFO (0x61 in the LSR)
>         6) The processing function receives the characters, and
> outputs data to the FIFO
>         7) At the exact time (very very small window) that the
> character is read from the FIFO, the FIFO timeout occurs locking in an
> interrupt cause
>         8) The next loop through the interrupt code begins
>         9) The IIR now indicates the data timeout interrupt
> (0xCC in the IIR)
>         10) The processing function is called and it reads the
> LSR
>         11) The LSR is 0 indicating nothing to do

>         12) The interrupt loop continues (the IIR won't clear
> until a character is pulled) until it reaches its max count and
> displays the error.

So we only need to check this in serial8250_handle_irq when IIR indicates
a data timeout interrupt ? 

Can we do

	if ((iir & 0x0F) == 0x0C) {
		/* Expensive RDI check */
	}



Alan
