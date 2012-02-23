Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754265Ab2BWMTK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 07:19:10 -0500
Received: from mx1.redhat.com ([209.132.183.28]:22799 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754578Ab2BWMTJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 07:19:09 -0500
Date: Thu, 23 Feb 2012 13:18:05 +0100
From: Anton Arapov <anton@redhat.com>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Jiri Olsa <jolsa@redhat.com>, Josh Stone <jistone@redhat.com>
Subject: Re: [PATCH] uprobes/core: handle breakpoint and signal step
 exception.
Message-ID: <20120223121805.GB2196@bandura.brq.redhat.com>
References: <20120223110245.12459.7391.sendpatchset@srdronam.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120223110245.12459.7391.sendpatchset@srdronam.in.ibm.com>
X-PGP-Key: http://people.redhat.com/aarapov/gpg
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

a super minor comment below.

On Thu, Feb 23, 2012 at 04:32:45PM +0530, Srikar Dronamraju wrote:
> From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
> 
> Uprobes uses exception notifiers to get to know if a thread hit a
> breakpoint or singlestep exception.
> 
[snip]
> ---
>  arch/x86/include/asm/thread_info.h |    2 
>  arch/x86/include/asm/uprobes.h     |   16 ++
>  arch/x86/kernel/signal.c           |    6 +
>  arch/x86/kernel/uprobes.c          |  275 +++++++++++++++++++++++++++++++++++
>  include/linux/sched.h              |    4 +
>  include/linux/uprobes.h            |   44 ++++++
>  kernel/events/uprobes.c            |  279 ++++++++++++++++++++++++++++++++++++
>  kernel/fork.c                      |    7 +
>  kernel/signal.c                    |    6 +
>  9 files changed, 629 insertions(+), 10 deletions(-)
> 
[snip]

> +static void handler_chain(struct uprobe *uprobe, struct pt_regs *regs)
> +{
> +	struct uprobe_consumer *consumer;
> +
> +	if (!(uprobe->flags & UPROBES_RUN_HANDLER))
> +		return;
> +
> +	down_read(&uprobe->consumer_rwsem);
> +	consumer = uprobe->consumers;
The line above is not needed, looks like a leftover. Perhaps Ingo can
cut it before commit.

> +	for (consumer = uprobe->consumers; consumer; consumer = consumer->next) {
> +		if (!consumer->filter || consumer->filter(consumer, current))
> +			consumer->handler(consumer, regs);
> +	}
> +	up_read(&uprobe->consumer_rwsem);
> +}
> +
>  /* Returns the previous consumer */
>  static struct uprobe_consumer *
>  consumer_add(struct uprobe *uprobe, struct uprobe_consumer *consumer)
[snip]

Anton.
