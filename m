Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753001Ab2FWECS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2012 00:02:18 -0400
Received: from nm4.access.bullet.mail.mud.yahoo.com ([66.94.237.205]:47641
	"HELO nm4.access.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751312Ab2FWEBh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2012 00:01:37 -0400
X-Yahoo-Newman-Id: 786233.55476.bm@smtp103.sbc.mail.bf1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: 0.PtJOIVM1l6QYG3IENtQdCWBCEcqzugVfhniTqnl.1oaQl
 b8AS01hwyHn67mBXdOogFSpG2QY9gjcfz4RxflbdW.4mBtWT1XBLhOThu3sR
 2a_LQN6xGPLQsVIJfTls0DUAamPQ8ig7y51lxeMMauVSQuxCKdIsOXW2etZp
 SSp_pt8DznylpaHcAYsdvW68vNBTo6RIzeCI0pNf._kHQJA07Q34g6EXXcW0
 s5ayHmwCayuddT9TlUjFUFpsgXfPamhpUuEmPqWAa5iBA2.4H13ksSzqKVoH
 3pqeNukli.GvgwzTmmB6FnyIw.dZAGeigtfScw3H7vNQ3ixVu6nxeZdYdo8N
 8c3.behm48Tp7ckAXL61tAKx3Ahr7NCWAuT.n5Mm7G1ukPsCgnDjl50hsOIs
 NFp7I3hC7V025zS2t1KaMkuhC8uj0mK5h3sbtwmouFvJ30hPK9HlAaVdSN9X
 7D1naTpn3bLk5O90wm_Q81ulRRlkITr25LCEWsw1VLOiyP3J9C_XEXWcfeu2
 UNTV76hhdb1FKFFsTiB0Rak23oWDpavTl02ghFzVOcvGzX54FnFqmW5Yy9JE
 Q.LUk96lCQBnSsD8IqxtY1XU1ufTcPslS4n56dw_FfA--
X-Yahoo-SMTP: xXkkXk6swBBAi.5wfkIWFW3ugxbrqyhyk_b4Z25Sfu.XGQ--
From: Daniel Santos <daniel.santos@pobox.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Christopher Li <sparse@chrisli.org>,
        Daniel Santos <daniel.santos@pobox.com>,
        David Daney <david.daney@cavium.com>,
        David Howells <dhowells@redhat.com>,
        David Rientjes <rientjes@google.com>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Ingo Molnar <mingo@kernel.org>, Joe Perches <joe@perches.com>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        linux-doc@vger.kernel.org, linux-sparse@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Paul Turner <pjt@google.com>, Pavel Pisa <pisa@cmp.felk.cvut.cz>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Richard Weinberger <richard@nod.at>, Rob Landley <rob@landley.net>,
        Steven Rostedt <rostedt@goodmis.org>,
        Suresh Siddha <suresh.b.siddha@intel.com>
Subject: [PATCH v4 7/13] compiler{,-gcc4}.h: Introduce __flatten function attribute
Date: Fri, 22 Jun 2012 23:00:42 -0500
Message-Id: <1340424048-7759-8-git-send-email-daniel.santos@pobox.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1340424048-7759-1-git-send-email-daniel.santos@pobox.com>
References: <1340424048-7759-1-git-send-email-daniel.santos@pobox.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For gcc 4.1 & later, expands to __attribute__((flatten)) which forces
the compiler to inline everything it can into the function.  This is
useful in combination with noinline when you want to control the depth
of inlining, or create a single function where inline expansions will
occur. (see
http://gcc.gnu.org/onlinedocs/gcc/Function-Attributes.html#index-g_t_0040code_007bflatten_007d-function-attribute-2512)

Normally, it's best to leave this type of thing up to the compiler.
However, the generic rbtree code uses inline functions just to be able
to inject compile-time constant data that specifies how the caller wants
the function to behave (via struct rb_relationship).  This data can be
thought of as the template parameters of a C++ templatized function.
Since some of these functions, once expanded, become quite large, gcc
sometimes decides not to perform some important inlining, in one case,
even generating a few bytes more code by not doing so. (Note: I have not
eliminated the possibility that this was an optimization bug, but the
flatten attribute fixes it in either case.)

Combining __flatten and noinline insures that important optimizations
occur in these cases and that the inline expansion occurs in exactly one
place, thus not leading to unnecissary bloat. However, it also can
eliminate some opportunities for optimization should gcc otherwise
decide the function its self is a good candidate for inlining.

Signed-off-by: Daniel Santos <daniel.santos@pobox.com>
---
 include/linux/compiler-gcc4.h |    7 ++++++-
 include/linux/compiler.h      |    4 ++++
 2 files changed, 10 insertions(+), 1 deletions(-)

diff --git a/include/linux/compiler-gcc4.h b/include/linux/compiler-gcc4.h
index 5755e23..38fb81d 100644
--- a/include/linux/compiler-gcc4.h
+++ b/include/linux/compiler-gcc4.h
@@ -15,7 +15,12 @@
 
 #if GCC_VERSION >= 40102
 # define __compiletime_object_size(obj) __builtin_object_size(obj, 0)
-#endif
+
+/* flatten introduced in 4.1, but broken in 4.6.0 (gcc bug #48731)*/
+# if GCC_VERSION != 40600
+#  define __flatten __attribute__((flatten))
+# endif
+#endif /* GCC_VERSION >= 40102 */
 
 #if GCC_VERSION >= 40300
 /* Mark functions as cold. gcc will assume any path leading to a call
diff --git a/include/linux/compiler.h b/include/linux/compiler.h
index 4d9f353..b26d606 100644
--- a/include/linux/compiler.h
+++ b/include/linux/compiler.h
@@ -244,6 +244,10 @@ void ftrace_likely_update(struct ftrace_branch_data *f, int val, int expect);
 #define __always_inline inline
 #endif
 
+#ifndef __flatten
+#define __flatten
+#endif
+
 #endif /* __KERNEL__ */
 
 /*
-- 
1.7.3.4

