Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753394Ab1I0NNe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 09:13:34 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:60957 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751303Ab1I0NNc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 09:13:32 -0400
Date: Tue, 27 Sep 2011 18:20:20 +0530
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
Message-ID: <20110927125020.GB3685@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20110920115938.25326.93059.sendpatchset@srdronam.in.ibm.com>
 <20110920120335.25326.50673.sendpatchset@srdronam.in.ibm.com>
 <1317127079.15383.52.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1317127079.15383.52.camel@twins>
User-Agent: Mutt/1.5.20 (2009-06-14)
x-cbid: 11092713-5112-0000-0000-000000A10336
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Zijlstra <peterz@infradead.org> [2011-09-27 14:37:59]:

> On Tue, 2011-09-20 at 17:33 +0530, Srikar Dronamraju wrote:
> > +static unsigned long xol_take_insn_slot(struct uprobes_xol_area *area)
> > +{
> > +       unsigned long slot_addr, flags;
> > +       int slot_nr;
> > +
> > +       do {
> > +               spin_lock_irqsave(&area->slot_lock, flags);
> > +               slot_nr = find_first_zero_bit(area->bitmap, UINSNS_PER_PAGE);
> > +               if (slot_nr < UINSNS_PER_PAGE) {
> > +                       __set_bit(slot_nr, area->bitmap);
> > +                       slot_addr = area->vaddr +
> > +                                       (slot_nr * UPROBES_XOL_SLOT_BYTES);
> > +                       atomic_inc(&area->slot_count);
> > +               }
> > +               spin_unlock_irqrestore(&area->slot_lock, flags);
> > +               if (slot_nr >= UINSNS_PER_PAGE)
> > +                       xol_wait_event(area);
> > +
> > +       } while (slot_nr >= UINSNS_PER_PAGE);
> > +
> > +       return slot_addr;
> > +} 
> 
> Why isn't a find_first_bit() + set_and_test_bit() not sufficient? That
> is, what do you need that lock for?

yes, we could do without the lock to.
Will do this in the next patchset.

-- 
Thanks and Regards 
Srikar

