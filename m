Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751219Ab0DJPMM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Apr 2010 11:12:12 -0400
Received: from ns.dcl.info.waseda.ac.jp ([133.9.216.194]:62555 "EHLO
	ns.dcl.info.waseda.ac.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750744Ab0DJPMK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Apr 2010 11:12:10 -0400
Message-ID: <4BC09546.5050309@dcl.info.waseda.ac.jp>
Date: Sun, 11 Apr 2010 00:12:06 +0900
From: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.7) Gecko/20100111 Lightning/1.0b1 Thunderbird/3.0.1
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: Question about lock sequence
References: <4BC05677.7070406@dcl.info.waseda.ac.jp> <20100410130723.GA5204@nowhere>
In-Reply-To: <20100410130723.GA5204@nowhere>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/10/10 22:07, Frederic Weisbecker wrote:
 > On Sat, Apr 10, 2010 at 07:44:07PM +0900, Hitoshi Mitake wrote:
 >>
 >> Hi,
 >>
 >> I found that my understand about lockdep is completely wrong :( ,
 >> so state machine of perf lock should be fixed before optimization.
 >>
 >> And I found that behaviour related to some of spin locks are strange.
 >> The concrete example is lock sequences targeting dcache_lock (defined in
 >> head of fs/dcache.c).
 >>
 >> I made a little (and not essential) change to perf lock, and observe
 >> lock sequence targeting it.
 >> Changed perf lock shows sequence of locks in time order,
 >> and I grepped the output of it with dcache, like this:
 >>
 >> % sudo ./perf lock report | grep dcache
 >>
 >> The head part of result is this:
 >> #<name>-<pid>  <time (in u64)>  <action>  <address of lockdep> 
<name of lock>
 >> perf-3238 92430534170 acquire: 0xffffffff81a4b398 dcache_lock
 >> perf-3238 92430536714 acquire: 0xffffffff81a4b398 dcache_lock
 >> perf-3238 92431444481 acquire: 0xffffffff81a4b398 dcache_lock
 >> perf-3238 92431446061 acquired: 0xffffffff81a4b398 dcache_lock
 >> perf-3238 92431448157 acquire: 0xffffffff81a4b398 dcache_lock
 >> perf-3238 92431449670 acquired: 0xffffffff81a4b398 dcache_lock
 >> perf-3238 92432371136 acquire: 0xffffffff81a4b398 dcache_lock
 >> perf-3238 92432372712 acquired: 0xffffffff81a4b398 dcache_lock
 >> perf-3238 92432374718 acquire: 0xffffffff81a4b398 dcache_lock
 >> perf-3238 92432376173 acquired: 0xffffffff81a4b398 dcache_lock
 >> perf-3238 92433315563 acquire: 0xffffffff81a4b398 dcache_lock
 >> perf-3238 92433317173 acquired: 0xffffffff81a4b398 dcache_lock
 >>
 >> There are too many acquire and acquired without corresponding release
 >> (or contended).
 >> If dcache_lock is rwlock and these acquires mean read locks, this is not
 >> so strange.
 >> But, for me, this is a pattern of dead lock.
 >> Of course perf lock finished its work, so there is no actual dead lock.
 >>
 >> If you know something about this behaviour of lock, could you tell me?
 >
 >
 > If you can see nesting acquires on an rwlock, it's normal, because it can
 > be recursively acquired.
 >
 > What wouldn't be normal is an unbalanced stacking of acquire - release.
 >
 > If you see:
 >
 > acquire
 >   acquire
 >    acquire
 >
 > You should find the symetric releases:
 >
 >    release
 >   release
 > release

Yes. All acquire must have their corresponding release.
According to my result, some of ordinary spin locks
make the not symmetric pattern.


 >
 > Otherwise we have something wrong.

I'm considering it. But I cannot find something wrong now :(
There should be some cause...

 >
 > Also I wonder about the fact you seem to have acquire without acquired
 > in your trace.

Yeah, if acquire is trylock, it isn't strange.
But these acquires are not trylock.

 >
 > I'm going to look at this, hopefully I'll survive after looking in 
all these
 > rwlock_* _rwlock_* __rwlock_* arch_* raw* _raw* __raw* do_raw* mess... :)
 >
 >

Oh thanks :) I'll continue my quest the cause.
    Hitoshi
