Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752844Ab1HPU4O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Aug 2011 16:56:14 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:58096 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752710Ab1HPU4N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Aug 2011 16:56:13 -0400
Subject: Re: [PATCH 40/41] ncpfs: Use set_current_blocked()
From: Matt Fleming <matt@console-pimps.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: linux-kernel@vger.kernel.org, Petr Vandrovec <petr@vandrovec.name>,
        Al Viro <viro@zeniv.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>
In-Reply-To: <20110816175643.GI29190@redhat.com>
References: <1313071035-12047-1-git-send-email-matt@console-pimps.org>
	 <1313071035-12047-41-git-send-email-matt@console-pimps.org>
	 <20110816175643.GI29190@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 16 Aug 2011 21:56:10 +0100
Message-ID: <1313528170.3436.200.camel@mfleming-mobl1.ger.corp.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 (2.32.2-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-08-16 at 19:56 +0200, Oleg Nesterov wrote:
> On 08/11, Matt Fleming wrote:
> >
> > As described in e6fa16ab ("signal: sigprocmask() should do
> > retarget_shared_pending()") the modification of current->blocked is
> > incorrect as we need to check whether the signal we're about to block
> > is pending in the shared queue.
> 
> I'd wish I could understand this code but this seems impossible ;)

Yeah, I gave up after staring at it for about twenty minutes. I couldn't
fathom the logic behind it.

> IOW, "This doesn't seem right at all." looks reasonable, and the
> PF_EXITING adds even more confusion.

Definitely. If I was more confident in this area of the kernel I would
have just deleted it ;-)

In fact, the more I stare at it, the more I think it needs removing.
Because the thread doesn't hold ->siglock over do_ncp_rpc_call() another
thread could change the signal handler for SIGINT or SIGQUIT mid-call.
Which makes the code under "if (server->m.flags & NCP_MOUNT_INTR)"
pointless.

Petr, Al, Arnd? Could one of you hit me with a clue bat?

> As for this patch, it looks (almost) fine anyway. But,
> 
> > @@ -749,7 +749,7 @@ static int ncp_do_request(struct ncp_server *server, int size,
> >  		return -EIO;
> >  	}
> >  	{
> > -		sigset_t old_set;
> > +		sigset_t old_set, blocked;
> >  		unsigned long mask, flags;
> >  
> >  		spin_lock_irqsave(&current->sighand->siglock, flags);
> > @@ -769,16 +769,14 @@ static int ncp_do_request(struct ncp_server *server, int size,
> >  			if (current->sighand->action[SIGQUIT - 1].sa.sa_handler == SIG_DFL)
> >  				mask |= sigmask(SIGQUIT);
> >  		}
> > -		siginitsetinv(&current->blocked, mask);
> > -		recalc_sigpending();
> > +
> > +		siginitsetinv(&blocked, mask);
> > +		__set_task_blocked(current, &blocked);
> >  		spin_unlock_irqrestore(&current->sighand->siglock, flags);
> 
> Why do we take ->siglock in the first place?
> 
> I think it is not needed. We can calculate mask/blocked lockless and
> use set_task_blocked(). This also makes sense because __set_task_blocked
> is not exported ;)

Eek! Sorry, I didn't realise this didn't compile.

> the sighand->action[] checks are racy anyway in the mt case, siglock
> can't help.

Hmm.. really? I thought that ->siglock serialised modifications to
sighand->action[] even in the mt case, no? This was the only reason that
I left the sighand locking around in this function.

-- 
Matt Fleming, Intel Open Source Technology Center

