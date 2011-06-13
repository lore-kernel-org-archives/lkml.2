Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755200Ab1FMJHi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jun 2011 05:07:38 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:46397 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754998Ab1FMJHh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jun 2011 05:07:37 -0400
Date: Mon, 13 Jun 2011 14:29:55 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
        Linux-mm <linux-mm@kvack.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Hugh Dickins <hughd@google.com>, Christoph Hellwig <hch@infradead.org>,
        Andi Kleen <andi@firstfloor.org>, Thomas Gleixner <tglx@linutronix.de>,
        Jonathan Corbet <corbet@lwn.net>, Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Roland McGrath <roland@hack.frob.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4 3.0-rc2-tip 2/22]  2: uprobes: Breakground page
 replacement.
Message-ID: <20110613085955.GD27130@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20110607125804.28590.92092.sendpatchset@localhost6.localdomain6>
 <20110607125835.28590.25476.sendpatchset@localhost6.localdomain6>
 <1307660609.2497.1773.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1307660609.2497.1773.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Zijlstra <peterz@infradead.org> [2011-06-10 01:03:29]:

> On Tue, 2011-06-07 at 18:28 +0530, Srikar Dronamraju wrote:
> > +       vaddr_old = kmap_atomic(old_page, KM_USER0);
> > +       vaddr_new = kmap_atomic(new_page, KM_USER1);
> > +
> > +       memcpy(vaddr_new, vaddr_old, PAGE_SIZE);
> > +       /* poke the new insn in, ASSUMES we don't cross page boundary */
> > +       addr = vaddr;
> > +       vaddr &= ~PAGE_MASK;
> > +       memcpy(vaddr_new + vaddr, &opcode, uprobe_opcode_sz);
> > +
> > +       kunmap_atomic(vaddr_new);
> > +       kunmap_atomic(vaddr_old); 
> 
> 
> > +       vaddr_new = kmap_atomic(page, KM_USER0);
> > +       vaddr &= ~PAGE_MASK;
> > +       memcpy(opcode, vaddr_new + vaddr, uprobe_opcode_sz);
> > +       kunmap_atomic(vaddr_new);
> > 


> 
> Both sequences in resp {write,read}_opcode() assume the opcode doesn't
> cross page boundaries but don't in fact have any assertions validating
> this assumption.
> 

read_opcode and write_opcode reads/writes just one breakpoint instruction
I had the below note just above the write_opcode definition.

/*
 * NOTE:
 * Expect the breakpoint instruction to be the smallest size instruction for
 * the architecture. If an arch has variable length instruction and the
 * breakpoint instruction is not of the smallest length instruction
 * supported by that architecture then we need to modify read_opcode /
 * write_opcode accordingly. This would never be a problem for archs that
 * have fixed length instructions.
 */

Do we have archs which have a breakpoint instruction which isnt of the
smallest instruction size for that arch. If we do have can we change the
write_opcode/read_opcode while we support that architecture?

-- 
Thanks and Regards
Srikar
> 
> 
