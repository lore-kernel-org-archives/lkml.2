Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932458Ab2ARSE4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jan 2012 13:04:56 -0500
Received: from mx1.redhat.com ([209.132.183.28]:42244 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932252Ab2ARSEy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jan 2012 13:04:54 -0500
Date: Wed, 18 Jan 2012 20:07:09 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alex Williamson <alex.williamson@redhat.com>
Subject: [PATCH] kvm: fix error handling for out of range irq
Message-ID: <20120118180708.GA4113@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

find_index_from_host_irq returns 0 on error
but callers assume < 0 on error. This should
not matter much: an out of range irq should never happen since
irq handler was registered with this irq #,
and even if it does we get a spurious msix irq in guest
and typically nothing terrible happens.

Still, better to make it consistent.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 virt/kvm/assigned-dev.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/virt/kvm/assigned-dev.c b/virt/kvm/assigned-dev.c
index 73bb001..0cbd8a1 100644
--- a/virt/kvm/assigned-dev.c
+++ b/virt/kvm/assigned-dev.c
@@ -49,10 +49,8 @@ static int find_index_from_host_irq(struct kvm_assigned_dev_kernel
 			index = i;
 			break;
 		}
-	if (index < 0) {
+	if (index < 0)
 		printk(KERN_WARNING "Fail to find correlated MSI-X entry!\n");
-		return 0;
-	}
 
 	return index;
 }
-- 
1.7.8.2.325.g247f9
