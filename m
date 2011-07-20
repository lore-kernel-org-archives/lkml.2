Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752486Ab1GTWpv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jul 2011 18:45:51 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39667 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752378Ab1GTWpt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jul 2011 18:45:49 -0400
MIME-Version: 1.0
In-Reply-To: <1311186383-24819-3-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20110720182512.GA22946@linux.vnet.ibm.com> <1311186383-24819-3-git-send-email-paulmck@linux.vnet.ibm.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 20 Jul 2011 15:44:55 -0700
Message-ID: <CA+55aFzWAWV4Vr5mhy6+EELNY4_jCr4ozjgHmPk1CMp3mTOegw@mail.gmail.com>
Subject: Re: [PATCH tip/core/urgent 3/7] rcu: Streamline code produced by __rcu_read_unlock()
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        Valdis.Kletnieks@vt.edu, dhowells@redhat.com, eric.dumazet@gmail.com,
        darren@dvhart.com, patches@linaro.org, greearb@candelatech.com,
        edt@aei.ca
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 20, 2011 at 11:26 AM, Paul E. McKenney
<paulmck@linux.vnet.ibm.com> wrote:
> Given some common flag combinations, particularly -Os, gcc will inline
> rcu_read_unlock_special() despite its being in an unlikely() clause.
> Use noinline to prohibit this misoptimization.

Btw, I suspect that we should at least look at what it would mean if
we make the rcu_read_lock_nesting and the preempt counters both be
per-cpu variables instead of making them per-thread/process counters.

Then, when we switch threads, we'd just save/restore them from the
process register save area.

There's a lot of critical code sequences (spin-lock/unlock, rcu
read-lock/unlock) that currently fetches the thread/process pointer
only to then offset it and increment the count. I get the strong
feeling that code generation could be improved and we could avoid one
level of indirection by just making it a per-thread counter.

For example, instead of __rcu_read_lock: looking like this (and being
an external function, partly because of header file dependencies on
the data structures involved):

  push   %rbp
  mov    %rsp,%rbp
  mov    %gs:0xb580,%rax
  incl   0x100(%rax)
  leaveq
  retq

it should inline to just something like

  incl %gs:0x100

instead. Same for the preempt counter.

Of course, it would need to involve making sure that we pick a good
cacheline etc that is already always dirty. But other than that, is
there any real downside?

                       Linus
