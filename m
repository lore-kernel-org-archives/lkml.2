Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755638Ab2GXUnJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2012 16:43:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19430 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754722Ab2GXUnI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2012 16:43:08 -0400
From: Alex Williamson <alex.williamson@redhat.com>
Subject: [PATCH v7 0/2] kvm: level irqfd and new eoifd
To: avi@redhat.com, mst@redhat.com
Cc: gleb@redhat.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        jan.kiszka@siemens.com
Date: Tue, 24 Jul 2012 14:43:05 -0600
Message-ID: <20120724203628.21081.56884.stgit@bling.home>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

v7:

Just a minor change from v6 to fix locking.  In v6 we called
f_op->poll under eoifds.lock to install the eventfd waitqueue
function.  This creates a eoifds.lock --> ctx->wqh lock ordering.
When our wakeup function gets called it's under ctx->wqh and
acquires eoifds.lock.  Badness.  To fix this we can move the
poll call to before the lock because we only do anything on
POLLHUP which won't occur as long as we have a reference to the
file.  Thanks,

Alex

---

Alex Williamson (2):
      kvm: KVM_EOIFD, an eventfd for EOIs
      kvm: Extend irqfd to support level interrupts


 Documentation/virtual/kvm/api.txt |   32 ++-
 arch/x86/kvm/x86.c                |    3 
 include/linux/kvm.h               |   18 +
 include/linux/kvm_host.h          |   17 +
 virt/kvm/eventfd.c                |  464 ++++++++++++++++++++++++++++++++++++-
 virt/kvm/kvm_main.c               |   11 +
 6 files changed, 537 insertions(+), 8 deletions(-)
