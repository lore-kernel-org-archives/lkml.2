Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756943Ab2FOQkY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2012 12:40:24 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:48308 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755043Ab2FOQkX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2012 12:40:23 -0400
Date: Fri, 15 Jun 2012 22:06:01 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 11/15] uprobes: move BUG_ON(UPROBE_SWBP_INSN_SIZE) from
 write_opcode() to install_breakpoint()
Message-ID: <20120615163600.GA10922@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20120615154241.GA9524@redhat.com>
 <20120615154350.GA9611@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20120615154350.GA9611@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12061516-7408-0000-0000-000005E2E676
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> 
> diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
> index 14c71a2..b9c61bd 100644
> --- a/kernel/events/uprobes.c
> +++ b/kernel/events/uprobes.c
> @@ -210,7 +210,6 @@ static int write_opcode(struct arch_uprobe *auprobe, struct mm_struct *mm,
>  	void *vaddr_old, *vaddr_new;
>  	struct vm_area_struct *vma;
>  	struct uprobe *uprobe;
> -	unsigned long pgoff;
>  	int ret;
>  retry:
>  	/* Read the page with vaddr into memory */
> @@ -251,11 +250,7 @@ retry:
>  	vaddr_new = kmap_atomic(new_page);
> 
>  	memcpy(vaddr_new, vaddr_old, PAGE_SIZE);
> -
> -	/* poke the new insn in, ASSUMES we don't cross page boundary */
> -	pgoff = (vaddr & ~PAGE_MASK);
> -	BUG_ON(pgoff + UPROBE_SWBP_INSN_SIZE > PAGE_SIZE);
> -	memcpy(vaddr_new + pgoff, &opcode, UPROBE_SWBP_INSN_SIZE);
> +	memcpy(vaddr_new + (vaddr & ~PAGE_MASK), &opcode, UPROBE_SWBP_INSN_SIZE);
> 
>  	kunmap_atomic(vaddr_new);
>  	kunmap_atomic(vaddr_old);
> @@ -699,6 +694,10 @@ install_breakpoint(struct uprobe *uprobe, struct mm_struct *mm,
>  		if (ret)
>  			return ret;
> 
> +		/* write_opcode() assumes we don't cross page boundary */
> +		BUG_ON((uprobe->offset & ~PAGE_MASK) +
> +				UPROBE_SWBP_INSN_SIZE > PAGE_SIZE);
> +
>  		uprobe->flags |= UPROBE_COPY_INSN;
>  	}

I am now thinking if we really need a BUG_ON? I am now thinking I should
have had a check at the start in uprobe_register() and failed the request. 

Something like 
	if ((offset & ~PAGE_MASK) + UPROBE_SWBP_INSN_SIZE > PAGE_SIZE)
		return -EINVAL;
-- 
Thanks and Regards
Srikar

