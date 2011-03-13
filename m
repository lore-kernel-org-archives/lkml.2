Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756629Ab1CMK31 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Mar 2011 06:29:27 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:52334 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755299Ab1CMK3W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Mar 2011 06:29:22 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Oleg Nesterov <oleg@redhat.com>
Subject: Re: + x86-mm-handle-mm_fault_error-in-kernel-space.patch added to -mm tree
Cc: kosaki.motohiro@jp.fujitsu.com, Andrew Vagin <avagin@gmail.com>,
        Pavel Emelyanov <xemul@openvz.org>, Andrey Vagin <avagin@openvz.org>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org, Nick Piggin <npiggin@suse.de>
In-Reply-To: <20110312211143.GA27460@redhat.com>
References: <20110311165700.GA30929@redhat.com> <20110312211143.GA27460@redhat.com>
Message-Id: <20110313182137.4119.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Sun, 13 Mar 2011 19:29:17 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On 03/11, Oleg Nesterov wrote:
> >
> > On 03/11, Andrew Vagin wrote:
> > >
> > >
> > The point is, if current was _NOT_ killed we should follow the current
> > pagefault_out_of_memory() logic or remove pagefault_out_of_memory()
> > completely.
> 
> Yes, and I still think this is valid. And thus I still think the patch
> should be changed (btw, this problem is not x86 specific).
> 
> However,
> 
> > >> Why do you think the current task should be killed? In this case we
> > >> do not need oom-killer at all, we could always kill the caller of
> > >> alloc_page/etc.
> > >
> > > You don't understand. alloc_page calls oom-killer himself, then try
> > > allocate memory again. Pls look at __alloc_pages_slowpath().
> > > __alloc_pages_slowpat may fail if order > 3 || gfp_mask & __GFP_NOFAIL
> > > || test_thread_flag(TIF_MEMDIE)
> >
> > Andrew, please, I know this.
> 
> Hmm. It turns out I do not ;)
> 
> I thought I can find the case when handle_mm_fault() returns VM_FAULT_OOM
> and the caller is not killed, but I can't. I do not really understand
> mem_cgroup_handle_oom/etc, but it seems we always retry indefinitely even
> with mem_cgroup's. mm/hugetlb.c looks fine too...
> 
> So, I have to apologize, I am starting to think you are right.
> 
> Maybe someone could explain why pagefault_out_of_memory() is still
> needed?

Hi Oleg, Andrew,

Now you are seeing VM dark side. ;-)
Two independent commit were introduced this hard to understand code.

	commit 1c0fe6e3bda0464728c23c8d84aa47567e8b716c
	Author: Nick Piggin <npiggin@suse.de>
	Date:   Tue Jan 6 14:38:59 2009 -0800

	    mm: invoke oom-killer from page fault

	commit 6583bb64fc370842b32a87c67750c26f6d559af0
	Author: David Rientjes <rientjes@google.com>
	Date:   Wed Jul 29 15:02:06 2009 -0700

	    mm: avoid endless looping for oom killed tasks

Most typical case is, as andew described, handle_mm_fault -> pte_alloc_one
-> alloc_pages_current(GFP_KERNEL, 0). and order 0 GFP_KERNEL allocation
never fail except the task received TIF_MEMDIE. therefore, in this case,
no need additional pageout_out_of_memory() call. Anyway pageout_out_of_memory()
is no-op if the task has already TIF_MEMDIE.

But, we don't have any gurantee pagefault path have no large allocation
nor no GFP_ATOMIC allocation. Therefore I think Oleg's patch pointed out
right thing. The protocol is, vma->vm_ops->fault() can return VM_FAULT_OOM
and if it is, page fault handler should invoke out-of-memory.

But I doubt practical workload can observe the difference.



