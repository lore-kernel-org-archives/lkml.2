Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755331Ab0F0N3h (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jun 2010 09:29:37 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:42003 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755167Ab0F0N3e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jun 2010 09:29:34 -0400
Date: Sun, 27 Jun 2010 14:35:18 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Samo Pogacnik <samo_pogacnik@t-2.net>
Cc: linux-embedded <linux-embedded@vger.kernel.org>,
       linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] detour TTY driver - now ttyprintk
Message-ID: <20100627143518.104ef190@lxorguk.ukuu.org.uk>
In-Reply-To: <1277516912.29797.411.camel@itpsd6lap>
References: <1273918658.2341.17.camel@itpsd6lap>
	<1275171436.2122.29.camel@itpsd6lap>
	<20100529235402.296406d9@lxorguk.ukuu.org.uk>
	<1275175983.2122.42.camel@itpsd6lap>
	<1276123020.16010.97.camel@itpsd6lap>
	<20100611134455.3fa7d563@lxorguk.ukuu.org.uk>
	<1276291932.2154.45.camel@itpsd6lap>
	<20100621153858.444695c0@lxorguk.ukuu.org.uk>
	<1277244410.2195.47.camel@itpsd6lap>
	<20100622232108.26752ff8@lxorguk.ukuu.org.uk>
	<1277462596.2143.101.camel@itpsd6lap>
	<20100625120329.1303aa61@lxorguk.ukuu.org.uk>
	<1277516912.29797.411.camel@itpsd6lap>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I thought that this would automatically reduce processor load, which is
> obviously not the case. Sorry for the delay, but i am trying to figure
> out how to slow down write method when under pressure.

Ok I played with this a bit. Much to my surprise until I thought about it
in detail it all works fine without any of the ratelimiting at all. There
is a problem if you manage to redirect the console *in kernel* to the
printk driver, but that needs stopping anyway and rate limit won't fix it
(you blow the stack before it kicks in)

In the case where userspace loads it hard and its a graphical console
then we use a lot of CPU power drawing stuff on screen, but killing the
process does as is expected.

With a serial console the printk itself blocks which blocks the line
discipline which in turn slows stuff down.

The only two bad things I can see how to cause are

- Slowing down output by stuffing lots of extra data into the port (which
  I can do anyway just fine) so isn't worse than before.

- Filling up the dmesg log easily and hiding important messages. Not
  really a problem in this case bcause the whole point of this is
  embedded and capturing those messages as if they were system ones.

So much to my surprise the flow control is a red herring and best left
out.

Alan
