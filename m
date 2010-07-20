Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755194Ab0GTHXN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jul 2010 03:23:13 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:59306 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752035Ab0GTHXM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jul 2010 03:23:12 -0400
Date: Tue, 20 Jul 2010 12:52:02 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Steven Rostedt <rostedt@goodmis.org>,
        Randy Dunlap <rdunlap@xenotime.net>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Oleg Nesterov <oleg@redhat.com>, Mark Wielaard <mjw@redhat.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Naren A Devaiah <naren.devaiah@in.ibm.com>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "Frank Ch. Eigler" <fche@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCHv9 2.6.35-rc4-tip 2/13]  uprobes: Breakpoint
 insertion/removal in user space applications.
Message-ID: <20100720072202.GB19375@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20100712103214.27491.15142.sendpatchset@localhost6.localdomain6>
 <20100712103235.27491.293.sendpatchset@localhost6.localdomain6>
 <20100720042814.GA13624@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20100720042814.GA13624@infradead.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Christoph Hellwig <hch@infradead.org> [2010-07-20 00:28:14]:

> > +struct user_bkpt_arch_info {
> > +	void (*set_ip)(struct pt_regs *regs, unsigned long vaddr);
> > +	int (*validate_address)(struct task_struct *tsk, unsigned long vaddr);
> > +	int (*read_opcode)(struct task_struct *tsk, unsigned long vaddr,
> > +						user_bkpt_opcode_t *opcode);
> > +	int (*set_bkpt)(struct task_struct *tsk,
> > +				struct user_bkpt *user_bkpt);
> > +	int (*set_orig_insn)(struct task_struct *tsk,
> > +				struct user_bkpt *user_bkpt, bool check);
> > +	bool (*is_bkpt_insn)(struct user_bkpt *user_bkpt);
> > +	int (*analyze_insn)(struct task_struct *tsk,
> > +					struct user_bkpt *user_bkpt);
> > +	int (*pre_xol)(struct task_struct *tsk,
> > +				struct user_bkpt *user_bkpt,
> > +				struct user_bkpt_task_arch_info *tskinfo,
> > +				struct pt_regs *regs);
> > +	int (*post_xol)(struct task_struct *tsk,
> > +				struct user_bkpt *user_bkpt,
> > +				struct user_bkpt_task_arch_info *tskinfo,
> > +				struct pt_regs *regs);
> > +};
> 
> Just wondering why these are function pointers.  Do we exepect an
> architecture to provide different versions of these for say 32 vs 64-bit
> binaries?  If not just making these arch provided helpers might be a lot
> simpler.  Especially in the current version where only very few of these
> are overriden by the architecture at all.
> 
> > +unsigned long uprobes_read_vm(struct task_struct *tsk, void __user *vaddr,
> > +					void *kbuf, unsigned long nbytes)


Some of these functions are purely optional example being
validate_address. 

Some of these functions need not be defined by the architecture in
which case we default to the functions defined in common code. 
examples being: read_opcode, set_bkpt, and set_orig_insn.

Some of these functions are architecture mode specific, for example 
there is a architecture specific pre_xol needed for x86_64. However
generic pre_xol for x86_32 would suffice for x86_32.

Some of these functions need to be mandatorily defined by the
architecture. example being set_ip and analyze_insn.

Apart from the above flexibilities and enforcements that we can make
when we use function pointers, its would be handy to incorporate
more enhancements like return probes and booster. 

> > +{
> > +	if (tsk == current) {
> > +		unsigned long nleft = copy_from_user(kbuf, vaddr, nbytes);
> > +		return nbytes - nleft;
> > +	} else
> > +		return access_process_vm(tsk, (unsigned long) vaddr, kbuf,
> > +							nbytes, 0);
> > +}
> > +
> > +unsigned long uprobes_write_data(struct task_struct *tsk,
> > +				void __user *vaddr, const void *kbuf,
> > +				unsigned long nbytes)
> > +{
> > +	unsigned long nleft;
> > +
> > +	if (tsk == current) {
> > +		nleft = copy_to_user(vaddr, kbuf, nbytes);
> > +		return nbytes - nleft;
> > +	} else
> > +		return access_process_vm(tsk, (unsigned long) vaddr,
> > +						(void *) kbuf, nbytes, 1);
> > +}
> 
> Any reason for the naming mismatch between _read_vm and _write_data?

The naming mismatch was on purpose, we wanted to mention that
write_data cannot be used with code sections unlike read_vm which can
be used to read code section.

> 
> Also I wonder if the optimization for tsk == current should be folded
> directly into access_process_vm instead of adding these wrappers.
> 

One reason why we dont want to move this optimization as is into
access_process_vm is we dont want to do a copy_to_user on a code
section. So that would mean another check to determine if its a code
section before we do the optimization. However there could other
reasons why we shouldnt be doing this optimization. Do you still
think we should still be pursuing with the optimization?

--
Thanks and Regards
Srikar
