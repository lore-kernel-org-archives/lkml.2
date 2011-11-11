Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756933Ab1KKAi4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Nov 2011 19:38:56 -0500
Received: from blv-smtpout-01.boeing.com ([130.76.32.69]:47050 "EHLO
	blv-smtpout-01.boeing.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752640Ab1KKAiy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Nov 2011 19:38:54 -0500
From: "Moffett, Kyle D" <Kyle.D.Moffett@boeing.com>
To: "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>
CC: Kumar Gala <galak@kernel.crashing.org>,
        Scott Wood <scottwood@freescale.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Timur Tabi <B04825@freescale.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Date: Thu, 10 Nov 2011 18:38:32 -0600
Subject: Re: [RFC PATCH 00/17] powerpc/e500: separate e500 from e500mc
Thread-Topic: [RFC PATCH 00/17] powerpc/e500: separate e500 from e500mc
Thread-Index: AcygCj1LoQpKFQCkTRavIEOsEn/how==
Message-ID: <15AB1C61-181F-4454-AF99-772B73DE0AA5@boeing.com>
References: <4E42AB6F.1050900@freescale.com>
 <1320883399-15911-1-git-send-email-Kyle.D.Moffett@boeing.com>
 <FF2BF3F3-1158-4747-AEEC-03D6A7C462D9@kernel.crashing.org>
 <C0DED343-76A8-457E-BF54-E52DFCAC83A8@boeing.com>
 <58FDDDA5-26C4-493B-A00D-81DD94A5C26A@kernel.crashing.org>
 <20111110165455.GE11983@schlenkerla.am.freescale.net>
In-Reply-To: <20111110165455.GE11983@schlenkerla.am.freescale.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Nov 10, 2011, at 11:54, Scott Wood wrote:
> On Thu, Nov 10, 2011 at 10:30:41AM -0600, Kumar Gala wrote:
>> On Nov 10, 2011, at 10:17 AM, Moffett, Kyle D wrote:
>>> Furthermore, it looks like there are a couple issues here I missed
>>> before.  PPC64 systems all appear to have an L1_CACHE_SHIFT of 7,
>>> except when you turn on the P5020DS board option which magically
>>> changes it to "6" and breaks lord-knows-what.  I think my patch
>>> series actually "breaks" that and makes e5500 use 7 as well.
>> 
>> a value of '6' on E5500 / P5020DS is correct and doesn't break anything.
>> Setting it to 7 is wrong and thus the code is correct today.
>> 
>>> Are you sure that a kernel built to support E5500 can also run on
>>> other 64-bit PowerPC/POWER systems?
>> 
>> No it will not.  There is not expectation of that as E5500 is an
>> embedded / Book-E class part and uses that ISA version.  Book-S
>> (server) 64-bit machines are not OS compatible and we are not trying to
>> make them as such (but we do re-use a lot of code).
> 
> What about other 64-bit book3e chips?  What cache block size does A2 have?

Ok, so I've been poking around this code a bunch and as far as I can
tell, the cacheline stuff has basically always been subtly wrong in
twelve different ways and it's only largely coincidence that it works
today.

So PowerPC64 systems have their own "ppc64_caches" structure set up
before start_kernel() is called by parsing the OpenFirmware "cpu" nodes.
That structure is then checked in every piece of 64-bit kernel code
(except xmon) that uses the "dcbXX" and "icbXX" opcodes.

There is an entirely separate mechanism built into the "cputable" that
is used on all PowerPC systems to compute cacheline sizes to pass in via
ELF headers for userspace to use in memset()/memcpy(), etc.

Furthermore, the VDSO gets cacheline sizes stored into it, but on 64-bit
they come from the ppc64_caches structure and on 32-bit they come from
dcache_bsize/icache_bsize copied from the cputable.

Then there's the value in arch/powerpc/include/asm/cache.h which is used
throughout the kernel to figure out how far apart to space CPU-specific
datastructures (EG: __cacheline_aligned_on_smp).

Despite the fact that all PPC64 have an "L1_CACHE_SIZE" value of 128,
the PowerPC A2 and e5500 have {d,i}cache_bsize values of 64 in cputable
and presumably also get correct values from OpenFirmware, so the bogus
constant in asm/cache.h does nothing more than waste a bit of memory
for unnecessary padding.

Unfortunately, lots of PPC32 assembly pretends that the value found in
asm/cache.h is a hard truth and uses it for "dcbz", etc, which is why
there are all of those ugly #ifdefs in asm/cache.h

Based on all of that, my proposal is going to be a patch which does the
following:

  (1) Conditionally set L1_CACHE_SHIFT to the maximum value used by any
      platform being compiled in for alignment purposes.

  (2) Make the ppc64_caches struct apply to ppc32 as well, and
      preinitialize it with a minimum value used by any platform being
      compiled in (for "dcbXX"/"icbXX" purposes).  This is safe because
      the pagesize is always a multiple of the cache block size and the
      kernel only uses dcbXX/icbXX on whole pages.  The only impact is a
      temporary small performance hit from flushing or zeroing the same
      block 8 times if too small.

  (3) Try to initialize the ppc_caches struct on ppc32 from the
      OpenFirmware device-tree.  If that fails, then use the values we
      find in the cputable.  After this is initialized any performance
      hit in copy_page()/zero_page() will obviously disappear.

  (4) Fix all of the PPC32 assembly code that is misusing L1_CACHE_SHIFT
      to use the ppc_caches struct instead.

Does that sound like a reasonable approach?

Cheers,
Kyle Moffett

--
Curious about my work on the Debian powerpcspe port?
I'm keeping a blog here: http://pureperl.blogspot.com/
