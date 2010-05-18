Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756112Ab0ERA5x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 20:57:53 -0400
Received: from ozlabs.org ([203.10.76.45]:32911 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752559Ab0ERA5v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 20:57:51 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: cpumask: fix compat getaffinity
Date: Tue, 18 May 2010 10:27:45 +0930
User-Agent: KMail/1.13.2 (Linux/2.6.32-21-generic; KDE/4.4.2; i686; ; )
Cc: Milton Miller <miltonm@bga.com>, Arnd Bergmann <arnd@arndb.de>,
       Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org,
       stable@vger.kernel.org, anton@samba.org
References: <1273653045_3386@mail4.comsite.net> <201005142209.14473.rusty@rustcorp.com.au> <20100517134320.A190.A69D9226@jp.fujitsu.com>
In-Reply-To: <20100517134320.A190.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201005181027.46273.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 17 May 2010 03:34:44 pm KOSAKI Motohiro wrote:
> > On Wed, 12 May 2010 06:00:45 pm Milton Miller wrote:
> > > 
> > > At least for parsing, we need to allocate and parse NR_CPUS until
> > > all places like arch/powerpc/platforms/pseries/xics.c that compare a
> > > user-supplied mask to CPUMASK_ALL are eliminated.
> > 
> > Good point.  Anton will want to fix those anyway for CONFIG_CPUMASK_OFFSTACK,
> > too, but that's the reason the parsing uses nr_cpumask_bits.
> > 
> > > > Would it make sense to use my initial patch for -stable, which reverts
> > > > the ABI back to before the change that caused the problem, but apply
> > > > the correct fix (changing the ABI throughout) for future releases?
> > > 
> > > This would definitly be the conservative fix.
> > 
> > Instead of changing back to NR_CPUS which will break libnuma for
> > CPUMASK_OFFSTACK, how about changing it to nr_cpumask_bits and having an
> > explicit comment above it:
> 
> Yes and No.
> 
> 1) sched_getaffinity syscall is used from glibc and libnuma.
> 2) glibc doesn't use the return value almostly. glibc emulate it as NR_CPUS=1024.
> 3) Now, both sched_getaffinity() and compat_sys_sched_getaffinity() have nr_cpu_ids thing.
> 4) But only compat_sys_sched_getaffinity() hit libnuma problem.
> 
> I think It mean compat_sys_sched_getaffinity() should behave as sched_getaffinity().
> IOW, libnuma assume compat_sys_sched_getaffinity() return len args or NR_CPUS.
> then, following patch do it. I confirmed the patch works with or without CPUMASK_OFFSTACK.  
> 
> So, My proposal is
> 	1) merge both mine and yours to linus tree
> 	2) but backport only mine

I think we should just take yours; it seems sufficient.

Acked-by: Rusty Russell <rusty@rustcorp.com.au>

We're going to break at > 4096 cpus whatever we do; I argued with Ingo about
it when the affinity syscalls were added but noone thought we'd hit it
so soon.

Thanks,
Rusty.
