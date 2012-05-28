Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755494Ab2E1DyM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2012 23:54:12 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51878 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753449Ab2E1D3I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2012 23:29:08 -0400
Message-Id: <20120528031205.798243797@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 28 May 2012 04:12:23 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Tilman Schmidt <tilman@imap.cc>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 021/117] isdn/gigaset: ratelimit CAPI message dumps
In-Reply-To: <20120528031202.829379252@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tilman Schmidt <tilman@imap.cc>

commit 8e618aad5348b6e6c5a90e8d97ea643197963b20 upstream.

Introduce a global ratelimit for CAPI message dumps to protect
against possible log flood.
Drop the ratelimit for ignored messages which is now covered by the
global one.

Signed-off-by: Tilman Schmidt <tilman@imap.cc>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/isdn/gigaset/capi.c |   22 +++++++++-------------
 1 file changed, 9 insertions(+), 13 deletions(-)

diff --git a/drivers/isdn/gigaset/capi.c b/drivers/isdn/gigaset/capi.c
index 343b5c8..292ca2f 100644
--- a/drivers/isdn/gigaset/capi.c
+++ b/drivers/isdn/gigaset/capi.c
@@ -14,6 +14,7 @@
 #include "gigaset.h"
 #include <linux/proc_fs.h>
 #include <linux/seq_file.h>
+#include <linux/ratelimit.h>
 #include <linux/isdn/capilli.h>
 #include <linux/isdn/capicmd.h>
 #include <linux/isdn/capiutil.h>
@@ -223,10 +224,14 @@ get_appl(struct gigaset_capi_ctr *iif, u16 appl)
 static inline void dump_cmsg(enum debuglevel level, const char *tag, _cmsg *p)
 {
 #ifdef CONFIG_GIGASET_DEBUG
+	/* dump at most 20 messages in 20 secs */
+	static DEFINE_RATELIMIT_STATE(msg_dump_ratelimit, 20 * HZ, 20);
 	_cdebbuf *cdb;
 
 	if (!(gigaset_debuglevel & level))
 		return;
+	if (!___ratelimit(&msg_dump_ratelimit, tag))
+		return;
 
 	cdb = capi_cmsg2str(p);
 	if (cdb) {
@@ -2059,12 +2064,6 @@ static void do_reset_b3_req(struct gigaset_capi_ctr *iif,
 }
 
 /*
- * dump unsupported/ignored messages at most twice per minute,
- * some apps send those very frequently
- */
-static unsigned long ignored_msg_dump_time;
-
-/*
  * unsupported CAPI message handler
  */
 static void do_unsupported(struct gigaset_capi_ctr *iif,
@@ -2073,8 +2072,7 @@ static void do_unsupported(struct gigaset_capi_ctr *iif,
 {
 	/* decode message */
 	capi_message2cmsg(&iif->acmsg, skb->data);
-	if (printk_timed_ratelimit(&ignored_msg_dump_time, 30 * 1000))
-		dump_cmsg(DEBUG_CMD, __func__, &iif->acmsg);
+	dump_cmsg(DEBUG_CMD, __func__, &iif->acmsg);
 	send_conf(iif, ap, skb, CapiMessageNotSupportedInCurrentState);
 }
 
@@ -2085,11 +2083,9 @@ static void do_nothing(struct gigaset_capi_ctr *iif,
 		       struct gigaset_capi_appl *ap,
 		       struct sk_buff *skb)
 {
-	if (printk_timed_ratelimit(&ignored_msg_dump_time, 30 * 1000)) {
-		/* decode message */
-		capi_message2cmsg(&iif->acmsg, skb->data);
-		dump_cmsg(DEBUG_CMD, __func__, &iif->acmsg);
-	}
+	/* decode message */
+	capi_message2cmsg(&iif->acmsg, skb->data);
+	dump_cmsg(DEBUG_CMD, __func__, &iif->acmsg);
 	dev_kfree_skb_any(skb);
 }
 


