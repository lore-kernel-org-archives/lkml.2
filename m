Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755067Ab2KMXQ0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 18:16:26 -0500
Received: from mail.eecsit.tu-berlin.de ([130.149.17.13]:63638 "EHLO
	mail.cs.tu-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753338Ab2KMXQY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 18:16:24 -0500
From: =?UTF-8?q?Jan=20H=2E=20Sch=C3=B6nherr?= <schnhrr@cs.tu-berlin.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Kay Sievers <kay@vrfy.org>,
        =?UTF-8?q?Jan=20H=2E=20Sch=C3=B6nherr?= <schnhrr@cs.tu-berlin.de>
Subject: [PATCH 04/12] printk: reuse reclaimed continuation buffer immediately
Date: Wed, 14 Nov 2012 00:13:01 +0100
Message-Id: <1352848389-23114-5-git-send-email-schnhrr@cs.tu-berlin.de>
X-Mailer: git-send-email 1.8.0.316.g291341c.dirty
In-Reply-To: <1352848389-23114-1-git-send-email-schnhrr@cs.tu-berlin.de>
References: <1352848389-23114-1-git-send-email-schnhrr@cs.tu-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cont_add() might flush the continuation buffer before appending
anything. If that happens, the function returns immediately, forcing the
calling function to store the message elsewhere. This is not always
necessary.

When the continuation buffer was reclaimed (and not just marked as
"flushed"), then we can reuse it immediately instead of returning false.

Signed-off-by: Jan H. Schönherr <schnhrr@cs.tu-berlin.de>
---
 kernel/printk.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/kernel/printk.c b/kernel/printk.c
index ba9494b..42e5eaf 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -1431,7 +1431,8 @@ static bool cont_add(int facility, int level, enum log_flags flags,
 	if (cont.len + len > sizeof(cont.buf)) {
 		/* the line gets too long, split it up in separate records */
 		cont_flush(0);
-		return false;
+		if (cont.len)
+			return false;
 	}
 
 	if (!cont.len) {
-- 
1.8.0.316.g291341c.dirty

