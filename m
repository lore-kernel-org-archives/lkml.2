Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751415Ab2GSQ7P (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2012 12:59:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32000 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750804Ab2GSQ7M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2012 12:59:12 -0400
Date: Thu, 19 Jul 2012 19:59:45 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: avi@redhat.com, gleb@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, jan.kiszka@siemens.com
Subject: Re: [PATCH v5 0/4] kvm: level irqfd and new eoifd
Message-ID: <20120719165944.GB17213@redhat.com>
References: <20120716202711.1752.71007.stgit@bling.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120716202711.1752.71007.stgit@bling.home>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 16, 2012 at 02:33:38PM -0600, Alex Williamson wrote:
> v5:
>  - irqfds now have a one-to-one mapping with eoifds to prevent users
>    from consuming all of kernel memory by repeatedly creating eoifds
>    from a single irqfd.
>  - implement a kvm_clear_irq() which does a test_and_clear_bit of
>    the irq_state, only updating the pic/ioapic if changes and allowing
>    the caller to know if anything was done.  I added this onto the end
>    as it's essentially an optimization on the previous design.  It's
>    hard to tell if there's an actual performance benefit to this.
>  - dropped eoifd gsi support patch as it was only an FYI.
> 
> Thanks,
> 
> Alex


So 3/4, 4/4 are racy and I think you convinced me it's best to drop it for
now. I hope that fact that we already scan all vcpus under spinlock for
level interrupts is enough to justify adding a lock here.

To summarize issues still outstanding with 1/2, 2/2:
- source id lingering after irqfd was destroyed/deassigned
  prevents assigning a new irqfd
- if same irqfd is deassigned and re-assigned, this
  seems to succeed but does not give any more EOIs
- document that user needs to re-inject interrupts
  injected by level IRQFD after migration as they are cleared

Hope this helps!

> ---
> 
> Alex Williamson (4):
>       kvm: Convert eoifd to use kvm_clear_irq
>       kvm: Create kvm_clear_irq()
>       kvm: KVM_EOIFD, an eventfd for EOIs
>       kvm: Extend irqfd to support level interrupts
> 
> 
>  Documentation/virtual/kvm/api.txt |   28 +++
>  arch/x86/kvm/x86.c                |    3 
>  include/linux/kvm.h               |   18 ++
>  include/linux/kvm_host.h          |   16 ++
>  virt/kvm/eventfd.c                |  333 +++++++++++++++++++++++++++++++++++++
>  virt/kvm/irq_comm.c               |   78 +++++++++
>  virt/kvm/kvm_main.c               |   11 +
>  7 files changed, 483 insertions(+), 4 deletions(-)
