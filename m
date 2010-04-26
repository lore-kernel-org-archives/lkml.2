Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754188Ab0DZVLI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Apr 2010 17:11:08 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:43132 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753467Ab0DZVLG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Apr 2010 17:11:06 -0400
Message-ID: <4BD600A7.609@oracle.com>
Date: Mon, 26 Apr 2010 14:07:51 -0700
From: Yinghai <yinghai.lu@oracle.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100317 SUSE/3.0.4-1.1.1 Thunderbird/3.0.4
MIME-Version: 1.0
To: Jesse Barnes <jbarnes@virtuousgeek.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
CC: Bjorn Helgaas <bjorn.helgaas@hp.com>, Andy Isaacson <adi@hexapodia.org>,
       "R. Andrew Bailey" <bailey@akamai.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, guenter.roeck@ericsson.com,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       "x86@kernel.org" <x86@kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Thomas Renninger <trenn@suse.de>, yaneti@declera.com
Subject: Re: [PATCH] x86/PCI: never allocate PCI MMIO resources below BIOS_END
References: <4BC4E55B.7000103@oracle.com>	<20100426183436.GV11130@hexapodia.org>	<20100426123135.5d095d2f@virtuousgeek.org>	<201004261427.57229.bjorn.helgaas@hp.com> <20100426133757.3e1d0a75@virtuousgeek.org>
In-Reply-To: <20100426133757.3e1d0a75@virtuousgeek.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Auth-Type: Internal IP
X-Source-IP: acsinet15.oracle.com [141.146.126.227]
X-CT-RefId: str=0001.0A090206.4BD60108.018B:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/26/2010 01:37 PM, Jesse Barnes wrote:
> On Mon, 26 Apr 2010 14:27:56 -0600
>> I think it also leads to at least one problem: Guenter's machine has no
>> VGA but has a PCI device that lives at 0xa0000.  The driver for that
>> device won't be able to request that region if the arch code has marked
>> it busy.
> 
> Ah good point, so we'll want another approach at any rate.  Yinghai?

With current linus's tree, there is some difference between mmio > 1M and MMIO < 1M.

Actually it does not care about E820_RESERVED for > 1M range, because it doesn't have _BUSY.

For < 1M range, 
a. MMIO is not with E820_RESERVED, the device driver will work.
b. MMIO is with E820_RESERVED, the device driver can not reserve it's mmio later. because that MMIO could have parent resource with "reserved" name and _BUSY flag

My patch -v3 will break a.
but my patch -v4 patch will make it work.

but looks -v4 is too tricky.

maybe we just need remove change like following.

diff --git a/arch/x86/kernel/e820.c b/arch/x86/kernel/e820.c
index 7bca3c6..9849824 100644
--- a/arch/x86/kernel/e820.c
+++ b/arch/x86/kernel/e820.c
@@ -1094,7 +1094,7 @@ void __init e820_reserve_resources(void)
 		 * pci device BAR resource and insert them later in
 		 * pcibios_resource_survey()
 		 */
-		if (e820.map[i].type != E820_RESERVED || res->start < (1ULL<<20)) {
+		if (e820.map[i].type != E820_RESERVED) {
 			res->flags |= IORESOURCE_BUSY;
 			insert_resource(&iomem_resource, res);
 		}

May need Linus to ack it.

Those strange devices could be some kind of virtual debug devices. and they like to use those low mmio range.

YH
