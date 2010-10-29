Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761186Ab0J2KrG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Oct 2010 06:47:06 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:52505 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759688Ab0J2KrF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Oct 2010 06:47:05 -0400
Date: Fri, 29 Oct 2010 16:18:58 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Steven Rostedt <rostedt@goodmis.org>,
        Randy Dunlap <rdunlap@xenotime.net>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Naren A Devaiah <naren.devaiah@in.ibm.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Oleg Nesterov <oleg@redhat.com>, Mark Wielaard <mjw@redhat.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "Frank Ch. Eigler" <fche@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCHv11 2.6.36-rc2-tip 0/15]  0: Uprobes Patches
Message-ID: <20101029104858.GA1800@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20100825134117.5447.55209.sendpatchset@localhost6.localdomain6>
 <20101029092350.GA353@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20101029092350.GA353@infradead.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> It's been a while since the last posting.  Did you make any progress on
> uprobes, especially allowing to define probes based on a file name?
> 

Thanks for checking, I discussed with Peter offline and ironed out most
of the issues. I am thankful for Peter for all the suggestions

I am still getting the inode based uprobes to shape. 
Here is the brief summary of the discussion.

Significant differences from the previous patchset are:

- All probes would be maintained in a global rbtree sorted by inode and
  offset.
- There can be one or more consumers per probe. With each consumer there
  will be one handler and one (optional) filter.
- Filter restricts the processes/tasks that the handler is active.
- uprobe structure is dynamically created when the first consumer
  registers to the probe. It gets deallocated when all consumers
  unregisters from the probe.
- While registering a probe, we walk thro the list of vmas that are
  mapped to the inode, check if the consumer wants to probe the task
  corresponding to the vma and inserts the breakpoint.
- unregistering a probe also does something similar except for deleting
  the probe.
- There will be a hook in mmap/unmap to install probes as and when the
  vma gets loaded into process address space. This hook would walk thro
  the tree of probes for that inode and for each probe, walk thro the
  list of consumers and insert/delete breakpoints accordingly.
- There will be a hook in fork to install probes in newly created
  processes. This hook would walk thro the tree of probes for that inode
  and for each probe, walk thro the list of consumers and insert/delete
  breakpoints accordingly.
- Slots will still hang-out of mm_struct.
- Instead of the per-probe slot, we would have to use a per-thread slot.
  (This slot is for single stepping out of line). On every probehit, the
  slot has to be refreshed with the correct contents. 
- Since probe information is stored as inode:offset, probe
  identification on a breakpoint hit can only happen in task context.

Current issues: Given a vma; finding all tasks that have this vma
mapped. The current solution seems to walk thro all tasks in the system
and check if each task's mm field. But this could be inefficient
especially if the vma is part of all processes like libc etc.
I dont think we can use mm->owner to walk thro all the tasks that map to
this mm_struct.

Slot allocation delays: Using a per-thread slot instead of a per-probe
slot leads to a 3.5X degradation in performance. If we need to use
per-probe slots, we would have to have maintain metadata, i.e the slot
to virtual address mapping per process. However Peter prefers that we
reduce such metadata.

If a sigtrap occurs not because of a uprobe, we queue the signal only in
the task context. This is because we cannot identify the cause for trap
in interrupt context. If we use per-probe slots, we could avoid this.

Uprobes may not be able to trace a long-time running process if its
mapped a file that got updated after the process started. This assumes
the probes were placed after the process was started.

To cover the race where a breakpoint is hit while the probe is being
deleted, Paul has agreed to enhance srcu to work in interrupt context.

>From a perf/ftrace perspective:

Assuming 3551 as pid 
0x0000000000446420 as the vaddr of the probe for zfree
0x0000000000046420 as the offset of zfree from start of text address.
130904 as the inode number for the /bin/zsh

ftrace interface:
Previously:

# echo 'p 3551:0x0000000000446420 %ip %ax' > uprobe_events
# cat uprobe_events
p:uprobes/p_3551_0x0000000000446420 3551:0x0000000000446420 %ip=%ip %ax=%ax

Now:

# echo 'p /path-to-/file:0x0000000000046420 %ip %ax' > uprobe_events
# cat uprobe_events
p:uprobes/p_file_0x0000000000446420 130904:0x0000000000046420 %ip=%ip %ax=%ax


perf interface:
Previously:

# perf probe -p 3551 zfree@zsh
Added new event:
  probe_3551:zfree                       (on 0x446420)
# perf probe --list
probe_3551:zfree                       (on 3551:0x0000000000446420)

Now: 

# perf probe zfree@zsh
Added new event:
  probe_zsh:zfree                      (on 130904:0x46420)
# perf probe --list
probe_zsh:zfree                       (on 130904:0x0000000000046420)

JFYI: v11 patchset code that I last posted to LKML is available at:
git://git.kernel.org/pub/scm/linux/kernel/git/srikar/linux-uprobes.git
 branch : uprobes_v11_patchset 

Peter knows the details/trade-offs of both the designs.(v11 and the
inode based probes)

-- 
Thanks and Regards
Srikar
