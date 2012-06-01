Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932597Ab2FAUpI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2012 16:45:08 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:56675 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756897Ab2FAUpG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2012 16:45:06 -0400
Subject: Re: [PATCH] tty: add lockdep annotations
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Alan Cox <alan@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jens Axboe <jaxboe@fusionio.com>
In-Reply-To: <CA+55aFzrbmGjghmR3M=fWrGUdy6BDu+SVXz6rjM4QAuUjfxk_w@mail.gmail.com>
References: <4FC6189B.9080909@fusionio.com>
	 <1338402812.2760.413.camel@edumazet-glaptop>
	 <4FC66D3D.6080509@fusionio.com>
	 <1338404902.2760.451.camel@edumazet-glaptop>
	 <1338410107.2760.544.camel@edumazet-glaptop>
	 <1338456918.2760.1318.camel@edumazet-glaptop>
	 <1338574627.2760.1545.camel@edumazet-glaptop>
	 <CA+55aFzrbmGjghmR3M=fWrGUdy6BDu+SVXz6rjM4QAuUjfxk_w@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 01 Jun 2012 22:44:58 +0200
Message-ID: <1338583498.2760.1648.camel@edumazet-glaptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-06-01 at 11:51 -0700, Linus Torvalds wrote:
> On Fri, Jun 1, 2012 at 11:17 AM, Eric Dumazet <eric.dumazet@gmail.com> wrote:
> >
> > About 10% of boots on my machine, and this looks like (hand written)
> >
> > general protection fault: 0000 [#1] SMP DEBUG_PAGEALLOC
> > ...
> > RIP : tty_shutdown+0x15/)x70
> 
> Ok, DEBUG_PAGEALLOC and with that offset fairly early in tty_shutdown,
> it's almost certainly one of the accesses in the
> 
>   tty->driver->ops->remove
> 

Yes, tty->driver deref is ok (tty points to valid memory), but crash is
on tty->driver->ops (driver points to freed/illegal memory)

using slub_debug=FZPU, I can indeed see RDI=6b6b6b6b6b6b6b6b

Typical use after free...

> chain when it does the (inlined)
> 
>     tty_driver_remove_tty(tty->driver, tty);
> 
> you could check which one it is at that offset 0x15, but I think both
> the ops and the driver structures should be statically allocated, so I
> suspect it's the "tty" itself that is already freed.
> 
> Odd. But yes, smells very much like a refcount issue, probably due to
> broken locking. Does the problem go away if you revert commits
> d29f3ef39be4 ("tty_lock: Localise the lock") and 3af502b96649
> ("tty_lock: undo the old tty_lock use on the ctty")?

Tried this but seems not straightforward, and its pretty late here in
France, week end starting ;)

By the way, release_one_tty() uses the following racy code :

tty_driver_kref_put(driver);
module_put(driver->owner);

I would use following patch to make sure bad things cant happen...

Thanks
diff --git a/drivers/tty/tty_io.c b/drivers/tty/tty_io.c
index 9e930c0..b8faf40 100644
--- a/drivers/tty/tty_io.c
+++ b/drivers/tty/tty_io.c
@@ -1479,13 +1479,14 @@ static void release_one_tty(struct work_struct *work)
 	struct tty_struct *tty =
 		container_of(work, struct tty_struct, hangup_work);
 	struct tty_driver *driver = tty->driver;
+	struct module *module = driver->owner;
 
 	if (tty->ops->cleanup)
 		tty->ops->cleanup(tty);
 
 	tty->magic = 0;
 	tty_driver_kref_put(driver);
-	module_put(driver->owner);
+	module_put(module);
 
 	spin_lock(&tty_files_lock);
 	list_del_init(&tty->tty_files);


