Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755875Ab2J1U5Y (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2012 16:57:24 -0400
Received: from nm2.access.bullet.mail.mud.yahoo.com ([66.94.237.203]:35019
	"EHLO nm2.access.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755772Ab2J1U5U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2012 16:57:20 -0400
X-Yahoo-Newman-Id: 979214.16106.bm@smtp105.sbc.mail.ne1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: 2ZxHqX8VM1lDGwdLxM2kASHMxrX1gggwPtvGqhhCnm6MZGT
 tDdkdWEi0NcmjQCBbDrKnLlTos2U2lr4RS92i58jEOowcvGfKYquAYg4T5OR
 fip40AWO37UOMNvO5GdX6.zP.1XBdw3Nkpk21DxcEYV4P8wOru7WknB1._O9
 2YzjEuERH7.0TgWxh5PDGyxX8Kd4gxOVud_Xet2N2axygnLIhWCIQw9eDPJw
 .sdKqdxmW2vKDivxjeLo9g8AaQ2JuucC6D0WZx9o2B6rmK19xHR6rsVgBsoa
 SWgysVE6_pK3b8FvbeiEepTRovOla7wW5e_i1z.WI9JVcMlEMkaaeXRgMCN0
 sngH0724kTWQTTs61.djenS07waAzZ5IFj9I5pnVrrh3z.XYIa2AbNfvBl9C
 SeufAgpYM2PMSYG5O24oACdQ8v66nZmxMmRctyZuhwbST6y9Dxfjm4BqGZWD
 LxZ1HNQRbmvq5WoKtFBorqJyJBNcL
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
Subject: [PATCH v4 9/9] bug.h: Convert BUILD_BUG{,_ON} to use BUILD_BUG_ON_MSG
Date: Sun, 28 Oct 2012 15:57:15 -0500
Message-Id: <1351457835-7553-9-git-send-email-daniel.santos@pobox.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1351457648-7453-1-git-send-email-daniel.santos@pobox.com>
References: <1351457648-7453-1-git-send-email-daniel.santos@pobox.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove duplicate code by converting BUILD_BUG and BUILD_BUG_ON to just
call BUILD_BUG_ON_MSG.  This not only reduces source code bloat, but
also prevents the possibility of code being changed for one macro and
not for the other (which was previously the case for BUILD_BUG and
BUILD_BUG_ON).

Signed-off-by: Daniel Santos <daniel.santos@pobox.com>
---
 include/linux/bug.h |   17 +++--------------
 1 files changed, 3 insertions(+), 14 deletions(-)

diff --git a/include/linux/bug.h b/include/linux/bug.h
index 3bc1ddf..b58ba51 100644
--- a/include/linux/bug.h
+++ b/include/linux/bug.h
@@ -81,14 +81,8 @@ struct pt_regs;
 #ifndef __OPTIMIZE__
 #define BUILD_BUG_ON(condition) __compiletime_error_fallback(condition)
 #else
-#define BUILD_BUG_ON(condition)						\
-	do {								\
-		extern void __build_bug_on_failed(void)			\
-			__compiletime_error("BUILD_BUG_ON failed");	\
-		__compiletime_error_fallback(condition);		\
-		if (condition)						\
-			__build_bug_on_failed();			\
-	} while(0)
+#define BUILD_BUG_ON(condition) \
+	BUILD_BUG_ON_MSG(condition, "BUILD_BUG_ON failed: " #condition)
 #endif
 
 /**
@@ -98,12 +92,7 @@ struct pt_regs;
  * build time, you should use BUILD_BUG to detect if it is
  * unexpectedly used.
  */
-#define BUILD_BUG()						\
-	do {							\
-		extern void __build_bug_failed(void)		\
-			__compiletime_error("BUILD_BUG failed");\
-		__build_bug_failed();				\
-	} while (0)
+#define BUILD_BUG() BUILD_BUG_ON_MSG(1, "BUILD_BUG failed")
 
 #endif	/* __CHECKER__ */
 
-- 
1.7.3.4

