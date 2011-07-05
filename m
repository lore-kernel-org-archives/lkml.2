Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752389Ab1GEOAa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 10:00:30 -0400
Received: from na3sys009aog115.obsmtp.com ([74.125.149.238]:43130 "EHLO
	na3sys009aog115.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751969Ab1GEOA2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 10:00:28 -0400
From: Partha Basak <p-basak2@ti.com>
References: <11640ef76f97628579e457b5c6a74cc3@mail.gmail.com> <Pine.LNX.4.44L0.1107041147510.12242-100000@netrider.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1107041147510.12242-100000@netrider.rowland.org>
MIME-Version: 1.0
X-Mailer: Microsoft Office Outlook 12.0
Thread-Index: Acw6Ykejc7LzsNIGR+SeKE3K8vUwYwAtugWw
Date: Tue, 5 Jul 2011 19:30:26 +0530
Message-ID: <41049fa81376d2973fa760cf061ee460@mail.gmail.com>
Subject: RE: [PATCH 6/6 v2] arm: omap: usb: global Suspend and resume support
 of ehci and ohci
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Keshava Munegowda <keshava_mgowda@ti.com>, linux-usb@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        Felipe Balbi <balbi@ti.com>, Anand Gadiyar <gadiyar@ti.com>,
        sameo@linux.intel.com, parthab@india.ti.com, tony@atomide.com,
        Kevin Hilman <khilman@ti.com>, Benoit Cousson <b-cousson@ti.com>,
        paul@pwsan.com, johnstul@us.ibm.com,
        Vishwanath Sripathy <vishwanath.bs@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>-----Original Message-----
>From: linux-omap-owner@vger.kernel.org [mailto:linux-omap-
>owner@vger.kernel.org] On Behalf Of Alan Stern
>Sent: Monday, July 04, 2011 9:21 PM
>To: Partha Basak
>Cc: Keshava Munegowda; linux-usb@vger.kernel.org; linux-
>omap@vger.kernel.org; linux-kernel@vger.kernel.org; Felipe Balbi; Anand
>Gadiyar; sameo@linux.intel.com; parthab@india.ti.com; tony@atomide.com;
>Kevin Hilman; Benoit Cousson; paul@pwsan.com; johnstul@us.ibm.com;
>Vishwanath Sripathy
>Subject: RE: [PATCH 6/6 v2] arm: omap: usb: global Suspend and resume
>support of ehci and ohci
>
>On Mon, 4 Jul 2011, Partha Basak wrote:
>
>> >I don't see any point in these routines (and likewise for
>> >omap_ohci_suspend/resume).  When the whole system is going to sleep
>> >anyway, what reason is there for enabling runtime PM on the parent
>> >device?
>>
>> Both for EHCI & OHCI, the clocks are owned by the parent (uhh-tll).
>>
>> Calling pm_runtime_put_sync(dev->parent) within omap_ehci_suspend
>> will turn-off the parent clocks in the Suspend path.
>>
>> Similarly, calling pm_runtime_get_sync(dev->parent) within
>> omap_ehci_resume
>> will turn-on the parent clocks in the resume path.
>>
>> This way, all reference counting are implicit within the Runtime PM
>layer
>> and takes care of all combinations of only EHCI insmoded, OHCI
>insmoded,
>> both insmoded etc.
>>
>> When both EHCI & OHCI are suspended, parent clocks will actually be
>> turned OFF and vice-versa.
>>
>> Note that the parent per-se does not have any .suspend & .resume
>hooked
>> up.
>
>Why not?  That sounds like a big bug.

This was a design decision since the parent needs to be activated only
when at-least one child is insmoded.

If the chidren are suspended, automatically the parent is suspended
via the pm_runtime_putsync calls to the parent.

So, effectively, we do not need an explicit suspend for the parent.
>
>> At the end of the _probe of parent, the clocks are turned OFF.
>> Subsequently, enabling
>> the parent clocks are entirely done implicitly by the children
>get_sync()
>> in their _probe.
>>
>> Therefore while .suspend/.resume of children are called they call back
>> into the parent to turn-off the clocks.
>
>You have ignored a few very important points:
>
>Firstly, system suspend is supposed to work even when runtime PM is not
>configured.
>
>Secondly, the user can disable runtime PM via sysfs at any time.  This
>shouldn't mess up system suspend.
>
>Basically, it's a bad idea to mix up system suspend with runtime PM.

Your observations are correct but this is a generic limitation and Kevin
is working
on this problem in parallel.

As of now, all OMAP drivers are mandated to use ONLY runtime pm framework
for enabling/disabling clocks. I will let Kevin comment further.

>
>Alan Stern
>
>--
>To unsubscribe from this list: send the line "unsubscribe linux-omap" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
