Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751652Ab0DJOBt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Apr 2010 10:01:49 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:47687 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751317Ab0DJOBr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Apr 2010 10:01:47 -0400
Subject: Re: Question about lock sequence
From: Peter Zijlstra <peterz@infradead.org>
To: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Paul Mackerras <paulus@samba.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>
In-Reply-To: <4BC05677.7070406@dcl.info.waseda.ac.jp>
References: <4BC05677.7070406@dcl.info.waseda.ac.jp>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Sat, 10 Apr 2010 16:01:51 +0200
Message-ID: <1270908111.4222.4.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-04-10 at 19:44 +0900, Hitoshi Mitake wrote:
> Hi,
> 
> I found that my understand about lockdep is completely wrong :( ,
> so state machine of perf lock should be fixed before optimization.
> 
> And I found that behaviour related to some of spin locks are strange.
> The concrete example is lock sequences targeting dcache_lock (defined in
> head of fs/dcache.c).
> 
> I made a little (and not essential) change to perf lock, and observe
> lock sequence targeting it.
> Changed perf lock shows sequence of locks in time order,
> and I grepped the output of it with dcache, like this:
> 
> % sudo ./perf lock report | grep dcache
> 
> The head part of result is this:
> # <name>-<pid> <time (in u64)> <action> <address of lockdep> <name of lock>
> perf-3238 92430534170 acquire: 0xffffffff81a4b398 dcache_lock
> perf-3238 92430536714 acquire: 0xffffffff81a4b398 dcache_lock
> perf-3238 92431444481 acquire: 0xffffffff81a4b398 dcache_lock
> perf-3238 92431446061 acquired: 0xffffffff81a4b398 dcache_lock
> perf-3238 92431448157 acquire: 0xffffffff81a4b398 dcache_lock
> perf-3238 92431449670 acquired: 0xffffffff81a4b398 dcache_lock
> perf-3238 92432371136 acquire: 0xffffffff81a4b398 dcache_lock
> perf-3238 92432372712 acquired: 0xffffffff81a4b398 dcache_lock
> perf-3238 92432374718 acquire: 0xffffffff81a4b398 dcache_lock
> perf-3238 92432376173 acquired: 0xffffffff81a4b398 dcache_lock
> perf-3238 92433315563 acquire: 0xffffffff81a4b398 dcache_lock
> perf-3238 92433317173 acquired: 0xffffffff81a4b398 dcache_lock
> 
> There are too many acquire and acquired without corresponding release
> (or contended).
> If dcache_lock is rwlock and these acquires mean read locks, this is not
> so strange.
> But, for me, this is a pattern of dead lock.
> Of course perf lock finished its work, so there is no actual dead lock.
> 
> If you know something about this behaviour of lock, could you tell me?

Well dcache_lock is a regular spinlock and there is only one of them, my
guess is that your timeline got messed up somehow.

Also, there doesn't appear to be a proper balance between acquires and
releases.


