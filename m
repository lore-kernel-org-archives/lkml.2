Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751605Ab2BQRnL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Feb 2012 12:43:11 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:51172 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751222Ab2BQRnJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Feb 2012 12:43:09 -0500
Date: Fri, 17 Feb 2012 09:43:04 -0800
From: Tejun Heo <tj@kernel.org>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: axboe@kernel.dk, ctalbott@google.com, rni@google.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/9] blkcg: drop unnecessary RCU locking
Message-ID: <20120217174304.GC29414@google.com>
References: <1329431878-28300-1-git-send-email-tj@kernel.org>
 <1329431878-28300-3-git-send-email-tj@kernel.org>
 <20120217164749.GC26620@redhat.com>
 <20120217171113.GB26575@google.com>
 <20120217172857.GD26620@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120217172857.GD26620@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Fri, Feb 17, 2012 at 12:28:57PM -0500, Vivek Goyal wrote:
> I am kind of confused that what are the semantics of calling
> blkg_lookup_create(). Given the fact that it traverses the
> blkcg->blkg_list which is rcu protected, so either we should have
> rcu read lock held or we should have blkcg->lock held.

Modifying blkgs require both blkcg and queue locks, so read access can
be done holding any lock.  Also, as modifications are done using RCU
safe oprations, it can be looked up while holding RCU read lock.

> > How?
> 
> Can pre_destroy() and blkio_policy_parse_and_set() make progress in
> parallel for same cgroup(blkcg) but different queue.
> 
> If yes, blkg_lookup() might be doing blkg->q == q check and pre_destroy
> might delete that group and free it up.

And that's why __blkg_release() is RCU free'ing blkgs, no?

Thanks.

-- 
tejun
