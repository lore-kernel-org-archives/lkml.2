Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754824Ab2DPVsH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 17:48:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54359 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752828Ab2DPVsF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 17:48:05 -0400
Date: Mon, 16 Apr 2012 23:47:07 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>, Linux-mm <linux-mm@kvack.org>,
        Andi Kleen <andi@firstfloor.org>,
        Christoph Hellwig <hch@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Thomas Gleixner <tglx@linutronix.de>, Anton Arapov <anton@redhat.com>
Subject: Re: [RFC 0/6] uprobes: kill uprobes_srcu/uprobe_srcu_id
Message-ID: <20120416214707.GA27639@redhat.com>
References: <20120405222024.GA19154@redhat.com> <1334409396.2528.100.camel@twins> <20120414205200.GA9083@redhat.com> <1334487062.2528.113.camel@twins> <20120415195351.GA22095@redhat.com> <1334526513.28150.23.camel@twins> <20120415234401.GA32662@redhat.com> <1334571419.28150.30.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1334571419.28150.30.camel@twins>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/16, Peter Zijlstra wrote:
>
> On Mon, 2012-04-16 at 01:44 +0200, Oleg Nesterov wrote:
>
> > And. I have another reason for down_write() in register/unregister.
> > I am still not sure this is possible (I had no time to try to
> > implement), but it seems to me we can kill the uprobe counter in
> > mm_struct.
>
> You mean by making register/unregister down_write, you're exclusive with
> munmap()

.. and with register/unregister.

Why do we need mm->uprobes_state.count? It is writeonly, except we
check it in the DIE_INT3 notifier before anything else to avoid the
unnecessary uprobes overhead.

Suppose we kill it, and add the new MMF_HAS_UPROBE flag instead.
install_breakpoint() sets it unconditionally,
uprobe_pre_sstep_notifier() checks it.

(And perhaps we can stop right here? I mean how often this can
 slow down the debugger which installs int3 in the same mm?)

Now we need to clear MMF_HAS_UPROBE somehowe, when the last
uprobe goes away. Lets ignore uprobe_map/unmap for simplicity.

	- We add another flag, MMF_UPROBE_RECALC, it is set by
	  remove_breakpoint().

	- We change handle_swbp(). Ignoring all details it does:

		if (find_uprobe(vaddr))
			process_uprobe();
		else if (test_bit(MMF_HAS_UPROBE) && test_bit(MMF_UPROBE_RECALC))
			recalc_mmf_uprobe_flag();

	  where recalc_mmf_uprobe_flag() checks all vmas and either
	  clears both flags or MMF_UPROBE_RECALC only.

	  This is the really slow O(n) path, but it can only happen after
	  unregister, and only if we hit another non-uprobe breakpoint
	  in the same mm.

Something like this. What do you think?

Oleg.

