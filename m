Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757249Ab2BHC2r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 21:28:47 -0500
Received: from db3ehsobe005.messaging.microsoft.com ([213.199.154.143]:39115
	"EHLO DB3EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755249Ab2BHC2q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Feb 2012 21:28:46 -0500
X-SpamScore: 0
X-BigFish: VPS0(zzzz1202hzz8275bhz2fh668h839h93fh)
X-Forefront-Antispam-Report: CIP:160.33.98.74;KIP:(null);UIP:(null);IPV:NLI;H:mail7.fw-bc.sony.com;RD:mail7.fw-bc.sony.com;EFVD:NLI
Message-ID: <4F31DDC7.1050107@am.sony.com>
Date: Tue, 7 Feb 2012 18:28:23 -0800
From: Tim Bird <tim.bird@am.sony.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.12) Gecko/20100907 Fedora/3.0.7-1.fc12 Thunderbird/3.0.7
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>,
        linux-embedded <linux-embedded@vger.kernel.org>,
        linux kernel <linux-kernel@vger.kernel.org>,
        Brian Swetland <swetland@google.com>, Dima Zavin <dima@android.com>,
        Andrew Morton <akpm@osdl.org>
Subject: [PATCH 2/5] logger: simplify and optimize get_entry_len
References: <4F31DC31.6040303@am.sony.com>
In-Reply-To: <4F31DC31.6040303@am.sony.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: am.sony.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make this code slightly easier to read, and eliminate calls
to sub-routines.  Some of these were previously optimized away
by the compiler, but one memcpy was not.

Signed-off-by: Tim Bird <tim.bird@am.sony.com>
---
 drivers/staging/android/logger.c |   18 +++++++++++-------
 1 files changed, 11 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/android/logger.c b/drivers/staging/android/logger.c
index 92456d7..92cfd94 100644
--- a/drivers/staging/android/logger.c
+++ b/drivers/staging/android/logger.c
@@ -93,19 +93,23 @@ static inline struct logger_log *file_get_log(struct file *file)
  * get_entry_len - Grabs the length of the payload of the next entry starting
  * from 'off'.
  *
+ * An entry length is 2 bytes (16 bits) in host endian order.
+ * In the log, the length does not include the size of the log entry structure.
+ * This function returns the size including the log entry structure.
+ *
  * Caller needs to hold log->mutex.
  */
 static __u32 get_entry_len(struct logger_log *log, size_t off)
 {
 	__u16 val;

-	switch (log->size - off) {
-	case 1:
-		memcpy(&val, log->buffer + off, 1);
-		memcpy(((char *) &val) + 1, log->buffer, 1);
-		break;
-	default:
-		memcpy(&val, log->buffer + off, 2);
+	if (unlikely(log->size - off == 1)) {
+		/* at end of buffer, handle wrap */
+		((unsigned char *)&val)[0] = log->buffer[off];
+		((unsigned char *)&val)[1] = log->buffer[0];
+	} else {
+		((unsigned char *)&val)[0] = log->buffer[off];
+		((unsigned char *)&val)[1] = log->buffer[off+1];
 	}

 	return sizeof(struct logger_entry) + val;
-- 
1.7.2.3

