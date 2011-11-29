Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753585Ab1K2LtZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 06:49:25 -0500
Received: from merlin.infradead.org ([205.233.59.134]:53485 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751411Ab1K2LtY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 06:49:24 -0500
Message-ID: <1322567326.2921.226.camel@twins>
Subject: Re: [PATCH v7 3.2-rc2 4/30] uprobes: Define hooks for mmap/munmap.
From: Peter Zijlstra <peterz@infradead.org>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Linux-mm <linux-mm@kvack.org>,
        Ingo Molnar <mingo@elte.hu>, Andi Kleen <andi@firstfloor.org>,
        Christoph Hellwig <hch@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Roland McGrath <roland@hack.frob.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Anton Arapov <anton@redhat.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Stephen Wilson <wilsons@start.ca>, tulasidhard@gmail.com
Date: Tue, 29 Nov 2011 12:48:46 +0100
In-Reply-To: <20111129083322.GD13445@linux.vnet.ibm.com>
References: <20111118110631.10512.73274.sendpatchset@srdronam.in.ibm.com>
	 <20111118110723.10512.66282.sendpatchset@srdronam.in.ibm.com>
	 <1322071812.14799.87.camel@twins>
	 <20111124134742.GH28065@linux.vnet.ibm.com>
	 <1322492384.2921.143.camel@twins>
	 <20111129083322.GD13445@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.2.1- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-11-29 at 14:03 +0530, Srikar Dronamraju wrote:


> install_breakpoints cannot have !consumers to be true when called from
> register_uprobe. (Since unregister_uprobe() which does the removal of
> consumer cannot race with register_uprobe().)

Right, that's the easy case ;-)

> Now lets consider mmap_uprobe() being called from vm_adjust(), the
> preceding unmap_uprobe() has already decremented the count but left the
> count intact.
> 
> if consumers is NULL, unregister_uprobes() has kicked already in, so
> there is no point in inserting the probe, Hence we return EEXIST. The
> following unregister_uprobe() (or the munmap_uprobe() which might race
> before unregister_uprobe) is also going to decrement the count.  So we
> have a case where the same breakpoint is accounted as removed twice. To
> offset this, we pretend as if the breakpoint is around by incrementing
> the count.

There's 2 main cases, 
	A) vma_adjust() vs unregister_uprobe() and 
	B) mmap() vs unregister_uprobe().

The result of A should be -1 reference in total, since we're removing
the one probe. The result of B should be 0 since we're removing the
probe and we shouldn't be installing new ones.

A1)
	vma_adjust()
	  munmap_uprobe()
				unregister_uprobe()
	  mmap_uprobe()
				  delete_uprobe()


	munmap will to -1, mmap will do +1, __unregister_uprobe() which is
serialized against vma_adjust() will do -1 on either the old or new vma,
resulting in a grand total of: -1+1-1=-1, OK

A2) breakpoint is in old, not in new, again two cases:

A2a) __unregister_uprobe() sees old

	munmap -1, __unregister_uprobe -1, mmap 0: -2 FAIL

A2b) __unregister_uprobe() sees new

	munmap -1, __unregister_uprobe 0, mmap 0: -1 OK

A3) breakpoint is in new, not in old, again two cases:

A3a) __unregister_uprobe() sees old

	munmap 0, __unregister_uprobe 0, mmap: 1: 1 FAIL

A3b) __unregister_uprobe() seed new

	munmap 0, __unregister_uprobe -1, mmap: 1: 0 FAIL

B1)
				unregister_uprobe()
	mmap()
	  mmap_uprobe()
				  __unregister_uprobe()
				  delete_uprobe()

	mmap +1, __unregister_uprobe() -1: 0 OK

B2)
				unregister_uprobe()
	mmap()
				  __unregister_uprobe()
	  mmap_uprobe()
				  delete_uprobe()

	mmap +1, __unregister_uprobe() 0: +1 FAIL


> Would it help if I add an extra check in mmap_uprobe?
> 
> int mmap_uprobe(...) {
> ....
> 	       ret = install_breakpoint(vma->vm_mm, uprobe);
> 	       if (ret == -EEXIST) {
> 			if (!read_opcode(vma->vm_mm, vaddr, &opcode) &&
> 					(opcode == UPROBES_BKPT_INSN))
> 			       atomic_inc(&vma->vm_mm->mm_uprobes_count);
> 		       ret = 0;
> 	       } 
> ....
> }

> The extra read_opcode check will tell us if the breakpoint is still
> around and then only increment the count. (As in it will distinguish if
> the mmap_uprobe is from vm_adjust).

No, I don't see that fixing A2a for example.

Could be I confused myself above, but like said, this stuff hurt brain.

It might just be easiest not to optimize munmap and leave fancy stuff
for later.
