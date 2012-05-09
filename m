Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759625Ab2EIPdZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 11:33:25 -0400
Received: from merlin.infradead.org ([205.233.59.134]:53380 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758008Ab2EIPdU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 11:33:20 -0400
Message-ID: <1336577562.2527.58.camel@twins>
Subject: Re: [RFC][PATCH] printk: Add %pb to print bitmaps
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: Igor Mammedov <imammedo@redhat.com>, Jiang Liu <liuj97@gmail.com>,
        linux-kernel@vger.kernel.org, pjt@google.com, tglx@linutronix.de,
        seto.hidetoshi@jp.fujitsu.com,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Joe Perches <joe@perches.com>
Date: Wed, 09 May 2012 17:32:42 +0200
In-Reply-To: <20120509141528.GA3623@gmail.com>
References: <4FAA452A.1070909@gmail.com> <4FAA588B.5010404@redhat.com>
	 <1336564330.2527.23.camel@twins> <4FAA5BFB.40309@redhat.com>
	 <1336566096.2527.30.camel@twins> <1336566644.2527.33.camel@twins>
	 <1336570043.2527.38.camel@twins> <20120509133607.GA26124@gmail.com>
	 <1336571049.2527.43.camel@twins> <1336571947.2527.47.camel@twins>
	 <20120509141528.GA3623@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-05-09 at 16:15 +0200, Ingo Molnar wrote:
> > I guess I should use %.*pb and keep the field_width in case someone
> > manages to actually make bitmap_scnlistprintf() conform to it. The
> > precision is unused anyway.
> 
> That's a cute trick, and it's intuitive as well. 

kernel/sched/core.c:5570:3: warning: precision used with ‘%p’ gnu_printf format [-Wformat]

/me curses a bit.. anybody?


The below compiles and works (with the above caveat) and has all the
style muck people 'wanted'.

---
 lib/vsprintf.c |   46 ++++++++++++++++++++++++++++++++--------------
 1 file changed, 32 insertions(+), 14 deletions(-)

diff --git a/lib/vsprintf.c b/lib/vsprintf.c
index abbabec..6bd9a66 100644
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
@@ -857,6 +860,9 @@ int kptr_restrict __read_mostly;
  *       correctness of the format string and va_list arguments.
  * - 'K' For a kernel pointer that should be hidden from unprivileged users
  * - 'NF' For a netdev_features_t
+ * - 'b' For a bitmap; %.*pb is required and the precision is used as bitmap length
+ * - 'bc' For a cpumask
+ * - 'bn' For a nodemask
  *
  * Note: The difference between 'S' and 'F' is that on ia64 and ppc64
  * function pointers are really function descriptors, which contain a
@@ -902,24 +908,21 @@ char *pointer(const char *fmt, char *buf, char *end, void *ptr,
 					 * 6:   000102...0f
 					 */
 		switch (fmt[1]) {
-		case '6':
-			return ip6_addr_string(buf, end, ptr, spec, fmt);
-		case '4':
-			return ip4_addr_string(buf, end, ptr, spec, fmt);
+		case '6': return ip6_addr_string(buf, end, ptr, spec, fmt);
+		case '4': return ip4_addr_string(buf, end, ptr, spec, fmt);
 		}
 		break;
 	case 'U':
 		return uuid_string(buf, end, ptr, spec, fmt);
-	case 'V':
-		{
-			va_list va;
-
-			va_copy(va, *((struct va_format *)ptr)->va);
-			buf += vsnprintf(buf, end > buf ? end - buf : 0,
-					 ((struct va_format *)ptr)->fmt, va);
-			va_end(va);
-			return buf;
-		}
+	case 'V': {
+		va_list va;
+
+		va_copy(va, *((struct va_format *)ptr)->va);
+		buf += vsnprintf(buf, end > buf ? end - buf : 0,
+				 ((struct va_format *)ptr)->fmt, va);
+		va_end(va);
+		return buf;
+	}
 	case 'K':
 		/*
 		 * %pK cannot be used in IRQ context because its test
@@ -941,6 +944,18 @@ char *pointer(const char *fmt, char *buf, char *end, void *ptr,
 			return netdev_feature_string(buf, end, ptr, spec);
 		}
 		break;
+	case 'b': {
+		int bits;
+
+		switch (fmt[1]) {
+		case 'c': bits = nr_cpumask_bits; break;
+		case 'n': bits = MAX_NUMNODES;    break;
+		default:  bits = spec.precision;  break;
+		}
+
+		return buf + bitmap_scnlistprintf(buf, end - buf, ptr, bits);
+	}
+	default: break;
 	}
 	spec.flags |= SMALL;
 	if (spec.field_width == -1) {
@@ -1175,6 +1190,9 @@ int format_decode(const char *fmt, struct printf_spec *spec)
  * %pI6c print an IPv6 address as specified by RFC 5952
  * %pU[bBlL] print a UUID/GUID in big or little endian using lower or upper
  *   case.
+ * %.*pb print a bitmap list using the precision as bitmap length
+ * %pbc print a cpumask bitmap
+ * %pbn print a nodemask bitmap
  * %n is ignored
  *
  * The return value is the number of characters which would

