Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753285Ab0IOKFV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Sep 2010 06:05:21 -0400
Received: from hera.kernel.org ([140.211.167.34]:39983 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752605Ab0IOKE7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Sep 2010 06:04:59 -0400
Date: Wed, 15 Sep 2010 10:04:32 GMT
From: tip-bot for Namhyung Kim <namhyung@gmail.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        masami.hiramatsu.pt@hitachi.com, tglx@linutronix.de,
        namhyung@gmail.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        masami.hiramatsu.pt@hitachi.com, tglx@linutronix.de,
        namhyung@gmail.com, mingo@elte.hu
In-Reply-To: <1284512670-2369-3-git-send-email-namhyung@gmail.com>
References: <1284512670-2369-3-git-send-email-namhyung@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] kprobes: Verify jprobe entry point
Message-ID: <tip-05662bdb64c746079de7ac4dc4fb4caa5e8e119f@git.kernel.org>
Git-Commit-ID: 05662bdb64c746079de7ac4dc4fb4caa5e8e119f
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 15 Sep 2010 10:04:33 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  05662bdb64c746079de7ac4dc4fb4caa5e8e119f
Gitweb:     http://git.kernel.org/tip/05662bdb64c746079de7ac4dc4fb4caa5e8e119f
Author:     Namhyung Kim <namhyung@gmail.com>
AuthorDate: Wed, 15 Sep 2010 10:04:27 +0900
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 15 Sep 2010 10:44:01 +0200

kprobes: Verify jprobe entry point

Verify jprobe's entry point is a function entry point
using kallsyms' offset value.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
Acked-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
LKML-Reference: <1284512670-2369-3-git-send-email-namhyung@gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/kprobes.c |   14 +++++++++-----
 1 files changed, 9 insertions(+), 5 deletions(-)

diff --git a/kernel/kprobes.c b/kernel/kprobes.c
index 8f96701..1b0dbe0 100644
--- a/kernel/kprobes.c
+++ b/kernel/kprobes.c
@@ -1339,14 +1339,18 @@ int __kprobes register_jprobes(struct jprobe **jps, int num)
 	if (num <= 0)
 		return -EINVAL;
 	for (i = 0; i < num; i++) {
-		unsigned long addr;
+		unsigned long addr, offset;
 		jp = jps[i];
 		addr = arch_deref_entry_point(jp->entry);
 
-		/* Todo: Verify probepoint is a function entry point */
-		jp->kp.pre_handler = setjmp_pre_handler;
-		jp->kp.break_handler = longjmp_break_handler;
-		ret = register_kprobe(&jp->kp);
+		/* Verify probepoint is a function entry point */
+		if (kallsyms_lookup_size_offset(addr, NULL, &offset) &&
+		    offset == 0) {
+			jp->kp.pre_handler = setjmp_pre_handler;
+			jp->kp.break_handler = longjmp_break_handler;
+			ret = register_kprobe(&jp->kp);
+		} else
+			ret = -EINVAL;
 
 		if (ret < 0) {
 			if (i > 0)
