Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755122Ab2DNDCA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2012 23:02:00 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:40485 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753989Ab2DNDB6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2012 23:01:58 -0400
Date: Sat, 14 Apr 2012 12:01:53 +0900
From: Takuya Yoshikawa <takuya.yoshikawa@gmail.com>
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Cc: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v2 10/16] KVM: MMU: fask check whether page is writable
Message-Id: <20120414120153.76c3afca3726c14d10581a6c@gmail.com>
In-Reply-To: <4F87FC82.2050302@linux.vnet.ibm.com>
References: <4F87FA69.5060106@linux.vnet.ibm.com>
	<4F87FC82.2050302@linux.vnet.ibm.com>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 13 Apr 2012 18:14:26 +0800
Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com> wrote:

> Using bit 1 (PTE_LIST_WP_BIT) in rmap store the write-protect status
> to avoid unnecessary shadow page walking
> 
> Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
> ---
>  arch/x86/kvm/mmu.c |   40 ++++++++++++++++++++++++++++++++++------
>  1 files changed, 34 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
> index 0c6e92d..8b71908 100644
> --- a/arch/x86/kvm/mmu.c
> +++ b/arch/x86/kvm/mmu.c
> @@ -796,7 +796,9 @@ static int mapping_level(struct kvm_vcpu *vcpu, gfn_t large_gfn)
>  	return level - 1;
>  }
> 
> -#define PTE_LIST_DESC		(0x1ull)
> +#define PTE_LIST_DESC_BIT	0
> +#define PTE_LIST_WP_BIT	1

_BIT ?

> +#define PTE_LIST_DESC		(1 << PTE_LIST_DESC_BIT)
>  #define PTE_LIST_FLAG_MASK	(0x3ull)
> 

Well, I think that rmap is losing its original meaning:
Before, it held just the information needed to link spteps.

Now it has more roles, and getting kind of descriptor?

...

> @@ -2291,9 +2310,15 @@ static int mmu_need_write_protect(struct kvm_vcpu *vcpu, gfn_t gfn,
>  {
>  	struct kvm_mmu_page *s;
>  	struct hlist_node *node;
> +	unsigned long *rmap;
>  	bool need_unsync = false;
> 
> +	rmap = gfn_to_rmap(vcpu->kvm, gfn, PT_PAGE_TABLE_LEVEL);

Please use consistent variable names.

In other parts of this patch, you are using rmapp for this.

	Takuya
