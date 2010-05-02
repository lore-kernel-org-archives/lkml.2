Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755124Ab0EBGD7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 May 2010 02:03:59 -0400
Received: from mail.skyhub.de ([78.46.96.112]:46207 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752704Ab0EBGD6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 May 2010 02:03:58 -0400
Date: Sun, 2 May 2010 08:03:54 +0200
From: Borislav Petkov <bp@alien8.de>
To: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>
Cc: lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH] ring-buffer: Wrap open-coded WARN_ONCE
Message-ID: <20100502060354.GA5281@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
	lkml <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wrap open-coded WARN_ONCE functionality into the equivalent macro.

Signed-off-by: Borislav Petkov <bp@alien8.de>
---
 kernel/trace/ring_buffer.c |   14 +++++---------
 1 files changed, 5 insertions(+), 9 deletions(-)

diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index 41ca394..19a7407 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -1979,17 +1979,13 @@ rb_add_time_stamp(struct ring_buffer_per_cpu *cpu_buffer,
 		  u64 *ts, u64 *delta)
 {
 	struct ring_buffer_event *event;
-	static int once;
 	int ret;
 
-	if (unlikely(*delta > (1ULL << 59) && !once++)) {
-		printk(KERN_WARNING "Delta way too big! %llu"
-		       " ts=%llu write stamp = %llu\n",
-		       (unsigned long long)*delta,
-		       (unsigned long long)*ts,
-		       (unsigned long long)cpu_buffer->write_stamp);
-		WARN_ON(1);
-	}
+	WARN_ONCE(*delta > (1ULL << 59),
+		  KERN_WARNING "Delta way too big! %llu ts=%llu write stamp = %llu\n",
+		  (unsigned long long)*delta,
+		  (unsigned long long)*ts,
+		  (unsigned long long)cpu_buffer->write_stamp);
 
 	/*
 	 * The delta is too big, we to add a
-- 
1.7.0.3


-- 
Regards/Gruss,
    Boris.
