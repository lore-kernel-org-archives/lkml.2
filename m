Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757578Ab1CaNhd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 09:37:33 -0400
Received: from adelie.canonical.com ([91.189.90.139]:35017 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757472Ab1CaNhc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 09:37:32 -0400
Date: Thu, 31 Mar 2011 10:37:26 -0300
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: Alan Cox <alan@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [PATCH] vt: avoid BUG_ON in con_shutdown when con_open returns
 with error
Message-ID: <20110331133725.GA2040@herton-IdeaPad-Y430>
References: <1301524178-7925-1-git-send-email-herton.krzesinski@canonical.com>
 <20110331105811.5d989e86@bob.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110331105811.5d989e86@bob.linux.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 31, 2011 at 10:58:11AM +0100, Alan Cox wrote:
> O
> > +static inline void con_ops_set_shutdown(void);
> >  static int con_open(struct tty_struct *, struct file *);
> >  static void vc_init(struct vc_data *vc, unsigned int rows,
> >  		    unsigned int cols, int do_clear);
> > @@ -2806,6 +2807,14 @@ static int con_open(struct tty_struct *tty,
> > struct file *filp) tty->driver_data = vc;
> >  			vc->port.tty = tty;
> >  
> > +			/* We must set shutdown only here, otherwise
> > +			 * we returned from con_open with error,
> > which
> > +			 * will make tty core call tty_release, that
> > +			 * in its call path makes con_shutdown being
> > +			 * called without tty->driver_data being set,
> > +			 * triggering the BUG_ON there */
> > +			con_ops_set_shutdown();
> 
> No we cannot go around patching the tty_operations - they are not
> locked for one.

Indeed, I feel in those "wearing a brown paper bag" moments now...

> 
> Probably this is one case where making con_shutdown() check is the
> right answer.
> 

I still wonder though if really the BUG_ON is ok, or I still didn't got
that code right. Even if it returns -ERESTARTSYS we will hit that
BUG_ON, if vc->port.tty != tty no? Or that is what the BUG_ON is trying
to catch?

While looking I noted a minor thing, in tty_open we don't need to check
retval again in one place, as !retval is always true, because we return
earlier (in retval = tty_add_file ...):

diff --git a/drivers/tty/tty_io.c b/drivers/tty/tty_io.c
index 936a4ea..349fa67 100644
--- a/drivers/tty/tty_io.c
+++ b/drivers/tty/tty_io.c
@@ -1902,12 +1902,10 @@ got_driver:
 #ifdef TTY_DEBUG_HANGUP
 	printk(KERN_DEBUG "opening %s...", tty->name);
 #endif
-	if (!retval) {
-		if (tty->ops->open)
-			retval = tty->ops->open(tty, filp);
-		else
-			retval = -ENODEV;
-	}
+	if (tty->ops->open)
+		retval = tty->ops->open(tty, filp);
+	else
+		retval = -ENODEV;
 	filp->f_flags = saved_flags;
 
 	if (!retval && test_bit(TTY_EXCLUSIVE, &tty->flags) &&

-- 
[]'s
Herton
