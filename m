Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752892Ab0IBFDT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 01:03:19 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:53174 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751909Ab0IBFCx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 01:02:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:message-id:x-mailer:in-reply-to:references;
        b=mn9Z6Q62ydKN8Bw+Ma1VeEGymey8r4AHlami3DldPszJeNuSYkCphvLfbJbVLDtHGz
         3YtxdR2oLan/48hl7nKkXuL6mPmyMZgRb3Lls+WEsY0q29yB1Fx/VXkec1v2VwXgwPUb
         sYPGLLBVaU7ZRNqs2OoDkTaXooCL2G2ptAt9E=
From: Namhyung Kim <namhyung@gmail.com>
To: linux-kernel@vger.kernel.org,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 2/5] kprobes: verify jprobe entry point
Date: Thu,  2 Sep 2010 14:02:35 +0900
Message-Id: <1283403758-3827-3-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <1283403758-3827-1-git-send-email-namhyung@gmail.com>
References: <1283403758-3827-1-git-send-email-namhyung@gmail.com>
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

