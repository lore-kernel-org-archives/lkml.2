Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761246Ab2FDXxL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 19:53:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39738 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753223Ab2FDXxK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 19:53:10 -0400
Message-ID: <4FCD4A5B.2050604@redhat.com>
Date: Mon, 04 Jun 2012 19:52:59 -0400
From: Don Dutile <ddutile@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.23) Gecko/20110927 Red Hat/3.1.15-1.el6_1 Thunderbird/3.1.15
MIME-Version: 1.0
To: David Woodhouse <dwmw2@infradead.org>
CC: iommu@lists.linux-foundation.org, mingo@elte.hu,
        linux-kernel@vger.kernel.org, chrisw@redhat.com,
        suresh.b.siddha@intel.com
Subject: Re: [PATCH 2/2] iommu: dmar -- reserve mmio space used by IOMMU
References: <1338845342-12464-1-git-send-email-ddutile@redhat.com>		 <1338845342-12464-3-git-send-email-ddutile@redhat.com>	 <1338849430.10884.288.camel@shinybook.infradead.org>	 <4FCD401D.9000304@redhat.com> <1338852196.26785.10.camel@shinybook.infradead.org>
In-Reply-To: <1338852196.26785.10.camel@shinybook.infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/04/2012 07:23 PM, David Woodhouse wrote:
> On Mon, 2012-06-04 at 19:09 -0400, Don Dutile wrote:
>>> If the BIOS *doesn't* do that, then I believe this should be
>>> WARN_TAINT_ONCE(…TAINT_FIRMWARE_WORKAROUND…) like other BIOS problems
>>> that we have discovered.
>>>
>> well, one could argue it may be easier to claim the space reserved in
>> the OS then making yet another hole in the available IO address space
>> in the ACPI tables.
>
> But how? It's got to work with operating systems that predate the IOMMU.
> The registers *have* to be in a marked hole. If *not*, then we should
> give a clear "YOUR BIOS IS BROKEN" output like all the similar
> breakages, and do our best to work around it.
>
> Working around it is fine; I'm not suggesting that we should WARN()
> *instead* of working around it.
>
ok.

>> How does the kernel probe for chipsets, then registers with the chipsets
>> to find the programmed IOMMU BAR values?
>> -- I missed that class.... I only have Intel Virt Tech Directed I/O
>> Architecture spec., and the beginning of IOMMU is based on DMAR tables...
>> If you have more info/guidance, I'd appreciate it.
>
> Hm, I thought we'd already started doing some of that in order to
> sanity-check the DMAR tables. The VTBAR registers are in PCI config
> space. The quirk_ioat_snb_local_iommu() check is already looking at
> them...
>
except that quirk is conditionally compiled in intel-iommu.c;
to do the check indep of INTEL-IOMMU CONFIG tag, it'd have to move into
pci/quirks.c. ... and how does it get triggered? ... a dmar table check?
(typical quirks kicked based on vid/did...)

> I'm not quite sure which document they are documented in. Doing it based
> on the DMAR table, as you have, is certainly a good start. But do it
> with a bigger shouty WARN(TAINT_FIRMWARE_WORKAROUND), and do it when the
> IOMMU code isn't compiled in.
>
The 'do it for intel-iommu systems only' and not be CONFIG dependent
is a bit challenging given how the code is compiled, and the expected/normal
code flow starting from a dmar table.
of course, if the IOMMU just exposed itself as the first device on a PCI
bus, this would be trivial!
-- I really hate BIOS dependencies to get things right!

>> Seems like the patch would be easier to support, although it doesn't
>> solve the problem you mentioned above, unless the reservation code isn't
>> compiled out by INTEL-IOMMU (but something more general like !(x86&&  PCI)).
>> the firmware taint message would be informative as to the quality of
>> the firmware, but my experience is nothing changes unless it's critical
>> to a system shipping.
>
>>    The BIOS's are getting better, but I've seen turtles run faster... ;-) .
>
> Thankfully, there are now some modern Intel systems on which you can run
> Coreboot. This should be a huge benefit — you should be able to build an
> up-to-date Tianocore and deploy it as your Coreboot payload, rather than
> having to put up with the crap that's on the system when you receive it.
>
>
except, most system (hw, os, applic) certifications are based on vendor's
shipped BIOS, so Coreboot isn't a guarantee either.  Additionally, telling
a customer to replace their paid-for-BIOS for a build-your-own-coreboot bios
is a tough way to close a bz. ;-)
