Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752522Ab3AAWyY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jan 2013 17:54:24 -0500
Received: from nm12.access.bullet.mail.mud.yahoo.com ([66.94.237.213]:30335
	"EHLO nm12.access.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752447Ab3AAWyT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jan 2013 17:54:19 -0500
X-Yahoo-Newman-Id: 603681.18166.bm@smtp107.sbc.mail.bf1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: J2ptmOAVM1kBD3xCelfj.e8fKXB21KwQKzFz0Y663K3iaUI
 GBg2wPJCEEZImKMJwQDbmsaozKiKWP7AvvWGm4YH.ygfnEym4saTyU9lCGzT
 kA94dQLOGvM6Ag8rzNsUHk7eb4y0D53JuMwEHRXmV9zGhXPCHTKfw27WC2LT
 7y2sC8II1FeIF5v9itavo4mGByWc.AP3Jis1DMB4kdEM_ZFO67CLkOvtxWMm
 8u9sEq_Jr_Id_o.JQ4UhrrqVw8kL_FIC.vMFz1PhiyVhB1ATqD41EXWLJ_dw
 2fZhUUCdk._qUMszN7U4.Ikk5.PEmzqYtSf4CJMyelOj3rFkYnotcJSee6xB
 3ptEJ64AIdyEmsxV.wiFWUY4RfwI91EXfEwt6kmQZ6wVeKMk47pQoGrEjuhW
 muKA3rijy58tBYkWwKNzpiwH.JG11CShRb7NZEf.ikXgW3imDrMH4tuXgUlk
 HyyuDTgMHPGtXQ8RIcFHnZwe76Sks4gg-
X-Yahoo-SMTP: xXkkXk6swBBAi.5wfkIWFW3ugxbrqyhyk_b4Z25Sfu.XGQ--
From: danielfsantos@att.net
To: LKML <linux-kernel@vger.kernel.org>, Andi Kleen <ak@linux.intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Borislav Petkov <bp@alien8.de>, Christopher Li <sparse@chrisli.org>,
        David Daney <david.daney@cavium.com>,
        David Rientjes <rientjes@google.com>, Joe Perches <joe@perches.com>,
        Josh Triplett <josh@joshtriplett.org>, linux-sparse@vger.kernel.org,
        Michel Lespinasse <walken@google.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Steven Rostedt <rostedt@goodmis.org>
Cc: Daniel Santos <daniel.santos@pobox.com>
Subject: [PATCH v8 1/9] compiler-gcc4.h: Reorder macros based upon gcc ver
Date: Tue,  1 Jan 2013 16:54:03 -0600
Message-Id: <1357080851-30938-2-git-send-email-daniel.santos@pobox.com>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <1357080851-30938-1-git-send-email-daniel.santos@pobox.com>
References: <1348874411-28288-1-git-send-email-daniel.santos@pobox.com>
 <1357080851-30938-1-git-send-email-daniel.santos@pobox.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This helps to keep the file from getting confusing, removes one
duplicate version check and should encourage future editors to put new
macros where they belong.

Signed-off-by: Daniel Santos <daniel.santos@pobox.com>
Acked-by: David Rientjes <rientjes@google.com>
Acked-by: Borislav Petkov <bp@alien8.de>
---
 include/linux/compiler-gcc4.h |   20 +++++++++++---------
 1 files changed, 11 insertions(+), 9 deletions(-)

diff --git a/include/linux/compiler-gcc4.h b/include/linux/compiler-gcc4.h
index 662fd1b..c9785c2 100644
--- a/include/linux/compiler-gcc4.h
+++ b/include/linux/compiler-gcc4.h
@@ -13,6 +13,10 @@
 #define __must_check 		__attribute__((warn_unused_result))
 #define __compiler_offsetof(a,b) __builtin_offsetof(a,b)
 
+#if __GNUC_MINOR__ > 0
+# define __compiletime_object_size(obj) __builtin_object_size(obj, 0)
+#endif
+
 #if __GNUC_MINOR__ >= 3
 /* Mark functions as cold. gcc will assume any path leading to a call
    to them will be unlikely.  This means a lot of manual unlikely()s
@@ -33,6 +37,12 @@
 
 #define __UNIQUE_ID(prefix) __PASTE(__PASTE(__UNIQUE_ID_, prefix), __COUNTER__)
 
+#ifndef __CHECKER__
+# define __compiletime_warning(message) __attribute__((warning(message)))
+# define __compiletime_error(message) __attribute__((error(message)))
+#endif /* __CHECKER__ */
+#endif /* __GNUC_MINOR__ >= 3 */
+
 #if __GNUC_MINOR__ >= 5
 /*
  * Mark a position in code as unreachable.  This can be used to
@@ -48,8 +58,7 @@
 /* Mark a function definition as prohibited from being cloned. */
 #define __noclone	__attribute__((__noclone__))
 
-#endif
-#endif
+#endif /* __GNUC_MINOR__ >= 5 */
 
 #if __GNUC_MINOR__ >= 6
 /*
@@ -58,13 +67,6 @@
 #define __visible __attribute__((externally_visible))
 #endif
 
-#if __GNUC_MINOR__ > 0
-#define __compiletime_object_size(obj) __builtin_object_size(obj, 0)
-#endif
-#if __GNUC_MINOR__ >= 3 && !defined(__CHECKER__)
-#define __compiletime_warning(message) __attribute__((warning(message)))
-#define __compiletime_error(message) __attribute__((error(message)))
-#endif
 
 #ifdef CONFIG_ARCH_USE_BUILTIN_BSWAP
 #if __GNUC_MINOR__ >= 4
-- 
1.7.8.6

