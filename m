Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754151Ab1JYHqE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Oct 2011 03:46:04 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:49204 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751630Ab1JYHqC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Oct 2011 03:46:02 -0400
Date: Tue, 25 Oct 2011 08:45:43 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Ilya Zykov <ilya@ilyx.ru>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Alan Cox <alan@linux.intel.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] TTY: tty flip buffer change reserve memory strategy.
Message-ID: <20111025084543.09432276@pyx>
In-Reply-To: <4EA48474.4010101@ilyx.ru>
References: <4EA48474.4010101@ilyx.ru>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.22.0; i386-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> free(kfree()) every chunk more 256 bytes every time,
> even we have in free buffer enough space, because we can't
> pass through chunk boundary in free buffer. Also we can't limit reserve
> memory size. In worse case we will have in free buffer:
> (256 * 256 byte chunk) = (256 * 552 ) = 141312 byte unused memory.

The idea is to trade off between the devices that need long linear blocks
(mostly for DMA) and devices that don't care - but many of which pass 1
or 2 bytes/irq so want a common buffer.

Most drivers should not be using tty_reserve_room in the first place.

> Also we can limit reserve memory size, but then,
> we will be use kmalloc()-kree() calls on intensive stream from the driver.

kmalloc is very fast anyway so I'd be interested in seeing the drivers
suffering and the profile traces of a real example.

I'm also not sure I agree with the maths - we chunk buffers to 256 byte
boundaries to avoid getting lots of queued buffers of different sizes. We
could in fact I think simplify the code from what we have learned using
it and simply treat the 256 byte buffer case as special rather than 256
and 512 as we do now. That would let us remove the more generic support
for free buffer sizes which is overcomplex and mean we could simply count
the number of 256 byte buffers we have to hand.

Alan
