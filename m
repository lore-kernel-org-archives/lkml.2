Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754900Ab1K2PGL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 10:06:11 -0500
Received: from merlin.infradead.org ([205.233.59.134]:57470 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754785Ab1K2PGI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 10:06:08 -0500
Message-ID: <1322579127.2921.240.camel@twins>
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
Date: Tue, 29 Nov 2011 16:05:27 +0100
In-Reply-To: <1322567326.2921.226.camel@twins>
References: <20111118110631.10512.73274.sendpatchset@srdronam.in.ibm.com>
	 <20111118110723.10512.66282.sendpatchset@srdronam.in.ibm.com>
	 <1322071812.14799.87.camel@twins>
	 <20111124134742.GH28065@linux.vnet.ibm.com>
	 <1322492384.2921.143.camel@twins>
	 <20111129083322.GD13445@linux.vnet.ibm.com>
	 <1322567326.2921.226.camel@twins>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.2.1- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-11-29 at 12:48 +0100, Peter Zijlstra wrote:
> There's 2 main cases, 
>         A) vma_adjust() vs unregister_uprobe() and 
>         B) mmap() vs unregister_uprobe().
> 
> The result of A should be -1 reference in total, since we're removing
> the one probe.

This might not be correct for A[23], please double check.

>  The result of B should be 0 since we're removing the
> probe and we shouldn't be installing new ones.
> 
> A1)
>         vma_adjust()
>           munmap_uprobe()
>                                 unregister_uprobe()
>           mmap_uprobe()
>                                   delete_uprobe()
> 
> 
>         munmap will to -1, mmap will do +1, __unregister_uprobe() which is
> serialized against vma_adjust() will do -1 on either the old or new vma,
> resulting in a grand total of: -1+1-1=-1, OK
> 
> A2) breakpoint is in old, not in new, again two cases:
> 
> A2a) __unregister_uprobe() sees old
> 
>         munmap -1, __unregister_uprobe -1, mmap 0: -2 FAIL
> 
> A2b) __unregister_uprobe() sees new
> 
>         munmap -1, __unregister_uprobe 0, mmap 0: -1 OK
> 
> A3) breakpoint is in new, not in old, again two cases:
> 
> A3a) __unregister_uprobe() sees old
> 
>         munmap 0, __unregister_uprobe 0, mmap: 1: 1 FAIL
> 
> A3b) __unregister_uprobe() seed new
> 
>         munmap 0, __unregister_uprobe -1, mmap: 1: 0 FAIL

There's more cases, I forgot the details of how the prio_tree stuff
works, so please consider if its possible to also have:

  __unregister_uprobe() will observe neither old nor new

This could happen if we first munmap, __unregister_uprobe() will iterate
past where mmap() will insert the new vma, mmap will insert the new vma,
and __unregister_uprobe() will now not observe it.

and

  __unregister_uprobe() will observe both old _and_ new

This latter could happen by favourably interleaving the prio_tree
iteration with the munmap and mmap operations, so that we first observe
the old vma, do the munmap, do the mmap, and then have the
find_next_vma_info() thing find the new vma.

> B1)
>                                 unregister_uprobe()
>         mmap()
>           mmap_uprobe()
>                                   __unregister_uprobe()
>                                   delete_uprobe()
> 
>         mmap +1, __unregister_uprobe() -1: 0 OK
> 
> B2)
>                                 unregister_uprobe()
>         mmap()
>                                   __unregister_uprobe()
>           mmap_uprobe()
>                                   delete_uprobe()
> 
>         mmap +1, __unregister_uprobe() 0: +1 FAIL 
