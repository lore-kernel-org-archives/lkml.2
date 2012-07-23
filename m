Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752538Ab2GWLnG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2012 07:43:06 -0400
Received: from cantor2.suse.de ([195.135.220.15]:49898 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750854Ab2GWLnD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2012 07:43:03 -0400
Date: Mon, 23 Jul 2012 12:42:58 +0100
From: Mel Gorman <mgorman@suse.de>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Fengguang Wu <fengguang.wu@intel.com>, kernel-janitors@vger.kernel.org,
        Kyle McMartin <kyle@parisc-linux.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Parisc List <linux-parisc@vger.kernel.org>
Subject: Re: [next:akpm 129/309] net/core/sock.c:274:36: error: initializer
 element is not constant
Message-ID: <20120723114258.GV9222@suse.de>
References: <20120722163058.GB13376@localhost>
 <20120723111619.GT9222@suse.de>
 <1343042420.3027.11.camel@dabdike.int.hansenpartnership.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <1343042420.3027.11.camel@dabdike.int.hansenpartnership.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 23, 2012 at 12:20:20PM +0100, James Bottomley wrote:
> [Parisc list cc added]
> On Mon, 2012-07-23 at 12:16 +0100, Mel Gorman wrote:
> > On Mon, Jul 23, 2012 at 12:30:58AM +0800, Fengguang Wu wrote:
> > > Hi Mel,
> > > 
> > > To be frank, I don't quite understand this build failure..
> > > 
> > > tree:   next/akpm akpm
> > > head:   37e2ad4953983527f7bdb6831bf478eedcc84082
> > > commit: 799dc3a908b1df8b766c35aefc24c1b5356aa051 [129/309] netvm: allow skb allocation to use PFMEMALLOC reserves
> > > config: parisc-defconfig (attached as .config)
> > > 
> > > All related error/warning messages:
> > > 
> > > net/core/sock.c:274:36: error: initializer element is not constant
> > > net/core/sock.c:274:36: error: (near initialization for 'memalloc_socks')
> > > net/core/sock.c:274:36: error: initializer element is not constant
> > > 
> > 
> > It looks parisc specific so am adding some parisc because this builds but
> > I am less sure if it is actually correct. If it's correct, it should be
> > appear before the swap-over-nfs patches to avoid bisection problems.
> > I've added some parisc folk for review.
> > 
> > ---8<---
> > parisc: Redefine ATOMIC_INIT and ATOMIC64_INIT like other architectures
> > 
> > The following build error occured during a parisc build with
> > swap-over-NFS patches applied.
> > 
> > net/core/sock.c:274:36: error: initializer element is not constant
> > net/core/sock.c:274:36: error: (near initialization for 'memalloc_socks')
> > net/core/sock.c:274:36: error: initializer element is not constant
> > 
> > It's not obvious but this is due to how ATOMIC_INIT is defined on
> > parisc. It should affect any user of STATIC_KEY_INIT_FALSE on that
> > platform.
> > 
> > This patch makes the definition of ATOMIC_INIT on parisc to look like
> > other arches definition.
> > 
> > Reported-by: Fengguang Wu <fengguang.wu@intel.com>
> > Signed-off-by: Mel Gorman <mgorman@suse.de>
> > ---
> >  arch/parisc/include/asm/atomic.h |    4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> > 
> > diff --git a/arch/parisc/include/asm/atomic.h b/arch/parisc/include/asm/atomic.h
> > index 6c6defc..af9cf30 100644
> > --- a/arch/parisc/include/asm/atomic.h
> > +++ b/arch/parisc/include/asm/atomic.h
> > @@ -141,7 +141,7 @@ static __inline__ int __atomic_add_unless(atomic_t *v, int a, int u)
> >  
> >  #define atomic_sub_and_test(i,v)	(atomic_sub_return((i),(v)) == 0)
> >  
> > -#define ATOMIC_INIT(i)	((atomic_t) { (i) })
> > +#define ATOMIC_INIT(i)	{ (i) }
> >  
> >  #define smp_mb__before_atomic_dec()	smp_mb()
> >  #define smp_mb__after_atomic_dec()	smp_mb()
> > @@ -150,7 +150,7 @@ static __inline__ int __atomic_add_unless(atomic_t *v, int a, int u)
> >  
> >  #ifdef CONFIG_64BIT
> >  
> > -#define ATOMIC64_INIT(i) ((atomic64_t) { (i) })
> > +#define ATOMIC64_INIT(i) { (i) }
> >  
> >  static __inline__ s64
> >  __atomic64_add_return(s64 i, atomic64_t *v)
> 
> OK, I don't understand this either ... why would not casting to the
> appropriate type suddenly stop warning about the initialiser being non
> constant.  It looks like some type of gcc bug to me. 

I agree. I could not see any functional difference as such either but also
could not figure out why gcc would get it right for some arches and not
for others.

> Our toolchain
> expert (Dave) hangs out on the parisc list ... he'll want to know your
> gcc -v.
> 

I'm using the cross-compiler from
ftp://ftp.kernel.org/pub/tools/crosstool/files/bin/x86_64/4.6.3/. I do
not know what compiler Fengguang Wu was using. 

Using built-in specs.
COLLECT_GCC=/home/mel/git-public/cross-compilers/gcc-4.6.3-nolibc/hppa-linux/bin/hppa-linux-gcc
COLLECT_LTO_WRAPPER=/home/mel/git-public/cross-compilers/gcc-4.6.3-nolibc/hppa-linux/bin/../libexec/gcc/hppa-linux/4.6.3/lto-wrapper
Target: hppa-linux
Configured with: /home/tony/buildall/src/gcc/configure
--target=hppa-linux --host=x86_64-linux-gnu --build=x86_64-linux-gnu
--enable-targets=all --prefix=/opt/cross/gcc-4.6.3-nolibc/hppa-linux/
--enable-languages=c --with-newlib --without-headers
--enable-sjlj-exceptions --with-system-libunwind --disable-nls
--disable-threads --disable-shared --disable-libmudflap --disable-libssp
--disable-libgomp --disable-decimal-float --enable-checking=release
--with-mpfr=/home/tony/buildall/src/sys-x86_64
--with-gmp=/home/tony/buildall/src/sys-x86_64 --disable-bootstrap
--disable-libquadmath
Thread model: single
gcc version 4.6.3 (GCC) 

-- 
Mel Gorman
SUSE Labs
