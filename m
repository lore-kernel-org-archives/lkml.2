Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751213Ab1CPFEg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 01:04:36 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:45560 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751033Ab1CPFE3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 01:04:29 -0400
Date: Wed, 16 Mar 2011 10:28:20 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Jonathan Corbet <corbet@lwn.net>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Steven Rostedt <rostedt@goodmis.org>, Linux-mm <linux-mm@kvack.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Christoph Hellwig <hch@infradead.org>,
        Andi Kleen <andi@firstfloor.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Oleg Nesterov <oleg@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Roland McGrath <roland@hack.frob.com>,
        SystemTap <systemtap@sources.redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH v2 2.6.38-rc8-tip 11/20] 11: uprobes: slot allocation
 for uprobes
Message-ID: <20110316045820.GF24254@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20110314133403.27435.7901.sendpatchset@localhost6.localdomain6>
 <20110314133610.27435.93666.sendpatchset@localhost6.localdomain6>
 <20110315131020.36477a1c@bike.lwn.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20110315131020.36477a1c@bike.lwn.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Content-Scanned: Fidelis XPS MAILER
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Jonathan Corbet <corbet@lwn.net> [2011-03-15 13:10:20]:

> Just a couple of minor notes while I was looking at this code...
> 
> > +static struct uprobes_xol_area *xol_alloc_area(void)
> > +{
> > +	struct uprobes_xol_area *area = NULL;
> > +
> > +	area = kzalloc(sizeof(*area), GFP_USER);
> > +	if (unlikely(!area))
> > +		return NULL;
> > +
> > +	area->bitmap = kzalloc(BITS_TO_LONGS(UINSNS_PER_PAGE) * sizeof(long),
> > +								GFP_USER);
> 
> Why GFP_USER?  That causes extra allocation limits to be enforced.  Given
> that in part 14 you have:

Okay, Will use GFP_KERNEL. 
We used GFP_USER because we thought its going to represent part of
process address space; 

> 
> +/* Prepare to single-step probed instruction out of line. */
> +static int pre_ssout(struct uprobe *uprobe, struct pt_regs *regs,
> +				unsigned long vaddr)
> +{
> +	xol_get_insn_slot(uprobe, vaddr);
> +	BUG_ON(!current->utask->xol_vaddr);
> 
> It seems to me that you really don't want those allocations to fail.
> 
> back to xol_alloc_area():
> 
> > +	if (!area->bitmap)
> > +		goto fail;
> > +
> > +	spin_lock_init(&area->slot_lock);
> > +	if (!xol_add_vma(area) && !current->mm->uprobes_xol_area) {
> > +		task_lock(current);
> > +		if (!current->mm->uprobes_xol_area) {
> > +			current->mm->uprobes_xol_area = area;
> > +			task_unlock(current);
> > +			return area;
> > +		}
> > +		task_unlock(current);
> > +	}
> > +
> > +fail:
> > +	if (area) {
> > +		if (area->bitmap)
> > +			kfree(area->bitmap);
> > +		kfree(area);
> > +	}
> 
> You've already checked area against NULL, and kfree() can handle null
> pointers, so both of those tests are unneeded.

Okay, 

> 
> > +	return current->mm->uprobes_xol_area;
> > +}
> 
> jon

-- 
Thanks and Regards
Srikar
