Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753391Ab0K2Swd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 13:52:33 -0500
Received: from terminus.zytor.com ([198.137.202.10]:60726 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751544Ab0K2Swc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 13:52:32 -0500
Message-ID: <4CF3F62F.2000508@zytor.com>
Date: Mon, 29 Nov 2010 10:51:27 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101027 Fedora/3.1.6-1.fc13 Thunderbird/3.1.6
MIME-Version: 1.0
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
CC: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, Matthew Garrett <mjg@redhat.com>
Subject: Re: [PATCH] x86/PCI: never allocate PCI space from the last 1M below
 4G
References: <20101129183009.11256.33739.stgit@bob.kio> <201011291334.52909.bjorn.helgaas@hp.com>
In-Reply-To: <201011291334.52909.bjorn.helgaas@hp.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/29/2010 12:34 PM, Bjorn Helgaas wrote:
> On Monday, November 29, 2010 11:30:09 am Bjorn Helgaas wrote:
>>
>> The last 1M before 4G contains the processor restart vector and usually
>> the system ROM.  We don't know the actual ROM size; I chose 1M because
>> that's how much Windows 7 appears to avoid.
>>
>> Without this check, we can allocate PCI space that will never work.  On
>> Matthew's HP 2530p, we put the Intel GTT "Flush Page" at the very last
>> page, which causes a spontaneous power-off:
>>
>>   pci_root PNP0A08:00: host bridge window [mem 0xfee01000-0xffffffff]
>>   fffff000-ffffffff : Intel Flush Page (assigned by intel-gtt)
>>
>> Reference: https://bugzilla.kernel.org/show_bug.cgi?id=23542
>> Reported-by: Matthew Garrett <mjg@redhat.com>
>> Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
>> ---
>>
>>  arch/x86/include/asm/e820.h |    3 +++
>>  arch/x86/pci/i386.c         |   10 +++++++++-
>>  2 files changed, 12 insertions(+), 1 deletions(-)
>>
>>
>> diff --git a/arch/x86/include/asm/e820.h b/arch/x86/include/asm/e820.h
>> index 5be1542..c1e908f 100644
>> --- a/arch/x86/include/asm/e820.h
>> +++ b/arch/x86/include/asm/e820.h
>> @@ -72,6 +72,9 @@ struct e820map {
>>  #define BIOS_BEGIN		0x000a0000
>>  #define BIOS_END		0x00100000
>>  
>> +#define BIOS_ROM_BASE		0xfff00000
>> +#define BIOS_ROM_END		0x100000000ULL
> 
> I'm really not thrilled about hard-coding these addresses, so I'd
> love it if somebody could suggest a way to discover them from the
> BIOS.
> 
> The E820 map doesn't reserve the last page:
> 
>   BIOS-e820: 00000000fed1c000 - 00000000fed20000 (reserved)
>   BIOS-e820: 00000000fffa0000 - 00000000fffa7000 (reserved)
> 
> and I don't think there's any ACPI device that does either.
> 

It is certainly reasonable to block off the last chunk of the 32-bit
address space.  Some systems double-decode it to avoid issues with
A20M#, so I would argue that we should avoid at least 2 MiB.

As far as discovering them from the BIOS, there is a way to do it --
E820.  This is a fallback for the case where the BIOS has plain and
simply failed to provide it, and so a heuristic is probably the best we
can do.  Probing is extremely unsafe.

	-hpa
