Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754701Ab1GNTun (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jul 2011 15:50:43 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:54540 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754180Ab1GNTum (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jul 2011 15:50:42 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jonas Gorski <jonas.gorski@gmail.com>
Subject: Re: Status of MIPS on 3.0.0-rc6 kernel
Date: Thu, 14 Jul 2011 21:51:24 +0200
User-Agent: KMail/1.13.6 (Linux/3.0.0-rc7+; KDE/4.6.0; x86_64; ; )
Cc: Roland Vossen <rvossen@broadcom.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-mips@linux-mips.org
References: <4E1ECE3B.10308@broadcom.com> <CAOiHx=kznEFL1BELeg2psg9yw+=-A5reunG0VYTu89DGKwrSzA@mail.gmail.com>
In-Reply-To: <CAOiHx=kznEFL1BELeg2psg9yw+=-A5reunG0VYTu89DGKwrSzA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201107142151.24763.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, July 14, 2011, Jonas Gorski wrote:
> On 14 July 2011 13:08, Roland Vossen <rvossen@broadcom.com> wrote:
> > Hi Jonas,
> >
> > The (defconfig) mips kernel fails to build, with the error message:
> >
> > arch/mips/kernel/i8259.c:240: error: unknown field 'resume' specified in
> > initializer
> >
> > I read on https://lkml.org/lkml/2011/6/1/37 that Geert Uytterhoeven
> > encountered the same issue on June 1st.
> >
> > Do you know if there are still known problems building a 3.0.0-rc6 MIPS
> > kernel ?
> 
> You probably could have found that out yourself quite easily [1] ;-)
> 
> This is actually still a problem in rc7. Commit
> 2e711c04dbbf7a7732a3f7073b1fc285d12b369d ("PM: Remove sysdev suspend,
> resume and shutdown operations") broke it.
> It's probably easily fixable by just removing the offending
> .resume/.shutdown lines (and their referenced functions), but I don't
> know the code (or PM) enough to know if some replacement is missing
> there.

Please check if the appended patch helps.

Thanks,
Rafael

---
From: Rafael J. Wysocki <rjw@sisk.pl>
Subject: MIPS: Convert i8259.c to using syscore_ops

The code in arch/mips/kernel/i8259.c still hasn't been converted to
using struct syscore_ops instead of a sysdev for resume and shutdown.
As a result, this code doesn't build any more after suspend, resume
and shutdown callbacks have been removed from struct sysdev_class.
Fix this problem by converting i8259.c to using syscore_ops.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 arch/mips/kernel/i8259.c |   22 ++++++----------------
 1 file changed, 6 insertions(+), 16 deletions(-)

Index: linux-2.6/arch/mips/kernel/i8259.c
===================================================================
--- linux-2.6.orig/arch/mips/kernel/i8259.c
+++ linux-2.6/arch/mips/kernel/i8259.c
@@ -14,7 +14,7 @@
 #include <linux/interrupt.h>
 #include <linux/kernel.h>
 #include <linux/spinlock.h>
-#include <linux/sysdev.h>
+#include <linux/syscore_ops.h>
 #include <linux/irq.h>
 
 #include <asm/i8259.h>
@@ -215,14 +215,13 @@ spurious_8259A_irq:
 	}
 }
 
-static int i8259A_resume(struct sys_device *dev)
+static void i8259A_resume(void)
 {
 	if (i8259A_auto_eoi >= 0)
 		init_8259A(i8259A_auto_eoi);
-	return 0;
 }
 
-static int i8259A_shutdown(struct sys_device *dev)
+static void i8259A_shutdown(void)
 {
 	/* Put the i8259A into a quiescent state that
 	 * the kernel initialization code can get it
@@ -232,26 +231,17 @@ static int i8259A_shutdown(struct sys_de
 		outb(0xff, PIC_MASTER_IMR);	/* mask all of 8259A-1 */
 		outb(0xff, PIC_SLAVE_IMR);	/* mask all of 8259A-1 */
 	}
-	return 0;
 }
 
-static struct sysdev_class i8259_sysdev_class = {
-	.name = "i8259",
+static struct syscore_ops i8259_syscore_ops = {
 	.resume = i8259A_resume,
 	.shutdown = i8259A_shutdown,
 };
 
-static struct sys_device device_i8259A = {
-	.id	= 0,
-	.cls	= &i8259_sysdev_class,
-};
-
 static int __init i8259A_init_sysfs(void)
 {
-	int error = sysdev_class_register(&i8259_sysdev_class);
-	if (!error)
-		error = sysdev_register(&device_i8259A);
-	return error;
+	register_syscore_ops(&i8259_syscore_ops);
+	return 0;
 }
 
 device_initcall(i8259A_init_sysfs);
