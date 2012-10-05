Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754308Ab2JETfL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 15:35:11 -0400
Received: from mga11.intel.com ([192.55.52.93]:40733 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751636Ab2JETfG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 15:35:06 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,541,1344236400"; 
   d="scan'208";a="230497875"
Message-ID: <506F3670.4020202@intel.com>
Date: Fri, 05 Oct 2012 12:35:12 -0700
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
References: <20121004002113.5016.66913.stgit@gitlad.jf.intel.com> <m28vbkx3hw.fsf@firstfloor.org>
In-Reply-To: <m28vbkx3hw.fsf@firstfloor.org>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/05/2012 09:55 AM, Andi Kleen wrote:
> Alexander Duyck <alexander.h.duyck@intel.com> writes:
>
>> While working on 10Gb/s routing performance I found a significant amount of
>> time was being spent in the swiotlb DMA handler.  Further digging found that a
>> significant amount of this was due to the fact that virtual to physical
>> address translation and calling the function that did it.  It accounted for
>> nearly 60% of the total overhead.
> Can you find out why that is? Traditionally virt_to_phys was just a
> subtraction. Then later on it was a if and a subtraction.
>
> It cannot really be that expensive. Do you have some debugging enabled?
>
> Really virt_to_phys should be fixed. Such fundamental operations
> shouldn't slow. I don't think hacking up all the users to work
> around this is the r ight way.
>
> Looking at the code a bit someone (crazy) made it out of line.
> But that cannot explain that much overhead.
>
>
> -Andi
>

I was thinking the issue was all of the calls to relatively small
functions occurring in quick succession.  The way most of this code is
setup it seems like it is one small function call in turn calling
another, and then another, and I would imagine the code fragmentation
can have a significant negative impact.

For example just the first patch in the series is enough to see a
significant performance gain and that is simply due to the fact that
is_swiotlb_buffer becomes inlined when I built it on my system.  The
basic idea I had with these patches was to avoid making multiple calls
in quick succession and instead just to have all the data right there so
that all of the swiotlb functions don't need to make many external
calls, at least not until they are actually dealing with bounce buffers
which are slower due to locking anyway.

Thanks,

Alex
