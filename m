Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422709Ab2JDPyF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 11:54:05 -0400
Received: from mga11.intel.com ([192.55.52.93]:51923 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750827Ab2JDPyE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 11:54:04 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,535,1344236400"; 
   d="scan'208";a="230549421"
Message-ID: <506DB121.3020700@intel.com>
Date: Thu, 04 Oct 2012 08:54:09 -0700
From: Alexander Duyck <alexander.h.duyck@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad@kernel.org>
CC: konrad.wilk@oracle.com, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, rob@landley.net, akpm@linux-foundation.org,
        joerg.roedel@amd.com, bhelgaas@google.com, shuahkhan@gmail.com,
        linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        x86@kernel.org
Subject: Re: [RFC PATCH 1/7] swiotlb: Instead of tracking the end of the swiotlb
 region just calculate it
References: <20121004002113.5016.66913.stgit@gitlad.jf.intel.com> <20121004003847.5016.50978.stgit@gitlad.jf.intel.com> <20121004130107.GB9158@phenom.dumpdata.com>
In-Reply-To: <20121004130107.GB9158@phenom.dumpdata.com>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/04/2012 06:01 AM, Konrad Rzeszutek Wilk wrote:
> On Wed, Oct 03, 2012 at 05:38:47PM -0700, Alexander Duyck wrote:
>> In the case of swiotlb we already have the start of the region and the number
>> of slabs that give us the region size.  Instead of having to call
>> virt_to_phys on two pointers we can just take advantage of the fact that the
>> region is linear and just compute the end based on the start plus the size.
> Why not take advantage of 'the fact that the region is linear' and just
> pre-compute the end in swiotlb_init_with_tbl?
>
> That way the logic in is_swiotlb_buffer is even simpler?
>

Using a pre-computed end point based on a virtual address is more
expensive in the x86_64 case.  The calls to __phys_addr require a
separate function call.  By just using the physical address of the start
and adding the offset I can avoid the second call and the compiler will
take advantage of the smaller function size.  The result is that
is_swiotlb_buffer will be inlined.

Thanks,

Alex
