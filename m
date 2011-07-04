Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756816Ab1GDJ0f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jul 2011 05:26:35 -0400
Received: from na3sys009aog102.obsmtp.com ([74.125.149.69]:60963 "EHLO
	na3sys009aog102.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754024Ab1GDJ0d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jul 2011 05:26:33 -0400
From: Partha Basak <p-basak2@ti.com>
References: <1309546474-15363-7-git-send-email-keshava_mgowda@ti.com>
 <Pine.LNX.4.44L0.1107011504530.1624-100000@iolanthe.rowland.org>
 <11640ef76f97628579e457b5c6a74cc3@mail.gmail.com> <20110704082553.GH15044@legolas.emea.dhcp.ti.com>
In-Reply-To: <20110704082553.GH15044@legolas.emea.dhcp.ti.com>
MIME-Version: 1.0
X-Mailer: Microsoft Office Outlook 12.0
Thread-Index: Acw6JAckWoxj0XGxQdazanXzseat4QABjZ/A
Date: Mon, 4 Jul 2011 14:56:30 +0530
Message-ID: <99b22453092fc32b751c3e7d0223c7eb@mail.gmail.com>
Subject: RE: [PATCH 6/6 v2] arm: omap: usb: global Suspend and resume support
 of ehci and ohci
To: balbi@ti.com
Cc: Alan Stern <stern@rowland.harvard.edu>,
        Keshava Munegowda <keshava_mgowda@ti.com>, linux-usb@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        Anand Gadiyar <gadiyar@ti.com>, sameo@linux.intel.com,
        parthab@india.ti.com, tony@atomide.com, Kevin Hilman <khilman@ti.com>,
        Benoit Cousson <b-cousson@ti.com>, paul@pwsan.com, johnstul@us.ibm.com,
        Vishwanath Sripathy <vishwanath.bs@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>-----Original Message-----
>From: Felipe Balbi [mailto:balbi@ti.com]
>Sent: Monday, July 04, 2011 1:56 PM
>To: Partha Basak
>Cc: Alan Stern; Keshava Munegowda; linux-usb@vger.kernel.org; linux-
>omap@vger.kernel.org; linux-kernel@vger.kernel.org; Felipe Balbi; Anand
>Gadiyar; sameo@linux.intel.com; parthab@india.ti.com; tony@atomide.com;
>Kevin Hilman; Benoit Cousson; paul@pwsan.com; johnstul@us.ibm.com;
>Vishwanath Sripathy
>Subject: Re: [PATCH 6/6 v2] arm: omap: usb: global Suspend and resume
>support of ehci and ohci
>
>Hi,
>
>On Mon, Jul 04, 2011 at 10:36:54AM +0530, Partha Basak wrote:
>> >-----Original Message-----
>> >From: Alan Stern [mailto:stern@rowland.harvard.edu]
>> >Sent: Saturday, July 02, 2011 12:37 AM
>> >To: Keshava Munegowda
>> >Cc: linux-usb@vger.kernel.org; linux-omap@vger.kernel.org; linux-
>> >kernel@vger.kernel.org; balbi@ti.com; gadiyar@ti.com;
>> >sameo@linux.intel.com; parthab@india.ti.com; tony@atomide.com;
>> >khilman@ti.com; b-cousson@ti.com; paul@pwsan.com;
>> >johnstul@us.ibm.com; vishwanath.bs@ti.com
>> >Subject: Re: [PATCH 6/6 v2] arm: omap: usb: global Suspend and resume
>> >support of ehci and ohci
>> >
>> >On Sat, 2 Jul 2011, Keshava Munegowda wrote:
>> >
>> >> From: Keshava Munegowda <Keshava_mgowda@ti.com>
>> >>
>> >> The global suspend and resume functions for ehci and ohci drivers
>> >> are implemented; these functions does the pm_runtime_get_sync and
>> >> pm_runtime_put_sync of the parent device usbhs core driver
>> >> respectively.
>> >>
>> >> Signed-off-by: Keshava Munegowda <keshava_mgowda@ti.com>
>> >> ---
>> >>  drivers/usb/host/ehci-omap.c  |   22 ++++++++++++++++++++--
>> >>  drivers/usb/host/ohci-omap3.c |   21 +++++++++++++++++++++
>> >>  2 files changed, 41 insertions(+), 2 deletions(-)
>> >>
>> >> diff --git a/drivers/usb/host/ehci-omap.c b/drivers/usb/host/ehci-
>> >omap.c
>> >> index 178f63e..a02a684 100644
>> >> --- a/drivers/usb/host/ehci-omap.c
>> >> +++ b/drivers/usb/host/ehci-omap.c
>> >> @@ -259,14 +259,32 @@ static void ehci_hcd_omap_shutdown(struct
>> >platform_device *pdev)
>> >>  		hcd->driver->shutdown(hcd);
>> >>  }
>> >>
>> >> +static int omap_ehci_resume(struct device *dev) {
>> >> +	if (dev->parent)
>> >> +		pm_runtime_get_sync(dev->parent);
>> >> +	return 0;
>> >> +}
>> >> +
>> >> +static int omap_ehci_suspend(struct device *dev) {
>> >> +	if (dev->parent)
>> >> +		pm_runtime_put_sync(dev->parent);
>> >> +	return 0;
>> >> +}
>> >
>> >I don't see any point in these routines (and likewise for
>> >omap_ohci_suspend/resume).  When the whole system is going to sleep
>> >anyway, what reason is there for enabling runtime PM on the parent
>> >device?
>>
>> Both for EHCI & OHCI, the clocks are owned by the parent (uhh-tll).
>>
>> Calling pm_runtime_put_sync(dev->parent) within omap_ehci_suspend will
>> turn-off the parent clocks in the Suspend path.
>>
>> Similarly, calling pm_runtime_get_sync(dev->parent) within
>> omap_ehci_resume will turn-on the parent clocks in the resume path.
>>
>> This way, all reference counting are implicit within the Runtime PM
>> layer and takes care of all combinations of only EHCI insmoded, OHCI
>> insmoded, both insmoded etc.
>>
>> When both EHCI & OHCI are suspended, parent clocks will actually be
>> turned OFF and vice-versa.
>
>not sure this is necessary. I would expect:
>
>pm_runtime_get_sync(dev) to propagate up the parent tree and enable all
>necessary resources to get the child in a working state. IOW, you
>shouldn't need to manuall access the parent device.
>
Refer to the description in Patch(5/6)
<snip>
In fact, the runtime framework takes care the get sync and put sync of the
child
in turn call the get sync and put sync of parent too; but calling get sync
and
put sync of parent is by ASYNC mode;
This mode queues the work item in runtime pm work queue,
which not getting scheduled in case of global suspend path.
<snip>
This approach was tried, but did not work in the Suspend path
static int rpm_suspend(struct device *dev, int rpmflags)
	__releases(&dev->power.lock) __acquires(&dev->power.lock)
{
.
.
.
no_callback:
.
.
.
	/* Maybe the parent is now able to suspend. */
	if (parent && !parent->power.ignore_children &&
!dev->power.irq_safe) {
		spin_unlock(&dev->power.lock);

		spin_lock(&parent->power.lock);
		rpm_idle(parent, RPM_ASYNC);
		spin_unlock(&parent->power.lock);

		spin_lock(&dev->power.lock);
	}
This is the reason of directly calling the parent Runtime PM calls from
the children.
If directly calling Runtime PM APIs with parent dev-pointer isn't
acceptable,
this can be achieved by exporting wrapper APIs from the
parent and calling them from the chidren .suspend/.resume routines.

>Kevin ? Paul ?
>
>--
>balbi
