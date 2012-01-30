Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752887Ab2A3R25 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 12:28:57 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:35148 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752325Ab2A3R24 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 12:28:56 -0500
Date: Mon, 30 Jan 2012 09:28:51 -0800
From: Tejun Heo <tj@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arjan van de Ven <arjan@linux.intel.com>, linux-kernel@vger.kernel.org
Subject: Re: + kmod-avoid-deadlock-by-recursive-kmod-call.patch added to
 -mm tree
Message-ID: <20120130172851.GD3355@google.com>
References: <20120126175612.GA24011@redhat.com>
 <87ipjxdfbg.fsf@rustcorp.com.au>
 <20120127143234.GA13056@redhat.com>
 <87y5srbaf7.fsf@rustcorp.com.au>
 <20120129163141.GC20803@redhat.com>
 <87aa56qedn.fsf@rustcorp.com.au>
 <20120130002511.GF17211@htj.dyndns.org>
 <20120130130335.GB11414@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120130130335.GB11414@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Mon, Jan 30, 2012 at 02:03:35PM +0100, Oleg Nesterov wrote:
> Perhaps we can use another system_wq, but afaics WQ_UNBOUND makes sense
> in this case. I mean, there is no reason to bind this work to any CPU.
> See also below.

I've been trying to nudge people away from using special wqs or flags
unless really necessary.  Other than non-reentrancy and strict
ordering, all behaviors are mostly for optimization and using them
incorrectly / spuriously usually doesn't cause any visible failure,
making it very easy to get them wrong and if you have enough of wrong
/ unnecessary usages in tree, the whole thing gets really confusing
and difficult to update in the future.

> > Is it expected consume large
> > amount of CPU cycles?
> 
> Currently __call_usermodehelper() does kernel_thread(), this is almost
> all. But it can block waiting for kernel_execve().

Blocking is completely fine on any workqueue.  The only reason to
require the use of unbound_wq is if work items would burn a lot of CPU
cycles.  In such cases, we want to let the scheduler have full
jurisdiction instead of wq regulating concurrency.

> Not sure this really makes sense, but if we kill khelper_wq perhaps we
> can simplify this code a bit. We can change __call_usermodehelper()
> 
> 		if (wait == UMH_WAIT_PROC)
> 	-		pid = kernel_thread(wait_for_helper, sub_info,
> 	-				    CLONE_FS | CLONE_FILES | SIGCHLD);
> 	+		wait_for_helper(...);
> 		else
> 
> IOW, the worker thread itself can do the UMH_WAIT_PROC work. This makes
> this work really "long running", but then we can kill sub_info->complete
> and use flush_work().

Again, long-running in the sense that the work item spending a lot of
time sleeping should be fine on system_wq or any other wq with default
attributes.  AFAICS, the things to consider here are...

* If work items are expected to consume large amount of CPU cycles (as
  in crypto work items), consider using system_unbound_wq / WQ_UNBOUND.

* If per-domain concurrency limit is necessary (ie. the number of
  concurrent work items doing this particular task should be limited
  rather than consuming global system_wq limit), a dedicated workqueue
  would be better.

Thanks.

-- 
tejun
