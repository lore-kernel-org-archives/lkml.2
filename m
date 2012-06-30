Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753556Ab2F3Rny (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jun 2012 13:43:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40716 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752256Ab2F3Rnw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jun 2012 13:43:52 -0400
Date: Sat, 30 Jun 2012 19:41:33 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        ". James Morris" <jmorris@namei.org>,
        linux-security-module@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>,
        David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 0/4] Was: deferring __fput()
Message-ID: <20120630174133.GA23411@redhat.com>
References: <20120623210141.GK14083@ZenIV.linux.org.uk> <20120624041652.GN14083@ZenIV.linux.org.uk> <20120624153310.GB24596@redhat.com> <20120625060357.GT14083@ZenIV.linux.org.uk> <20120625151812.GA16062@redhat.com> <20120627183721.GA23086@redhat.com> <20120628043836.GW14083@ZenIV.linux.org.uk> <20120628162253.GA25357@redhat.com> <20120628164539.GA26350@redhat.com> <20120630062453.GA14083@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120630062453.GA14083@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/30, Al Viro wrote:
>
> On Thu, Jun 28, 2012 at 06:45:39PM +0200, Oleg Nesterov wrote:
> > Forgot to mention...
> >
> > And I still think that task_work_add() should not succeed unconditionally,
> > it synchronize with exit_task_work(). Otherwise keyctl_session_to_parent()
> > is broken.
>
> Hmm...  Look: if nothing else, we have
>         /* the parent mustn't be init and mustn't be a kernel thread */
>         if (parent->pid <= 1 || !parent->mm)
>                 goto unlock;
> in the caller.  OTOH, on the exit side we have exit_mm() done first.  And
> that will have ->mm set to NULL.  So we are closing a very narrow race to start
> with.  So why not do the following and be done with that?

Of course we can fix keyctl_session_to_parent(). But why? I mean, why
do you dislike the idea to put this synchronization into add/run ?

IMO, this makes task_work much less useful/convenient. Every caller
has to fight with this race somehow. And the lock it can take depends
on the context, say, you can't use task_lock() in irq.

IOW, what is wrong with

	[PATCH 2/4] task_work: don't rely on PF_EXITING
	http://marc.info/?l=linux-kernel&m=134082265321691

and
	[PATCH 3/4] task_work: deal with task_work callbacks adding more work
	http://marc.info/?t=134082275400004

?

perhaps you do not like the fact that the exiting task takes pi_lock
unconditionally?



and in fact I think that probably it makes sense to change fput,

	- task_work_add(current, ...);
	+ BUG_ON(task_work_add(current, ...) != 0);

Oleg.

