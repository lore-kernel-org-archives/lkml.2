Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965497Ab2FAQg5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2012 12:36:57 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:37508 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965419Ab2FAQg4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2012 12:36:56 -0400
Date: Fri, 1 Jun 2012 22:03:15 +0530
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
Message-ID: <20120601163315.GJ24279@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20120530165757.GA8077@redhat.com>
 <20120530165816.GA8085@redhat.com>
 <1338398931.28384.7.camel@twins>
 <20120530173717.GM15587@linux.vnet.ibm.com>
 <1338400142.28384.12.camel@twins>
 <1338400450.28384.16.camel@twins>
 <20120531185339.GA28057@redhat.com>
 <20120601155312.GA20265@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20120601155312.GA20265@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12060116-7606-0000-0000-000000C9161E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Oleg Nesterov <oleg@redhat.com> [2012-06-01 17:53:12]:

> On 05/31, Oleg Nesterov wrote:
> >
> > __find_next_vma_info() checks tmpvi->mm == vma->vm_mm to detect the
> > already visited mm/vma. However, afaics this can be false positive?
> 
> Yes, but I guess this is harmless, we can rely on uprobe_mmap.
> 
> 
> 
> But. Doesn't this mean we can greatly simplify register_for_each_vma()
> and make it O(n) ?
> 
> Unless I missed something, we can simply create the list of
> mm/vaddr structures under ->i_mmap_mutex (vma_prio_tree_foreach), then
> register_for_each_vma() can process the list and that is all.


If I remember correctly, we cannot allocate the list elements under
i_mmap_mutex. We dont know how many list elements to allocate.

This is what Peter had to say : https://lkml.org/lkml/2011/6/27/72

"Because we try to take i_mmap_mutex during reclaim, trying to unmap
pages. So suppose we do an allocation while holding i_mmap_mutex, find
there's no free memory, try and unmap a page in order to free it, and
we're stuck."

> 
> If another mapping comes after we drop i_mmap_mutex, uprobe_mmap()
> should be called and it should install the bp.
> 

-- 
Thanks and Regards
Srikar

