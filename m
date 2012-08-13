Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752166Ab2HMNTf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 09:19:35 -0400
Received: from e28smtp02.in.ibm.com ([122.248.162.2]:48723 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751946Ab2HMNTe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 09:19:34 -0400
Date: Mon, 13 Aug 2012 18:48:51 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/7] uprobes: kill uprobes_state->count
Message-ID: <20120813131850.GF31805@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20120808173659.GA13220@redhat.com>
 <20120808173736.GA13252@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20120808173736.GA13252@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
x-cbid: 12081313-5816-0000-0000-000003F93D78
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Oleg Nesterov <oleg@redhat.com> [2012-08-08 19:37:37]:

> uprobes_state->count is only needed to avoid the slow path in
> uprobe_pre_sstep_notifier(). It is also checked in uprobe_munmap()
> but ironically its only goal to decrement this counter. However,
> it is very broken. Just some examples:
> 
> - uprobe_mmap() can race with uprobe_unregister() and wrongly
>   increment the counter if it hits the non-uprobe "int3". Note
>   that install_breakpoint() checks ->consumers first and returns
>   -EEXIST if it is NULL.
> 
>   "atomic_sub() if error" in uprobe_mmap() looks obviously wrong
>   too.
> 
> - uprobe_munmap() can race with uprobe_register() and wrongly
>   decrement the counter by the same reason.
> 
> - Suppose an appication tries to increase the mmapped area via
>   sys_mremap(). vma_adjust() does uprobe_munmap(whole_vma) first,
>   this can nullify the counter temporarily and race with another
>   thread which can hit the bp, the application will be killed by
>   SIGTRAP.
> 
> - Suppose an application mmaps 2 consecutive areas in the same file
>   and one (or both) of these areas has uprobes. In the likely case
>   mmap_region()->vma_merge() suceeds. Like above, this leads to
>   uprobe_munmap/uprobe_mmap from vma_merge()->vma_adjust() but then
>   mmap_region() does another uprobe_mmap(resulting_vma) and doubles
>   the counter.
> 
> This patch only removes this counter and fixes the compile errors,
> then we will try to cleanup the changed code and add something else
> instead.
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>

Acked-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>

