Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753755Ab1CPTp5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 15:45:57 -0400
Received: from science.horizon.com ([71.41.210.146]:48388 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753698Ab1CPTpn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 15:45:43 -0400
Date: 16 Mar 2011 15:45:42 -0400
Message-ID: <20110316194542.22530.qmail@science.horizon.com>
From: "George Spelvin" <linux@horizon.com>
To: hughd@google.com, linux@horizon.com
Subject: Re: [PATCH 1/8] drivers/random: Cache align ip_random better
Cc: herbert@gondor.hengli.com.au, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, mpm@selenic.com, penberg@cs.helsinki.fi
In-Reply-To: <alpine.LSU.2.00.1103161123360.14076@sister.anvils>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> 1) A smart compiler could note the alignment and issue wider copy
>>    instructions.  (Especially on alignment-required architectures.)

> Right, that part of it would benefit from stronger alignment,
> but does not generally need cacheline alignment.

Agreed.  The only reason the structure is cacheline aligned is to keep
it all in a single cache line, and swapping the order of the elements
made the buffer more aligned without hurting the counter.

>> 2) The cacheline fetch would get more data faster.  The data would
>>    be transferred in the first 6 beats of the load from RAM (assuming a
>>    64-bit data bus) rather than waiting for 7, so you'd finish the copy
>>    1 ns sooner or so.  Similar 1-cycle win on a 128-bit Ln->L(n-1) cache
>>    transfer.

> That argument worries me.  I don't know enough to say whether you are
> correct or not.  But if you are correct, then it worries me that your
> patch will be the first of a trickle growing to a stream to an avalanche
> of patches where people align and reorder structures so that the most
> commonly accessed fields are at the beginnng of the cacheline, so that
> those can then be accessed minutely faster.
> 
> Aargh, and now I am setting off the avalanche with that remark.
> Please, someone, save us by discrediting George's argument.

It was mostly #1 and #3.  The *important* thing is to minimize the number
of cache lines touched by common operations, which has already been the
subject of a lot of kernel patches.

Remember, most hardware does have critical-word-first loads.  So alignment
to the width of the data bus is enough.  "Keep it naturally aligned" is
all that's necessary, and most kernel data structures already obey that.

I was just extending it, because I wanted to make it *possible* to use
wider loads.

>> As I said, "infinitesimal".  The main reason that I bothered to
>> generate a patch was that it appealed to my sense of neatness to
>> keep the 3x16-byte buffer 16-byte aligned.

> Ah, now you come clean!  Yes, it does feel neater to me too;
> but I doubt that would be sufficient justification by itself.

It took both factors to make it worth it to me.  The real reason was:
1) Neater
2) Definitely not slower
3) Maybe a tiny bit faster
Conclusion: do it.

Sorry to alarm you.
