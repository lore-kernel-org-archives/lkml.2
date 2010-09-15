Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754253Ab0IOBEu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 21:04:50 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:36702 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754144Ab0IOBEt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 21:04:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=lUh9Naw5OHOzA3hOg9TEcIQwfVonzQWuqldDFdISbeMbMB7qpLL3T1IWEJ501bI/xp
         FNOZaBcODGCHaCfxjqo6FBV0wAdQqYo3mbYTSc077fewniKexmeQWJoTv14vKFIvo/Iu
         nfXB1VVVkr241aDnMvA00a/xxRN7kwhwYsDlQ=
From: Namhyung Kim <namhyung@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/5] kprobes: remove redundant address check
Date: Wed, 15 Sep 2010 10:04:26 +0900
Message-Id: <1284512670-2369-2-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <1284512670-2369-1-git-send-email-namhyung@gmail.com>
References: <1284512670-2369-1-git-send-email-namhyung@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

remove call to kernel_text_address() in register_jprobes()
because it is called right after in register_kprobe().

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
Acked-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
---
 kernel/kprobes.c |   13 +++++--------
 1 files changed, 5 insertions(+), 8 deletions(-)

diff --git a/kernel/kprobes.c b/kernel/kprobes.c
index 282035f..8f96701 100644
--- a/kernel/kprobes.c
+++ b/kernel/kprobes.c
@@ -1343,14 +1343,11 @@ int __kprobes register_jprobes(struct jprobe **jps, int num)
 		jp = jps[i];
 		addr = arch_deref_entry_point(jp->entry);
 
-		if (!kernel_text_address(addr))
-			ret = -EINVAL;
-		else {
-			/* Todo: Verify probepoint is a function entry point */
-			jp->kp.pre_handler = setjmp_pre_handler;
-			jp->kp.break_handler = longjmp_break_handler;
-			ret = register_kprobe(&jp->kp);
-		}
+		/* Todo: Verify probepoint is a function entry point */
+		jp->kp.pre_handler = setjmp_pre_handler;
+		jp->kp.break_handler = longjmp_break_handler;
+		ret = register_kprobe(&jp->kp);
+
 		if (ret < 0) {
 			if (i > 0)
 				unregister_jprobes(jps, i);
-- 
1.7.2.2

