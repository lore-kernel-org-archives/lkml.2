Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752772Ab1CFLDh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Mar 2011 06:03:37 -0500
Received: from mx1.redhat.com ([209.132.183.28]:33762 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752290Ab1CFLDg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Mar 2011 06:03:36 -0500
Date: Sun, 6 Mar 2011 13:03:26 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] kvm: improve comment on rcu use in irqfd_deassign
Message-ID: <20110306110326.GA23818@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The RCU use in kvm_irqfd_deassign is tricky: we have rcu_assign_pointer
but no synchronize_rcu: synchronize_rcu is done by kvm_irq_routing_update
which we share a spinlock with.

Fix up a comment in an attempt to make this clearer.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 virt/kvm/eventfd.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/virt/kvm/eventfd.c b/virt/kvm/eventfd.c
index 2ca4535..3656849 100644
--- a/virt/kvm/eventfd.c
+++ b/virt/kvm/eventfd.c
@@ -313,8 +313,9 @@ kvm_irqfd_deassign(struct kvm *kvm, int fd, int gsi)
 		if (irqfd->eventfd == eventfd && irqfd->gsi == gsi) {
 			/*
 			 * This rcu_assign_pointer is needed for when
-			 * another thread calls kvm_irqfd_update before
-			 * we flush workqueue below.
+			 * another thread calls kvm_irq_routing_update before
+			 * we flush workqueue below (we synchronize with
+			 * kvm_irq_routing_update using irqfds.lock).
 			 * It is paired with synchronize_rcu done by caller
 			 * of that function.
 			 */
-- 
1.7.3.2.91.g446ac
