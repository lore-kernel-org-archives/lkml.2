Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754835Ab0DZVNz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Apr 2010 17:13:55 -0400
Received: from terminus.zytor.com ([198.137.202.10]:58921 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754302Ab0DZVNy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Apr 2010 17:13:54 -0400
Message-ID: <a65d005c2c7607d4d6dd6e280fdc6d66.squirrel@www.zytor.com>
In-Reply-To: <20100426133757.3e1d0a75@virtuousgeek.org>
References: <4BC4E55B.7000103@oracle.com>
    <20100426183436.GV11130@hexapodia.org>
    <20100426123135.5d095d2f@virtuousgeek.org>
    <201004261427.57229.bjorn.helgaas@hp.com>
    <20100426133757.3e1d0a75@virtuousgeek.org>
Date: Mon, 26 Apr 2010 14:12:35 -0700
Subject: Re: [PATCH] x86/PCI: never allocate PCI MMIO resources below 
 BIOS_END
From: "H. Peter Anvin" <hpa@zytor.com>
To: "Jesse Barnes" <jbarnes@virtuousgeek.org>
Cc: "Bjorn Helgaas" <bjorn.helgaas@hp.com>,
       "Andy Isaacson" <adi@hexapodia.org>,
       "R. Andrew Bailey" <bailey@akamai.com>,
       "Yinghai" <yinghai.lu@oracle.com>, "H. Peter Anvin" <hpa@zytor.com>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "Ingo Molnar" <mingo@redhat.com>, guenter.roeck@ericsson.com,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       "x86@kernel.org" <x86@kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Thomas Renninger" <trenn@suse.de>, yaneti@declera.com
User-Agent: SquirrelMail/1.4.20-1.fc11
MIME-Version: 1.0
Content-Type: text/plain;charset=utf-8
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.2 (terminus.zytor.com [127.0.0.1]); Mon, 26 Apr 2010 14:12:41 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Mon, 26 Apr 2010 14:27:56 -0600
> Bjorn Helgaas <bjorn.helgaas@hp.com> wrote:
>> I'm a little concerned that those patches are a sledgehammer approach.
>> Previously, IORESOURCE_BUSY has basically been used for mutual exclusion
>> between drivers that would otherwise claim the same resource.  It hasn't
>> been used to guide resource assignment in the PCI/PNP/etc core.  Maybe
>> it's a good idea to also use IORESOURCE_BUSY there, but I'm not sure.
>> Right now it feels like undesirable overloading to me.
>
> I guess that's true, removing those regions from the pool entirely
> might be better?  Or some other, clear way of expressing that the
> regions aren't available to drivers.  Maybe we need a new IO resource
> type for platform ranges.
>
>> I think it also leads to at least one problem: Guenter's machine has no
>> VGA but has a PCI device that lives at 0xa0000.  The driver for that
>> device won't be able to request that region if the arch code has marked
>> it busy.
>
> Ah good point, so we'll want another approach at any rate.  Yinghai?

What we need is to keep track of the areas available for address space
allocation by dynamically addressed devices, as distinct from address
space that is in use by a kernel-known device.  There is an in-between,
which one can call "here there be dragons" space, which should never be
used for dynamic device allocation, but if a platform device or
pre-assigned device uses that space then it should be allowed to be
allocated.

In the case of x86, anything that is E820_RESERVED, *or* in the legacy
region (below 1 MB) and is not RAM, is "here there be dragons" space.

    -hpa

