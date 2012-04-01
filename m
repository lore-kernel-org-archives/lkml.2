Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752951Ab2DARfM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2012 13:35:12 -0400
Received: from www.linutronix.de ([62.245.132.108]:46839 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751601Ab2DARfH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2012 13:35:07 -0400
Date: Sun, 1 Apr 2012 19:34:55 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, linux-alpha@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        uclinux-dist-devel@blackfin.uclinux.org, linux-hexagon@vger.kernel.org,
        linux-ia64@vger.kernel.org, linux-m32r@ml.linux-m32r.org,
        linux-m32r-ja@ml.linux-m32r.org, linux-mips@linux-mips.org,
        linux-am33-list@redhat.com, linux-parisc@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-s390@vger.kernel.org,
        linux-sh@vger.kernel.org, sparclinux@vger.kernel.org,
        dhowells@redhat.com, jejb@parisc-linux.org, linux390@de.ibm.com,
        x86@kernel.org, cmetcalf@tilera.com
Subject: Re: [PATCH RFC] Simplify the Linux kernel by reducing its state
 space
In-Reply-To: <20120331223200.GA32482@n2100.arm.linux.org.uk>
Message-ID: <alpine.LFD.2.02.1204011930010.2542@ionos>
References: <20120331163321.GA15809@linux.vnet.ibm.com> <20120331223200.GA32482@n2100.arm.linux.org.uk>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 31 Mar 2012, Russell King - ARM Linux wrote:

> On Sun, Apr 01, 2012 at 12:33:21AM +0800, Paul E. McKenney wrote:
> > Although there have been numerous complaints about the complexity of
> > parallel programming (especially over the past 5-10 years), the plain
> > truth is that the incremental complexity of parallel programming over
> > that of sequential programming is not as large as is commonly believed.
> > Despite that you might have heard, the mind-numbing complexity of modern
> > computer systems is not due so much to there being multiple CPUs, but
> > rather to there being any CPUs at all.  In short, for the ultimate in
> > computer-system simplicity, the optimal choice is NR_CPUS=0.
> > 
> > This commit therefore limits kernel builds to zero CPUs.  This change
> > has the beneficial side effect of rendering all kernel bugs harmless.
> > Furthermore, this commit enables additional beneficial changes, for
> > example, the removal of those parts of the kernel that are not needed
> > when there are zero CPUs.
> > 
> > Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
> 
> Great work, but I don't think you've gone far enough with this.
> 
> What would really help is if you could consolidate all these NR_CPUS
> definitions into one place so we don't have essentially the same thing
> scattered across all these architectures.  We're already doing this on
> ARM across our platforms, and its about time such an approach was taken
> across the entire kernel tree.
> 
> It looks like the MIPS solution would be the best one to pick.
> Could you rework your patch to do this please?
> 
> While you're at it, you might like to consider that having zero CPUs
> makes all this architecture support redundant, so maybe you've missed
> a trick there - according to my count, we could get rid of almost 3
> million lines of code from arch.  We could replace all that with a
> single standard implementation.

For a first step we can deprecated arch/ and make it depend on
CONFIG_STAGING. That way we can have it around a bit for sentimental
reasons w/o having a lot of churn.

Suggested-by: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

Index: tip/Makefile
===================================================================
--- tip.orig/Makefile
+++ tip/Makefile
@@ -564,7 +564,9 @@ else
 KBUILD_CFLAGS	+= -O2
 endif
 
+ifdef CONFIG_ARCH_SUPPORT
 include $(srctree)/arch/$(SRCARCH)/Makefile
+endif
 
 ifneq ($(CONFIG_FRAME_WARN),0)
 KBUILD_CFLAGS += $(call cc-option,-Wframe-larger-than=${CONFIG_FRAME_WARN})
Index: tip/drivers/staging/Kconfig
===================================================================
--- tip.orig/drivers/staging/Kconfig
+++ tip/drivers/staging/Kconfig
@@ -1,6 +1,10 @@
+config ARCH_SUPPORT
+	bool
+
 menuconfig STAGING
 	bool "Staging drivers"
 	default n
+	select ARCH_SUPPORT
 	---help---
 	  This option allows you to select a number of drivers that are
 	  not of the "normal" Linux kernel quality level.  These drivers
Index: tip/Documentation/feature-removal-schedule.txt
===================================================================
--- tip.orig/Documentation/feature-removal-schedule.txt
+++ tip/Documentation/feature-removal-schedule.txt
@@ -537,3 +537,13 @@ When:	3.6
 Why:	setitimer is not returning -EFAULT if user pointer is NULL. This
 	violates the spec.
 Who:	Sasikantha Babu <sasikanth.v19@gmail.com>
+
+-----------------------------
+
+What:	Remove arch
+When:	April 1st 2013
+Why:    NR_CPUS=0 made arch/ obsolete. Keep it around a bit for
+	sentimental reasons.
+Who:	paulmck,tglx.rmk
+
+	
