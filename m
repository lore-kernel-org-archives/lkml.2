Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751128Ab2FXERD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jun 2012 00:17:03 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:32833 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750776Ab2FXERA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jun 2012 00:17:00 -0400
Date: Sun, 24 Jun 2012 05:16:52 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        ". James Morris" <jmorris@namei.org>,
        linux-security-module@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: deferring __fput()
Message-ID: <20120624041652.GN14083@ZenIV.linux.org.uk>
References: <1340369098.2464.20.camel@falcor>
 <20120623092049.GH14083@ZenIV.linux.org.uk>
 <20120623194505.GI14083@ZenIV.linux.org.uk>
 <20120623203800.GA10306@redhat.com>
 <20120623210141.GK14083@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120623210141.GK14083@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 23, 2012 at 10:01:41PM +0100, Al Viro wrote:
> On Sat, Jun 23, 2012 at 10:38:00PM +0200, Oleg Nesterov wrote:
> 
> > > Matter of fact, it would become identical to struct rcu_head
> > > after that...
> > 
> > This is not clear to me... Why this is good?
> 
> Occam's Razor.
> 
> > I understand that sizeof(task_work) == sizeof(rcu_head) would be
> > nice, probably you meant just this?
> 
> More than that - the callback type is also the same (pointer to such
> struct -> void).  IOW, they both look like two instances of the
> same thing ("list of callbacks"), differing only in what and
> when does calling.

BTW, I suspect that we really want to move exit_task_work() down past the
calls of exit_mm()/exit_files() (and lose the PF_EXITING check in
task_work_add(), making that ordering responsibility of callers).  It's
not strictly necessary - we can just treat PF_EXITING the same way we
treat PF_KTHREAD, but that means driving those final fput on exit through
schedule_work().  Extra context switch...

I'm not 100% sure about that one - if you have planned task_work users
relying on e.g. task->mm still being there when callback runs, we obviously
can't go that way, but it would be nice to have.  AFAICS, existing users are
fine with such reordering.

We could, in principle, add a "ok_late" argument, allowing to add after
PF_EXITING has been set only if it's true and run the list twice, but
that's really more convoluted than I would like...

Comments?
