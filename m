Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757615Ab0KAM6K (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Nov 2010 08:58:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1259 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756039Ab0KAM6J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Nov 2010 08:58:09 -0400
Date: Mon, 1 Nov 2010 14:58:05 +0200
From: Gleb Natapov <gleb@redhat.com>
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Cc: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: [RFC PATCH v2 6/7] KVM: fix the race while wakeup all pv guest
Message-ID: <20101101125805.GE31722@redhat.com>
References: <4CCE8143.3090105@cn.fujitsu.com>
 <4CCE8270.5020300@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CCE8270.5020300@cn.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 01, 2010 at 05:03:44PM +0800, Xiao Guangrong wrote:
> In kvm_async_pf_wakeup_all(), we add a dummy apf to vcpu->async_pf.done
> without holding vcpu->async_pf.lock, it will break if we are handling apfs
> at this time.
> 
This should never happen to well behaved guest, but malicious guest can do it
on purpose.

> Also use 'list_empty_careful()' instead of 'list_empty()'
> 
> Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Acked-by: Gleb Natapov <gleb@redhat.com>

> ---
>  virt/kvm/async_pf.c |    5 ++++-
>  1 files changed, 4 insertions(+), 1 deletions(-)
> 
> diff --git a/virt/kvm/async_pf.c b/virt/kvm/async_pf.c
> index d57ec92..6ef3373 100644
> --- a/virt/kvm/async_pf.c
> +++ b/virt/kvm/async_pf.c
> @@ -200,7 +200,7 @@ int kvm_async_pf_wakeup_all(struct kvm_vcpu *vcpu)
>  {
>  	struct kvm_async_pf *work;
>  
> -	if (!list_empty(&vcpu->async_pf.done))
> +	if (!list_empty_careful(&vcpu->async_pf.done))
>  		return 0;
>  
>  	work = kmem_cache_zalloc(async_pf_cache, GFP_ATOMIC);
> @@ -211,7 +211,10 @@ int kvm_async_pf_wakeup_all(struct kvm_vcpu *vcpu)
>  	get_page(bad_page);
>  	INIT_LIST_HEAD(&work->queue); /* for list_del to work */
>  
> +	spin_lock(&vcpu->async_pf.lock);
>  	list_add_tail(&work->link, &vcpu->async_pf.done);
> +	spin_unlock(&vcpu->async_pf.lock);
> +
>  	vcpu->async_pf.queued++;
>  	return 0;
>  }
> -- 
> 1.7.0.4

--
			Gleb.
