Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756328Ab2BGEf2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 23:35:28 -0500
Received: from serv2.oss.ntt.co.jp ([222.151.198.100]:53471 "EHLO
	serv2.oss.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754234Ab2BGEf1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 23:35:27 -0500
Message-ID: <4F30AA7E.3020803@oss.ntt.co.jp>
Date: Tue, 07 Feb 2012 13:37:18 +0900
From: Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.2.25) Gecko/20111213 Thunderbird/3.1.17
MIME-Version: 1.0
To: Liu Ping Fan <kernelfans@gmail.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, avi@redhat.com,
        aliguori@us.ibm.com, gleb@redhat.com, mtosatti@redhat.com,
        xiaoguangrong.eric@gmail.com, jan.kiszka@web.de
Subject: Re: [PATCH v8] kvm: make vcpu life cycle separated from kvm instance
References: <1328582057-31549-1-git-send-email-kernelfans@gmail.com>
In-Reply-To: <1328582057-31549-1-git-send-email-kernelfans@gmail.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2012/02/07 11:34), Liu Ping Fan wrote:

>   static int kvm_vcpu_release(struct inode *inode, struct file *filp)

Is this a hot path?
If no, do you really need to pre-allocate the space for the next vcpus?

>   {
> +	int i;
>   	struct kvm_vcpu *vcpu = filp->private_data;
> +	struct kvm *kvm = vcpu->kvm;
> +	struct kvm_vcpu *vcpus_next;
> +	filp->private_data = NULL;
> +
> +	for (i = 0; i<  atomic_read(&kvm->online_vcpus); i++) {
> +		if (vcpu == kvm->vcpus+i)
> +			break;
> +	}
> +	mutex_lock(&kvm->lock);
> +	vcpus_next =  kvm->vcpus_array +
> +		((kvm->vcpus - kvm->vcpus_array) ? 0 : KVM_MAX_VCPUS);
> +
> +	memset(vcpus_next, 0, KVM_MAX_VCPUS*sizeof(struct kvm_vcpu *));
> +	memcpy(vcpus_next, kvm->vcpus, i*sizeof(struct kvm_vcpu *));
> +	memcpy(vcpus_next+i, kvm->vcpus+i+1,
> +		(atomic_read(&kvm->online_vcpus)-i)*sizeof(struct kvm_vcpu *));
> +	atomic_dec(&kvm->online_vcpus);
> +	/* Removed vcpu can not be seen from vcpus[] */

This comment is confusing.

> +	rcu_assign_pointer(kvm->vcpus, vcpus_next);
> +	mutex_unlock(&kvm->lock);
> +
> +	synchronize_rcu();
> 
> -	kvm_put_kvm(vcpu->kvm);
> +	/* vcpu is out of list,drop it safely */

Ditto.

Do you mean something like
"now that there is no reader of it we can safely free this" ?

(Please do not trust me:  I am not a native English speaker as you know.)

> +	kvm_vcpu_destruct(vcpu);
>   	return 0;
>   }


	Takuya
