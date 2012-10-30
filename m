Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933759Ab2J3Okd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 10:40:33 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:48649 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754131Ab2J3Okb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 10:40:31 -0400
From: Colin King <colin.king@canonical.com>
To: Anton Vorontsov <cbouatmailru@gmail.com>, Colin Cross <ccross@android.com>,
        Kees Cook <keescook@chromium.org>, Tony Luck <tony.luck@intel.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] pstore: fix NULL pointer dereference in console writes
Date: Tue, 30 Oct 2012 14:40:26 +0000
Message-Id: <1351608026-12208-1-git-send-email-colin.king@canonical.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

Passing a NULL id causes a NULL pointer deference in writers
such as erst_writer and efi_pstore_write because they expect
to update this id.  Pass a dummy id instead.

This avoids a cascade of oopses caused when the initial
pstore_console_write passes a null which in turn causes
writes to the console causing further oopses in subsequent
pstore_console_write calls.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 fs/pstore/platform.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/pstore/platform.c b/fs/pstore/platform.c
index a40da07..947fbe0 100644
--- a/fs/pstore/platform.c
+++ b/fs/pstore/platform.c
@@ -161,6 +161,7 @@ static void pstore_console_write(struct console *con, const char *s, unsigned c)
 
 	while (s < e) {
 		unsigned long flags;
+		u64 id;
 
 		if (c > psinfo->bufsize)
 			c = psinfo->bufsize;
@@ -172,7 +173,7 @@ static void pstore_console_write(struct console *con, const char *s, unsigned c)
 			spin_lock_irqsave(&psinfo->buf_lock, flags);
 		}
 		memcpy(psinfo->buf, s, c);
-		psinfo->write(PSTORE_TYPE_CONSOLE, 0, NULL, 0, c, psinfo);
+		psinfo->write(PSTORE_TYPE_CONSOLE, 0, &id, 0, c, psinfo);
 		spin_unlock_irqrestore(&psinfo->buf_lock, flags);
 		s += c;
 		c = e - s;
-- 
1.7.10.4

