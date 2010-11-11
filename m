Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756730Ab0KKUdk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 15:33:40 -0500
Received: from mail.digidescorp.com ([66.244.163.200]:23796 "EHLO
	digidescorp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753034Ab0KKUdj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 15:33:39 -0500
X-Spam-Processed: digidescorp.com, Thu, 11 Nov 2010 14:33:34 -0600
X-Authenticated-Sender: steve@digidescorp.com
X-MDRemoteIP: 99.142.19.240
X-Return-Path: prvs=1931d8b490=steve@digidescorp.com
X-Envelope-From: steve@digidescorp.com
X-MDaemon-Deliver-To: linux-kernel@vger.kernel.org
From: "Steven J. Magnani" <steve@digidescorp.com>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, "Steven J. Magnani" <steve@digidescorp.com>
Subject: [PATCH][RESEND] nommu: yield CPU periodically while disposing large VM
Date: Thu, 11 Nov 2010 14:33:16 -0600
Message-Id: <1289507596-17613-1-git-send-email-steve@digidescorp.com>
X-Mailer: git-send-email 1.6.0.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Depending on processor speed, page size, and the amount of memory a process
is allowed to amass, cleanup of a large VM may freeze the system for many
seconds. This can result in a watchdog timeout.

Make sure other tasks receive some service when cleaning up large VMs.

Signed-off-by: Steven J. Magnani <steve@digidescorp.com>
---
diff -uprN a/mm/nommu.c b/mm/nommu.c
--- a/mm/nommu.c	2010-10-21 07:42:23.000000000 -0500
+++ b/mm/nommu.c	2010-10-21 07:46:50.000000000 -0500
@@ -1656,6 +1656,7 @@ SYSCALL_DEFINE2(munmap, unsigned long, a
 void exit_mmap(struct mm_struct *mm)
 {
 	struct vm_area_struct *vma;
+	unsigned long next_yield = jiffies + HZ;
 
 	if (!mm)
 		return;
@@ -1668,6 +1669,11 @@ void exit_mmap(struct mm_struct *mm)
 		mm->mmap = vma->vm_next;
 		delete_vma_from_mm(vma);
 		delete_vma(mm, vma);
+		/* Yield periodically to prevent watchdog timeout */
+		if (time_after(jiffies, next_yield)) {
+			cond_resched();
+			next_yield = jiffies + HZ;
+		}
 	}
 
 	kleave("");

