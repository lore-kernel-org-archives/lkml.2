Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932494Ab2EGUzW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 16:55:22 -0400
Received: from www.linutronix.de ([62.245.132.108]:42145 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932189Ab2EGUzU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 16:55:20 -0400
Date: Mon, 7 May 2012 22:55:18 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Sam Ravnborg <sam@ravnborg.org>
cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [patch 01/18] fork: Remove the weak insanity
In-Reply-To: <20120505155824.GA14468@merkur.ravnborg.org>
Message-ID: <alpine.LFD.2.02.1205072243500.6271@ionos>
References: <20120505150007.543515803@linutronix.de> <20120505150141.306358267@linutronix.de> <20120505155824.GA14468@merkur.ravnborg.org>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 5 May 2012, Sam Ravnborg wrote:

> On Sat, May 05, 2012 at 03:05:40PM -0000, Thomas Gleixner wrote:
> > We error out when compiling with gcc4.1.[01] as it miscompiles
> > __weak. The workaround with magic defines is not longer
> > necessary. Make it __weak again.
> 
> The cleanup is much appreciated!
> 
> But the magic defines is IMO much better than the CONFIG_ based approach
> that this patch-set introduces in the last patch.
> 
> If you do:
> 
>     $git grep arch_task_cache_init
> 
> Then if you see:
> 
>     #define arch_task_cache_init arch_task_cache_init
> 
> Then you know alrady that this arch will provide a local implementation
> of arch_task_cache_init().
> No need to grep for an ARCH_XXX symbol that you need to look up
> somewhere else.

I'm not following that argument.

Removing that magic define thing does not change anything. The change
is:

-#define arch_task_cache_init arch_task_cache_init
-#define arch_task_cache_init arch_task_cache_init
-/*
- * macro override instead of weak attribute alias, to workaround
- * gcc 4.1.0 and 4.1.1 bugs with weak attribute and empty functions.
- */
-#ifndef arch_task_cache_init
-#define arch_task_cache_init()
-#endif
+void __init __weak arch_task_cache_init(void) { }

So $git grep arch_task_cache_init still tells you who is overriding
arch_task_cache_init () which is:

arch/sh/include/asm/thread_info.h:extern void arch_task_cache_init(void);
arch/sh/kernel/process.c:void arch_task_cache_init(void)
arch/x86/include/asm/thread_info.h:extern void arch_task_cache_init(void);
arch/x86/kernel/process.c:void arch_task_cache_init(void)

What's your problem ?

Now for the last patch in the series:

It merily moves 

#define __HAVE_ARCH_THREAD_INFO_ALLOCATOR 

to a Kconfig based

   select ARCH_THREAD_INFO_ALLOCATOR

I'm not seeing any difference except that something which is actually
a config switch is moved to the place where it belongs.

Thanks,

	tglx
