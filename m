Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752259Ab1IFD3I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Sep 2011 23:29:08 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:56411 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751935Ab1IFD3C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Sep 2011 23:29:02 -0400
Date: Tue, 6 Sep 2011 12:28:55 +0900
From: Tejun Heo <tj@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: matthltc@us.ibm.com, rjw@sisk.pl, paul@paulmenage.org,
        containers@lists.linux-foundation.org,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/6] freezer: kill unused set_freezable_with_signal()
Message-ID: <20110906032846.GA18425@mtj.dyndns.org>
References: <1314988070-12244-1-git-send-email-tj@kernel.org>
 <1314988070-12244-7-git-send-email-tj@kernel.org>
 <20110904184626.GA30101@redhat.com>
 <20110905023315.GB9807@htj.dyndns.org>
 <20110905162012.GA4445@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110905162012.GA4445@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Mon, Sep 05, 2011 at 06:20:12PM +0200, Oleg Nesterov wrote:
> Perhaps it is correct... Just I do not understand what it should do.
> I thought it is "wait_for_event && do_not_block_freezer". And at first
> glance the code looks as if it tries to do this. Say, in the "likely"
> case we restart wait_event_interruptible() after refrigerator().
> 
> But this looks racy. Suppose that freezing() is already false when
> try_to_freeze() or __refrigerator() is called. Say, cgroup_freezer does
> freeze_task() + __thaw_task(). Why it returns -ERESTARTSYS in this case?

It may return -ERESTARTSYS when not strictly necessary but given that
it's supposed to trigger restart anyway I don't think it's actually
broken (it doesn't break the contract of the wait).  Another thing to
note is that kthread freezing via cgroup is almost fundamentally
broken.  With the removal of freezable_with_signal, this shouldn't be
an issue anymore although cgroup_freezer still needs to be fixed to
account for kthreads for xstate transitions (it currently triggers
BUG_ON).

> And if it can be used by the userspace thread, then we should probably
> do recalc_sigpending() somewhere, otherwise wait_event_freezable() will
> always return -ERESTARTSYS after __refrigerator().

Thankfully, currently, all the few users are kthreads.  I don't think
it makes sense for userland tasks at all.  Interruptible sleeps for
userland tasks necessiate the ability to return to signal delivery
path and restart or abort the current operation.  There's no point in
using wait_event_freezable() instead of wait_event_interruptible().

Thanks.

-- 
tejun
