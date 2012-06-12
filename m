Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752870Ab2FLRGo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 13:06:44 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:44068 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751623Ab2FLRGm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 13:06:42 -0400
Date: Tue, 12 Jun 2012 22:24:04 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        linuxppc-dev@lists.ozlabs.org, lkml <linux-kernel@vger.kernel.org>,
        michael@ellerman.id.au, antonb@thinktux.localdomain,
        Paul Mackerras <paulus@samba.org>, benh@kernel.crashing.org,
        Ingo Molnar <mingo@elte.hu>, peterz@infradead.org,
        Jim Keniston <jkenisto@us.ibm.com>
Subject: Re: [PATCH v2 1/2] uprobes: Pass probed vaddr to
 arch_uprobe_analyze_insn()
Message-ID: <20120612165404.GB30555@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20120608093257.GG13409@in.ibm.com>
 <20120611161215.GA12116@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20120611161215.GA12116@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12061217-7182-0000-0000-000001B9F584
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> Well, IMHO, this is confusing.
> 
> First of all, why do we have this "addr" or even "vaddr"? It should
> not exists. We pass it to copy_insn(), but for what?? copy_insn()
> should simply use uprobe->offset, the virtual address for this
> particular mapping does not matter at all. I am going to send
> the cleanup.
> 

Yes, we can use uprobe->offset instead of vaddr/addr.

> Note also that we should move this !UPROBE_COPY_INSN from
> install_breakpoint() to somewhere near alloc_uprobe(). This code
> is called only once, it looks a bit strange to use the "random" mm
> (the first mm vma_prio_tree_foreach() finds) and its mapping to
> verify the insn. In fact this is simply not correct and should be
> fixed, note that on x86 arch_uprobe_analyze_insn() checks

The reason we "delay" the copy_insn to the first insert is because 
we have to get access to mm. For archs like x86, we want to know if the
executable is 32 bit or not (since we have a different valid set of
instructions for 32 bit and 64 bit). So in effect, if we get access to
struct file corresponding to the inode and if the inode corresponds to
32 bit executable file or 64 bit executable file during register, then
we can move it around alloc_uprobe().

