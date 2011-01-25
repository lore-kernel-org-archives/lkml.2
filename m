Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753742Ab1AYN4K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 08:56:10 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:60083 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753702Ab1AYN4H convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 08:56:07 -0500
Subject: Re: [RFC] [PATCH 2.6.37-rc5-tip 10/20] 10: uprobes: task specific
 information.
From: Peter Zijlstra <peterz@infradead.org>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Christoph Hellwig <hch@infradead.org>,
        Andi Kleen <andi@firstfloor.org>, Oleg Nesterov <oleg@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        SystemTap <systemtap@sources.redhat.com>,
        Linux-mm <linux-mm@vger.kernel.org>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
In-Reply-To: <20101216095912.23751.63180.sendpatchset@localhost6.localdomain6>
References: <20101216095714.23751.52601.sendpatchset@localhost6.localdomain6>
	 <20101216095912.23751.63180.sendpatchset@localhost6.localdomain6>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 25 Jan 2011 14:56:15 +0100
Message-ID: <1295963775.28776.1056.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-12-16 at 15:29 +0530, Srikar Dronamraju wrote:
> Uprobes needs to maintain some task specific information include if a
> task is currently uprobed, the currently handing uprobe, any arch
> specific information (for example to handle rip relative instructions),
> the per-task slot where the original instruction is copied to before
> single-stepping.

This can go away once you have per-task xol slots and boosted probes,
because then you can write the complete replacement sequence on trap and
never need to come back until you hit another probe, right?

> +/*
> + * uprobe_utask -- not a user-visible struct.
> + * Corresponds to a thread in a probed process.
> + * Guarded by uproc->mutex.
> + */
> +struct uprobe_task {
> +	unsigned long xol_vaddr;
> +	unsigned long vaddr;
> +
> +	enum uprobe_task_state state;
> +	struct uprobe_task_arch_info tskinfo;
> +
> +	struct uprobe *active_uprobe;
> +};

So xol_vaddr is the start of the xol slot,
vaddr is the trap address, we store those so that you still have the
state during the single-step things?

I guess you could obtain the xol slot information from the IP during
single-step, but since you have storage anyway, this might be cheaper.

And the active_probe is again due to single-step, right? Why exactly do
you need that? If you trap, acquire a new slot, write the replacement
sequence, single step through it, and release the slot once you're back
to the original code stream. I'm not quite seeing where you need the
probe during stepping.

Ah, I think I found it while reading patch 13, you need the pre/post_xol
callbacks, can't you simply synthesize their effect into the replacement
sequence?

  push %rax
  mov $vaddr, %rax
  $INSN
  pop %rax
  jmp $next_insn

like replacements would obviate the need for the pre/post callbacks and
allow you to run straight through.

It doesn't look too hard to create simple sequences for each
UPROBE_FIX_* thingy:

pre:
  push %rax; mov $vaddr, %rax && UPROBE_FIX_RIP_AX
  push %rcx; mov $vaddr, %rcx && UPROBE_FIX_RIP_CX

INSN

post:
  pop %rax && UPROBE_FIX_RIP_AX
  pop %rcx && UPROBE_FIX_RIP_CX
  add $correction, $offset(%rsp) && UPROBE_FIX_CALL
  jmp $next_insn

you already have all the logic of computing the various constants there.
And your slots are 128bytes long, which should fit sequences like that
just fine I think.

It would also remove the whole single-step need since they're proper
boosted probes.


