Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755975Ab2J1U6l (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2012 16:58:41 -0400
Received: from nm19-vm0.access.bullet.mail.mud.yahoo.com ([66.94.236.25]:31061
	"EHLO nm19-vm0.access.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755732Ab2J1U5M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2012 16:57:12 -0400
X-Yahoo-Newman-Id: 117994.16106.bm@smtp105.sbc.mail.ne1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: eaFCvhwVM1ltq8FNWO5abH3PKAtQUESuR9J4Bhf3U690ezL
 FL3UYdW5fM2mjwXzhcdVM9QrNQ1QWvuvbZZrXM.kJaqSs84JqHO42sO_aGM.
 J__uUCsCpP7MURVjAoF0Fu67iOL3DiS6Rs7D683v7S93ughgRur8.o0E6BlM
 Tb9GfFAw1vpuEBAmjr9HR11z0BFDuyUV8zGzuMHOArMug3DBuOnTzqSY4miy
 knSSk0ouHziqrP9NS5GKYs5I8cp9smKSCAckvTJuvnZOess46eyXRmlohyDx
 ksbS51xdaaoP1KVEwh8zIPSUvEMho8BRQ2BPkt_mAINmyHUgwgzD8zSsrB4o
 xHX_3_nRC2XUYRK.geeooSKMi5vRDrzbAyBXSZUOZmQKUcQzjdvXHu50tyaE
 QAOzfPc3BTkP6o3Kid7qp3_Kf_rT_j8MudvmxgU3ZGxwL87nxXDrfwg--
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
Subject: [PATCH v4 4/9] compiler{,-gcc4}.h, bug.h: Remove duplicate macros
Date: Sun, 28 Oct 2012 15:57:10 -0500
Message-Id: <1351457835-7553-4-git-send-email-daniel.santos@pobox.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1351457648-7453-1-git-send-email-daniel.santos@pobox.com>
References: <1351457648-7453-1-git-send-email-daniel.santos@pobox.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

__linktime_error() does the same thing as __compiletime_error() and is
only used in bug.h.  Since the macro defines a function attribute that
will cause a failure at compile-time (not link-time), it makes more
sense to keep __compiletime_error(), which is also neatly mated with
__compiletime_warning().

Signed-off-by: Daniel Santos <daniel.santos@pobox.com>
Acked-by: David Rientjes <rientjes@google.com>
Acked-by: Borislav Petkov <bp@alien8.de>
---
 include/linux/bug.h           |    2 +-
 include/linux/compiler-gcc4.h |    2 --
 include/linux/compiler.h      |    3 ---
 3 files changed, 1 insertions(+), 6 deletions(-)

diff --git a/include/linux/bug.h b/include/linux/bug.h
index aaac4bb..298a916 100644
--- a/include/linux/bug.h
+++ b/include/linux/bug.h
@@ -73,7 +73,7 @@ extern int __build_bug_on_failed;
 #define BUILD_BUG()						\
 	do {							\
 		extern void __build_bug_failed(void)		\
-			__linktime_error("BUILD_BUG failed");	\
+			__compiletime_error("BUILD_BUG failed");\
 		__build_bug_failed();				\
 	} while (0)
 
diff --git a/include/linux/compiler-gcc4.h b/include/linux/compiler-gcc4.h
index 9755029..7f143ac 100644
--- a/include/linux/compiler-gcc4.h
+++ b/include/linux/compiler-gcc4.h
@@ -33,8 +33,6 @@
    the kernel context */
 #define __cold			__attribute__((__cold__))
 
-#define __linktime_error(message) __attribute__((__error__(message)))
-
 #ifndef __CHECKER__
 # define __compiletime_warning(message) __attribute__((warning(message)))
 # define __compiletime_error(message) __attribute__((error(message)))
diff --git a/include/linux/compiler.h b/include/linux/compiler.h
index b121554..cbf6d9d 100644
--- a/include/linux/compiler.h
+++ b/include/linux/compiler.h
@@ -299,9 +299,6 @@ void ftrace_likely_update(struct ftrace_branch_data *f, int val, int expect);
 #ifndef __compiletime_error
 # define __compiletime_error(message)
 #endif
-#ifndef __linktime_error
-# define __linktime_error(message)
-#endif
 /*
  * Prevent the compiler from merging or refetching accesses.  The compiler
  * is also forbidden from reordering successive instances of ACCESS_ONCE(),
-- 
1.7.3.4

