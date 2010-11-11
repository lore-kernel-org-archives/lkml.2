Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756697Ab0KKUcB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 15:32:01 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:19666 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753034Ab0KKUcA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 15:32:00 -0500
Message-ID: <4CDC3BCD.700@kernel.org>
Date: Thu, 11 Nov 2010 10:54:05 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101026 SUSE/3.0.10 Thunderbird/3.0.10
MIME-Version: 1.0
To: Jan Beulich <JBeulich@novell.com>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -v2 2/2] x86/pci: Add mmconf range into e820 for	 when
 it is from MSR with amd faml0h
References: <4CDB3E85.9010604@kernel.org> <4CDB3EBB.4010800@kernel.org> <4CDBBC7E0200007800021A2D@vpn.id2.novell.com>
In-Reply-To: <4CDBBC7E0200007800021A2D@vpn.id2.novell.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/11/2010 12:50 AM, Jan Beulich wrote:
>>>> On 11.11.10 at 01:54, Yinghai Lu <yinghai@kernel.org> wrote:
>> @@ -191,10 +208,12 @@ void __cpuinit fam10h_check_enable_mmcfg
>>  		/* only trust the one handle 256 buses, if acpi=off */
>>  		if (!acpi_pci_disabled || busnbits >= 8) {
>>  			u64 base;
>> -			base = val & (0xffffULL << 32);
>> +			base = val & (FAM10H_MMIO_CONF_BASE_MASK <<
>> +					FAM10H_MMIO_CONF_BASE_SHIFT);
>>  			if (fam10h_pci_mmconf_base_status <= 0) {
>>  				fam10h_pci_mmconf_base = base;
>>  				fam10h_pci_mmconf_base_status = 1;
>> +				e820_add_mmconf_range(busnbits);
>>  				return;
>>  			} else if (fam10h_pci_mmconf_base ==  base)
>>  				return;
> 
> I don't think adding the range in this case is correct: Here, we
> found that the BIOS enabled the feature, and we're doing
> nothing to "correct" it, so we also should expect the range
> to be reserved by the BIOS.

this function is protected by PCI_CHECK_ENABLE_AMD_MMCONF

void __cpuinit fam10h_check_enable_mmcfg(void)
{
        u64 val;
        u32 address;

        if (!(pci_probe & PCI_CHECK_ENABLE_AMD_MMCONF))
                return;

and could have systems that setting in hw config is right, but BIOS doesn't put
them with e820 reserved entries.

Thanks

	Yinghai
