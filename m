Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756135Ab1DBMvV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Apr 2011 08:51:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:27240 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755459Ab1DBMvU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Apr 2011 08:51:20 -0400
Message-ID: <4D971BC4.7010404@redhat.com>
Date: Sat, 02 Apr 2011 08:51:16 -0400
From: Prarit Bhargava <prarit@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.9) Gecko/20100505 Fedora/3.0.4-2.el6 Thunderbird/3.0.4
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Steven Rostedt <rostedt@goodmis.org>, dzickus@redhat.com
Subject: Re: [PATCH]: Use cmpxchg() in WARN_*_ONCE() functions
References: <20110331124607.13219.33332.sendpatchset@prarit.bos.redhat.com> <20110331152319.GC14441@home.goodmis.org>
In-Reply-To: <20110331152319.GC14441@home.goodmis.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Missed deleting a chunk at the end of the patch...

An issue popped up where WARN_ON_ONCE() was used in a callback function
in smp_call_function().  This resulted in the WARN_ON executing multiple times
when it should have only executed once.

We cannot use a lock in the WARN_*_ONCE functions because it is far too heavy
for the code in question.  Don Zickus suggested using cmpxchg(), which resolves
the problem of the multiple outputs.

The question surrounding cmpxchg(), of course, is one of performance.  It
appears that, at least on x86, it isn't a concern.

I ran the following test in a simple module:

void prarit_callback(void *info)
{
        WARN_ON_ONCE(1);
}

        for (j = 0; j < 10; j++)
                for (i = 0; i < 1000000; i++)
                        prarit_callback(NULL);

With the current code in place an average of 10 runs was .219s.  Doing just
a (!cmpxchg(&__warned, 0, 1)) the time jumps to .402s.  Adding in a check
for the __warned flag, (!__warned && !cmpxchg(&__warned, 0, 1)), results in
an average of .220s.

I then did

        for (i = 0; i < 1000000; i++)
                on_each_cpu(prarit_callback, NULL, 0);

The current code, of course, explodes :).  That's the bug I'm trying to fix.
What is interesting in this test, however, is the impact that checking the
!__warned flag has [Aside: Checking the !__warned flag is an enhancement
and is not explicitly required for this code].

A run with just (!cmpxchg(&__warned, 0, 1)) results in an average of 21.323s,
and a run with  (!__warned && !cmpxchg(&__warned, 0, 1)) results in an
average of 20.233s.  Of course, the !__warned is not necessary for the code
to work properly but it seems to be a significant impact to the time to run
this code.

P.

WARN_ON_ONCE() is used in callback functions in smp_call_function().  This
results in races through the WARN_ON() code.

Use cmxchg() in the WARN_*_ON functions in order to guarantee single
execution of the WARN_ONs.

Signed-off-by: Prarit Bhargava <prarit@redhat.com>

diff --git a/include/asm-generic/bug.h b/include/asm-generic/bug.h
index f2d2faf..1825fd7 100644
--- a/include/asm-generic/bug.h
+++ b/include/asm-generic/bug.h
@@ -133,32 +133,32 @@ extern void warn_slowpath_null(const char *file, const int line);
 #endif
 
 #define WARN_ON_ONCE(condition)	({				\
-	static bool __warned;					\
+	static int __warned;					\
 	int __ret_warn_once = !!(condition);			\
 								\
 	if (unlikely(__ret_warn_once))				\
-		if (WARN_ON(!__warned)) 			\
-			__warned = true;			\
+		if (!__warned && !cmpxchg(&__warned, 0, 1))	\
+			WARN_ON(1);				\
 	unlikely(__ret_warn_once);				\
 })
 
 #define WARN_ONCE(condition, format...)	({			\
-	static bool __warned;					\
+	static int __warned;					\
 	int __ret_warn_once = !!(condition);			\
 								\
 	if (unlikely(__ret_warn_once))				\
-		if (WARN(!__warned, format)) 			\
-			__warned = true;			\
+		if (!__warned && !cmpxchg(&__warned, 0, 1))	\
+			WARN(1, format);			\
 	unlikely(__ret_warn_once);				\
 })
 
 #define WARN_TAINT_ONCE(condition, taint, format...)	({	\
-	static bool __warned;					\
+	static int __warned;					\
 	int __ret_warn_once = !!(condition);			\
 								\
 	if (unlikely(__ret_warn_once))				\
-		if (WARN_TAINT(!__warned, taint, format))	\
-			__warned = true;			\
+		if (!__warned && !cmpxchg(&__warned, 0, 1))	\
+			WARN_TAINT(1, taint, format);		\
 	unlikely(__ret_warn_once);				\
 })
 
