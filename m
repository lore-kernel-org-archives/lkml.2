Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752830Ab1CQIyO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 04:54:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57567 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750872Ab1CQIyM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 04:54:12 -0400
Date: Thu, 17 Mar 2011 10:53:33 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        jean-philippe.menil@univ-nantes.fr, stable@kernel.org
Cc: Jason Wang <jasowang@redhat.com>
Subject: [PATCH] kvm: fix crash on irqfd deassign
Message-ID: <20110317085333.GA7336@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

irqfd in kvm used flush_work incorrectly:
it assumed that work scheduled previously can't run
after flush_work, but since kvm uses a non-reentrant
workqueue (by means of schedule_work)
we need flush_work_sync to get that guarantee.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Reported-by: Jean-Philippe Menil <jean-philippe.menil@univ-nantes.fr>
Tested-by: Jean-Philippe Menil <jean-philippe.menil@univ-nantes.fr>
---

Note: this is needed for kernel 2.6.39 and earlier.

 virt/kvm/eventfd.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/virt/kvm/eventfd.c b/virt/kvm/eventfd.c
index 2ca4535..cdf51c9 100644
--- a/virt/kvm/eventfd.c
+++ b/virt/kvm/eventfd.c
@@ -90,7 +90,7 @@ irqfd_shutdown(struct work_struct *work)
 	 * We know no new events will be scheduled at this point, so block
 	 * until all previously outstanding events have completed
 	 */
-	flush_work(&irqfd->inject);
+	flush_work_sync(&irqfd->inject);
 
 	/*
 	 * It is now safe to release the object's resources
-- 
1.7.3.2.91.g446ac
