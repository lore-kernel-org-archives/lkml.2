Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754527Ab2F0FI4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 01:08:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46091 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751564Ab2F0FIz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 01:08:55 -0400
From: Alex Williamson <alex.williamson@redhat.com>
Subject: [PATCH v2 0/6] kvm: level triggered irqfd support
To: avi@redhat.com, mst@redhat.com
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, jan.kiszka@siemens.com
Date: Tue, 26 Jun 2012 23:08:52 -0600
Message-ID: <20120627044758.23698.249.stgit@bling.home>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ok, let's see how this flies.  I actually quite like this, so be
gentle tearing it apart ;)

I just couldn't bring myself to contort KVM_IRQFD into something
that either sets up an irqfd or specifies a nearly unrelated EOI
eventfd.  The solution I've come up with, that also avoids exposing
irq_source_ids to userspace, is to work through the irqfd.  If we
setup a level irqfd, we can optionally associate an eoifd with
the same irq_source_id, by passing the irqfd.  To do this, we just
need to create a new reference counted object for the source ID
so we don't run into problems ordering release.  This means we
end up with a KVM_EOIFD ioctl that has both general usefulness and
can still tie into an irqfd.  In patch 6/6 I also include an
alternate de-assert mechanism via an irqfd with the opposite
polarity.  I don't currently use this, but it's pretty trivial
and at least available in archives now.

I don't address whether injecting an edge irqfd really needs an assert
followed by de-assert (I don't know).  This new interface really
unties itself from caring.  We might be able to consolidate inject
functions at some future point, but it doesn't change how we'd name
flags as it did in the previous version.  Thanks,

Alex

---

Alex Williamson (6):
      kvm: Level IRQ de-assert for KVM_IRQFD
      kvm: KVM_EOIFD, an eventfd for EOIs
      kvm: Extend irqfd to support level interrupts
      kvm: Sanitize KVM_IRQFD flags
      kvm: Add missing KVM_IRQFD API documentation
      kvm: Pass kvm_irqfd to functions


 Documentation/virtual/kvm/api.txt |   53 ++++++
 arch/x86/kvm/x86.c                |    2 
 include/linux/kvm.h               |   23 +++
 include/linux/kvm_host.h          |   17 ++
 virt/kvm/eventfd.c                |  323 ++++++++++++++++++++++++++++++++++++-
 virt/kvm/kvm_main.c               |   13 +
 6 files changed, 414 insertions(+), 17 deletions(-)
