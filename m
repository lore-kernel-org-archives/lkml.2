Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030668Ab2ERC1l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 22:27:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10855 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966624Ab2ERC1i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 22:27:38 -0400
Date: Thu, 17 May 2012 23:22:41 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Xudong Hao <xudong.hao@linux.intel.com>
Cc: avi@redhat.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        haitao.shan@intel.com, xiantao.zhang@intel.com, xudong.hao@intel.com
Subject: Re: [PATCH 4/4] Enabling Access bit when doing memory swapping
Message-ID: <20120518022241.GA14096@amt.cnet>
References: <20120516011230.GE14256@hp-xd.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120516011230.GE14256@hp-xd.sh.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 16, 2012 at 09:12:30AM +0800, Xudong Hao wrote:
> Enabling Access bit when doing memory swapping.
> 
> Signed-off-by: Haitao Shan <haitao.shan@intel.com>
> Signed-off-by: Xudong Hao <xudong.hao@intel.com>
> ---
>  arch/x86/kvm/mmu.c |   13 +++++++------
>  arch/x86/kvm/vmx.c |    6 ++++--
>  2 files changed, 11 insertions(+), 8 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
> index ff053ca..5f55f98 100644
> --- a/arch/x86/kvm/mmu.c
> +++ b/arch/x86/kvm/mmu.c
> @@ -1166,7 +1166,8 @@ static int kvm_age_rmapp(struct kvm *kvm, unsigned long *rmapp,
>     int young = 0;
> 
>     /*
> -    * Emulate the accessed bit for EPT, by checking if this page has
> +    * In case of absence of EPT Access and Dirty Bits supports,
> +    * emulate the accessed bit for EPT, by checking if this page has
>      * an EPT mapping, and clearing it if it does. On the next access,
>      * a new EPT mapping will be established.
>      * This has some overhead, but not as much as the cost of swapping
> @@ -1179,11 +1180,11 @@ static int kvm_age_rmapp(struct kvm *kvm, unsigned long *rmapp,
>     while (spte) {
>         int _young;
>         u64 _spte = *spte;
> -       BUG_ON(!(_spte & PT_PRESENT_MASK));
> -       _young = _spte & PT_ACCESSED_MASK;
> +       BUG_ON(!is_shadow_present_pte(_spte));
> +       _young = _spte & shadow_accessed_mask;
>         if (_young) {
>             young = 1;
> -           clear_bit(PT_ACCESSED_SHIFT, (unsigned long *)spte);
> +           *spte &= ~shadow_accessed_mask;
>         }

Now a dirty bit can be lost. Is there a reason to remove the clear_bit?

