Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752760Ab0EQDEN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 May 2010 23:04:13 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:35294 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752209Ab0EQDEK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 May 2010 23:04:10 -0400
Message-ID: <4BF0B1C5.4060601@oracle.com>
Date: Sun, 16 May 2010 20:02:29 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Linux PCI <linux-pci@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Matthew Garrett <mjg@redhat.com>, Greg Kroah-Hartman <gregkh@suse.de>,
       Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [RFC][PATCH] PM / PCI: Update PCI power management documentation
References: <201005162149.31770.rjw@sisk.pl>
In-Reply-To: <201005162149.31770.rjw@sisk.pl>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Auth-Type: Internal IP
X-Source-IP: acsinet15.oracle.com [141.146.126.227]
X-CT-RefId: str=0001.0A090209.4BF0B1E7.00C5:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/16/10 12:49, Rafael J. Wysocki wrote:
> Hi,
> 
> I've just finished rewriting the PCI PM documentation.  I hope I didn't forget
> of anything important, so please let me know if I did.
> 
> Generally, please let me know what you think.

Hi,

It reads pretty well IMO.

I have corrected several typos etc.
I have also noted a need for explaining *why* something is being done,
not just what is being done.  There may be a few other places where
some justification is needed (i.e., would be helpful).


> Thanks,
> Rafael
> 
> ---
> From: Rafael J. Wysocki <rjw@sisk.pl>
> 
> The PCI power management document, Documentation/power/pci.txt, is
> outdated and partially inaccurate.  It also is missing some important
> information about the power management of PCI device.  Rewrite it to
> make it more up to date and more complete.
> 
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> ---
>  Documentation/power/pci.txt | 1306 ++++++++++++++++++++++++++++++++++----------
>  1 file changed, 1015 insertions(+), 291 deletions(-)
> 
> Index: linux-2.6/Documentation/power/pci.txt
> ===================================================================
> --- linux-2.6.orig/Documentation/power/pci.txt
> +++ linux-2.6/Documentation/power/pci.txt
> +1. Hardware and Platform Support for PCI Power Management
> +2. PCI Subsystem and Device Power Management
> +3. PCI Device Drivers and Power Management
> +4. Resources
> +
> +
> +1. Hardware and Platform Support for PCI Power Management
> +=========================================================
> +
> +1.1. Native and Platform-Based Power Management
> +-----------------------------------------------
...

> +Devices supporting the native PCI PM ususally can generate wakeup signals called

                                        usually

> +Power Management Events (PMEs) to let the kernel know about external events
> +requiring the device to be active.  After receiving a PME the kernel is supposed
> +to put the device that sent it into the full-power state.  However, the PCI Bus
> +Power Management Interface Specification doesn't define any standard method of
> +delivering the PME from the device to the CPU and the operating system kernel.
> +It is assumed that the platform firmware will perform this task and therefore,
> +even though a PCI device is set up to generate PMEs, it also may be necessary to
> +prepare the platform firmware for notifying the CPU of the PMEs coming from the
> +device (e.g. by generating interrupts).
> +
> +In turn, if the methods provided by the platform firmware are used for changing
> +the power state of a device, usually the platform also provides a method for
> +preparing the device to generate wakeup signals.  In that cases, however, it

                                                             case,

> +often also is necessary to prepare the device for generating PMEs using the
> +native PCI PM mechanism, because the method provided by the platform depends on
> +that.
> +
> +Thus in many situations both the native and the platform-based power management
> +mechanisms have to be used simultaneously to obtain the desired result.
> +
> +1.2. Native PCI Power Management
> +--------------------------------

...
> +
> +1.3. ACPI Device Power Management
> +---------------------------------
...
> +
> +1.4. Wakeup Signaling
> +---------------------
> +Wakeup signals generated by PCI devices, either as native PCI PMEs, or as
> +a result of the execution of the _DSW (or _PSW) ACPI control method before
> +putting the device into a low-power state, have to be caught and handled as
> +appropriate.  If they are sent while the system is in the working state
> +(ACPI S0), they should be translated into interrupts so that the kernel can
> +put the devices generating them into the full-power state and take care of the
> +events that triggered them.  In turn, if they are send while the system is

                                                     sent

