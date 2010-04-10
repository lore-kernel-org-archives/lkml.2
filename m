Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751835Ab0DJKoN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Apr 2010 06:44:13 -0400
Received: from ns.dcl.info.waseda.ac.jp ([133.9.216.194]:60590 "EHLO
	ns.dcl.info.waseda.ac.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750918Ab0DJKoJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Apr 2010 06:44:09 -0400
Message-ID: <4BC05677.7070406@dcl.info.waseda.ac.jp>
Date: Sat, 10 Apr 2010 19:44:07 +0900
From: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091211 Shredder/3.0
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Frederic Weisbecker <fweisbec@gmail.com>
CC: Paul Mackerras <paulus@samba.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Question about lock sequence
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

I found that my understand about lockdep is completely wrong :( ,
so state machine of perf lock should be fixed before optimization.

And I found that behaviour related to some of spin locks are strange.
The concrete example is lock sequences targeting dcache_lock (defined in
head of fs/dcache.c).

I made a little (and not essential) change to perf lock, and observe
lock sequence targeting it.
Changed perf lock shows sequence of locks in time order,
and I grepped the output of it with dcache, like this:

% sudo ./perf lock report | grep dcache

The head part of result is this:
# <name>-<pid> <time (in u64)> <action> <address of lockdep> <name of lock>
perf-3238 92430534170 acquire: 0xffffffff81a4b398 dcache_lock
perf-3238 92430536714 acquire: 0xffffffff81a4b398 dcache_lock
perf-3238 92431444481 acquire: 0xffffffff81a4b398 dcache_lock
perf-3238 92431446061 acquired: 0xffffffff81a4b398 dcache_lock
perf-3238 92431448157 acquire: 0xffffffff81a4b398 dcache_lock
perf-3238 92431449670 acquired: 0xffffffff81a4b398 dcache_lock
perf-3238 92432371136 acquire: 0xffffffff81a4b398 dcache_lock
perf-3238 92432372712 acquired: 0xffffffff81a4b398 dcache_lock
perf-3238 92432374718 acquire: 0xffffffff81a4b398 dcache_lock
perf-3238 92432376173 acquired: 0xffffffff81a4b398 dcache_lock
perf-3238 92433315563 acquire: 0xffffffff81a4b398 dcache_lock
perf-3238 92433317173 acquired: 0xffffffff81a4b398 dcache_lock

There are too many acquire and acquired without corresponding release
(or contended).
If dcache_lock is rwlock and these acquires mean read locks, this is not
so strange.
But, for me, this is a pattern of dead lock.
Of course perf lock finished its work, so there is no actual dead lock.

If you know something about this behaviour of lock, could you tell me?

Thanks,
	Hitoshi

