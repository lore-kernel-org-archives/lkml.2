Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752863Ab0CQE03 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Mar 2010 00:26:29 -0400
Received: from serv2.oss.ntt.co.jp ([222.151.198.100]:54095 "EHLO
	serv2.oss.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752720Ab0CQE02 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Mar 2010 00:26:28 -0400
Message-ID: <4BA05A92.7090102@oss.ntt.co.jp>
Date: Wed, 17 Mar 2010 13:29:06 +0900
From: Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
CC: Avi Kivity <avi@redhat.com>, KVM list <kvm@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] KVM: cleanup kvm_get_dirty_log()
References: <4BA05040.4000101@cn.fujitsu.com>
In-Reply-To: <4BA05040.4000101@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Xiao Guangrong wrote:
> Using bitmap_empty() to see whether memslot->dirty_bitmap is empty
> 

You can do this for arch specific get_dirty_log() too.

> Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
> ---
>  virt/kvm/kvm_main.c |    6 ++----
>  1 files changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index bcd08b8..497ae14 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -767,8 +767,7 @@ int kvm_get_dirty_log(struct kvm *kvm,
>  			struct kvm_dirty_log *log, int *is_dirty)
>  {
>  	struct kvm_memory_slot *memslot;
> -	int r, i;
> -	int n;
> +	int r, n;
>  	unsigned long any = 0;

any is no longer need to be unsigned long, if you do this?

>  
>  	r = -EINVAL;
> @@ -782,8 +781,7 @@ int kvm_get_dirty_log(struct kvm *kvm,
>  
>  	n = ALIGN(memslot->npages, BITS_PER_LONG) / 8;
>  
> -	for (i = 0; !any && i < n/sizeof(long); ++i)
> -		any = memslot->dirty_bitmap[i];
> +	any = !bitmap_empty(memslot->dirty_bitmap, memslot->npages);
>  
>  	r = -EFAULT;
>  	if (copy_to_user(log->dirty_bitmap, memslot->dirty_bitmap, n))

