Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755743Ab2F0JVx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 05:21:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15164 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755139Ab2F0JVu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 05:21:50 -0400
Date: Wed, 27 Jun 2012 12:21:50 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: avi@redhat.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        jan.kiszka@siemens.com
Subject: Re: [PATCH v2 3/6] kvm: Sanitize KVM_IRQFD flags
Message-ID: <20120627092150.GD17507@redhat.com>
References: <20120627044758.23698.249.stgit@bling.home>
 <20120627050924.23698.65802.stgit@bling.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120627050924.23698.65802.stgit@bling.home>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 26, 2012 at 11:09:32PM -0600, Alex Williamson wrote:
> We only know of one so far.
> 
> Signed-off-by: Alex Williamson <alex.williamson@redhat.com>

Ugh. So we have a bug: we should have sanitized the fields.
If there's buggy userspace that only set the low bit
it will break with this change.
Is it too late now? Do we need KVM_IRQFD2 which
sanitized fields properly? Avi?

> ---
> 
>  virt/kvm/eventfd.c |    3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/virt/kvm/eventfd.c b/virt/kvm/eventfd.c
> index c307c24..7d7e2aa 100644
> --- a/virt/kvm/eventfd.c
> +++ b/virt/kvm/eventfd.c
> @@ -340,6 +340,9 @@ kvm_irqfd_deassign(struct kvm *kvm, struct kvm_irqfd *args)
>  int
>  kvm_irqfd(struct kvm *kvm, struct kvm_irqfd *args)
>  {
> +	if (args->flags & ~KVM_IRQFD_FLAG_DEASSIGN)
> +		return -EINVAL;
> +
>  	if (args->flags & KVM_IRQFD_FLAG_DEASSIGN)
>  		return kvm_irqfd_deassign(kvm, args);
>  
