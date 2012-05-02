Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757372Ab2EBUg6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2012 16:36:58 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:49407 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756308Ab2EBUg5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2012 16:36:57 -0400
Date: Wed, 2 May 2012 13:36:53 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Killing the tty lock
Message-ID: <20120502203653.GC27158@kroah.com>
References: <20120501173739.4fe61fb5@pyramind.ukuu.org.uk>
 <20120502044544.GA32521@kroah.com>
 <20120502114515.2cc22a26@pyramind.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120502114515.2cc22a26@pyramind.ukuu.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 02, 2012 at 11:45:15AM +0100, Alan Cox wrote:
> > It's mostly pretty "sane", but what is this:
> > 
> > > +/*
> > > + * Getting the big tty mutex for a pair of ttys with lock ordering
> > > + * On a non pty/tty pair tty2 can be NULL which is just fine.
> > > + */
> > > +void __lockfunc tty_lock_pair(struct tty_struct *tty,
> > > +					struct tty_struct *tty2)
> > > +{
> > > +	if (tty < tty2) {
> > > +		tty_lock(tty);
> > > +		tty_lock(tty2);
> > > +	} else {
> > > +		if (tty2 && tty2 != tty)
> > > +			tty_lock(tty2);
> > > +		tty_lock(tty);
> > > +	}
> > > +}
> > > +EXPORT_SYMBOL(tty_lock_pair);
> > > +
> > > +void __lockfunc tty_unlock_pair(struct tty_struct *tty,
> > > +						struct tty_struct *tty2)
> > > +{
> > > +	tty_unlock(tty);
> > > +	if (tty2 && tty2 != tty)
> > > +		tty_unlock(tty2);
> > > +}
> > > +EXPORT_SYMBOL(tty_unlock_pair);
> > 
> > for?
> 
> We need to take locks on a pair of tty devices at the same time in some
> cases (pty/tty pairs).

Ok.

> > And what's with the comparing of pointers as "<"?  How portable is that
> > really, and how are we supposed to control the memory location of these
> > structures?
> 
> You don't need to. The point is that we must lock any arbitrary pair of
> tty structs in a defined order. Pointer comparisons work just fine for
> this. The fs layer uses similar logic for inode locking. We only care
> that for any given pair of objects the lock ordering is consistent.

Ah, ok, that makes more sense, sorry, I didn't understand that.

greg
