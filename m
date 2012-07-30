Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754637Ab2G3OV2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2012 10:21:28 -0400
Received: from terminus.zytor.com ([198.137.202.10]:45820 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754375Ab2G3OV1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2012 10:21:27 -0400
Date: Mon, 30 Jul 2012 07:21:10 -0700
From: tip-bot for Oleg Nesterov <oleg@redhat.com>
Message-ID: <tip-194f8dcbe9629d8e9346cf96345a9c0bbf0e67ae@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, anton@redhat.com, hpa@zytor.com,
        mingo@kernel.org, srikar@linux.vnet.ibm.com, oleg@redhat.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, anton@redhat.com,
        linux-kernel@vger.kernel.org, srikar@linux.vnet.ibm.com,
        tglx@linutronix.de, oleg@redhat.com
In-Reply-To: <20120729182249.GA20372@redhat.com>
References: <20120729182249.GA20372@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] uprobes: __replace_page() needs munlock_vma_page()
Git-Commit-ID: 194f8dcbe9629d8e9346cf96345a9c0bbf0e67ae
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Mon, 30 Jul 2012 07:21:16 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  194f8dcbe9629d8e9346cf96345a9c0bbf0e67ae
Gitweb:     http://git.kernel.org/tip/194f8dcbe9629d8e9346cf96345a9c0bbf0e67ae
Author:     Oleg Nesterov <oleg@redhat.com>
AuthorDate: Sun, 29 Jul 2012 20:22:49 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Mon, 30 Jul 2012 11:27:25 +0200

uprobes: __replace_page() needs munlock_vma_page()

Like do_wp_page(), __replace_page() should do munlock_vma_page()
for the case when the old page still has other !VM_LOCKED
mappings. Unfortunately this needs mm/internal.h.

Also, move put_page() outside of ptl lock. This doesn't really
matter but looks a bit better.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Srikar Dronamraju <srikar.vnet.ibm.com>
Cc: Anton Arapov <anton@redhat.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Link: http://lkml.kernel.org/r/20120729182249.GA20372@redhat.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/events/uprobes.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
index bb30a4f..c08a22d 100644
--- a/kernel/events/uprobes.c
+++ b/kernel/events/uprobes.c
@@ -32,6 +32,7 @@
 #include <linux/swap.h>		/* try_to_free_swap */
 #include <linux/ptrace.h>	/* user_enable_single_step */
 #include <linux/kdebug.h>	/* notifier mechanism */
+#include "../../mm/internal.h"	/* munlock_vma_page */
 
 #include <linux/uprobes.h>
 
@@ -141,7 +142,7 @@ static int __replace_page(struct vm_area_struct *vma, unsigned long addr,
 	pte_t *ptep;
 	int err;
 
-	/* freeze PageSwapCache() for try_to_free_swap() below */
+	/* For try_to_free_swap() and munlock_vma_page() below */
 	lock_page(page);
 
 	err = -EAGAIN;
@@ -164,9 +165,12 @@ static int __replace_page(struct vm_area_struct *vma, unsigned long addr,
 	page_remove_rmap(page);
 	if (!page_mapped(page))
 		try_to_free_swap(page);
-	put_page(page);
 	pte_unmap_unlock(ptep, ptl);
 
+	if (vma->vm_flags & VM_LOCKED)
+		munlock_vma_page(page);
+	put_page(page);
+
 	err = 0;
  unlock:
 	unlock_page(page);
