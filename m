Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752746Ab1JZUzD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Oct 2011 16:55:03 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:48303 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752584Ab1JZUzA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Oct 2011 16:55:00 -0400
Date: Wed, 26 Oct 2011 13:54:55 -0700
From: Tejun Heo <tj@kernel.org>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: axboe@kernel.dk, ctalbott@google.com, rni@google.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 10/13] block, cfq: unlink cfq_io_context's immediately
Message-ID: <20111026205455.GG24261@google.com>
References: <1319593719-19132-1-git-send-email-tj@kernel.org>
 <1319593719-19132-11-git-send-email-tj@kernel.org>
 <20111026194857.GF355@redhat.com>
 <20111026195506.GD24261@google.com>
 <20111026203846.GG355@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111026203846.GG355@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Vivek.

On Wed, Oct 26, 2011 at 04:38:46PM -0400, Vivek Goyal wrote:
> So the only reason that cic needs to be rcu protected because in
> cfq_cic_lookup() we can access ioc->ioc_data which can point to a 
> cic which is not ours and we are not holding queue lock for that and
> we can't access cic->q ?

About right but to be more exact.

* Indexes from ioc are protected by ioc->lock - both the radix tree
  and hint.  Both are RCU managed.

* cic structures themselves are protected by cic->q->queue_lock and
  RCU managed.

* Additions and removals are done holding both ioc and q locks.

* Lookup is performed with RCU read locked and q->queue_lock held.
  Indexes and cic's themselves are RCU protected so can be traversed
  and cic can be dereferenced even if it's pointing to a different
  queue (and thus protected under different queue_lock).

  However, cic's pointing to the q which is being looked up can be
  added only under the same queue_lock, so on "cic->q == q" we're
  guaranteed to be looking at the right thing.

> I am wondering if there should be a small text file explaining all
> the locking in this area.

Oh, I'm gonna be restructuring ioc interface and adding ample
explanations on locking rules there.

Thanks.

-- 
tejun
