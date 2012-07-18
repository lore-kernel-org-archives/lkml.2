Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752212Ab2GRG5j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 02:57:39 -0400
Received: from softlayer.compulab.co.il ([50.23.254.55]:38888 "EHLO
	compulab.co.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751152Ab2GRG5d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 02:57:33 -0400
Message-ID: <50065E5A.2040103@compulab.co.il>
Date: Wed, 18 Jul 2012 09:57:30 +0300
From: Denis Turischev <denis@compulab.co.il>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Sarah Sharp <sarah.a.sharp@linux.intel.com>
CC: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] xhci: EHCI/xHCI ports switching on Intense-PC.
References: <5004454E.9030903@compulab.co.il> <20120717045416.GJ7599@xanatos>
In-Reply-To: <20120717045416.GJ7599@xanatos>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - softlayer.compulab.co.il
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - compulab.co.il
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/17/2012 07:54 AM, Sarah Sharp wrote:
> On Mon, Jul 16, 2012 at 07:46:06PM +0300, Denis Turischev wrote:
>> Intense-PC is Compulab's mini-desktop with Intel Panther Point
>> chipset.
>>
>> Unconditional ports switching provided by function
>> usb_enable_xhci_ports() leads to surprising results, after shutdown
>> system powered-on again after a few seconds. On Windows power
>> related problems were not observed.
> 
> Do you have wake on lan enabled in the BIOS?  I have heard reports from
> other users that this is a BIOS bug triggered by WOL.

Bug appears with WOL disabled too, moreover, it appears with PCH LAN
disabled at all in the BIOS.

> 
>> The patch avoids ports switching for Intense-PC.
>>
>> Signed-off-by: Denis Turischev <denis@compulab.co.il>
>> ---
>>  drivers/usb/host/pci-quirks.c |    7 +++++++
>>  1 file changed, 7 insertions(+)
>>
>> diff --git a/drivers/usb/host/pci-quirks.c b/drivers/usb/host/pci-quirks.c
>> index df0828c..6f72593 100644
>> --- a/drivers/usb/host/pci-quirks.c
>> +++ b/drivers/usb/host/pci-quirks.c
>> @@ -759,6 +759,13 @@ void usb_enable_xhci_ports(struct pci_dev *xhci_pdev)
>>  {
>>  	u32		ports_available;
>>
>> +	const char *brd_name;
>> +	brd_name = dmi_get_system_info(DMI_BOARD_NAME);
>> +
>> +	/* quirk for Compulab's Intense-PC board */
>> +	if (brd_name && strstr(brd_name, "Intense-PC"))
>> +		return;
>> +
> 
> No, this fix is not acceptable.  You won't get USB 3.0 speeds if the
> ports are not switched over.  Now, we can add a quirk to the xHCI
> shutdown function to switch the ports back to EHCI on shutdown.  That
> might not trigger the BIOS bug.

Yes, switching back to EHCI in xhci_shutdown() solves the problem.

I suppose to do something like this in xhci_shutdown:
	pdev = to_pci_dev(hcd->self.controller);

	if (usb_is_intel_switchable_xhci(pdev)){
		brd_name = dmi_get_system_info(DMI_BOARD_NAME);

		/* quirk for Compulab's Intense-PC board */
		if (brd_name && strstr(brd_name, "Intense-PC"))
			usb_disable_xhci_ports(pdev);
	}

Is it ok?

May be it worth to disable xhci ports for all intel switchable
devices, not only for Intense-PC?

