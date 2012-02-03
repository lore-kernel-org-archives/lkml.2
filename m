Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757361Ab2BCSHJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Feb 2012 13:07:09 -0500
Received: from mx1.redhat.com ([209.132.183.28]:43308 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754112Ab2BCSHH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Feb 2012 13:07:07 -0500
Date: Fri, 3 Feb 2012 19:00:30 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arjan van de Ven <arjan@linux.intel.com>, linux-kernel@vger.kernel.org
Subject: Re: + kmod-avoid-deadlock-by-recursive-kmod-call.patch added to
	-mm tree
Message-ID: <20120203180030.GA8842@redhat.com>
References: <20120126175612.GA24011@redhat.com> <87ipjxdfbg.fsf@rustcorp.com.au> <20120127143234.GA13056@redhat.com> <87y5srbaf7.fsf@rustcorp.com.au> <20120129163141.GC20803@redhat.com> <87aa56qedn.fsf@rustcorp.com.au> <20120130002511.GF17211@htj.dyndns.org> <20120130130335.GB11414@redhat.com> <20120130172851.GD3355@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120130172851.GD3355@google.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tejun,

On 01/30, Tejun Heo wrote:
>
> On Mon, Jan 30, 2012 at 02:03:35PM +0100, Oleg Nesterov wrote:
> > Perhaps we can use another system_wq, but afaics WQ_UNBOUND makes sense
> > in this case. I mean, there is no reason to bind this work to any CPU.
> > See also below.
>
> I've been trying to nudge people away from using special wqs or flags
> unless really necessary.  Other than non-reentrancy and strict
> ordering, all behaviors are mostly for optimization and using them
> incorrectly / spuriously usually doesn't cause any visible failure,
> making it very easy to get them wrong and if you have enough of wrong
> / unnecessary usages in tree, the whole thing gets really confusing
> and difficult to update in the future.

You know, I am a bit suprized. To me, it is the !WQ_UNBOUND case is
"special". IOW, I think we need some reason to bind the work to the
specific CPU.

> > > Is it expected consume large
> > > amount of CPU cycles?
> >
> > Currently __call_usermodehelper() does kernel_thread(), this is almost
> > all. But it can block waiting for kernel_execve().
>
> Blocking is completely fine on any workqueue.

I understand. But, the blocked worker "consumes" nr_active/worker.

> The only reason to
> require the use of unbound_wq is if work items would burn a lot of CPU
> cycles.  In such cases, we want to let the scheduler have full
> jurisdiction instead of wq regulating concurrency.

I am starting to think I do not understand this code at all. OK,
perhaps unbound_wq should be used for cpu-intensive works only.

But why do you think that we should use a !WQ_UNBOUND workque
instead of khelper_wq? And why "a lot of CPU" is the only reason
for WQ_UNBOUND?

> * If work items are expected to consume large amount of CPU cycles (as
>   in crypto work items), consider using system_unbound_wq / WQ_UNBOUND.
>
> * If per-domain concurrency limit is necessary (ie. the number of
>   concurrent work items doing this particular task should be limited
>   rather than consuming global system_wq limit), a dedicated workqueue
>   would be better.

So I don't understand whether you like the idea to kill khelper_wq
and use some system_ wq or not (and fix the bug).

I do not really like the current patch. If nothing else, what if
UMH_WAIT_EXEC request actually needs another UMH_WAIT_EXEC/PROC
request to succeed?

Tetsuo, we spent a lot of time discussing other problems. What
do you think about s/khelper/system/ instead of this patch?

Oleg.

