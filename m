Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753165Ab2F1T3d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2012 15:29:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57347 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751399Ab2F1T3b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2012 15:29:31 -0400
Date: Thu, 28 Jun 2012 22:29:27 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: avi@redhat.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        jan.kiszka@siemens.com
Subject: Re: [PATCH v2 5/6] kvm: KVM_EOIFD, an eventfd for EOIs
Message-ID: <20120628192927.GB14787@redhat.com>
References: <20120627044758.23698.249.stgit@bling.home>
 <20120627050952.23698.37235.stgit@bling.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120627050952.23698.37235.stgit@bling.home>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 26, 2012 at 11:10:08PM -0600, Alex Williamson wrote:
> diff --git a/Documentation/virtual/kvm/api.txt b/Documentation/virtual/kvm/api.txt
> index b216709..87a2558 100644
> --- a/Documentation/virtual/kvm/api.txt
> +++ b/Documentation/virtual/kvm/api.txt
> @@ -1987,6 +1987,30 @@ interrupts with those injected through KVM_IRQ_LINE.  IRQFDs created
>  with KVM_IRQFD_FLAG_LEVEL must also set this flag when de-assiging.
>  KVM_IRQFD_FLAG_LEVEL support is indicated by KVM_CAP_IRQFD_LEVEL.
>  
> +4.77 KVM_EOIFD
> +
> +Capability: KVM_CAP_EOIFD
> +Architectures: x86
> +Type: vm ioctl
> +Parameters: struct kvm_eoifd (in)
> +Returns: 0 on success, -1 on error
> +
> +KVM_EOIFD allows userspace to receive EOI notification through an
> +eventfd for level triggered irqchip interrupts.  Behavior for edge
> +triggered interrupts is undefined.  kvm_eoifd.fd specifies the eventfd
> +used for notification and kvm_eoifd.gsi specifies the irchip pin,
> +similar to KVM_IRQFD.  KVM_EOIFD_FLAG_DEASSIGN is used to deassign
> +a previously enabled eoifd and should also set fd and gsi to match.
> +
> +The KVM_EOIFD_FLAG_LEVEL_IRQFD flag indicates that the EOI is for
> +a level triggered EOI and the kvm_eoifd structure includes
> +kvm_eoifd.irqfd, which must be previously configured using KVM_IRQFD
> +with the KVM_IRQFD_FLAG_LEVEL flag.  This allows both EOI notification
> +through kvm_eoifd.fd as well as automatically de-asserting level
> +irqfds on EOI.  Both KVM_EOIFD_FLAG_DEASSIGN and
> +KVM_EOIFD_FLAG_LEVEL_IRQFD should be used to de-assign an eoifd
> +initially setup with KVM_EOIFD_FLAG_LEVEL_IRQFD.
> +

OK so thinking about this some more, does the below makes sense:
it is enough to have LEVEL either in IRQFD or in EOIFD but not both.
I weakly prefer it in EOIFD: when you bind it to irqfd you
also assign a source id to that irqfd.

We also can make is a bit clearer: rename KVM_EOIFD_FLAG_LEVEL_IRQFD
to KVM_EOIFD_FLAG_LEVEL_CLEAR which makes it explicit that we clear
on EOI and that it is for a level interrupt. The fact that it needs
an irqfd is less important IMHO.
Make this flag mandatory for now, we'll see later how to handle
vcpu filtering and edge.

How does it sound?

-- 
MST
