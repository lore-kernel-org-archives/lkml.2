Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755386Ab1KIIH2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 03:07:28 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:49636 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751334Ab1KIIH1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 03:07:27 -0500
Date: Wed, 9 Nov 2011 16:07:14 +0800
From: Yong Zhang <yong.zhang0@gmail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Vegard Nossum <vegard.nossum@gmail.com>, linux-kernel@vger.kernel.org,
        sergey.senozhatsky@gmail.com, bp@alien8.de,
        Ingo Molnar <mingo@elte.hu>, Tejun Heo <tj@kernel.org>,
        David Rientjes <rientjes@google.com>, casteyde.christian@free.fr,
        Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
Subject: [PATCH 2/2] lockdep: always try to set ->class_cache in
 register_lock_class() lockdep_init_map()
Message-ID: <20111109080714.GC8124@zhy>
Reply-To: Yong Zhang <yong.zhang0@gmail.com>
References: <1320669279.18053.29.camel@twins>
 <CAOMGZ=EC0eHahfHy2K=5HwBwOCWEdF6u-mDaeLhb4GQVKVxLLA@mail.gmail.com>
 <1320682230.17809.11.camel@twins>
 <20111108025847.GB11439@zhy>
 <1320739015.2244.0.camel@twins>
 <20111108081433.GA3746@zhy>
 <1320741980.2244.4.camel@twins>
 <20111108090735.GA4038@zhy>
 <1320745246.2244.12.camel@twins>
 <20111109080451.GB8124@zhy>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20111109080451.GB8124@zhy>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yong Zhang <yong.zhang0@gmail.com>

commit [62016250 lockdep: Add improved subclass caching] try to
improve performance (expecially to reduce the cost of rq->lock)
when using lockdep, but it fails due to lockdep_init_map() in
which ->class_cache is cleared. The typical caller is
lock_set_subclass(), after that class will not be cached anymore.

This patch try to achive the goal of commit 62016250 by always
setting ->class_cache in register_lock_class().

=== Score comparison of benchmarks ===

for i in `seq 1 10`; do ./perf bench -f simple sched messaging; done

before:  min: 0.604, max: 0.660, avg: 0.622
after:   min: 0.414, max: 0.473, avg: 0.427

for i in `seq 1 10`; do ./perf bench -f simple sched messaging -g 40; done

before:  min: 2.347, max: 2.421, avg: 2.391
after:   min: 1.652, max: 1.699, avg: 1.671

Signed-off-by: Yong Zhang <yong.zhang0@gmail.com>
Cc: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>
---
 kernel/lockdep.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/kernel/lockdep.c b/kernel/lockdep.c
index 21ea1dc..e9cbb99 100644
--- a/kernel/lockdep.c
+++ b/kernel/lockdep.c
@@ -722,7 +722,7 @@ register_lock_class(struct lockdep_map *lock, unsigned int subclass, int force)
 
 	class = look_up_lock_class(lock, subclass);
 	if (likely(class))
-		return class;
+		goto out_set_class_cache;
 
 	/*
 	 * Debug-check: all keys must be persistent!
@@ -807,6 +807,7 @@ out_unlock_set:
 	graph_unlock();
 	raw_local_irq_restore(flags);
 
+out_set_class_cache:
 	if (!subclass || force)
 		lock->class_cache[0] = class;
 	else if (subclass < NR_LOCKDEP_CACHING_CLASSES)
-- 
1.7.5.4

