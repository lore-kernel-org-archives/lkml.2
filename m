Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755115Ab1FTQOv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 12:14:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14508 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753831Ab1FTQOs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 12:14:48 -0400
Date: Mon, 20 Jun 2011 13:14:32 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Cc: Avi Kivity <avi@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH 04/15] KVM: MMU: cache mmio info on page fault path
Message-ID: <20110620161432.GA17130@amt.cnet>
References: <4DEE205E.8000601@cn.fujitsu.com>
 <4DEE20EE.7060000@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DEE20EE.7060000@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 07, 2011 at 09:00:30PM +0800, Xiao Guangrong wrote:
> If the page fault is caused by mmio, we can cache the mmio info, later, we do
> not need to walk guest page table and quickly know it is a mmio fault while we
> emulate the mmio instruction
> 
> Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
> ---
>  arch/x86/include/asm/kvm_host.h |    5 +++
>  arch/x86/kvm/mmu.c              |   21 +++++----------
>  arch/x86/kvm/mmu.h              |   23 +++++++++++++++++
>  arch/x86/kvm/paging_tmpl.h      |   21 ++++++++++-----
>  arch/x86/kvm/x86.c              |   52 ++++++++++++++++++++++++++++++--------
>  arch/x86/kvm/x86.h              |   36 +++++++++++++++++++++++++++
>  6 files changed, 126 insertions(+), 32 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index d167039..326af42 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -414,6 +414,11 @@ struct kvm_vcpu_arch {
>  	u64 mcg_ctl;
>  	u64 *mce_banks;
>  
> +	/* Cache MMIO info */
> +	u64 mmio_gva;
> +	unsigned access;
> +	gfn_t mmio_gfn;
> +
>  	/* used for guest single stepping over the given code position */
>  	unsigned long singlestep_rip;
>  

Why you're not implementing the original idea to cache the MMIO
attribute of an address into the spte?

That solution is wider reaching than a one-entry cache, and was proposed
to overcome large number of memslots.

If the access pattern switches between different addresses this one
solution is doomed.

