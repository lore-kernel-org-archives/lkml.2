Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752380Ab1AGHkG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 02:40:06 -0500
Received: from vpn.id2.novell.com ([195.33.99.129]:34766 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751328Ab1AGHkF convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-JBeulich@novell.com:5:1>);
	Fri, 7 Jan 2011 02:40:05 -0500
Message-Id: <4D26D160020000780002AEBE@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Fri, 07 Jan 2011 07:40:00 +0000
From: "Jan Beulich" <JBeulich@novell.com>
To: "Robert Richter" <robert.richter@amd.com>
Cc: "Andreas Herrmann3" <Andreas.Herrmann3@amd.com>,
        "Joerg Roedel" <Joerg.Roedel@amd.com>, "mingo@elte.hu" <mingo@elte.hu>,
        "JeremyFitzhardinge" <jeremy@goop.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "hpa@zytor.com" <hpa@zytor.com>
Subject: Re: [PATCH] x86: use PCI method for enabling AMD extended
	 config  space before MSR method
References: <4D26028F020000780002AC8A@vpn.id2.novell.com>
 <20110106172004.GM4739@erda.amd.com>
In-Reply-To: <20110106172004.GM4739@erda.amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 06.01.11 at 18:20, Robert Richter <robert.richter@amd.com> wrote:
> On 06.01.11 11:57:35, Jan Beulich wrote:
>> +#ifdef CONFIG_AMD_NB
>> +	/* Try the PCI method first. */
>> +	if (early_pci_allowed()) {
>> +		unsigned int i, n;
>> +
>> +		for (n = i = 0; !n && amd_bus_dev_ranges[i].dev_limit; ++i) {
>> +			u8 bus = amd_bus_dev_ranges[i].bus;
>> +			u8 slot = amd_bus_dev_ranges[i].dev_base;
>> +			u8 limit = amd_bus_dev_ranges[i].dev_limit;
>> +
>> +			for (; slot < limit; ++slot) {
>> +				u32 val = read_pci_config(bus, slot, 3, 0);
>> +
>> +				if (!early_is_k8_nb(val))
>> +					continue;
>> +
>> +				val = read_pci_config(bus, slot, 3, 0x8c);
>> +				if (!(val & (ENABLE_CF8_EXT_CFG >> 32))) {
>> +					val |= ENABLE_CF8_EXT_CFG >> 32;
>> +					write_pci_config(bus, slot, 3, 0x8c,
>> +							 val);
>> +				}
>> +				++n;
>> +			}
>> +		}
>> +		pr_info("Extended Config Space enabled on %u nodes\n", n);
> 
> Isn't i the number of nodes?

No, "i" is the number of PCI devices looked at (but only those that
pass early_is_k8_nb() are of interest).

Jan

