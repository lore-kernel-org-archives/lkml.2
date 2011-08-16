Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752512Ab1HPU3u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Aug 2011 16:29:50 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:44588 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751377Ab1HPU3t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Aug 2011 16:29:49 -0400
Subject: Re: [PATCH 37/41] autofs4: Use set_current_blocked()
From: Matt Fleming <matt@console-pimps.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: linux-kernel@vger.kernel.org, Ian Kent <raven@themaw.net>
In-Reply-To: <20110816174707.GH29190@redhat.com>
References: <1313071035-12047-1-git-send-email-matt@console-pimps.org>
	 <1313071035-12047-38-git-send-email-matt@console-pimps.org>
	 <20110816174707.GH29190@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 16 Aug 2011 21:29:46 +0100
Message-ID: <1313526586.3436.188.camel@mfleming-mobl1.ger.corp.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 (2.32.2-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-08-16 at 19:47 +0200, Oleg Nesterov wrote:
> On 08/11, Matt Fleming wrote:
> >
> > As described in e6fa16ab ("signal: sigprocmask() should do
> > retarget_shared_pending()") the modification of current->blocked is
> > incorrect as we need to check whether the signal we're about to block
> > is pending in the shared queue.
> 
> ACK.
> 
> 
> cough, can't resist...
> 
> > @@ -458,21 +458,16 @@ int autofs4_wait(struct autofs_sb_info *sbi, struct dentry *dentry,
> >  	 */
> >  	if (wq->name.name) {
> >  		/* Block all but "shutdown" signals while waiting */
> > -		sigset_t oldset;
> > +		sigset_t oldset, blocked;
> >  		unsigned long irqflags;
> >  
> > -		spin_lock_irqsave(&current->sighand->siglock, irqflags);
> >  		oldset = current->blocked;
> > -		siginitsetinv(&current->blocked, SHUTDOWN_SIGS & ~oldset.sig[0]);
> > -		recalc_sigpending();
> > -		spin_unlock_irqrestore(&current->sighand->siglock, irqflags);
> > +		siginitsetinv(&blocked, SHUTDOWN_SIGS & ~oldset.sig[0]);
> > +		set_current_blocked(&blocked);
> >  
> >  		wait_event_interruptible(wq->queue, wq->name.name == NULL);
> > -
> > -		spin_lock_irqsave(&current->sighand->siglock, irqflags);
> > -		current->blocked = oldset;
> > -		recalc_sigpending();
> > -		spin_unlock_irqrestore(&current->sighand->siglock, irqflags);
> > +		
> 
> this adds the trailing whitespaces ;)

Whoops! I fixed that and added your Acked-by. Thanks!

-- 
Matt Fleming, Intel Open Source Technology Center

