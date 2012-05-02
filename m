Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753467Ab2EBKma (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2012 06:42:30 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:55768 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752164Ab2EBKm3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2012 06:42:29 -0400
Date: Wed, 2 May 2012 11:45:15 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Killing the tty lock
Message-ID: <20120502114515.2cc22a26@pyramind.ukuu.org.uk>
In-Reply-To: <20120502044544.GA32521@kroah.com>
References: <20120501173739.4fe61fb5@pyramind.ukuu.org.uk>
	<20120502044544.GA32521@kroah.com>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> It's mostly pretty "sane", but what is this:
> 
> > +/*
> > + * Getting the big tty mutex for a pair of ttys with lock ordering
> > + * On a non pty/tty pair tty2 can be NULL which is just fine.
> > + */
> > +void __lockfunc tty_lock_pair(struct tty_struct *tty,
> > +					struct tty_struct *tty2)
> > +{
> > +	if (tty < tty2) {
> > +		tty_lock(tty);
> > +		tty_lock(tty2);
> > +	} else {
> > +		if (tty2 && tty2 != tty)
> > +			tty_lock(tty2);
> > +		tty_lock(tty);
> > +	}
> > +}
> > +EXPORT_SYMBOL(tty_lock_pair);
> > +
> > +void __lockfunc tty_unlock_pair(struct tty_struct *tty,
> > +						struct tty_struct *tty2)
> > +{
> > +	tty_unlock(tty);
> > +	if (tty2 && tty2 != tty)
> > +		tty_unlock(tty2);
> > +}
> > +EXPORT_SYMBOL(tty_unlock_pair);
> 
> for?

We need to take locks on a pair of tty devices at the same time in some
cases (pty/tty pairs).

> And what's with the comparing of pointers as "<"?  How portable is that
> really, and how are we supposed to control the memory location of these
> structures?

You don't need to. The point is that we must lock any arbitrary pair of
tty structs in a defined order. Pointer comparisons work just fine for
this. The fs layer uses similar logic for inode locking. We only care
that for any given pair of objects the lock ordering is consistent.

Alan
