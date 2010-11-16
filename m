Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758159Ab0KPNG6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 08:06:58 -0500
Received: from mail.digidescorp.com ([66.244.163.200]:36925 "EHLO
	digidescorp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756264Ab0KPNG5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 08:06:57 -0500
X-Spam-Processed: digidescorp.com, Tue, 16 Nov 2010 07:06:57 -0600
X-Authenticated-Sender: steve@digidescorp.com
X-Return-Path: prvs=1936c50a63=steve@digidescorp.com
X-Envelope-From: steve@digidescorp.com
X-MDaemon-Deliver-To: linux-kernel@vger.kernel.org
From: "Steven J. Magnani" <steve@digidescorp.com>
To: linux-mm@kvack.org
Cc: stable@kernel.org, linux-kernel@vger.kernel.org, gerg@snapgear.com,
        kosaki.motohiro@jp.fujitsu.com, akpm@linux-foundation.org,
        "Steven J. Magnani" <steve@digidescorp.com>
Subject: [PATCH][V2] nommu: yield CPU while disposing VM
Date: Tue, 16 Nov 2010 07:06:45 -0600
Message-Id: <1289912805-4143-1-git-send-email-steve@digidescorp.com>
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
--- a/mm/nommu.c	2010-11-15 07:53:45.000000000 -0600
+++ b/mm/nommu.c	2010-11-15 07:57:13.000000000 -0600
@@ -1668,6 +1668,7 @@ void exit_mmap(struct mm_struct *mm)
 		mm->mmap = vma->vm_next;
 		delete_vma_from_mm(vma);
 		delete_vma(mm, vma);
+		cond_resched();
 	}
 
 	kleave("");

