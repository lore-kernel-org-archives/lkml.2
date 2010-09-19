Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755163Ab0ISRIe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Sep 2010 13:08:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22782 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754955Ab0ISRIc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Sep 2010 13:08:32 -0400
Date: Sun, 19 Sep 2010 19:02:31 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>, Tejun Heo <tj@kernel.org>,
        Gregory Haskins <ghaskins@novell.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] kvm: fix irqfd assign/deassign race
Message-ID: <20100919170231.GA12620@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I think I see the following (theoretical) race:

During irqfd assign, we drop irqfds lock before we
schedule inject work. Therefore, deassign running
on another CPU could cause shutdown and flush to run
before inject, causing user after free in inject.

A simple fix it to schedule inject under the lock.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---

If the issue is real, this might be a 2.6.36 and -stable
candidate. Comments?

 virt/kvm/eventfd.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/virt/kvm/eventfd.c b/virt/kvm/eventfd.c
index 66cf65b..c1f1e3c 100644
--- a/virt/kvm/eventfd.c
+++ b/virt/kvm/eventfd.c
@@ -218,7 +218,6 @@ kvm_irqfd_assign(struct kvm *kvm, int fd, int gsi)
 	events = file->f_op->poll(file, &irqfd->pt);
 
 	list_add_tail(&irqfd->list, &kvm->irqfds.items);
-	spin_unlock_irq(&kvm->irqfds.lock);
 
 	/*
 	 * Check if there was an event already pending on the eventfd
@@ -227,6 +226,8 @@ kvm_irqfd_assign(struct kvm *kvm, int fd, int gsi)
 	if (events & POLLIN)
 		schedule_work(&irqfd->inject);
 
+	spin_unlock_irq(&kvm->irqfds.lock);
+
 	/*
 	 * do not drop the file until the irqfd is fully initialized, otherwise
 	 * we might race against the POLLHUP
-- 
1.7.2.2
