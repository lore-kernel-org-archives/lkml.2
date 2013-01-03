Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752797Ab3ACKUS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2013 05:20:18 -0500
Received: from mail-bk0-f47.google.com ([209.85.214.47]:44496 "EHLO
	mail-bk0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751134Ab3ACKUP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2013 05:20:15 -0500
From: kpark3469@gmail.com
To: rostedt@goodmis.org
Cc: fweisbec@gmail.com, mingo@redhat.com, linux@arm.linux.org.uk,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        sahara <keun-o.park@windriver.com>
Subject: [PATCH 1/2] arm: fix returning wrong CALLER_ADDRx
Date: Thu,  3 Jan 2013 19:12:28 +0900
Message-Id: <1357207949-3349-1-git-send-email-kpark3469@gmail.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: sahara <keun-o.park@windriver.com>

This makes return_address return correct value for ftrace feature.
unwind_frame does not update frame->lr but frame->pc for backtrace.
And, the initialization for data.addr was missing so that wrong value
returned when unwind_frame failed.

Signed-off-by: sahara <keun-o.park@windriver.com>
---
 arch/arm/kernel/return_address.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/arm/kernel/return_address.c b/arch/arm/kernel/return_address.c
index 8085417..fafedd8 100644
--- a/arch/arm/kernel/return_address.c
+++ b/arch/arm/kernel/return_address.c
@@ -26,7 +26,7 @@ static int save_return_addr(struct stackframe *frame, void *d)
 	struct return_address_data *data = d;
 
 	if (!data->level) {
-		data->addr = (void *)frame->lr;
+		data->addr = (void *)frame->pc;
 
 		return 1;
 	} else {
@@ -41,7 +41,8 @@ void *return_address(unsigned int level)
 	struct stackframe frame;
 	register unsigned long current_sp asm ("sp");
 
-	data.level = level + 1;
+	data.level = level + 2;
+	data.addr = NULL;
 
 	frame.fp = (unsigned long)__builtin_frame_address(0);
 	frame.sp = current_sp;
-- 
1.7.1

