Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757377Ab2E3SG0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 14:06:26 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:47224 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757279Ab2E3SGW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 14:06:22 -0400
Date: Wed, 30 May 2012 23:34:09 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Oleg Nesterov <oleg@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] uprobes: install_breakpoint() should fail if
 is_swbp_insn() == T
Message-ID: <20120530180409.GO15587@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20120530165757.GA8077@redhat.com>
 <20120530165816.GA8085@redhat.com>
 <1338398931.28384.7.camel@twins>
 <20120530173717.GM15587@linux.vnet.ibm.com>
 <1338400142.28384.12.camel@twins>
 <1338400450.28384.16.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1338400450.28384.16.camel@twins>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12053018-7182-0000-0000-000001A1BE16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> So its the -EEXIST from set_swbp() that I was thinking about. I think I
> was also wrong on the reason that that can happen. register's vma
> iteration is very careful not to have the same vma twice, but it can
> race against mmap() because of the uprobe_hash() vs uprobe_mmap_hash()
> madness, right?


right. 

> 
> Something like so?
> 
> ---
>  kernel/events/uprobes.c |   16 ++++++++++++++++
>  1 file changed, 16 insertions(+)
> 
> diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
> index 985be4d..b4e749e 100644
> --- a/kernel/events/uprobes.c
> +++ b/kernel/events/uprobes.c
> @@ -45,6 +45,19 @@ static DEFINE_SPINLOCK(uprobes_treelock);	/* serialize rbtree access */
>  
>  #define UPROBES_HASH_SZ	13
>  
> +/*
> + * We need separate register/unregister and mmap/munmap lock hashes because of
> + * mmap_sem nesting.
> + *
> + * {,un}egister_uprobe() needs to install probes on (potentially) all processes
> + * and thus need to acquire multiple mmap_sems (consecutively, not
> + * concurrently), whereas uprobe_m{,un}map() is called while holding mmap_sem
> + * for the particular process doing the mmap.
> + *
> + * This all means that register_uprobe() can race with uprobe_mmap() and we
> + * can try and install a probe where one is already installed.
> + */

Nit: {,un}egister_uprobe should have been uprobe_{,un}register  at
couple of places.

> +
>  /* serialize (un)register */
>  static struct mutex uprobes_mutex[UPROBES_HASH_SZ];
>  
> @@ -356,6 +369,9 @@ int __weak set_swbp(struct arch_uprobe *auprobe, struct mm_struct *mm, unsigned
>  {
>  	int result;
>  
> +	/*
> +	 * See the comment near uprobes_hash().
> +	 */
>  	result = is_swbp_at_addr(mm, vaddr);
>  	if (result == 1)
>  		return -EEXIST;
> 

