Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756072Ab2IJBKT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Sep 2012 21:10:19 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:53953 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753300Ab2IJBKR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Sep 2012 21:10:17 -0400
Date: Mon, 10 Sep 2012 02:10:15 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [signal] BUG: unable to handle kernel NULL pointer dereference
 at 0000000000000001
Message-ID: <20120910011015.GM13973@ZenIV.linux.org.uk>
References: <20120910004753.GB27699@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120910004753.GB27699@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 10, 2012 at 08:47:53AM +0800, Fengguang Wu wrote:
> Al,
> 
> Something bad happens since the below commit. Because commit [12/18] f411932
> was not tested, it might also be the first bad commit.

There's a damn good reason why the branch is called the way it's called ;-)
It's missing a lot of kernel_thread() stuff; I'm still not sure if it's
worth going that way, but there are some very attractive aspects.

Basically, if we had guaranteed that pt_regs instance on the bottom of the
stack will _not_ overlap anything for a kernel thread, we can move copying
pt_regs into kernel_execve() itself.  Which simplifies the hell out of
ret_from_kernel_execve() instances...

The price is that we need to leave that space aside for kernel threads.
It's not _that_ much and kernel threads are generally less stack-hungry
than the worst cases of syscalls (note that for userland process in the
middle of syscall that pt_regs instance *will* be there, no matter what).

FWIW, the plan for that branch is to do the following trick:
either split ret_from_kernel_thread away from ret_from_fork, setting the
right one to be used at copy_thread() time or make ret_from_fork itself
check if it's returning to kernel.  Either way, do *not* go through
return from syscall in return to kernel case; instead of that, have
ret_from_kernel_thread:
	schedule_tail();
	get the function to be called and its argument from regs and call it
	pass return value to do_exit() (BTW, I'm not at all sure we wouldn't
be better off if we took those do_exit() calls into 3--5 places in callbacks;
kernel_thread() is really very low-level and has few immediate callers).

Of course, such patches would have to go before the ret_from_kernel_execve()
ones.  Right now this branch is guaranteed to be broken; build testing does
make sense, but trying to boot it...  Not yet.
