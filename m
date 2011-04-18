Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756003Ab1DRQ6m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 12:58:42 -0400
Received: from casper.infradead.org ([85.118.1.10]:46835 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753092Ab1DRQ6h convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 12:58:37 -0400
Subject: Re: [PATCH v3 2.6.39-rc1-tip 14/26] 14: x86: x86 specific probe
 handling
From: Peter Zijlstra <peterz@infradead.org>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
        Linux-mm <linux-mm@kvack.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Christoph Hellwig <hch@infradead.org>,
        Andi Kleen <andi@firstfloor.org>, Thomas Gleixner <tglx@linutronix.de>,
        Jonathan Corbet <corbet@lwn.net>, Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Roland McGrath <roland@hack.frob.com>,
        SystemTap <systemtap@sources.redhat.com>,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20110401143517.15455.88373.sendpatchset@localhost6.localdomain6>
References: <20110401143223.15455.19844.sendpatchset@localhost6.localdomain6>
	 <20110401143517.15455.88373.sendpatchset@localhost6.localdomain6>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 18 Apr 2011 18:57:56 +0200
Message-ID: <1303145876.32491.892.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-04-01 at 20:05 +0530, Srikar Dronamraju wrote:
> +void arch_uprobe_enable_sstep(struct pt_regs *regs)
> +{
> +       /*
> +        * Enable single-stepping by
> +        * - Set TF on stack
> +        * - Set TIF_SINGLESTEP: Guarantees that TF is set when
> +        *      returning to user mode.
> +        *  - Indicate that TF is set by us.
> +        */
> +       regs->flags |= X86_EFLAGS_TF;
> +       set_thread_flag(TIF_SINGLESTEP);
> +       set_thread_flag(TIF_FORCED_TF);
> +}
> +
> +void arch_uprobe_disable_sstep(struct pt_regs *regs)
> +{
> +       /* Disable single-stepping by clearing what we set */
> +       clear_thread_flag(TIF_SINGLESTEP);
> +       clear_thread_flag(TIF_FORCED_TF);
> +       regs->flags &= ~X86_EFLAGS_TF;
> +} 

Don't you loose the single step flag if userspace was already
single-stepping when it hit your breakpoint? Also, you don't seem to
touch the blockstep settings.
