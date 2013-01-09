Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932957Ab3AIUhO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 15:37:14 -0500
Received: from mail.kernel.org ([198.145.19.201]:41279 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932861Ab3AIUhG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 15:37:06 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Steven Rostedt <rostedt@goodmis.org>
Subject: [ 29/47] ftrace: Do not function trace inlined functions
Date: Wed,  9 Jan 2013 12:35:24 -0800
Message-Id: <20130109201732.848206759@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130109201729.435233560@linuxfoundation.org>
References: <20130109201729.435233560@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Steven Rostedt <srostedt@redhat.com>

commit 45959ee7aa645815a5ce303a0ea1e48a21e67c6a upstream.

When gcc inlines a function, it does not mark it with the mcount
prologue, which in turn means that inlined functions are not traced
by the function tracer. But if CONFIG_OPTIMIZE_INLINING is set, then
gcc is allowed not to inline a function that is marked inline.

Depending on the options and the compiler, a function may or may
not be traced by the function tracer, depending on whether gcc
decides to inline a function or not. This has caused several
problems in the pass becaues gcc is not always consistent with
what it decides to inline between different gcc versions.

Some places should not be traced (like paravirt native_* functions)
and these are mostly marked as inline. When gcc decides not to
inline the function, and if that function should not be traced, then
the ftrace function tracer will suddenly break when it use to work
fine. This becomes even harder to debug when different versions of
gcc will not inline that function, making the same kernel and config
work for some gcc versions and not work for others.

By making all functions marked inline to not be traced will remove
the ambiguity that gcc adds when it comes to tracing functions marked
inline. All gcc versions will be consistent with what functions are
traced and having volatile working code will be removed.

Note, only the inline macro when CONFIG_OPTIMIZE_INLINING is set needs
to have notrace added, as the attribute __always_inline will force
the function to be inlined and then not traced.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/linux/compiler-gcc.h |    5 +++++
 1 file changed, 5 insertions(+)

--- a/include/linux/compiler-gcc.h
+++ b/include/linux/compiler-gcc.h
@@ -50,6 +50,11 @@
 # define inline		inline		__attribute__((always_inline))
 # define __inline__	__inline__	__attribute__((always_inline))
 # define __inline	__inline	__attribute__((always_inline))
+#else
+/* A lot of inline functions can cause havoc with function tracing */
+# define inline		inline		notrace
+# define __inline__	__inline__	notrace
+# define __inline	__inline	notrace
 #endif
 
 #define __deprecated			__attribute__((deprecated))


