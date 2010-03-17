Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753557Ab0CQIPJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Mar 2010 04:15:09 -0400
Received: from serv2.oss.ntt.co.jp ([222.151.198.100]:35309 "EHLO
	serv2.oss.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752025Ab0CQIPF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Mar 2010 04:15:05 -0400
Message-ID: <4BA09023.4000706@oss.ntt.co.jp>
Date: Wed, 17 Mar 2010 17:17:39 +0900
From: Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
CC: Avi Kivity <avi@redhat.com>, KVM list <kvm@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] KVM: cleanup {kvm_vm_ioctl, kvm}_get_dirty_log()
References: <4BA0897F.3050906@cn.fujitsu.com>
In-Reply-To: <4BA0897F.3050906@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Xiao Guangrong wrote:
> Using bitmap_empty() to see whether memslot->dirty_bitmap is empty 
> 
> Changlog:
> cleanup x86 specific kvm_vm_ioctl_get_dirty_log() and fix a local
> parameter's type address Takuya Yoshikawa's suggestion

Oh, for such a tiny comment.

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

What I said was just you may be able to use bitmap_empty() instead of

 > -	for (i = 0; !is_dirty && i < n/sizeof(long); i++)
 > -		is_dirty = memslot->dirty_bitmap[i];

for x86's code too, if your patch for kvm_get_dirty_log() was correct.

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
>  	n = ALIGN(memslot->npages, BITS_PER_LONG) / 8;
>  
>  	r = -ENOMEM;
> @@ -2668,9 +2663,6 @@ int kvm_vm_ioctl_get_dirty_log(struct kvm *kvm,
>  		goto out;
>  	memset(dirty_bitmap, 0, n);
>  
> -	for (i = 0; !is_dirty && i < n/sizeof(long); i++)
> -		is_dirty = memslot->dirty_bitmap[i];
> -
>  	/* If nothing is dirty, don't bother messing with page tables. */
>  	if (is_dirty) {
>  		struct kvm_memslots *slots, *old_slots;
> @@ -2694,8 +2686,7 @@ int kvm_vm_ioctl_get_dirty_log(struct kvm *kvm,
>  	}
>  
>  	r = 0;
> -	if (copy_to_user(log->dirty_bitmap, dirty_bitmap, n))
> -		r = -EFAULT;
> +
>  out_free:
>  	vfree(dirty_bitmap);
>  out:
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
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
>  
>  	r = -EFAULT;
>  	if (copy_to_user(log->dirty_bitmap, memslot->dirty_bitmap, n))

