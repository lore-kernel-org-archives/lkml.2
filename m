Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754047Ab1HZARa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 20:17:30 -0400
Received: from smtp-out.google.com ([74.125.121.67]:44698 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753314Ab1HZAR3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 20:17:29 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:in-reply-to:references:from:date:
	message-id:subject:to:cc:content-type:
	content-transfer-encoding:x-system-of-record;
	b=IS2W9gwJVTUggkD6cfJqgmBD+Xl52UFFVk4wY3FKinKZkyp89taiSTB/M/KE9wEJM
	8oLPLYPge/Y/c03Do8dig==
MIME-Version: 1.0
In-Reply-To: <1314315225.16133.30.camel@sbsiddha-desk.sc.intel.com>
References: <20110825230539.5355.13851.stgit@bhelgaas.mtv.corp.google.com> <1314315225.16133.30.camel@sbsiddha-desk.sc.intel.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Thu, 25 Aug 2011 18:17:06 -0600
Message-ID: <CAErSpo7N3UBJgQTb+zePnsf5YuFSQT8zy9CftwceyAKKfcHUjA@mail.gmail.com>
Subject: Re: [PATCH 1/2] x86, ioapic: Reserve only 128 bytes for IOAPICs
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ralf Jung <ralfjung-e@gmx.de>,
        Cyrill Gorcunov <gorcunov@openvz.org>, Yinghai Lu <yinghai@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 25, 2011 at 5:33 PM, Suresh Siddha
<suresh.b.siddha@intel.com> wrote:
> On Thu, 2011-08-25 at 16:05 -0700, Bjorn Helgaas wrote:
>> Previously we reserved 1024 bytes, but that's more space than the IOAPIC
>> consumes, and it can cause conflicts with nearby devices.  The known
>> requirement is 68 bytes (sizeof(struct io_apic)), and rounding up to a
>> power-of-2 gives us 128.
>>
>
> Bjorn, Given the info from Intel that most of its io-apic
> implementations has registers up to 0xff offset (reserved), does
> reserving just the 128 bytes for the io-apic cause any address conflicts
> if the next 128 bytes are allocated (by the OS) for any other device.

If the OS allocated the next 128 bytes to another device, it sounds
like it would cause a conflict on Intel boxes.  This must be an area
that differs between vendors.  I haven't seen a spec that mentions 256
bytes as the required minimum MMIO size for IOAPICs, and apparently
the AMD IOAPIC decodes 240 bytes or fewer.

> Or OS doesn't allocate this range to any other device and its only the
> bios which allocates the addresses in this range and OS just ensures
> that there are no conflicts?

This patch only changes the region marked "busy" by the IOAPIC code.
This is analogous to a driver using request_mem_region() to show what
it's using.

That's different from the information about the range decoded by a
device, e.g,. what we learn from PCI BARs or ACPI _CRS.  We always
need this kind of information so we can avoid handing out that space
to another device, even if the driver isn't loaded or we aren't using
the IOAPICs, e.g., booting with "noapic".

This patch doesn't change the "range decoding" information, so I think
we're fairly safe.  I'm not sure we're completely safe because some
machines have PNP0C01 devices that cover the IOAPIC area, some have
E820 "reserved" areas, and some have both, and we currently ignore
PNP0C01 resources that conflict with E820 ones.

But I think we'd only see a problem if a machine had neither PNP0C01
nor E820 descriptions of that space (in that case, "noapic" is already
broken), if we had an E820 description that only covered *part* of an
IOAPIC (seems unlikely to me), or if we had no E820 but had a PNP0C01
that covered part of it.

Bjorn
