Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755803Ab2HFKRW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 06:17:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14705 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755654Ab2HFKRU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 06:17:20 -0400
Message-ID: <501F99A8.9050006@redhat.com>
Date: Mon, 06 Aug 2012 13:17:12 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Alex Williamson <alex.williamson@redhat.com>
CC: mst@redhat.com, gleb@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, jan.kiszka@siemens.com
Subject: Re: [PATCH v7 2/2] kvm: KVM_EOIFD, an eventfd for EOIs
References: <20120724203628.21081.56884.stgit@bling.home> <20120724204320.21081.32333.stgit@bling.home>
In-Reply-To: <20120724204320.21081.32333.stgit@bling.home>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/24/2012 11:43 PM, Alex Williamson wrote:
> This new ioctl enables an eventfd to be triggered when an EOI is
> written for a specified irqchip pin.  The first user of this will
> be external device assignment through VFIO, using a level irqfd
> for asserting a PCI INTx interrupt and this interface for de-assert
> and notification once the interrupt is serviced.
> 
> Here we make use of the reference counting of the _irq_source
> object allowing us to share it with an irqfd and cleanup regardless
> of the release order.

The name is slightly misleading.  eoifd doesn't trigger on EOI (which is
an APIC->IOAPIC interface) but rather when an interrupt controller
resamples an input line.  This happens for the IOAPIC when an EOI is
received for a vector that is configured for level interrupts and not
masked, or similarly for a PIC (but this is not triggered by an APIC EOI).

It's not a huge difference, but let's document it.

>  
> +4.77 KVM_EOIFD
> +
> +Capability: KVM_CAP_EOIFD
> +Architectures: x86
> +Type: vm ioctl
> +Parameters: struct kvm_eoifd (in)
> +Returns: 0 on success, < 0 on error
> +
> +KVM_EOIFD allows userspace to receive interrupt EOI notification
> +through an eventfd.  kvm_eoifd.fd specifies the eventfd used for
> +notification.  KVM_EOIFD_FLAG_DEASSIGN is used to de-assign an eoifd
> +once assigned.  KVM_EOIFD also requires additional bits set in
> +kvm_eoifd.flags to bind to the proper interrupt line.  The
> +KVM_EOIFD_FLAG_LEVEL_IRQFD indicates that kvm_eoifd.key is provided
> +and is a key from a level triggered interrupt (configured from
> +KVM_IRQFD using KVM_IRQFD_FLAG_LEVEL).  The EOI notification is bound
> +to the same GSI and irqchip input as the irqfd.  Both kvm_eoifd.key
> +and KVM_EOIFD_FLAG_LEVEL_IRQFD must be specified on assignment and
> +de-assignment of KVM_EOIFD.  A level irqfd may only be bound to a
> +single eoifd.  KVM_CAP_EOIFD_LEVEL_IRQFD indicates support of
> +KVM_EOIFD_FLAG_LEVEL_IRQFD.

Why do we need to couple eoifd and irqfd?



-- 
error compiling committee.c: too many arguments to function
