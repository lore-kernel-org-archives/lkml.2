Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756328Ab2FYMOv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 08:14:51 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:52545 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755638Ab2FYMOt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 08:14:49 -0400
Date: Mon, 25 Jun 2012 13:14:36 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        ". James Morris" <jmorris@namei.org>,
        linux-security-module@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Oleg Nesterov <oleg@redhat.com>, David Miller <davem@davemloft.net>
Subject: Re: deferring __fput()
Message-ID: <20120625121436.GU14083@ZenIV.linux.org.uk>
References: <1340369098.2464.20.camel@falcor>
 <20120623092049.GH14083@ZenIV.linux.org.uk>
 <20120623194505.GI14083@ZenIV.linux.org.uk>
 <20120623205755.GJ14083@ZenIV.linux.org.uk>
 <1340625805.2507.56.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1340625805.2507.56.camel@laptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 25, 2012 at 02:03:25PM +0200, Peter Zijlstra wrote:
> On Sat, 2012-06-23 at 21:57 +0100, Al Viro wrote:
> > 3) at that point task_work is equal in size (and layout, BTW) to rcu_head.  So we can add it
> > into the same union in struct file where we already have list_head and rcu_head.  No space
> > eaten up.  fput() would, once the counter reaches 0, remove the file from list (the only
> > place walking that list skips the ones with zero refcount anyway) and, if we are in a normal
> > process, use task_work_add() to have __fput() done to it.  If we are in kernel thread or
> > atomic context, just move the sucker to global list and use schedule_work() to have said
> > list emptied and everything in it fed to __fput(). 
> 
> So we're now Ok with doing fput() async?
> 
> Last time I remember this coming up people thought this wasn't such a
> hot idea.

You mean, doing that from RCU callbacks?  Still a bad idea, IMO; you will end up with a context
switch and unpleasantness with delayed user-visible effects of syscalls.  With aio we did have
a delayed execution of fput() anyway; all that has changed there is that we use generic
mechanism instead of home-grown analog thereof.

I'll need to reread that thread to comment on the specifics (had been too long ago; I don't
remember the details), but...  See Linus' objections to full-async fput() circa this April
or March.  There's a reason why this patchset uses task_work_add() whenever possible.
