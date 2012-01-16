Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757166Ab2APW5V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jan 2012 17:57:21 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:34926 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756729Ab2APW5U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jan 2012 17:57:20 -0500
X-Authority-Analysis: v=2.0 cv=SqgSGYy0 c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=upWhEs_B3ZQA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=5WgTN1gKfifDXCnjasEA:9 a=7isuxI_w8p4H3USrx1wA:7 a=PUjeQqilurYA:10 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1326754637.7642.177.camel@gandalf.stny.rr.com>
Subject: [PATCH][GIT PULL][v3.3] tracing: Add header wrappers
 event_headers_start.h and event_headers_end.h
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Date: Mon, 16 Jan 2012 17:57:17 -0500
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ingo,

This is actually a special pull request. This patch adds two new files
that are not used by anyone. The rational for this is, they will be
required for v3.4 and I want to make the transition in linux-next as
smooth as possible. Let me explain the situation.

There has been more and more cases where trace/events/*.h headers have
been showing up in normal header files. This is fine unless one of these
normal header files ends up included in another trace/events/*.h file.
What happens then, is when the CREATE_TRACE_POINTS is defined both
headers get evaluated. This means the C functions to create the
tracepoints are created for both the initial trace/events/*.h header, as
well as the one that got included by the normal header file. This makes
the build fail. We've already had to fix this up a few times to handle
these cases.

I added two header files:

 include/trace/event_headers_start.h
 include/trace/event_headers_end.h

These headers add some macro magic to handle the nested tracepoint event
headers that was described above.

The way this works is that all tracepoint event headers must include
these two headers around their other includes. For example trace/sched.h
will now have:

#include <trace/event_headers_start.h>
#include <linux/sched.h>
#include <linux/tracepoint.h>
#include <trace/event_headers_end.h>

I've already updated all the tracepoint headers inside the latest
kernel. I searched all headers with "TRACE_EVENT" in them to catch
headers outside of trace/events/ that define trace event headers.

The issue I see, and why I want this patch into 3.3 is that I have a
warning that will print if someone adds a new tracepoint event header
and doesn't add these files. If this warning goes into linux-next, and
someone adds a new tracepoint event header, they will start getting this
warning. The only way for them to stop it, is to include the above
wrappers. The problem is, the wrappers will not exist in the kernel that
gets pulled into linux-next, unless we push them now into 3.3.

Now if you feel this is too much and do not want to include files into
3.3 that are not being used, I can hold off the warning patch until 3.5,
and then we may have a mixture of files with and without these header
wrappers in 3.4.

What's your thoughts on this?

-- Steve


Please pull the latest tip/perf/urgent-3 tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git
tip/perf/urgent-3

Head SHA1: 8bc9bfdfd80d28b0902ee168b9b2c181e7e37c35


Steven Rostedt (1):
      tracing: Add header wrappers event_headers_start.h and event_headers_end.h

----
 include/trace/event_headers_end.h   |   41 ++++++++++++++++++++
 include/trace/event_headers_start.h |   71 +++++++++++++++++++++++++++++++++++
 2 files changed, 112 insertions(+), 0 deletions(-)
---------------------------
commit 8bc9bfdfd80d28b0902ee168b9b2c181e7e37c35
Author: Steven Rostedt <srostedt@redhat.com>
Date:   Mon Jan 16 17:00:19 2012 -0500

    tracing: Add header wrappers event_headers_start.h and event_headers_end.h
    
    As more tracepoints are created, more are being added inside of header
    files to add tracepoints into static inline functions. If another tracepoint
    header includes a header with a tracepoint header within it, it can break
    the build.
    
    The reason is that the tracepoint headers create their C functions when the
    CREATE_TRACE_POINT macro is defined. But if the tracepoint header includes
    another tracepoint header, the C functions for that second tracepoint header
    will also be defined, causing the C functions to be defined in more than one
    location.
    
    To prevent this, two headers were created that must be wrapped around
    all headers within tracepoint headers. These wrapper headers has some logic
    to deal with the CREATE_TRACE_POINTS being set, and undefines it. The
    second wrapper header will define it again.
    
    This is only part of the solution. The other part is that all tracepoint headers
    that are included within normal headers, must also wrap the TRACE_SYSTEM
    macro define with #ifdef CONFIG_TRACE_POINTS. This second change will come
    later.
    
    Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

diff --git a/include/trace/event_headers_end.h b/include/trace/event_headers_end.h
new file mode 100644
index 0000000..a5bd8f4
--- /dev/null
+++ b/include/trace/event_headers_end.h
@@ -0,0 +1,41 @@
+
+/* See event_headers_start.h for details. */
+
+#ifdef REENABLE_CREATE_TRACE_POINTS
+
+/* must be a better way to decrement a macro counter */
+
+# if REENABLE_CREATE_TRACE_POINTS == 0
+
+# elif REENABLE_CREATE_TRACE_POINTS == 1
+#  define CREATE_TRACE_POINTS
+
+/*
+ * Keeping REENABLE_CREATE_TRACE_POINTS undefined
+ * will cause the rest of the #elif to fail.
+ * Set it to zero, it will act the same as undefined.
+ */
+#  undef REENABLE_CREATE_TRACE_POINTS
+#  define REENABLE_CREATE_TRACE_POINTS 0
+
+/*
+ * Would be nice to use elif here, but it seems that the
+ * above 'undef' or any redefining the 
+ */
+# elif REENABLE_CREATE_TRACE_POINTS == 2
+#  undef REENABLE_CREATE_TRACE_POINTS
+#  define REENABLE_CREATE_TRACE_POINTS 1
+
+# elif REENABLE_CREATE_TRACE_POINTS == 3
+#  undef REENABLE_CREATE_TRACE_POINTS
+#  define REENABLE_CREATE_TRACE_POINTS 2
+
+# elif REENABLE_CREATE_TRACE_POINTS == 4
+#  undef REENABLE_CREATE_TRACE_POINTS
+#  define REENABLE_CREATE_TRACE_POINTS 3
+
+# else
+#   error Bad REENABLE_CREATE_TRACE_POINTS number
+# endif
+
+#endif
diff --git a/include/trace/event_headers_start.h b/include/trace/event_headers_start.h
new file mode 100644
index 0000000..063df69
--- /dev/null
+++ b/include/trace/event_headers_start.h
@@ -0,0 +1,71 @@
+/*
+ * Because some trace/events/foo.h headers are included in normal headers,
+ * compiling can fail if one of these normal headers is included inside
+ * another trace/events/foo.h header. This is because when CREATE_TRACE_POINTS
+ * is defined, the trace/events/foo.h header file becomes activated to
+ * create the necessary C functions to use with tracepoints.
+ *
+ * The problem is that one trace/events/foo.h header will create the
+ * tracepoints for both included headers, and when the other header
+ * is called with CREATE_TRACE_POINTS, it will create duplicated functions
+ * and cause the build to fail.
+ *
+ * To allow other headers to be nested, we need to save the nesting level
+ * of these calls (REENABLE_CREATE_TRACE_POINTS) and disable the
+ * CREATE_TRACE_POINTS while the headers are nested.
+ *
+ * For this to work, all trace/events/foo.h headers should wrap all their
+ * headers with:
+ *
+ *  #include <trace/event_headers_start.h>
+ *  [...]
+ *  #include <trace/event_headers_end.h>
+ *
+ * Unfortunately, macros are evaluate at the location of their use
+ * and not at the #define, so we need to create our own counter.
+ * We support up to 4 nested trace/events/foo.h headers, which should
+ * be way more than enough.
+ */
+#ifdef CREATE_TRACE_POINTS
+
+#undef CREATE_TRACE_POINTS
+
+#ifdef REENABLE_CREATE_TRACE_POINTS
+# if REENABLE_CREATE_TRACE_POINTS != 0
+#  error Problem calculating REENABLE_CREATE_TRACE_POINTS
+# endif
+# undef REENABLE_CREATE_TRACE_POINTS
+#endif
+
+#define REENABLE_CREATE_TRACE_POINTS 1
+
+#else
+
+# ifdef REENABLE_CREATE_TRACE_POINTS
+/* Must be a better way to increment a macro counter */
+
+/*
+ * We allow four levels of nested event headers, which should
+ * be way more than enough.
+ */
+#  if REENABLE_CREATE_TRACE_POINTS == 0
+/* Do nothing. */
+
+#  elif REENABLE_CREATE_TRACE_POINTS == 1
+#   undef REENABLE_CREATE_TRACE_POINTS
+#   define REENABLE_CREATE_TRACE_POINTS 2
+
+#  elif REENABLE_CREATE_TRACE_POINTS == 2
+#   undef REENABLE_CREATE_TRACE_POINTS
+#   define REENABLE_CREATE_TRACE_POINTS 3
+
+#  elif REENABLE_CREATE_TRACE_POINTS == 3
+#   undef REENABLE_CREATE_TRACE_POINTS
+#   define REENABLE_CREATE_TRACE_POINTS 4
+
+#  else
+#   error Too many nested trace/events headers
+#  endif
+# endif
+
+#endif


