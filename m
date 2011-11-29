Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754870Ab1K2KxL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 05:53:11 -0500
Received: from merlin.infradead.org ([205.233.59.134]:42138 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754631Ab1K2KxI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 05:53:08 -0500
Message-ID: <1322563948.2921.199.camel@twins>
Subject: Re: [PATCH v7 3.2-rc2 3/30] uprobes: register/unregister probes.
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
        Stephen Wilson <wilsons@start.ca>
Date: Tue, 29 Nov 2011 11:52:28 +0100
In-Reply-To: <20111129074807.GA13445@linux.vnet.ibm.com>
References: <20111118110631.10512.73274.sendpatchset@srdronam.in.ibm.com>
	 <20111118110713.10512.9461.sendpatchset@srdronam.in.ibm.com>
	 <1322494194.2921.147.camel@twins>
	 <20111129074807.GA13445@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.2.1- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-11-29 at 13:18 +0530, Srikar Dronamraju wrote:
> * Peter Zijlstra <peterz@infradead.org> [2011-11-28 16:29:54]:
> 
> > On Fri, 2011-11-18 at 16:37 +0530, Srikar Dronamraju wrote:
> > > +static void __unregister_uprobe(struct inode *inode, loff_t offset,
> > > +                                               struct uprobe *uprobe)
> > > +{
> > > +       struct list_head try_list;
> > > +       struct address_space *mapping;
> > > +       struct vma_info *vi, *tmpvi;
> > > +       struct vm_area_struct *vma;
> > > +       struct mm_struct *mm;
> > > +       loff_t vaddr;
> > > +
> > > +       mapping = inode->i_mapping;
> > > +       INIT_LIST_HEAD(&try_list);
> > > +       while ((vi = find_next_vma_info(&try_list, offset,
> > > +                                               mapping, false)) != NULL) {
> > > +               if (IS_ERR(vi))
> > > +                       break;
> > 
> > So what kind of half-assed state are we left in if we try an unregister
> > under memory pressure and how do we deal with that?
> > 
> 
> Agree, Even I had this concern and wanted to see if there are ways to
> deal with this.

If you do have this, please mention it in the Changelog and/or put /*
XXX */ in the code or so to point it out that there's a problem here.

> Do you have any other approaches that we could try?

You could use the stuff from patch 29 to effectively disable the uprobe
and return -ENOMEM to whoemever is unregistering. Basically failing the
unreg.

That way you can leave the uprobe in existance and half installed but
functionally fully disabled. Userspace (assuming we go back that far)
can then either re-try the removal later, or even reinstate it by doing
a register again or so.

Its still not pretty, but its better than pretending the unreg
completed.
