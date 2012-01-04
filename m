Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756131Ab2ADQ1S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jan 2012 11:27:18 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:38568 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754584Ab2ADQ1P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jan 2012 11:27:15 -0500
Date: Wed, 4 Jan 2012 16:27:45 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: markh@compro.net
Cc: Linux-kernel <linux-kernel@vger.kernel.org>,
        Mark Hounschell <dmarkh@cfl.rr.com>
Subject: Re: tty  TTY_HUPPED anomaly
Message-ID: <20120104162745.76fc3852@pyramind.ukuu.org.uk>
In-Reply-To: <4F047767.5060708@compro.net>
References: <4EF49579.9040907@compro.net>
	<4EF4CC92.5090502@compro.net>
	<20111223204015.541924f2@pyx>
	<4F047767.5060708@compro.net>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> But what has carrier dropping got to do with an TIOCSETD ioctl. For that 

When the carrier is dropped and HUPCL is set then the tty is disconnected
from the physical interface. It's specified behaviour and required for
security. So by the time you go to issue the TIOCSETD you are no longer
connected to the tty. That may well just be a timing change.
 
> What can be done to prevent tty_hangup from being called after opening 
> the port? And if this is really supposed to happen, why does it not 
> always happen?

It should only happen if the carrier is dropped.

> Even if the first thing I do after opening the port is to clear HUPCL 
> and set CLOCAL, this still randomly happens the first time I open the 
> port after booting.

I'd expect the behaviour to either be

carrier high, stays high - open works, no hangup events seen

or

carrier low, stays low - open blocks, but open with O_NDELAY works,
hangup events not seen.

It's the act of the drop which is a hangup not the presence of low
carrier if I remember the spec properly. The Synclink GT correctly does
this as far as I can tell (I have no hardware or docs for it) but the
code indicates that the hardware reports changes and it acts on them
properly (checking CLOCAL etc).


I would guess (given the distro change is the trigger) that you've got a
SuSE problem not a kernel one. The kernel behaviour and code looks
correct. My guess therefore is that newer SuSE is running stuff in the
boot which is probing serial ports and messing with the carrier wrongly
and in ways it didn't use to. That would fit the fact that something
similarly broken has apparently also appeared in the Fedora user space
bootup.

Alan
