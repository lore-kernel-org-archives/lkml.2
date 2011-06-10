Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754046Ab1FJJSY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jun 2011 05:18:24 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:40543 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750774Ab1FJJSW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jun 2011 05:18:22 -0400
Date: Fri, 10 Jun 2011 10:20:26 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Matthieu CASTET <matthieu.castet@parrot.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        <linux-serial@vger.kernel.org>
Subject: Re: uart : lost characters when system is busy
Message-ID: <20110610102026.01f7da05@lxorguk.ukuu.org.uk>
In-Reply-To: <4DF1DCA9.9060604@parrot.com>
References: <4DF1DCA9.9060604@parrot.com>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> uart_throttle/uart_unthrottle is called from a workqueue.
> If the system is busy, and the uart receive lot's of data, we fill the tty
> buffer, but the workqueue doesn't run and we never have a chance to call
> uart_throttle. So the uart is never slow down.

You should have around 64K of buffering (actually n_tty worst case
should be 63.5Kbyte) that's a lot of slack so what is holding off the
work queue for so long on your problem system ? I think that should be
answered first as it sounds like some other part of your kernel is
misbehaving.

> A workaround could be to check the buffer threshold in tty_flip_buffer_push and
> call throttle callback if needed.

tty_flip_buffer_push can be called from an IRQ, the throttle callback
needs to be able to sleep.

What might work if it is needed though is to provide a tty_is_throttled()
method that a driver can use to check the instantaneous throttle state.
Trouble is that will require a lot of care on the drivers part to deal
with asynchronus throttle/unthrottle events while peering at the state in
its IRQ handler as well.

Anyway - question for the case you hit, what tasks or work held off the
serial work queue for 63.5Kbytes of data ?
