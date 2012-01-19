Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756549Ab2ASPjp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jan 2012 10:39:45 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:61900 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753248Ab2ASPjo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jan 2012 10:39:44 -0500
Date: Thu, 19 Jan 2012 07:39:38 -0800
From: Tejun Heo <tj@kernel.org>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: axboe@kernel.dk, ctalbott@google.com, rni@google.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/12] blkcg: obtaining blkg should be enclosed inside
 rcu_read_lock()
Message-ID: <20120119153938.GA5198@google.com>
References: <1326935490-11827-1-git-send-email-tj@kernel.org>
 <1326935490-11827-2-git-send-email-tj@kernel.org>
 <20120119100729.GA2649@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120119100729.GA2649@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Vivek.

On Thu, Jan 19, 2012 at 05:07:29AM -0500, Vivek Goyal wrote:
> On Wed, Jan 18, 2012 at 05:11:19PM -0800, Tejun Heo wrote:
> > When looking up or creating blkg's, both blk-throttle and cfq-iosched
> > drops rcu_read_lock() right after lookup is complete.  This isn't
> > safe.  Refcnt isn't incremented at that point and rcu lock is the only
> > thing holding the blkg.  It shouldn't be dropped until after refcnt is
> > incremented by the caller.
> 
> throtl_get_tg() and cfq_get_cfqg() are called with queue lock held and
> tg and cfqg are protected by queue lock as they can not go away as long
> as queue lock is held.

Ah, right.

> I had used rcu read lock to access blkcg pointer here. That's why when
> we are done with accessing blkcg, we drop rcu read lock and return back
> to caller with group pointer, which is aready holding either a queue
> lock or rcu read lock to protect returned group pointer.
>
> So if we are protecting blkcg using rcu, then it should make sense to
> take that lock inside throtl_get_tg() and cfq_get_cfqg() respectively and
> it should not be left to the caller?

No, no matter whatever synchronization scheme is in use, the code is
seriously screwed up if it's doing something like,

	lock();
	a = lookup();
	unlock();
	return a;

You should *NEVER* be doing that.  It can't serve any purpose and is
misleading at best.  In this case, the right thing to do is dropping
the rcu read locking and using annotated rcu deferencing macros to
enforce q locked || rcu read locked.  I'll update the patch.

Thanks.

-- 
tejun
