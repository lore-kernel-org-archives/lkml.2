Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751920Ab2EBGlR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2012 02:41:17 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:41139 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751029Ab2EBGlQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2012 02:41:16 -0400
Date: Tue, 1 May 2012 21:45:44 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Killing the tty lock
Message-ID: <20120502044544.GA32521@kroah.com>
References: <20120501173739.4fe61fb5@pyramind.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120501173739.4fe61fb5@pyramind.ukuu.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 01, 2012 at 05:37:39PM +0100, Alan Cox wrote:
> This is a first stab at it by making the lock per tty and using tty_mutex
> to cover the lookup for now. We ought to move to the lookup handing back
> ttys with a ref but thats a further step.
> 
> It seems to mostly work but not quite reliably, so coul do with some more
> eyes and review for ideas.

It's mostly pretty "sane", but what is this:

> +/*
> + * Getting the big tty mutex for a pair of ttys with lock ordering
> + * On a non pty/tty pair tty2 can be NULL which is just fine.
> + */
> +void __lockfunc tty_lock_pair(struct tty_struct *tty,
> +					struct tty_struct *tty2)
> +{
> +	if (tty < tty2) {
> +		tty_lock(tty);
> +		tty_lock(tty2);
> +	} else {
> +		if (tty2 && tty2 != tty)
> +			tty_lock(tty2);
> +		tty_lock(tty);
> +	}
> +}
> +EXPORT_SYMBOL(tty_lock_pair);
> +
> +void __lockfunc tty_unlock_pair(struct tty_struct *tty,
> +						struct tty_struct *tty2)
> +{
> +	tty_unlock(tty);
> +	if (tty2 && tty2 != tty)
> +		tty_unlock(tty2);
> +}
> +EXPORT_SYMBOL(tty_unlock_pair);

for?

And what's with the comparing of pointers as "<"?  How portable is that
really, and how are we supposed to control the memory location of these
structures?

thanks,

greg k-h
