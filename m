Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752102Ab0CRCux (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Mar 2010 22:50:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40103 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751945Ab0CRCuq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Mar 2010 22:50:46 -0400
Date: Wed, 17 Mar 2010 23:48:52 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Cc: Avi Kivity <avi@redhat.com>,
       Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>,
       KVM list <kvm@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] KVM: cleanup {kvm_vm_ioctl, kvm}_get_dirty_log()
Message-ID: <20100318024852.GA23995@amt.cnet>
References: <4BA0897F.3050906@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BA0897F.3050906@cn.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 17, 2010 at 03:49:19PM +0800, Xiao Guangrong wrote:
> Using bitmap_empty() to see whether memslot->dirty_bitmap is empty 
> 
> Changlog:
> cleanup x86 specific kvm_vm_ioctl_get_dirty_log() and fix a local
> parameter's type address Takuya Yoshikawa's suggestion
> 
> Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
> ---
>  arch/x86/kvm/x86.c  |   17 ++++-------------
>  virt/kvm/kvm_main.c |    7 ++-----
>  2 files changed, 6 insertions(+), 18 deletions(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index bcf52d1..e6cbbd4 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -2644,22 +2644,17 @@ static int kvm_vm_ioctl_reinject(struct kvm *kvm,
>  int kvm_vm_ioctl_get_dirty_log(struct kvm *kvm,
>  				      struct kvm_dirty_log *log)
>  {
> -	int r, n, i;
> +	int r, n, is_dirty = 0;
>  	struct kvm_memory_slot *memslot;
> -	unsigned long is_dirty = 0;
>  	unsigned long *dirty_bitmap = NULL;
>  
>  	mutex_lock(&kvm->slots_lock);
>  
> -	r = -EINVAL;
> -	if (log->slot >= KVM_MEMORY_SLOTS)
> +	r = kvm_get_dirty_log(kvm, log, &is_dirty);
> +	if (r)
>  		goto out;
>  
>  	memslot = &kvm->memslots->memslots[log->slot];
> -	r = -ENOENT;
> -	if (!memslot->dirty_bitmap)
> -		goto out;
> -

Its different because the user copy must be done after the 
SRCU assignment.

> index bcd08b8..b08a7de 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -767,9 +767,7 @@ int kvm_get_dirty_log(struct kvm *kvm,
>  			struct kvm_dirty_log *log, int *is_dirty)
>  {
>  	struct kvm_memory_slot *memslot;
> -	int r, i;
> -	int n;
> -	unsigned long any = 0;
> +	int r, n, any = 0;
>  
>  	r = -EINVAL;
>  	if (log->slot >= KVM_MEMORY_SLOTS)
> @@ -782,8 +780,7 @@ int kvm_get_dirty_log(struct kvm *kvm,
>  
>  	n = ALIGN(memslot->npages, BITS_PER_LONG) / 8;
>  
> -	for (i = 0; !any && i < n/sizeof(long); ++i)
> -		any = memslot->dirty_bitmap[i];
> +	any = !bitmap_empty(memslot->dirty_bitmap, memslot->npages);

The opencoded version should be faster in comparison to __bitmap_empty 
because the dirty bitmaps are always unsigned long aligned (and also
there's a function call).