> +sleeping, they should cause the system's core logic to trigger wakeup.
> +
...

> +In principle the native PCI Express PME signaling may also be used on ACPI-based
> +systems along with the GPEs, but to use it the kernel has to ask the system's
> +ACPI BIOS to release control of root port configuration registers.  The ACPI
> +BIOS, however, is not required to allow the kernel to control these registers
> +and if it doesn't do that, the kernel must not modify their contents.  Of course
> +the native PCI Express PME signaling cannot be used by the kernel in that cases.

                                                                             case.

> +
> +
> +2. PCI Subsystem and Device Power Management
> +============================================
> +
> +2.1. Device Power Management Callbacks
> +--------------------------------------
> +The PCI Subsystem participates in the power management of PCI devices in a
> +number of ways.  First of all, it provides an intermediate code layer between
> +the device power managemen core (PM core) and PCI device drivers.  Specifically,

                    management

> +the pm field of the PCI subsystem's struct bus_type object, pci_bus_type, points
> +to a struct dev_pm_ops object, pci_dev_pm_ops, containing pointers to several
> +device power management callbacks:
> +
> +const struct dev_pm_ops pci_dev_pm_ops = {
...

> +
> +2.2. Device Initialization
> +--------------------------
> +The first PCI subsystem's task related to device power management is to

   The PCI subsystem's first task related to ...

> +prepare the device for power management and initialize the fields of struct
> +pci_dev used for this purpose.  This happens in two functions defined in
> +drivers/pci/pci.c, pci_pm_init() and platform_pci_wakeup_init().
> +
...
> +2.3. Runtime Device Power Management
> +------------------------------------
...
> +2.4. System-Wide Power Transitions
> +----------------------------------
...
> +2.4.2. System Resume
> +
...

> +2.4.3. System Hibernation
...

To a first-time reader, the hibernation sequence described here can be
confusing:

+Once the image has been created, it has to be saved.  For this purpose devices
+are activated in the following phases:
+
+	thaw_noirq, thaw, complete
+
+using the following PCI bus type's callbacks:
+
+	pci_pm_thaw_noirq()
+	pci_pm_thaw()
+	pci_pm_complete()
+
+respectively.


This can be confusing because the system is attempting to hibernate/power down,
but here we are thawing devices.  I think that the thing that is missing here
is "why" this is done.  I'm pretty sure that I know, but some people might not know,
so I think that a small amount of "why" needs to be added here.

> +2.4.4. System Restore
> +
...
> +If the pre-hibernation memory contents are restored successfully, which is the
> +usual situation, control is passed to the image kernel, which then becomes
> +responsible for bringing the system back to the working state.  To achieve this,
> +it must restore the devices' pre-hibernation functionality, which is done much
> +like waking up from the memory sleep state, although it involves different
> +phases:
> +
> +	restore_noirq, restore, complete
> +
> +The first two of them are analogous to the resume_noirq and resume phases

                    these

> +described above, respectively, and correspond to the following PCI subsystem
> +callbacks:
> +
> +	pci_pm_restore_noirq()
> +	pci_pm_restore()
> +
> +These callbacks work in analogy with pci_pm_resume_noirq() and pci_pm_resume(),
> +respectively, but they execute the device driver's pm->restore_noirq() and
> +pm->restore() callbacks, if available.
> +
> +The complete phase is carried out in exactly the same way as during system
> +resume.
> +
> +
> +3. PCI Device Drivers and Power Management
> +==========================================
> +
> +3.1. Power Management Callbacks
> +-------------------------------
...

> +3.1.1. prepare()
> +
> +The prepare() callback is executed during system suspend, during hibernation
> +(i.e. when hibernation image is about to be created), during power-off after

         when a hibernation image

> +saving a hibernation image and during system restore, when hibernation image

                                                         when a hibernation image

> +has just been loaded into memory.
> +
> +This callback is only necessary if the driver's device has children that in
> +general may be registered at any time.  In that cases the role of the prepare()

                                                   case

> +callback is to prevent new children of the device from being registered until
> +one of the resume_noirq(), thaw_noirq(), or restore_noirq() callbacks is run.
> +
...

> +
> +3.1.2. suspend()
> +

...
> +
> +3.1.3. suspend_noirq()
> +
...

> +
> +3.1.4. freeze()
> +
> +The freeze() callback is hibernation-specific and is executed in two situations,
> +during hibernation, after prepare() callbacks have been executed for all devices
> +in preparation for the creation of a system image, and during restore,
> +after a system image has been loaded into memory from persistent storage and the
> +prepare() callbacks have been executed for all devices.
> +
> +The role of this callback is analogous to the role of the suspend() callback
> +described above.  In fact, they only need to be different in the rare cases when
> +the driver takes the responsibility for putting the device into a low-power
>  state.
>  
> +In that cases the freeze() callback should not prepare the device system wakeup

           case

> +or put it into a low-power state.  Still, either it or freeze_noirq() should
> +save the device's standard configuration registers using pci_save_state().
> +
> +3.1.5. freeze_noirq()
> +
...

> +
> +3.1.6. poweroff()
> +
...

> +3.1.7. poweroff_noirq()
> +
> +The poweroff() callback is hibernation-specific.  It is executed after

       poweroff_noirq()

> +poweroff() callbacks have been executed for all devices in the system.
> +
> +The role of this callback is analogous to the role of the suspend_noirq() and
> +freeze_noirq() callbacks described above, but it does not need to save the
> +contents of the device's registers.
> +
> +The difference between poweroff_noirq() and poweroff() is analogous to the
> +difference between suspend_noirq() and suspend().
> +
> +3.1.8. resume_noirq()
> +
...

> +
> +3.1.9. resume()
> +
...

> +
> +3.1.10. thaw_noirq()
> +
...

> +
> +3.1.11. thaw()
> +
...

> +
> +3.1.12. restore_noirq()
> +
...

> +
> +3.1.13. restore()
> +
...

> +
> +3.1.14. complete()
> +
...

> +
> +3.1.15. runtime_suspend()
> +
...

> +
> +3.1.16. runtime_resume()
> +
> +The runtime_suspend() callback is specific to device runtime PM.  It is executed

       runtime_resume()

> +by the PM core's runtime PM framework when the device is about to be resumed
> +(i.e. put into the full-power state and programmed to process I/O normally) at
> +run time.
> +
> +This callback is responsible for restoring the normal functionality of the
> +device after it has been put into the full-power state by the PCI subsystem.
> +The device is expected to be able to process I/O in the usual way after
> +runtime_resume() has returned.
> +
> +3.1.17. runtime_idle()
> +
...

> +
> +3.1.18. Pointing Multiple Callback Pointers to One Routine
> +
...

> +
> +3.2. Device Runtime Power Management
> +------------------------------------
...

> +The runtime PM of PCI devices is disabled by default.  It is also blocked by
> +pci_pm_init() that runs the pm_runtime_forbid() helper function.  If a PCI
> +driver implements the runtime PM callbacks and intends to use the runtime PM
> +framework provided by the PM core and the PCI subsystem, it should enable this
> +feature by executing the pm_runtime_enable() helper function.  However, the
> +driver should not call the pm_runtime_allow() helper function unblocking
> +the runtime PM of the device.  Instead, it should allow user space or some
> +platform-specific code to do that, although once it has called

how would userspace do that?  via sysfs or some other way?

> +pm_runtime_enable(), it must be prepared to handle the runtime PM of the device
> +correctly as soon as pm_runtime_allow() is called (which may happen at any
> +time).  [It also is possible that user space causes pm_runtime_allow() to be
> +called via sysfs before the driver is loaded, so in fact the driver has to be
> +prepared to handle the runtime PM of the device as soon as it calls
> +pm_runtime_enable().]
> +
...


-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
