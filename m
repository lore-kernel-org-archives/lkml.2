Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935049Ab2JXQjr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 12:39:47 -0400
Received: from nm30-vm0.access.bullet.mail.sp2.yahoo.com ([98.139.44.194]:25206
	"EHLO nm30-vm0.access.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933811Ab2JXQjp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 12:39:45 -0400
X-Yahoo-Newman-Id: 852865.79197.bm@smtp105.sbc.mail.gq1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: 0.0QFHkVM1m31ziTRQJvMHJZ.I5QmQlijKAO4Oj0.MxIBBS
 W_wwXUB2QE.EbxPKEgQNqlKzGIn0iOGmbwbANRzU2KDD.AX5WiXMhAjNKcOz
 qY.8lQIrMJDrVz3ZCooBeycGEWM8nnEzre4yPLep5_anIDXFbbHojbcFzGP6
 8sEdW0dLNnXcL0DyVq_dlhvXSVSgbGSs0AQL9sg5boBLpwDmn9_8rGAD.Kck
 HldZnSsx7DBPpOc81Inw8I_F.dBg.5aJ0plr87MxFITQHu_NH9I1Au09tS3M
 bnQmXZzGiZq64HpMMoVmixwjmADRB.OLTdqR4zJ.DEWLvYGfgWhNf36vCml1
 0HF9Z1j2c9pIyeC_hCB3DHFvjAYjNOb9q3wBzIwRuHn0KGb.54Dg4woOXDsS
 xCktZaQUxPXlhyvkqbLB5qkx74LV1q5lxAS.86zY8qnaqjtB7IOk8
X-Yahoo-SMTP: xXkkXk6swBBAi.5wfkIWFW3ugxbrqyhyk_b4Z25Sfu.XGQ--
From: danielfsantos@att.net
To: LKML <linux-kernel@vger.kernel.org>, Andi Kleen <ak@linux.intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Christopher Li <sparse@chrisli.org>,
        Daniel Santos <daniel.santos@pobox.com>,
        David Daney <david.daney@cavium.com>,
        David Howells <dhowells@redhat.com>, Joe Perches <joe@perches.com>,
        Josh Triplett <josh@joshtriplett.org>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        linux-sparse@vger.kernel.org, Michel Lespinasse <walken@google.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Pavel Pisa <pisa@cmp.felk.cvut.cz>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Steven Rostedt <rostedt@goodmis.org>, Borislav Petkov <bp@alien8.de>,
        David Rientjes <rientjes@google.com>
Subject: [PATCH v3 09/10] bug.h: Add BUILD_BUG_ON_MSG & _BUILD_BUG_INTERNAL
Date: Wed, 24 Oct 2012 11:34:00 -0500
Message-Id: <1351096441-12388-9-git-send-email-daniel.santos@pobox.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1351096132-12244-1-git-send-email-daniel.santos@pobox.com>
References: <1351096132-12244-1-git-send-email-daniel.santos@pobox.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add BUILD_BUG_ON_MSG which behaves like BUILD_BUG_ON (with optimizations
enabled), except that it allows you to specify the error message you
want emitted as the third parameter.  Under the hood, this relies on
_BUILD_BUG_INTERNAL, which does the actual work and is pretty-much
identical to BUILD_BUG_ON.

Signed-off-by: Daniel Santos <daniel.santos@pobox.com>
---
 include/linux/bug.h |   22 ++++++++++++++++++++++
 1 files changed, 22 insertions(+), 0 deletions(-)

diff --git a/include/linux/bug.h b/include/linux/bug.h
index 1b43ea2..f6f81f6 100644
--- a/include/linux/bug.h
+++ b/include/linux/bug.h
@@ -16,6 +16,7 @@ struct pt_regs;
 #define BUILD_BUG_ON_NOT_POWER_OF_2(n)
 #define BUILD_BUG_ON_ZERO(e) (0)
 #define BUILD_BUG_ON_NULL(e) ((void*)0)
+#define BUILD_BUG_ON_MSG(cond, msg) (0)
 #define BUILD_BUG_ON(condition) (0)
 #define BUILD_BUG() (0)
 #else /* __CHECKER__ */
@@ -38,6 +39,27 @@ struct pt_regs;
  */
 #define BUILD_BUG_ON_INVALID(e) ((void)(sizeof((__force long)(e))))
 
+#define __BUILD_BUG_INTERNAL(condition, msg, line)		\
+	do {							\
+		extern void __build_bug_on_failed_ ## line	\
+			(void) __compiletime_error(msg);	\
+		__compiletime_error_fallback(condition);	\
+		if (condition)					\
+			__build_bug_on_failed_ ## line();	\
+	} while (0)
+
+#define _BUILD_BUG_INTERNAL(condition, msg, line) \
+	__BUILD_BUG_INTERNAL(condition, msg, line)
+
+/**
+ * BUILD_BUG_ON_MSG - break compile if a condition is true & emit supplied
+ * 		      error message.
+ * @condition: the condition which the compiler should know is false.
+ *
+ * See BUILD_BUG_ON for description.
+ */
+#define BUILD_BUG_ON_MSG(cond, msg) _BUILD_BUG_INTERNAL(cond, msg, __LINE__)
+
 /**
  * BUILD_BUG_ON - break compile if a condition is true.
  * @condition: the condition which the compiler should know is false.
-- 
1.7.3.4

