Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755997Ab2E0BGX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2012 21:06:23 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:36809 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755850Ab2E0BGT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2012 21:06:19 -0400
Message-Id: <20120527010424.914912315@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Sun, 27 May 2012 10:04:31 +0900
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Tilman Schmidt <tilman@imap.cc>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 08/94] isdn/gigaset: ratelimit CAPI message dumps
In-Reply-To: <20120527010332.GA11170@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tilman Schmidt <tilman@imap.cc>

commit 8e618aad5348b6e6c5a90e8d97ea643197963b20 upstream.

Introduce a global ratelimit for CAPI message dumps to protect
against possible log flood.
Drop the ratelimit for ignored messages which is now covered by the
global one.

Signed-off-by: Tilman Schmidt <tilman@imap.cc>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/isdn/gigaset/capi.c |   22 +++++++++-------------
 1 file changed, 9 insertions(+), 13 deletions(-)

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
@@ -223,10 +224,14 @@ get_appl(struct gigaset_capi_ctr *iif, u
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
@@ -2059,12 +2064,6 @@ static void do_reset_b3_req(struct gigas
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
@@ -2073,8 +2072,7 @@ static void do_unsupported(struct gigase
 {
 	/* decode message */
 	capi_message2cmsg(&iif->acmsg, skb->data);
-	if (printk_timed_ratelimit(&ignored_msg_dump_time, 30 * 1000))
-		dump_cmsg(DEBUG_CMD, __func__, &iif->acmsg);
+	dump_cmsg(DEBUG_CMD, __func__, &iif->acmsg);
 	send_conf(iif, ap, skb, CapiMessageNotSupportedInCurrentState);
 }
 
@@ -2085,11 +2083,9 @@ static void do_nothing(struct gigaset_ca
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
 


