Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753796Ab0LFQVz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 11:21:55 -0500
Received: from mx1.redhat.com ([209.132.183.28]:19520 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753728Ab0LFQVx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 11:21:53 -0500
Message-ID: <4CFD0D91.3050303@redhat.com>
Date: Mon, 06 Dec 2010 18:21:37 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101103 Fedora/1.0-0.33.b2pre.fc14 Lightning/1.0b3pre Thunderbird/3.1.6
MIME-Version: 1.0
To: Jan Kiszka <jan.kiszka@web.de>
CC: Thomas Gleixner <tglx@linutronix.de>,
        Marcelo Tosatti <mtosatti@redhat.com>, linux-kernel@vger.kernel.org,
        kvm <kvm@vger.kernel.org>, Tom Lyon <pugs@cisco.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jan Kiszka <jan.kiszka@siemens.com>
Subject: Re: [PATCH 5/5] KVM: Allow host IRQ sharing for passed-through PCI
 2.3 devices
References: <cover.1291419444.git.jan.kiszka@web.de> <10b9265d513950f2574edf4e79be3b808e741a78.1291419444.git.jan.kiszka@web.de>
In-Reply-To: <10b9265d513950f2574edf4e79be3b808e741a78.1291419444.git.jan.kiszka@web.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/04/2010 01:37 AM, Jan Kiszka wrote:
> From: Jan Kiszka<jan.kiszka@siemens.com>
>
> PCI 2.3 allows to generically disable IRQ sources at device level. This
> enables us to share IRQs of such devices on the host side when passing
> them to a guest.
>
> However, IRQ disabling via the PCI config space is more costly than
> masking the line via disable_irq. Therefore we register an IRQ sharing
> notifier and switch between line and device level disabling on demand.
>
> This feature is optional, user space has to request it explicitly as it
> also has to inform us about its view of PCI_COMMAND_INTX_DISABLE. That
> way, we can avoid unmasking the interrupt and signaling it if the guest
> masked it via the PCI config space.
>
>
> diff --git a/Documentation/kvm/api.txt b/Documentation/kvm/api.txt
> index e1a9297..5e164db 100644
> --- a/Documentation/kvm/api.txt
> +++ b/Documentation/kvm/api.txt
> @@ -1112,6 +1112,14 @@ following flags are specified:
>
>   /* Depends on KVM_CAP_IOMMU */
>   #define KVM_DEV_ASSIGN_ENABLE_IOMMU	(1<<  0)
> +/* The following two depend on KVM_CAP_PCI_2_3 */
> +#define KVM_DEV_ASSIGN_PCI_2_3		(1<<  1)
> +#define KVM_DEV_ASSIGN_MASK_INTX	(1<<  2)
> +
> +If KVM_DEV_ASSIGN_PCI_2_3 is set, the kernel will manage legacy INTx interrupts
> +via the PCI-2.3-compliant device-level mask, but only if IRQ sharing with other
> +assigned or host devices requires it. KVM_DEV_ASSIGN_MASK_INTX specifies the
> +guest's view on the INTx mask, see KVM_ASSIGN_SET_INTX_MASK for details.
>
>   4.48 KVM_DEASSIGN_PCI_DEVICE
>
> @@ -1263,6 +1271,23 @@ struct kvm_assigned_msix_entry {
>   	__u16 padding[3];
>   };
>
> +4.54 KVM_ASSIGN_SET_INTX_MASK
> +
> +Capability: KVM_CAP_PCI_2_3
> +Architectures: x86
> +Type: vm ioctl
> +Parameters: struct kvm_assigned_pci_dev (in)
> +Returns: 0 on success, -1 on error
> +
> +Informs the kernel about the guest's view on the INTx mask. As long as the
> +guest masks the legacy INTx, the kernel will refrain from unmasking it at
> +hardware level and will not assert the guest's IRQ line. User space is still
> +responsible for applying this state to the assigned device's real config space.

What's the protocol for doing this?  I suppose userspace has to disable 
interrupts, ioctl(SET_INTX_MASK, masked), ..., ioctl(SET_INTX_MASK, 
unmasked), enable interrupts?

Isn't there a race window between the two operations?

Maybe we should give the kernel full ownership of that bit.

> +
> +See KVM_ASSIGN_DEV_IRQ for the data structure. The target device is specified
> +by assigned_dev_id. In the flags field, only KVM_DEV_ASSIGN_MASK_INTX is
> +evaluated.
> +

-- 
error compiling committee.c: too many arguments to function

