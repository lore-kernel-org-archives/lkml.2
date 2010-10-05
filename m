Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752468Ab0JEETT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 00:19:19 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33036 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751657Ab0JEETS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 00:19:18 -0400
Date: Mon, 4 Oct 2010 21:20:25 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Nicolas Pitre <nico@fluxnic.net>
Cc: lkml <linux-kernel@vger.kernel.org>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [PATCH 1/2] vcs: add poll/fasync support
Message-Id: <20101004212025.279eca25.akpm@linux-foundation.org>
In-Reply-To: <alpine.LFD.2.00.1010042323350.3107@xanadu.home>
References: <alpine.LFD.2.00.1009302320360.1146@xanadu.home>
	<20101004155454.771f7b70.akpm@linux-foundation.org>
	<alpine.LFD.2.00.1010042323350.3107@xanadu.home>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 04 Oct 2010 23:51:25 -0400 (EDT) Nicolas Pitre <nico@fluxnic.net> wrote:

> On Mon, 4 Oct 2010, Andrew Morton wrote:
> 
> > On Fri, 01 Oct 2010 00:10:23 -0400 (EDT)
> > Nicolas Pitre <nico@fluxnic.net> wrote:
> > 
> > > The /dev/vcs* devices are used, amongst other things, by accessibility
> > > applications such as BRLTTY to display the screen content onto refreshable
> > > braille displays.  Currently this is performed by constantly reading from
> > > /dev/vcsa0 whether or not the screen content has changed.  Given the
> > > default braille refresh rate of 25 times per second, this easily qualifies
> > > as the biggest source of wake-up events preventing laptops from entering
> > > deeper power saving states.
> > > 
> > > To avoid this periodic polling, let's add support for select()/poll() and
> > > SIGIO with the /dev/vcs* devices.  The implemented semantic is to report
> > > data availability whenever the corresponding vt has seen some update after
> > > the last read() operation.  The application still has to lseek() back
> > > as usual in order to read() the new data.
> > > 
> > > Not to create unwanted overhead, the needed data structure is allocated
> > > and the vt notification callback is registered only when the poll or
> > > fasync method is invoked for the first time per file instance.
> > > 
> > > ...
> > > 
> > > diff --git a/drivers/char/vc_screen.c b/drivers/char/vc_screen.c
> > > index bcce46c..9013573 100644
> > > --- a/drivers/char/vc_screen.c
> > > +++ b/drivers/char/vc_screen.c
> > > @@ -35,6 +35,10 @@
> > >  #include <linux/console.h>
> > >  #include <linux/device.h>
> > >  #include <linux/smp_lock.h>
> > > +#include <linux/sched.h>
> > > +#include <linux/poll.h>
> > > +#include <linux/signal.h>
> > > +#include <linux/slab.h>
> > 
> > Formally, we need fs.h and notifier.h (at lesat).  I'll fix that up.
> 
> I didn't think that notifier.h was necessary as the declaration for 
> register_vt_notifier() is in vt_kern.h, which also includes notifier.h 
> itself already.

bug ;) vt_kern.h could use a forward declaration and save the include.

> As to fs.h... I agree in principle, but I don't see what my patch is 
> adding that would make fs.h a new requirement. In other words it was 
> probably required even before, which could justify a patch of its own?

kill_fasync() declaration.

> > >  #include <asm/uaccess.h>
> > >  #include <asm/byteorder.h>
> > > @@ -45,6 +49,78 @@
> > >  #undef addr
> > >  #define HEADER_SIZE	4
> > >  
> > > +struct vcs_poll_data {
> > > +	struct notifier_block notifier;
> > > +	unsigned int cons_num;
> > > +	int has_read;
> > 
> > It would be nice to document the meaning of has_read.  And consider
> > using the more appropriate `bool' type?
> 
> OK, please could you fold the patch below into this one?  That should 
> make the code more self explanatory.

shall take a look, thanks,

> [...]
> > > +static struct vcs_poll_data *
> > > +vcs_poll_data_get(struct file *file)
> > > +{
> > > +	struct vcs_poll_data *poll = file->private_data;
> > > +
> > > +	if (poll)
> > > +		return poll;
> > > +
> > > +	poll = kzalloc(sizeof(*poll), GFP_KERNEL);
> > > +	if (!poll)
> > > +		return NULL;
> > > +	poll->cons_num = iminor(file->f_path.dentry->d_inode) & 127;
> > > +	init_waitqueue_head(&poll->waitq);
> > > +	poll->notifier.notifier_call = vcs_notifier;
> > > +	if (register_vt_notifier(&poll->notifier) != 0) {
> > > +		kfree(poll);
> > > +		return NULL;
> > > +	}
> > > +
> > > +	spin_lock(&file->f_lock);
> > > +	if (!file->private_data) {
> > > +		file->private_data = poll;
> > > +	} else {
> > > +		/* someone else raced ahead of us */
> > > +		vcs_poll_data_free(poll);
> > > +		poll = file->private_data;
> > > +	}
> > > +	spin_unlock(&file->f_lock);
> > 
> > What's the race-handling code here all about?
> 
> This code may be called either through ->poll() or ->fasync().  If we 
> have two threads using the same file descriptor, they could both enter 
> this function, both notice that the structure hasn't been allocated yet 
> and go ahead allocating it in parallel, but only one of them must 
> survive and be shared otherwise we'd leak memory with a dangling 
> notifier callback.

And I'll turn that into a code comment!
