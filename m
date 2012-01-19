Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757396Ab2ASKHi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jan 2012 05:07:38 -0500
Received: from mx1.redhat.com ([209.132.183.28]:62347 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757135Ab2ASKHg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jan 2012 05:07:36 -0500
Date: Thu, 19 Jan 2012 05:07:29 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: axboe@kernel.dk, ctalbott@google.com, rni@google.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/12] blkcg: obtaining blkg should be enclosed inside
 rcu_read_lock()
Message-ID: <20120119100729.GA2649@redhat.com>
References: <1326935490-11827-1-git-send-email-tj@kernel.org>
 <1326935490-11827-2-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1326935490-11827-2-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 18, 2012 at 05:11:19PM -0800, Tejun Heo wrote:
> When looking up or creating blkg's, both blk-throttle and cfq-iosched
> drops rcu_read_lock() right after lookup is complete.  This isn't
> safe.  Refcnt isn't incremented at that point and rcu lock is the only
> thing holding the blkg.  It shouldn't be dropped until after refcnt is
> incremented by the caller.

Hi Tejun,

throtl_get_tg() and cfq_get_cfqg() are called with queue lock held and
tg and cfqg are protected by queue lock as they can not go away as long
as queue lock is held.

If the group is already created, then caller accesses it under queue
lock and does not pass the pointer around. In case of throttling, caller
can use it under rcu also just to do update of stats (when there are
no rules).

I had used rcu read lock to access blkcg pointer here. That's why when
we are done with accessing blkcg, we drop rcu read lock and return back
to caller with group pointer, which is aready holding either a queue
lock or rcu read lock to protect returned group pointer.

So if we are protecting blkcg using rcu, then it should make sense to
take that lock inside throtl_get_tg() and cfq_get_cfqg() respectively and
it should not be left to the caller?

Thanks
Vivek
