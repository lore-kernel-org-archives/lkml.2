Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751949Ab1K3Fcs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Nov 2011 00:32:48 -0500
Received: from e34.co.us.ibm.com ([32.97.110.152]:46185 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750852Ab1K3Fcr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Nov 2011 00:32:47 -0500
Date: Wed, 30 Nov 2011 11:00:44 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
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
Subject: Re: [PATCH v7 3.2-rc2 4/30] uprobes: Define hooks for mmap/munmap.
Message-ID: <20111130053007.GA21514@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20111118110631.10512.73274.sendpatchset@srdronam.in.ibm.com>
 <20111118110723.10512.66282.sendpatchset@srdronam.in.ibm.com>
 <1322071812.14799.87.camel@twins>
 <20111124134742.GH28065@linux.vnet.ibm.com>
 <1322492384.2921.143.camel@twins>
 <20111129083322.GD13445@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20111129083322.GD13445@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
x-cbid: 11113005-1780-0000-0000-0000014D35F2
X-IBM-ISS-SpamDetectors: 
X-IBM-ISS-DetailInfo: BY=3.00000235; HX=3.00000178; KW=3.00000007;
 PH=3.00000001; SC=3.00000001; SDB=6.00091966; UDB=6.00024381; UTC=2011-11-30
 05:32:46
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
> 

Infact the check for EEXIST and read_opcode in mmap_uprobe() is needed
for another reason too.

Lets say while unregister_uprobe was around, a thread thats being
probed, just forked a child and the child called mmap_uprobe.

Now mmap_uprobe might find that the breakpoint is already inserted
since the pages are shared with the parent. But before
unregister_uprobe can come around and cleanup, the child can run and hit
the breakpoint. Since the breakpoint count is 0 for the child, we dont
expect the child to have hit a breakpoint placed by uprobes, and the
child gets a SIGTRAP.

With this check for read_opcode on EEXIST from install_breakpoint, we
will know that there is a valid breakpoint underneath and increment
the count. So on a breakpoint hit, the uprobes notifier does the right
thing.

If the unregister_uprobe() had already cleanup the breakpoint in the
parent, the child's copy would also be clean so read_opcode wont find
the breakpoint and hence we wont increment the breakpoint.

-- 
Thanks and Regards
Srikar

