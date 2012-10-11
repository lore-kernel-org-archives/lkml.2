Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758395Ab2JKMxO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 08:53:14 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:58086 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756082Ab2JKMxM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 08:53:12 -0400
Date: Thu, 11 Oct 2012 13:53:06 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Paul Mackerras <paulus@samba.org>
Cc: linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-arch@vger.kernel.org, David Miller <davem@davemloft.net>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [RFC][CFT][CFReview] execve and kernel_thread unification work
Message-ID: <20121011125306.GF2616@ZenIV.linux.org.uk>
References: <20121001213809.GA31155@ZenIV.linux.org.uk>
 <20121011090023.GA28427@bloggs.ozlabs.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121011090023.GA28427@bloggs.ozlabs.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 11, 2012 at 08:00:23PM +1100, Paul Mackerras wrote:
> I just looked through the "powerpc: split ret_from_fork" commit in
> your for-next branch, and I have a couple of comments.
> 
> First, on 64-bit powerpc, if kernel_thread() is called on a function
> in a module, and that function returns, we'll then jump to do_exit
> with r2 pointing to the module's TOC rather than the main kernel's
> TOC, with disastrous results.  It would be easily solved by adding a
> 
> 	ld	r2,PACATOC(r13)
> 
> before the branch to .do_exit in the 64-bit ret_from_kernel_thread().
> Maybe no-one ever calls kernel_thread() on a function in a module
> today, but I don't want to rely on that being true forever, especially
> since it's only one more instruction to guard against the possibility.

It's unexported, and for a good reason.  So no, there won't be any callers
in modules.  The good reasons in question:
	* it's trivial to convert any such caller to kthread_run() and
kthread.h in general
	* there are only ~7 callers in the mainline, all but one in
{init,kernel}/*.c.  Said exception is in arch/powerpc, also non-modular
and there conversion is simply
-       set_task_comm(current, "eehd");
in eeh_event_handler,
-       if (kernel_thread(eeh_event_handler, NULL, CLONE_KERNEL) < 0)
+       if (IS_ERR(kthread_run(eeh_event_handler, NULL, "eehd")))
in eeh_thread_launcher, plus adding #include <linux/kthread.h>.
All there is to it.
	* life is going to become much simpler if we change kernel_thread()
callback semantics (while leaving kthread.h and kmod.h behaviour intact)
and I'm going to do that later in the series.  This call of do_exit() is
going away, to start with - from any asm glue.  Better have it done in
kernel/kmod.c - all it takes is a couple of lines in there, everything
else already never returns, either by looping forever or by successful
execve(2) or by exit(2) (or panic(), in one case).  Again, I'm talking about
kernel_thread() callbacks - kthread.h ones already have do_exit() done by
their caller (which is a kernel_thread() callback in kernel/kthread.c).
And then we can do even better - check signal.git#experimental-kernel_thread
and you'll see.

IOW, being able to treat that as internal low-level mechanism rather than
any kind of stable API for modules is a very good thing.

> Secondly, while the code as you have it is correct, to my mind it
> would be cleaner to put the function descriptor address in r14 on
> 64-bit, rather than the function text address, and then dereference it
> to get the TOC and text address at the point of doing the call.  That
> would reduce the differences between 32-bit and 64-bit in
> copy_thread() and make it more obvious that ret_from_kernel_thread()
> is setting the right TOC value in r2.

	Umm...  Maybe, but let's do that as subsequent cleanup.  Again,
we almost certainly don't need to mess with TOC at all - the callbacks
are in the main kernel, there are very few of them and they really are
low-level details of exported mechanisms (i.e. kthread_create/run/etc.
in kthread.h and call_usermode... in kmod.h).  Again, we are talking
about out-of-tree modules, they had better mechanism for at least
6 years and conversion to it is bloody trivial.  Hell, it was even
in late unlamented feature-removal-schedule.txt - since 2006.  If that's
not enough to retire an export, what is?
