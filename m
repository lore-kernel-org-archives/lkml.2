Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757316Ab1F0JBo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jun 2011 05:01:44 -0400
Received: from merlin.infradead.org ([205.233.59.134]:44843 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757482Ab1F0I7K convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jun 2011 04:59:10 -0400
Subject: Re: [PATCH v4 3.0-rc2-tip 7/22]  7: uprobes: mmap and fork hooks.
From: Peter Zijlstra <peterz@infradead.org>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
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
In-Reply-To: <20110627064502.GB24776@linux.vnet.ibm.com>
References: <20110616130012.GL4952@linux.vnet.ibm.com>
	 <1308248588.13240.267.camel@twins>
	 <20110617045000.GM4952@linux.vnet.ibm.com>
	 <1308297836.13240.380.camel@twins>
	 <20110617090504.GN4952@linux.vnet.ibm.com> <1308303665.2355.11.camel@twins>
	 <1308662243.26237.144.camel@twins>
	 <20110622143906.GF16471@linux.vnet.ibm.com>
	 <20110624020659.GA24776@linux.vnet.ibm.com>
	 <1308901324.27849.7.camel@twins>
	 <20110627064502.GB24776@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 27 Jun 2011 10:57:51 +0200
Message-ID: <1309165071.6701.4.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-06-27 at 12:15 +0530, Srikar Dronamraju wrote:

> > > 	mutex_lock(&mapping->i_mmap_mutex);
> > > 	add_to_temp_list(vma, inode, &tmp_list);
> > > 	list_for_each_entry_safe(uprobe, u, &tmp_list, pending_list) {
> > > 		loff_t vaddr;
> > > 
> > > 		list_del(&uprobe->pending_list);
> > > 		if (ret)
> > > 			continue;
> > > 
> > > 		vaddr = vma->vm_start + uprobe->offset;
> > > 		vaddr -= vma->vm_pgoff << PAGE_SHIFT;
> > > 		ret = install_breakpoint(mm, uprobe, vaddr);
> > 
> > Right, so this is the problem, you cannot do allocations under
> > i_mmap_mutex, however I think you can under i_mutex.
> 
> I didnt know that we cannot do allocations under i_mmap_mutex.
> Why is this? 

Because we try to take i_mmap_mutex during reclaim, trying to unmap
pages. So suppose we do an allocation while holding i_mmap_mutex, find
there's no free memory, try and unmap a page in order to free it, and
we're stuck.

> I cant take i_mutex, because we would have already held
> down_write(mmap_sem) here. 

Right. So can we add a lock in the uprobe? All we need is per uprobe
serialization, right?
