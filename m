Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752535Ab1K2Hty (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 02:49:54 -0500
Received: from e2.ny.us.ibm.com ([32.97.182.142]:45610 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751146Ab1K2Htx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 02:49:53 -0500
Date: Tue, 29 Nov 2011 13:18:07 +0530
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
        Stephen Wilson <wilsons@start.ca>
Subject: Re: [PATCH v7 3.2-rc2 3/30] uprobes: register/unregister probes.
Message-ID: <20111129074807.GA13445@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20111118110631.10512.73274.sendpatchset@srdronam.in.ibm.com>
 <20111118110713.10512.9461.sendpatchset@srdronam.in.ibm.com>
 <1322494194.2921.147.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1322494194.2921.147.camel@twins>
User-Agent: Mutt/1.5.20 (2009-06-14)
x-cbid: 11112907-5112-0000-0000-00000289C55E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Zijlstra <peterz@infradead.org> [2011-11-28 16:29:54]:

> On Fri, 2011-11-18 at 16:37 +0530, Srikar Dronamraju wrote:
> > +static void __unregister_uprobe(struct inode *inode, loff_t offset,
> > +                                               struct uprobe *uprobe)
> > +{
> > +       struct list_head try_list;
> > +       struct address_space *mapping;
> > +       struct vma_info *vi, *tmpvi;
> > +       struct vm_area_struct *vma;
> > +       struct mm_struct *mm;
> > +       loff_t vaddr;
> > +
> > +       mapping = inode->i_mapping;
> > +       INIT_LIST_HEAD(&try_list);
> > +       while ((vi = find_next_vma_info(&try_list, offset,
> > +                                               mapping, false)) != NULL) {
> > +               if (IS_ERR(vi))
> > +                       break;
> 
> So what kind of half-assed state are we left in if we try an unregister
> under memory pressure and how do we deal with that?
> 

Agree, Even I had this concern and wanted to see if there are ways to
deal with this.

- One approach would be pass extra GFG flags while we do allocations
  atleast in the unregister_uprobe.

Drawback of this approach: if the system is already under memory
pressure we shouldnt exert more pressure by asking it to repeat.

- The other approach would be to cache these temporary objects while we
  insert probes. i.e keep these metadata around.

I am sure you wouldnt want to add additional metadata.

- Third approach would be to have a completion/worker routine kick in if
  unregister_uprobe fails due to memory allocations.

This looks better than the rest.

Do you have any other approaches that we could try?

-- 
thanks and regards
Srikar

