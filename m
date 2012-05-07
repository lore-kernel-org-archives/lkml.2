Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757539Ab2EGRTY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 13:19:24 -0400
Received: from mail-pz0-f51.google.com ([209.85.210.51]:43474 "EHLO
	mail-pz0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757467Ab2EGRTW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 13:19:22 -0400
Date: Mon, 7 May 2012 10:19:09 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Tejun Heo <tj@kernel.org>
cc: Stephen Boyd <sboyd@codeaurora.org>, Yong Zhang <yong.zhang0@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: linux-next oops in __lock_acquire for process_one_work
Message-ID: <alpine.LSU.2.00.1205070951170.1544@eggly.anvils>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tejun,

Running MM load on recent linux-nexts (e.g. 3.4.0-rc5-next-20120504),
with CONFIG_PROVE_LOCKING=y, I've been hitting an oops in __lock_acquire
called from lock_acquire called from process_one_work: serving mm/swap.c's
lru_add_drain_all - schedule_on_each_cpu(lru_add_drain_per_cpu).

In each case the oopsing address has been ffffffff00000198, and the
oopsing instruction is the "atomic_inc((atomic_t *)&class->ops)" in
__lock_acquire: so class is ffffffff00000000.

I notice Stephen's commit 0976dfc1d0cd80a4e9dfaf87bd8744612bde475a
workqueue: Catch more locking problems with flush_work()
in linux-next but not 3.4-rc, adding
	lock_map_acquire(&work->lockdep_map);
	lock_map_release(&work->lockdep_map);
to flush_work.

I believe that occasionally races with your
	struct lockdep_map lockdep_map = work->lockdep_map;
in process_one_work, putting an entry into the class_cache
just as you're copying it, so you end up with half a pointer.
yes, the structure copy is using "rep movsl" not "rep movsq".

I've reverted Stephen's commit from my testing, and indeed it's
now run that MM load much longer than I've seen since this bug
first appeared.  Though I suspect that strictly it's your
unlocked copying of the lockdep_map that's to blame.  Probably
easily fixed by someone who understands lockdep - not me!

Hugh
