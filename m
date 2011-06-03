Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752363Ab1FCKbP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jun 2011 06:31:15 -0400
Received: from merlin.infradead.org ([205.233.59.134]:52307 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751401Ab1FCKbO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jun 2011 06:31:14 -0400
Subject: Re: [tip:sched/locking] sched: Add p->pi_lock to task_rq_lock()
From: Peter Zijlstra <peterz@infradead.org>
To: Arne Jansen <lists@die-jansens.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, mingo@redhat.com,
        hpa@zytor.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        npiggin@kernel.dk, akpm@linux-foundation.org, frank.rowand@am.sony.com,
        tglx@linutronix.de, mingo@elte.hu, linux-tip-commits@vger.kernel.org
In-Reply-To: <4DE8B13D.9020302@die-jansens.de>
References: <20110405152729.232781355@chello.nl>
	 <tip-0122ec5b02f766c355b3168df53a6c038a24fa0d@git.kernel.org>
	 <4DE64596.5010006@die-jansens.de> <1306946120.2497.606.camel@laptop>
	 <4DE674EB.1000200@die-jansens.de> <1306951751.2497.626.camel@laptop>
	 <1306953870.2497.627.camel@laptop> <4DE6936F.7090700@die-jansens.de>
	 <BANLkTimXXR1mJDtdCsbXF410sd3irFSitQ@mail.gmail.com>
	 <1307092535.2353.2973.camel@twins>  <4DE8B13D.9020302@die-jansens.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 03 Jun 2011 12:30:52 +0200
Message-ID: <1307097052.2353.3061.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-06-03 at 12:02 +0200, Arne Jansen wrote:
> On 03.06.2011 11:15, Peter Zijlstra wrote:

> > Anyway, Arne, how long did you wait before power cycling the box? The
> > NMI watchdog should trigger in about a minute or so if it will trigger
> > at all (its enabled in your config).
> 
> No, it doesn't trigger,

Bummer.

>  but the hang is not as complete as I first
> thought. A running iostat via ssh continues to give output for a while,
> the serial console still reacts to return and prompts for login. But
> after a while more and more locks up. The console locks as soon as I
> sysrq-t.

OK, that seems to suggest one CPU is stuck, and once you try something
that touches the CPU everything grinds to a halt. Does something like
sysrq-l work? That would send NMIs to the other CPUs.

Anyway, good to know using serial doesn't make it go away, that means
its not too timing sensitive.

> Maybe it has also something to do with the place where I added the
> printks (btrfs_scan_one_device). 

printk() should work pretty much anywhere these days, and filesystem
code in particular shouldn't be ran from any weird and wonderful
contexts afaik.

> Also the 10k-print gets triggered
> several times (though I only see 10 lines of output). Maybe you can
> send me your test-module and I'll try that, so we have more equal
> conditions.

Sure, see below.

> What also might help: the maschine I'm testing with is a quad-core
> X3450 with 8GB RAM.

/me & wikipedia, that's a nehalem box, ok I'm testing on a westmere
(don't have a nehalem).

---
 kernel/Makefile |    1 +
 kernel/test.c   |   23 +++++++++++++++++++++++
 2 files changed, 24 insertions(+), 0 deletions(-)

diff --git a/kernel/Makefile b/kernel/Makefile
index 2d64cfc..65eff6c 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -80,6 +80,7 @@ obj-$(CONFIG_LOCKUP_DETECTOR) += watchdog.o
 obj-$(CONFIG_GENERIC_HARDIRQS) += irq/
 obj-$(CONFIG_SECCOMP) += seccomp.o
 obj-$(CONFIG_RCU_TORTURE_TEST) += rcutorture.o
+obj-m += test.o
 obj-$(CONFIG_TREE_RCU) += rcutree.o
 obj-$(CONFIG_TREE_PREEMPT_RCU) += rcutree.o
 obj-$(CONFIG_TREE_RCU_TRACE) += rcutree_trace.o
diff --git a/kernel/test.c b/kernel/test.c
index e69de29..8005395 100644
--- a/kernel/test.c
+++ b/kernel/test.c
@@ -0,0 +1,23 @@
+#include <linux/kernel.h>
+#include <linux/module.h>
+
+MODULE_LICENSE("GPL");
+
+static void
+test_cleanup(void)
+{
+}
+
+static int __init
+test_init(void)
+{
+	int i;
+
+	for (i = 0; i < 10000; i++)
+		printk("test %d\n", i);
+
+	return 0;
+}
+
+module_init(test_init);
+module_exit(test_cleanup);

