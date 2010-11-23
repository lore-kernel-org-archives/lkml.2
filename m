Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753959Ab0KWOT5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 09:19:57 -0500
Received: from canuck.infradead.org ([134.117.69.58]:59827 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752627Ab0KWOT4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 09:19:56 -0500
Subject: Re: [PATCH] mutex: Introduce arch_mutex_cpu_relax()
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: gerald.schaefer@de.ibm.com
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>
In-Reply-To: <1290521556.16834.25.camel@thinkpad>
References: <1290437256.7455.4.camel@thinkpad>
	 <20101122121049.01c4690a.akpm@linux-foundation.org>
	 <1290521556.16834.25.camel@thinkpad>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 23 Nov 2010 15:20:00 +0100
Message-ID: <1290522000.2072.406.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-11-23 at 15:12 +0100, Gerald Schaefer wrote:
> On Mo, 2010-11-22 at 12:10 -0800, Andrew Morton wrote:
> > On Mon, 22 Nov 2010 15:47:36 +0100
> > Gerald Schaefer <gerald.schaefer@de.ibm.com> wrote:
> > 
> > > From: Gerald Schaefer <gerald.schaefer@de.ibm.com>
> > > 
> > > The spinning mutex implementation uses cpu_relax() in busy loops as a
> > > compiler barrier. Depending on the architecture, cpu_relax() may do more
> > > than needed in this specific mutex spin loops. On System z we also give
> > > up the time slice of the virtual cpu in cpu_relax(), which prevents
> > > effective spinning on the mutex.
> > > 
> > > This patch replaces cpu_relax() in the spinning mutex code with
> > > arch_mutex_cpu_relax(), which can be defined by each architecture that
> > > selects HAVE_ARCH_MUTEX_CPU_RELAX. The default is still cpu_relax(), so
> > > this patch should not affect other architectures than System z for now.
> > > 
> > > ...
> > >
> > > --- a/include/linux/mutex.h
> > > +++ b/include/linux/mutex.h
> > > @@ -160,4 +160,8 @@ extern int mutex_trylock(struct mutex *l
> > >  extern void mutex_unlock(struct mutex *lock);
> > >  extern int atomic_dec_and_mutex_lock(atomic_t *cnt, struct mutex *lock);
> > >  
> > > +#ifndef CONFIG_HAVE_ARCH_MUTEX_CPU_RELAX
> > > +#define arch_mutex_cpu_relax()	cpu_relax()
> > > +#endif
> > 
> > A simpler way of doing this is to remove the CONFIG_ variable
> > altogether and do 
> > 
> > #ifndef arch_mutex_cpu_relax
> > #define arch_mutex_cpu_relax()	cpu_relax()
> > #endif
> > 
> > When doing this, one should be clear about _which_ arch file has the
> > responsibility of defining arch_mutex_cpu_relax, and make sure that
> > this arch file is reliably included in the .c file.
> 
> Well, I've tried that with my last approach, defining arch_mutex_cpu_relax()
> in <asm/mutex.h> and including that from <linux/mutex.h>. This didn't work
> well because of ugly header file dependencies, and Peter also commented
> that "including "asm/mutex.h" isn't advised". The problem is the following
> code in kernel/mutex.c (after including <linux/mutex.h>) when
> CONFIG_DEBUG_MUTEXES is set:
> 
> #ifdef CONFIG_DEBUG_MUTEXES
> # include "mutex-debug.h"
> # include <asm-generic/mutex-null.h>
> #else
> # include "mutex.h"
> # include <asm/mutex.h>
> #endif
> 
> So I can only include <asm/mutex.h> from <linux/mutex.h> with an ugly
> "#ifndef CONFIG_DEBUG_MUTEXES" around it, or use a completely different
> or new arch header file (but <asm/mutex.h> seems like the right place
> for this). The CONFIG_ approach avoids all this header file dependency
> mess, or did I miss something (or maybe it's just me and it is not ugly
> at all)?

Yeah, that all cause massive grief.. I've applied your patch as is,
assuming s390 already has the needed arch_mutex_cpu_relax()
implementation (otherwise I've just broken my s390 build).

Thanks
