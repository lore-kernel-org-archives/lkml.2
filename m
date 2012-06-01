Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965537Ab2FAQuF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2012 12:50:05 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:34086 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965469Ab2FAQuD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2012 12:50:03 -0400
Date: Fri, 1 Jun 2012 22:17:25 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] uprobes: install_breakpoint() should fail if
 is_swbp_insn() == T
Message-ID: <20120601164725.GK24279@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20120530165757.GA8077@redhat.com>
 <20120530165816.GA8085@redhat.com>
 <1338398931.28384.7.camel@twins>
 <20120530173717.GM15587@linux.vnet.ibm.com>
 <1338400142.28384.12.camel@twins>
 <1338400450.28384.16.camel@twins>
 <20120531185339.GA28057@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20120531185339.GA28057@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12060116-5806-0000-0000-000015C81E58
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Oleg Nesterov <oleg@redhat.com> [2012-05-31 20:53:39]:

> On 05/30, Peter Zijlstra wrote:
> >
> > register's vma
> > iteration is very careful not to have the same vma twice,
> 
> Hmm. I am wondering if it is careful enough...
> 
> Just in case, I think your patch is great. But it seems to me
> there is another problem.
> 
> __find_next_vma_info() checks tmpvi->mm == vma->vm_mm to detect the
> already visited mm/vma. However, afaics this can be false positive?
> 
> The caller, register_for_each_vma(), does mmput() and after that
> this memory can be freed and re-used as another mm_struct.
> 

Before we do a mmput(), we take the mmap_sem for that mm. So this mm
cannot be freed until we complete insertion/removal.  If the mm gets
reused after the insertion/removal, and maps the inode, then we are
doing the right thing by parsing it.

Or are you hinting at some other problem?


> I'll recheck this, but perhaps we need something like below?
> 
> Oleg.
> 
> --- x/kernel/events/uprobes.c
> +++ x/kernel/events/uprobes.c
> @@ -851,7 +851,6 @@ static int register_for_each_vma(struct 
>  			list_del(&vi->probe_list);
>  			kfree(vi);
>  			up_write(&mm->mmap_sem);
> -			mmput(mm);

If we want to do this, then we have to even move the list_del and kfree
along with mmput.  Otherwise we may leak mm's.  I see no advantages
except for decrease in code.  I might be missing something trivial. 

On the other side, moving the lines below would mean keeping extra
elements in the list that have to be traversed again. i.e if we
determine in this pass that elements of the list can be removed, then
why keep them till the next pass.

>  			continue;
>  		}
>  		vaddr = vma_address(vma, uprobe->offset);
> @@ -860,7 +859,6 @@ static int register_for_each_vma(struct 
>  			list_del(&vi->probe_list);
>  			kfree(vi);
>  			up_write(&mm->mmap_sem);
> -			mmput(mm);
>  			continue;
>  		}
> 
> @@ -870,7 +868,6 @@ static int register_for_each_vma(struct 
>  			remove_breakpoint(uprobe, mm, vi->vaddr);
> 
>  		up_write(&mm->mmap_sem);
> -		mmput(mm);
>  		if (is_register) {
>  			if (ret && ret == -EEXIST)
>  				ret = 0;
> @@ -881,6 +878,7 @@ static int register_for_each_vma(struct 
> 
>  	list_for_each_entry_safe(vi, tmpvi, &try_list, probe_list) {
>  		list_del(&vi->probe_list);
> +		mmput(vi->mm)
>  		kfree(vi);
>  	}
> 
> 

