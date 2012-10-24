Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757064Ab2JXQot (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 12:44:49 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:59619 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753555Ab2JXQos (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 12:44:48 -0400
Subject: Re: Process Hang in __read_seqcount_begin
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Peter LaDow <petela@gocougs.wsu.edu>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <CAN8Q1EeF3g8O7=Vn9ufj-3Kd9Qhg4xcTPKkcqBmbsXWW-BnHcQ@mail.gmail.com>
References: <CAN8Q1EdobyFuAvtajGRSqNsCG+XoPA+FkwN=2j_H126mmfEjTQ@mail.gmail.com>
	 <1350925299.8609.978.camel@edumazet-glaptop>
	 <CAN8Q1EeqmHMHD-VUgr7Wzv0Z_DAD1SrEniftg==L14d+hGwu+Q@mail.gmail.com>
	 <CAN8Q1EcTRsHjCJD90q0bKRJFMvi7Vn8YRsyQTAHNtTFVuuNdWQ@mail.gmail.com>
	 <CAN8Q1EeB2kC6A_YP9zdtp_qYHMG5FF7-Usjx7Rz5pv--bjhqkQ@mail.gmail.com>
	 <1351053164.6537.95.camel@edumazet-glaptop>
	 <CAN8Q1EeF3g8O7=Vn9ufj-3Kd9Qhg4xcTPKkcqBmbsXWW-BnHcQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 24 Oct 2012 18:44:44 +0200
Message-ID: <1351097084.6537.110.camel@edumazet-glaptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-10-24 at 09:30 -0700, Peter LaDow wrote:
> On Tue, Oct 23, 2012 at 9:32 PM, Eric Dumazet <eric.dumazet@gmail.com> wrote:
> > Could you try following patch ?
> 
> Thanks for the suggestion. But I have a question about the patch below.
> 
> > +       /* Note : cmpxchg() is a memory barrier, we dont need smp_wmb() */
> > +       if (old != new && cmpxchg(&ptr->sequence, old, new) == old)
> > +               return 1;
> > +       return 0;
> 
> Looking at arch/powerpc/include/asm/system.h, cmpxchg is defined as a
> call to __cmpxchg_u32 (we are 32-bit, and I presume the size is 32
> bits):
> 
> static __always_inline unsigned long
> __cmpxchg_u32(volatile unsigned int *p, unsigned long old, unsigned long new)
> {
>         unsigned int prev;
> 
>         __asm__ __volatile__ (
>         PPC_RELEASE_BARRIER
> "1:     lwarx   %0,0,%2         # __cmpxchg_u32\n\
>         cmpw    0,%0,%3\n\
>         bne-    2f\n"
>         PPC405_ERR77(0,%2)
> "       stwcx.  %4,0,%2\n\
>         bne-    1b"
>         PPC_ACQUIRE_BARRIER
>         "\n\
> 2:"
>         : "=&r" (prev), "+m" (*p)
>         : "r" (p), "r" (old), "r" (new)
>         : "cc", "memory");
> 
>         return prev;
> }
> 
> And the interesting part is PPC_RELEASE_BARRIER and
> PPC_ACQUIRE_BARRIER.  Both of these are noops in non SMP systems.
> From arch/powerpc/include/asm/sync.h:
> 
> #ifdef CONFIG_SMP
> #define __PPC_ACQUIRE_BARRIER                           \
>         START_LWSYNC_SECTION(97);                       \
>         isync;                                          \
>         MAKE_LWSYNC_SECTION_ENTRY(97, __lwsync_fixup);
> #define PPC_ACQUIRE_BARRIER     "\n" stringify_in_c(__PPC_ACQUIRE_BARRIER)
> #define PPC_RELEASE_BARRIER     stringify_in_c(LWSYNC) "\n"
> #else
> #define PPC_ACQUIRE_BARRIER
> #define PPC_RELEASE_BARRIER
> #endif
> 
> So, if these are noops, does this really become an atomic operation?

On UP that would be an 'atomic operation' yes, because of lwarx/stwcx.



