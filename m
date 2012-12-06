Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946196Ab2LFRJK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 12:09:10 -0500
Received: from mail.eecsit.tu-berlin.de ([130.149.17.13]:65095 "EHLO
	mail.cs.tu-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423043Ab2LFRJI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 12:09:08 -0500
From: =?UTF-8?q?Jan=20H=2E=20Sch=C3=B6nherr?= <schnhrr@cs.tu-berlin.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kay Sievers <kay@vrfy.org>
Cc: linux-kernel@vger.kernel.org, Joe Perches <joe@perches.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        =?UTF-8?q?Jan=20H=2E=20Sch=C3=B6nherr?= <schnhrr@cs.tu-berlin.de>
Subject: [PATCH v2 04/14] printk: do not add unnecessary newlines to the continuation buffer
Date: Thu,  6 Dec 2012 18:06:01 +0100
Message-Id: <1354813571-11253-5-git-send-email-schnhrr@cs.tu-berlin.de>
X-Mailer: git-send-email 1.8.0.1.20.g7c65b2e.dirty
In-Reply-To: <1354813571-11253-1-git-send-email-schnhrr@cs.tu-berlin.de>
References: <1354813571-11253-1-git-send-email-schnhrr@cs.tu-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Do not add newlines to the continuation buffer just because we can.  (In
some cases, the newlines are even misplaced and prevent a correct syslog
output.) Instead, only if a newline was part of the input, store it
during cont_add().

This makes the previous patch a bit more efficient.

Signed-off-by: Jan H. Schönherr <schnhrr@cs.tu-berlin.de>
---
added in v2
---
 kernel/printk.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/kernel/printk.c b/kernel/printk.c
index 13af61c..f6a91ec 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -1392,15 +1392,13 @@ static struct cont {
 	bool flushed:1;			/* buffer sealed and committed */
 } cont;
 
-static void cont_flush(enum log_flags flags)
+static void cont_flush(void)
 {
 	if (cont.flushed)
 		return;
 	if (cont.len == 0)
 		return;
 
-	cont.flags |= flags;
-
 	/*
 	 * If a fragment of this line was directly flushed to the console, the
 	 * whole line is/was directly printed. Use LOG_NOCONS to suppress a
@@ -1431,7 +1429,7 @@ static bool cont_add(int facility, int level, enum log_flags flags,
 
 	if (cont.len + len > sizeof(cont.buf)) {
 		/* the line gets too long, split it up in separate records */
-		cont_flush(0);
+		cont_flush();
 		return false;
 	}
 
@@ -1440,16 +1438,18 @@ static bool cont_add(int facility, int level, enum log_flags flags,
 		cont.level = level;
 		cont.owner = current;
 		cont.ts_nsec = local_clock();
-		cont.flags = flags;
+		cont.flags = 0;
 		cont.cons = 0;
 		cont.flushed = false;
 	}
 
+	cont.flags |= flags;
+
 	memcpy(cont.buf + cont.len, text, len);
 	cont.len += len;
 
 	if (cont.len > (sizeof(cont.buf) * 80) / 100)
-		cont_flush(0);
+		cont_flush();
 
 	return true;
 }
@@ -1585,7 +1585,7 @@ asmlinkage int vprintk_emit(int facility, int level,
 			if (cont.owner != current)
 				lflags |= LOG_PREFIX;
 			if (lflags & LOG_PREFIX)
-				cont_flush(LOG_NEWLINE);
+				cont_flush();
 		}
 
 		/* buffer line if possible, otherwise store it right away */
@@ -1605,7 +1605,7 @@ asmlinkage int vprintk_emit(int facility, int level,
 			if (!(lflags & LOG_PREFIX))
 				stored = cont_add(facility, level, lflags,
 							text, text_len);
-			cont_flush(LOG_NEWLINE);
+			cont_flush();
 		}
 
 		if (!stored)
-- 
1.8.0.1.20.g7c65b2e.dirty

