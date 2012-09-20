Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753644Ab2ITOAb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 10:00:31 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:48557 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751360Ab2ITOA1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 10:00:27 -0400
Date: Thu, 20 Sep 2012 19:23:51 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/5] uprobes: Do not leak UTASK_BP_HIT if
 find_active_uprobe() fails
Message-ID: <20120920135351.GA27880@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20120914171513.GA29599@redhat.com>
 <20120914171551.GA29632@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20120914171551.GA29632@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12092014-4242-0000-0000-000002F6A9BD
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> If handle_swbp()->find_active_uprobe() fails we return with
> utask->state = UTASK_BP_HIT.
> 
> Change handle_swbp() to reset utask->state at the start. Note
> that we do this unconditionally, see the next patch(es).
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>
> ---
>  kernel/events/uprobes.c |    5 ++++-
>  1 files changed, 4 insertions(+), 1 deletions(-)
> 
> diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
> index 26f06a6..760acc1 100644
> --- a/kernel/events/uprobes.c
> +++ b/kernel/events/uprobes.c
> @@ -1468,6 +1468,10 @@ static void handle_swbp(struct pt_regs *regs)
>  	bp_vaddr = uprobe_get_swbp_addr(regs);
>  	uprobe = find_active_uprobe(bp_vaddr, &is_swbp);
> 
> +	utask = current->utask;
> +	if (utask)
> +		utask->state = UTASK_RUNNING;
> +
>  	if (!uprobe) {
>  		if (is_swbp > 0) {
>  			/* No matching uprobe; signal SIGTRAP. */
> @@ -1486,7 +1490,6 @@ static void handle_swbp(struct pt_regs *regs)
>  		return;
>  	}
> 
> -	utask = current->utask;
>  	if (!utask) {
>  		utask = add_utask();
>  		/* Cannot allocate; re-execute the instruction. */


Acked-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>

