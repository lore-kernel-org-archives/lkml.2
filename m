Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758524Ab2IMQC1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 12:02:27 -0400
Received: from e06smtp14.uk.ibm.com ([195.75.94.110]:56374 "EHLO
	e06smtp14.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758264Ab2IMQCZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 12:02:25 -0400
Date: Thu, 13 Sep 2012 18:02:37 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        Michal Marek <mmarek@suse.cz>, "H. Peter Anvin" <hpa@linux.intel.com>
Subject: Re: [PATCH 2/2] checksyscalls: ignore kcmp system call
Message-ID: <20120913160237.GA10145@osiris.de.ibm.com>
References: <1347017491-11354-1-git-send-email-heiko.carstens@de.ibm.com>
 <1347017491-11354-2-git-send-email-heiko.carstens@de.ibm.com>
 <20120907120234.GB2121@moon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120907120234.GB2121@moon>
User-Agent: Mutt/1.5.21 (2010-09-15)
x-cbid: 12091316-1948-0000-0000-000002F28C61
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 07, 2012 at 04:02:34PM +0400, Cyrill Gorcunov wrote:
> On Fri, Sep 07, 2012 at 01:31:31PM +0200, Heiko Carstens wrote:
> > Now that the checksyscalls script works again it will warn about the missing
> > "kcmp" system call on all architectures but x86.
> > Since according to git commit d97b46a6 "syscalls, x86: add __NR_kcmp syscall"
> > only x86 is currently supported don't emit any warning for this system call.
[...]
> > diff --git a/scripts/checksyscalls.sh b/scripts/checksyscalls.sh
> > index fd8fa9a..c7cda79 100755
> > --- a/scripts/checksyscalls.sh
> > +++ b/scripts/checksyscalls.sh
> > @@ -194,6 +194,9 @@ cat << EOF
> >  #define __IGNORE_getpmsg
> >  #define __IGNORE_putpmsg
> >  #define __IGNORE_vserver
> > +
> > +/* kcmp is currently x86 only */
> > +#define __IGNORE_kcmp

Ok, I wired the system call up on s390 and the test case passed.
Below is the patch that is needed to actually reach the system call from
other architectures than x86.
Andrew, can you pick this one up as well?

The code that wires the system call up on s390 will go upstream via the
s390 tree. Thanks to kcmp being a cond_syscall there is no compile
time dependency.

>From 1ff800597ea8f678a179387e3cf2ae663531e2fe Mon Sep 17 00:00:00 2001
From: Heiko Carstens <heiko.carstens@de.ibm.com>
Date: Thu, 13 Sep 2012 09:37:38 +0200
Subject: [PATCH] syscalls: make kcmp syscall available for all architectures

Remove the x86 dependency, since the system call is not
architecture dependend.

Also add a ptrace.h include, so it compiles at least also on s390.

Cc: Cyrill Gorcunov <gorcunov@openvz.org>
Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
---
 kernel/Makefile | 4 +---
 kernel/kcmp.c   | 1 +
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/kernel/Makefile b/kernel/Makefile
index c0cc67a..eb4138b 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -25,9 +25,7 @@ endif
 obj-y += sched/
 obj-y += power/
 
-ifeq ($(CONFIG_CHECKPOINT_RESTORE),y)
-obj-$(CONFIG_X86) += kcmp.o
-endif
+obj-$(CONFIG_CHECKPOINT_RESTORE) += kcmp.o
 obj-$(CONFIG_FREEZER) += freezer.o
 obj-$(CONFIG_PROFILING) += profile.o
 obj-$(CONFIG_STACKTRACE) += stacktrace.o
diff --git a/kernel/kcmp.c b/kernel/kcmp.c
index 30b7b22..e30ac0f 100644
--- a/kernel/kcmp.c
+++ b/kernel/kcmp.c
@@ -4,6 +4,7 @@
 #include <linux/string.h>
 #include <linux/random.h>
 #include <linux/module.h>
+#include <linux/ptrace.h>
 #include <linux/init.h>
 #include <linux/errno.h>
 #include <linux/cache.h>
-- 
1.7.11.6

