Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755043Ab0DORz4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Apr 2010 13:55:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1885 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754894Ab0DORzz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Apr 2010 13:55:55 -0400
Date: Thu, 15 Apr 2010 14:54:46 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Cc: Avi Kivity <avi@redhat.com>, KVM list <kvm@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 2/5] KVM MMU: fix kvm_mmu_zap_page() and its calling
 path
Message-ID: <20100415175446.GA32413@amt.cnet>
References: <4BC864DD.3000606@cn.fujitsu.com>
 <4BC8652F.5010006@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BC8652F.5010006@cn.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 16, 2010 at 09:25:03PM +0800, Xiao Guangrong wrote:
> - calculate zapped page number properly in mmu_zap_unsync_children()
> - calculate freeed page number properly kvm_mmu_change_mmu_pages()
> 
> Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
> ---
>  arch/x86/kvm/mmu.c |   12 ++++++++----
>  1 files changed, 8 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
> index a23ca75..41cccd4 100644
> --- a/arch/x86/kvm/mmu.c
> +++ b/arch/x86/kvm/mmu.c
> @@ -1481,13 +1481,16 @@ static int mmu_zap_unsync_children(struct kvm *kvm,
>  		struct kvm_mmu_page *sp;
>  
>  		for_each_sp(pages, sp, parents, i) {
> +			if (list_empty(&kvm->arch.active_mmu_pages))
> +				goto exit;

I meant to check for list_empty in kvm_mmu_change_mmu_pages, instead of
relying on the count returned by kvm_mmu_zap_page. Similarly to what 
__kvm_mmu_free_some_pages does.

Checking here is not needed because the pages returned in the array 
will not be zapped (mmu_lock is held).

Applied 1, 4 and 5 (so please regenerate against kvm.git -next branch),
thanks.

