Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756564Ab0KRKQd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 05:16:33 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:50848 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756529Ab0KRKQc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 05:16:32 -0500
Date: Thu, 18 Nov 2010 10:15:19 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Greg KH <greg@kroah.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>, Valdis.Kletnieks@vt.edu,
        Lennart Poettering <mzxreary@0pointer.de>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Werner Fink <werner@suse.de>, Jiri Slaby <jslaby@suse.cz>
Subject: Re: tty: add 'active' sysfs attribute to tty0 and console device
Message-ID: <20101118101519.11729a74@lxorguk.ukuu.org.uk>
In-Reply-To: <20101118012734.GA8558@kroah.com>
References: <AANLkTimn7zyEjLhmOmUVQGnLDfM-A_uEgWETsM3nsyuY@mail.gmail.com>
	<20101116171447.29336514@lxorguk.ukuu.org.uk>
	<AANLkTi=ju4fON7Hz=j_tFtqFGD0b-c=-Ou+HQwfYDgOy@mail.gmail.com>
	<20101116195538.7fa66b97@lxorguk.ukuu.org.uk>
	<20101116213622.GA17824@tango.0pointer.de>
	<20101116225619.5fa7ef8b@lxorguk.ukuu.org.uk>
	<20101116231023.GB27594@tango.0pointer.de>
	<25482.1290031268@localhost>
	<AANLkTimV_zKK-Ubw3vJkDUtrYvB+W06cRR7Nz2vam6fP@mail.gmail.com>
	<20101117235647.00766e32@lxorguk.ukuu.org.uk>
	<20101118012734.GA8558@kroah.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 	- the existing ioctl is broken and no userspace program can use
> 	  it properly, so it might as well be removed.

You can use it happily for various things providing you hold the vt
switch lock. It's not a very good API and wants something doing about it.
However we can't deprecate it using either of the proposed patches
because neither of them cover the needed functionality.

> 	- Kay's patch is one proposed solution for what userspace is
> 	  wanting to learn about ttys.  Werner's is another one.

Kay's patch is useless. As we've demonstrated by as you call it "going
off topic" it can't actually provide a credible security model. Its
providing a variable without holding the locks that make the value
meaningful. Thats as basic an error I can think of.

We wouldn't accept kernel code which did

	mutex_lock(&foo->lock)
	temp = foo->only_valid_under_lock;
	mutex_unlock(&foo->lock);
	return temp;	/* ma invalid by now */

especially when it was going to be used for permission management. We'd
call it a bug. So why are we proposing to add an API that does exactly
that ?

> I can do any one, or multiple things from the following options:
> 
> 	- disable the existing ioctl to return an error so that no new
> 	  userspace program starts to use it thinking it is valid
> 	- accept Werner's patch for those who like proc files
> 	- accept Kay's patch
> 
> Any suggestions?

None of the above. In fact the current situation is better than either of
the patches because it's equally broken and involves no more broken APIs !

Doing it right means:
- deprecating the existing ioctl (because it's a dumb interface and Kay
  is right about that)
- adding a proper event device which is pollable and returns the same
  events (and more) using a small kfifo queue. Trivial to code and will
  not add another API we'll need to deprecate again the moment anyone
  wants to use it.
- support synchronous switching by that interface or verify the existing
  vt locking interfaces will do the job in conjunction with it.

Kay's approach doesn't solve three things

- You can't use the data to implement proper secure desktop switching
- It doesn't support moving to multiple active vts at a time
- You can't deprecate the wait event interface unless you replace all the
  features of it that people use (eg resize events)

So we will be back here again doing the same thing deprecating Kay's
interface if we go that way. Having an event device actually lets us
solve the problem properly, and if we are careful about the message
formats cover the fact the KMS folks and others want multiple "live"
virtual consoles at a time.

If you have a /dev/vtmanager or similar and opening it allocates a kfifo
of a page into which we stuff the events we currently post for waitevent
then the code is trivial and it does what Kay needs as well as being able
to cover the rest of the WAITEVENT interface and future multi-desktop
stuff.

So its trivial to do the job properly, which makes the existing patches
all the wrong thing to do.

Alan
