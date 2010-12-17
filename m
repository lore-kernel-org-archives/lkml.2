Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751490Ab0LQF0v (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Dec 2010 00:26:51 -0500
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:58901 "EHLO
	ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750866Ab0LQF0v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Dec 2010 00:26:51 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av0EADaDCk15Lc+z/2dsb2JhbACDZKBbdLIukGKBIYM1dAQ
Date: Fri, 17 Dec 2010 16:26:42 +1100
From: Nick Piggin <npiggin@kernel.dk>
To: Axel <axel.lin@gmail.com>
Cc: Peter =?iso-8859-1?Q?H=FCwe?= <PeterHuewe@gmx.de>,
        Nick Piggin <npiggin@kernel.dk>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Russell King <rmk+kernel@arm.linux.org.uk>
Subject: Re: include/linux: Add missing include / fix build failure
Message-ID: <20101217052642.GA3282@amd>
References: <g06LM-1y8-17@gated-at.bofh.it>
 <g096W-5pB-17@gated-at.bofh.it>
 <g09gC-5Db-9@gated-at.bofh.it>
 <0d7b441c-a702-4bce-8711-8c0cedfb5d8a@c17g2000prm.googlegroups.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <0d7b441c-a702-4bce-8711-8c0cedfb5d8a@c17g2000prm.googlegroups.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 15, 2010 at 11:57:41PM -0800, Axel wrote:
> On 12月16日, 上午7時50分, Peter Hüwe <PeterHu...@gmx.de> wrote:
> > From: Peter Huewe <peterhu...@gmx.de>
> >
> > This patch fixes a build failure[1-2] by adding the missing asm/memory.h
> > include needed for arch_is_coherent().
> >
> > Error message:
> > In file included from include/linux/list_bl.h:5,
> >                  from include/linux/rculist_bl.h:7,
> >                  from include/linux/dcache.h:7,
> >                  from include/linux/fs.h:381,
> >                  from arch/arm/mm/mmap.c:4:
> > include/linux/bit_spinlock.h: In function 'bit_spin_unlock':
> > include/linux/bit_spinlock.h:61: error: implicit declaration of function
> > 'arch_is_coherent'
> >
> > KernelVersion: linux-next-20101215
> > Used configs: hackkit_defconfig (arm), ep93xx_defconfig (arm)
> >
> > References:
> > [1]http://kisskb.ellerman.id.au/kisskb/buildresult/3651495/
> > [2]http://kisskb.ellerman.id.au/kisskb/buildresult/3651425/
> >
> > Signed-off-by: Peter Huewe <peterhu...@gmx.de>
> > ---
> > v2:
> > moved additional information in the commit message.
> >
> >  include/linux/bit_spinlock.h |    1 +
> >  1 files changed, 1 insertions(+), 0 deletions(-)
> >
> > diff --git a/include/linux/bit_spinlock.h b/include/linux/bit_spinlock.h
> > index e612575..053fad7 100644
> > --- a/include/linux/bit_spinlock.h
> > +++ b/include/linux/bit_spinlock.h
> > @@ -4,6 +4,7 @@
> >  #include <linux/kernel.h>
> >  #include <linux/preempt.h>
> >  #include <asm/atomic.h>
> > +#include <asm/memory.h>
> >
> >  /*
> >   *  bit-based spin_lock()
> > --
> > 1.7.2.2
> >
> > --
> 
> hi Peter,
> After apply the patch,
> I got below error message while
> # make i386_defconfig;make
> 
>   CHK     include/linux/version.h
>   CHK     include/generated/utsrelease.h
>   CALL    scripts/checksyscalls.sh
>   CC      init/main.o
> In file included from include/linux/list_bl.h:5,
>                  from include/linux/rculist_bl.h:7,
>                  from include/linux/dcache.h:7,
>                  from include/linux/fs.h:381,
>                  from include/linux/proc_fs.h:5,
>                  from init/main.c:14:
> include/linux/bit_spinlock.h:7:24: error: asm/memory.h: No such file
> or directory
> make[1]: *** [init/main.o] Error 1
> make: *** [init] Error 2
> 
> I personally fix it by below patch now, but I'm not so sure if this is
> a good way to fix it.

Yes it should be fixed in arm code. If someone would send along a
patch to the maintainer, that would be appreciated.

Thanks,
Nick

> 
> git diff arch/arm/include/asm/system.h
> diff --git a/arch/arm/include/asm/system.h b/arch/arm/include/asm/
> system.h
> index ec4327a..3222ab8 100644
> --- a/arch/arm/include/asm/system.h
> +++ b/arch/arm/include/asm/system.h
> @@ -155,6 +155,7 @@ extern unsigned int user_debug;
>  #define rmb()          dmb()
>  #define wmb()          mb()
>  #else
> +#include <asm/memory.h>
>  #define mb()   do { if (arch_is_coherent()) dmb(); else barrier(); }
> while (0)
>  #define rmb()  do { if (arch_is_coherent()) dmb(); else barrier(); }
> while (0)
>  #define wmb()  do { if (arch_is_coherent()) dmb(); else barrier(); }
> while (0)
