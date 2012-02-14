Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761308Ab2BNXJg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Feb 2012 18:09:36 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:39225 "EHLO
	out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757285Ab2BNXJf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Feb 2012 18:09:35 -0500
X-Sasl-enc: zryCDACGfAebZ1l/h7/aq8x52/WzfjU9RoaDdQw9D0cM 1329260974
Date: Tue, 14 Feb 2012 15:03:23 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Anton Vorontsov <anton.vorontsov@linaro.org>
Cc: Oleg Nesterov <oleg@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
        rientjes@google.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sysrq: Use SEND_SIG_FORCED instead of force_sig()
Message-ID: <20120214230323.GA9292@kroah.com>
References: <13288070803232@kroah.org>
 <20120210201008.GA21009@redhat.com>
 <20120214225017.GA12360@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120214225017.GA12360@oksana.dev.rtsoft.ru>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 15, 2012 at 02:50:17AM +0400, Anton Vorontsov wrote:
> Change send_sig_all() to use do_send_sig_info(SEND_SIG_FORCED)
> instead of force_sig(SIGKILL). With the recent changes we do not
> need force_ to kill the CLONE_NEWPID tasks.
> 
> And this is more correct. force_sig() can race with the exiting
> thread, while do_send_sig_info(group => true) kill the whole
> process.
> 
> Suggested-by: Oleg Nesterov <oleg@redhat.com>
> Signed-off-by: Anton Vorontsov <anton.vorontsov@linaro.org>
> ---
> 
> On Fri, Feb 10, 2012 at 09:10:08PM +0100, Oleg Nesterov wrote:
> > > --- a/drivers/tty/sysrq.c
> > > +++ b/drivers/tty/sysrq.c
> > > @@ -324,9 +324,12 @@ static void send_sig_all(int sig)
> > >  
> > >  	read_lock(&tasklist_lock);
> > >  	for_each_process(p) {
> > > -		if (p->mm && !is_global_init(p))
> > > -			/* Not swapper, init nor kernel thread */
> > > -			force_sig(sig, p);
> > > +		if (p->flags & PF_KTHREAD)
> > > +			continue;
> > > +		if (is_global_init(p))
> > > +			continue;
> > > +
> > > +		force_sig(sig, p);
> > >  	}
> > >  	read_unlock(&tasklist_lock);
> > 
> > Obviously I agree with this change.
> > 
> > But where does this read_lock(tasklist) come from?
> 
> It came from this patch: http://lkml.org/lkml/2012/2/7/24
> 
> > We discussed this with Anton. Yes, tasklist ensures that
> > force_sig() can't crash the kernel. But it is still wrong
> > and should not be used.
> >
> > I think send_sig_all() should use SEND_SIG_FORCED (this
> > depends on the patches I sent to Andrew), in this case
> > tasklist is not needed.
> 
> Well, I think the lock is still a good thing: we don't want
> any new processes to be created while we kill others.
> 
> I might be wrong, but copy_process() issues recalc_sigpending()
> under tasklist lock especially the for this scenario.
> 
> So, in this and in OOM cases we have to be precise (unlike LMK).
> Sysrq is a rare thing, so there is actually should be no problem
> with holding the lock.
> 
> So, how about this patch?
> 
> Greg, can we take it via -mm tree, as it depends on a few
> sched patches?

That's fine with me:
	Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

