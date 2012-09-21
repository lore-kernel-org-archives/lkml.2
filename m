Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753546Ab2IUMXw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 08:23:52 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:17087 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751767Ab2IUMXv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 08:23:51 -0400
X-IronPort-AV: E=Sophos;i="4.80,462,1344211200"; 
   d="scan'208";a="208913861"
Message-ID: <505C5C54.4060100@citrix.com>
Date: Fri, 21 Sep 2012 13:23:48 +0100
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20120428 Iceowl/1.0b1 Icedove/3.0.11
MIME-Version: 1.0
To: Jan Beulich <JBeulich@suse.com>
CC: David Vrabel <david.vrabel@citrix.com>,
        Oliver Chick <oliver.chick@citrix.com>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xen.org" <xen-devel@lists.xen.org>
Subject: Re: [Xen-devel] [PATCH] Persistent grant maps for xen blk drivers
References: <1348051887-21885-1-git-send-email-oliver.chick@citrix.com>	<505AF126.2050806@citrix.com>	<1348140637.24539.32.camel@oliverchick-Precision-WorkStation-T3400> <505B1EB9020000780009CA6E@nat28.tlf.novell.com>
In-Reply-To: <505B1EB9020000780009CA6E@nat28.tlf.novell.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20/09/12 12:48, Jan Beulich wrote:
>>>> On 20.09.12 at 13:30, Oliver Chick <oliver.chick@citrix.com> wrote:
>> The memory overhead, and fallback mode points are related:
>> -Firstly, it turns out that the overhead is actually 2.75MB, not 11MB
>> per device. I made a mistake (pointed out by Jan) as the maximum number
>> of requests that can fit into a single-page ring is 64, not 256.
>> -Clearly, this still scales linearly. So the problem of memory footprint
>> will occur with more VMs, or block devices.
>> -Whilst 2.75MB per device is probably acceptable (?), if we start using
>> multipage rings, then we might not want to have
>> BLKIF_MAX_PERS_REQUESTS_PER_DEVICE==__RING_SIZE, as this will cause the
>> memory overhead to increase. This is why I have implemented the
>> 'fallback' mode. With a multipage ring, it seems reasonable to want the
>> first $x$ grefs seen by blkback to be treated as persistent, and any
>> later ones to be non-persistent. Does that seem sensible?
> 
>>From a resource usage pov, perhaps. But this will get the guest
> entirely unpredictable performance. Plus I don't think 11Mb of
> _virtual_ space is unacceptable overhead in a 64-bit kernel. If
> you really want/need this in a 32-bit one, then perhaps some
> other alternatives would be needed (and persistent grants may
> not be the right approach there in the first place).

It's not just virtual space.  blkback in pvops kernels allocates its
pages from the balloon and if there aren't enough ballooned out pages it
has to allocate real pages (releasing the MFN back to Xen).

Classic kernels didn't need to do this as there was an API for allocate
new "empty" struct page's that get mapped into kernel space.

David
