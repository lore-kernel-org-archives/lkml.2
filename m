Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751622Ab0CSLFR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Mar 2010 07:05:17 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:60810 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751068Ab0CSLFP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Mar 2010 07:05:15 -0400
Date: Fri, 19 Mar 2010 11:08:37 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Alan Cox <alan@linux.intel.com>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] move tty_kref_put() outside of __cleanup_signal()
Message-ID: <20100319110837.267458d5@lxorguk.ukuu.org.uk>
In-Reply-To: <20100318231632.GA13591@redhat.com>
References: <20100318223736.GA12944@redhat.com>
	<20100318225102.6a5578d9@lxorguk.ukuu.org.uk>
	<20100318231632.GA13591@redhat.com>
X-Mailer: Claws Mail 3.7.4 (GTK+ 2.18.6; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This task is new, nobody can see/use it before we drop the locks. NULL or not,
> its signal->tty is just uninitialized yet.

Fair enough.

> 
> > > --- 34-rc1/kernel/exit.c~7_TTY_PUT	2010-03-17 20:05:38.000000000 +0100
> > > +++ 34-rc1/kernel/exit.c	2010-03-18 22:46:41.000000000 +0100
> > > @@ -150,6 +150,7 @@ static void __exit_signal(struct task_st
> > >  		 * see account_group_exec_runtime().
> > >  		 */
> > >  		task_rq_unlock_wait(tsk);
> > > +		tty_kref_put(sig->tty);
> >
> > and a sig->tty = NULL assignment to trap races might not go amiss here
> > perhaps ?
> 
> Indeed ;)
> 
> The subsequent patches will do this, we need more changes anyway. Currently
> this doesn't matter because we are going to kfree() this memory unconditionally.
> But when we pin ->signal to task_struct, we should clear ->signal->tty before
> we drop ->siglock, then tty_kref_put().

Ok - yes the moment you start refcounting ->signal that changes (or do you
expect to free ->tty when you destruct the signals ?)
