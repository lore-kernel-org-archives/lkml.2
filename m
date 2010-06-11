Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932564Ab0FKUfX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jun 2010 16:35:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25751 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757970Ab0FKUfS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jun 2010 16:35:18 -0400
Date: Fri, 11 Jun 2010 16:46:48 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Avi Kivity <avi@redhat.com>, kvm@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] kvm,ept: pass error code to handler
Message-ID: <20100611194648.GB12317@amt.cnet>
References: <4C121E50.6050402@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C121E50.6050402@cn.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 11, 2010 at 07:30:24PM +0800, Lai Jiangshan wrote:
> handle_ept_violation() does not pass error code to
> the handler tdp_page_fault().
> 
> It means tdp_page_fault() handles the page fault with ignoring
> the error code, It will not handle the page fault completely correctly,
> and may causes endless page fault.
> 
> {
> But because there is another bad code in the kvm, This endless page faulting
> never occur. The bad code: kvm always set pte writable.
> 
> negative * negative = positive, WTF!!
> 
> Next patch will fix this bad code.
> }
> 
> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
> ---
> diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
> index c7565ea..6362dcc 100644
> --- a/arch/x86/kvm/vmx.c
> +++ b/arch/x86/kvm/vmx.c
> @@ -3470,7 +3470,7 @@ static int handle_ept_violation(struct kvm_vcpu *vcpu)
>  
>  	gpa = vmcs_read64(GUEST_PHYSICAL_ADDRESS);
>  	trace_kvm_page_fault(gpa, exit_qualification);
> -	return kvm_mmu_page_fault(vcpu, gpa & PAGE_MASK, 0);
> +	return kvm_mmu_page_fault(vcpu, gpa & PAGE_MASK, exit_qualification);

exit_qualification & 0x2, because bit 1 (write fault) of exit
qualification is the only one that matches x86's pagefault error codes.
