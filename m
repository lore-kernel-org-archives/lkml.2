Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756650Ab2LMOG0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 09:06:26 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44390 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756617Ab2LMOGS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 09:06:18 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 090/241] s390/gup: add missing TASK_SIZE check to get_user_pages_fast()
Date: Thu, 13 Dec 2012 11:57:35 -0200
Message-Id: <1355407206-17100-91-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
References: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Heiko Carstens <heiko.carstens@de.ibm.com>

commit d55c4c613fc4d4ad2ba0fc6fa2b57176d420f7e4 upstream.

When walking page tables we need to make sure that everything
is within bounds of the ASCE limit of the task's address space.
Otherwise we might calculate e.g. a pud pointer which is not
within a pud and dereference it.
So check against TASK_SIZE (which is the ASCE limit) before
walking page tables.

Reviewed-by: Gerald Schaefer <gerald.schaefer@de.ibm.com>
Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 arch/s390/mm/gup.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/s390/mm/gup.c b/arch/s390/mm/gup.c
index 65cb06e..4ccf9f5 100644
--- a/arch/s390/mm/gup.c
+++ b/arch/s390/mm/gup.c
@@ -183,7 +183,7 @@ int get_user_pages_fast(unsigned long start, int nr_pages, int write,
 	addr = start;
 	len = (unsigned long) nr_pages << PAGE_SHIFT;
 	end = start + len;
-	if (end < start)
+	if ((end < start) || (end > TASK_SIZE))
 		goto slow_irqon;
 
 	/*
-- 
1.7.9.5

