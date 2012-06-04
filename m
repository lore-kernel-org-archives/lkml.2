Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756252Ab2FDHjw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 03:39:52 -0400
Received: from linux-sh.org ([111.68.239.195]:41404 "EHLO linux-sh.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752639Ab2FDHjt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 03:39:49 -0400
Date: Mon, 4 Jun 2012 16:39:33 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Al Viro <viro@zeniv.linux.org.uk>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: linux-next: build failure after merge of the origin tree
Message-ID: <20120604073932.GG11445@linux-sh.org>
References: <20120604125724.603f62215c9dc9269db898a2@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120604125724.603f62215c9dc9269db898a2@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 04, 2012 at 12:57:24PM +1000, Stephen Rothwell wrote:
> Hi Al,
> 
> Building the origin tree (v3.5-rc1 sh lboxre2_defconfig and other sh
> configs) failed like this:
> 
> arch/sh/include/asm/thread_info.h:172:2: error: 'TAINT_WARN' undeclared (first use in this function)
> 
> Caused by commit edd63a2763bd ("set_restore_sigmask() is never called
> without SIGPENDING (and never should be)").  Missing include of kernel.h.
> 
Ideally bug.h should be including linux/kernel.h itself due to its
TAINT_WARN dependence, it just seems to be getting lucky on other
platforms who either don't have this combination or pull in kernel.h from
somewhere else.

That commit also introduces a linux/bug.h include for WARN_ON() in
linux/thread_info.h which would be similarly insufficient for any
TIF_RESTORE_SIGMASK && !HAVE_SET_RESTORE_SIGMASK platform that also uses
asm-generic/bug.h. 

Given that, I'd prefer stuffing the include in asm-generic directly:

---

bug.h: need linux/kernel.h for TAINT_WARN.

asm-generic/bug.h uses taint flags that are only defined in
linux/kernel.h, resulting in build failures on platforms that
don't include linux/kernel.h some other way:

	arch/sh/include/asm/thread_info.h:172:2: error: 'TAINT_WARN' undeclared (first use in this function)

Caused by commit edd63a2763bd ("set_restore_sigmask() is never called
without SIGPENDING (and never should be)").

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Paul Mundt <lethal@linux-sh.org>

---

diff --git a/include/asm-generic/bug.h b/include/asm-generic/bug.h
index 2520a6e..9f02005 100644
--- a/include/asm-generic/bug.h
+++ b/include/asm-generic/bug.h
@@ -2,6 +2,7 @@
 #define _ASM_GENERIC_BUG_H
 
 #include <linux/compiler.h>
+#include <linux/kernel.h>
 
 #ifdef CONFIG_BUG
 
