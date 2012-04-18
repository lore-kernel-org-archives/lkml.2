Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752808Ab2DRCBI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 22:01:08 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:46064 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751990Ab2DRCBF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 22:01:05 -0400
MIME-Version: 1.0
In-Reply-To: <201204172310.38816.rjw@sisk.pl>
References: <4F8790F6.5080408@intel.com>
	<201204162330.12178.rjw@sisk.pl>
	<CAC=cRTMXNnZQ_bDes9JFp9yreGC63b_i9fUX6apQzWrUHw2a0Q@mail.gmail.com>
	<201204172310.38816.rjw@sisk.pl>
Date: Wed, 18 Apr 2012 10:01:04 +0800
Message-ID: <CAC=cRTNc3XeniOzttRVUTFEzZY1RY7Ds7m+hE8_86A-Ep-5Czw@mail.gmail.com>
Subject: Re: [RFC PATCH] PCIe: Add PCIe runtime D3cold support
From: huang ying <huang.ying.caritas@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: "Yan, Zheng" <zheng.z.yan@intel.com>, bhelgaas@google.com,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-pm@vger.kernel.org, Lin Ming <ming.m.lin@intel.com>,
        Zhang Rui <rui.zhang@intel.com>,
        ACPI Devel Mailing List <linux-acpi@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 18, 2012 at 5:10 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> On Tuesday, April 17, 2012, huang ying wrote:
>> On Tue, Apr 17, 2012 at 5:30 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>> >> >> +     return 0;
>> >> >> +}
>> >> >> +
>> >> >> +static int pcie_port_runtime_resume(struct device *dev)
>> >> >> +{
>> >> >> +     struct pci_dev *pdev = to_pci_dev(dev);
>> >> >> +
>> >> >> +     pci_restore_state(pdev);
>> >> >> +     if (pdev->runtime_d3cold)
>> >> >> +             msleep(100);
>> >> >
>> >> > What's _that_ supposed to do?
>> >>
>> >> When resume from d3cold, PCIe main link will be powered on again, it
>> >> will take quite some time before the main link go into L0 state.
>> >> Otherwise, accessing devices under the port may return wrong result.
>> >
>> > OK, but this is generic code and as per the standard the link should have been
>> > reestablished at this point already.
>> >
>> > Please don't put some nonstandard-platform-specific quirks like this into
>> > code that's supposed to handle _every_ PCIe system.
>>
>> After checking PCIe spec, I found that the 100ms here has its standard origin :)
>>
>> In PCI Express Base Specification Revision 2.0:
>>
>> Section 6.6.1 Conventional Reset
>>
>> "
>> To allow components to perform internal initialization, system
>> software must wait for at least
>> 100 ms from the end of a Conventional Reset of one or more devices
>> before it is permitted to
>> issue Configuration Requests to those devices
>> "
>>
>> But I think we should move the 100ms delay here to PCIe bus code or
>> PCIe/ACPI code, because that is needed by all PCIe devices for D3cold
>> support.
>
> I think it should be sufficient to wait for the PME message to arrive at
> the root port (which will cause the PME interrupt to appear), at which
> point the device that sent it should be able to receive configuration
> requests.

For remote wake up, it is sufficient.  But for host wake up, we still
need to wait 100ms.

> At this point, I need to konw what exactly happens when the GPE is triggered
> by WAKE#.

- Lxx handler will be executed
- in Lxx handler, Notify the ACPI handle PCIe port
- Linux has registered a handler for the ACPI handle of PCIe port, in
the handler, turn on _PR0 and execute _PS0, which will power on the
link.

Best Regards,
Huang Ying
