Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753036Ab1HANZz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Aug 2011 09:25:55 -0400
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:37263 "EHLO
	ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752467Ab1HANZt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Aug 2011 09:25:49 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AocDAKGnNk55LCkBgWdsb2JhbABBDqdSFQEBFiYlgUABAQUyASMjEAgDDgouFCUDIRPIFQ6FVV8EoyhJ
Date: Mon, 1 Aug 2011 23:25:46 +1000
From: Dave Chinner <david@fromorbit.com>
To: Andrew Lutomirski <luto@mit.edu>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu
Subject: Re: [3.0-rc0 Regression]: legacy vsyscall emulation increases user
 CPU time by 20%
Message-ID: <20110801132546.GB12870@dastard>
References: <20110729013830.GC5404@dastard>
 <CAObL_7GdxD07-9_aYZBDqutQD6cVz2kYHXAcUwDWr6NkqRdByw@mail.gmail.com>
 <20110729072426.GF5404@dastard>
 <CAObL_7HCyS0aE2KKJR0rF48VKVqdeOruNVvsakAjzR5J6GHvPw@mail.gmail.com>
 <CAObL_7G6rb23X2xAA0Aw6jT+TapynDvhAicNNeo91jD09S5UkQ@mail.gmail.com>
 <20110731110119.GO5404@dastard>
 <CAObL_7ES3FyAAaX-1GOjKV1xCbT2pnW7=Ey+=ErUdTKUt8shkA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAObL_7ES3FyAAaX-1GOjKV1xCbT2pnW7=Ey+=ErUdTKUt8shkA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 01, 2011 at 08:29:47AM -0400, Andrew Lutomirski wrote:
> On Sun, Jul 31, 2011 at 7:01 AM, Dave Chinner <david@fromorbit.com> wrote:
> > On Fri, Jul 29, 2011 at 09:26:19AM -0400, Andrew Lutomirski wrote:
> >> On Fri, Jul 29, 2011 at 8:17 AM, Andrew Lutomirski <luto@mit.edu> wrote:
> >> > On Fri, Jul 29, 2011 at 3:24 AM, Dave Chinner <david@fromorbit.com> wrote:
> >> >> On Thu, Jul 28, 2011 at 11:30:49PM -0400, Andrew Lutomirski wrote:
> >> >>> >
> >> >>> > Assuming this is the problem, can this be fixed without requiring
> >> >>> > the whole world having to wait for the current glibc dev tree to
> >> >>> > filter down into distro repositories?
> >> >>>
> >> >>> How old is your glibc?  gettimeofday has used the vdso since:
> >> >>
> >> >> It's 2.11 on the test machine, whatever that translates to. I
> >> >> haven't really changed the base userspace for about 12 months
> >> >> because if I do I invalidate all my historical benchmark results
> >> >> that I use for comparisons.
> >> >
> >> > 2.11 is from 2009 and appears to contain that commit.  Does your
> >> > workload call time() very frequently?  That's the largest slowdown.
> >> > With the old code, time() took 4-5 ns and with the new code time() is
> >> > about as slow as gettimeofday().  I suggested having a config option
> >> > to allow time() to stay fast until glibc 2.14 became widespread, but a
> >> > few other people disagreed.
> >>
> >> *sigh*
> >>
> >> fs_mark: fs_mark.o lib_timing.o
> >>         ${CC} -static -o fs_mark fs_mark.o lib_timing.o
> >>
> >> Even brand-new glibc still issues vsyscalls when statically linked,
> >> and Ulrich has said [1] that he doesn't care that much about
> >> performance of statically linked code.
> >>
> >> How bad would it be to just remove the -static from the makefile?
> >
> > Results in 270s +-5s user CPU time, so user CPU time is still ~10%
> > up on 3.0 numbers.  IOWs, a non-static link roughly halves the
> > regression but doesn't get rid of it.
> 
> Are you sure?  I stuck a trace event in do_emulate_vsyscall and it's
> not getting hit at all in fs_mark, at least on my system.  I'll send
> out the patch tomorrow.

It may be other changes to kernel code that are causing the rest of
the regresssion. Kernel code that blows the CPU caches (e.g. direct
reclaim LRU scanning) can have a major effect of the userspace CPU
time, so it's probably some secondary effect like that I'm seeing.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
