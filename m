Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754266Ab2AILfA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jan 2012 06:35:00 -0500
Received: from mx1.redhat.com ([209.132.183.28]:22679 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753732Ab2AILe5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jan 2012 06:34:57 -0500
Date: Mon, 9 Jan 2012 09:16:38 -0200
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Cc: Avi Kivity <avi@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH 1/8] KVM: MMU: combine unsync and unsync_children
Message-ID: <20120109111638.GA5255@amt.cnet>
References: <4EEB19AF.5070501@linux.vnet.ibm.com>
 <4EEB19D6.60101@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4EEB19D6.60101@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 16, 2011 at 06:13:42PM +0800, Xiao Guangrong wrote:
> unsync is only used for the page of level == 1 and unsync_children is only
> used in the upper page, so combine them to reduce the size of shadow page
> structure
> 
> Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
> ---
>  Documentation/virtual/kvm/mmu.txt |    5 ++-
>  arch/x86/include/asm/kvm_host.h   |   14 +++++++++++-
>  arch/x86/kvm/mmu.c                |   39 +++++++++++++++++++++++++-----------
>  arch/x86/kvm/mmu_audit.c          |    6 ++--
>  arch/x86/kvm/mmutrace.h           |    3 +-
>  arch/x86/kvm/paging_tmpl.h        |    2 +-
>  6 files changed, 48 insertions(+), 21 deletions(-)
> 
> diff --git a/Documentation/virtual/kvm/mmu.txt b/Documentation/virtual/kvm/mmu.txt
> index 5dc972c..4a5fedd 100644
> --- a/Documentation/virtual/kvm/mmu.txt
> +++ b/Documentation/virtual/kvm/mmu.txt
> @@ -205,14 +205,15 @@ Shadow pages contain the following information:
>      this page's spt.  Otherwise, parent_ptes points at a data structure
>      with a list of parent_ptes.
>    unsync:
> +    It is used when role.level == 1, only level 1 shadow pages can be unsync.
>      If true, then the translations in this page may not match the guest's
>      translation.  This is equivalent to the state of the tlb when a pte is
>      changed but before the tlb entry is flushed.  Accordingly, unsync ptes
>      are synchronized when the guest executes invlpg or flushes its tlb by
>      other means.  Valid for leaf pages.
>    unsync_children:
> -    How many sptes in the page point at pages that are unsync (or have
> -    unsynchronized children).
> +    It is used when role.level > 1 and indicates how many sptes in the page
> +    point at unsync pages or unsynchronized children.
>    unsync_child_bitmap:
>      A bitmap indicating which sptes in spt point (directly or indirectly) at
>      pages that may be unsynchronized.  Used to quickly locate all unsychronized
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 52d6640..c0a89cd 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -233,9 +233,19 @@ struct kvm_mmu_page {
>  	 * in this shadow page.
>  	 */
>  	DECLARE_BITMAP(slot_bitmap, KVM_MEM_SLOTS_NUM);
> -	bool unsync;
>  	int root_count;          /* Currently serving as active root */
> -	unsigned int unsync_children;
> +
> +	/*
> +	 * If role.level == 1, unsync indicates whether the sp is
> +	 * unsync, otherwise unsync_children indicates the number
> +	 * of sptes which point at unsync sp or unsychronized children.
> +	 * See sp_is_unsync() / sp_unsync_children_num.
> +	 */
> +	union {
> +		bool unsync;
> +		unsigned int unsync_children;
> +	};
> +
>  	unsigned long parent_ptes;	/* Reverse mapping for parent_pte */
>  	DECLARE_BITMAP(unsync_child_bitmap, 512);
> 
> diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
> index 2a2a9b4..6913a16 100644
> --- a/arch/x86/kvm/mmu.c
> +++ b/arch/x86/kvm/mmu.c
> @@ -151,6 +151,21 @@ module_param(dbg, bool, 0644);
> 
>  #define SHADOW_PT_INDEX(addr, level) PT64_INDEX(addr, level)
> 
> +static bool sp_is_unsync(struct kvm_mmu_page *sp)
> +{
> +	return sp->role.level == PT_PAGE_TABLE_LEVEL && sp->unsync;
> +}
> +
> +static unsigned int sp_unsync_children_num(struct kvm_mmu_page *sp)
> +{
> +	unsigned int num = 0;
> +
> +	if (sp->role.level != PT_PAGE_TABLE_LEVEL)
> +		num = sp->unsync_children;
> +
> +	return num;
> +}

This adds significant complexity/trickery to the code for little gain.
For example, in kvm_mmu_page_get, you use sp_is_unsync() which depends
on sp->role.level, but that is not set yet.

In general, given the number of optimizations made to the shadow mmu
code, and the fact that over time NPT will dominate, i'd suggest time
should be spent improving other areas.

