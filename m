Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754325Ab0ISUCx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Sep 2010 16:02:53 -0400
Received: from soto.provo.novell.com ([137.65.250.214]:33432 "EHLO
	soto.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752357Ab0ISUCw convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-ghaskins@novell.com:3:2>);
	Sun, 19 Sep 2010 16:02:52 -0400
Message-Id: <4C9634230200005A00072005@soto.provo.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.2 
Date: Sun, 19 Sep 2010 14:02:43 -0600
From: "Gregory Haskins" <ghaskins@novell.com>
To: "Tejun Heo" <tj@kernel.org>, "Avi Kivity" <avi@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        "Marcelo Tosatti" <mtosatti@redhat.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kvm: fix irqfd assign/deassign race
References: <20100919170231.GA12620@redhat.com>
In-Reply-To: <20100919170231.GA12620@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 9/19/2010 at 01:02 PM, in message <20100919170231.GA12620@redhat.com>,
"Michael S. Tsirkin" <mst@redhat.com> wrote: 
> I think I see the following (theoretical) race:
> 
> During irqfd assign, we drop irqfds lock before we
> schedule inject work. Therefore, deassign running
> on another CPU could cause shutdown and flush to run
> before inject, causing user after free in inject.
> 
> A simple fix it to schedule inject under the lock.

I swear there was some reason why the schedule_work() was done outside of the lock, but I can't for the life of me remember why anymore (it obviously was a failing on my part to _comment_ why if there was such a reason).  So, short of recalling what that reason was, and the fact that Michael's theory seems rational and legit... 

Acked-by: Gregory Haskins <ghaskins@novell.com>

> 
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> ---
> 
> If the issue is real, this might be a 2.6.36 and -stable
> candidate. Comments?
> 
>  virt/kvm/eventfd.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/virt/kvm/eventfd.c b/virt/kvm/eventfd.c
> index 66cf65b..c1f1e3c 100644
> --- a/virt/kvm/eventfd.c
> +++ b/virt/kvm/eventfd.c
> @@ -218,7 +218,6 @@ kvm_irqfd_assign(struct kvm *kvm, int fd, int gsi)
>  	events = file->f_op->poll(file, &irqfd->pt);
>  
>  	list_add_tail(&irqfd->list, &kvm->irqfds.items);
> -	spin_unlock_irq(&kvm->irqfds.lock);
>  
>  	/*
>  	 * Check if there was an event already pending on the eventfd
> @@ -227,6 +226,8 @@ kvm_irqfd_assign(struct kvm *kvm, int fd, int gsi)
>  	if (events & POLLIN)
>  		schedule_work(&irqfd->inject);
>  
> +	spin_unlock_irq(&kvm->irqfds.lock);
> +
>  	/*
>  	 * do not drop the file until the irqfd is fully initialized, otherwise
>  	 * we might race against the POLLHUP




