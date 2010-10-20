Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754744Ab0JTSIA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 14:08:00 -0400
Received: from mail4.comsite.net ([205.238.176.238]:21746 "EHLO
	mail4.comsite.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753913Ab0JTSH7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 14:07:59 -0400
X-Greylist: delayed 980 seconds by postgrey-1.27 at vger.kernel.org; Wed, 20 Oct 2010 14:07:59 EDT
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=71.22.127.106;
From: miltonm@bga.com
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Stefani Seibold <stefani@seibold.net>
Subject: Re: kfifo must_check warning (+ patch)
Message-Id: <kfifo-patch1-reply@mdm.bga.com>
In-Reply-To: <20101020094659.091113f5.randy.dunlap@oracle.com>
References: <20101019151048.ae79bb25.randy.dunlap@oracle.com>
	<20101019221242.c732e1fa.akpm@linux-foundation.org>
	<20101020094659.091113f5.randy.dunlap@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Date: Wed, 20 Oct 2010 12:51:27 -0500
X-Originating-IP: 71.22.127.106
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> --- linux-next-20101019.orig/drivers/char/n_gsm.c
> +++ linux-next-20101019/drivers/char/n_gsm.c
> @@ -1573,11 +1573,14 @@  static void gsm_dlci_command(struct gsm_
>  static struct gsm_dlci *gsm_dlci_alloc(struct gsm_mux *gsm, int addr)
>  {
>  	struct gsm_dlci *dlci = kzalloc(sizeof(struct gsm_dlci), GFP_ATOMIC);
> +	int err;
> +
>  	if (dlci == NULL)
>  		return NULL;
>  	spin_lock_init(&dlci->lock);
>  	dlci->fifo = &dlci->_fifo;
> -	if (kfifo_alloc(&dlci->_fifo, 4096, GFP_KERNEL) < 0) {
> +	err = kfifo_alloc(&dlci->_fifo, 4096, GFP_KERNEL);
> +	if (err < 0) {
>  		kfree(dlci);
>  		return NULL;
>  	}
> 
> 


I think this is not a gcc bug but Randy's gcc beeing smarter
and showing a signed bug with the old code.

The earlier discussion had:

> > > Should the driver code be doing something else?
> > > or should the kfifo_alloc() macro be checking the result of the helper?
> > > 
> > 
> > A gcc bug, I'd say.  The code looks OK and my gcc doesn't warn.
> 
> OK.
> 
> > Perhaps see if you can find some code transformation in n_gsm.c which
> > makes it go away?  Add a new local variable or something.
> 
> Yes, that works for me.  Patch is below.
> 

> > I did see a probably unrelated bug in there though. 
> > __kfifo_must_check_helper() coerces its arg into an `unsigned int' and
> > returns an unsigned int.  Consequently if kfifo_alloc() tries to return
> > -EINVAL, the above-quoted code won't detect the error: it will see
> > -EINVAL as a large, positive unsigned value.
> > 

and then gcc decides that the check of < 0 is meaningless, and then
says that the result is unused.

Note: I'm a kernel hacker , not a gcc one.  This is pure speculation.

So to me the helper is the one causing the error!  ... and the patch is
undoing the damage at the caller.

So the correct fix is to change the return type of the helper,
and if someone wants the int to be unsigned then it needs to be
unsigned long so we can use an is_error type test.

milton
