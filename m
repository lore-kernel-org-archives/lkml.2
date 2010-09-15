Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755144Ab0IOTBs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Sep 2010 15:01:48 -0400
Received: from casper.infradead.org ([85.118.1.10]:45900 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753453Ab0IOTBr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Sep 2010 15:01:47 -0400
Date: Wed, 15 Sep 2010 20:01:43 +0100 (BST)
From: James Simmons <jsimmons@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Jarek Poplawski <jarkao2@gmail.com>, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fbcon: fix lockdep warning from fbcon_deinit()
In-Reply-To: <20100913152127.c2328034.akpm@linux-foundation.org>
Message-ID: <alpine.LFD.2.00.1009152000220.7965@casper.infradead.org>
References: <20100913215850.GA2176@del.dom.local> <20100913152127.c2328034.akpm@linux-foundation.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> On Mon, 13 Sep 2010 23:58:50 +0200
> Jarek Poplawski <jarkao2@gmail.com> wrote:
> 
> > This patch fixes the lockdep warning:
> > 
> > [   13.657164] INFO: trying to register non-static key.
> > [   13.657169] the code is fine but needs lockdep annotation.
> > [   13.657171] turning off the locking correctness validator.
> > [   13.657177] Pid: 622, comm: modprobe Not tainted 2.6.36-rc3c #8
> > [   13.657180] Call Trace:
> > [   13.657194]  [<c13002c8>] ? printk+0x18/0x20
> > [   13.657202]  [<c1056cf6>] register_lock_class+0x336/0x350
> > [   13.657208]  [<c1058bf9>] __lock_acquire+0x449/0x1180
> > [   13.657215]  [<c1059997>] lock_acquire+0x67/0x80
> > [   13.657222]  [<c1042bf1>] ? __cancel_work_timer+0x51/0x230
> > [   13.657227]  [<c1042c23>] __cancel_work_timer+0x83/0x230
> > [   13.657231]  [<c1042bf1>] ? __cancel_work_timer+0x51/0x230
> > [   13.657236]  [<c10582b2>] ? mark_held_locks+0x62/0x80
> > [   13.657243]  [<c10b3a2f>] ? kfree+0x7f/0xe0
> > [   13.657248]  [<c105853c>] ? trace_hardirqs_on_caller+0x11c/0x160
> > [   13.657253]  [<c105858b>] ? trace_hardirqs_on+0xb/0x10
> > [   13.657259]  [<c117f4cd>] ? fbcon_deinit+0x16d/0x1e0
> > [   13.657263]  [<c117f4cd>] ? fbcon_deinit+0x16d/0x1e0
> > [   13.657268]  [<c1042dea>] cancel_work_sync+0xa/0x10
> > [   13.657272]  [<c117f444>] fbcon_deinit+0xe4/0x1e0
> > ...
> > 
> > The warning is caused by trying to cancel an uninitialized work from
> > fbcon_exit(). Fix it by adding a check for queue.func, similarly to
> > other places in this code.
> > 
> > Signed-off-by: Jarek Poplawski <jarkao2@gmail.com>
> > ---
> > 
> > diff --git a/drivers/video/console/fbcon.c b/drivers/video/console/fbcon.c
> > index 84f8423..7ccc967 100644
> > --- a/drivers/video/console/fbcon.c
> > +++ b/drivers/video/console/fbcon.c
> > @@ -3508,7 +3508,7 @@ static void fbcon_exit(void)
> >  	softback_buf = 0UL;
> >  
> >  	for (i = 0; i < FB_MAX; i++) {
> > -		int pending;
> > +		int pending = 0;
> >  
> >  		mapped = 0;
> >  		info = registered_fb[i];
> > @@ -3516,7 +3516,8 @@ static void fbcon_exit(void)
> >  		if (info == NULL)
> >  			continue;
> >  
> > -		pending = cancel_work_sync(&info->queue);
> > +		if (info->queue.func)
> > +			pending = cancel_work_sync(&info->queue);
> >  		DPRINTK("fbcon: %s pending work\n", (pending ? "canceled" :
> >  			"no"));
> >  
> 
> Well.  It'd be better to just initialise the dang thing.
> 
> But all that code looks really hacky, fiddling around inside workqueue
> internals as a driver-private state variable.  Needs a rewrite, I suspect.

You are not kidding. I just started to tackle that mess. Currently fbcon 
is broken in my tree but I plan to get in going again in the next few 
weeks.

http://git.infradead.org/users/jsimmons/linuxconsole-2.6.git
