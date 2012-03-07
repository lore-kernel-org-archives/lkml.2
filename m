Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758324Ab2CGVrJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 16:47:09 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:63044 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752037Ab2CGVrF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 16:47:05 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: David Howells <dhowells@redhat.com>
Subject: Re: [RFC][PATCH 00/29] Disintegrate and kill asm/system.h
Date: Wed, 7 Mar 2012 21:46:51 +0000
User-Agent: KMail/1.12.2 (Linux/3.3.0-rc1; KDE/4.3.2; x86_64; ; )
Cc: paul.gortmaker@windriver.com, hpa@zytor.com, torvalds@linux-foundation.org,
        sfr@canb.auug.org.au, mingo@redhat.com, tglx@linutronix.de,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
References: <20120307194548.15987.36073.stgit@warthog.procyon.org.uk>
In-Reply-To: <20120307194548.15987.36073.stgit@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201203072146.51494.arnd@arndb.de>
X-Provags-ID: V02:K0:v0SeAOmh6DkbJ0GVufs4C3ZdWYPfiZqHTwsADHIO1Xc
 Juqi42lvGSLM1aRo1A7jpDJ19i0+uavHH1RC7gyiE9RuS+3OrB
 /XGZfBoo+UnamEg+qvR20Yke2TccrSDVWavdR3FZ2oHxw0e7/n
 rVtg5jVPx9grTwkgafEVhcwvtAj203WCrX7pjbkrf5zRYBkw+c
 tnIcWjiooT/OcfjcPWp/jAjR0OcIUh28VlNPXfJGIk49+oARyf
 hFdkrIOMH7BoODOU02WupA6Z+QMOv934vT7H/v/Rwaa9SKhxvn
 AhHOid5D9s6meLJeSq4AVCKX+6Ja2KSZv9eItXc8SkqT17ZkeQ
 8BQIcUTg8463FCGh8/9U=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 07 March 2012, David Howells wrote:
> Here are a bunch of patches to disintegrate asm/system.h into a set of separate
> bits to relieve the problem of circular inclusion dependencies.
>
> The reason for this is that I recently encountered a circular dependency
> problem that came about when I produced some patches to optimise get_order() by
> rewriting it to use ilog2().  This uses bitops - and on the SH arch
> asm/bitops.h drags in asm-generic/get_order.h by a circuituous route involving
> asm/system.h.
>
> The main difficulty seems to be asm/system.h.  It holds a number of low level
> bits with no/few dependencies that are commonly used (eg. memory barriers) and
> a number of bits with more dependencies that aren't used in many places
> (eg. switch_to()).

Excellent series!

One part you were missing seems to be include/asm-generic/system.h, which is used
on openrisc and contains a lot of the things you move to other places. It
would be helpful to split that up as well.

>These patches break asm/system.h up into the following core pieces:
>
>     (1) asm/barrier.h
>
>         Move memory barriers here.  This already done for MIPS and Alpha.
>
>     (2) asm/switch_to.h
>
>         Move switch_to() and related stuff here.
>
>     (3) asm/exec.h
>
>         Move arch_align_stack() here.  Other process execution related bits
>         could perhaps go here from asm/processor.h.
>
>     (4) asm/atomic.h
>
>         Move xchg() and cmpxchg() here as they're full word atomic ops and
>         frequently used by atomic_xchg() and atomic_cmpxchg().

Well, the thing with xchg and cmpxchg is that they operate on arbirary-sized
integers, not atomic_t, unlike everything else in atomic.h.

Some architectures already have an asm/cmpxchg.h, which seems more appropriate
here.

>     (5) asm/bug.h
>
>         Move die() and related bits.
>
>     (6) asm/auxvec.h
>
>         Move AT_VECTOR_SIZE_ARCH here.

These two look suboptimal, but I don't have a better idea either.

> These patches are somewhat inside-out.  They start by removing all the
> inclusions of asm/system.h and then patching up the core files to include the
> right headers and then patching up each arch.  Whilst that's the easiest for
> actually performing this task (as I can use the compiler to find breakages more
> easily), it does mean that the patchset is not bisectable as all arches will be
> broken for a greater or lesser span.
> 
> I'm not sure what's the best way to get around that.  Possibly by rearranging
> things so each arch's asm/system.h is split up, leaving just a file with a
> bunch of #includes - and then delete them all later.  That might not work,
> however, as it may lead to circular deps until asm/system.h is no longer used.
> 

How about adding a '-include asm/system.h' gcc switch for each architecture
in one patch in the beginning, so that the header becomes included all the
time, but then remove that for each arch you go through?

	Arnd
