Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755377Ab0DZVo4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Apr 2010 17:44:56 -0400
Received: from mga07.intel.com ([143.182.124.22]:10923 "EHLO
	azsmga101.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755360Ab0DZVoz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Apr 2010 17:44:55 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.52,275,1270450800"; 
   d="scan'208";a="270302101"
Date: Mon, 26 Apr 2010 14:44:53 -0700
From: jacob pan <jacob.jun.pan@linux.intel.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: "Jesse Barnes" <jbarnes@virtuousgeek.org>,
       "Bjorn Helgaas" <bjorn.helgaas@hp.com>,
       "Andy Isaacson" <adi@hexapodia.org>,
       "R. Andrew Bailey" <bailey@akamai.com>,
       "Yinghai" <yinghai.lu@oracle.com>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "Ingo Molnar" <mingo@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86/PCI: never allocate PCI MMIO resources below 
 BIOS_END
Message-ID: <20100426144453.00004e7e@unknown>
In-Reply-To: <a65d005c2c7607d4d6dd6e280fdc6d66.squirrel@www.zytor.com>
References: <4BC4E55B.7000103@oracle.com>
	<20100426183436.GV11130@hexapodia.org>
	<20100426123135.5d095d2f@virtuousgeek.org>
	<201004261427.57229.bjorn.helgaas@hp.com>
	<20100426133757.3e1d0a75@virtuousgeek.org>
	<a65d005c2c7607d4d6dd6e280fdc6d66.squirrel@www.zytor.com>
Organization: Intel OTC
X-Mailer: Claws Mail 3.7.4cvs1 (GTK+ 2.16.0; i586-pc-mingw32msvc)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin Mon, 26 Apr 2010 14:12:35 -0700
>> On Mon, 26 Apr 2010 14:27:56 -0600
>> Bjorn Helgaas <bjorn.helgaas@hp.com> wrote:
>>> I'm a little concerned that those patches are a sledgehammer approach.
>>> Previously, IORESOURCE_BUSY has basically been used for mutual exclusion
>>> between drivers that would otherwise claim the same resource.  It hasn't
>>> been used to guide resource assignment in the PCI/PNP/etc core.  Maybe
>>> it's a good idea to also use IORESOURCE_BUSY there, but I'm not sure.
>>> Right now it feels like undesirable overloading to me.
>>
>> I guess that's true, removing those regions from the pool entirely
>> might be better?  Or some other, clear way of expressing that the
>> regions aren't available to drivers.  Maybe we need a new IO resource
>> type for platform ranges.
>>
>>> I think it also leads to at least one problem: Guenter's machine has no
>>> VGA but has a PCI device that lives at 0xa0000.  The driver for that
>>> device won't be able to request that region if the arch code has marked
>>> it busy.
>>
>> Ah good point, so we'll want another approach at any rate.  Yinghai?
>
>What we need is to keep track of the areas available for address space
>allocation by dynamically addressed devices, as distinct from address
>space that is in use by a kernel-known device.  There is an in-between,
>which one can call "here there be dragons" space, which should never be
>used for dynamic device allocation, but if a platform device or
>pre-assigned device uses that space then it should be allowed to be
>allocated.
>
>In the case of x86, anything that is E820_RESERVED, *or* in the legacy
>region (below 1 MB) and is not RAM, is "here there be dragons" space.
>
>    -hpa
>
Moorestown has a similar situation where one of the PCI devices have a BAR
below 1MB. Moorestown also has the option not to have VGA.
