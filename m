Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755256Ab1DTPeg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 11:34:36 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:37967 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753449Ab1DTPee (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 11:34:34 -0400
Date: Wed, 20 Apr 2011 16:35:35 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: John Linn <John.Linn@xilinx.com>
Cc: <linux-kernel@vger.kernel.org>, <linux-serial@vger.kernel.org>
Subject: Re: [PATCH] tty/serial: add support for Xilinx PS UART
Message-ID: <20110420163535.77b5826f@lxorguk.ukuu.org.uk>
In-Reply-To: <bde1ee6b-79a8-46f9-a8a3-38a91e51f1c3@VA3EHSMHS019.ehs.local>
References: <e35578a9-909d-4594-bbe4-41d89b5f9b3e@VA3EHSMHS014.ehs.local>
	<20110419221530.7370d013@lxorguk.ukuu.org.uk>
	<bde1ee6b-79a8-46f9-a8a3-38a91e51f1c3@VA3EHSMHS019.ehs.local>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I see the subtle locking issue you mention.
> 
> This looks like a good way to help it, but it's not clear to me what to
> do in an isr 
> if the function returns a NULL for the tty.  In other places you can say
> the tty

It can happen, you must deal with it.

> It seems easier in this case to just move the tty =
> port->state->port.tty to after 
> the lock is acquired.

It can still be NULL.

> I'm sure there's something obvious I'm missing here.

It varies what drivers do but essentially what has occurred is that the
user side of the tty has gone away and you have an IRQ still. Your port
is still around as the lifetime of the port is the lifetime of your
serial driver creating/deleting it, but your tty has gone.

In those cases you need to do whatever needs doing to handle the IRQ and
processing that doesn't require the tty. That varies by device, in many
cases for example you read the data and chuck it rather than stuffing it
into the flip buffer.

Alan
