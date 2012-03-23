Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755736Ab2CWBIY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2012 21:08:24 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:32992 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754022Ab2CWBIX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2012 21:08:23 -0400
MIME-Version: 1.0
In-Reply-To: <20120320033300.GH2393@linux.vnet.ibm.com>
References: <20120319152317.GA3932@gmail.com> <CA+55aFyezw6yW2g6hOAOeZ5vRm0xUNPQyD4eo0wRHMHiN3Z+kQ@mail.gmail.com>
 <20120320033300.GH2393@linux.vnet.ibm.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 22 Mar 2012 18:08:01 -0700
X-Google-Sender-Auth: -K9RyJgkncDeNwA6Hsv7bVBSQto
Message-ID: <CA+55aFzXAdNRqNHm3-wx02au4b_Ze_WM-gCtOk+gJdGMsn3Zbg@mail.gmail.com>
Subject: Re: [GIT PULL] RCU changes for v3.4
To: paulmck@linux.vnet.ibm.com
Cc: Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 19, 2012 at 8:33 PM, Paul E. McKenney
<paulmck@linux.vnet.ibm.com> wrote:
>
> If it would help, I would be happy to put together an itemized list.
> I will of course do so for the next merge window.

Ok. I would like to get an itemized list next time, now I ended up
re-doing the merges with the one Ingo sent me.

However, looking at the current state of RCU, the thing I would
*really* like to *finally* be fixed is that total disaster called
__rcu_read_lock() (and to a lesser degree __rcu_read_unlock).

Why do I call it a total disaster?

Simple: there are two versions of that function (not counting the
inlined trivial non-preempt version that just disables preemption),
AND THEY ARE BOTH IDENTICAL.

More importantly, they are both IDENTICALLY BAD.

They are crap because:

 - they shouldn't be out-of-line to begin with.

   Doing a function call for these things is stupid. It's  not like
it's even "oh, there are two versions of it, so the linker picks one
over the other". Sure, there are two versions of it, but they are the
same stupid code just duplicated.

 - the rcu counter should be a per-cpu counter, not a per-thread one

Right now that function ends up being two instructions:

        mov    %gs:0xb700,%rax
        incl   0x100(%rax)

and dammit, using a function call to do that is pretty much
borderline. But it should be *one* instruction that just increments
the percpu variable:

        incl %gs:rcu_read_lock_nesting

and it shouldn't be out-of-line.

Because wouldn't it be nice to just make the scheduler save/restore
the rcu read lock depth for the rcu preemption case.

Yeah, we should do the same thing with the preempt count. It shouldn't
be in the thread structure, it should be per-cpu.

Please? Every time I look at some profiles, that silly rcu_read_lock
is there in the profile. It's annoying. I'd rather see it in the
function that invokes it.

                      Linus
