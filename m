Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946230Ab2LFRJi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 12:09:38 -0500
Received: from mail.eecsit.tu-berlin.de ([130.149.17.13]:65181 "EHLO
	mail.cs.tu-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946199Ab2LFRJe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 12:09:34 -0500
From: =?UTF-8?q?Jan=20H=2E=20Sch=C3=B6nherr?= <schnhrr@cs.tu-berlin.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kay Sievers <kay@vrfy.org>
Cc: linux-kernel@vger.kernel.org, Joe Perches <joe@perches.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        =?UTF-8?q?Jan=20H=2E=20Sch=C3=B6nherr?= <schnhrr@cs.tu-berlin.de>
Subject: [PATCH v2 06/14] printk: move wake_klogd-check out of the loop
Date: Thu,  6 Dec 2012 18:06:03 +0100
Message-Id: <1354813571-11253-7-git-send-email-schnhrr@cs.tu-berlin.de>
X-Mailer: git-send-email 1.8.0.1.20.g7c65b2e.dirty
In-Reply-To: <1354813571-11253-1-git-send-email-schnhrr@cs.tu-berlin.de>
References: <1354813571-11253-1-git-send-email-schnhrr@cs.tu-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The checked criterion is loop-independent and we hold the lock necessary
to do the check also outside the loop. So, move that piece of code more
towards the end where the result is used.

Signed-off-by: Jan H. Schönherr <schnhrr@cs.tu-berlin.de>
---
 kernel/printk.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/kernel/printk.c b/kernel/printk.c
index 7328348..4f3c355 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -2060,10 +2060,6 @@ again:
 		int level;
 
 		raw_spin_lock_irqsave(&logbuf_lock, flags);
-		if (seen_seq != log_next_seq) {
-			wake_klogd = true;
-			seen_seq = log_next_seq;
-		}
 
 		if (console_seq < log_first_seq) {
 			/* messages are gone, move to first one */
@@ -2124,6 +2120,10 @@ skip:
 	 */
 	raw_spin_lock(&logbuf_lock);
 	retry = console_seq != log_next_seq;
+	if (seen_seq != log_next_seq) {
+		wake_klogd = true;
+		seen_seq = log_next_seq;
+	}
 	raw_spin_unlock_irqrestore(&logbuf_lock, flags);
 
 	if (retry && console_trylock())
-- 
1.8.0.1.20.g7c65b2e.dirty

