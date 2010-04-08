Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758189Ab0DHAbP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Apr 2010 20:31:15 -0400
Received: from kroah.org ([198.145.64.141]:60468 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756371Ab0DHAbK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Apr 2010 20:31:10 -0400
Date: Wed, 7 Apr 2010 17:28:29 -0700
From: Greg KH <greg@kroah.com>
To: =?utf-8?Q?Micha=C5=82?= Nazarewicz <m.nazarewicz@samsung.com>
Cc: linux-usb@vger.kernel.org, Peter Korsgaard <jacmet@sunsite.dk>,
       Rupesh Gujare <rupeshgujare@gmail.com>, linux-kernel@vger.kernel.org,
       David Brownell <dbrownell@users.sourceforge.net>,
       Kyungmin Park <kyungmin.park@samsung.com>,
       Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: [PATCH 2/8] sched: __wake_up_locked() exported
Message-ID: <20100408002829.GB4365@kroah.com>
References: <cover.1270644740.git.mina86@mina86.com>
 <033ad254a3bba337e7a37cc6071b7debc7051801.1270644740.git.mina86@mina86.com>
 <b866157fc128769a3cdf9ae76f9fc21743776778.1270644740.git.mina86@mina86.com>
 <20100407152922.GB13425@kroah.com>
 <op.vasx0rg07p4s8u@pikus>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <op.vasx0rg07p4s8u@pikus>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 07, 2010 at 07:11:05PM +0200, Michał Nazarewicz wrote:
> >On Wed, Apr 07, 2010 at 03:41:29PM +0200, Michal Nazarewicz wrote:
> >>The __wake_up_locked() function has been exported in case modules need it.
> 
> On Wed, 07 Apr 2010 17:29:22 +0200, Greg KH <greg@kroah.com> wrote:
> >What module needs it?
> 
> FunctionFS (f_fs) uses it (thus FunctionFS Gadget (g_ffs) uses it).
> 
> >Why is it needed?
> 
> The FunctionFS uses wait_queue_head_t's spinlock to protect a data
> structure (a queue) used by FunctionFS.
> 
> In an earlier version of the code there was another spinlock for
> the queue alone thus when waiting for an event the following had
> to be used:
> 
> #v+
> spin_lock(&queue.lock);
> while (queue.empty) {
> 	spin_unlock(&queue.lock);
> 	wait_event(&queue.wait_queue, !queue.empty);
> 	spin_lock(&queue.lock);
> }
> ...
> spin_unlock(&queue.lock);
> #v-
> 
> I disliked this code very much and at first hoped that there's some
> "wait_event_holding_lock()" macro which would define the loop shown
> above (similar to user-space condition variables; see
> pthread_cond_wait(3) <http://linux.die.net/man/3/pthread_cond_wait>).
> 
> What makes matter worse is that wait_event() calls prepare_to_wait()
> which locks the wait_queue_head_t's spinlock so in the end we have
> unlock one spinlock prior to locking another in situation where one
> spinlock would suffice.
> 
> In searching for a better solution I stumbled across fs/timerfd.c which
> used the wait_queue_head_t's spinlock to lock it's own structures:
> 
> * http://lxr.linux.no/#linux+v2.6.33/fs/timerfd.c#L39
> * http://lxr.linux.no/#linux+v2.6.33/fs/timerfd.c#L106
> 
> So, in the end, I decided to use the same approach in FunctionFS and
> hence by using wait_queue_head_t's spinlock I removed one (unneeded)
> spinlock and decreased number of spin_lock and spin_unlock operations,
> ie. to something like (simplified code):
> 
> #v+
> spin_lock(&queue.wait_queue.lock);
> my_wait_event_locked(&queue.wait_queue, !queue.empty);
> ...
> spin_unlock(&queue.lock);
> #v-
> 
> where my_wait_event_locked() is a function that does what wait_event()
> does but assumes the wait_queue_head_t's lock is held when entering
> and leaves it held when exiting.
> 
> >Are you sure that you really need it?
> 
> I could live without it but I strongly believe the code is somehow
> cleaner and more optimised when __wake_up_locked() is used.

Ok, thanks for the detailed description, that makes more sense.

Perhaps you should put this into the patch description next time :)

Oh, and maybe we should move this type of functionality into the core
kernel so that the two users don't have to open-code it both times?  If
there are 2 users, odds are someone else will want to also do the same
thing in the near future.

thanks,

greg k-h
