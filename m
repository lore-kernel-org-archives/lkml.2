Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753250Ab1HQM3F (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Aug 2011 08:29:05 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:50387 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752126Ab1HQM3B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Aug 2011 08:29:01 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: [PATCH 7/9] ARM: DMA: steal memory for DMA coherent mappings
Date: Wed, 17 Aug 2011 14:28:44 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.35-22-generic; KDE/4.3.2; x86_64; ; )
Cc: "'Russell King - ARM Linux'" <linux@arm.linux.org.uk>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-media@vger.kernel.org, linux-mm@kvack.org,
        linaro-mm-sig@lists.linaro.org,
        "'Michal Nazarewicz'" <mina86@mina86.com>,
        "'Kyungmin Park'" <kyungmin.park@samsung.com>,
        "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'KAMEZAWA Hiroyuki'" <kamezawa.hiroyu@jp.fujitsu.com>,
        "'Ankita Garg'" <ankita@in.ibm.com>,
        "'Daniel Walker'" <dwalker@codeaurora.org>,
        "'Mel Gorman'" <mel@csn.ul.ie>,
        "'Jesse Barker'" <jesse.barker@linaro.org>,
        "'Jonathan Corbet'" <corbet@lwn.net>,
        "'Shariq Hasnain'" <shariq.hasnain@linaro.org>,
        "'Chunsang Jeong'" <chunsang.jeong@linaro.org>
References: <1313146711-1767-1-git-send-email-m.szyprowski@samsung.com> <201108161626.26130.arnd@arndb.de> <006b01cc5cb3$dac09fa0$9041dee0$%szyprowski@samsung.com>
In-Reply-To: <006b01cc5cb3$dac09fa0$9041dee0$%szyprowski@samsung.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201108171428.44555.arnd@arndb.de>
X-Provags-ID: V02:K0:yDiqniX3bc1/OoEt7axWRS0vzGXxxu2F1q1jkPFwtlO
 Ncpmv8rKXDenqyGqBqMwhOnK4ZlfJeMyfPn0XWqs21EWjwun37
 xcSuxEhOMLN4w55qZoQrSlAu0ptF71Y0VHJaWnYylVyCV/kKCw
 f6P6wYGEAKQFJl2gOkl44do5GuPKZQojh2PpAeYlDmz2M6ICo0
 J7h3MIlwsCLxkzHIr8Bkg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 17 August 2011, Marek Szyprowski wrote:
> Do we really need the dynamic pool for the first version? I would like to
> know how much memory can be allocated in GFP_ATOMIC context. What are the
> typical sizes of such allocations?

I think this highly depends on the board and on the use case. We know
that 2 MB is usually enough, because that is the current CONSISTENT_DMA_SIZE
on most platforms. Most likely something a lot smaller will be ok
in practice. CONSISTENT_DMA_SIZE is currently used for both atomic
and non-atomic allocations.

> Maybe for the first version a static pool with reasonably small size
> (like 128KiB) will be more than enough? This size can be even board
> depended or changed with kernel command line for systems that really
> needs more memory.

For a first version that sounds good enough. Maybe we could use a fraction
of the CONSISTENT_DMA_SIZE as an estimate?

For the long-term solution, I see two options:

1. make the preallocated pool rather small so we normally don't need it.
2. make it large enough so we can also fulfill most nonatomic allocations
   from that pool to avoid the TLB flushes and going through the CMA
   code. Only use the real CMA region when the pool allocation fails.

In either case, there should be some method for balancing the pool
size.

> I noticed one more problem. The size of the CMA managed area must be
> the multiple of 16MiBs (MAX_ORDER+1). This means that the smallest CMA area
> is 16MiB. These values comes from the internals of the kernel memory 
> management design and page blocks are the only entities that can be managed
> with page migration code.
> 
> I'm not sure if all ARMv6+ boards have at least 32MiB of memory be able to
> create a CMA area.

My guess is that you can assume to have 64 MB or more on ARMv6 running Linux,
but other people may have more accurate data.

Also, there is the option of setting a lower value for FORCE_MAX_ZONEORDER
for some platforms if it becomes a problem.

	Arnd
