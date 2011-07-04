Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751944Ab1GDFG7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jul 2011 01:06:59 -0400
Received: from na3sys009aog107.obsmtp.com ([74.125.149.197]:51642 "EHLO
	na3sys009aog107.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750944Ab1GDFG5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jul 2011 01:06:57 -0400
From: Partha Basak <p-basak2@ti.com>
References: <1309546474-15363-7-git-send-email-keshava_mgowda@ti.com> <Pine.LNX.4.44L0.1107011504530.1624-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1107011504530.1624-100000@iolanthe.rowland.org>
MIME-Version: 1.0
X-Mailer: Microsoft Office Outlook 12.0
Thread-Index: Acw4Ig3kOE9LZVj4Qe2EWXpRSl4wNwB5As0Q
Date: Mon, 4 Jul 2011 10:36:54 +0530
Message-ID: <11640ef76f97628579e457b5c6a74cc3@mail.gmail.com>
Subject: RE: [PATCH 6/6 v2] arm: omap: usb: global Suspend and resume support
 of ehci and ohci
To: Alan Stern <stern@rowland.harvard.edu>,
        Keshava Munegowda <keshava_mgowda@ti.com>
Cc: linux-usb@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, Felipe Balbi <balbi@ti.com>,
        Anand Gadiyar <gadiyar@ti.com>, sameo@linux.intel.com,
        parthab@india.ti.com, tony@atomide.com, Kevin Hilman <khilman@ti.com>,
        Benoit Cousson <b-cousson@ti.com>, paul@pwsan.com, johnstul@us.ibm.com,
        Vishwanath Sripathy <vishwanath.bs@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>-----Original Message-----
>From: Alan Stern [mailto:stern@rowland.harvard.edu]
>Sent: Saturday, July 02, 2011 12:37 AM
>To: Keshava Munegowda
>Cc: linux-usb@vger.kernel.org; linux-omap@vger.kernel.org; linux-
>kernel@vger.kernel.org; balbi@ti.com; gadiyar@ti.com;
>sameo@linux.intel.com; parthab@india.ti.com; tony@atomide.com;
>khilman@ti.com; b-cousson@ti.com; paul@pwsan.com; johnstul@us.ibm.com;
>vishwanath.bs@ti.com
>Subject: Re: [PATCH 6/6 v2] arm: omap: usb: global Suspend and resume
>support of ehci and ohci
>
>On Sat, 2 Jul 2011, Keshava Munegowda wrote:
>
>> From: Keshava Munegowda <Keshava_mgowda@ti.com>
>>
>> The global suspend and resume functions for ehci and ohci
>> drivers are implemented; these functions does the
>> pm_runtime_get_sync and pm_runtime_put_sync of the
>> parent device usbhs core driver respectively.
>>
>> Signed-off-by: Keshava Munegowda <keshava_mgowda@ti.com>
>> ---
>>  drivers/usb/host/ehci-omap.c  |   22 ++++++++++++++++++++--
>>  drivers/usb/host/ohci-omap3.c |   21 +++++++++++++++++++++
>>  2 files changed, 41 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/usb/host/ehci-omap.c b/drivers/usb/host/ehci-
>omap.c
>> index 178f63e..a02a684 100644
>> --- a/drivers/usb/host/ehci-omap.c
>> +++ b/drivers/usb/host/ehci-omap.c
>> @@ -259,14 +259,32 @@ static void ehci_hcd_omap_shutdown(struct
>platform_device *pdev)
>>  		hcd->driver->shutdown(hcd);
>>  }
>>
>> +static int omap_ehci_resume(struct device *dev)
>> +{
>> +	if (dev->parent)
>> +		pm_runtime_get_sync(dev->parent);
>> +	return 0;
>> +}
>> +
>> +static int omap_ehci_suspend(struct device *dev)
>> +{
>> +	if (dev->parent)
>> +		pm_runtime_put_sync(dev->parent);
>> +	return 0;
>> +}
>
>I don't see any point in these routines (and likewise for
>omap_ohci_suspend/resume).  When the whole system is going to sleep
>anyway, what reason is there for enabling runtime PM on the parent
>device?

Both for EHCI & OHCI, the clocks are owned by the parent (uhh-tll).

Calling pm_runtime_put_sync(dev->parent) within omap_ehci_suspend
will turn-off the parent clocks in the Suspend path.

Similarly, calling pm_runtime_get_sync(dev->parent) within
omap_ehci_resume
will turn-on the parent clocks in the resume path.

This way, all reference counting are implicit within the Runtime PM layer
and takes care of all combinations of only EHCI insmoded, OHCI insmoded,
both insmoded etc.

When both EHCI & OHCI are suspended, parent clocks will actually be
turned OFF and vice-versa.

Note that the parent per-se does not have any .suspend & .resume hooked
up.
At the end of the _probe of parent, the clocks are turned OFF.
Subsequently, enabling
the parent clocks are entirely done implicitly by the children get_sync()
in their _probe.

Therefore while .suspend/.resume of children are called they call back
into the parent to turn-off the clocks.

FYI, Keshava is out of office due to some emergency this week,
there will be some delays in replying from his side.

>
>Alan Stern
