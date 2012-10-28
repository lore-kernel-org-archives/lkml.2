Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755910Ab2J1U50 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2012 16:57:26 -0400
Received: from nm22-vm0.access.bullet.mail.sp2.yahoo.com ([98.139.44.178]:28891
	"EHLO nm22-vm0.access.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755737Ab2J1U5S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2012 16:57:18 -0400
X-Yahoo-Newman-Id: 433701.16106.bm@smtp105.sbc.mail.ne1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: iy4h88AVM1lutF90xHH1n1zqTEhgT_.bAz6vApvqNacXSDa
 nTGM7FdBv5Yv.nzBGDIqeIoSu2t9vTYjzRKf_DW6xK74bJldyLe8rbRJwQ0X
 tWUBrUHjfjop.5z3U3Tm0CVsV5ic8S4gFWPst8pio8t__LZXsBlnwLrfEmCm
 j9u1Ta0ZA7pAt2jNZKAMaEQUSlrBRNweHGx5PuRggMw1TjohP.ISfTUl6Mxe
 HoIhVLk54fMqCQDGLug4.WZssRn5c8VqjM4AyxBwbUhRPUXaLyvMCNQOqALO
 FERH2PMtwKomx4lCfPNl9zdsXV3NxnQa83Qi1LyEywWoS_vZqpCgFkfJbMCd
 XSTsFdmqwUHPtkT.HYn7utPwG9TENICUqf933M5zthWJgqmqbVvQsolD6iM3
 hirpIr03mPChYZlmnvP5KPAbsyWKiTHYzvB_vg2yU7kmXItUcv_.XG7n_DIC
 LUk4H5kSdFp3N8UrIDpbGd.KlLv1H
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
Subject: [PATCH v4 8/9] bug.h: Add BUILD_BUG_ON_MSG & _BUILD_BUG_INTERNAL
Date: Sun, 28 Oct 2012 15:57:14 -0500
Message-Id: <1351457835-7553-8-git-send-email-daniel.santos@pobox.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1351457648-7453-1-git-send-email-daniel.santos@pobox.com>
References: <1351457648-7453-1-git-send-email-daniel.santos@pobox.com>
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
index 6c38988..3bc1ddf 100644
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

