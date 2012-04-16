Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752996Ab2DPKJX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 06:09:23 -0400
Received: from merlin.infradead.org ([205.233.59.134]:34653 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752042Ab2DPKJV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 06:09:21 -0400
Message-ID: <1334570935.28150.25.camel@twins>
Subject: Re: [PATCH 2/6] uprobes: introduce is_swbp_at_addr_fast()
From: Peter Zijlstra <peterz@infradead.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>, Linux-mm <linux-mm@kvack.org>,
        Andi Kleen <andi@firstfloor.org>,
        Christoph Hellwig <hch@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Thomas Gleixner <tglx@linutronix.de>, Anton Arapov <anton@redhat.com>
Date: Mon, 16 Apr 2012 12:08:55 +0200
In-Reply-To: <20120405222106.GB19166@redhat.com>
References: <20120405222024.GA19154@redhat.com>
	 <20120405222106.GB19166@redhat.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-04-06 at 00:21 +0200, Oleg Nesterov wrote:
> +int __weak is_swbp_at_addr_fast(unsigned long vaddr)
> +{
> +       uprobe_opcode_t opcode;
> +       int fault;
> +
> +       pagefault_disable();
> +       fault = __copy_from_user_inatomic(&opcode, (void __user*)vaddr,
> +                                                       sizeof(opcode));
> +       pagefault_enable();
> +
> +       if (unlikely(fault)) {
> +               /*
> +                * XXX: read_opcode() lacks FOLL_FORCE, it can fail if
> +                * we race with another thread which does mprotect(NONE)
> +                * after we hit bp.
> +                */
> +               if (read_opcode(current->mm, vaddr, &opcode))
> +                       return -EFAULT;
> +       }
> +
> +       return is_swbp_insn(&opcode);
> +} 

Why bother with the pagefault_disable() and unlikely fault case and not
simply do copy_from_user() and have it deal with the fault if its needed
anyway?
