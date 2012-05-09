Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759350Ab2EIN2B (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 09:28:01 -0400
Received: from merlin.infradead.org ([205.233.59.134]:36772 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757560Ab2EIN2A convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 09:28:00 -0400
Message-ID: <1336570043.2527.38.camel@twins>
Subject: [RFC][PATCH] printk: Add %pb to print bitmaps
From: Peter Zijlstra <peterz@infradead.org>
To: Igor Mammedov <imammedo@redhat.com>
Cc: Jiang Liu <liuj97@gmail.com>, linux-kernel@vger.kernel.org,
        mingo@kernel.org, pjt@google.com, tglx@linutronix.de,
        seto.hidetoshi@jp.fujitsu.com,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 09 May 2012 15:27:23 +0200
In-Reply-To: <1336566644.2527.33.camel@twins>
References: <1336559908-32533-1-git-send-email-imammedo@redhat.com>
	 <4FAA452A.1070909@gmail.com> <4FAA588B.5010404@redhat.com>
	 <1336564330.2527.23.camel@twins> <4FAA5BFB.40309@redhat.com>
	 <1336566096.2527.30.camel@twins> <1336566644.2527.33.camel@twins>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-05-09 at 14:30 +0200, Peter Zijlstra wrote:
> on a related note, we should add a printk-%p modifier for cpulist,
> this cpulist_scnprintf() stuff gets annoying. 

Something like so I guess.. I'll try and convert some of the sched_debug
code to test it..

---
 lib/vsprintf.c |   36 +++++++++++++++++++++++++++++++-----
 1 file changed, 31 insertions(+), 5 deletions(-)

diff --git a/lib/vsprintf.c b/lib/vsprintf.c
index abbabec..90bfcd1 100644
--- a/lib/vsprintf.c
+++ b/lib/vsprintf.c
@@ -25,6 +25,9 @@
 #include <linux/kallsyms.h>
 #include <linux/uaccess.h>
 #include <linux/ioport.h>
+#include <linux/bitmap.h>
+#include <linux/cpumask.h>
+#include <linux/numa.h>
 #include <net/addrconf.h>
 
 #include <asm/page.h>		/* for PAGE_SIZE */
@@ -857,15 +860,19 @@ int kptr_restrict __read_mostly;
  *       correctness of the format string and va_list arguments.
  * - 'K' For a kernel pointer that should be hidden from unprivileged users
  * - 'NF' For a netdev_features_t
+ * - 'b' For a bitmap, consumes 2 args, second is int
+ * - 'bc' For a cpumask
+ * - 'bn' For a nodemask
  *
  * Note: The difference between 'S' and 'F' is that on ia64 and ppc64
  * function pointers are really function descriptors, which contain a
  * pointer to the real address.
  */
-static noinline_for_stack
-char *pointer(const char *fmt, char *buf, char *end, void *ptr,
-	      struct printf_spec spec)
+static noinline_for_stack 
+char *pointer(const char *fmt, char *buf, char *end, va_list args, struct printf_spec spec)
 {
+	void *ptr = va_arg(args, void *);
+
 	if (!ptr && *fmt != 'K') {
 		/*
 		 * Print (null) with the same width as a pointer so it makes
@@ -941,6 +948,26 @@ char *pointer(const char *fmt, char *buf, char *end, void *ptr,
 			return netdev_feature_string(buf, end, ptr, spec);
 		}
 		break;
+	case 'b':
+		{
+			int bits, len;
+
+			switch (fmt[1]) {
+			case 'c':
+				bits = nr_cpumask_bits;
+				break;
+			case 'n':
+				bits = MAX_NUMNODES;
+				break;
+			default:
+				bits = va_arg(args, int);
+				break;
+			}
+		       
+			len = bitmap_scnlistprintf(buf, end - buf, ptr, bits);
+
+			return buf + len;
+		}
 	}
 	spec.flags |= SMALL;
 	if (spec.field_width == -1) {
@@ -1261,8 +1288,7 @@ int vsnprintf(char *buf, size_t size, const char *fmt, va_list args)
 			break;
 
 		case FORMAT_TYPE_PTR:
-			str = pointer(fmt+1, str, end, va_arg(args, void *),
-				      spec);
+			str = pointer(fmt+1, str, end, args, spec);
 			while (isalnum(*fmt))
 				fmt++;
 			break;

