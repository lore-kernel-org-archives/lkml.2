Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754319Ab2EHMEF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 08:04:05 -0400
Received: from www.linutronix.de ([62.245.132.108]:45076 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753726Ab2EHMEE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 08:04:04 -0400
Date: Tue, 8 May 2012 14:04:01 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Chris Metcalf <cmetcalf@tilera.com>
cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>
Subject: Re: [patch 17/18] tile: Use common threadinfo allocator
In-Reply-To: <4FA835FA.2090201@tilera.com>
Message-ID: <alpine.LFD.2.02.1205081359550.6271@ionos>
References: <20120505150007.543515803@linutronix.de> <20120505150142.311126440@linutronix.de> <4FA54569.2040209@tilera.com> <alpine.LFD.2.02.1205072134130.6271@ionos> <4FA82A80.3090001@tilera.com> <alpine.LFD.2.02.1205072227540.6271@ionos>
 <4FA835FA.2090201@tilera.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 7 May 2012, Chris Metcalf wrote:

> On 5/7/2012 4:33 PM, Thomas Gleixner wrote:
> > On Mon, 7 May 2012, Chris Metcalf wrote:
> >
> >> I think the only obvious
> >> way is to override something in the threadinfo allocator.
> > Wrong. The obvious way is to use the common code and add a special
> > flag to it.
> 
> Well, that's overriding something in the threadinfo allocator :-)
> 
> In all seriousness, adding an arch-specific GFP flag sounds like it should
> work OK for tile.  Thanks!

I pushed out the minimum set of patches into a separate branch, so you
can base your work on that and we wont run into merge order
dependencies.

  git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git smp/threadinfo

The patch below lets you define your extra gfp flag for tile.

Thanks,

	tglx

-------->

Subject: threadinfo: Add an optional ARCH gfp flag for the threadinfo allocator

Allows architectures to add their magic gfp flags.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

--- tip.orig/include/linux/thread_info.h
+++ tip/include/linux/thread_info.h
@@ -55,11 +55,17 @@ extern long do_no_restart_syscall(struct
 #ifdef __KERNEL__
 
 #ifdef CONFIG_DEBUG_STACK_USAGE
-# define THREADINFO_GFP		(GFP_KERNEL | __GFP_NOTRACK | __GFP_ZERO)
+# define __THREADINFO_GFP	(GFP_KERNEL | __GFP_NOTRACK | __GFP_ZERO)
 #else
-# define THREADINFO_GFP		(GFP_KERNEL | __GFP_NOTRACK)
+# define __THREADINFO_GFP	(GFP_KERNEL | __GFP_NOTRACK)
 #endif
 
+#ifndef ARCH_THREAD_INFO_GFP
+# define ARCH_THREAD_INFO_GFP	(0)
+#endif
+
+#define THREADINFO_GFP		(__THREADINFO_GFP | ARCH_THREAD_INFO_GFP)
+
 /*
  * flag set/clear/test wrappers
  * - pass TIF_xxxx constants to these functions
