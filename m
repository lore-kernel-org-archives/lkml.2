Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757467Ab0JEDv1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Oct 2010 23:51:27 -0400
Received: from relais.videotron.ca ([24.201.245.36]:65471 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751687Ab0JEDv0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Oct 2010 23:51:26 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN; charset=US-ASCII
Date: Mon, 04 Oct 2010 23:51:25 -0400 (EDT)
From: Nicolas Pitre <nico@fluxnic.net>
X-X-Sender: nico@xanadu.home
To: Andrew Morton <akpm@linux-foundation.org>
Cc: lkml <linux-kernel@vger.kernel.org>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [PATCH 1/2] vcs: add poll/fasync support
In-reply-to: <20101004155454.771f7b70.akpm@linux-foundation.org>
Message-id: <alpine.LFD.2.00.1010042323350.3107@xanadu.home>
References: <alpine.LFD.2.00.1009302320360.1146@xanadu.home>
 <20101004155454.771f7b70.akpm@linux-foundation.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 4 Oct 2010, Andrew Morton wrote:

> On Fri, 01 Oct 2010 00:10:23 -0400 (EDT)
> Nicolas Pitre <nico@fluxnic.net> wrote:
> 
> > The /dev/vcs* devices are used, amongst other things, by accessibility
> > applications such as BRLTTY to display the screen content onto refreshable
> > braille displays.  Currently this is performed by constantly reading from
> > /dev/vcsa0 whether or not the screen content has changed.  Given the
> > default braille refresh rate of 25 times per second, this easily qualifies
> > as the biggest source of wake-up events preventing laptops from entering
> > deeper power saving states.
> > 
> > To avoid this periodic polling, let's add support for select()/poll() and
> > SIGIO with the /dev/vcs* devices.  The implemented semantic is to report
> > data availability whenever the corresponding vt has seen some update after
> > the last read() operation.  The application still has to lseek() back
> > as usual in order to read() the new data.
> > 
> > Not to create unwanted overhead, the needed data structure is allocated
> > and the vt notification callback is registered only when the poll or
> > fasync method is invoked for the first time per file instance.
> > 
> > ...
> > 
> > diff --git a/drivers/char/vc_screen.c b/drivers/char/vc_screen.c
> > index bcce46c..9013573 100644
> > --- a/drivers/char/vc_screen.c
> > +++ b/drivers/char/vc_screen.c
> > @@ -35,6 +35,10 @@
> >  #include <linux/console.h>
> >  #include <linux/device.h>
> >  #include <linux/smp_lock.h>
> > +#include <linux/sched.h>
> > +#include <linux/poll.h>
> > +#include <linux/signal.h>
> > +#include <linux/slab.h>
> 
> Formally, we need fs.h and notifier.h (at lesat).  I'll fix that up.

I didn't think that notifier.h was necessary as the declaration for 
register_vt_notifier() is in vt_kern.h, which also includes notifier.h 
itself already.

As to fs.h... I agree in principle, but I don't see what my patch is 
adding that would make fs.h a new requirement. In other words it was 
probably required even before, which could justify a patch of its own?

> >  #include <asm/uaccess.h>
> >  #include <asm/byteorder.h>
> > @@ -45,6 +49,78 @@
> >  #undef addr
> >  #define HEADER_SIZE	4
> >  
> > +struct vcs_poll_data {
> > +	struct notifier_block notifier;
> > +	unsigned int cons_num;
> > +	int has_read;
> 
> It would be nice to document the meaning of has_read.  And consider
> using the more appropriate `bool' type?

OK, please could you fold the patch below into this one?  That should 
make the code more self explanatory.

[...]
> > +static struct vcs_poll_data *
> > +vcs_poll_data_get(struct file *file)
> > +{
> > +	struct vcs_poll_data *poll = file->private_data;
> > +
> > +	if (poll)
> > +		return poll;
> > +
> > +	poll = kzalloc(sizeof(*poll), GFP_KERNEL);
> > +	if (!poll)
> > +		return NULL;
> > +	poll->cons_num = iminor(file->f_path.dentry->d_inode) & 127;
> > +	init_waitqueue_head(&poll->waitq);
> > +	poll->notifier.notifier_call = vcs_notifier;
> > +	if (register_vt_notifier(&poll->notifier) != 0) {
> > +		kfree(poll);
> > +		return NULL;
> > +	}
> > +
> > +	spin_lock(&file->f_lock);
> > +	if (!file->private_data) {
> > +		file->private_data = poll;
> > +	} else {
> > +		/* someone else raced ahead of us */
> > +		vcs_poll_data_free(poll);
> > +		poll = file->private_data;
> > +	}
> > +	spin_unlock(&file->f_lock);
> 
> What's the race-handling code here all about?

This code may be called either through ->poll() or ->fasync().  If we 
have two threads using the same file descriptor, they could both enter 
this function, both notice that the structure hasn't been allocated yet 
and go ahead allocating it in parallel, but only one of them must 
survive and be shared otherwise we'd leak memory with a dangling 
notifier callback.

8< -----
diff --git a/drivers/char/vc_screen.c b/drivers/char/vc_screen.c
index 58e8d5e..a6ecd6a 100644
--- a/drivers/char/vc_screen.c
+++ b/drivers/char/vc_screen.c
@@ -52,7 +52,7 @@
 struct vcs_poll_data {
 	struct notifier_block notifier;
 	unsigned int cons_num;
-	int has_read;
+	bool seen_last_update;
 	wait_queue_head_t waitq;
 	struct fasync_struct *fasync;
 };
@@ -76,7 +76,7 @@ vcs_notifier(struct notifier_block *nb, unsigned long code, void *_param)
 	if (currcons != vc->vc_num)
 		return NOTIFY_DONE;
 
-	poll->has_read = 0;
+	poll->seen_last_update = false;
 	wake_up_interruptible(&poll->waitq);
 	kill_fasync(&poll->fasync, SIGIO, POLL_IN);
 	return NOTIFY_OK;
@@ -213,7 +213,7 @@ vcs_read(struct file *file, char __user *buf, size_t count, loff_t *ppos)
 		goto unlock_out;
 	poll = file->private_data;
 	if (count && poll)
-		poll->has_read = 1;
+		poll->seen_last_update = true;
 	read = 0;
 	ret = 0;
 	while (count) {
@@ -547,7 +547,7 @@ vcs_poll(struct file *file, poll_table *wait)
 
 	if (poll) {
 		poll_wait(file, &poll->waitq, wait);
-		if (!poll->has_read)
+		if (!poll->seen_last_update)
 			ret = POLLIN | POLLRDNORM;
 	}
 	return ret;
