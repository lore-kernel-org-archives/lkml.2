Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753710Ab1I0NGf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 09:06:35 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:40152 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751856Ab1I0NGe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 09:06:34 -0400
Date: Tue, 27 Sep 2011 18:15:00 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
        Linux-mm <linux-mm@kvack.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jonathan Corbet <corbet@lwn.net>, Hugh Dickins <hughd@google.com>,
        Christoph Hellwig <hch@infradead.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Roland McGrath <roland@hack.frob.com>,
        Andi Kleen <andi@firstfloor.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v5 3.1.0-rc4-tip 18/26]   uprobes: slot allocation.
Message-ID: <20110927124500.GA3685@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20110920115938.25326.93059.sendpatchset@srdronam.in.ibm.com>
 <20110920120335.25326.50673.sendpatchset@srdronam.in.ibm.com>
 <1317125932.15383.49.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1317125932.15383.49.camel@twins>
User-Agent: Mutt/1.5.20 (2009-06-14)
x-cbid: 11092713-6078-0000-0000-0000013C26B1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Zijlstra <peterz@infradead.org> [2011-09-27 14:18:52]:

> On Tue, 2011-09-20 at 17:33 +0530, Srikar Dronamraju wrote:
> > +static struct uprobes_xol_area *xol_alloc_area(void)
> > +{
> > +       struct uprobes_xol_area *area = NULL;
> > +
> > +       area = kzalloc(sizeof(*area), GFP_KERNEL);
> > +       if (unlikely(!area))
> > +               return NULL;
> > +
> > +       area->bitmap = kzalloc(BITS_TO_LONGS(UINSNS_PER_PAGE) * sizeof(long),
> > +                                                               GFP_KERNEL);
> > +
> > +       if (!area->bitmap)
> > +               goto fail;
> > +
> > +       init_waitqueue_head(&area->wq);
> > +       spin_lock_init(&area->slot_lock);
> > +       if (!xol_add_vma(area) && !current->mm->uprobes_xol_area) {
> 
> So what happens if xol_add_vma() succeeds, but we find
> ->uprobes_xol_area set?
> 
> > +               task_lock(current);
> > +               if (!current->mm->uprobes_xol_area) {
> 
> Having to re-test it under this lock seems to suggest it could.
> 
> > +                       current->mm->uprobes_xol_area = area;
> > +                       task_unlock(current);
> > +                       return area;
> 
> This function would be so much easier to read if the success case (this
> here I presume) would not be nested 2 deep.
> 
> > +               }
> > +               task_unlock(current);
> > +       }
> 
> at which point you could end up with two extra vmas? Because there's no
> freeing of the result of xol_add_vma().
> 

Agree, we need to unmap the vma in that case.

> > +fail:
> > +       kfree(area->bitmap);
> > +       kfree(area);
> > +       return current->mm->uprobes_xol_area;
> > +} 

-- 
Thanks and Regards
Srikar

