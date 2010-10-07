Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760561Ab0JGNLh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Oct 2010 09:11:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57022 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760543Ab0JGNLg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Oct 2010 09:11:36 -0400
Message-ID: <4CADC6C3.3040305@redhat.com>
Date: Thu, 07 Oct 2010 15:10:27 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc13 Thunderbird/3.1.4
MIME-Version: 1.0
To: Gleb Natapov <gleb@redhat.com>
CC: kvm@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        mingo@elte.hu, a.p.zijlstra@chello.nl, tglx@linutronix.de,
        hpa@zytor.com, riel@redhat.com, cl@linux-foundation.org,
        mtosatti@redhat.com
Subject: Re: [PATCH v6 08/12] Handle async PF in a guest.
References: <1286207794-16120-1-git-send-email-gleb@redhat.com> <1286207794-16120-9-git-send-email-gleb@redhat.com>
In-Reply-To: <1286207794-16120-9-git-send-email-gleb@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  On 10/04/2010 05:56 PM, Gleb Natapov wrote:
> When async PF capability is detected hook up special page fault handler
> that will handle async page fault events and bypass other page faults to
> regular page fault handler. Also add async PF handling to nested SVM
> emulation. Async PF always generates exit to L1 where vcpu thread will
> be scheduled out until page is available.
>

Please separate guest and host changes.

> +void kvm_async_pf_task_wait(u32 token)
> +{
> +	u32 key = hash_32(token, KVM_TASK_SLEEP_HASHBITS);
> +	struct kvm_task_sleep_head *b =&async_pf_sleepers[key];
> +	struct kvm_task_sleep_node n, *e;
> +	DEFINE_WAIT(wait);
> +
> +	spin_lock(&b->lock);
> +	e = _find_apf_task(b, token);
> +	if (e) {
> +		/* dummy entry exist ->  wake up was delivered ahead of PF */
> +		hlist_del(&e->link);
> +		kfree(e);
> +		spin_unlock(&b->lock);
> +		return;
> +	}
> +
> +	n.token = token;
> +	n.cpu = smp_processor_id();
> +	init_waitqueue_head(&n.wq);
> +	hlist_add_head(&n.link,&b->list);
> +	spin_unlock(&b->lock);
> +
> +	for (;;) {
> +		prepare_to_wait(&n.wq,&wait, TASK_UNINTERRUPTIBLE);
> +		if (hlist_unhashed(&n.link))
> +			break;
> +		local_irq_enable();

Suppose we take another apf here.  And another, and another (for 
different pages, while executing schedule()).  What's to prevent kernel 
stack overflow?

> +		schedule();
> +		local_irq_disable();
> +	}
> +	finish_wait(&n.wq,&wait);
> +
> +	return;
> +}
> +EXPORT_SYMBOL_GPL(kvm_async_pf_task_wait);
> +
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

