Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757842Ab1KRLjH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 06:39:07 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:64134 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757758Ab1KRLjC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 06:39:02 -0500
From: Kautuk Consul <consul.kautuk@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>, Joe Perches <joe@perches.com>,
        David Rientjes <rientjes@google.com>,
        Minchan Kim <minchan.kim@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Kautuk Consul <consul.kautuk@gmail.com>
Subject: [PATCH 1/1] mm/vmalloc.c: eliminate extra loop in pcpu_get_vm_areas error path
Date: Fri, 18 Nov 2011 17:13:50 +0530
Message-Id: <1321616630-28281-1-git-send-email-consul.kautuk@gmail.com>
X-Mailer: git-send-email 1.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If either of the vas or vms arrays are not properly kzalloced,
then the code jumps to the err_free label.

The err_free label runs a loop to check and free each of the array
members of the vas and vms arrays which is not required for this
situation as none of the array members have been allocated till this
point.

Eliminate the extra loop we have to go through by introducing a new
label err_free2 and then jumping to it.

Signed-off-by: Kautuk Consul <consul.kautuk@gmail.com>
---
 mm/vmalloc.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index b669aa6..1a0d4e2 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -2352,7 +2352,7 @@ struct vm_struct **pcpu_get_vm_areas(const unsigned long *offsets,
 	vms = kzalloc(sizeof(vms[0]) * nr_vms, GFP_KERNEL);
 	vas = kzalloc(sizeof(vas[0]) * nr_vms, GFP_KERNEL);
 	if (!vas || !vms)
-		goto err_free;
+		goto err_free2;
 
 	for (area = 0; area < nr_vms; area++) {
 		vas[area] = kzalloc(sizeof(struct vmap_area), GFP_KERNEL);
@@ -2455,6 +2455,7 @@ err_free:
 		if (vms)
 			kfree(vms[area]);
 	}
+err_free2:
 	kfree(vas);
 	kfree(vms);
 	return NULL;
-- 
1.7.6

