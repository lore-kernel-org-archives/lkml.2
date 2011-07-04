Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757943Ab1GDPut (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jul 2011 11:50:49 -0400
Received: from netrider.rowland.org ([192.131.102.5]:39579 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757197Ab1GDPur (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jul 2011 11:50:47 -0400
Date: Mon, 4 Jul 2011 11:50:47 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Partha Basak <p-basak2@ti.com>
cc: Keshava Munegowda <keshava_mgowda@ti.com>, <linux-usb@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Felipe Balbi <balbi@ti.com>, Anand Gadiyar <gadiyar@ti.com>,
        <sameo@linux.intel.com>, <parthab@india.ti.com>, <tony@atomide.com>,
        Kevin Hilman <khilman@ti.com>, Benoit Cousson <b-cousson@ti.com>,
        <paul@pwsan.com>, <johnstul@us.ibm.com>,
        Vishwanath Sripathy <vishwanath.bs@ti.com>
Subject: RE: [PATCH 6/6 v2] arm: omap: usb: global Suspend and resume support
 of ehci and ohci
In-Reply-To: <11640ef76f97628579e457b5c6a74cc3@mail.gmail.com>
Message-ID: <Pine.LNX.4.44L0.1107041147510.12242-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 4 Jul 2011, Partha Basak wrote:

> >I don't see any point in these routines (and likewise for
> >omap_ohci_suspend/resume).  When the whole system is going to sleep
> >anyway, what reason is there for enabling runtime PM on the parent
> >device?
> 
> Both for EHCI & OHCI, the clocks are owned by the parent (uhh-tll).
> 
> Calling pm_runtime_put_sync(dev->parent) within omap_ehci_suspend
> will turn-off the parent clocks in the Suspend path.
> 
> Similarly, calling pm_runtime_get_sync(dev->parent) within
> omap_ehci_resume
> will turn-on the parent clocks in the resume path.
> 
> This way, all reference counting are implicit within the Runtime PM layer
> and takes care of all combinations of only EHCI insmoded, OHCI insmoded,
> both insmoded etc.
> 
> When both EHCI & OHCI are suspended, parent clocks will actually be
> turned OFF and vice-versa.
> 
> Note that the parent per-se does not have any .suspend & .resume hooked
> up.

Why not?  That sounds like a big bug.

> At the end of the _probe of parent, the clocks are turned OFF.
> Subsequently, enabling
> the parent clocks are entirely done implicitly by the children get_sync()
> in their _probe.
> 
> Therefore while .suspend/.resume of children are called they call back
> into the parent to turn-off the clocks.

You have ignored a few very important points:

Firstly, system suspend is supposed to work even when runtime PM is not 
configured.

Secondly, the user can disable runtime PM via sysfs at any time.  This 
shouldn't mess up system suspend.

Basically, it's a bad idea to mix up system suspend with runtime PM.

Alan Stern

