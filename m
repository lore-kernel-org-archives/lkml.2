Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759784Ab0JFUtv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Oct 2010 16:49:51 -0400
Received: from one.firstfloor.org ([213.235.205.2]:37480 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759275Ab0JFUtO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Oct 2010 16:49:14 -0400
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: fengguang.wu@intel.com, linux-mm@kvack.org,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 2/4] HWPOISON: Copy si_addr_lsb to user
Date: Wed,  6 Oct 2010 22:48:59 +0200
Message-Id: <1286398141-13749-3-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1286398141-13749-1-git-send-email-andi@firstfloor.org>
References: <1286398141-13749-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

The original hwpoison code added a new siginfo field si_addr_lsb to
pass the granuality of the fault address to user space. Unfortunately
this field was never copied to user space. Fix this here.

I added explicit checks for the MCEERR codes to avoid having
to patch all potential callers to initialize the field.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 kernel/signal.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/kernel/signal.c b/kernel/signal.c
index bded651..919562c 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -2215,6 +2215,14 @@ int copy_siginfo_to_user(siginfo_t __user *to, siginfo_t *from)
 #ifdef __ARCH_SI_TRAPNO
 		err |= __put_user(from->si_trapno, &to->si_trapno);
 #endif
+#ifdef BUS_MCEERR_AO
+		/* 
+		 * Other callers might not initialize the si_lsb field,
+	 	 * so check explicitely for the right codes here.
+		 */
+		if (from->si_code == BUS_MCEERR_AR || from->si_code == BUS_MCEERR_AO)
+			err |= __put_user(from->si_addr_lsb, &to->si_addr_lsb);
+#endif
 		break;
 	case __SI_CHLD:
 		err |= __put_user(from->si_pid, &to->si_pid);
-- 
1.7.1

