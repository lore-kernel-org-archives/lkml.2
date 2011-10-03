Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756647Ab1JCQB0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 12:01:26 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:53912 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756620Ab1JCQBT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 12:01:19 -0400
Date: Mon, 3 Oct 2011 09:00:36 -0700
From: "Darrick J. Wong" <djwong@us.ibm.com>
To: Joakim Tjernlund <joakim.tjernlund@transmode.se>
Cc: linux-crypto <linux-crypto@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3] crc32c: Implement CRC32c with slicing-by-8 algorithm
Message-ID: <20111003160036.GX11984@tux1.beaverton.ibm.com>
Reply-To: djwong@us.ibm.com
References: <OF1BEE9025.31A1BE17-ONC125791B.00203167-C125791B.00211B4A@transmode.se> <20110930161223.GW11984@tux1.beaverton.ibm.com> <OF34B3D797.8C95417C-ONC125791C.00497BA8-C125791C.004C2C5A@transmode.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <OF34B3D797.8C95417C-ONC125791C.00497BA8-C125791C.004C2C5A@transmode.se>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 01, 2011 at 03:52:00PM +0200, Joakim Tjernlund wrote:
> "Darrick J. Wong" <djwong@us.ibm.com> wrote on 2011/09/30 18:12:23:
> >
> > [putting mailing lists on cc]
> >
> > On Fri, Sep 30, 2011 at 08:01:36AM +0200, Joakim Tjernlund wrote:
> > >
> > > (Just happen to see this patch in the archives)
> > >
> > > - This is basically an copy of Bobs crc32 work and duplicates code, this
> > >   code needs to move into /lib/crc32.c and use the existing framework.
> >
> > Which framework are you talking about?  lib/crc32.c appears to be a simple
> > module that exports a utility function.  Do you mean that you want to merge the
> > crc32{,c}defs.h and gen_crc32{,c}table.c code?  Do you want a build script that
> > starts with only a crc${ALG}_defs.h file and stamps out gencrc${ALG}_table.c
> > and crc${ALG}.c boilerplate code and then builds it?
> 
> I meant adding a crc32c_le in crc32.c and extend gen_table to generate the crc32c table.
> 
> >
> > I really don't know; from my perspective there was a slow implementation in
> > crypto/crc32c.c and I wanted to speed it up.  crc32c seems to be in crypto/ and
> > not lib/ so that the implementation can be replaced with a hardware accelerated
> > version at runtime (crc32c-intel).
> 
> It was a mistake to place it there IMHO.
> 
> >
> > For crc32 which has no such hw replacement (as far as I know), moving it into
> > crypto/ would incur the overhead of going through the cryptoapi for not much
> > benefit.  On the other hand it wouldn't be hard to put the crc32 code into
> > crypto/.
> 
> No, CRC is not a crypto. It is used by other subsystems like file systems that
> has nothing to do with crypto. Compare with the internet checksum, I think you
> will have a hard time moving it to crypto.

Yes, crc32* are not crypto hashes; crc32c is merely using the framework.  I'm
not inclined to tear it out of there unless the crypto maintainers tell me to
move it, which seems unlikely since Herbert made the move in the first place
for reasons I noted in my other reply.

> > > - Slice by 8 is just half the speed on my ppc32 compared to slice by 4 so
> > >   it can't be enabled for all archs. Best to start with all 64 bit archs
> >
> > <shrug> I suppose I could make CRC32C_BITS configurable.  What is the hardware
> > profile of your ppc32 processor?  How much L1D/L2 cache?  slice-by-8 does have
> > a big cache footprint.  On the other hand it's faster than the slice-by-4
> > (crc32) and Sarwate (crc32c) code in the kernel, even on old slow 32-bit x86
> > processors (PII, PIII, P4).
> 
> It is a low end embedded 333 MHz CPU with only L1 cache. How much faster
> is slice by 8 than slice by 4 on these old x86 machines?

How much L1 cache?  Or, if you'd rather not give away specifics, has the CPU
more than 8KB L1 cache?  I'm willing to concede that with little cache the
added memory pressure could be painful.

As for the old x86 machines, please have a look at:
http://djwong.org/docs/ext4_metadata_checksums.html#Benchmarking

~15% faster on a 2GHz Via C7
~20% faster on a 2.7GHz P4
~25% faster on a 500MHz P3

I vaguely recall it was ~20% faster on a 400MHz P2, but all the kernel.org
wikis are still down. :(

So I suspect the key factor here is memory hierachy, since all of those systems
have at least 16K of L1 cache.  Slice by 8 might actually suck on a Pentium
Proor earlier.  Unfortunately I don't have anything older than a PII...

> Bobs last version tested for 64/32 bits arch and selected slice by 8/slice by 4 based
> on that.
> 
> >
> > > - Last time I tested Bobs slice by 8 on ppc32 it didn't work.
> >
> > ... is crc32c broken *now*?  It seems fine on x86/amd64/ppc64.
> 
> Don't know, I haven't tested it. Don't have much time ATM and I don't
> want to test something I don't agree with.

It seems fine on a ppc64 running in 32bit mode too.  I'll go find an old ppc32
and see how it fares.  I think it's a G3 500MHz.

--D
