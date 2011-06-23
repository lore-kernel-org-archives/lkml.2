Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759596Ab1FWPVo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 11:21:44 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:40224 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758206Ab1FWPVm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 11:21:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=Aqxykhl7MV8TtzJYxSmjRSi4pq+UG2o07A0iT8qV2iZE7VbaY5K/wau9kmfinplBMm
         K1rixLJQV/wfbjTnOb0nYMf9ZJnU/HZi1HLi1XE5PwrWTjqyK2pjS1USxedX0YsB+69s
         xuTWj2cCKPWpP4UJY9lVqe1XWwceCA09vZWiU=
Date: Thu, 23 Jun 2011 19:21:37 +0400
From: Vasiliy Kulikov <segoon@openwall.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        James Morris <jmorris@namei.org>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@gmail.com>, Greg Kroah-Hartman <gregkh@suse.de>,
        kernel-hardening@lists.openwall.com, linux-kernel@vger.kernel.org,
        Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH v2] kernel: escape non-ASCII and control characters in
 printk()
Message-ID: <20110623152137.GA2536@albatros>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch escapes control characters fed to printk() except '\n' and '\t'.

There are numerous printk() instances with user supplied input as "%s"
data, and unprivileged user may craft log messages with substrings
containing control characters via these printk()s.  Control characters
might fool root viewing the logs via tty, e.g. using ^[1A to suppress
the previous log line.

On the testing Samsung Q310 laptop there are no users of chars outside
of the restricted charset. 

v2 - Allow chars with code >127.  Allow tabs.

Reported-by: Solar Designer <solar@openwall.com>
Signed-off-by: Vasiliy Kulikov <segoon@openwall.com>
---
 kernel/printk.c |   17 ++++++++++++++++-
 1 files changed, 16 insertions(+), 1 deletions(-)

---
diff --git a/kernel/printk.c b/kernel/printk.c
index 3518539..727ff7d 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -41,6 +41,7 @@
 #include <linux/cpu.h>
 #include <linux/notifier.h>
 #include <linux/rculist.h>
+#include <linux/ctype.h>
 
 #include <asm/uaccess.h>
 
@@ -671,6 +672,20 @@ static void emit_log_char(char c)
 		logged_chars++;
 }
 
+static void emit_log_char_escaped(char c)
+{
+	char buffer[8];
+	int i, len;
+
+	if (!iscntrl(c) || (c == '\n') || (c == '\t'))
+		emit_log_char(c);
+	else {
+		len = sprintf(buffer, "#x%02x", c);
+		for (i = 0; i < len; i++)
+			emit_log_char(buffer[i]);
+	}
+}
+
 /*
  * Zap console related locks when oopsing. Only zap at most once
  * every 10 seconds, to leave time for slow consoles to print a
@@ -938,7 +953,7 @@ asmlinkage int vprintk(const char *fmt, va_list args)
 				break;
 		}
 
-		emit_log_char(*p);
+		emit_log_char_escaped(*p);
 		if (*p == '\n')
 			new_text_line = 1;
 	}
---
