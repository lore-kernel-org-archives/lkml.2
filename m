Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751777Ab2JHPnP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2012 11:43:15 -0400
Received: from mga01.intel.com ([192.55.52.88]:6317 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750857Ab2JHPnM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2012 11:43:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,554,1344236400"; 
   d="scan'208";a="231288453"
Message-ID: <5072F497.2000703@intel.com>
Date: Mon, 08 Oct 2012 08:43:19 -0700
From: Alexander Duyck <alexander.h.duyck@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: konrad.wilk@oracle.com, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, rob@landley.net, akpm@linux-foundation.org,
        joerg.roedel@amd.com, bhelgaas@google.com, shuahkhan@gmail.com,
        linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        x86@kernel.org, torvalds@linux-foundation.org
Subject: Re: [RFC PATCH 0/7] Improve swiotlb performance by using physical
 addresses
References: <20121004002113.5016.66913.stgit@gitlad.jf.intel.com> <m28vbkx3hw.fsf@firstfloor.org> <506F3670.4020202@intel.com> <20121005200245.GQ16230@one.firstfloor.org> <506F6BF2.8030500@intel.com> <20121006175751.GS16230@one.firstfloor.org>
In-Reply-To: <20121006175751.GS16230@one.firstfloor.org>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/06/2012 10:57 AM, Andi Kleen wrote:
>> Inlining everything did speed things up a bit, but I still didn't reach
>> the same speed I achieved using the patch set.  However I did notice the
>> resulting swiotlb code was considerably larger.
> Thanks. So your patch makes sense, but imho should pursue the inlining
> in parallel for other call sites.

I'll try to take a look at getting that done this morning.

>> assembly, is replaced with 8 lines of assembly and becomes inline.  In
>> addition we drop the number of calls to __phys_addr from 9 to 2 by
>> dropping them all from swiotlb.  By my math I am probably saving about
>> 120 instructions per packet.  I suspect all of that would probably be
>> cutting the number of instructions per packet enough to probably account
>> for a 5% difference when you consider I am running at about 1.5Mpps per
>> core on a 2.7Ghz processor.
> Maybe it's just me, but that's somehow sad for one if() and a subtraction

Well there is also all of the setup of the call on the function stack. 
By my count just the portion that is used in the standard case is about
9 lines of assembly.  By inlining it and dropping the if case we can
probably drop it to 1.

> BTW __pa used to be a simple subtraction, the if () was just added to
> handle the few call sites for x86-64 that do __pa(&text_symbol).
> Maybe we should just go back to the old __pa_symbol() for those cases,
> then __pa could be the simple subtraction it used to was again
> and it could be inlined and everyone would be happy.
>
> -Andi

What I am probably looking at doing is splitting the function in two as
you suggest where we have a separate function for the text symbol case. 
I will probably also take the 32 bit approach and add a debug version
that is still a separate function for uses such as determining if we
have any callers who should be using __pa_symbol instead of __pa.

Thanks,

Alex
