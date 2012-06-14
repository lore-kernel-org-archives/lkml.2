Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755293Ab2FNDku (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 23:40:50 -0400
Received: from linux-sh.org ([111.68.239.195]:58401 "EHLO linux-sh.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755099Ab2FNDks (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 23:40:48 -0400
Date: Thu, 14 Jun 2012 12:40:36 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: linux-next: build failure in Linus' tree
Message-ID: <20120614034036.GE27673@linux-sh.org>
References: <20120614114722.0fd16fb906b6a5503cfbc51a@canb.auug.org.au>
 <20120614030606.GC27673@linux-sh.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120614030606.GC27673@linux-sh.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(adding Arnd to Cc, who I forgot to include previously)

On Thu, Jun 14, 2012 at 12:06:06PM +0900, Paul Mundt wrote:
> On Thu, Jun 14, 2012 at 11:47:22AM +1000, Stephen Rothwell wrote:
> > While building Linus' tree, today's linux-next build (powerpc
> > ppc64_defconfig) failed like this:
> > 
> > In file included from include/asm-generic/bug.h:5:0,
> >                  from arch/powerpc/include/asm/bug.h:127,
> >                  from arch/powerpc/kernel/head_64.S:31:
> > include/linux/kernel.h:44:0: warning: "ALIGN" redefined [enabled by default]
> > include/linux/linkage.h:57:0: note: this is the location of the previous definition
> > include/linux/sysinfo.h: Assembler messages:
> > include/linux/sysinfo.h:7: Error: Unrecognized opcode: `struct'
> > include/linux/sysinfo.h:8: Error: Unrecognized opcode: `__kernel_long_t'
> > 
> > And it went downhill from there :-(
> > 
> > Caused by commit 3777808873b0 ("bug.h: need linux/kernel.h for
> > TAINT_WARN") which, unfortunately never made it into linux-next.
> > 
> > I have reverted that commit for today (which presumably means that sh
> > builds will be broken again).
> 
> I'm still unsure as to the best way to fix this, and there was no
> response to the original mail I posted about it either:
> 
> http://marc.info/?l=linux-kernel&m=133879579014853&w=2
> 
> I'll fetch a powerpc cross compiler and see if I can figure out what went
> wrong.
> 
Ok, it's because the asm-generic/bug.h __ASSEMBLY__ guarding is
completely bogus. This should hopefully fix it once and for all.
Sorry for the trouble.

Signed-off-by: Paul Mundt <lethal@linux-sh.org>

---

 include/asm-generic/bug.h |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/include/asm-generic/bug.h b/include/asm-generic/bug.h
index 9f02005..506ec19 100644
--- a/include/asm-generic/bug.h
+++ b/include/asm-generic/bug.h
@@ -2,7 +2,6 @@
 #define _ASM_GENERIC_BUG_H
 
 #include <linux/compiler.h>
-#include <linux/kernel.h>
 
 #ifdef CONFIG_BUG
 
@@ -32,6 +31,9 @@ struct bug_entry {
 
 #endif	/* CONFIG_GENERIC_BUG */
 
+#ifndef __ASSEMBLY__
+#include <linux/kernel.h>
+
 /*
  * Don't use BUG() or BUG_ON() unless there's really no way out; one
  * example might be detecting data structure corruption in the middle
@@ -61,7 +63,6 @@ struct bug_entry {
  * to provide better diagnostics.
  */
 #ifndef __WARN_TAINT
-#ifndef __ASSEMBLY__
 extern __printf(3, 4)
 void warn_slowpath_fmt(const char *file, const int line,
 		       const char *fmt, ...);
@@ -70,7 +71,6 @@ void warn_slowpath_fmt_taint(const char *file, const int line, unsigned taint,
 			     const char *fmt, ...);
 extern void warn_slowpath_null(const char *file, const int line);
 #define WANT_WARN_ON_SLOWPATH
-#endif
 #define __WARN()		warn_slowpath_null(__FILE__, __LINE__)
 #define __WARN_printf(arg...)	warn_slowpath_fmt(__FILE__, __LINE__, arg)
 #define __WARN_printf_taint(taint, arg...)				\
@@ -203,4 +203,6 @@ extern void warn_slowpath_null(const char *file, const int line);
 # define WARN_ON_SMP(x)			({0;})
 #endif
 
+#endif /* __ASSEMBLY__ */
+
 #endif
