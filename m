Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752255Ab2AVWpA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jan 2012 17:45:00 -0500
Received: from a.ns.miles-group.at ([95.130.255.143]:47845 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752516Ab2AVWoP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jan 2012 17:44:15 -0500
From: Richard Weinberger <richard@nod.at>
To: netfilter-devel@vger.kernel.org
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        eric.dumazet@gmail.com, jengelh@medozas.de,
        Richard Weinberger <richard@nod.at>
Subject: [PATCH 3/6] xt_log: Make printk() in sb_close() optional
Date: Sun, 22 Jan 2012 22:56:18 +0100
Message-Id: <1327269381-20748-4-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1327269381-20748-1-git-send-email-richard@nod.at>
References: <1327269381-20748-1-git-send-email-richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make printk() in sb_close() optional such that other modules
can build a log string without printing it using printk().

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 include/net/netfilter/xt_log.h |    9 ++++++---
 1 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/include/net/netfilter/xt_log.h b/include/net/netfilter/xt_log.h
index 0dfb34a..767e08d 100644
--- a/include/net/netfilter/xt_log.h
+++ b/include/net/netfilter/xt_log.h
@@ -39,10 +39,12 @@ static struct sbuff *sb_open(void)
 	return m;
 }
 
-static void sb_close(struct sbuff *m)
+static void __sb_close(struct sbuff *m, int print)
 {
-	m->buf[m->count] = 0;
-	printk("%s\n", m->buf);
+	if (print) {
+		m->buf[m->count] = 0;
+		printk("%s\n", m->buf);
+	}
 
 	if (likely(m != &emergency))
 		kfree(m);
@@ -52,3 +54,4 @@ static void sb_close(struct sbuff *m)
 	}
 }
 
+#define sb_close(m)	__sb_close(m, 1)
-- 
1.7.7

