Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753606Ab2ALN4j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jan 2012 08:56:39 -0500
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:43587 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753516Ab2ALN4h convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jan 2012 08:56:37 -0500
MIME-Version: 1.0
In-Reply-To: <1326351173.2741.3.camel@edumazet-laptop>
References: <20120105212719.3965.40406.stgit@bhelgaas.mtv.corp.google.com> <1326351173.2741.3.camel@edumazet-laptop>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Thu, 12 Jan 2012 06:56:15 -0700
Message-ID: <CAErSpo4C13Q_S6RiycmEf642Ogv0TCVZSw3XfrWE2E=zzT=8ig@mail.gmail.com>
Subject: Re: [PATCH 1/2] x86, amd: factor out MMCONFIG discovery
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Borislav Petkov <borislav.petkov@amd.com>,
        linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>, Len Brown <lenb@kernel.org>,
        Jesse Barnes <jbarnes@virtuousgeek.org>
X-System-Of-Record: true
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 11, 2012 at 11:52 PM, Eric Dumazet <eric.dumazet@gmail.com> wrote:
> Le jeudi 05 janvier 2012 à 14:27 -0700, Bjorn Helgaas a écrit :
>> This factors out the AMD native MMCONFIG discovery so we can use it
>> outside amd_bus.c.
>>
>> amd_bus.c reads AMD MSRs so it can remove the MMCONFIG area from the
>> PCI resources.  We may also need the MMCONFIG information to work
>> around BIOS defects in the ACPI MCFG table.
>>
>> Cc: Borislav Petkov <borislav.petkov@amd.com>
>> Cc: Yinghai Lu <yinghai@kernel.org>
>> Cc: stable@kernel.org       # 2.6.34+
>> Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
>> ---
>>  arch/x86/include/asm/amd_nb.h |    2 ++
>>  arch/x86/kernel/amd_nb.c      |   31 ++++++++++++++++++++++++++++++
>>  arch/x86/pci/amd_bus.c        |   42 +++++++++++------------------------------
>>  3 files changed, 44 insertions(+), 31 deletions(-)
>
>>  /**
>> @@ -85,6 +57,9 @@ static int __init early_fill_mp_bus_info(void)
>>       u64 val;
>>       u32 address;
>>       bool found;
>> +     struct resource fam10h_mmconf_res, *fam10h_mmconf;
>> +     u64 fam10h_mmconf_start;
>> +     u64 fam10h_mmconf_end;
>>
>>       if (!early_pci_allowed())
>>               return -1;
>> @@ -211,12 +186,17 @@ static int __init early_fill_mp_bus_info(void)
>>               subtract_range(range, RANGE_NUM, 0, end);
>>
>>       /* get mmconfig */
>> -     get_pci_mmcfg_amd_fam10h_range();
>> +     fam10h_mmconf = amd_get_mmconfig_range(&fam10h_mmconf_res);
>>       /* need to take out mmconf range */
>
> This adds following link error if "# CONFIG_CPU_SUP_AMD is not set"
>
>  LD      .tmp_vmlinux1
> arch/x86/pci/built-in.o: In function `early_fill_mp_bus_info':
> /opt/src/linux/arch/x86/pci/amd_bus.c:189: undefined reference to
> `amd_get_mmconfig_range'
> make: *** [.tmp_vmlinux1] Error 1

I posted a fix for this, but looks like it hasn't been merged yet:
http://marc.info/?l=linux-pci&m=132614917932150&w=2

I'll resend it.

Bjorn
