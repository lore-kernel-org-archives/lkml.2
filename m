Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755135Ab2BCT06 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Feb 2012 14:26:58 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:46479 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752177Ab2BCT05 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Feb 2012 14:26:57 -0500
Date: Fri, 3 Feb 2012 11:26:52 -0800
From: Tejun Heo <tj@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arjan van de Ven <arjan@linux.intel.com>, linux-kernel@vger.kernel.org
Subject: Re: + kmod-avoid-deadlock-by-recursive-kmod-call.patch added to
 -mm tree
Message-ID: <20120203192652.GA14209@google.com>
References: <20120126175612.GA24011@redhat.com>
 <87ipjxdfbg.fsf@rustcorp.com.au>
 <20120127143234.GA13056@redhat.com>
 <87y5srbaf7.fsf@rustcorp.com.au>
 <20120129163141.GC20803@redhat.com>
 <87aa56qedn.fsf@rustcorp.com.au>
 <20120130002511.GF17211@htj.dyndns.org>
 <20120130130335.GB11414@redhat.com>
 <20120130172851.GD3355@google.com>
 <20120203180030.GA8842@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120203180030.GA8842@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Oleg.

On Fri, Feb 03, 2012 at 07:00:30PM +0100, Oleg Nesterov wrote:
> > I've been trying to nudge people away from using special wqs or flags
> > unless really necessary.  Other than non-reentrancy and strict
> > ordering, all behaviors are mostly for optimization and using them
> > incorrectly / spuriously usually doesn't cause any visible failure,
> > making it very easy to get them wrong and if you have enough of wrong
> > / unnecessary usages in tree, the whole thing gets really confusing
> > and difficult to update in the future.
> 
> You know, I am a bit suprized. To me, it is the !WQ_UNBOUND case is
> "special". IOW, I think we need some reason to bind the work to the
> specific CPU.

It's part historical due to the way workqueue was originally
implemented and part because work items are expected to consume little
CPU cycles and access data which the issuer accessed, but the question
really isn't about whether unbound would be marginally better or not.
We may change the default behavior in the future as implementation
evolves or hardware environment changes and having more things which
claim special treatment without clear reason makes things needlessly
complicated, so the question to ask is whether the default behavior
doesn't fit enough that the extra flag is really required.

> > Blocking is completely fine on any workqueue.
> 
> I understand. But, the blocked worker "consumes" nr_active/worker.

If it's expected to consume high number of nr_active and needs
limiting, creating a dedicated wq as an isolation domain would be a
good idea.  It's not like wqs are expensive or complex to use after
all.

> > The only reason to
> > require the use of unbound_wq is if work items would burn a lot of CPU
> > cycles.  In such cases, we want to let the scheduler have full
> > jurisdiction instead of wq regulating concurrency.
> 
> I am starting to think I do not understand this code at all. OK,
> perhaps unbound_wq should be used for cpu-intensive works only.
> 
> But why do you think that we should use a !WQ_UNBOUND workque
> instead of khelper_wq? And why "a lot of CPU" is the only reason
> for WQ_UNBOUND?

As I wrote, it's not about "should use bound", it's about having
enough justification for deviating from the default.

Thanks.

-- 
tejun
