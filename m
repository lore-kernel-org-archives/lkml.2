Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754269Ab1FMRCx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jun 2011 13:02:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41596 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753966Ab1FMRCw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jun 2011 13:02:52 -0400
Date: Mon, 13 Jun 2011 19:00:20 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Steven Rostedt <rostedt@goodmis.org>, Linux-mm <linux-mm@kvack.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Hugh Dickins <hughd@google.com>, Christoph Hellwig <hch@infradead.org>,
        Andi Kleen <andi@firstfloor.org>, Thomas Gleixner <tglx@linutronix.de>,
        Jonathan Corbet <corbet@lwn.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Roland McGrath <roland@hack.frob.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4 3.0-rc2-tip 2/22]  2: uprobes: Breakground page
	replacement.
Message-ID: <20110613170020.GA27137@redhat.com>
References: <20110607125804.28590.92092.sendpatchset@localhost6.localdomain6> <20110607125835.28590.25476.sendpatchset@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110607125835.28590.25476.sendpatchset@localhost6.localdomain6>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/07, Srikar Dronamraju wrote:
>
> +static int write_opcode(struct task_struct *tsk, struct uprobe * uprobe,
> +			unsigned long vaddr, uprobe_opcode_t opcode)
> +{
> +	struct page *old_page, *new_page;
> +	void *vaddr_old, *vaddr_new;
> +	struct vm_area_struct *vma;
> +	unsigned long addr;
> +	int ret;
> +
> +	/* Read the page with vaddr into memory */
> +	ret = get_user_pages(tsk, tsk->mm, vaddr, 1, 1, 1, &old_page, &vma);

Sorry if this was already discussed... But why we are using FOLL_WRITE here?
We are not going to write into this page, and this provokes the unnecessary
cow, no?

Also. This is called under down_read(mmap_sem), can't we race with
access_process_vm() modifying the same memory?

Oleg.

