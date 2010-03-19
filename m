Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752280Ab0CSNLL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Mar 2010 09:11:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:24046 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751979Ab0CSNLH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Mar 2010 09:11:07 -0400
Date: Fri, 19 Mar 2010 14:09:32 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>, Alan Cox <alan@linux.intel.com>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] move tty_kref_put() outside of __cleanup_signal()
Message-ID: <20100319130932.GA19394@redhat.com>
References: <20100318223736.GA12944@redhat.com> <20100318225102.6a5578d9@lxorguk.ukuu.org.uk> <20100318231632.GA13591@redhat.com> <20100319110837.267458d5@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100319110837.267458d5@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/19, Alan Cox wrote:
>
> > > > --- 34-rc1/kernel/exit.c~7_TTY_PUT	2010-03-17 20:05:38.000000000 +0100
> > > > +++ 34-rc1/kernel/exit.c	2010-03-18 22:46:41.000000000 +0100
> > > > @@ -150,6 +150,7 @@ static void __exit_signal(struct task_st
> > > >  		 * see account_group_exec_runtime().
> > > >  		 */
> > > >  		task_rq_unlock_wait(tsk);
> > > > +		tty_kref_put(sig->tty);
> > >
> > > and a sig->tty = NULL assignment to trap races might not go amiss here
> > > perhaps ?
> >
> > Indeed ;)
> >
> > The subsequent patches will do this, we need more changes anyway. Currently
> > this doesn't matter because we are going to kfree() this memory unconditionally.
> > But when we pin ->signal to task_struct, we should clear ->signal->tty before
> > we drop ->siglock, then tty_kref_put().
>
> Ok - yes the moment you start refcounting ->signal that changes (or do you
> expect to free ->tty when you destruct the signals ?)

I think signal->tty should be freed (and nullified under ->siglock) when the
last thread exits.

The goal is to make ->signal immutable, so that it would be always safe to
dereference task->signal if you have a reference to task_struct. But I don't
think get_task_struct() should defer tty_kref_put(), and besides put_task_struct()
must be safe in any context.

See also http://marc.info/?l=linux-kernel&m=126885423426183

Oleg.

