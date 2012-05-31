Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758330Ab2EaSze (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 14:55:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29641 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757647Ab2EaSzc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 14:55:32 -0400
Date: Thu, 31 May 2012 20:53:39 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>, Ingo Molnar <mingo@elte.hu>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] uprobes: install_breakpoint() should fail if
	is_swbp_insn() == T
Message-ID: <20120531185339.GA28057@redhat.com>
References: <20120530165757.GA8077@redhat.com> <20120530165816.GA8085@redhat.com> <1338398931.28384.7.camel@twins> <20120530173717.GM15587@linux.vnet.ibm.com> <1338400142.28384.12.camel@twins> <1338400450.28384.16.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1338400450.28384.16.camel@twins>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/30, Peter Zijlstra wrote:
>
> register's vma
> iteration is very careful not to have the same vma twice,

Hmm. I am wondering if it is careful enough...

Just in case, I think your patch is great. But it seems to me
there is another problem.

__find_next_vma_info() checks tmpvi->mm == vma->vm_mm to detect the
already visited mm/vma. However, afaics this can be false positive?

The caller, register_for_each_vma(), does mmput() and after that
this memory can be freed and re-used as another mm_struct.

I'll recheck this, but perhaps we need something like below?

Oleg.

--- x/kernel/events/uprobes.c
+++ x/kernel/events/uprobes.c
@@ -851,7 +851,6 @@ static int register_for_each_vma(struct 
 			list_del(&vi->probe_list);
 			kfree(vi);
 			up_write(&mm->mmap_sem);
-			mmput(mm);
 			continue;
 		}
 		vaddr = vma_address(vma, uprobe->offset);
@@ -860,7 +859,6 @@ static int register_for_each_vma(struct 
 			list_del(&vi->probe_list);
 			kfree(vi);
 			up_write(&mm->mmap_sem);
-			mmput(mm);
 			continue;
 		}
 
@@ -870,7 +868,6 @@ static int register_for_each_vma(struct 
 			remove_breakpoint(uprobe, mm, vi->vaddr);
 
 		up_write(&mm->mmap_sem);
-		mmput(mm);
 		if (is_register) {
 			if (ret && ret == -EEXIST)
 				ret = 0;
@@ -881,6 +878,7 @@ static int register_for_each_vma(struct 
 
 	list_for_each_entry_safe(vi, tmpvi, &try_list, probe_list) {
 		list_del(&vi->probe_list);
+		mmput(vi->mm)
 		kfree(vi);
 	}
 

