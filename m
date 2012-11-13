Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755340Ab2KMWOI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 17:14:08 -0500
Received: from nm25.access.bullet.mail.mud.yahoo.com ([66.94.237.90]:27558
	"EHLO nm25.access.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753872Ab2KMWN7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 17:13:59 -0500
X-Yahoo-Newman-Id: 901629.28409.bm@smtp115.sbc.mail.ne1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: Cotpxm8VM1lHs32QvPqceHomGPygDY5eVLW5RmwDS.Jhqvc
 ubfOLgL1eSM7jSM6uxKtceHkqgDi2FqP8qjUjcAszekFoY.atcpJhgJ1tITL
 T842xJijiKVOfXRyrmZaibMLqtMzo5Gn4Kv1k8EJ8Ybq_MBcPwngOvJP8QX4
 PenTWLrQqFzeQ1Ei2df3.ccPZS.FceLQ3LQQYfq9WdC5JgTw9RUUGV6ak66U
 J6NBhvAKSZ_5Fne6zFcicQ8TNesuUQsqITYGCl6Txb_k1WOYRSD2qC3oO357
 UI.oCSJ5c..5kQKTwVQuNrSmbVg45LwtdvT67sin0dfTs6droE.jKgwDNWSE
 v4U3s5zWnzYepwZEyp8_gFrJjTPb3T.CycsmEE5qPzZDw4FxamwKaNrsJqOp
 tEIRrD2_dIhx7XfIx4jBT5bif72tajnvWUp9HLyAKU2GRnQrqk_nkqnFjLqV
 _qVuM6K_38vQuevOFEuiOQa73iEzc
X-Yahoo-SMTP: xXkkXk6swBBAi.5wfkIWFW3ugxbrqyhyk_b4Z25Sfu.XGQ--
From: danielfsantos@att.net
To: LKML <linux-kernel@vger.kernel.org>, Andi Kleen <ak@linux.intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Borislav Petkov <bp@alien8.de>, Christopher Li <sparse@chrisli.org>,
        Daniel Santos <daniel.santos@pobox.com>,
        David Daney <david.daney@cavium.com>,
        David Howells <dhowells@redhat.com>, Joe Perches <joe@perches.com>,
        Josh Triplett <josh@joshtriplett.org>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        linux-sparse@vger.kernel.org, Michel Lespinasse <walken@google.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Pavel Pisa <pisa@cmp.felk.cvut.cz>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH v5 6/9] bug.h: Prevent double evaulation of in BUILD_BUG_ON
Date: Tue, 13 Nov 2012 16:13:38 -0600
Message-Id: <1352844821-18952-6-git-send-email-daniel.santos@pobox.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1352844568-18826-1-git-send-email-daniel.santos@pobox.com>
References: <1352844568-18826-1-git-send-email-daniel.santos@pobox.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When calling BUILD_BUG_ON in an optimized build using gcc 4.3 and later,
the condition will be evaulated twice, possibily with side-effects.
This patch eliminates that error.

Signed-off-by: Daniel Santos <daniel.santos@pobox.com>
---
 include/linux/bug.h |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/include/linux/bug.h b/include/linux/bug.h
index 1b2465d..ccd44ce 100644
--- a/include/linux/bug.h
+++ b/include/linux/bug.h
@@ -58,8 +58,9 @@ struct pt_regs;
 extern int __build_bug_on_failed;
 #define BUILD_BUG_ON(condition)					\
 	do {							\
-		((void)sizeof(char[1 - 2*!!(condition)]));	\
-		if (condition) __build_bug_on_failed = 1;	\
+		bool __cond = !!(condition);			\
+		((void)sizeof(char[1 - 2*!!(__cond)]));		\
+		if (__cond) __build_bug_on_failed = 1;		\
 	} while(0)
 #endif
 
-- 
1.7.3.4

