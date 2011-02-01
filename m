Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755422Ab1BAROm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 12:14:42 -0500
Received: from terminus.zytor.com ([198.137.202.10]:37670 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751949Ab1BAROl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 12:14:41 -0500
X-User-Agent: K-9 Mail for Android
References: <1296513876-31415-1-git-send-email-konrad.wilk@oracle.com> <1296513876-31415-7-git-send-email-konrad.wilk@oracle.com> <1296572896.13091.240.camel@zakaz.uk.xensource.com>
In-Reply-To: <1296572896.13091.240.camel@zakaz.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 06/11] xen/setup: Skip over 1st gap after System RAM.
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Tue, 01 Feb 2011 09:14:22 -0800
To: Ian Campbell <Ian.Campbell@eu.citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Xen-devel@lists.xensource.com" <Xen-devel@lists.xensource.com>,
        "konrad@kernel.org" <konrad@kernel.org>,
        "jeremy@goop.org" <jeremy@goop.org>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>
Message-ID: <5e6ddb2e-fd31-4552-a986-2bf4e68a3f0c@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Not merely possible, it's fairly common.

"Ian Campbell" <Ian.Campbell@eu.citrix.com> wrote:

>On Mon, 2011-01-31 at 22:44 +0000, Konrad Rzeszutek Wilk wrote:
>> If the kernel is booted with dom0_mem=max:512MB and the
>> machine has more than 512MB of RAM, the E820 we get is:
>> 
>> Xen: 0000000000100000 - 0000000020000000 (usable)
>> Xen: 00000000b7ee0000 - 00000000b7ee3000 (ACPI NVS)
>> 
>> while in actuality it is:
>> 
>> (XEN)  0000000000100000 - 00000000b7ee0000 (usable)
>> (XEN)  00000000b7ee0000 - 00000000b7ee3000 (ACPI NVS)
>> 
>> Based on that, we would determine that the "gap" between
>> 0x20000 -> 0xb7ee0 is not System RAM and try to assign it to
>> 1-1 mapping. This meant that later on when we setup the page tables
>> we would try to assign those regions to DOMID_IO and the
>> Xen hypervisor would fail such operation. This patch
>> guards against that and sets the "gap" to be after the first
>> non-RAM E820 region.
>
>This seems dodgy to me and makes assumptions about the sanity of the
>BIOS provided e820 maps. e.g. it's not impossible that there are
>systems
>out there with 2 or more little holes under 1M etc.
>
>The truncation (from 0xb7ee0000 to 0x20000000 in this case) happens in
>the dom0 kernel not the hypervisor right? So we can at least know that
>we've done it.
>
>Can we do the identity setup before that truncation happens? If not can
>can we not remember the untruncated map too and refer to it as
>necessary. One way of doing that might be to insert an e820 region
>covering the truncated region to identify it as such (perhaps
>E820_UNUSABLE?) or maybe integrating e.g. with the memblock
>reservations
>(or whatever the early enough allocator is).
>
>The scheme we have is that all pre-ballooned memory goes at the end of
>the e820 right, as opposed to allowing it to first fill truncated
>regions such as this? 
>
>Ian.
>
>> 
>> Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
>> ---
>>  arch/x86/xen/setup.c |   20 ++++++++++++++++++--
>>  1 files changed, 18 insertions(+), 2 deletions(-)
>> 
>> diff --git a/arch/x86/xen/setup.c b/arch/x86/xen/setup.c
>> index c2a5b5f..5b2ae49 100644
>> --- a/arch/x86/xen/setup.c
>> +++ b/arch/x86/xen/setup.c
>> @@ -147,6 +147,7 @@ static unsigned long __init
>xen_set_identity(const struct e820map *e820)
>>  {
>>  	phys_addr_t last = xen_initial_domain() ? 0 : ISA_END_ADDRESS;
>>  	phys_addr_t start_pci = last;
>> +	phys_addr_t ram_end = last;
>>  	int i;
>>  	unsigned long identity = 0;
>>  
>> @@ -168,11 +169,26 @@ static unsigned long __init
>xen_set_identity(const struct e820map *e820)
>>  			if (start > start_pci)
>>  				identity += set_phys_range_identity(
>>  					PFN_UP(start_pci), PFN_DOWN(start));
>> -			start_pci = end;
>>  			/* Without saving 'last' we would gooble RAM too. */
>> -			last = end;
>> +			start_pci = last = ram_end = end;
>>  			continue;
>>  		}
>> +		/* Gap found right after the 1st RAM region. Skip over it.
>> +		 * Why? That is b/c if we pass in dom0_mem=max:512MB and
>> +		 * have in reality 1GB, the E820 is clipped at 512MB.
>> +		 * In xen_set_pte_init we end up calling xen_set_domain_pte
>> +		 * which asks Xen hypervisor to alter the ownership of the MFN
>> +		 * to DOMID_IO. We would try to set that on PFNs from 512MB
>> +		 * up to the next System RAM region (likely from 0x20000->
>> +		 * 0x100000). But changing the ownership on "real" RAM regions
>> +		 * will infuriate Xen hypervisor and we will fail (WARN).
>> +		 * So instead of trying to set IDENTITY mapping on the gap
>> +		 * between the System RAM and the first non-RAM E820 region
>> +		 * we start at the non-RAM E820 region.*/
>> +		if (ram_end && start >= ram_end) {
>> +			start_pci = start;
>> +			ram_end = 0;
>> +		}
>>  		start_pci = min(start, start_pci);
>>  		last = end;
>>  	}

-- 
Sent from my mobile phone.  Please pardon any lack of formatting.
