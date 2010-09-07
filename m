Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756925Ab0IGOAr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Sep 2010 10:00:47 -0400
Received: from www.tglx.de ([62.245.132.106]:58761 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756888Ab0IGOAc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Sep 2010 10:00:32 -0400
Message-Id: <20100907111349.884798010@linutronix.de>
User-Agent: quilt/0.47-1
Date: Tue, 07 Sep 2010 14:00:04 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Eric Paris <eparis@redhat.com>
Subject: [patch 2/3] audit: Do not send uninitialized data for AUDIT_TTY_GET
References: <20100907111326.202980881@linutronix.de>
Content-Disposition: inline;
	filename=audit-do-not-send-uninitialized-data-for-audit_tty_get.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

audit_receive_msg() sends uninitialized data for AUDIT_TTY_GET when
the task was not found.

Send reply only when task was found.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Eric Paris <eparis@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>

---
kernel/audit.c |    6 ++++--
 kernel/audit.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)
Index: linux-2.6/kernel/audit.c
===================================================================
--- linux-2.6.orig/kernel/audit.c
+++ linux-2.6/kernel/audit.c
@@ -884,8 +884,10 @@ static int audit_receive_msg(struct sk_b
 			spin_unlock_irq(&tsk->sighand->siglock);
 		}
 		read_unlock(&tasklist_lock);
-		audit_send_reply(NETLINK_CB(skb).pid, seq, AUDIT_TTY_GET, 0, 0,
-				 &s, sizeof(s));
+
+		if (!err)
+			audit_send_reply(NETLINK_CB(skb).pid, seq,
+					 AUDIT_TTY_GET, 0, 0, &s, sizeof(s));
 		break;
 	}
 	case AUDIT_TTY_SET: {


