Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755762Ab2FXKJc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jun 2012 06:09:32 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:43006 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755634Ab2FXKJR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jun 2012 06:09:17 -0400
Date: Sun, 24 Jun 2012 11:09:08 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        ". James Morris" <jmorris@namei.org>,
        linux-security-module@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: deferring __fput()
Message-ID: <20120624100908.GR14083@ZenIV.linux.org.uk>
References: <1340369098.2464.20.camel@falcor>
 <20120623092049.GH14083@ZenIV.linux.org.uk>
 <20120623194505.GI14083@ZenIV.linux.org.uk>
 <20120623203800.GA10306@redhat.com>
 <20120623210141.GK14083@ZenIV.linux.org.uk>
 <20120624041652.GN14083@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120624041652.GN14083@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 24, 2012 at 05:16:52AM +0100, Al Viro wrote:
> We could, in principle, add a "ok_late" argument, allowing to add after
> PF_EXITING has been set only if it's true and run the list twice, but
> that's really more convoluted than I would like...
> 
> Comments?

OK...  What I had in mind is (modulo really dire need of saner commit messages
and probably a different ordering/splitup of the first 3 commits) is
in vfs.git#untested.  WARNING: the branch name is no joke; it builds, but
I hadn't even tried to boot the resulting kernel yet.

Comments would be very welcome.  It should get us the situation when
	* __fput() is always called with no locks held by caller and
can take any locks whatsoever.
	* fput() is legal to call from any contexts
	* fput() done by a syscall will be completed before the process
returns to userland or terminates
	* no extra context switches, unless we have the final fput() done
from interrupt (instant death on the current kernel) or from the
kernel thread.
	* SCM_RIGHTS datagram destruction should be no worse than it is now;
probably a bit kinder on stack, even...  Again, no extra context switches.
	* Neither struct file nor struct task_struct changed size.
	* task_work and rcu_head are identical at that point; I'd appreciate
a better name (I ended up calling that sucker callback_head, defined in
types.h, with #define rcu_head callback_head next to it, to avoid global
rename from hell).  I can live with two identical structs (and a union
of those two in a few places), but I really see no point in going that way.
