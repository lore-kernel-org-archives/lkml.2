Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758505Ab0JSMYN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 08:24:13 -0400
Received: from mtagate4.uk.ibm.com ([194.196.100.164]:54393 "EHLO
	mtagate4.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754904Ab0JSMYM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 08:24:12 -0400
Subject: Re: [PATCH] mutex: Introduce arch_mutex_cpu_relax()
From: Gerald Schaefer <gerald.schaefer@de.ibm.com>
Reply-To: gerald.schaefer@de.ibm.com
To: Peter Zijlstra <peterz@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>
In-Reply-To: <1287428051.1998.2124.camel@laptop>
References: <1287070392.8344.15.camel@thinkpad>
	 <1287071960.29097.284.camel@twins>	<1287077465.8344.47.camel@thinkpad>
	 <1287078025.8344.56.camel@thinkpad>
	 <20101014151349.826b5271.akpm@linux-foundation.org>
	 <1287140101.2547.6.camel@thinkpad>  <1287140855.2547.18.camel@thinkpad>
	 <1287428051.1998.2124.camel@laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 19 Oct 2010 14:24:08 +0200
Message-ID: <1287491048.3545.19.camel@thinkpad>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mo, 2010-10-18 at 20:54 +0200, Peter Zijlstra wrote:
> On Fri, 2010-10-15 at 13:07 +0200, Gerald Schaefer wrote:
> > From: Gerald Schaefer <gerald.schaefer@de.ibm.com>
> > 
> > The spinning mutex implementation uses cpu_relax() in busy loops as a
> > compiler barrier. Depending on the architecture, cpu_relax() may do more
> > than needed in this specific mutex spin loops. On System z we also give
> > up the time slice of the virtual cpu in cpu_relax(), which prevents
> > effective spinning on the mutex.
> > 
> > This patch replaces cpu_relax() in the spinning mutex code with
> > arch_mutex_cpu_relax(), which can be defined by each architecture in
> > include/asm/mutex.h. The default is still cpu_relax(), so this should
> > not affect other architectures than System z for now.
> 
> Ingo's randconfig build found the following, .config attached.
> 
> including "asm/mutex.h" isn't advised.
> 
>   CC      kernel/mutex.o
> In file included from /usr/src/linux-2.6/kernel/mutex.c:33:
> /usr/src/linux-2.6/include/asm-generic/mutex-null.h:13:1: warning: "__mutex_fastpath_lock" redefined
> In file included from /usr/src/linux-2.6/arch/x86/include/asm/mutex.h:4,
>                  from /usr/src/linux-2.6/include/linux/mutex.h:19,
>                  from /usr/src/linux-2.6/kernel/mutex.c:20:
> /usr/src/linux-2.6/arch/x86/include/asm/mutex_64.h:19:1: warning: this is the location of the previous definition
> In file included from /usr/src/linux-2.6/kernel/mutex.c:33:
> /usr/src/linux-2.6/include/asm-generic/mutex-null.h:15:1: warning: "__mutex_fastpath_unlock" redefined
> In file included from /usr/src/linux-2.6/arch/x86/include/asm/mutex.h:4,
>                  from /usr/src/linux-2.6/include/linux/mutex.h:19,
>                  from /usr/src/linux-2.6/kernel/mutex.c:20:
> /usr/src/linux-2.6/arch/x86/include/asm/mutex_64.h:62:1: warning: this is the location of the previous definition
> In file included from /usr/src/linux-2.6/kernel/mutex.c:33:
> /usr/src/linux-2.6/include/asm-generic/mutex-null.h:13:1: warning: "__mutex_fastpath_lock" redefined
> In file included from /usr/src/linux-2.6/arch/x86/include/asm/mutex.h:4,
>                  from /usr/src/linux-2.6/include/linux/mutex.h:19,
>                  from /usr/src/linux-2.6/kernel/mutex.c:20:
> /usr/src/linux-2.6/arch/x86/include/asm/mutex_64.h:19:1: warning: this is the location of the previous definition
> In file included from /usr/src/linux-2.6/kernel/mutex.c:33:
> /usr/src/linux-2.6/include/asm-generic/mutex-null.h:15:1: warning: "__mutex_fastpath_unlock" redefined
> In file included from /usr/src/linux-2.6/arch/x86/include/asm/mutex.h:4,
>                  from /usr/src/linux-2.6/include/linux/mutex.h:19,
>                  from /usr/src/linux-2.6/kernel/mutex.c:20:
> /usr/src/linux-2.6/arch/x86/include/asm/mutex_64.h:62:1: warning: this is the location of the previous definition

Ok, I see now that including <asm/mutex.h> from include/linux/mutex.h is
not a good idea, because of this code in kernel/mutex.c (and the conflict
with CONFIG_DEBUG_MUTEXES set):

#ifdef CONFIG_DEBUG_MUTEXES
# include "mutex-debug.h"
# include <asm-generic/mutex-null.h>
#else
# include "mutex.h"
# include <asm/mutex.h>
#endif

Putting the architecture specific details of arch_mutex_cpu_relax()
somewhere else than <asm/mutex.h> doesn't seem like a good idea either.
Also, putting an "#ifndef CONFIG_DEBUG_MUTEXES" around my
"#include <asm/mutex.h>" in include/linux/mutex.h would fix the conflict,
but that also looks rather ugly.

So I guess I'll just go back to the original Kconfig approach, which
at least avoids all this header file mess. I'll send a new patch.


