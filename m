Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758079Ab1FHABH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 20:01:07 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55941 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757991Ab1FHABF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 20:01:05 -0400
Date: Tue, 7 Jun 2011 17:00:29 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: ebiederm@xmission.com (Eric W. Biederman)
Cc: Seiji Aguchi <seiji.aguchi@hds.com>, Vivek Goyal <vgoyal@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Americo Wang <xiyou.wangcong@gmail.com>,
        linux kernel mailing list <linux-kernel@vger.kernel.org>,
        Jarod Wilson <jwilson@redhat.com>
Subject: Re: [Patch] kexec: remove KMSG_DUMP_KEXEC (was Re: Query about
 kdump_msg hook into crash_kexec())
Message-Id: <20110607170029.b6f41e9b.akpm@linux-foundation.org>
In-Reply-To: <m1ei3cq5gj.fsf@fess.ebiederm.org>
References: <20110203095837.93A2.A69D9226@jp.fujitsu.com>
	<20110203020703.GB21603@redhat.com>
	<20110203135324.93BC.A69D9226@jp.fujitsu.com>
	<20110526131028.7052a893.akpm@linux-foundation.org>
	<5C4C569E8A4B9B42A84A977CF070A35B2C17324B79@USINDEVS01.corp.hds.com>
	<20110531213704.GV16382@redhat.com>
	<5C4C569E8A4B9B42A84A977CF070A35B2C17324BB9@USINDEVS01.corp.hds.com>
	<m1ei3cq5gj.fsf@fess.ebiederm.org>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 01 Jun 2011 20:26:20 -0700
ebiederm@xmission.com (Eric W. Biederman) wrote:

> >>What are you using kmsg_dump() for? Using mtdoops, ramoops or something
> >>else?  Is it working reliably for you?
> >
> > I plan to use kmsg_dump() for set_variable service of UEFI.
> > I proposed a prototype patch this month and will improve it.
> > (kmsg_dump is used inside pstore.)
> >
> > https://lkml.org/lkml/2011/5/10/340
> 
> Shudder.  Firmware calls in the crash path.
> 
> If that is the use, we need to remove the kmsg_dump(KMSG_DUMP_KEXEC)
> hook from crash_kexec yesterday.  It is leading to some really ludicrous
> suggestions that are on the way from making kexec on panic unreliable
> and useless.
> 
> There will always be EFI implementations where that will not work and
> there will be no way we can fix those.
> 
> There is a long history of people trying to do things in a crashing
> kernel, things that simply do not work when the system is in a bad
> state.  kmsg_dump() when I reviewed the code had significant
> implementation problems for being called from interrupt handlers
> and the like.
> 
> To introduce a different solution for capturing information when a
> kernel crashes we need to see numbers that in a large number of
> situations that the mechanism you are proposing is more reliable and/or
> more maintainable than the current kexec on panic implementation.
> 
> The best work I know of on the reliability of the current situation
> is "Evaluating Linux Kernel Crash Dumping Mechanisms", by Fernando Luis Vazquez Cao.
> http://www.linuxsymposium.org/archives/OLS/Reprints-2006/cao-reprint.pdf
> 
> 
> Now it does happen to be a fact that our efi support in linux is
> so buggy kexec does not work let alone kexec on panic (if the target
> kernel has any efi support).   But our efi support being buggy is not
> a reason to add more ways to fail when we have a kernel with efi
> support.  It is an argument to remove our excessive use of EFI
> calls.
> 
> So let's just remove the ridiculous kmsg_dump(KMSG_DUMP_KEXEC) hook from
> crash_kexec and remove any temptation for abuses like wanting to use
> kmsg_dump() on anything but a deeply embedded system where there simply
> is not enough memory for 2 kernels.
> 

So am I allowed to merge kexec-remove-kmsg_dump_kexec.patch yet?


From: WANG Cong <xiyou.wangcong@gmail.com>

KMSG_DUMP_KEXEC is useless because we already save kernel messages inside
/proc/vmcore, and it is unsafe to allow modules to do other stuffs in a
crash dump scenario.

