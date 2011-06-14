Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751669Ab1FNM6q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jun 2011 08:58:46 -0400
Received: from casper.infradead.org ([85.118.1.10]:45601 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751292Ab1FNM6m convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jun 2011 08:58:42 -0400
Subject: Re: [PATCH v4 3.0-rc2-tip 2/22]  2: uprobes: Breakground page
 replacement.
From: Peter Zijlstra <peterz@infradead.org>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
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
In-Reply-To: <20110613085955.GD27130@linux.vnet.ibm.com>
References: <20110607125804.28590.92092.sendpatchset@localhost6.localdomain6>
	 <20110607125835.28590.25476.sendpatchset@localhost6.localdomain6>
	 <1307660609.2497.1773.camel@laptop>
	 <20110613085955.GD27130@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 14 Jun 2011 14:57:29 +0200
Message-ID: <1308056249.19856.34.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-06-13 at 14:29 +0530, Srikar Dronamraju wrote:
> * Peter Zijlstra <peterz@infradead.org> [2011-06-10 01:03:29]:
> 
> > On Tue, 2011-06-07 at 18:28 +0530, Srikar Dronamraju wrote:
> > > +       vaddr_old = kmap_atomic(old_page, KM_USER0);
> > > +       vaddr_new = kmap_atomic(new_page, KM_USER1);
> > > +
> > > +       memcpy(vaddr_new, vaddr_old, PAGE_SIZE);
> > > +       /* poke the new insn in, ASSUMES we don't cross page boundary */
> > > +       addr = vaddr;
> > > +       vaddr &= ~PAGE_MASK;
> > > +       memcpy(vaddr_new + vaddr, &opcode, uprobe_opcode_sz);
> > > +
> > > +       kunmap_atomic(vaddr_new);
> > > +       kunmap_atomic(vaddr_old); 
> > 
> > 
> > > +       vaddr_new = kmap_atomic(page, KM_USER0);
> > > +       vaddr &= ~PAGE_MASK;
> > > +       memcpy(opcode, vaddr_new + vaddr, uprobe_opcode_sz);
> > > +       kunmap_atomic(vaddr_new);
> > > 
> 
> 
> > 
> > Both sequences in resp {write,read}_opcode() assume the opcode doesn't
> > cross page boundaries but don't in fact have any assertions validating
> > this assumption.
> > 
> 
> read_opcode and write_opcode reads/writes just one breakpoint instruction
> I had the below note just above the write_opcode definition.
> 
> /*
>  * NOTE:
>  * Expect the breakpoint instruction to be the smallest size instruction for
>  * the architecture. If an arch has variable length instruction and the
>  * breakpoint instruction is not of the smallest length instruction
>  * supported by that architecture then we need to modify read_opcode /
>  * write_opcode accordingly. This would never be a problem for archs that
>  * have fixed length instructions.
>  */

Whoever reads comments anyway? :-)

> Do we have archs which have a breakpoint instruction which isnt of the
> smallest instruction size for that arch. If we do have can we change the
> write_opcode/read_opcode while we support that architecture?

Why not put a simple WARN_ON_ONCE() in there that checks the assumption?
