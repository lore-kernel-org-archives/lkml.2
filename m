Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756420Ab0KRJz6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 04:55:58 -0500
Received: from mx1.redhat.com ([209.132.183.28]:25923 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755137Ab0KRJz4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 04:55:56 -0500
Message-ID: <4CE4F823.8030804@redhat.com>
Date: Thu, 18 Nov 2010 11:55:47 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101103 Fedora/1.0-0.33.b2pre.fc14 Lightning/1.0b3pre Thunderbird/3.1.6
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, Gleb Natapov <gleb@redhat.com>,
        Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>,
        Gregory Haskins <ghaskins@novell.com>,
        Chris Lalancette <clalance@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC] kvm: fast-path msi injection with irqfd
References: <20101117221254.GA8296@redhat.com>
In-Reply-To: <20101117221254.GA8296@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/18/2010 12:12 AM, Michael S. Tsirkin wrote:
> Store irq routing table pointer in the irqfd object,
> and use that to inject MSI directly without bouncing out to
> a kernel thread.
>
> While we touch this structure, rearrange irqfd fields to make fastpath
> better packed for better cache utilization.
>
> Some notes on the design:
> - Use pointer into the rt instead of copying an entry,
>    to make it possible to use rcu, thus side-stepping
>    locking complexities.  We also save some memory this way.
> - Old workqueue code is still used for level irqs.
>    I don't think we DTRT with level anyway, however,
>    it seems easier to keep the code around as
>    it has been thought through and debugged, and fix level later than
>    rip out and re-instate it later.
>
>

> @@ -166,6 +178,7 @@ irqfd_ptable_queue_proc(struct file *file, wait_queue_head_t *wqh,
>   static int
>   kvm_irqfd_assign(struct kvm *kvm, int fd, int gsi)
>   {
> +	struct kvm_irq_routing_table *irq_rt;
>   	struct _irqfd *irqfd, *tmp;
>   	struct file *file = NULL;
>   	struct eventfd_ctx *eventfd = NULL;
> @@ -215,6 +228,10 @@ kvm_irqfd_assign(struct kvm *kvm, int fd, int gsi)
>   		goto fail;
>   	}
>
> +	rcu_read_lock();
> +	irqfd_update(kvm, irqfd, rcu_dereference(kvm->irq_routing));
> +	rcu_read_unlock();

Wow, complicated.  rcu_read_lock() protects kvm->irq_routing, while 
we're in the update side of rcu-protected irqfd->irq_entry.

A comment please.

The rest looks good, it's nice we finally got the irq injection path so 
streamlined.

-- 
error compiling committee.c: too many arguments to function

