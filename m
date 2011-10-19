Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757168Ab1JSRa7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Oct 2011 13:30:59 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:47141 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755300Ab1JSRa6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Oct 2011 13:30:58 -0400
Date: Wed, 19 Oct 2011 10:30:53 -0700
From: Tejun Heo <tj@kernel.org>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: axboe@kernel.dk, linux-kernel@vger.kernel.org, ctalbott@google.com
Subject: Re: [PATCH 07/10] block: reorganize throtl_get_tg() and
 blk_throtl_bio()
Message-ID: <20111019173053.GG25124@google.com>
References: <1318998384-22525-1-git-send-email-tj@kernel.org>
 <1318998384-22525-8-git-send-email-tj@kernel.org>
 <20111019145622.GE1140@redhat.com>
 <20111019170625.GD25124@google.com>
 <20111019171917.GA4026@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111019171917.GA4026@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Wed, Oct 19, 2011 at 01:19:17PM -0400, Vivek Goyal wrote:
> > Currently, the code has different opportunistic checks which can catch
> > most of those cases but unfortunatly I think it just makes the bugs
> > more obscure.
> > 
> > That said, we probably should be switching to internal lock once
> > clenaup is complete.
> 
> So even switching to internal lock is racy. Christoph suggeted to break down
> this sharing of queue lock and driver lock and suggested always use
> internal queue lock and modify drivers to use their own lock and manage it.
> It makes sense though it might be lot of work to fix drivers.

Hmmmm, yeah, right, switching itself would be racy.  Maybe not sharing
is the solution, I don't know.  There's a way to make the switching
safe tho.  Sth like the following.

	lock_queue(q, flags)
	{
		spinlock_t *lock;

		local_irq_save(flags);
		lock = rcu_dereference_sched(q->queue_lock);
		spin_lock(lock);
	}

and on cleanup, do synchronize_sched() after lock switching.  But yeah
it still stinks.

Thanks.

-- 
tejun
