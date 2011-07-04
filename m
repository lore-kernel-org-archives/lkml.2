Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754742Ab1GDLBv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jul 2011 07:01:51 -0400
Received: from na3sys009aob106.obsmtp.com ([74.125.149.76]:47700 "EHLO
	na3sys009aog106.obsmtp.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752455Ab1GDLBt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jul 2011 07:01:49 -0400
From: Partha Basak <p-basak2@ti.com>
References: <1309546474-15363-7-git-send-email-keshava_mgowda@ti.com>
 <Pine.LNX.4.44L0.1107011504530.1624-100000@iolanthe.rowland.org>
 <11640ef76f97628579e457b5c6a74cc3@mail.gmail.com> <20110704082553.GH15044@legolas.emea.dhcp.ti.com>
 <99b22453092fc32b751c3e7d0223c7eb@mail.gmail.com> <20110704093056.GD25295@legolas.emea.dhcp.ti.com>
In-Reply-To: <20110704093056.GD25295@legolas.emea.dhcp.ti.com>
MIME-Version: 1.0
X-Mailer: Microsoft Office Outlook 12.0
Thread-Index: Acw6LT99+5Hs/h5jSriBLY4njNywZQACnSSw
Date: Mon, 4 Jul 2011 16:31:45 +0530
Message-ID: <c026265b1b15473e41ea3c8cd72abf07@mail.gmail.com>
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
>From: linux-omap-owner@vger.kernel.org [mailto:linux-omap-
>owner@vger.kernel.org] On Behalf Of Felipe Balbi
>Sent: Monday, July 04, 2011 3:01 PM
>To: Partha Basak
>Cc: balbi@ti.com; Alan Stern; Keshava Munegowda; linux-
>usb@vger.kernel.org; linux-omap@vger.kernel.org; linux-
>kernel@vger.kernel.org; Anand Gadiyar; sameo@linux.intel.com;
>parthab@india.ti.com; tony@atomide.com; Kevin Hilman; Benoit Cousson;
>paul@pwsan.com; johnstul@us.ibm.com; Vishwanath Sripathy
>Subject: Re: [PATCH 6/6 v2] arm: omap: usb: global Suspend and resume
>support of ehci and ohci
>
>Hi,
>
>On Mon, Jul 04, 2011 at 02:56:30PM +0530, Partha Basak wrote:
>> >> Both for EHCI & OHCI, the clocks are owned by the parent (uhh-tll).
>> >>
>> >> Calling pm_runtime_put_sync(dev->parent) within omap_ehci_suspend
>> >> will turn-off the parent clocks in the Suspend path.
>> >>
>> >> Similarly, calling pm_runtime_get_sync(dev->parent) within
>> >> omap_ehci_resume will turn-on the parent clocks in the resume path.
>> >>
>> >> This way, all reference counting are implicit within the Runtime PM
>> >> layer and takes care of all combinations of only EHCI insmoded,
>> >> OHCI insmoded, both insmoded etc.
>> >>
>> >> When both EHCI & OHCI are suspended, parent clocks will actually be
>> >> turned OFF and vice-versa.
>> >
>> >not sure this is necessary. I would expect:
>> >
>> >pm_runtime_get_sync(dev) to propagate up the parent tree and enable
>> >all necessary resources to get the child in a working state. IOW, you
>> >shouldn't need to manuall access the parent device.
>> >
>> Refer to the description in Patch(5/6) <snip> In fact, the runtime
>> framework takes care the get sync and put sync of the child in turn
>> call the get sync and put sync of parent too; but calling get sync and
>> put sync of parent is by ASYNC mode; This mode queues the work item in
>> runtime pm work queue, which not getting scheduled in case of global
>> suspend path.
>> <snip>
>> This approach was tried, but did not work in the Suspend path
>
>sounds to me like a bug on pm runtime ? If you're calling
>pm_runtime_*_sync() family, shouldn't all calls be _sync() too ?
>
>> static int rpm_suspend(struct device *dev, int rpmflags)
>> 	__releases(&dev->power.lock) __acquires(&dev->power.lock) { .
>> .
>> .
>> no_callback:
>> .
>> .
>> .
>> 	/* Maybe the parent is now able to suspend. */
>> 	if (parent && !parent->power.ignore_children &&
>> !dev->power.irq_safe) {
>> 		spin_unlock(&dev->power.lock);
>>
>> 		spin_lock(&parent->power.lock);
>> 		rpm_idle(parent, RPM_ASYNC);
>
>to me this is bogus, if you called pm_runtime_put_sync() should should
>be sync too. Shouldn't it ?
>
>> 		spin_unlock(&parent->power.lock);
>>
>> 		spin_lock(&dev->power.lock);
>> 	}
>> This is the reason of directly calling the parent Runtime PM calls
>> from the children.
>> If directly calling Runtime PM APIs with parent dev-pointer isn't
>> acceptable, this can be achieved by exporting wrapper APIs from the
>> parent and calling them from the chidren .suspend/.resume routines.
>
>Still no good, IMHO.

Kevin, any comments?

Shouldn't the framework ensure that if put_sync(dev) is called
it should ensure that the parent is rmp_idled synchronously?
>
>--
>balbi
