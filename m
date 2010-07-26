Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754148Ab0GZJzG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jul 2010 05:55:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44512 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753835Ab0GZJzE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jul 2010 05:55:04 -0400
From: Xiaotian Feng <dfeng@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Xiaotian Feng <dfeng@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Neil Horman <nhorman@tuxdriver.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [RFC PATCH] sysrq: don't hold the sysrq_key_table_lock during the handler
Date: Mon, 26 Jul 2010 17:54:02 +0800
Message-Id: <1280138042-1576-1-git-send-email-dfeng@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sysrq_key_table_lock is used to protect the sysrq_key_table, make sure
we get/replace the right operation for the sysrq. But in __handle_sysrq,
kernel will hold this lock and disable irqs until we finished op_p->handler().
This may cause false positive watchdog alert when we're doing "show-task-states"
on a system with many tasks.

Signed-off-by: Xiaotian Feng <dfeng@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Neil Horman <nhorman@tuxdriver.com>
Cc: "David S. Miller" <davem@davemloft.net>
---
 drivers/char/sysrq.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/char/sysrq.c b/drivers/char/sysrq.c
index 878ac0c..0856e2e 100644
--- a/drivers/char/sysrq.c
+++ b/drivers/char/sysrq.c
@@ -520,9 +520,11 @@ void __handle_sysrq(int key, struct tty_struct *tty, int check_mask)
 		if (!check_mask || sysrq_on_mask(op_p->enable_mask)) {
 			printk("%s\n", op_p->action_msg);
 			console_loglevel = orig_log_level;
+			spin_unlock_irqrestore(&sysrq_key_table_lock, flags);
 			op_p->handler(key, tty);
 		} else {
 			printk("This sysrq operation is disabled.\n");
+			spin_unlock_irqrestore(&sysrq_key_table_lock, flags);
 		}
 	} else {
 		printk("HELP : ");
@@ -541,8 +543,8 @@ void __handle_sysrq(int key, struct tty_struct *tty, int check_mask)
 		}
 		printk("\n");
 		console_loglevel = orig_log_level;
+		spin_unlock_irqrestore(&sysrq_key_table_lock, flags);
 	}
-	spin_unlock_irqrestore(&sysrq_key_table_lock, flags);
 }
 
 void handle_sysrq(int key, struct tty_struct *tty)
-- 
1.7.2

