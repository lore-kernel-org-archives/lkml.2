Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756785Ab1I3QMq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Sep 2011 12:12:46 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:39803 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753986Ab1I3QMo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Sep 2011 12:12:44 -0400
Date: Fri, 30 Sep 2011 09:12:23 -0700
From: "Darrick J. Wong" <djwong@us.ibm.com>
To: Joakim Tjernlund <joakim.tjernlund@transmode.se>
Cc: linux-crypto <linux-crypto@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3] crc32c: Implement CRC32c with slicing-by-8 algorithm
Message-ID: <20110930161223.GW11984@tux1.beaverton.ibm.com>
Reply-To: djwong@us.ibm.com
References: <OF1BEE9025.31A1BE17-ONC125791B.00203167-C125791B.00211B4A@transmode.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <OF1BEE9025.31A1BE17-ONC125791B.00203167-C125791B.00211B4A@transmode.se>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[putting mailing lists on cc]

On Fri, Sep 30, 2011 at 08:01:36AM +0200, Joakim Tjernlund wrote:
> 
> (Just happen to see this patch in the archives)
> 
> - This is basically an copy of Bobs crc32 work and duplicates code, this
>   code needs to move into /lib/crc32.c and use the existing framework.

Which framework are you talking about?  lib/crc32.c appears to be a simple
module that exports a utility function.  Do you mean that you want to merge the
crc32{,c}defs.h and gen_crc32{,c}table.c code?  Do you want a build script that
starts with only a crc${ALG}_defs.h file and stamps out gencrc${ALG}_table.c
and crc${ALG}.c boilerplate code and then builds it?

I really don't know; from my perspective there was a slow implementation in
crypto/crc32c.c and I wanted to speed it up.  crc32c seems to be in crypto/ and
not lib/ so that the implementation can be replaced with a hardware accelerated
version at runtime (crc32c-intel).

For crc32 which has no such hw replacement (as far as I know), moving it into
crypto/ would incur the overhead of going through the cryptoapi for not much
benefit.  On the other hand it wouldn't be hard to put the crc32 code into
crypto/.
> 
> - Slice by 8 is just half the speed on my ppc32 compared to slice by 4 so
>   it can't be enabled for all archs. Best to start with all 64 bit archs

<shrug> I suppose I could make CRC32C_BITS configurable.  What is the hardware
profile of your ppc32 processor?  How much L1D/L2 cache?  slice-by-8 does have
a big cache footprint.  On the other hand it's faster than the slice-by-4
(crc32) and Sarwate (crc32c) code in the kernel, even on old slow 32-bit x86
processors (PII, PIII, P4).

> - Last time I tested Bobs slice by 8 on ppc32 it didn't work.

... is crc32c broken *now*?  It seems fine on x86/amd64/ppc64.

--D
