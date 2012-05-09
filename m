Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756039Ab2EIN7S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 09:59:18 -0400
Received: from casper.infradead.org ([85.118.1.10]:37463 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753761Ab2EIN7R convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 09:59:17 -0400
Message-ID: <1336571947.2527.47.camel@twins>
Subject: Re: [RFC][PATCH] printk: Add %pb to print bitmaps
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: Igor Mammedov <imammedo@redhat.com>, Jiang Liu <liuj97@gmail.com>,
        linux-kernel@vger.kernel.org, pjt@google.com, tglx@linutronix.de,
        seto.hidetoshi@jp.fujitsu.com,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 09 May 2012 15:59:07 +0200
In-Reply-To: <1336571049.2527.43.camel@twins>
References: <1336559908-32533-1-git-send-email-imammedo@redhat.com>
	 <4FAA452A.1070909@gmail.com> <4FAA588B.5010404@redhat.com>
	 <1336564330.2527.23.camel@twins> <4FAA5BFB.40309@redhat.com>
	 <1336566096.2527.30.camel@twins> <1336566644.2527.33.camel@twins>
	 <1336570043.2527.38.camel@twins> <20120509133607.GA26124@gmail.com>
	 <1336571049.2527.43.camel@twins>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-05-09 at 15:44 +0200, Peter Zijlstra wrote:
> On Wed, 2012-05-09 at 15:36 +0200, Ingo Molnar wrote:
> > * Peter Zijlstra <peterz@infradead.org> wrote:
> > 
> > > @@ -857,15 +860,19 @@ int kptr_restrict __read_mostly;
> > >   *       correctness of the format string and va_list arguments.
> > >   * - 'K' For a kernel pointer that should be hidden from unprivileged users
> > >   * - 'NF' For a netdev_features_t
> > > + * - 'b' For a bitmap, consumes 2 args, second is int
> > 
> > hm, won't the second arg confuse gcc's printf format checker?
> 
> 
> Ah, yes, I suppose I could abuse something like %*pb. Let me try that.

I guess I should use %.*pb and keep the field_width in case someone
manages to actually make bitmap_scnlistprintf() conform to it. The
precision is unused anyway.

The current implementation limits both (field_width and precision) to
s16, which will limit us to printing 32Kb bitmaps. If need arises we
could increase printf_spec size I guess.

---
 lib/vsprintf.c |   29 +++++++++++++++++++++++++++++
 1 file changed, 29 insertions(+)

diff --git a/lib/vsprintf.c b/lib/vsprintf.c
index abbabec..6eb30a9 100644
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
@@ -941,6 +947,26 @@ char *pointer(const char *fmt, char *buf, char *end, void *ptr,
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
+				bits = spec->precision;
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
@@ -1175,6 +1201,9 @@ int format_decode(const char *fmt, struct printf_spec *spec)
  * %pI6c print an IPv6 address as specified by RFC 5952
  * %pU[bBlL] print a UUID/GUID in big or little endian using lower or upper
  *   case.
+ * %.*pb print a bitmap list using the precision as bitmap length
+ * %pbc print a cpumask bitmap
+ * %pbn print a nodemask bitmap
  * %n is ignored
  *
  * The return value is the number of characters which would

