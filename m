Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751265Ab0DJNHf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Apr 2010 09:07:35 -0400
Received: from mail-bw0-f209.google.com ([209.85.218.209]:55676 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750958Ab0DJNHd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Apr 2010 09:07:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=JnoPoL9CiCOppY+Pj0XtYNJ8eGwTgtGmmE99AxTU8+5LJp2XUgxquVgP0WeObwP6bC
         ilj1mvSi6UrwOMmJfzV3fzATLaa7neldh2bMDeOCPycXfjq48oRFEfvRV+S78emfjk8y
         6Kero5uAZ0+PchAw0P7bCve/HgoBAi5AHB9RI=
Date: Sat, 10 Apr 2010 15:07:26 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: Question about lock sequence
Message-ID: <20100410130723.GA5204@nowhere>
References: <4BC05677.7070406@dcl.info.waseda.ac.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BC05677.7070406@dcl.info.waseda.ac.jp>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 10, 2010 at 07:44:07PM +0900, Hitoshi Mitake wrote:
>
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


If you can see nesting acquires on an rwlock, it's normal, because it can
be recursively acquired.

What wouldn't be normal is an unbalanced stacking of acquire - release.

If you see:

acquire
 acquire
  acquire

You should find the symetric releases:

  release
 release
release

Otherwise we have something wrong.

Also I wonder about the fact you seem to have acquire without acquired
in your trace.

I'm going to look at this, hopefully I'll survive after looking in all these
rwlock_* _rwlock_* __rwlock_* arch_* raw* _raw* __raw* do_raw* mess... :)

