Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752902Ab0CWMXw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 08:23:52 -0400
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:40581 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752492Ab0CWMXn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 08:23:43 -0400
Date: Tue, 23 Mar 2010 17:53:35 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Masami Hiramatsu <mhiramat@redhat.com>, Mel Gorman <mel@csn.ul.ie>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Jim Keniston <jkenisto@linux.vnet.ibm.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       "Frank Ch. Eigler" <fche@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>, Roland McGrath <roland@redhat.com>,
       Oleg Nesterov <oleg@redhat.com>, Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v1 7/10] Uprobes Implementation
Message-ID: <20100323122335.GB26762@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20100320142455.11427.76925.sendpatchset@localhost6.localdomain6>
 <20100320142617.11427.23852.sendpatchset@localhost6.localdomain6>
 <1269342115.5279.1620.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1269342115.5279.1620.camel@twins>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,

> On Sat, 2010-03-20 at 19:56 +0530, Srikar Dronamraju wrote:
> > +struct uprobe {
> > +       /*
> > +        * The pid of the probed process.  Currently, this can be the
> > +        * thread ID (task->pid) of any active thread in the process.
> > +        */
> > +       pid_t pid;
> > +
> > +       /* Location of the probepoint */
> > +       unsigned long vaddr;
> > +
> > +       /* Handler to run when the probepoint is hit */
> > +       void (*handler)(struct uprobe*, struct pt_regs*);
> > +
> > +       /* true if handler runs in interrupt context*/
> > +       bool handler_in_interrupt;
> > +}; 
> 
> I would still prefer to see something like:
> 
>  vma:offset, instead of tid:vaddr
>  
> You want to probe a symbol in a DSO, filtering per-task comes after that
> if desired.
> 

If I would want to trace malloc in a process 
$ objdump -T /lib64/libc.so.6 | grep malloc 
000000357c274b80 g    DF .text  0000000000000224  GLIBC_2.2.5 __libc_malloc
000000357c271000  w   DF .text  0000000000000273  GLIBC_2.2.5 malloc_stats
000000357c275570  w   DF .text  00000000000001fb  GLIBC_2.2.5 malloc_get_state
000000357c5514f8  w   DO .data  0000000000000008  GLIBC_2.2.5 __malloc_hook
000000357c274b80 g    DF .text  0000000000000224  GLIBC_2.2.5 malloc
000000357c26f570  w   DF .text  0000000000000033  GLIBC_2.2.5 malloc_usable_size
000000357c271420  w   DF .text  000000000000024e  GLIBC_2.2.5 malloc_trim
000000357c5529a0  w   DO .bss   0000000000000008  GLIBC_2.2.5 __malloc_initialize_hook
000000357c271670  w   DF .text  00000000000003c2  GLIBC_2.2.5 malloc_set_state
$
$ cat /proc/9069/maps
...............
357c200000-357c34d000 r-xp 00000000 08:03 6115979 /lib64/libc-2.5.so
357c34d000-357c54d000 ---p 0014d000 08:03 6115979 /lib64/libc-2.5.so
357c54d000-357c551000 r--p 0014d000 08:03 6115979 /lib64/libc-2.5.so
357c551000-357c552000 rw-p 00151000 08:03 6115979 /lib64/libc-2.5.so
...............
$

do you mean the user should be specifying 357c200000:74b80 to denote
000000357c274b80? or /lib64/libc.so.6:74b80
And we trace all the process which have mapped this address?


> Also, like we discussed in person, I think we can do away with the
> handler_in_interrupt thing by letting the handler have an error return
> value and doing something like:
> 
> do_int3:
> 
>   uprobe = find_probe_point(addr);
> 
>   pagefault_disable();
>   err = uprobe->handler(uprobe, regs);
>   pagefault_enable();
> 
>   if (err == -EFAULT) {
>     /* set TIF flag and call the handler again from
>        task context */
>   }
> 
> This should allow the handler to optimistically access memory from the
> trap handler, but in case it does need to fault pages in we'll call it
> from task context.

Okay but what if the handler is coded to sleep.

> 
> Everybody else simply places callbacks in kernel/fork.c and
> kernel/exit.c, but as it is I don't think you want per-task state like
> this.
> 
> One thing I would like to see is a slot per task, that has a number of
> advantages over the current patch-set in that it doesn't have one page
> limit in number of probe sites, nor do you need to insert vmas into each
> and every address space that happens to have your DSO mapped.
> 

where are the per task slots stored?
or Are you looking at a XOL vma area per DSO?

> Also, I would simply kill the user_bkpt stuff and merge it into uprobes,
> we don't have a kernel_bkpt thing either, only kprobes.
> 

We had uprobes as one single layer. However it was suggested that
breaking it up into two layers was useful because it would help code
reuse. Esp it was felt that a generic user_bkpt layer would be far more
useful than being used for just uprobes.
Here are links where these discussion happened.
http://sourceware.org/ml/systemtap/2007-q1/msg00570.html
http://sourceware.org/ml/systemtap/2007-q1/msg00571.html

--
Thanks and Regards
Srikar
 
