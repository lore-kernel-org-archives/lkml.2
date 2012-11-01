Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761435Ab2KANDd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2012 09:03:33 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:39469 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755662Ab2KANDa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2012 09:03:30 -0400
Date: Thu, 1 Nov 2012 09:03:10 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mukesh Rathor <mukesh.rathor@oracle.com>
Subject: Re: linux-next: manual merge of the tmem tree with the xen-two tree
Message-ID: <20121101130310.GA11029@localhost.localdomain>
References: <20121101144059.a8350c24499f1beffe59a64a@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121101144059.a8350c24499f1beffe59a64a@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 01, 2012 at 02:40:59PM +1100, Stephen Rothwell wrote:
> Hi Konrad,
> 
> Today's linux-next merge of the tmem tree got conflicts in
> arch/x86/include/asm/xen/interface.h and drivers/xen/cpu_hotplug.c
> between commit 6c6067f26388 ("xen/pvh: Extend vcpu_guest_context, p2m,
> event, and XenBus") from the xen-two tree and commit 7282a68f5aea ("PVH:
> Basic and preparatory changes") from the tmem tree.
> 
> I fixed it up (see below and using the xen-two version for cpu_hotplug.c)
> and can carry the fix as necessary (no action is required).

Thank you.

I am not really sure how this happen - the 'tmem' tree should not have
had 7282a68f5aea, and more interestingly, I cannot find it in the
tmem tree! Either way, let me just reset the #linux-next to v3.7-rc3
in tmem tree and see if this shows up.

> 
> -- 
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
> 
> diff --cc arch/x86/include/asm/xen/interface.h
> index 20e738a,104fa50..0000000
> --- a/arch/x86/include/asm/xen/interface.h
> +++ b/arch/x86/include/asm/xen/interface.h
> @@@ -145,16 -136,8 +145,17 @@@ struct vcpu_guest_context 
>       struct cpu_user_regs user_regs;         /* User-level CPU registers     */
>       struct trap_info trap_ctxt[256];        /* Virtual IDT                  */
>       unsigned long ldt_base, ldt_ents;       /* LDT (linear address, # ents) */
>  -    unsigned long gdt_frames[16], gdt_ents; /* GDT (machine frames, # ents).*
>  -					     * PV in HVM: it's GDTR addr/sz */
>  +    union {
>  +	struct {
> - 		/* PV: GDT (machine frames, # ents).*/
> ++		/* PV: GDT (machine frames, # ents).
> ++		 * PV in HVM: it's GDTR addr/sz */
>  +		unsigned long gdt_frames[16], gdt_ents;
>  +	} pv;
>  +	struct {
>  +		/* PVH: GDTR addr and size */
>  +		unsigned long gdtaddr, gdtsz;
>  +	} pvh;
>  +    } u;
>       unsigned long kernel_ss, kernel_sp;     /* Virtual TSS (only SS1/SP1)   */
>       /* NB. User pagetable on x86/64 is placed in ctrlreg[1]. */
>       unsigned long ctrlreg[8];               /* CR0-CR7 (control registers)  */


