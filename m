Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932270Ab0F3VcY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 17:32:24 -0400
Received: from terminus.zytor.com ([198.137.202.10]:46034 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932087Ab0F3VcW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jun 2010 17:32:22 -0400
Message-ID: <4C2BB7C0.9040000@zytor.com>
Date: Wed, 30 Jun 2010 14:31:44 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100621 Fedora/3.0.5-1.fc13 Thunderbird/3.0.5
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: mingo@redhat.com, linux-kernel@vger.kernel.org, djwong@us.ibm.com,
       muli@il.ibm.com, cschultz@linux.vnet.ibm.com, stable@kernel.org,
       tglx@linutronix.de, mingo@elte.hu, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/urgent] x86, Calgary: Increase max PHB number
References: <20100624212647.GI15515@tux1.beaverton.ibm.com>	<tip-499a00e92dd9a75395081f595e681629eb1eebad@git.kernel.org> <20100629155151.7caaff4b.akpm@linux-foundation.org>
In-Reply-To: <20100629155151.7caaff4b.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/29/2010 03:51 PM, Andrew Morton wrote:
> On Fri, 25 Jun 2010 15:29:50 GMT
> "tip-bot for Darrick J. Wong" <djwong@us.ibm.com> wrote:
> 
>> Commit-ID:  499a00e92dd9a75395081f595e681629eb1eebad
>> Gitweb:     http://git.kernel.org/tip/499a00e92dd9a75395081f595e681629eb1eebad
>> Author:     Darrick J. Wong <djwong@us.ibm.com>
>> AuthorDate: Thu, 24 Jun 2010 14:26:47 -0700
>> Committer:  Ingo Molnar <mingo@elte.hu>
>> CommitDate: Fri, 25 Jun 2010 16:14:58 +0200
>>
>> x86, Calgary: Increase max PHB number
> 
> arch/x86/kernel/pci-calgary_64.c: In function 'calgary_init_one':
> arch/x86/kernel/pci-calgary_64.c:1059: warning: comparison is always false due to limited range of data type
> 
> from
> 
>         BUG_ON(dev->bus->number >= MAX_PHB_BUS_NUM);
> 
> with
> 
> http://userweb.kernel.org/~akpm/stuff/config-akpm2.txt

This comes from:

/*
 * The maximum PHB bus number.
 * x3950M2 (rare): 8 chassis, 48 PHBs per chassis = 384
 * x3950M2: 4 chassis, 48 PHBs per chassis        = 192
 * x3950 (PCIE): 8 chassis, 32 PHBs per chassis   = 256
 * x3950 (PCIX): 8 chassis, 16 PHBs per chassis   = 128
 */
#define MAX_PHB_BUS_NUM		384

Clearly there can't be 384 busses with standard PCI numbering (bus
numbers are 8 bits).  That means either that the number 384 is just
wrong, or it means that there are multiple PCI domains involved, and
that the BUG_ON() should be something else.

Furthermore, in get_tce_space_from_tar() we have:

	for (bus = 0; bus < MAX_PHB_BUS_NUM; bus++) {
		struct calgary_bus_info *info = &bus_info[bus];
		unsigned short pci_device;
		u32 val;

		val = read_pci_config(bus, 0, 0, 0);
		pci_device = (val & 0xFFFF0000) >> 16;

... which assumes the bus is a PCI bus number, no domain involved.

Does this mean the limit should be 256 (in which case we can just drop
the BUG_ON()), or is there support for domains which should be in this
code but isn't?

	-hpa
