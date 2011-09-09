Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759515Ab1IIRfK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Sep 2011 13:35:10 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:54995 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759356Ab1IIRfI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Sep 2011 13:35:08 -0400
Date: Fri, 9 Sep 2011 10:34:55 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Olof Johansson <olof@lixom.net>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        Valdis.Kletnieks@vt.edu, dhowells@redhat.com, eric.dumazet@gmail.com,
        darren@dvhart.com, patches@linaro.org, anton@samba.org,
        benh@kernel.crashing.org, paulus@samba.org, linuxppc-dev@ozlabs.org
Subject: Re: [PATCH tip/core/rcu 48/55] powerpc: strengthen
 value-returning-atomics memory barriers
Message-ID: <20110909173455.GH2435@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20110906180015.GA2560@linux.vnet.ibm.com>
 <1315332049-2604-48-git-send-email-paulmck@linux.vnet.ibm.com>
 <CAOesGMi--W6TCUMZzF07-Zep9Ta3tBJWZcG+5imEK_Hza0y9Jg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAOesGMi--W6TCUMZzF07-Zep9Ta3tBJWZcG+5imEK_Hza0y9Jg@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
x-cbid: 11090917-8974-0000-0000-000000085258
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 09, 2011 at 10:23:33AM -0700, Olof Johansson wrote:
> [+linuxppc-dev]
> 
> On Tue, Sep 6, 2011 at 11:00 AM, Paul E. McKenney
> <paulmck@linux.vnet.ibm.com> wrote:
> > The trailing isync/lwsync in PowerPC value-returning atomics needs
> > to be a sync in order to provide the required ordering properties.
> > The leading lwsync/eieio can remain, as the remainder of the required
> > ordering guarantees are provided by the atomic instructions: Any
> > reordering will cause the stwcx to fail, which will result in a retry.
> 
> Admittedly, my powerpc barrier memory is starting to fade, but isn't
> isync sufficient here? It will make sure all instructions before it
> have retired, and will restart any speculative/issued instructions
> beyond it.
> 
> lwsync not being sufficient makes sense since a load can overtake it.

As I understand it, although isync waits for the prior stwcx to execute,
it does not guarantee that the corresponding store is visible to all
processors before any following loads.

> > diff --git a/arch/powerpc/include/asm/synch.h b/arch/powerpc/include/asm/synch.h
> > index d7cab44..4d97fbe 100644
> > --- a/arch/powerpc/include/asm/synch.h
> > +++ b/arch/powerpc/include/asm/synch.h
> > @@ -37,11 +37,7 @@ static inline void isync(void)
> >  #endif
> >
> >  #ifdef CONFIG_SMP
> > -#define __PPC_ACQUIRE_BARRIER                          \
> > -       START_LWSYNC_SECTION(97);                       \
> > -       isync;                                          \
> > -       MAKE_LWSYNC_SECTION_ENTRY(97, __lwsync_fixup);
> > -#define PPC_ACQUIRE_BARRIER    "\n" stringify_in_c(__PPC_ACQUIRE_BARRIER)
> > +#define PPC_ACQUIRE_BARRIER    "\n" stringify_in_c(sync;)
> 
> This can just be done as "\n\tsync\n" instead of the stringify stuff.

That does sound a bit more straightforward, now that you mention it.  ;-)

							Thanx, Paul

