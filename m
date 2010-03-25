Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753170Ab0CYJy5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 05:54:57 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:54482 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752811Ab0CYJy4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 05:54:56 -0400
Subject: Re: [BUG] perf: hard lockup when using perf-sched
From: Peter Zijlstra <peterz@infradead.org>
To: Mike Galbraith <efault@gmx.de>
Cc: Li Zefan <lizf@cn.fujitsu.com>, LKML <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Paul Mackerras <paulus@samba.org>
In-Reply-To: <1269509241.8438.30.camel@marge.simson.net>
References: <4BA082EC.8030101@cn.fujitsu.com>
	 <4BA9A885.9050105@cn.fujitsu.com>
	 <1269415964.6530.25.camel@marge.simson.net>
	 <1269418671.6465.6.camel@marge.simson.net>
	 <4BAB1924.4060304@cn.fujitsu.com>
	 <1269509241.8438.30.camel@marge.simson.net>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 25 Mar 2010 10:54:52 +0100
Message-ID: <1269510892.12097.41.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-03-25 at 10:27 +0100, Mike Galbraith wrote:
> On Thu, 2010-03-25 at 16:04 +0800, Li Zefan wrote:
> > Mike Galbraith wrote:
> > > On Wed, 2010-03-24 at 08:32 +0100, Mike Galbraith wrote:
> > > 
> > >> I just saw this, hunted down your testcase and tried it here.  Looks
> > >> like perf_output_lock() wedged box.
> > > 
> > > (turns on frame pointers, and adds noinline)
> > > 
> > 
> > Thanks! Then who's going to fix this...
> 
> Well, that kinda depends on whether I figure out how the heck it's all
> supposed to work before somebody else whacks it or not.
> 
> ATM, I've instrumented, know _what's_ happening, but find myself saying
> "wtf?" a lot, especially wrt handle->locked.  The act of attempting to
> lock a handle declares it unlocked, turning perf_output_unlock() into a
> noop, which looks a bit strange.  We're spinning on those "unlocked"
> locks, all left genuinely locked by one CPU.  I just whacked the thing,
> and am very likely about to see in yet another trace.
> 
> Locking is hard, "curious construct" locking is even harder :)

Yeah, that perf_output_{un,}lock() stuff is a pain.. 

handle->locked should indicate if we're the outer most context

the problem this stuff is solving is that of publishing the data head
pointer, suppose two concurrent writers:

 head = 0;

 A: reserve N bytes
    write content
    commit

 B: reserve M bytes
    write content
    commit

Now, if B happens during A, and B completes before A is done, B's commit
would expose a head pointer of N+M bytes, even though the first N aren't
completely written yet.

So the trick is to only update the head pointer once everybody is done
writing. You can model this as a recursion problem and only update once
the recursion count hits 0 again.

However, with multiple cpus and NMIs and a busy enough environment this
never needs to happen, which would be bad, since we then cannot make
progress.

Hence the curious construct which basically serializes per cpu. Since
each cpu can only have a limited nesting context, and any one cpu is
bound to make progress (unless of course there is another bug that
prevents that) we'll post regular updates to the head pointer.



