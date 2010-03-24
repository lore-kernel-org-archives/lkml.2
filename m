Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755585Ab0CXKrL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 06:47:11 -0400
Received: from gate.crashing.org ([63.228.1.57]:40679 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755363Ab0CXKrJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 06:47:09 -0400
Subject: Re: [PATCH 4/7] hvc_console: Fix race between hvc_close and
 hvc_remove
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org,
       Amit Shah <amit.shah@redhat.com>, linuxppc-dev@ozlabs.org,
       Rusty Russell <rusty@rustcorp.com.au>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
In-Reply-To: <1269119079.8599.65.camel@pasglop>
References: <20100319151326.GC8541@kroah.com>
	 <1269011916-8836-4-git-send-email-gregkh@suse.de>
	 <1269119079.8599.65.camel@pasglop>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 24 Mar 2010 21:45:44 +1100
Message-ID: <1269427544.8599.222.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2010-03-21 at 08:04 +1100, Benjamin Herrenschmidt wrote:
> On Fri, 2010-03-19 at 08:18 -0700, Greg Kroah-Hartman wrote:
> > From: Amit Shah <amit.shah@redhat.com>
> > 
> > Alan pointed out a race in the code where hvc_remove is invoked. The
> > recent virtio_console work is the first user of hvc_remove().
> 
> This causes hangs during boot on pseries machines. Haven't had a chance
> to track that down yet, but please revert
> e74d098c66543d0731de62eb747ccd5b636a6f4c for now.

Linus, any chance you can revert that one for now until we figure out
what's wrong ?

Thanks !

Cheers,
Ben.

> Cheers,
> Ben.
> 
> 
> > Alan describes it thus:
> > 
> > The hvc_console assumes that a close and remove call can't occur at the
> > same time.
> > 
> > In addition tty_hangup(tty) is problematic as tty_hangup is asynchronous
> > itself....
> > 
> > So this can happen
> > 
> >         hvc_close                               hvc_remove
> >         hung up ? - no
> >                                                 lock
> >                                                 tty = hp->tty
> >                                                 unlock
> >         lock
> >         hp->tty = NULL
> >         unlock
> >         notify del
> >         kref_put the hvc struct
> >         close completes
> >         tty is destroyed
> >                                                 tty_hangup dead tty
> >                                                 tty->ops will be NULL
> >                                                 NULL->...
> > 
> > This patch adds some tty krefs and also converts to using tty_vhangup().
> > 
> > Reported-by: Alan Cox <alan@lxorguk.ukuu.org.uk>
> > Signed-off-by: Amit Shah <amit.shah@redhat.com>
> > CC: Alan Cox <alan@lxorguk.ukuu.org.uk>
> > CC: linuxppc-dev@ozlabs.org
> > CC: Rusty Russell <rusty@rustcorp.com.au>
> > Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> > ---
> >  drivers/char/hvc_console.c |   31 +++++++++++++++++++++----------
> >  1 files changed, 21 insertions(+), 10 deletions(-)
> > 
> > diff --git a/drivers/char/hvc_console.c b/drivers/char/hvc_console.c
> > index 465185f..ba55bba 100644
> > --- a/drivers/char/hvc_console.c
> > +++ b/drivers/char/hvc_console.c
> > @@ -312,6 +312,7 @@ static int hvc_open(struct tty_struct *tty, struct file * filp)
> >  	spin_lock_irqsave(&hp->lock, flags);
> >  	/* Check and then increment for fast path open. */
> >  	if (hp->count++ > 0) {
> > +		tty_kref_get(tty);
> >  		spin_unlock_irqrestore(&hp->lock, flags);
> >  		hvc_kick();
> >  		return 0;
> > @@ -319,7 +320,7 @@ static int hvc_open(struct tty_struct *tty, struct file * filp)
> >  
> >  	tty->driver_data = hp;
> >  
> > -	hp->tty = tty;
> > +	hp->tty = tty_kref_get(tty);
> >  
> >  	spin_unlock_irqrestore(&hp->lock, flags);
> >  
> > @@ -336,6 +337,7 @@ static int hvc_open(struct tty_struct *tty, struct file * filp)
> >  		spin_lock_irqsave(&hp->lock, flags);
> >  		hp->tty = NULL;
> >  		spin_unlock_irqrestore(&hp->lock, flags);
> > +		tty_kref_put(tty);
> >  		tty->driver_data = NULL;
> >  		kref_put(&hp->kref, destroy_hvc_struct);
> >  		printk(KERN_ERR "hvc_open: request_irq failed with rc %d.\n", rc);
> > @@ -363,13 +365,18 @@ static void hvc_close(struct tty_struct *tty, struct file * filp)
> >  		return;
> >  
> >  	hp = tty->driver_data;
> > +
> >  	spin_lock_irqsave(&hp->lock, flags);
> > +	tty_kref_get(tty);
> >  
> >  	if (--hp->count == 0) {
> >  		/* We are done with the tty pointer now. */
> >  		hp->tty = NULL;
> >  		spin_unlock_irqrestore(&hp->lock, flags);
> >  
> > +		/* Put the ref obtained in hvc_open() */
> > +		tty_kref_put(tty);
> > +
> >  		if (hp->ops->notifier_del)
> >  			hp->ops->notifier_del(hp, hp->data);
> >  
> > @@ -389,6 +396,7 @@ static void hvc_close(struct tty_struct *tty, struct file * filp)
> >  		spin_unlock_irqrestore(&hp->lock, flags);
> >  	}
> >  
> > +	tty_kref_put(tty);
> >  	kref_put(&hp->kref, destroy_hvc_struct);
> >  }
> >  
> > @@ -424,10 +432,11 @@ static void hvc_hangup(struct tty_struct *tty)
> >  	spin_unlock_irqrestore(&hp->lock, flags);
> >  
> >  	if (hp->ops->notifier_hangup)
> > -			hp->ops->notifier_hangup(hp, hp->data);
> > +		hp->ops->notifier_hangup(hp, hp->data);
> >  
> >  	while(temp_open_count) {
> >  		--temp_open_count;
> > +		tty_kref_put(tty);
> >  		kref_put(&hp->kref, destroy_hvc_struct);
> >  	}
> >  }
> > @@ -592,7 +601,7 @@ int hvc_poll(struct hvc_struct *hp)
> >  	}
> >  
> >  	/* No tty attached, just skip */
> > -	tty = hp->tty;
> > +	tty = tty_kref_get(hp->tty);
> >  	if (tty == NULL)
> >  		goto bail;
> >  
> > @@ -672,6 +681,8 @@ int hvc_poll(struct hvc_struct *hp)
> >  
> >  		tty_flip_buffer_push(tty);
> >  	}
> > +	if (tty)
> > +		tty_kref_put(tty);
> >  
> >  	return poll_mask;
> >  }
> > @@ -807,7 +818,7 @@ int hvc_remove(struct hvc_struct *hp)
> >  	struct tty_struct *tty;
> >  
> >  	spin_lock_irqsave(&hp->lock, flags);
> > -	tty = hp->tty;
> > +	tty = tty_kref_get(hp->tty);
> >  
> >  	if (hp->index < MAX_NR_HVC_CONSOLES)
> >  		vtermnos[hp->index] = -1;
> > @@ -819,18 +830,18 @@ int hvc_remove(struct hvc_struct *hp)
> >  	/*
> >  	 * We 'put' the instance that was grabbed when the kref instance
> >  	 * was initialized using kref_init().  Let the last holder of this
> > -	 * kref cause it to be removed, which will probably be the tty_hangup
> > +	 * kref cause it to be removed, which will probably be the tty_vhangup
> >  	 * below.
> >  	 */
> >  	kref_put(&hp->kref, destroy_hvc_struct);
> >  
> >  	/*
> > -	 * This function call will auto chain call hvc_hangup.  The tty should
> > -	 * always be valid at this time unless a simultaneous tty close already
> > -	 * cleaned up the hvc_struct.
> > +	 * This function call will auto chain call hvc_hangup.
> >  	 */
> > -	if (tty)
> > -		tty_hangup(tty);
> > +	if (tty) {
> > +		tty_vhangup(tty);
> > +		tty_kref_put(tty);
> > +	}
> >  	return 0;
> >  }
> >  EXPORT_SYMBOL_GPL(hvc_remove);
> 


