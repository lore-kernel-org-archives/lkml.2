Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755220Ab2BAG7J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 01:59:09 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:45487 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755042Ab2BAG7F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 01:59:05 -0500
From: Cong Wang <xiyou.wangcong@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Prarit Bhargava <prarit@redhat.com>, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <greg@kroah.com>, Dave Young <dyoung@redhat.com>
Subject: [PATCH 2/2] lkdtm: avoid calling sleeping functions in interrupt context
Date: Wed,  1 Feb 2012 14:58:20 +0800
Message-Id: <1328079501-24746-2-git-send-email-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1328079501-24746-1-git-send-email-xiyou.wangcong@gmail.com>
References: <1328079501-24746-1-git-send-email-xiyou.wangcong@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

lkdtm_do_action() could be called in interrupt context,
but it also calls sleeping functions like schedule(),
kmalloc(GFP_KERNEL) etc., for such cases, avoid calling them
if we are in interrupt context.

BTW, check the return value of kmalloc().

Cc: Prarit Bhargava <prarit@redhat.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Greg Kroah-Hartman <greg@kroah.com>
Cc: Dave Young <dyoung@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>

---
 drivers/misc/lkdtm.c |   15 +++++++++++++--
 1 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/drivers/misc/lkdtm.c b/drivers/misc/lkdtm.c
index afdef2e..63b23a4 100644
--- a/drivers/misc/lkdtm.c
+++ b/drivers/misc/lkdtm.c
@@ -311,22 +311,31 @@ static void lkdtm_do_action(enum ctype which)
 	}
 	case CT_OVERWRITE_ALLOCATION: {
 		size_t len = 1020;
-		u32 *data = kmalloc(len, GFP_KERNEL);
+		u32 *data = kmalloc(len, GFP_ATOMIC);
 
+		if (!data)
+			break;
 		data[1024 / sizeof(u32)] = 0x12345678;
 		kfree(data);
 		break;
 	}
 	case CT_WRITE_AFTER_FREE: {
 		size_t len = 1024;
-		u32 *data = kmalloc(len, GFP_KERNEL);
+		u32 *data;
 
+		if (in_interrupt())
+			break;
+		data = kmalloc(len, GFP_KERNEL);
+		if (!data)
+			break;
 		kfree(data);
 		schedule();
 		memset(data, 0x78, len);
 		break;
 	}
 	case CT_SOFTLOCKUP:
+		if (in_interrupt())
+			break;
 		preempt_disable();
 		for (;;)
 			cpu_relax();
@@ -337,6 +346,8 @@ static void lkdtm_do_action(enum ctype which)
 			cpu_relax();
 		break;
 	case CT_HUNG_TASK:
+		if (in_interrupt())
+			break;
 		set_current_state(TASK_UNINTERRUPTIBLE);
 		schedule();
 		break;
-- 
1.7.7.6

