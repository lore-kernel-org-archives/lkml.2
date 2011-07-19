Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752212Ab1GSHFj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jul 2011 03:05:39 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:41811 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752107Ab1GSHFi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jul 2011 03:05:38 -0400
Date: Tue, 19 Jul 2011 12:23:50 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
        Linux-mm <linux-mm@kvack.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andi Kleen <andi@firstfloor.org>, Hugh Dickins <hughd@google.com>,
        Christoph Hellwig <hch@infradead.org>,
        Jonathan Corbet <corbet@lwn.net>, Thomas Gleixner <tglx@linutronix.de>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Oleg Nesterov <oleg@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Roland McGrath <roland@hack.frob.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v4 3.0-rc2-tip 7/22]  7: uprobes: mmap and fork hooks.
Message-ID: <20110719065350.GB1210@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20110617090504.GN4952@linux.vnet.ibm.com>
 <1308303665.2355.11.camel@twins>
 <1308662243.26237.144.camel@twins>
 <20110622143906.GF16471@linux.vnet.ibm.com>
 <20110624020659.GA24776@linux.vnet.ibm.com>
 <1308901324.27849.7.camel@twins>
 <20110627064502.GB24776@linux.vnet.ibm.com>
 <1309165071.6701.4.camel@twins>
 <20110718092055.GA1210@linux.vnet.ibm.com>
 <1310999476.13765.107.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1310999476.13765.107.camel@twins>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Zijlstra <peterz@infradead.org> [2011-07-18 16:31:16]:

> On Mon, 2011-07-18 at 14:50 +0530, Srikar Dronamraju wrote:
> >  *  - Introduce uprobes_list and uprobes_vaddr in vm_area_struct.
> >  *    uprobes_list is a node in the temp list of vmas while
> >  *    registering/unregistering uprobes. uprobes_vaddr caches the vaddr to
> >  *    insert/remove the breakpoint.
> >  *
> >  *  - Introduce srcu to synchronize vma deletion with walking the list of
> >  *    vma in register/unregister_uprobe.
> 
> I don't think you can sell this, that'll make munmap() horridly slow.

Okay, 

How about using a counter and a wq in each vma.
Based on the counter, I can wait in the munmap() and since this is per
vma, this should be faster than srcu.

Counter would be incremented when we do a vma-rmap walk. 
decremented when after insertion/deletion.
read in munmap().

> 
> >  *  - Introduce uprobes_mmap_mutex to synchronize uprobe deletion and
> >  *    mmap_uprobe(). 
> 
> Yes, that'll work I think.

Here another possibility is to have a per uprobe mutex, that way we
would not have to serialize mmap_uprobe. But this optimization can be
done later too.

-- 
Thanks and Regards
Srikar
