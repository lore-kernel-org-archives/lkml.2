Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760693Ab2EISSw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 14:18:52 -0400
Received: from g5t0007.atlanta.hp.com ([15.192.0.44]:21276 "EHLO
	g5t0007.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753717Ab2EISSu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 14:18:50 -0400
Message-ID: <1336587377.16730.150.camel@misato.fc.hp.com>
Subject: Re: [PATCH v2 3/7] ACPI: Add _OST support for sysfs eject
From: Toshi Kani <toshi.kani@hp.com>
To: shuahkhan@gmail.com
Cc: lenb@kernel.org, linux-acpi@vger.kernel.org, bhelgaas@google.com,
        linux-kernel@vger.kernel.org
Date: Wed, 09 May 2012 12:16:17 -0600
In-Reply-To: <1336581973.2498.15.camel@lorien2>
References: <1336507944-10219-1-git-send-email-toshi.kani@hp.com>
	 <1336507944-10219-4-git-send-email-toshi.kani@hp.com>
	 <1336581973.2498.15.camel@lorien2>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-1.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-05-09 at 10:46 -0600, Shuah Khan wrote:
> On Tue, 2012-05-08 at 14:12 -0600, Toshi Kani wrote:
> > Changed acpi_bus_hot_remove_device() to support _OST. This function is
> > also changed to global so that it can be called from hotplug notify
> > handlers to perform hot-remove operation.
> > 
> > Changed acpi_eject_store(), which is the sysfs eject handler. It checks
> > eject_pending to see if the request was originated from ACPI eject
> > notification. If not, it calls _OST(0x103,84,) per Figure 6-37 in ACPI
> > 5.0 spec.
> > 
> > Added eject_pending bit to acpi_device_flags. This bit is set when the
> > kernel has received an ACPI eject notification, but does not initiate
> > its hot-remove operation by itself.
> > 
> > Added struct acpi_eject_event. This structure is used to pass extended
> > information to acpi_bus_hot_remove_device(), which has a single argument
> > to support asynchronous call.
> > 
> > Added macro definitions of _OST source events and status codes.
> > Also renamed OSC_SB_CPUHP_OST_SUPPORT to OSC_SB_HOTPLUG_OST_SUPPORT
> > since this _OSC bit is not specific to CPU hotplug. This bit is
> > defined in Table 6-147 of ACPI 5.0 as follows.
> 
> I am confused. This patch adds lot of new code that is for _OST handling
> without CONFIG_ACPI_HOTPLUG_OST check. Is this intended? Doesn't jive
> with the intent communicated in the [PATCH v2 0/7] introduction.

Yes, it is intended to minimize the use of #ifdefs in order to improve
its code readability and maintainability.  The statement in the [PATCH
v2 0/7] is correct.  When CONFIG_ACPI_HOTPLUG_OST is disabled, there is
no change in the kernel functionality nor in the OS-firmware
interaction.  


> Could you please walk though the steps on what happens with this code on
> a system that doesn't enable _OST and doesn't support _OST. That will
> help me understand how this code would behave on a system that doesn't
> support _OST.

1. CONFIG_ACPI_HOTPLUG_OST disabled
There is no change in the kernel functionality nor in the OS-firmware
interaction.  This case is same whether or not the system supports _OST.

- At boot-time, the kernel calls ACPI Operating System Capabilities
(_OSC) method, if present, with hotplug _OST bit unset. This indicates
that the OS does not support hotplug _OST.
- During a hotplug operation, the OS does not call _OST method because
acpi_evaluate_hotplug_ost() is stubbed out.

2. CONFIG_ACPI_HOTPLUG_OST enabled, but the system does not support _OST

- At boot-time, the kernel calls ACPI _OSC method, if present, with
hotplug _OST bit set. This indicates that the OS supports hotplug _OST.
Firmware ignores this bit since it does not support _OST.
- During a hotplug operation, the OS attempts to call _OST method.
Since _OST method is not present, this _OST call is a no-op
(AE_NOT_FOUND).


Thanks,
-Toshi
 


