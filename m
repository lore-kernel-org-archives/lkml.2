Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754457Ab0IOBEz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 21:04:55 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:64544 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754316Ab0IOBEy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 21:04:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=dCv8Lfl0osmV53piEmp/cjxp56Bkpcfoxs/zD7YJO/EHDtGlqO1H3RQVOsuxFDIkpy
         l31WVPaqTikq7C+bPKP8tamiW32jdoaj+esjPB9VV4a7xGaWPhAWsgkouo6IS3a2gcRi
         nEIyylRLpdh6ncNDakKHMlS+uGGgK8Rf6zp7o=
From: Namhyung Kim <namhyung@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/5] kprobes: verify jprobe entry point
Date: Wed, 15 Sep 2010 10:04:27 +0900
Message-Id: <1284512670-2369-3-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <1284512670-2369-1-git-send-email-namhyung@gmail.com>
References: <1284512670-2369-1-git-send-email-namhyung@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

verify jprobe's entry point is a function entry point
using kallsyms' offset value.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
Acked-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
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
-- 
1.7.2.2

