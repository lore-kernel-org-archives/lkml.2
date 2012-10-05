Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754943Ab2JEXX0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 19:23:26 -0400
Received: from mga02.intel.com ([134.134.136.20]:49589 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753665Ab2JEXXX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 19:23:23 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,541,1344236400"; 
   d="scan'208";a="221337891"
Message-ID: <506F6BF2.8030500@intel.com>
Date: Fri, 05 Oct 2012 16:23:30 -0700
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
References: <20121004002113.5016.66913.stgit@gitlad.jf.intel.com> <m28vbkx3hw.fsf@firstfloor.org> <506F3670.4020202@intel.com> <20121005200245.GQ16230@one.firstfloor.org>
In-Reply-To: <20121005200245.GQ16230@one.firstfloor.org>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/05/2012 01:02 PM, Andi Kleen wrote:
>> I was thinking the issue was all of the calls to relatively small
>> functions occurring in quick succession.  The way most of this code is
>> setup it seems like it is one small function call in turn calling
>> another, and then another, and I would imagine the code fragmentation
>> can have a significant negative impact.
> Maybe. Can you just inline everything and see if it it's faster then?
>
> This was out of line when the "text cost at all costs" drive was still
> envogue, but luckily we're not doing  that anymore.
>
> -Andiu
>

Inlining everything did speed things up a bit, but I still didn't reach
the same speed I achieved using the patch set.  However I did notice the
resulting swiotlb code was considerably larger.

I did a bit more digging and the issue may actually be simple repetition
of the calls.  By my math it would seem we would end up calling
is_swiotlb_buffer 3 times per packet in the routing test case, once in
sync_for_cpu and once for sync_for_device in the Rx cleanup path, and
once in unmap_page in the Tx cleanup path.  Each call to
is_swiotlb_buffer will result in 2 calls to __phys_addr.  In freeing the
skb we end up doing a call to virt_to_head_page which will call
__phys_addr.  In addition we end up mapping the skb using map_single so
we end up using __phys_addr to do a virt_to_page translation in the
xmit_frame_ring path, and then call __phys_addr when we check
dma_mapping_error.  So in total that ends up being 3 calls to
is_swiotlb_buffer, and 9 calls to __phys_addr per packet routed.

With the patches the is_swiotlb_buffer function, which was 25 lines of
assembly, is replaced with 8 lines of assembly and becomes inline.  In
addition we drop the number of calls to __phys_addr from 9 to 2 by
dropping them all from swiotlb.  By my math I am probably saving about
120 instructions per packet.  I suspect all of that would probably be
cutting the number of instructions per packet enough to probably account
for a 5% difference when you consider I am running at about 1.5Mpps per
core on a 2.7Ghz processor.

Thanks,

Alex
