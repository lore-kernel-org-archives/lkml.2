Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756909Ab2GMTky (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2012 15:40:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:65364 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752645Ab2GMTkw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2012 15:40:52 -0400
From: Alex Williamson <alex.williamson@redhat.com>
Subject: [PATCH v4 0/3] kvm: level irqfd and new eoifd
To: avi@redhat.com, mst@redhat.com
Cc: gleb@redhat.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        jan.kiszka@siemens.com
Date: Fri, 13 Jul 2012 13:40:48 -0600
Message-ID: <20120713192625.5474.60777.stgit@bling.home>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

v4:
 - KVM_IRQFD_FLAG_LEVEL flag now documented and coded to only be
   necessary on assign.
 - Lock added to struct _irq_source to maintain the source ID assertion
   state to avoid repeat assertions or spurious EOIs.  I couldn't figure
   out a way to make this work w/o races using atomics and don't see any
   way to make use of kvm_irq_line_state.
 - GSI support in KVM_EOIFD is dropped since it's not immediately used
   and I don't seem to be able to explain why it's useful.  It makes it
   optional though, which may be a good thing if other archs try to use
   this interface.
 - eoifd switch to mutex from spinlock (all tested as lockdep safe)
 - _irqfd_fdget_lock/_irqfd_put_unlock replaces _irqfd_fdget/_irqfd_put
   so we hold the lock for the irqfds ensuring the one we're binding to
   doesn't go away while we get a reference to the _irq_source.
 - We also pull the GSI off the irqfd rather than specifying it for eoifd.
 - eoifd_deactivate renamed to eoifd_destroy to make it blindingly
   obvious what it does.

Patch 3/3 is not for commit and not meant to be ready for commit, it's
just an FYI on what adding back support for a GSI based, non-de-asserting
eoifd will look like.  Thanks,

Alex

---

Alex Williamson (3):
      kvm: Add a GSI specification for KVM_EOIFD
      kvm: KVM_EOIFD, an eventfd for EOIs
      kvm: Extend irqfd to support level interrupts


 Documentation/virtual/kvm/api.txt |   27 +++
 arch/x86/kvm/x86.c                |    3 
 include/linux/kvm.h               |   24 +++
 include/linux/kvm_host.h          |   13 +
 virt/kvm/eventfd.c                |  349 +++++++++++++++++++++++++++++++++++++
 virt/kvm/kvm_main.c               |   11 +
 6 files changed, 423 insertions(+), 4 deletions(-)
