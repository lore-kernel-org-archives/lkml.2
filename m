Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755983Ab0IPTfv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 15:35:51 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:28280 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752517Ab0IPTfu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 15:35:50 -0400
Message-ID: <4C92710D.3040401@kernel.org>
Date: Thu, 16 Sep 2010 12:33:33 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11) Gecko/20100714 SUSE/3.0.6 Thunderbird/3.0.6
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Bjorn Helgaas <bjorn.helgaas@hp.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Brian Bloniarz <phunge0@hotmail.com>,
        Charles Butterfield <charles.butterfield@nextcentury.com>,
        Denys Vlasenko <dvlasenk@redhat.com>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, Stefan Becker <chemobejk@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 3/3] PCI: allocate bus resources from the top down
References: <20100915210818.12365.58732.stgit@bob.kio> <201009151644.38563.bjorn.helgaas@hp.com> <4C915AB2.9090203@zytor.com> <201009161104.15665.bjorn.helgaas@hp.com> <4C925768.7040707@zytor.com>
In-Reply-To: <4C925768.7040707@zytor.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/16/2010 10:44 AM, H. Peter Anvin wrote:
> On 09/16/2010 10:04 AM, Bjorn Helgaas wrote:
>> It does seem like we should do *something* with E820 reserved areas, but
>> I'm not 100% convinced we should be more strict than Windows.  If we
>> pay attention to things Windows doesn't test, I think we're likely to
>> trip over even more BIOS bugs.
> 
> Windows have a couple of advantages on us.  They have WHQL; every
> machine needs to pass WHQL or it doesn't get sold.  The other advantage
> is that most manufacturers of Windows desktops don't give a damn about
> anything other than the shipping configuration (Windows version and
> hardware): I have seen machines which fail to boot if you put in a PCI
> UART card.
> 
>> Linux does avoid putting PCI devices in E820 reserved areas ... in
>> some cases.  In this Dell case, the reserved area conflicts with a
>> host bridge window, so we expand the reserved area and insert it as
>> the *parent* of the window.  Since it's the parent, it has no effect
>> on allocations from the window, so we end up putting devices in the
>> reserved area.
> 
> OK, so that's a problem.  This isn't really a hideously uncommon use
> case for a reserved region, either: it probably reflects a device used
> by SMM under that particular host bridge.
> 
>> I think the problem is that E820 reservations fundamentally don't
>> fit well with the Linux resource manager.  We manage resources as
>> a strict hierarchy of non-overlapping regions, but there's no
>> requirement that E820 reservations have any relationship with actual
>> devices that we discover via ACPI, PCI, etc.
>>
>> We've been kludging around this with a collection of hacks like
>> reserve_region_with_split() and insert_resource_expand_to_fit(),
>> but I think we're just making an unmaintainable mess.  We should
>> take a step back and think about how to do this cleanly.
> 
> Perhaps we should consider reserved regions a separate hierarchy, or we
> should deal with them at the time a new resource is created?

Those Dell machine BIOS set wrong value in the pci bridge. and it is partial
overlapped with reserved range in e820.

Kernel current will honor that HW setting from pci bridge reading at first.

so the best way should be: using e820 reserved range to trim reading from pci or acpi in some cases.

Yinghai



