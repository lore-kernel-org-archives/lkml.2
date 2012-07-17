Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755257Ab2GQKVO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 06:21:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29916 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751898Ab2GQKVK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 06:21:10 -0400
Date: Tue, 17 Jul 2012 13:21:39 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: avi@redhat.com, gleb@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, jan.kiszka@siemens.com
Subject: Re: [PATCH v5 2/4] kvm: KVM_EOIFD, an eventfd for EOIs
Message-ID: <20120717102139.GG7949@redhat.com>
References: <20120716202711.1752.71007.stgit@bling.home>
 <20120716203353.1752.19127.stgit@bling.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120716203353.1752.19127.stgit@bling.home>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 16, 2012 at 02:33:55PM -0600, Alex Williamson wrote:
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

OK so this means eoifd keeps a reference to the irqfd.
And since this is the case, can't we drop the reference counting
around source ids now? Everything is referenced through irqfd.

-- 
MST
