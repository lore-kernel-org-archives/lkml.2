Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752290Ab0IBFC5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 01:02:57 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:44502 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751060Ab0IBFCu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 01:02:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:message-id:x-mailer:in-reply-to:references;
        b=HGb9RzRk3t2RC0bCaJBairxi4hrsVwc8677vdmGJycsBowTaTEtUJ/uO7vp6fqnPyu
         rpkJ3GQzwB3M/pltBP70MbwruQdIHO48OffuGfZuQo6hrDCuWQxWv8p2UpxHdl22Z/I5
         u5fGjReRExvFMxf+qe6bZWRMWJUqTd605emnI=
From: Namhyung Kim <namhyung@gmail.com>
To: linux-kernel@vger.kernel.org,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 1/5] kprobes: remove redundant address check
Date: Thu,  2 Sep 2010 14:02:34 +0900
Message-Id: <1283403758-3827-2-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <1283403758-3827-1-git-send-email-namhyung@gmail.com>
References: <1283403758-3827-1-git-send-email-namhyung@gmail.com>
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

