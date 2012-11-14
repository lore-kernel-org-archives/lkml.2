Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755148Ab2KNKBg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 05:01:36 -0500
Received: from ogre.sisk.pl ([193.178.161.156]:43253 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752187Ab2KNKBe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 05:01:34 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Huang Ying <ying.huang@intel.com>, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org
Subject: Re: [BUGFIX] PM: Fix active child counting when disabled and forbidden
Date: Wed, 14 Nov 2012 11:05:56 +0100
Message-ID: <1456950.61QZjXbNpt@vostro.rjw.lan>
User-Agent: KMail/4.8.5 (Linux/3.7.0-rc5; KDE/4.8.5; x86_64; ; )
In-Reply-To: <Pine.LNX.4.44L0.1211081125470.1280-100000@iolanthe.rowland.org>
References: <Pine.LNX.4.44L0.1211081125470.1280-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, November 08, 2012 12:07:54 PM Alan Stern wrote:
> On Thu, 8 Nov 2012, Rafael J. Wysocki wrote:

[...]

I'd like to revisit this for a while if you don't mind.

> Your revised patch does do the job, except for a few problems.  
> Namely, while local_pci_probe() and pci_device_remove() are running,
> the device _does_ have a driver.

Right.

> This means that local_pci_probe() should not call pm_runtime_get_sync(),
> for example.  Doing so would invoke the driver's runtime_resume routine
> before calling the driver's probe routine!
> 
> The USB subsystem solves this problem by carefully keeping track of the 
> state of the device-driver binding:
> 
> 	Originally the device is UNBOUND.
> 
> 	At the start of the subsystem's probe routine, the state
> 	changes to BINDING.
> 
> 	If the probe succeeds then it changes to BOUND; otherwise
> 	it goes back to UNBOUND.
> 
> 	At the start of the subsystem's remove routine, the state
> 	changes to UNBINDING.  At the end it goes to UNBOUND.
> 
> When the state is anything other than BOUND, the subsystem's runtime PM 
> routines act as though there is no driver.

Well, that wouldn't help PCI, because some drivers want to use the
pm_runtime_* stuff in their .probe() routines and actually expect it to
work. :-)

Perhaps we can introduce something like

pm_runtime_get[_put]_skip_callbacks()

that would treat the device as though it had the power.no_callbacks flag
set and use that around the driver's .probe() in the PCI core?

Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
