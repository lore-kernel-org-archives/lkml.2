Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761431Ab2BNXhE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Feb 2012 18:37:04 -0500
Received: from a.ns.miles-group.at ([95.130.255.143]:47839 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761363Ab2BNXgY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Feb 2012 18:36:24 -0500
From: Richard Weinberger <richard@nod.at>
To: netfilter-devel@vger.kernel.org
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        eric.dumazet@gmail.com, jengelh@medozas.de, rostedt@goodmis.org,
        pablo@netfilter.org, basti@b-bl.de,
        Richard Weinberger <richard@nod.at>
Subject: [PATCH 2/2] Netfilter: xt_LOG: Add timestamp support
Date: Wed, 15 Feb 2012 00:36:13 +0100
Message-Id: <1329262573-22048-2-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1329262573-22048-1-git-send-email-richard@nod.at>
References: <1329262573-22048-1-git-send-email-richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using XT_LOG_ADD_TIMESTAMP it is possible to have a timestamp
directly in the log message.

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 include/linux/netfilter/xt_LOG.h |    1 +
 net/netfilter/xt_LOG.c           |   10 ++++++++++
 2 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/include/linux/netfilter/xt_LOG.h b/include/linux/netfilter/xt_LOG.h
index e4b1177..d84710c 100644
--- a/include/linux/netfilter/xt_LOG.h
+++ b/include/linux/netfilter/xt_LOG.h
@@ -8,6 +8,7 @@
 #define XT_LOG_UID		0x08	/* Log UID owning local socket */
 #define XT_LOG_NFLOG		0x10	/* Unsupported, don't reuse */
 #define XT_LOG_MACDECODE	0x20	/* Decode MAC header */
+#define XT_LOG_ADD_TIMESTAMP	0x40	/* Add a timestamp */
 #define XT_LOG_MASK		0x6f
 
 struct xt_log_info {
diff --git a/net/netfilter/xt_LOG.c b/net/netfilter/xt_LOG.c
index 211d341..bd59dfd 100644
--- a/net/netfilter/xt_LOG.c
+++ b/net/netfilter/xt_LOG.c
@@ -490,6 +490,16 @@ log_packet_common(struct sbuff *m,
 	if (loginfo->type == NF_LOG_TYPE_LOG)
 		sb_add(m, "<%d>", loginfo->u.log.level);
 
+	if (loginfo->u.log.logflags & XT_LOG_ADD_TIMESTAMP) {
+		static struct timespec tv;
+		unsigned int msec;
+
+		getnstimeofday(&tv);
+		msec = tv.tv_nsec;
+		do_div(msec, 1000000);
+		sb_add(m, "TIMESTAMP=%li.%03li ", tv.tv_sec, msec);
+	}
+
 	sb_add(m, "%sIN=%s OUT=%s ", prefix, in ? in->name : "",
 	       out ? out->name : "");
 #ifdef CONFIG_BRIDGE_NETFILTER
-- 
1.7.7.3

