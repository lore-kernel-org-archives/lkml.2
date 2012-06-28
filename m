Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758130Ab2F1DNG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 23:13:06 -0400
Received: from e28smtp04.in.ibm.com ([122.248.162.4]:44249 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756724Ab2F1DND (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 23:13:03 -0400
Message-ID: <4FEBCBB3.3060707@linux.vnet.ibm.com>
Date: Thu, 28 Jun 2012 11:12:51 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>
CC: avi@redhat.com, mtosatti@redhat.com, agraf@suse.de, paulus@samba.org,
        aarcange@redhat.com, kvm@vger.kernel.org, kvm-ppc@vger.kernel.org,
        linux-kernel@vger.kernel.org, takuya.yoshikawa@gmail.com
Subject: Re: [PATCH 5/6] KVM: Separate rmap_pde from kvm_lpage_info->write_count
References: <20120628105733.ccd9abb3.yoshikawa.takuya@oss.ntt.co.jp> <20120628110141.7b908c91.yoshikawa.takuya@oss.ntt.co.jp>
In-Reply-To: <20120628110141.7b908c91.yoshikawa.takuya@oss.ntt.co.jp>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12062803-5564-0000-0000-0000035DEA04
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/28/2012 10:01 AM, Takuya Yoshikawa wrote:
> This makes it possible to loop over rmap_pde arrays in the same way as
> we do over rmap so that we can optimize kvm_handle_hva_range() easily in
> the following patch.
> 
> Signed-off-by: Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>
> ---
>  arch/x86/include/asm/kvm_host.h |    2 +-
>  arch/x86/kvm/mmu.c              |    6 +++---
>  arch/x86/kvm/x86.c              |   11 +++++++++++
>  3 files changed, 15 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 5aab8d4..aea1673 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -499,11 +499,11 @@ struct kvm_vcpu_arch {
>  };
> 
>  struct kvm_lpage_info {
> -	unsigned long rmap_pde;
>  	int write_count;
>  };
> 
>  struct kvm_arch_memory_slot {
> +	unsigned long *rmap_pde[KVM_NR_PAGE_SIZES - 1];
>  	struct kvm_lpage_info *lpage_info[KVM_NR_PAGE_SIZES - 1];
>  };
> 

It looks little complex than before - need manage more alloc-ed/freed buffers.

Why not just introduce a function to get the next rmap? Something like this:

static unsigned long *get_next_rmap(unsigned long *rmap, int level)
{
	struct kvm_lpage_info *linfo

	if (level == 1)
		return rmap++
	
	linfo = container_of(rmap, struct kvm_lpage_info, rmap_pde);
	
	return &(++linfo)->rmap_pde
}

[ Completely untested ]

