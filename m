Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755104Ab1AKBVQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 20:21:16 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:20624 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753150Ab1AKBVL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 20:21:11 -0500
Message-ID: <4D2BB048.2050509@kernel.org>
Date: Mon, 10 Jan 2011 17:20:08 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20101125 SUSE/3.0.11 Thunderbird/3.0.11
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: Jesse Barnes <jbarnes@virtuousgeek.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        linux-usb@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -v3 1/4] pci, usb:  Make usb handoff func all take base
 remapping
References: <4D2A1382.7010407@kernel.org> <4D2AC6BF.3010907@kernel.org> <4D2BA8FE.9090204@kernel.org> <4D2BAA75.60001@kernel.org> <20110111010714.GB32585@kroah.com>
In-Reply-To: <20110111010714.GB32585@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/10/2011 05:07 PM, Greg KH wrote:
> On Mon, Jan 10, 2011 at 04:55:17PM -0800, Yinghai Lu wrote:
>>
>> So later could reuse them to do usb handoff much early for x86.
>>
>> will make arch early code get MMIO BAR and do remapping itself.
>>
>> -v2: still keep pci_device *pdev as parameter according to BenH.
>> -v3: expose three functions that take *base instead of including .c file.
>>
>> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
>>
>> ---
>>  drivers/usb/host/pci-quirks.c |  195 ++++++++++++++++++++++++------------------
>>  drivers/usb/host/pci-quirks.h |    6 +
>>  2 files changed, 120 insertions(+), 81 deletions(-)
>>
>> Index: linux-2.6/drivers/usb/host/pci-quirks.c
>> ===================================================================
>> --- linux-2.6.orig/drivers/usb/host/pci-quirks.c
>> +++ linux-2.6/drivers/usb/host/pci-quirks.c
>> @@ -17,6 +17,19 @@
>>  #include "pci-quirks.h"
>>  #include "xhci-ext-caps.h"
>>  
>> +static void default_usb_handoff_udelay(unsigned long usecs)
>> +{
>> +	udelay(usecs);
>> +}
>> +
>> +static void __devinit default_usb_handoff_msleep(unsigned long msecs)
>> +{
>> +	msleep(msecs);
>> +}
> 
> What?
> 
> Why in the world would you not just call the real functions here?
> That's not acceptable, sorry.

for early access, can not use udelay yet, it will take some one.
Also msleep will cause crash, because it needs scheduler there.

> 
> 
>> +
>> +void (*usb_handoff_udelay)(unsigned long) = default_usb_handoff_udelay;
>> +void (*usb_handoff_msleep)(unsigned long) __devinitdata =
>> +			default_usb_handoff_msleep;

or do you mean use ..
+void (*usb_handoff_udelay)(unsigned long) = udelay;
+void (*usb_handoff_msleep)(unsigned long) __devinitdata =
+			msleep;



>> --- linux-2.6.orig/drivers/usb/host/pci-quirks.h
>> +++ linux-2.6/drivers/usb/host/pci-quirks.h
>> @@ -3,5 +3,11 @@
>>  
>>  void uhci_reset_hc(struct pci_dev *pdev, unsigned long base);
>>  int uhci_check_and_reset_hc(struct pci_dev *pdev, unsigned long base);
>> +void __usb_handoff_ohci(struct pci_dev *pdev, void __iomem *base);
>> +void __usb_handoff_ehci(struct pci_dev *pdev, void __iomem *base);
>> +void __usb_handoff_xhci(struct pci_dev *pdev, void __iomem *base);
> 
> External functions should never have "__" at the start of them, sorry.

will change that.

Thanks

Yinghai
