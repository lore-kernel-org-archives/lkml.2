Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753220Ab1BEOWI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Feb 2011 09:22:08 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:52225 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753081Ab1BEOWD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Feb 2011 09:22:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=Uup5iQDz6dI+Ey1cJ5XkdZYyD2fRH0AIG//p9NeXXZ/LoXZXHE6F+1YPh1zYzzugp+
         6FmYB12r6q6tCBIUb6Rs1cV+mYmD8COgnMl0PVs14Y9NLPyPuq5jVysfmKBttPIDPx5z
         ch3ns+X2uQLGHH7qCPfhmQnYbs0NnLB03Fqpw=
From: Alexey Dobriyan <adobriyan@gmail.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, adobriyan@gmail.com
Subject: [PATCH 24/52] kstrtox: convert drivers/isdn/
Date: Sat,  5 Feb 2011 16:20:27 +0200
Message-Id: <1296915654-7458-24-git-send-email-adobriyan@gmail.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1296915654-7458-1-git-send-email-adobriyan@gmail.com>
References: <1296915654-7458-1-git-send-email-adobriyan@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---
 drivers/isdn/gigaset/ev-layer.c    |   25 +++++++++----------------
 drivers/isdn/hysdn/hysdn_proclog.c |   11 ++++-------
 2 files changed, 13 insertions(+), 23 deletions(-)

diff --git a/drivers/isdn/gigaset/ev-layer.c b/drivers/isdn/gigaset/ev-layer.c
index a141876..37f7347 100644
--- a/drivers/isdn/gigaset/ev-layer.c
+++ b/drivers/isdn/gigaset/ev-layer.c
@@ -390,12 +390,12 @@ static const struct zsau_resp_t {
  */
 static int cid_of_response(char *s)
 {
-	unsigned long cid;
+	unsigned int cid;
 	int rc;
 
 	if (s[-1] != ';')
 		return 0;	/* no CID separator */
-	rc = strict_strtoul(s, 10, &cid);
+	rc = kstrtouint(s, 10, &cid);
 	if (rc)
 		return 0;	/* CID not numeric */
 	if (cid < 1 || cid > 65535)
@@ -566,27 +566,20 @@ void gigaset_handle_modem_response(struct cardstate *cs)
 		case RT_ZCAU:
 			event->parameter = -1;
 			if (curarg + 1 < params) {
-				unsigned long type, value;
+				u8 type, value;
 
-				i = strict_strtoul(argv[curarg++], 16, &type);
-				j = strict_strtoul(argv[curarg++], 16, &value);
+				i = kstrtou8(argv[curarg++], 16, &type);
+				j = kstrtou8(argv[curarg++], 16, &value);
 
-				if (i == 0 && type < 256 &&
-				    j == 0 && value < 256)
+				if (i == 0 && j == 0)
 					event->parameter = (type << 8) | value;
 			} else
 				curarg = params - 1;
 			break;
 		case RT_NUMBER:
-			event->parameter = -1;
-			if (curarg < params) {
-				unsigned long res;
-				int rc;
-
-				rc = strict_strtoul(argv[curarg++], 10, &res);
-				if (rc == 0)
-					event->parameter = res;
-			}
+			if (curarg >= params ||
+			    kstrtoint(argv[curarg++], 10, &event->parameter))
+				event->parameter = -1;
 			gig_dbg(DEBUG_EVENT, "parameter==%d", event->parameter);
 			break;
 		}
diff --git a/drivers/isdn/hysdn/hysdn_proclog.c b/drivers/isdn/hysdn/hysdn_proclog.c
index 2ee93d0..236cc7d 100644
--- a/drivers/isdn/hysdn/hysdn_proclog.c
+++ b/drivers/isdn/hysdn/hysdn_proclog.c
@@ -155,7 +155,6 @@ put_log_buffer(hysdn_card * card, char *cp)
 static ssize_t
 hysdn_log_write(struct file *file, const char __user *buf, size_t count, loff_t * off)
 {
-	unsigned long u = 0;
 	int rc;
 	unsigned char valbuf[128];
 	hysdn_card *card = file->private_data;
@@ -167,12 +166,10 @@ hysdn_log_write(struct file *file, const char __user *buf, size_t count, loff_t
 
 	valbuf[count] = 0;	/* terminating 0 */
 
-	rc = strict_strtoul(valbuf, 0, &u);
-
-	if (rc == 0) {
-		card->debug_flags = u;	/* remember debug flags */
-		hysdn_addlog(card, "debug set to 0x%lx", card->debug_flags);
-	}
+	rc = kstrtoul(valbuf, 0, &card->debug_flags);
+	if (rc < 0)
+		return rc;
+	hysdn_addlog(card, "debug set to 0x%lx", card->debug_flags);
 	return (count);
 }				/* hysdn_log_write */
 
-- 
1.7.3.4

