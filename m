Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966387Ab2FBHRY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jun 2012 03:17:24 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:44782 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966316Ab2FBHRW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jun 2012 03:17:22 -0400
Subject: Re: [PATCH] tty: add lockdep annotations
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Alan Cox <alan@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jens Axboe <jaxboe@fusionio.com>
In-Reply-To: <1338584389.2760.1653.camel@edumazet-glaptop>
References: <4FC6189B.9080909@fusionio.com>
	 <1338402812.2760.413.camel@edumazet-glaptop>
	 <4FC66D3D.6080509@fusionio.com>
	 <1338404902.2760.451.camel@edumazet-glaptop>
	 <1338410107.2760.544.camel@edumazet-glaptop>
	 <1338456918.2760.1318.camel@edumazet-glaptop>
	 <1338574627.2760.1545.camel@edumazet-glaptop>
	 <CA+55aFzrbmGjghmR3M=fWrGUdy6BDu+SVXz6rjM4QAuUjfxk_w@mail.gmail.com>
	 <1338583498.2760.1648.camel@edumazet-glaptop>
	 <20120601215620.305155c0@pyramind.ukuu.org.uk>
	 <1338584389.2760.1653.camel@edumazet-glaptop>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 02 Jun 2012 09:17:18 +0200
Message-ID: <1338621438.2760.1679.camel@edumazet-glaptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-06-01 at 22:59 +0200, Eric Dumazet wrote:
> On Fri, 2012-06-01 at 21:56 +0100, Alan Cox wrote:
> > > Yes, tty->driver deref is ok (tty points to valid memory), but crash is
> > > on tty->driver->ops (driver points to freed/illegal memory)
> > > 
> > > using slub_debug=FZPU, I can indeed see RDI=6b6b6b6b6b6b6b6b
> > 
> > driver and driver->ops is basically const and it's not what you'd expect
> > from a tty refcount bug. The driver side puts shouldn't have changed but
> > I'll take a look over that patch and the error paths closely again just
> > in case.
> 
> right
> 
> The code looks like :
> ...
> 	call mcount
> 	mov  %rdi,%rbx
> 	mov  0x10(%rdi),%rdi   tty->driver
> <>	mov  0xf8(%rdi),%rax   CRASH
> 
> So tty was freed an tty->driver contains 6b6b6b6b6b6b6b6b
> 
> 

Here is the patch I am currently testing (need to boot the machine ~50
times to make sure it is the right fix)

diff --git a/drivers/tty/tty_io.c b/drivers/tty/tty_io.c
index 9e930c0..128a95b 100644
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
@@ -2005,11 +2006,15 @@ retry_open:
 			filp->f_op = &tty_fops;
 		goto retry_open;
 	}
-	tty_unlock(tty);
-
 
+	/*
+	 * Must acquire both mutexes in right order,
+	 * and keep a reference on tty, so dont call tty_unlock() !
+	 */
+	mutex_unlock(&tty->legacy_mutex);
 	mutex_lock(&tty_mutex);
-	tty_lock(tty);
+	mutex_lock(&tty->legacy_mutex);
+
 	spin_lock_irq(&current->sighand->siglock);
 	if (!noctty &&
 	    current->signal->leader &&