[akpm@linux-foundation.org: fix powerpc build]
Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>
Reported-by: Vivek Goyal <vgoyal@redhat.com>
Acked-by: Vivek Goyal <vgoyal@redhat.com>
Acked-by: Jarod Wilson <jarod@redhat.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/platforms/pseries/nvram.c |    1 -
 drivers/char/ramoops.c                 |    3 +--
 drivers/mtd/mtdoops.c                  |    3 +--
 include/linux/kmsg_dump.h              |    1 -
 kernel/kexec.c                         |    3 ---
 5 files changed, 2 insertions(+), 9 deletions(-)

diff -puN drivers/char/ramoops.c~kexec-remove-kmsg_dump_kexec drivers/char/ramoops.c
--- a/drivers/char/ramoops.c~kexec-remove-kmsg_dump_kexec
+++ a/drivers/char/ramoops.c
@@ -69,8 +69,7 @@ static void ramoops_do_dump(struct kmsg_
 	struct timeval timestamp;
 
 	if (reason != KMSG_DUMP_OOPS &&
-	    reason != KMSG_DUMP_PANIC &&
-	    reason != KMSG_DUMP_KEXEC)
+	    reason != KMSG_DUMP_PANIC)
 		return;
 
 	/* Only dump oopses if dump_oops is set */
diff -puN drivers/mtd/mtdoops.c~kexec-remove-kmsg_dump_kexec drivers/mtd/mtdoops.c
--- a/drivers/mtd/mtdoops.c~kexec-remove-kmsg_dump_kexec
+++ a/drivers/mtd/mtdoops.c
@@ -308,8 +308,7 @@ static void mtdoops_do_dump(struct kmsg_
 	char *dst;
 
 	if (reason != KMSG_DUMP_OOPS &&
-	    reason != KMSG_DUMP_PANIC &&
-	    reason != KMSG_DUMP_KEXEC)
+	    reason != KMSG_DUMP_PANIC)
 		return;
 
 	/* Only dump oopses if dump_oops is set */
diff -puN include/linux/kmsg_dump.h~kexec-remove-kmsg_dump_kexec include/linux/kmsg_dump.h
--- a/include/linux/kmsg_dump.h~kexec-remove-kmsg_dump_kexec
+++ a/include/linux/kmsg_dump.h
@@ -18,7 +18,6 @@
 enum kmsg_dump_reason {
 	KMSG_DUMP_OOPS,
 	KMSG_DUMP_PANIC,
-	KMSG_DUMP_KEXEC,
 	KMSG_DUMP_RESTART,
 	KMSG_DUMP_HALT,
 	KMSG_DUMP_POWEROFF,
diff -puN kernel/kexec.c~kexec-remove-kmsg_dump_kexec kernel/kexec.c
--- a/kernel/kexec.c~kexec-remove-kmsg_dump_kexec
+++ a/kernel/kexec.c
@@ -32,7 +32,6 @@
 #include <linux/console.h>
 #include <linux/vmalloc.h>
 #include <linux/swap.h>
-#include <linux/kmsg_dump.h>
 #include <linux/syscore_ops.h>
 
 #include <asm/page.h>
@@ -1079,8 +1078,6 @@ void crash_kexec(struct pt_regs *regs)
 		if (kexec_crash_image) {
 			struct pt_regs fixed_regs;
 
-			kmsg_dump(KMSG_DUMP_KEXEC);
-
 			crash_setup_regs(&fixed_regs, regs);
 			crash_save_vmcoreinfo();
 			machine_crash_shutdown(&fixed_regs);
diff -puN arch/powerpc/platforms/pseries/nvram.c~kexec-remove-kmsg_dump_kexec arch/powerpc/platforms/pseries/nvram.c
--- a/arch/powerpc/platforms/pseries/nvram.c~kexec-remove-kmsg_dump_kexec
+++ a/arch/powerpc/platforms/pseries/nvram.c
@@ -490,7 +490,6 @@ static void oops_to_nvram(struct kmsg_du
 		/* These are almost always orderly shutdowns. */
 		return;
 	case KMSG_DUMP_OOPS:
-	case KMSG_DUMP_KEXEC:
 		break;
 	case KMSG_DUMP_PANIC:
 		panicking = true;
_

