Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760958Ab2EIUJs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 16:09:48 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:62237 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756923Ab2EIUJr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 16:09:47 -0400
Date: Wed, 9 May 2012 13:09:27 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Ingo Molnar <mingo@kernel.org>
cc: Peter Zijlstra <peterz@infradead.org>, Tejun Heo <tj@kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Stephen Boyd <sboyd@codeaurora.org>,
        Yong Zhang <yong.zhang0@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: linux-next oops in __lock_acquire for process_one_work
In-Reply-To: <20120509092536.GC8585@gmail.com>
Message-ID: <alpine.LSU.2.00.1205091219590.20881@eggly.anvils>
References: <alpine.LSU.2.00.1205070951170.1544@eggly.anvils> <20120507175743.GC19417@google.com> <1336482202.16236.29.camel@twins> <20120508165819.GB10687@google.com> <alpine.LSU.2.00.1205081106160.4071@eggly.anvils> <1336516260.8226.61.camel@twins>
 <alpine.LSU.2.00.1205081553250.4497@eggly.anvils> <20120509092536.GC8585@gmail.com>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 9 May 2012, Ingo Molnar wrote:
> * Hugh Dickins <hughd@google.com> wrote:
> 
> > I'll set it going when I get home later - thanks.

Going fine so far, but a more convincing final report tomorrow.

> 
> Do we still need an explanation about why it's needed and why it 
> makes a difference?

I don't see the difficulty in understanding it.  Peter didn't comment
whether my further explanations convinced him or not.  Or perhaps you're
asking for some commit description text - I may not be the right person to
write it, since I didn't make myself understood very well, but here's a go.

lockdep: fix oops in processing workqueue

Under memory load, on x86_64, with lockdep enabled, the workqueue's
process_one_work() has been seen to oops in __lock_acquire(), barfing
on a 0xffffffff00000000 pointer in the lockdep_map's class_cache[].

Because it's permissible to free a work_struct from its callout function,
the map used is an onstack copy of the map given in the work_struct: and
that copy is made without any locking.

Surprisingly, gcc (4.5.1 in Hugh's case) uses "rep movsl" rather than
"rep movsq" for that structure copy: which might race with a workqueue
user's wait_on_work() doing lock_map_acquire() on the source of the
copy, putting a pointer into the class_cache[], but only in time for
the top half of that pointer to be copied to the destination map.

Boom when process_one_work() subsequently does lock_map_acquire()
on its onstack copy of the lockdep_map.

Fix this, and a similar instance in call_timer_fn(), with a
lockdep_copy_map() function which additionally NULLs the class_cache[].

Note: this oops was actually seen on 3.4-next, where flush_work() newly
does the racing lock_map_acquire(); but Tejun points out that 3.4 and
earlier are already vulnerable to the same through wait_on_work().

Hugh
