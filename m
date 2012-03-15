Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761313Ab2COLf6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 07:35:58 -0400
Received: from casper.infradead.org ([85.118.1.10]:43808 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751434Ab2COLfz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 07:35:55 -0400
Message-ID: <1331811337.18960.179.camel@twins>
Subject: [PATCH] printk: Make it compile with !CONFIG_PRINTK
From: Peter Zijlstra <peterz@infradead.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Randy Dunlap <rdunlap@xenotime.net>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>
Date: Thu, 15 Mar 2012 12:35:37 +0100
In-Reply-To: <20120315071934.77f0af64a4c633c545d68ea4@canb.auug.org.au>
References: <20120314181921.59451eca117c276461f7dc28@canb.auug.org.au>
	 <4F60BFA6.2030804@xenotime.net>
	 <20120315071934.77f0af64a4c633c545d68ea4@canb.auug.org.au>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-03-15 at 07:19 +1100, Stephen Rothwell wrote:
> On Wed, 14 Mar 2012 08:56:22 -0700 Randy Dunlap <rdunlap@xenotime.net> wrote:
> >
> > on x86_64:
> > 
> > kernel/printk.c:1230:5: error: redefinition of 'printk_sched'
> > include/linux/printk.h:136:5: note: previous definition of 'printk_sched' was here
> 
> Caused by commit 3ccf3e830615 ("printk/sched: Introduce special
> printk_sched() for those awkward moments") from the tip tree.  The
> declaration in include/linux/printk.h has alternatives determined by
> CONFIG_PRINTK, but the definition in kernel/printk.c is not so
> protected ...

Ingo, could you stick this on top.. ?

---
Subject: printk: Make it compile with !CONFIG_PRINTK

Commit 3ccf3e830615 ("printk/sched: Introduce special printk_sched() for
those awkward moments") overlooked an #ifdef, so move code around to
respect these directives.

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/printk.c |   40 ++++++++++++++++++++--------------------
 1 files changed, 20 insertions(+), 20 deletions(-)

diff --git a/kernel/printk.c b/kernel/printk.c
index 8b6981e..b663c2c 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -1227,26 +1227,6 @@ int is_console_locked(void)
 static DEFINE_PER_CPU(int, printk_pending);
 static DEFINE_PER_CPU(char [PRINTK_BUF_SIZE], printk_sched_buf);
 
-int printk_sched(const char *fmt, ...)
-{
-	unsigned long flags;
-	va_list args;
-	char *buf;
-	int r;
-
-	local_irq_save(flags);
-	buf = __get_cpu_var(printk_sched_buf);
-
-	va_start(args, fmt);
-	r = vsnprintf(buf, PRINTK_BUF_SIZE, fmt, args);
-	va_end(args);
-
-	__this_cpu_or(printk_pending, PRINTK_PENDING_SCHED);
-	local_irq_restore(flags);
-
-	return r;
-}
-
 void printk_tick(void)
 {
 	if (__this_cpu_read(printk_pending)) {
@@ -1663,6 +1643,26 @@ late_initcall(printk_late_init);
 
 #if defined CONFIG_PRINTK
 
+int printk_sched(const char *fmt, ...)
+{
+	unsigned long flags;
+	va_list args;
+	char *buf;
+	int r;
+
+	local_irq_save(flags);
+	buf = __get_cpu_var(printk_sched_buf);
+
+	va_start(args, fmt);
+	r = vsnprintf(buf, PRINTK_BUF_SIZE, fmt, args);
+	va_end(args);
+
+	__this_cpu_or(printk_pending, PRINTK_PENDING_SCHED);
+	local_irq_restore(flags);
+
+	return r;
+}
+
 /*
  * printk rate limiting, lifted from the networking subsystem.
  *

