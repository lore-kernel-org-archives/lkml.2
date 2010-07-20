Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752150Ab0GTE23 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jul 2010 00:28:29 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:44707 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751593Ab0GTE22 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jul 2010 00:28:28 -0400
Date: Tue, 20 Jul 2010 00:28:14 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Steven Rostedt <rostedt@goodmis.org>,
        Randy Dunlap <rdunlap@xenotime.net>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Christoph Hellwig <hch@infradead.org>,
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
Message-ID: <20100720042814.GA13624@infradead.org>
References: <20100712103214.27491.15142.sendpatchset@localhost6.localdomain6>
 <20100712103235.27491.293.sendpatchset@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100712103235.27491.293.sendpatchset@localhost6.localdomain6>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +struct user_bkpt_arch_info {
> +	void (*set_ip)(struct pt_regs *regs, unsigned long vaddr);
> +	int (*validate_address)(struct task_struct *tsk, unsigned long vaddr);
> +	int (*read_opcode)(struct task_struct *tsk, unsigned long vaddr,
> +						user_bkpt_opcode_t *opcode);
> +	int (*set_bkpt)(struct task_struct *tsk,
> +				struct user_bkpt *user_bkpt);
> +	int (*set_orig_insn)(struct task_struct *tsk,
> +				struct user_bkpt *user_bkpt, bool check);
> +	bool (*is_bkpt_insn)(struct user_bkpt *user_bkpt);
> +	int (*analyze_insn)(struct task_struct *tsk,
> +					struct user_bkpt *user_bkpt);
> +	int (*pre_xol)(struct task_struct *tsk,
> +				struct user_bkpt *user_bkpt,
> +				struct user_bkpt_task_arch_info *tskinfo,
> +				struct pt_regs *regs);
> +	int (*post_xol)(struct task_struct *tsk,
> +				struct user_bkpt *user_bkpt,
> +				struct user_bkpt_task_arch_info *tskinfo,
> +				struct pt_regs *regs);
> +};

Just wondering why these are function pointers.  Do we exepect an
architecture to provide different versions of these for say 32 vs 64-bit
binaries?  If not just making these arch provided helpers might be a lot
simpler.  Especially in the current version where only very few of these
are overriden by the architecture at all.

> +unsigned long uprobes_read_vm(struct task_struct *tsk, void __user *vaddr,
> +					void *kbuf, unsigned long nbytes)
> +{
> +	if (tsk == current) {
> +		unsigned long nleft = copy_from_user(kbuf, vaddr, nbytes);
> +		return nbytes - nleft;
> +	} else
> +		return access_process_vm(tsk, (unsigned long) vaddr, kbuf,
> +							nbytes, 0);
> +}
> +
> +unsigned long uprobes_write_data(struct task_struct *tsk,
> +				void __user *vaddr, const void *kbuf,
> +				unsigned long nbytes)
> +{
> +	unsigned long nleft;
> +
> +	if (tsk == current) {
> +		nleft = copy_to_user(vaddr, kbuf, nbytes);
> +		return nbytes - nleft;
> +	} else
> +		return access_process_vm(tsk, (unsigned long) vaddr,
> +						(void *) kbuf, nbytes, 1);
> +}

Any reason for the naming mismatch between _read_vm and _write_data?

Also I wonder if the optimization for tsk == current should be folded
directly into access_process_vm instead of adding these wrappers.

