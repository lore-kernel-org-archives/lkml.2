Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757342Ab2HOUhb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 16:37:31 -0400
Received: from mga09.intel.com ([134.134.136.24]:17275 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756242Ab2HOUhZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 16:37:25 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.77,774,1336374000"; 
   d="scan'208";a="186891343"
Message-ID: <502C0883.2030904@linux.intel.com>
Date: Wed, 15 Aug 2012 13:37:23 -0700
From: "H. Peter Anvin" <hpa@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: Matt Mackall <mpm@selenic.com>
CC: "Ted Ts'o" <tytso@mit.edu>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        greg@kroah.com, w@1wt.eu, ewust@umich.edu, zakir@umich.edu,
        nadiah@cs.ucsd.edu, jhalderm@umich.edu, tglx@linutronix.de,
        davem@davemloft.net, mingo@kernel.org, hpa@zytor.com,
        DJ Johnston <dj.johnston@intel.com>, stable@vger.kernel.org
Subject: Re: [PATCH RFC] random: Account for entropy loss due to overwrites
References: <1344878779-10700-1-git-send-email-hpa@linux.intel.com> <1345059051.32116.32.camel@calx>
In-Reply-To: <1345059051.32116.32.camel@calx>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/15/2012 12:30 PM, Matt Mackall wrote:
> On Mon, 2012-08-13 at 10:26 -0700, H. Peter Anvin wrote:
>> From: "H. Peter Anvin" <hpa@linux.intel.com>
>>
>> When we write entropy into a non-empty pool, we currently don't
>> account at all for the fact that we will probabilistically overwrite
>> some of the entropy in that pool.
> 
> Technically, no, nothing is overwritten. The key fact is that the mixing
> function is -reversible-. Thus, even if you mix in known data, you can't
> learn anything about the state and thus can't destroy any of the
> existing entropy.
> 
> But you are correct, mixing new actual entropy is not purely additive
> (with saturation). For that to happen, we'd need an input mixing
> function with perfect maximal cascading. Instead we effectively cascade
> across somewhere between 6 and 64 bits. So the truth lies somewhere
> between linear and your exponential estimate (which would be the case
> for mixing a single bit into the pool with XOR), but much closer to
> linear due to combinatoric expansion.
> 

I think you have it backwards; if the input was a FIFO, with no mixing
at all, and no reuse, the linear estimate would be correct.  The mixing
into an already-existent and potentially-observed pool is what causes
the exponential estimate to apply... although it is assuming perfect
mixing.  However, I believe it is still correct in the aggregate.

> On the other hand, I don't think this sort of thing matters at all.
> There is so much more fundamentally wrong with even trying to do entropy
> accounting in the first place that these sorts of details don't even
> matter. Instead we should stop fooling ourselves and just drop the
> pretense of accounting entirely. Now that we've got a much richer set of
> inputs, I think the time is ripe... but of course, I'm no longer the
> maintainer.

If we're going to fundamentally change the structure perhaps we should
actually take the suggestions long offered from the cryptographic
community, and look at structures like Fortuna.

	-hpa
