Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933399Ab2KEWLe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 17:11:34 -0500
Received: from mail-wi0-f178.google.com ([209.85.212.178]:43287 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933360Ab2KEWLb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 17:11:31 -0500
MIME-Version: 1.0
In-Reply-To: <1352000325.9881.0.camel@yhuang-mobile.sh.intel.com>
References: <1351061654-8339-1-git-send-email-ying.huang@intel.com>
 <CAErSpo7hiFQOC+OPZretkyp5EcL84zEWCAiQgEE5Ewq--gUziQ@mail.gmail.com>
 <1351919165.13106.2.camel@yhuang-mobile.sh.intel.com> <CAErSpo4k+SjqdBt3w3POkg=toCnZufH4gnwJpV8BW8DH5abkqw@mail.gmail.com>
 <1352000325.9881.0.camel@yhuang-mobile.sh.intel.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Mon, 5 Nov 2012 15:11:10 -0700
Message-ID: <CAErSpo4AMsGeuKqhFeqf=8VnJOgvEuQmL3a8j4MtfwhnHtU2DA@mail.gmail.com>
Subject: Re: [BUGFIX 1/2] PCI/PM: Fix deadlock when unbind device if its
 parent in D3cold
To: Huang Ying <ying.huang@intel.com>
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-pm@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Zhang Yanmin <yanmin.zhang@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 3, 2012 at 9:38 PM, Huang Ying <ying.huang@intel.com> wrote:
> On Sat, 2012-11-03 at 11:22 -0600, Bjorn Helgaas wrote:
>> On Fri, Nov 2, 2012 at 11:06 PM, Huang Ying <ying.huang@intel.com> wrote:
>> > On Fri, 2012-11-02 at 10:50 -0600, Bjorn Helgaas wrote:
>> >> On Wed, Oct 24, 2012 at 12:54 AM, Huang Ying <ying.huang@intel.com> wrote:
>> >> > If a PCI device and its parents are put into D3cold, unbinding the
>> >> > device will trigger deadlock as follow:
>> >> >
>> >> > - driver_unbind
>> >> >   - device_release_driver
>> >> >     - device_lock(dev)                          <--- previous lock here
>> >> >     - __device_release_driver
>> >> >       - pm_runtime_get_sync
>> >> >         ...
>> >> >           - rpm_resume(dev)
>> >> >             - rpm_resume(dev->parent)
>> >> >               ...
>> >> >                 - pci_pm_runtime_resume
>> >> >                   ...
>> >> >                   - pci_set_power_state
>> >> >                     - __pci_start_power_transition
>> >> >                       - pci_wakeup_bus(dev->parent->subordinate)
>> >> >                         - pci_walk_bus
>> >> >                           - device_lock(dev)    <--- dead lock here
>> >> >
>> >> >
>> >> > If we do not do device_lock in pci_walk_bus, we can avoid dead lock.
>> >> > Device_lock in pci_walk_bus is introduced in commit:
>> >> > d71374dafbba7ec3f67371d3b7e9f6310a588808, corresponding email thread
>> >> > is: https://lkml.org/lkml/2006/5/26/38.  The patch author Zhang Yanmin
>> >> > said device_lock is added to pci_walk_bus because:
>> >> >
>> >> >   Some error handling functions call pci_walk_bus. For example, PCIe
>> >> >   aer. Here we lock the device, so the driver wouldn't detach from the
>> >> >   device, as the cb might call driver's callback function.
>> >> >
>> >> > So I fixed the dead lock as follow:
>> >> >
>> >> > - remove device_lock from pci_walk_bus
>> >> > - add device_lock into callback if callback will call driver's callback
>> >> >
>> >> > I checked pci_walk_bus users one by one, and found only PCIe aer needs
>> >> > device lock.
>> >>
>> >> Is there a problem report or bugzilla for this issue?
>> >
>> > No.  I found this issue when I developed kexec fixing.
>> >
>> > Best Regards,
>> > Huang Ying
>> >
>> >> > Signed-off-by: Huang Ying <ying.huang@intel.com>
>> >> > Cc: Zhang Yanmin <yanmin.zhang@intel.com>
>> >>
>> >> Should this go to stable as well?  The D3cold support appeared in
>> >> v3.6, so my guess is that this fix could go to v3.6.x.
>>
>> What about the stable tree?
>
> You are right.  This fix should go to v3.6.x stable tree.

I applied these two patches to my for-linus branch as v3.7 material.  Thanks!
