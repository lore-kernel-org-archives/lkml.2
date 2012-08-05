Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754630Ab2HEPKu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Aug 2012 11:10:50 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:39478 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754531Ab2HEPKt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Aug 2012 11:10:49 -0400
Message-ID: <501E8CEA.9050601@ti.com>
Date: Sun, 5 Aug 2012 11:10:34 -0400
From: Cyril Chemparathy <cyril@ti.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:14.0) Gecko/20120713 Thunderbird/14.0
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <arnd@arndb.de>, <catalin.marinas@arm.com>, <nico@linaro.org>,
        <will.deacon@arm.com>
Subject: Re: [PATCH 00/22] Introducing the TI Keystone platform
References: <1343775898-28345-1-git-send-email-cyril@ti.com> <20120804083945.GB6802@n2100.arm.linux.org.uk>
In-Reply-To: <20120804083945.GB6802@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Russell,

On 8/4/2012 4:39 AM, Russell King - ARM Linux wrote:
> On Tue, Jul 31, 2012 at 07:04:36PM -0400, Cyril Chemparathy wrote:
>> This series is a follow on to the RFC series posted earlier (archived at [1]).
>> The major change introduced here is the modification to the kernel patching
>> mechanism for phys_to_virt/virt_to_phys, in order to support LPAE platforms
>> that require late patching.  In addition to these changes, we've updated the
>> series based on feedback from the earlier posting.
>>
>> Most of the patches in this series are fixes and extensions to LPAE support on
>> ARM. The last three patches in this series are specific to the TI Keystone
>> platform, and are being provided here for the sake of completeness.  These
>> three patches are dependent on the smpops patch set (see [2]), and are not
>> ready to be merged in as yet.
>
> Can you explain why you want the kernel loaded above the 4GB watermark?
> This seems silly to me, as the kernel needs to run at points with a 1:1
> physical to virtual mapping, and you can't do that if the kernel is
> stored in physical memory above the 4GB watermark.
>

The Keystone family of devices is built to run with large (>8G) physical 
memory for certain use-cases.  From the CPUs perspective, this entire 
range of physical memory is mapped in linearly at 08:0000:0000, i.e., 
above the 4GB watermark.

The interconnect provides an aliased view of the first 2GB of this 
memory at the 8000:0000 offset.  This alias is intended primarily for 
boot-time usage, and does not support DMA coherence.  We considered the 
option of running with the first 2G of memory located under the 4GB 
watermark, and the rest located at the native >4GB location, but this 
would necessitate sparsemem, and would also break DMA coherence out of 
lowmem.  Hence the need for the more complicated approach implemented in 
this patch series.


The posted patch series manages to get an SMP system running out of 
memory beyond the 4GB watermark.  We identified a couple of places that 
needed the 1:1 physical to virtual mapping, and for these we take 
advantage of the alias view provided by the interconnect.  The two 
places that we found the need for 1:1 mapping were:

1. initial boot code in head.S:  here we've taken the approach of 
initially running out of the alias space, and then switching over to the 
high address space once we are safely in machine-specific territory.

2. idmap for secondary CPU boot:  here we've added a virt_to_idmap() 
facility that our sub-architecture then overrides to express the 
interconnect supported alias view.


We are well aware of the fact that we are barely scratching the surface 
of the problem space here, and we'd be very thankful for a heads up on 
issues that we may have missed so far.  We would similarly appreciate 
other better ideas to solve this problem in light of the unique 
constraints imposed here.

-- 
Thanks
- Cyril
