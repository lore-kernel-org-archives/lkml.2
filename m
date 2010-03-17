Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751938Ab0CQBci (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 21:32:38 -0400
Received: from mail-bw0-f211.google.com ([209.85.218.211]:64741 "EHLO
	mail-bw0-f211.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751173Ab0CQBcg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 21:32:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=KB3/7vLznOfyj7LR1ZFCqmvCnXASyPiIueykqo6JOO3gLI7qY/hzyhFKmMbMjy4kqZ
         cx+r7N+l8TdQOoz4RW2yz84yoz/0SJVrr9ar5rWEbtOj6vrmEmeG//dJAPqZln5sEdnE
         Me8vuai4bSYEFTSwMwJbL4vYXvsSITV92gvlw=
Date: Wed, 17 Mar 2010 02:32:39 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>,
       linux-kernel@vger.kernel.org, h.mitake@gmail.com,
       Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Jens Axboe <jens.axboe@oracle.com>, Jason Baron <jbaron@redhat.com>
Subject: Re: [PATCH RFC 00/11] lock monitor: Separate features related to
	lock
Message-ID: <20100317013236.GB5258@nowhere>
References: <1268563128-6486-1-git-send-email-mitake@dcl.info.waseda.ac.jp> <1268590435.9440.8.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1268590435.9440.8.camel@laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 14, 2010 at 07:13:55PM +0100, Peter Zijlstra wrote:
> On Sun, 2010-03-14 at 19:38 +0900, Hitoshi Mitake wrote:
> > Current lockdep is too complicated because,
> >  * dependency validation
> >  * statistics
> >  * event tracing
> > are all implemented by it.
> > This cause problem of overhead.
> > If user enables one of them, overhead of rests part is not avoidable.
> > (tracing is exception. If user enables validation or stat,
> > overhead of tracing doesn't occur.)
> > 
> > So I suggest new subsystem "lock monitor".
> > This is a general purpose lock event hooking mechanism.
> > 
> > lock monitor will be enable easy implementing and running
> > these features related to lock.
> > 
> > And I'm hoping that lock monitor will reduce overhead of perf lock.
> > Because lock monitor separates dependency validation and event tracing clearly,
> > so calling of functions of lockdep (e.g. lock_acquire()) only for validation
> > will not occur lock events.
> > 
> > I implemented it on the branch perf/inject of Frederic's random-tracing tree.
> > Because the branch is hottest place of lock and tracing :)
> 
> OK, so I really don't like this much..
> 
> Building a lockstat kernel (PROVE_LOCKING=n) should not have much more
> overhead than the proposed solution, if the simple lock acquistion
> tracking bothers you, you can do a patch to weaken that.
> 
> I really really dislike how you add a monitor variable between
> everything for no reason what so ever.
> 
> You use a new rwlock_t, which is an instant fail, those things are worse
> than useless.
> 
> You add chained indirect calls into all lock ops, that's got to hurt.


Well, the idea was not bad at the first glance. It was separating
lockdep and lock events codes.

But indeed, the indirect calls plus the locking are not good
for such a fast path.

There is something else, it would be nice to keep the
lockdep_map -> lockdep_class mapping so that we can
do lock profiling based on classes too. So we actually
need the lockdep code. What we don't need is the prove
locking or the lock stats. So I guess we can have a new
config to enable lock events and get rid of the prove
locking / lock stat code if we don't need it.

