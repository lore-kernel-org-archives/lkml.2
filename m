Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754426Ab0JTQsF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 12:48:05 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:47563 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754095Ab0JTQsE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 12:48:04 -0400
Date: Wed, 20 Oct 2010 09:46:59 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: lkml <linux-kernel@vger.kernel.org>, Stefani Seibold <stefani@seibold.net>
Subject: Re: kfifo must_check warning (+ patch)
Message-Id: <20101020094659.091113f5.randy.dunlap@oracle.com>
In-Reply-To: <20101019221242.c732e1fa.akpm@linux-foundation.org>
References: <20101019151048.ae79bb25.randy.dunlap@oracle.com>
	<20101019221242.c732e1fa.akpm@linux-foundation.org>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 Oct 2010 22:12:42 -0700 Andrew Morton wrote:

> On Tue, 19 Oct 2010 15:10:48 -0700 Randy Dunlap <randy.dunlap@oracle.com> wrote:
> 
> > In 2.6.36-rc8, I see this build warning:
> > 
> > drivers/char/n_gsm.c: In function 'gsm_dlci_alloc':
> > drivers/char/n_gsm.c:1580: warning: ignoring return value of '__kfifo_must_check_helper', declared with attribute warn_unused_result
> > 
> > The helper seems to be getting in the way (?).  The driver code does this:
> > 
> > 	if (kfifo_alloc(&dlci->_fifo, 4096, GFP_KERNEL) < 0) {
> > 		kfree(dlci);
> > 		return NULL;
> > 	}
> > 
> > Should the driver code be doing something else?
> > or should the kfifo_alloc() macro be checking the result of the helper?
> > 
> 
> A gcc bug, I'd say.  The code looks OK and my gcc doesn't warn.

OK.

> Perhaps see if you can find some code transformation in n_gsm.c which
> makes it go away?  Add a new local variable or something.

Yes, that works for me.  Patch is below.

> I did see a probably unrelated bug in there though. 
> __kfifo_must_check_helper() coerces its arg into an `unsigned int' and
> returns an unsigned int.  Consequently if kfifo_alloc() tries to return
> -EINVAL, the above-quoted code won't detect the error: it will see
> -EINVAL as a large, positive unsigned value.
> 
> I don't see a simple fix for that apart from creating several flavours
> of __kfifo_must_check_helper() and carefully going through each
> instance and using the one which takes (and returns) the correct type.
> 
> A suitable temporary 2.6.37 patch would bee to just disable
> __kfifo_must_check_helper():
> 
> --- a/include/linux/kfifo.h~a
> +++ a/include/linux/kfifo.h
> @@ -171,11 +171,7 @@ struct kfifo_rec_ptr_2 __STRUCT_KFIFO_PT
>  	}
>  
>  
> -static inline unsigned int __must_check
> -__kfifo_must_check_helper(unsigned int val)
> -{
> -	return val;
> -}
> +#define __kfifo_must_check_helper(x) (x)
>  
>  /**
>   * kfifo_initialized - Check if the fifo is initialized
> _
> 
> --


From: Randy Dunlap <randy.dunlap@oracle.com>

Some versions of gcc mysteriously report:
drivers/char/n_gsm.c:1580: warning: ignoring return value of '__kfifo_must_check_helper', declared with attribute warn_unused_result

This warning can be eliminated by using a local variable for the
returned result value, as suggested by Andrew Morton.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 drivers/char/n_gsm.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- linux-next-20101019.orig/drivers/char/n_gsm.c
+++ linux-next-20101019/drivers/char/n_gsm.c
@@ -1573,11 +1573,14 @@ static void gsm_dlci_command(struct gsm_
 static struct gsm_dlci *gsm_dlci_alloc(struct gsm_mux *gsm, int addr)
 {
 	struct gsm_dlci *dlci = kzalloc(sizeof(struct gsm_dlci), GFP_ATOMIC);
+	int err;
+
 	if (dlci == NULL)
 		return NULL;
 	spin_lock_init(&dlci->lock);
 	dlci->fifo = &dlci->_fifo;
-	if (kfifo_alloc(&dlci->_fifo, 4096, GFP_KERNEL) < 0) {
+	err = kfifo_alloc(&dlci->_fifo, 4096, GFP_KERNEL);
+	if (err < 0) {
 		kfree(dlci);
 		return NULL;
 	}
