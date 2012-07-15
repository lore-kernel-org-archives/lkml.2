Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752143Ab2GOQcb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jul 2012 12:32:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14650 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751422Ab2GOQcZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jul 2012 12:32:25 -0400
Date: Sun, 15 Jul 2012 19:32:39 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: avi@redhat.com, gleb@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, jan.kiszka@siemens.com
Subject: Re: [PATCH v4 2/3] kvm: KVM_EOIFD, an eventfd for EOIs
Message-ID: <20120715163238.GB17995@redhat.com>
References: <20120713192625.5474.60777.stgit@bling.home>
 <20120713194103.5474.54352.stgit@bling.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120713194103.5474.54352.stgit@bling.home>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 13, 2012 at 01:41:05PM -0600, Alex Williamson wrote:
> +static int kvm_assign_eoifd(struct kvm *kvm, struct kvm_eoifd *args)
> +{
> +	struct eventfd_ctx *level_irqfd = NULL, *eventfd = NULL;
> +	struct _eoifd *eoifd = NULL;
> +	struct _irq_source *source = NULL;
> +	unsigned gsi;
> +	int ret;
> +
> +	eventfd = eventfd_ctx_fdget(args->fd);
> +	if (IS_ERR(eventfd)) {
> +		ret = PTR_ERR(eventfd);
> +		goto fail;
> +	}
> +
> +	eoifd = kzalloc(sizeof(*eoifd), GFP_KERNEL);
> +	if (!eoifd) {
> +		ret = -ENOMEM;
> +		goto fail;
> +	}
> +
> +	if (args->flags & KVM_EOIFD_FLAG_LEVEL_IRQFD) {
> +		struct _irqfd *irqfd = _irqfd_fdget_lock(kvm, args->irqfd);
> +		if (IS_ERR(irqfd)) {
> +			ret = PTR_ERR(irqfd);
> +			goto fail;
> +		}
> +
> +		gsi = irqfd->gsi;
> +		level_irqfd = eventfd_ctx_get(irqfd->eventfd);
> +		source = _irq_source_get(irqfd->source);
> +		_irqfd_put_unlock(irqfd);
> +		if (!source) {
> +			ret = -EINVAL;
> +			goto fail;
> +		}
> +	} else {
> +		ret = -EINVAL;
> +		goto fail;
> +	}
> +
> +	INIT_LIST_HEAD(&eoifd->list);
> +	eoifd->kvm = kvm;
> +	eoifd->eventfd = eventfd;
> +	eoifd->source = source;
> +	eoifd->level_irqfd = level_irqfd;
> +	eoifd->notifier.gsi = gsi;
> +	eoifd->notifier.irq_acked = eoifd_event;
> +
> +	mutex_lock(&kvm->eoifds.lock);
> +
> +	list_add_tail(&eoifd->list, &kvm->eoifds.items);

Do we want to disallow multiple eventfds mapping the same irqfd?
No strong opinions but preventing this might make it possible to cache
the callback in the irqfd in the future.

This will also help limit the number of eoifd-s to 1024 GSIs * 32 source ids.
As it is userspace can apparently consume unlimited kernel memory.
