Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756890Ab0LBCuI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 21:50:08 -0500
Received: from mx1.redhat.com ([209.132.183.28]:31351 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756480Ab0LBCuD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 21:50:03 -0500
Date: Wed, 1 Dec 2010 23:19:42 -0200
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Cc: Avi Kivity <avi@redhat.com>, Gleb Natapov <gleb@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v3 3/3] KVM: MMU: retry #PF for softmmu
Message-ID: <20101202011942.GA24787@amt.cnet>
References: <4CF4C535.8080405@cn.fujitsu.com>
 <4CF4C5E0.2020301@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CF4C5E0.2020301@cn.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 30, 2010 at 05:37:36PM +0800, Xiao Guangrong wrote:
> Retry #PF for softmmu only when the current vcpu has the same root shadow page
> as the time when #PF occurs. it means they have same paging environment
> 
> Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
> ---
>  arch/x86/include/asm/kvm_host.h |    5 +++++
>  arch/x86/kvm/mmu.c              |   33 ++++++++++++++++++++++++++++++++-
>  arch/x86/kvm/paging_tmpl.h      |   34 +++++++++++++++++++++++-----------
>  arch/x86/kvm/x86.c              |   13 ++++++++++++-
>  virt/kvm/async_pf.c             |    1 +
>  5 files changed, 73 insertions(+), 13 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 209da89..5acbcab 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -191,6 +191,7 @@ union kvm_mmu_page_role {
>  struct kvm_mmu_page {
>  	struct list_head link;
>  	struct hlist_node hash_link;
> +	struct kref apfs_counter;
>  
>  	/*
>  	 * The following two entries are used to key the shadow page in the
> @@ -602,6 +603,7 @@ struct kvm_x86_ops {
>  struct kvm_arch_async_pf {
>  	u32 token;
>  	gfn_t gfn;
> +	struct kvm_mmu_page *root_sp;
>  	bool direct_map;
>  };

Can't you just compare cr3 value? Its harmless to instantiate an spte
for an unused translation.


