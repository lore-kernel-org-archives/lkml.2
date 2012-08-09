Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755697Ab2HINdy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 09:33:54 -0400
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:49326 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754754Ab2HINdw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 09:33:52 -0400
Date: Thu, 9 Aug 2012 19:03:35 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 7/7] uprobes: remove "verify" argument from
 set_orig_insn()
Message-ID: <20120809133335.GB26733@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20120808173659.GA13220@redhat.com>
 <20120808173752.GA13282@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20120808173752.GA13282@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
x-cbid: 12080913-0260-0000-0000-000001A6F33E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Oleg Nesterov <oleg@redhat.com> [2012-08-08 19:37:52]:

> Nobody does set_orig_insn(verify => false), and I think nobody will.
> Remove this argument. IIUC set_orig_insn(verify => false) was needed
> to single-step without xol area.
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>

Acked-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>

> ---
>  include/linux/uprobes.h |    2 +-
>  kernel/events/uprobes.c |   20 +++++++++-----------
>  2 files changed, 10 insertions(+), 12 deletions(-)
> 
> diff --git a/include/linux/uprobes.h b/include/linux/uprobes.h
> index 30297f9..6d4fe79 100644
> --- a/include/linux/uprobes.h
> +++ b/include/linux/uprobes.h
> @@ -102,7 +102,7 @@ struct uprobes_state {
>  };
> 
>  extern int __weak set_swbp(struct arch_uprobe *aup, struct mm_struct *mm, unsigned long vaddr);
> -extern int __weak set_orig_insn(struct arch_uprobe *aup, struct mm_struct *mm,  unsigned long vaddr, bool verify);
> +extern int __weak set_orig_insn(struct arch_uprobe *aup, struct mm_struct *mm, unsigned long vaddr);
>  extern bool __weak is_swbp_insn(uprobe_opcode_t *insn);
>  extern int uprobe_register(struct inode *inode, loff_t offset, struct uprobe_consumer *uc);
>  extern void uprobe_unregister(struct inode *inode, loff_t offset, struct uprobe_consumer *uc);
> diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
> index 81fb2d8..25c0d74 100644
> --- a/kernel/events/uprobes.c
> +++ b/kernel/events/uprobes.c
> @@ -347,24 +347,22 @@ int __weak set_swbp(struct arch_uprobe *auprobe, struct mm_struct *mm, unsigned
>   * @mm: the probed process address space.
>   * @auprobe: arch specific probepoint information.
>   * @vaddr: the virtual address to insert the opcode.
> - * @verify: if true, verify existance of breakpoint instruction.
>   *
>   * For mm @mm, restore the original opcode (opcode) at @vaddr.
>   * Return 0 (success) or a negative errno.
>   */
>  int __weak
> -set_orig_insn(struct arch_uprobe *auprobe, struct mm_struct *mm, unsigned long vaddr, bool verify)
> +set_orig_insn(struct arch_uprobe *auprobe, struct mm_struct *mm, unsigned long vaddr)
>  {
> -	if (verify) {
> -		int result;
> +	int result;
> +
> +	result = is_swbp_at_addr(mm, vaddr);
> +	if (!result)
> +		return -EINVAL;
> 
> -		result = is_swbp_at_addr(mm, vaddr);
> -		if (!result)
> -			return -EINVAL;
> +	if (result != 1)
> +		return result;
> 
> -		if (result != 1)
> -			return result;
> -	}
>  	return write_opcode(auprobe, mm, vaddr, *(uprobe_opcode_t *)auprobe->insn);
>  }
> 
> @@ -699,7 +697,7 @@ install_breakpoint(struct uprobe *uprobe, struct mm_struct *mm,
>  static void
>  remove_breakpoint(struct uprobe *uprobe, struct mm_struct *mm, unsigned long vaddr)
>  {
> -	set_orig_insn(&uprobe->arch, mm, vaddr, true);
> +	set_orig_insn(&uprobe->arch, mm, vaddr);
>  }
> 
>  /*
> -- 
> 1.5.5.1
> 

