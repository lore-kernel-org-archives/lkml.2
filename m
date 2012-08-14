Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756400Ab2HNO53 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 10:57:29 -0400
Received: from mga01.intel.com ([192.55.52.88]:30981 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753118Ab2HNO5Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 10:57:25 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.77,766,1336374000"; 
   d="scan'208";a="200744220"
Date: Tue, 14 Aug 2012 22:57:15 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>, kernel-janitors@vger.kernel.org,
        Greg Ungerer <gerg@uclinux.org>, linux-m68k@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        Guan Xuetao <gxt@mprc.pku.edu.cn>,
        Chen Liqin <liqin.chen@sunplusct.com>, Lennox Wu <lennox.wu@gmail.com>
Subject: Re: Architectures missing atomic64_t
Message-ID: <20120814145715.GA16834@localhost>
References: <20120812145023.GA17077@localhost>
 <87k3x3z3de.fsf@xmission.com>
 <20120813133910.GA30532@localhost>
 <63f9e712-3cd1-4020-9df6-8fb8d9c3f1ec@email.android.com>
 <20120813175516.GA32757@localhost>
 <20120813181343.GA2055@localhost>
 <877gt2y5hc.fsf_-_@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <877gt2y5hc.fsf_-_@xmission.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 13, 2012 at 12:08:47PM -0700, Eric W. Biederman wrote:
> Fengguang Wu <fengguang.wu@intel.com> writes:
> 
> > On Tue, Aug 14, 2012 at 01:55:16AM +0800, Fengguang Wu wrote:
> >> > >I'd suggest to fix it in m68k and make atomic64_t generally available.
> >> > 
> >> > Fengguang in your testing on any architechtures is atomic64_t missing on anything except some m68k subarchtechtures?
> >> 
> >> Eric, it only complaints for m68k, among the architechtures the build
> >> tests covered (alpha arm avr32 blackfin cris frv h8300 i386 ia64 m32r
> >> m68k mips mn10300 openrisc parisc powerpc s390 sh sparc sparc64 tile
> >> um x86_64 xtensa).
> >
> > Sorry, I must missed something (in my system, build errors are only
> > recorded on first sight)..
> >
> > wfg /c/linux% for arch in arch/*/; do grep -ir -q atomic64 $arch || echo $arch; done
> > arch/c6x/
> > arch/h8300/
> > arch/mn10300/
> > arch/score/
> > arch/unicore32/
> >
> > So the above archs are likely still missing atomic64_t support.
> > However it should be trivial to add support to them, by adding
> > "select GENERIC_ATOMIC64" lines to them.
> 
> So I just looked a little deeper and it appears architectures that do
> not support atomic64_t are broken.
> 
> The generic atomic64 support came in 2009 to support the perf subsystem
> with the expectation that all architectures would implement atomic64
> support.
> 
> Furthermore upon inspection of the kernel atomic64_t is used in a fair
> number of places beyond the performance counters:
> block/blk-cgroup.c
> drivers/acpi/apei/
> drivers/block/rbd.c
> drivers/crypto/nx/nx.h
> drivers/gpu/drm/radeon/radeon.h
> drivers/infiniband/hw/ipath/
> drivers/infiniband/hw/qib/
> drivers/staging/octeon/
> fs/xfs/
> include/linux/perf_event.h
> include/net/netfilter/nf_conntrack_acct.h
> kernel/events/
> kernel/trace/
> net/mac80211/key.h
> net/rds/
> 
> The block control group, infiniband, xfs, crypto, 802.11, netfilter.
> Nothing quite so fundamental as fs/namespace.c but definitely in
> multiplatform-code that should work, and is already broken on those
> architecutres.
> 
> Looking at the implementation of atomic64_add_return in lib/atomic64.c
> the code looks as efficient as these kinds of things get.
> 
> Which leads me to the conclusion that we need atomic64 support on all
> architectures.

Agreed.

> Arch folks can you please take care of your achitectures and ensure
> that atomic64_t is supported?

Since I can test h8300 and mn10300, I'll do patches for them.

CC score and unicore32 maintainers.

Thanks,
Fengguang

> Eric
> 
> commit 09d4e0edd4614e787393acc582ac701c6ec3565b
> Author: Paul Mackerras <paulus@samba.org>
> Date:   Fri Jun 12 21:10:05 2009 +0000
> 
>     lib: Provide generic atomic64_t implementation
>     
>     Many processor architectures have no 64-bit atomic instructions, but
>     we need atomic64_t in order to support the perf_counter subsystem.
>     
>     This adds an implementation of 64-bit atomic operations using hashed
>     spinlocks to provide atomicity.  For each atomic operation, the address
>     of the atomic64_t variable is hashed to an index into an array of 16
>     spinlocks.  That spinlock is taken (with interrupts disabled) around the
>     operation, which can then be coded non-atomically within the lock.
>     
>     On UP, all the spinlock manipulation goes away and we simply disable
>     interrupts around each operation.  In fact gcc eliminates the whole
>     atomic64_lock variable as well.
>     
>     Signed-off-by: Paul Mackerras <paulus@samba.org>
>     Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> 
