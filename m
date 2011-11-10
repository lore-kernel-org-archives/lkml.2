Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935739Ab1KJRSO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Nov 2011 12:18:14 -0500
Received: from blv-smtpout-01.boeing.com ([130.76.32.69]:43667 "EHLO
	blv-smtpout-01.boeing.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934243Ab1KJRSN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Nov 2011 12:18:13 -0500
From: "Moffett, Kyle D" <Kyle.D.Moffett@boeing.com>
To: Kumar Gala <galak@kernel.crashing.org>
CC: "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Timur Tabi <B04825@freescale.com>,
        Scott Wood <scottwood@freescale.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Date: Thu, 10 Nov 2011 10:17:52 -0600
Subject: Re: [RFC PATCH 00/17] powerpc/e500: separate e500 from e500mc
Thread-Topic: [RFC PATCH 00/17] powerpc/e500: separate e500 from e500mc
Thread-Index: AcyfxEwLMaf7S7leSAyeV86AjbE+PQ==
Message-ID: <C0DED343-76A8-457E-BF54-E52DFCAC83A8@boeing.com>
References: <4E42AB6F.1050900@freescale.com>
 <1320883399-15911-1-git-send-email-Kyle.D.Moffett@boeing.com>
 <FF2BF3F3-1158-4747-AEEC-03D6A7C462D9@kernel.crashing.org>
In-Reply-To: <FF2BF3F3-1158-4747-AEEC-03D6A7C462D9@kernel.crashing.org>
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

On Nov 10, 2011, at 08:59, Kumar Gala wrote:
> On Nov 9, 2011, at 6:03 PM, Kyle Moffett wrote:
>> I saw Baruch Siach's patch:
>> powerpc: 85xx: separate e500 from e500mc
>> 
>> Unfortunately, that patch breaks the dependencies for the P5020DS
>> platform and does not fix the underlying code which does not
>> understand what the ambiguous "CONFIG_E500" means.
>> 
>> In order to fix the issue at the fundamental level, I created the
>> following 17-patch series loosely based on Baruch's patch.
>> 
>> === High-Level Summary ===
>> 
>> The e500v1/v2 and e500mc/e5500 CPU families are not compatible with
>> each other, yet they share the same "CONFIG_E500" Kconfig option.
>> 
>> The following patch series splits the 32-bit CPU support into two
>> separate options: "CONFIG_FSL_E500_V1_V2" and "CONFIG_FSL_E500MC".
>> Additionally, the 64-bit e5500 support is separated to its own config
>> option ("CONFIG_FSL_E5500") which is automatically combined with
>> either 32-bit e500MC or 64-bit Book-3E when the P5020DS board support
>> is enabled.
> 
> So its clear from the community that there is confusion here and we
> need to clean this up.  I guess my attempt to support an kernel that
> ran on both E500v2 and E500mc isn't worth it.  However I don't want to
> completely remove the ability to do this.

Well, a kernel built with CONFIG_PPC_E500MC today appears to be
fundamentally broken on E500v1/E500v2:

#if defined(CONFIG_8xx) || defined(CONFIG_403GCX)
#define L1_CACHE_SHIFT		4
#define MAX_COPY_PREFETCH	1
#elif defined(CONFIG_PPC_E500MC)
#define L1_CACHE_SHIFT		6
#define MAX_COPY_PREFETCH	4
#elif defined(CONFIG_PPC32)
#define MAX_COPY_PREFETCH	4
#if defined(CONFIG_PPC_47x)
#define L1_CACHE_SHIFT		7
#else
#define L1_CACHE_SHIFT		5
#endif
#else /* CONFIG_PPC64 */
#define L1_CACHE_SHIFT		7
#endif

E500MC will set L1_CACHE_SHIFT to 6, while regular E500 appears to
want it set to 5.  I don't know if that's a mistake or exactly what
code that affects, but it looks very wrong.

Furthermore, it looks like there are a couple issues here I missed
before.  PPC64 systems all appear to have an L1_CACHE_SHIFT of 7,
except when you turn on the P5020DS board option which magically
changes it to "6" and breaks lord-knows-what.  I think my patch
series actually "breaks" that and makes e5500 use 7 as well.

Are you sure that a kernel built to support E5500 can also run on
other 64-bit PowerPC/POWER systems?


> Towards the cleanup I'd ask for a proposal on what exactly the
> CONFIG_ options we'd end up with would be and their meaning.
> So today we have:
> 
> CONFIG_E500
> CONFIG_PPC_E500MC

It's actually a bit more complicated than that.  There are 3 ways
that the user can configure an e500 kernel today.  I'm omitting
the "FSL_SOC_BOOKE" menu that wraps around all of the 85xx/e5500
boards today, because that is set for all of these platforms:

  * PPC32 + PPC_85xx + E500 [+ boards]
  * PPC64 + BOOK3E_64 + P5020_DS (which adds E500 and PPC_E500MC)

Note that whether or not "PPC_E500MC" is set on PPC32 depends
only on which boards the user picked.  So if I am trying to
build an e500v2 kernel and I accidentally also turn on support
for one of the e500mc boards, my kernel mysteriously breaks.


> What do we want to move to?  I want to keep the builds such that we
> have only 2 classes:  e500V1/V2 and e500mc/e5500/e6500/.../eX500.
> I see no reason to hyper-optimize e500mc vs e5500 vs e6500.

So after my changes, there are the following user-configurable
option sets:
  * PPC32 + FSL_E500_V1_V2 [+ e500v1/v2 boards]
  * PPC32 + FSL_E500MC     [+ e500mc boards]
  * PPC64 + BOOK3E_64 + P5020_DS (which adds FSL_E5500)

Since most of the "e500mc"-specific code was in 32-bit-only ASM
or inside of #ifdef PPC32, the new FSL_E500MC option is only
set on 32-bit builds, even if it is running in compat mode on
64-bit e5500 hardware)

Internally the P5020_DS option turns on the hidden FSL_E5500
option for both 32-bit and 64-bit; that config option enables
platform drivers and similar stuff.

Depending on how compatible the AMP processors are, you could
rename the option to be "FSL_E5X00" or add a hidden option for
"FSL_E6500" that is also selected by appropriate boards.

Please let me know if you think!

Cheers,
Kyle Moffett

--
Curious about my work on the Debian powerpcspe port?
I'm keeping a blog here: http://pureperl.blogspot.com/
