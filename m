Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754156Ab2IYJR1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 05:17:27 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:45939 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750847Ab2IYJR0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 05:17:26 -0400
Date: Tue, 25 Sep 2012 14:19:31 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] uprobes: Change write_opcode() to use FOLL_FORCE
Message-ID: <20120925084931.GA18334@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20120916175210.GA32337@redhat.com>
 <20120916175242.GA32363@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20120916175242.GA32363@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
x-cbid: 12092509-3534-0000-0000-00000D12CF9B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Oleg Nesterov <oleg@redhat.com> [2012-09-16 19:52:42]:

> write_opcode()->get_user_pages() needs FOLL_FORCE to ensure we can
> read the page even if the probed task did mprotect(PROT_NONE) after
> uprobe_register(). Without FOLL_WRITE, FOLL_FORCE doesn't have any
> side effect but allows to read the !VM_READ memory.
> 
> Otherwiese the subsequent uprobe_unregister()->set_orig_insn() fails
> and we leak "int3". If that task does mprotect(PROT_READ | EXEC) and
> execute the probed insn later it will be killed.
> 
> Note: in fact this is also needed for _register, see the next patch.
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>

Acked-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>

> ---
>  kernel/events/uprobes.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
> index 14c2e99..fa1579a 100644
> --- a/kernel/events/uprobes.c
> +++ b/kernel/events/uprobes.c
> @@ -221,7 +221,7 @@ static int write_opcode(struct arch_uprobe *auprobe, struct mm_struct *mm,
> 
>  retry:
>  	/* Read the page with vaddr into memory */
> -	ret = get_user_pages(NULL, mm, vaddr, 1, 0, 0, &old_page, &vma);
> +	ret = get_user_pages(NULL, mm, vaddr, 1, 0, 1, &old_page, &vma);
>  	if (ret <= 0)
>  		return ret;
> 
> -- 
> 1.5.5.1
> 

