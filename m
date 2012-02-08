Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757301Ab2BHCc1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 21:32:27 -0500
Received: from db3ehsobe005.messaging.microsoft.com ([213.199.154.143]:50681
	"EHLO DB3EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756556Ab2BHCcZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Feb 2012 21:32:25 -0500
X-SpamScore: 0
X-BigFish: VPS0(zzzz1202hzz8275bhz2fh668h839h93fh)
X-Forefront-Antispam-Report: CIP:160.33.98.74;KIP:(null);UIP:(null);IPV:NLI;H:mail7.fw-bc.sony.com;RD:mail7.fw-bc.sony.com;EFVD:NLI
Message-ID: <4F31DEA2.7000702@am.sony.com>
Date: Tue, 7 Feb 2012 18:32:02 -0800
From: Tim Bird <tim.bird@am.sony.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.12) Gecko/20100907 Fedora/3.0.7-1.fc12 Thunderbird/3.0.7
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>,
        linux-embedded <linux-embedded@vger.kernel.org>,
        linux kernel <linux-kernel@vger.kernel.org>,
        Brian Swetland <swetland@google.com>, Dima Zavin <dima@android.com>,
        Andrew Morton <akpm@osdl.org>
Subject: [PATCH 4/5] logger: clarify code in clock_interval
References: <4F31DC31.6040303@am.sony.com>
In-Reply-To: <4F31DC31.6040303@am.sony.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: am.sony.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add commentary, rename the function and make the code easier to read.

Signed-off-by: Tim Bird <tim.bird@am.sony.com>
---
 drivers/staging/android/logger.c |   28 ++++++++++++++++++++--------
 1 files changed, 20 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/android/logger.c b/drivers/staging/android/logger.c
index 54b7cdf..8d9d4f1 100644
--- a/drivers/staging/android/logger.c
+++ b/drivers/staging/android/logger.c
@@ -242,16 +242,28 @@ static size_t get_next_entry(struct logger_log *log, size_t off, size_t len)
 }

 /*
- * clock_interval - is a < c < b in mod-space? Put another way, does the line
- * from a to b cross c?
+ * is_between - is a < c < b, accounting for wrapping of a, b, and c
+ *    positions in the buffer
+ *
+ * That is, if a<b, check for c between a and b
+ * and if a>b, check for c outside (not between) a and b
+ *
+ * |------- a xxxxxxxx b --------|
+ *               c^
+ *
+ * |xxxxx b --------- a xxxxxxxxx|
+ *    c^
+ *  or                    c^
  */
-static inline int clock_interval(size_t a, size_t b, size_t c)
+static inline int is_between(size_t a, size_t b, size_t c)
 {
-	if (b < a) {
-		if (a < c || b >= c)
+	if (a < b) {
+		/* is c between a and b? */
+		if (a < c && c <= b)
 			return 1;
 	} else {
-		if (a < c && b >= c)
+		/* is c outside of b through a? */
+		if (c <= b || a < c)
 			return 1;
 	}

@@ -272,11 +284,11 @@ static void fix_up_readers(struct logger_log *log, size_t len)
 	size_t new = logger_offset(log, old + len);
 	struct logger_reader *reader;

-	if (clock_interval(old, new, log->head))
+	if (is_between(old, new, log->head))
 		log->head = get_next_entry(log, log->head, len);

 	list_for_each_entry(reader, &log->readers, list)
-		if (clock_interval(old, new, reader->r_off))
+		if (is_between(old, new, reader->r_off))
 			reader->r_off = get_next_entry(log, reader->r_off, len);
 }

-- 
1.7.2.3

