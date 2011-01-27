Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753254Ab1A0UEi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jan 2011 15:04:38 -0500
Received: from va3ehsobe005.messaging.microsoft.com ([216.32.180.31]:58454
	"EHLO VA3EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752614Ab1A0UEh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jan 2011 15:04:37 -0500
X-SpamScore: -23
X-BigFish: VS-23(zzbb2dK1432N98dN9371Pzz1202hzz8275bhz2dh2a8h668h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:az33egw02.freescale.net;RD:az33egw02.freescale.net;EFVD:NLI
Date: Thu, 27 Jan 2011 14:04:20 -0600
From: Scott Wood <scottwood@freescale.com>
To: David Daney <ddaney@caviumnetworks.com>
CC: Coly Li <bosong.ly@taobao.com>, Wang Cong <xiyou.wangcong@gmail.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>, <linuxppc-dev@lists.ozlabs.org>,
        <linux-kernel@vger.kernel.org>, Yong Zhang <yong.zhang0@gmail.com>
Subject: Re: [PATCH 2/7] PowerPC: add unlikely() to BUG_ON()
Message-ID: <20110127140420.2c727f36@udp111988uds.am.freescale.net>
In-Reply-To: <4D41B213.4070606@caviumnetworks.com>
References: <1296130356-29896-1-git-send-email-bosong.ly@taobao.com>
	<1296130356-29896-3-git-send-email-bosong.ly@taobao.com>
	<4D41B213.4070606@caviumnetworks.com>
X-Mailer: Claws Mail 3.7.4 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 Jan 2011 09:57:39 -0800
David Daney <ddaney@caviumnetworks.com> wrote:

> On 01/27/2011 04:12 AM, Coly Li wrote:
> > diff --git a/arch/powerpc/include/asm/bug.h b/arch/powerpc/include/asm/bug.h
> > index 065c590..10889a6 100644
> > --- a/arch/powerpc/include/asm/bug.h
> > +++ b/arch/powerpc/include/asm/bug.h
> > @@ -2,6 +2,7 @@
> >   #define _ASM_POWERPC_BUG_H
> >   #ifdef __KERNEL__
> >
> > +#include<linux/compiler.h>
> >   #include<asm/asm-compat.h>
> >
> >   /*
> > @@ -71,7 +72,7 @@
> >   	unreachable();						\
> >   } while (0)
> >
> > -#define BUG_ON(x) do {						\
> > +#define __BUG_ON(x) do {					\
> >   	if (__builtin_constant_p(x)) {				\
> >   		if (x)						\
> >   			BUG();					\
> > @@ -85,6 +86,8 @@
> >   	}							\
> >   } while (0)
> >
> > +#define BUG_ON(x) __BUG_ON(unlikely(x))
> > +
> 
> This is the same type of frobbing you were trying to do to MIPS.
> 
> I will let the powerpc maintainers weigh in on it, but my opinion is 
> that, as with MIPS, BUG_ON() is expanded to a single machine 
> instruction, and this unlikely() business will not change the generated 
> code in any useful way.  It is thus gratuitous code churn and 
> complexification.

What about just doing this:

#define BUG() __builtin_trap()

#define BUG_ON(x) do {	\
	if (x) \
		BUG(); \
} while (0)

GCC should produce better code than forcing it into twnei.  A simple
BUG_ON(x != y) currently generates something like this (GCC 4.3):

xor     r0,r11,r0
addic   r10,r0,-1
subfe   r9,r10,r0
twnei   r9,0

Or this (GCC 4.5):

xor     r0,r11,r0
cntlzw	r0,r0
srwi	r0,r0,5
xori	r0,r0,1
twnei   r0,0

Instead of:

twne	r0,r11

And if GCC doesn't treat code paths that lead to __builtin_trap() as
unlikely (which could make a difference with complex expressions,
even with a conditional trap instruction), that's something that could
and should be fixed in GCC.

The downside is that GCC says, "The mechanism used may vary from
release to release so you should not rely on any particular
implementation."  However, some architectures (sparc, m68k, ia64)
already use __builtin_trap() for this, it seems unlikely that future GCC
versions would switch away from using the trap instruction[1], and there
doesn't seem to be a better-defined way to make GCC generate trap
instructions intelligently.

-Scott

[1] A more likely possibility is that an older compiler just generates a
call to abort() or similar, and later versions implemented trap -- need
to check what the oldest supported GCC does.

