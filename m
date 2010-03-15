Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936663Ab0COUBn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Mar 2010 16:01:43 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:37770 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936641Ab0COUBk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Mar 2010 16:01:40 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Randy Dunlap <rdunlap@xenotime.net>
Subject: Re: [linux-pm] [RFC][PATCH] PM: Update device power management document
Date: Mon, 15 Mar 2010 21:04:24 +0100
User-Agent: KMail/1.12.4 (Linux/2.6.34-rc1-rjw; KDE/4.3.5; x86_64; ; )
Cc: pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
References: <201003142103.19420.rjw@sisk.pl> <4B9DA9F4.7040906@xenotime.net>
In-Reply-To: <4B9DA9F4.7040906@xenotime.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201003152104.24882.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 15 March 2010, Randy Dunlap wrote:
> On 03/14/10 13:03, Rafael J. Wysocki wrote:
> > From: Rafael J. Wysocki <rjw@sisk.pl>
> > 
> > The device PM document, Documentation/power/devices.txt, is badly
> > outdated and requires total rework to fit the current design of the
> > PM framework.  Make it more up to date.
> > 
> > Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> > ---
> > This has been promised for a long time, but the interface has been changing
> > so that it's been a moving target.  Since I hope it'll stabilize now, here it
> > goes.
> > 
> > Please let me know if you find any problems.  I have read it for a few times
> > already, so I'm afraid I won't find any even if they are present.
> > 
> > Enjoy!
> > 
> > Rafael
> > ---
> >  Documentation/power/devices.txt |  721 ++++++++++++++++++++++++----------------
> >  1 file changed, 442 insertions(+), 279 deletions(-)
> > 
> > Index: linux-2.6/Documentation/power/devices.txt
> > ===================================================================
> > --- linux-2.6.orig/Documentation/power/devices.txt
> > +++ linux-2.6/Documentation/power/devices.txt
> > @@ -1,3 +1,7 @@
> > +Device Power Management
> > +
> > +(C) 2010 Rafael J. Wysocki <rjw@sisk.pl>, Novell Inc.
> > +
> >  Most of the code in Linux is device drivers, so most of the Linux power
> >  management code is also driver-specific.  Most drivers will do very little;
> >  others, especially for platforms with small batteries (like cell phones),
> > @@ -25,31 +29,39 @@ states:
> >  	them without loss of data.
> >  
> >  	Some drivers can manage hardware wakeup events, which make the system
> > -	leave that low-power state.  This feature may be disabled using the
> > -	relevant /sys/devices/.../power/wakeup file; enabling it may cost some
> > -	power usage, but let the whole system enter low power states more often.
> > +	leave that low-power state.  This feature may be enabled or disabled
> > +	using the relevant /sys/devices/.../power/wakeup file (for Ethernet
> > +	drivers the ioctl interface used by ethtool may also be used for this
> > +	purpose); enabling it may cost some power usage, but let the whole
> > +	system enter low power states more often.
> >  
> >      Runtime Power Management model:
> > -	Drivers may also enter low power states while the system is running,
> > -	independently of other power management activity.  Upstream drivers
> > -	will normally not know (or care) if the device is in some low power
> > -	state when issuing requests; the driver will auto-resume anything
> > -	that's needed when it gets a request.
> > -
> > -	This doesn't have, or need much infrastructure; it's just something you
> > -	should do when writing your drivers.  For example, clk_disable() unused
> > -	clocks as part of minimizing power drain for currently-unused hardware.
> > -	Of course, sometimes clusters of drivers will collaborate with each
> > -	other, which could involve task-specific power management.
> > +	Devices may also be put into low power states while the system is
> > +	running, independently of other power management activity in principle.
> > +	However, devices are not generally independent of each other (for
> > +	example, parent device cannot be suspended unless all of its child
> > +	devices have been suspended).  Moreover,  depending on the bus type the
> > +	device is on, it may be necessary to carry some bus-specific operations
> 
> 	                                     carry out (?)

Yes, that was the intention.

Thanks for the comments, I did my best to address them all.

Updated patch is appended.

Rafael

---
From: Rafael J. Wysocki <rjw@sisk.pl>
Subject: PM: Update device power management document

The device PM document, Documentation/power/devices.txt, is badly
outdated and requires total rework to fit the current design of the
PM framework.  Make it more up to date.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 Documentation/power/devices.txt |  722 ++++++++++++++++++++++++----------------
 1 file changed, 443 insertions(+), 279 deletions(-)

Index: linux-2.6/Documentation/power/devices.txt
===================================================================
--- linux-2.6.orig/Documentation/power/devices.txt
+++ linux-2.6/Documentation/power/devices.txt
@@ -1,3 +1,7 @@
+Device Power Management
+
+(C) 2010 Rafael J. Wysocki <rjw@sisk.pl>, Novell Inc.
+
 Most of the code in Linux is device drivers, so most of the Linux power
 management code is also driver-specific.  Most drivers will do very little;
 others, especially for platforms with small batteries (like cell phones),
@@ -25,31 +29,39 @@ states:
 	them without loss of data.
 
 	Some drivers can manage hardware wakeup events, which make the system
-	leave that low-power state.  This feature may be disabled using the
-	relevant /sys/devices/.../power/wakeup file; enabling it may cost some
-	power usage, but let the whole system enter low power states more often.
+	leave that low-power state.  This feature may be enabled or disabled
+	using the relevant /sys/devices/.../power/wakeup file (for Ethernet
+	drivers the ioctl interface used by ethtool may also be used for this
+	purpose); enabling it may cost some power usage, but let the whole
+	system enter low power states more often.
 
     Runtime Power Management model:
-	Drivers may also enter low power states while the system is running,
-	independently of other power management activity.  Upstream drivers
-	will normally not know (or care) if the device is in some low power
-	state when issuing requests; the driver will auto-resume anything
-	that's needed when it gets a request.
-
-	This doesn't have, or need much infrastructure; it's just something you
-	should do when writing your drivers.  For example, clk_disable() unused
-	clocks as part of minimizing power drain for currently-unused hardware.
-	Of course, sometimes clusters of drivers will collaborate with each
-	other, which could involve task-specific power management.
+	Devices may also be put into low power states while the system is
+	running, independently of other power management activity in principle.
+	However, devices are not generally independent of each other (for
+	example, parent device cannot be suspended unless all of its child
+	devices have been suspended).  Moreover,  depending on the bus type the
+	device is on, it may be necessary to carry out some bus-specific
+	operations on the device for this purpose.  Also, devices put into low
+	power states at run time may require special handling during system-wide
+	power transitions, like suspend to RAM.
+
+	For these reasons not only the device driver itself, but also the
+	appropriate subsystem (bus type, device type or device class) driver
+	and the PM core are involved in the runtime power management of devices.
+	Like in the system sleep power management case, they need to collaborate
+	by implementing various role-specific suspend and resume methods, so
+	that the hardware is cleanly powered down and reactivated without data
+	or service loss.
 
 There's not a lot to be said about those low power states except that they
 are very system-specific, and often device-specific.  Also, that if enough
-drivers put themselves into low power states (at "runtime"), the effect may be
-the same as entering some system-wide low-power state (system sleep) ... and
-that synergies exist, so that several drivers using runtime pm might put the
+devices have been put into low power states (at "run time"), the effect may be
+very similar to entering some system-wide low-power state (system sleep) ... and
+that synergies exist, so that several drivers using runtime PM might put the
 system into a state where even deeper power saving options are available.
 
-Most suspended devices will have quiesced all I/O:  no more DMA or irqs, no
+Most suspended devices will have quiesced all I/O:  no more DMA or IRQs, no
 more data read or written, and requests from upstream drivers are no longer
 accepted.  A given bus or platform may have different requirements though.
 
@@ -60,34 +72,67 @@ or removal (for PCMCIA, MMC/SD, USB, and
 
 Interfaces for Entering System Sleep States
 ===========================================
-Most of the programming interfaces a device driver needs to know about
-relate to that first model:  entering a system-wide low power state,
-rather than just minimizing power consumption by one device.
+There are programming interfaces provided for subsystem (bus type, device type,
+device class) and device drivers in order to allow them to participate in the
+power management of devices they are concerned with.  They cover the system
+sleep power management as well as the runtime power management of devices.
+
+
+Device Power Management Operations
+----------------------------------
+Device power management operations, at the subsystem level as well as at the
+device driver level, are implemented by defining and populating objects of type
+struct dev_pm_ops:
+
+struct dev_pm_ops {
+	int (*prepare)(struct device *dev);
+	void (*complete)(struct device *dev);
+	int (*suspend)(struct device *dev);
+	int (*resume)(struct device *dev);
+	int (*freeze)(struct device *dev);
+	int (*thaw)(struct device *dev);
+	int (*poweroff)(struct device *dev);
+	int (*restore)(struct device *dev);
+	int (*suspend_noirq)(struct device *dev);
+	int (*resume_noirq)(struct device *dev);
+	int (*freeze_noirq)(struct device *dev);
+	int (*thaw_noirq)(struct device *dev);
+	int (*poweroff_noirq)(struct device *dev);
+	int (*restore_noirq)(struct device *dev);
+	int (*runtime_suspend)(struct device *dev);
+	int (*runtime_resume)(struct device *dev);
+	int (*runtime_idle)(struct device *dev);
+};
 
+This structure is defined in include/linux/pm.h and the methods included in it
+are also described in that file.  Their roles will be explained in what follows.
+For now, it should be sufficient to remember that the last three of them are
+specific to runtime power management, while the remaining ones are used during
+system-wide power transitions.
+
+There also is an "old" or "legacy", deprecated way of implementing power
+management operations available at least for some subsystems.  This approach
+does not use struct dev_pm_ops objects and it only is suitable for implementing
+system sleep power management methods.  Therefore it is not described in this
+document, so please refer directly to the source code for more information about
+it.
 
-Bus Driver Methods
-------------------
-The core methods to suspend and resume devices reside in struct bus_type.
-These are mostly of interest to people writing infrastructure for busses
-like PCI or USB, or because they define the primitives that device drivers
-may need to apply in domain-specific ways to their devices:
-
-struct bus_type {
-	...
-	int  (*suspend)(struct device *dev, pm_message_t state);
-	int  (*resume)(struct device *dev);
-};
 
-Bus drivers implement those methods as appropriate for the hardware and
+Subsystem-Level Methods
+-----------------------
+The core methods to suspend and resume devices reside in struct dev_pm_ops
+pointed to by the pm member of struct bus_type, struct device_type and
+struct class.  They are mostly of interest to the people writing infrastructure
+for buses, like PCI or USB, or device type and device class drivers.
+
+Bus drivers implement these methods as appropriate for the hardware and
 the drivers using it; PCI works differently from USB, and so on.  Not many
-people write bus drivers; most driver code is a "device driver" that
+people write subsystem-level drivers; most driver code is a "device driver" that
 builds on top of bus-specific framework code.
 
 For more information on these driver calls, see the description later;
 they are called in phases for every device, respecting the parent-child
-sequencing in the driver model tree.  Note that as this is being written,
-only the suspend() and resume() are widely available; not many bus drivers
-leverage all of those phases, or pass them down to lower driver levels.
+sequencing in the driver model tree.
 
 
 /sys/devices/.../power/wakeup files
@@ -95,7 +140,7 @@ leverage all of those phases, or pass th
 All devices in the driver model have two flags to control handling of
 wakeup events, which are hardware signals that can force the device and/or
 system out of a low power state.  These are initialized by bus or device
-driver code using device_init_wakeup(dev,can_wakeup).
+driver code using device_init_wakeup().
 
 The "can_wakeup" flag just records whether the device (and its driver) can
 physically support wakeup events.  When that flag is clear, the sysfs
@@ -103,64 +148,44 @@ physically support wakeup events.  When 
 
 For devices that can issue wakeup events, a separate flag controls whether
 that device should try to use its wakeup mechanism.  The initial value of
-device_may_wakeup() will be true, so that the device's "wakeup" file holds
-the value "enabled".  Userspace can change that to "disabled" so that
-device_may_wakeup() returns false; or change it back to "enabled" (so that
-it returns true again).
+device_may_wakeup() will be false for the majority of devices, except for
+power buttons, keyboards, and Ethernet adapters whose WoL (wake-on-LAN) feature
+has been set up with ethtool.  Thus in the majority of cases the device's
+"wakeup" file will initially hold the value "disabled".  Userspace can change
+that to "enabled", so that device_may_wakeup() returns true, or change it back
+to "disabled", so that it returns false again.
+
+
+/sys/devices/.../power/control files
+------------------------------------
+All devices in the driver model have a flag to control the desired behavior of
+its driver with respect to runtime power management.  This flag, called
+runtime_auto, is initialized by the bus type (or generally subsystem) code using
+pm_runtime_allow() or pm_runtime_forbid(), depending on whether or not the
+driver is supposed to power manage the device at run time by default,
+respectively.
+
+This setting may be adjusted by user space by writing either "on" or "auto" to
+the device's "control" file.  If "auto" is written, the device's runtime_auto
+flag will be set and the driver will be allowed to power manage the device if
+capable of doing that.  If "on" is written, the driver is not allowed to power
+manage the device which in turn is supposed to remain in the full power state at
+run time.  User space can check the current value of the runtime_auto flag by
+reading from the device's "control" file.
+
+The device's runtime_auto flag has no effect on the handling of system-wide
+power transitions by its driver.  In particular, the device can (and in the
+majority of cases should and will) be put into a low power state during a
+system-wide transition to a sleep state (like "suspend-to-RAM") even though its
+runtime_auto flag is unset (in which case its "control" file contains "on").
 
-
-EXAMPLE:  PCI Device Driver Methods
------------------------------------
-PCI framework software calls these methods when the PCI device driver bound
-to a device device has provided them:
-
-struct pci_driver {
-	...
-	int  (*suspend)(struct pci_device *pdev, pm_message_t state);
-	int  (*suspend_late)(struct pci_device *pdev, pm_message_t state);
-
-	int  (*resume_early)(struct pci_device *pdev);
-	int  (*resume)(struct pci_device *pdev);
-};
-
-Drivers will implement those methods, and call PCI-specific procedures
-like pci_set_power_state(), pci_enable_wake(), pci_save_state(), and
-pci_restore_state() to manage PCI-specific mechanisms.  (PCI config space
-could be saved during driver probe, if it weren't for the fact that some
-systems rely on userspace tweaking using setpci.)  Devices are suspended
-before their bridges enter low power states, and likewise bridges resume
-before their devices.
-
-
-Upper Layers of Driver Stacks
------------------------------
-Device drivers generally have at least two interfaces, and the methods
-sketched above are the ones which apply to the lower level (nearer PCI, USB,
-or other bus hardware).  The network and block layers are examples of upper
-level interfaces, as is a character device talking to userspace.
-
-Power management requests normally need to flow through those upper levels,
-which often use domain-oriented requests like "blank that screen".  In
-some cases those upper levels will have power management intelligence that
-relates to end-user activity, or other devices that work in cooperation.
-
-When those interfaces are structured using class interfaces, there is a
-standard way to have the upper layer stop issuing requests to a given
-class device (and restart later):
-
-struct class {
-	...
-	int  (*suspend)(struct device *dev, pm_message_t state);
-	int  (*resume)(struct device *dev);
-};
-
-Those calls are issued in specific phases of the process by which the
-system enters a low power "suspend" state, or resumes from it.
+For more information about the runtime power management framework for devices
+refer to Documentation/power/runtime_pm.txt.
 
 
 Calling Drivers to Enter System Sleep States
 ============================================
-When the system enters a low power state, each device's driver is asked
+When the system goes into a sleep state, each device's driver is asked
 to suspend the device by putting it into state compatible with the target
 system state.  That's usually some version of "off", but the details are
 system-specific.  Also, wakeup-enabled devices will usually stay partly
@@ -175,14 +200,13 @@ and then turn its hardware as "off" as p
 matching resume calls would then completely reinitialize the hardware
 before reactivating its class I/O queues.
 
-More power-aware drivers drivers will use more than one device low power
-state, either at runtime or during system sleep states, and might trigger
-system wakeup events.
+More power-aware drivers might prepare the devices for triggering system wakeup
+events.
 
 
 Call Sequence Guarantees
 ------------------------
-To ensure that bridges and similar links needed to talk to a device are
+To ensure that bridges and similar links needing to talk to a device are
 available when the device is suspended or resumed, the device tree is
 walked in a bottom-up order to suspend devices.  A top-down order is
 used to resume those devices.
@@ -194,7 +218,7 @@ its parent; and can't be removed or susp
 The policy is that the device tree should match hardware bus topology.
 (Or at least the control bus, for devices which use multiple busses.)
 In particular, this means that a device registration may fail if the parent of
-the device is suspending (ie. has been chosen by the PM core as the next
+the device is suspending (i.e. has been chosen by the PM core as the next
 device to suspend) or has already suspended, as well as after all of the other
 devices have been suspended.  Device drivers must be prepared to cope with such
 situations.
@@ -207,54 +231,166 @@ system always includes every phase, exec
 before the next phase begins.  Not all busses or classes support all
 these callbacks; and not all drivers use all the callbacks.
 
-The phases are seen by driver notifications issued in this order:
-
-   1	class.suspend(dev, message) is called after tasks are frozen, for
-	devices associated with a class that has such a method.  This
-	method may sleep.
-
-	Since I/O activity usually comes from such higher layers, this is
-	a good place to quiesce all drivers of a given type (and keep such
-	code out of those drivers).
-
-   2	bus.suspend(dev, message) is called next.  This method may sleep,
-	and is often morphed into a device driver call with bus-specific
-	parameters and/or rules.
-
-	This call should handle parts of device suspend logic that require
-	sleeping.  It probably does work to quiesce the device which hasn't
-	been abstracted into class.suspend().
-
-The pm_message_t parameter is currently used to refine those semantics
-(described later).
+Generally, different callbacks are used depending on whether the system is
+going to the standby or memory sleep state ("suspend-to-RAM") or it is going to
+be hibernated ("suspend-to-disk").
+
+If the system goes to the standby or memory sleep state the phases are seen by
+driver notifications issued in this order:
+
+   1	bus->pm.prepare(dev) is called after tasks are frozen and it is supposed
+	to call the device driver's ->pm.prepare() method.
+
+	The purpose of this method is mainly to prevent new children of the
+	device from being registered after it has returned.  It also may be used
+	to generally prepare the device for the upcoming system transition, but
+	it should not put the device into a low power state.
+
+   2	class->pm.suspend(dev) is called if dev is associated with a class that
+	has such a method.  It may invoke the device driver's ->pm.suspend()
+	method, unless type->pm.suspend(dev) or bus->pm.suspend() does that.
+
+   3	type->pm.suspend(dev) is called if dev is associated with a device type
+	that has such a method.  It may invoke the device driver's
+	->pm.suspend() method, unless class->pm.suspend(dev) or
+	bus->pm.suspend() does that.
+
+   4	bus->pm.suspend(dev) is called, if implemented.  It usually calls the
+	device driver's ->pm.suspend() method.
+
+	This call should generally quiesce the device so that it doesn't do any
+	I/O after the call has returned.  It also may save the device registers
+	and put it into the appropriate low power state, depending on the bus
+	type the device is on.
+
+   5	bus->pm.suspend_noirq(dev) is called, if implemented.  It may call the
+	device driver's ->pm.suspend_noirq() method, depending on the bus type
+	in question.
+
+	This method is invoked after device interrupts have been suspended,
+	which means that the driver's interrupt handler will not be called
+	while it is running.  It should save the values of the device's
+	registers that weren't saved previously and finally put the device into
+	the appropriate low power state.
+
+	The majority of subsystems and device drivers need not implement this
+	method.  However, bus types allowing devices to share interrupt vectors,
+	like PCI, generally need to use it to prevent interrupt handling issues
+	from happening during suspend.
 
 At the end of those phases, drivers should normally have stopped all I/O
 transactions (DMA, IRQs), saved enough state that they can re-initialize
 or restore previous state (as needed by the hardware), and placed the
 device into a low-power state.  On many platforms they will also use
-clk_disable() to gate off one or more clock sources; sometimes they will
-also switch off power supplies, or reduce voltages.  Drivers which have
-runtime PM support may already have performed some or all of the steps
-needed to prepare for the upcoming system sleep state.
-
-When any driver sees that its device_can_wakeup(dev), it should make sure
-to use the relevant hardware signals to trigger a system wakeup event.
-For example, enable_irq_wake() might identify GPIO signals hooked up to
-a switch or other external hardware, and pci_enable_wake() does something
-similar for PCI's PME# signal.
-
-If a driver (or bus, or class) fails it suspend method, the system won't
-enter the desired low power state; it will resume all the devices it's
-suspended so far.
-
-Note that drivers may need to perform different actions based on the target
-system lowpower/sleep state.  At this writing, there are only platform
-specific APIs through which drivers could determine those target states.
+gate off one or more clock sources; sometimes they will also switch off power
+supplies, or reduce voltages.  [Drivers supporting runtime PM may already have
+performed some or all of the steps needed to prepare for the upcoming system
+state transition.]
+
+If device_may_wakeup(dev) returns true, the device should be prepared for
+generating hardware wakeup signals when the system is in the sleep state to
+trigger a system wakeup event.  For example, enable_irq_wake() might identify
+GPIO signals hooked up to a switch or other external hardware, and
+pci_enable_wake() does something similar for the PCI PME signal.
+
+If a driver (or subsystem) fails it suspend method, the system won't enter the
+desired low power state; it will resume all the devices it's suspended so far.
+
+
+Hibernation Phases
+------------------
+Hibernating the system is more complicated than putting it into the standby or
+memory sleep state, because it involves creating a system image and saving it.
+Therefore there are more phases of hibernation and special device PM methods are
+used in this case.
+
+First, it is necessary to prepare the system for creating a hibernation image.
+This is similar to putting the system into the standby or memory sleep state,
+although it generally doesn't require that devices be put into low power states
+(that is even not desirable at this point).  Driver notifications are then
+issued in the following order:
+
+   1	bus->pm.prepare(dev) is called after tasks have been frozen and enough
+	memory has been freed.
+
+   2	class->pm.freeze(dev) is called if implemented.  It may invoke the
+        device driver's ->pm.freeze() method, unless type->pm.freeze(dev) or
+        bus->pm.freeze() does that.
+
+   3	type->pm.freeze(dev) is called if implemented.  It may invoke the device
+	driver's ->pm.suspend() method, unless class->pm.freeze(dev) or
+	bus->pm.freeze() does that.
+
+   4	bus->pm.freeze(dev) is called, if implemented.  It usually calls the
+	device driver's ->pm.freeze() method.
+
+   5	bus->pm.freeze_noirq(dev) is called, if implemented.  It may call the
+	device driver's ->pm.freeze_noirq() method, depending on the bus type
+	in question.
+
+The difference between ->pm.freeze() and the corresponding ->pm.suspend() (and
+similarly for the "noirq" variants) is that the former should avoid preparing
+devices to trigger system wakeup events and putting devices into low power
+states, although they generally have to save the values of device registers
+so that it's possible to restore them during system resume.
+
+Second, after the system image has been created, the functionality of devices
+has to be restored so that the image can be saved.  That is similar to resuming
+devices after the system has been woken up from the standby or memory sleep
+state, which is described below, and causes the following device notifications
+to be issued:
+
+   1	bus->pm.thaw_noirq(dev), if implemented; may call the device driver's
+	->pm.thaw_noirq() method, depending on the bus type in question.
+
+   2	bus->pm.thaw(dev), if implemented; usually calls the device driver's
+	->pm.thaw() method.
+
+   3	type->pm.thaw(dev), if implemented; may call the device driver's
+	->pm.thaw() method if not called by the bus type or class.
+
+   4	class->pm.thaw(dev), if implemented; may call the device driver's
+	->pm.thaw() method if not called by the bus type or device type.
+
+   5	bus->pm.complete(dev), if implemented; may call the device driver's
+	->pm.complete() method.
+
+Generally, the role of the ->pm.thaw() methods (including the "noirq" variants)
+is to bring the device back to the fully functional state, so that it may be
+used for saving the image, if necessary.  The role of bus->pm.complete() is to
+reverse whatever bus->pm.prepare() did (likewise for the analogous device driver
+callbacks).
+
+After the image has been saved, the devices need to be prepared for putting the
+system into the low power state.  That is analogous to suspending them before
+putting the system into the standby or memory sleep state and involves the
+following device notifications:
+
+   1	bus->pm.prepare(dev).
+
+   2	class->pm.poweroff(dev), if implemented; may invoke the device driver's
+   	->pm.poweroff() method if not called by the bus type or device type.
+
+   3	type->pm.poweroff(dev), if implemented; may invoke the device driver's
+   	->pm.poweroff() method if not called by the bus type or device class.
+
+   4	bus->pm.poweroff(dev), if implemented; usually calls the device driver's
+   	->pm.poweroff() method (if not called by the device class or type).
+
+   5	bus->pm.poweroff_noirq(dev), if implemented; may call the device
+	driver's ->pm.poweroff_noirq() method, depending on the bus type
+	in question.
+
+The difference between ->pm.poweroff() and the corresponding ->pm.suspend() (and
+analogously for the "noirq" variants) is that the former need not save the
+device's registers.  Still, they should prepare the device for triggering
+system wakeup events if necessary and finally put it into the appropriate low
+power state.
 
 
 Device Low Power (suspend) States
 ---------------------------------
-Device low-power states aren't very standard.  One device might only handle
+Device low-power states aren't standard.  One device might only handle
 "on" and "off, while another might support a dozen different versions of
 "on" (how many engines are active?), plus a state that gets back to "on"
 faster than from a full "off".
@@ -265,7 +401,7 @@ PCI device may not perform DMA or issue 
 issues would be issued through the PME# bus signal.  Plus, there are
 several PCI-standard device states, some of which are optional.
 
-In contrast, integrated system-on-chip processors often use irqs as the
+In contrast, integrated system-on-chip processors often use IRQs as the
 wakeup event sources (so drivers would call enable_irq_wake) and might
 be able to treat DMA completion as a wakeup event (sometimes DMA can stay
 active too, it'd only be the CPU and some peripherals that sleep).
@@ -284,84 +420,86 @@ ways; the aforementioned LCD might be ac
 but a different product using the same SOC might work differently.
 
 
-Meaning of pm_message_t.event
------------------------------
-Parameters to suspend calls include the device affected and a message of
-type pm_message_t, which has one field:  the event.  If driver does not
-recognize the event code, suspend calls may abort the request and return
-a negative errno.  However, most drivers will be fine if they implement
-PM_EVENT_SUSPEND semantics for all messages.
-
-The event codes are used to refine the goal of suspending the device, and
-mostly matter when creating or resuming system memory image snapshots, as
-used with suspend-to-disk:
-
-    PM_EVENT_SUSPEND -- quiesce the driver and put hardware into a low-power
-	state.  When used with system sleep states like "suspend-to-RAM" or
-	"standby", the upcoming resume() call will often be able to rely on
-	state kept in hardware, or issue system wakeup events.
-
-    PM_EVENT_HIBERNATE -- Put hardware into a low-power state and enable wakeup
-	events as appropriate.  It is only used with hibernation
-	(suspend-to-disk) and few devices are able to wake up the system from
-	this state; most are completely powered off.
-
-    PM_EVENT_FREEZE -- quiesce the driver, but don't necessarily change into
-	any low power mode.  A system snapshot is about to be taken, often
-	followed by a call to the driver's resume() method.  Neither wakeup
-	events nor DMA are allowed.
-
-    PM_EVENT_PRETHAW -- quiesce the driver, knowing that the upcoming resume()
-	will restore a suspend-to-disk snapshot from a different kernel image.
-	Drivers that are smart enough to look at their hardware state during
-	resume() processing need that state to be correct ... a PRETHAW could
-	be used to invalidate that state (by resetting the device), like a
-	shutdown() invocation would before a kexec() or system halt.  Other
-	drivers might handle this the same way as PM_EVENT_FREEZE.  Neither
-	wakeup events nor DMA are allowed.
-
-To enter "standby" (ACPI S1) or "Suspend to RAM" (STR, ACPI S3) states, or
-the similarly named APM states, only PM_EVENT_SUSPEND is used; the other event
-codes are used for hibernation ("Suspend to Disk", STD, ACPI S4).
-
-There's also PM_EVENT_ON, a value which never appears as a suspend event
-but is sometimes used to record the "not suspended" device state.
-
-
 Resuming Devices
 ----------------
 Resuming is done in multiple phases, much like suspending, with all
 devices processing each phase's calls before the next phase begins.
 
-The phases are seen by driver notifications issued in this order:
+Again, however, different callbacks are used depending on whether the system is
+waking up from the standby or memory sleep state ("suspend-to-RAM") or from
+hibernation ("suspend-to-disk").
+
+If the system is waking up from the standby or memory sleep state, the phases
+are seen by driver notifications issued in this order:
+
+   1	bus->pm.resume_noirq(dev) is called, if implemented.  It may call the
+	device driver's ->pm.resume_noirq() method, depending on the bus type in
+	question.
+
+	The role of this method is to perform actions that need to be performed
+	before device drivers' interrupt handlers are allowed to be invoked.  If
+	the given bus type permits devices to share interrupt vectors, like PCI,
+	this method should bring the device and its driver into a state in which
+	the driver can recognize if the device is the source of incoming
+	interrupts, if any, and handle them correctly.
+
+	For example, the PCI bus type's ->pm.resume_noirq() puts the device into
+	the full power state (D0 in the PCI terminology) and restores the
+	standard configuration registers of the device.  Then, it calls the
+	device driver's ->pm.resume_noirq() method to perform device-specific
+	actions needed at this stage of resume.
+
+   2	bus->pm.resume(dev) is called, if implemented.  It usually calls the
+	device driver's ->pm.resume() method.
+
+	This call should generally bring the the device back to the working
+	state, so that it can do I/O as requested after the call has returned.
+	However, it may be more convenient to use the device class or device
+	type ->pm.resume() for this purpose, in which case the bus type's
+	->pm.resume() method need not be implemented at all.
+
+   3	type->pm.resume(dev) is called, if implemented.  It may invoke the
+	device driver's ->pm.resume() method, unless class->pm.resume(dev) or
+	bus->pm.resume() does that.
+
+	For devices that are not associated with any bus type or device class
+	this method plays the role of bus->pm.resume().
+
+   4	class->pm.resume(dev) is called, if implemented.  It may invoke the
+	device driver's ->pm.resume() method, unless bus->pm.resume(dev) or
+	type->pm.resume() does that.
 
-   1	bus.resume(dev) reverses the effects of bus.suspend().  This may
-	be morphed into a device driver call with bus-specific parameters;
-	implementations may sleep.
+	For devices that are not associated with any bus type or device type
+	this method plays the role of bus->pm.resume().
 
-   2	class.resume(dev) is called for devices associated with a class
-	that has such a method.  Implementations may sleep.
+   5	bus->pm.complete(dev) is called, if implemented.  It is supposed to
+	invoke the device driver's ->pm.complete() method.
 
-	This reverses the effects of class.suspend(), and would usually
-	reactivate the device's I/O queue.
+	The role of this method is to reverse whatever bus->pm.prepare(dev)
+	(or the driver's ->pm.prepare()) did during suspend, if necessary.
 
 At the end of those phases, drivers should normally be as functional as
 they were before suspending:  I/O can be performed using DMA and IRQs, and
-the relevant clocks are gated on.  The device need not be "fully on"; it
-might be in a runtime lowpower/suspend state that acts as if it were.
+the relevant clocks are gated on.  In principle the device need not be
+"fully on"; it might be in a runtime lowpower/suspend state during suspend and
+the resume callbacks may try to restore that state, but that need not be
+desirable from the user's point of view.  In fact, there are multiple reasons
+why it's better to always put devices into the "fully working" state in the
+system sleep resume callbacks and they are discussed in more detail in
+Documentation/power/runtime_pm.txt.
 
 However, the details here may again be platform-specific.  For example,
 some systems support multiple "run" states, and the mode in effect at
-the end of resume() might not be the one which preceded suspension.
+the end of resume might not be the one which preceded suspension.
 That means availability of certain clocks or power supplies changed,
 which could easily affect how a driver works.
 
-
 Drivers need to be able to handle hardware which has been reset since the
 suspend methods were called, for example by complete reinitialization.
 This may be the hardest part, and the one most protected by NDA'd documents
 and chip errata.  It's simplest if the hardware state hasn't changed since
-the suspend() was called, but that can't always be guaranteed.
+the suspend was carried out, but that can't be guaranteed (in fact, it ususally
+is not the case).
 
 Drivers must also be prepared to notice that the device has been removed
 while the system was powered off, whenever that's physically possible.
@@ -371,11 +509,76 @@ will notice and handle such removals are
 involve a separate thread.
 
 
-Note that the bus-specific runtime PM wakeup mechanism can exist, and might
-be defined to share some of the same driver code as for system wakeup.  For
-example, a bus-specific device driver's resume() method might be used there,
-so it wouldn't only be called from bus.resume() during system-wide wakeup.
-See bus-specific information about how runtime wakeup events are handled.
+Resume From Hibernation
+-----------------------
+Resuming from hibernation is, again, more complicated than resuming from a sleep
+state in which the contents of main memory are preserved, because it requires
+a system image to be loaded into memory and the pre-hibernation memory contents
+to be restored before control can be passed back to the image kernel.
+
+In principle, the image might be loaded into memory and the pre-hibernation
+memory contents might be restored by the boot loader.  For this purpose,
+however, the boot loader would need to know the image kernel's entry point and
+there's no protocol defined for passing that information to boot loaders.  As
+a workaround, the boot loader loads a fresh instance of the kernel, called the
+boot kernel, into memory and passes control to it in a usual way.  Then, the
+boot kernel reads the hibernation image, restores the pre-hibernation memory
+contents and passes control to the image kernel.  Thus, in fact, two different
+kernels are involved in resuming from hibernation and in general they are not
+only different because they play different roles in this operation.  Actually,
+the boot kernel may be completely different from the image kernel.  Not only
+the configuration of it, but also the version of it may be different.
+The consequences of this are important to device drivers and their subsystems
+(bus types, device classes and device types) too.
+
+Namely, to be able to load the hibernation image into memory, the boot kernel
+needs to include at least the subset of device drivers allowing it to access the
+storage medium containing the image, although it generally doesn't need to
+include all of the drivers included into the image kernel.  After the image has
+been loaded the devices handled by those drivers need to be prepared for passing
+control back to the image kernel.  This is very similar to the preparation of
+devices for creating a hibernation image described above.  In fact, it is done
+in the same way, with the help of the ->pm.prepare(), ->pm.freeze() and
+->pm.freeze_noirq() callbacks, but only for device drivers included in the boot
+kernel (whose versions may generally be different from the versions of the
+analogous drivers from the image kernel).
+
+Should the restoration of the pre-hibernation memory contents fail, the boot
+kernel would carry out the procedure of "thawing" devices described above, using
+the ->pm.thaw_noirq(), ->pm.thaw(), and ->pm.complete() callbacks provided by
+subsystems and device drivers.  This, however, is a very rare condition.  Most
+often the pre-hibernation memory contents are restored successfully and control
+is passed to the image kernel that is now responsible for bringing the system
+back to the working state.
+
+To achieve this goal, among other things, the image kernel restores the
+pre-hibernation functionality of devices.  This operation is analogous to the
+resuming of devices after waking up from the memory sleep state, although it
+involves different device notifications which are the following:
+
+   1	bus->pm.restore_noirq(dev), if implemented; may call the device driver's
+	->pm.restore_noirq() method, depending on the bus type in question.
+
+   2	bus->pm.restore(dev), if implemented; usually calls the device driver's
+	->pm.restore() method.
+
+   3	type->pm.restore(dev), if implemented; may call the device driver's
+	->pm.restore() method if not called by the bus type or class.
+
+   4	class->pm.restore(dev), if implemented; may call the device driver's
+	->pm.restore() method if not called by the bus type or device type.
+
+   5	bus->pm.complete(dev), if implemented; may call the device driver's
+	->pm.complete() method.
+
+The roles of the ->pm.restore_noirq() and ->pm.restore() callbacks are analogous
+to the roles of the corresponding resume callbacks, but they must assume that
+the device may have been accessed before by the boot kernel.  Consequently, the
+state of the device before they are called may be different from the state of it
+right prior to calling the resume callbacks.  That difference usually doesn't
+matter, so the majority of device drivers can set their resume and restore
+callback pointers to the same routine.  Nevertheless, different callback
+pointers are used in case there is a situation where it actually matters.
 
 
 System Devices
@@ -389,10 +592,13 @@ System devices will only be suspended wi
 all other devices have been suspended.  On resume, they will be resumed
 before any other devices, and also with interrupts disabled.
 
-That is, IRQs are disabled, the suspend_late() phase begins, then the
-sysdev_driver.suspend() phase, and the system enters a sleep state.  Then
-the sysdev_driver.resume() phase begins, followed by the resume_early()
-phase, after which IRQs are enabled.
+That is, when the non-boot CPUs are all offline and IRQs are disabled on the
+remaining online CPU, then the sysdev_driver.suspend() phase is carried out, and
+the system enters a sleep state (or hibernation image is created).  During
+resume (or after the image has been created) the sysdev_driver.resume() phase
+is carried out, IRQs are enabled on the only online CPU, the non-boot CPUs are
+enabled and that is followed by the "early resume" phase (in which the "noirq"
+callbacks provided by subsystems and device drivers are invoked).
 
 Code to actually enter and exit the system-wide low power state sometimes
 involves hardware details that are only known to the boot firmware, and
@@ -400,6 +606,22 @@ may leave a CPU running software (from S
 the system and manages its wakeup sequence.
 
 
+Power Management Notifiers
+--------------------------
+As stated in Documentation/power/notifiers.txt, there are some operations that
+cannot be carried out by the power management callbacks discussed above, because
+carrying them out at these points would be too late or too early.  To handle
+these cases subsystems and device drivers may register power management
+notifiers that are called before tasks are frozen and after they have been
+thawed.
+
+Generally speaking, the PM notifiers are suitable for performing actions that
+either require user space to be available, or at least won't interfere with user
+space in a wrong way.
+
+For details refer to Documentation/power/notifiers.txt.
+
+
 Runtime Power Management
 ========================
 Many devices are able to dynamically power down while the system is still
@@ -410,79 +632,21 @@ as "off", "sleep", "idle", "active", and
 cases (like PCI) be partially constrained by a bus the device uses, and will
 usually include hardware states that are also used in system sleep states.
 
-However, note that if a driver puts a device into a runtime low power state
-and the system then goes into a system-wide sleep state, it normally ought
-to resume into that runtime low power state rather than "full on".  Such
-distinctions would be part of the driver-internal state machine for that
-hardware; the whole point of runtime power management is to be sure that
-drivers are decoupled in that way from the state machine governing phases
-of the system-wide power/sleep state transitions.
-
-
-Power Saving Techniques
------------------------
-Normally runtime power management is handled by the drivers without specific
-userspace or kernel intervention, by device-aware use of techniques like:
-
-    Using information provided by other system layers
-	- stay deeply "off" except between open() and close()
-	- if transceiver/PHY indicates "nobody connected", stay "off"
-	- application protocols may include power commands or hints
-
-    Using fewer CPU cycles
-	- using DMA instead of PIO
-	- removing timers, or making them lower frequency
-	- shortening "hot" code paths
-	- eliminating cache misses
-	- (sometimes) offloading work to device firmware
-
-    Reducing other resource costs
-	- gating off unused clocks in software (or hardware)
-	- switching off unused power supplies
-	- eliminating (or delaying/merging) IRQs
-	- tuning DMA to use word and/or burst modes
-
-    Using device-specific low power states
-	- using lower voltages
-	- avoiding needless DMA transfers
-
-Read your hardware documentation carefully to see the opportunities that
-may be available.  If you can, measure the actual power usage and check
-it against the budget established for your project.
-
-
-Examples:  USB hosts, system timer, system CPU
-----------------------------------------------
-USB host controllers make interesting, if complex, examples.  In many cases
-these have no work to do:  no USB devices are connected, or all of them are
-in the USB "suspend" state.  Linux host controller drivers can then disable
-periodic DMA transfers that would otherwise be a constant power drain on the
-memory subsystem, and enter a suspend state.  In power-aware controllers,
-entering that suspend state may disable the clock used with USB signaling,
-saving a certain amount of power.
-
-The controller will be woken from that state (with an IRQ) by changes to the
-signal state on the data lines of a given port, for example by an existing
-peripheral requesting "remote wakeup" or by plugging a new peripheral.  The
-same wakeup mechanism usually works from "standby" sleep states, and on some
-systems also from "suspend to RAM" (or even "suspend to disk") states.
-(Except that ACPI may be involved instead of normal IRQs, on some hardware.)
-
-System devices like timers and CPUs may have special roles in the platform
-power management scheme.  For example, system timers using a "dynamic tick"
-approach don't just save CPU cycles (by eliminating needless timer IRQs),
-but they may also open the door to using lower power CPU "idle" states that
-cost more than a jiffie to enter and exit.  On x86 systems these are states
-like "C3"; note that periodic DMA transfers from a USB host controller will
-also prevent entry to a C3 state, much like a periodic timer IRQ.
-
-That kind of runtime mechanism interaction is common.  "System On Chip" (SOC)
-processors often have low power idle modes that can't be entered unless
-certain medium-speed clocks (often 12 or 48 MHz) are gated off.  When the
-drivers gate those clocks effectively, then the system idle task may be able
-to use the lower power idle modes and thereby increase battery life.
-
-If the CPU can have a "cpufreq" driver, there also may be opportunities
-to shift to lower voltage settings and reduce the power cost of executing
-a given number of instructions.  (Without voltage adjustment, it's rare
-for cpufreq to save much power; the cost-per-instruction must go down.)
+Note, however, that a system-wide power transition can be started while some
+devices are in low power states due to the runtime power management.  The system
+sleep PM callbacks should generally recognize such situations and react to them
+appropriately, but the recommended actions to be taken in that cases are
+subsystem-specific.
+
+In some cases the decision may be made at the subsystem level while in some
+other cases the device driver may be left to decide.  In some cases it may be
+desirable to leave a suspended device in that state during system-wide power
+transition, but in some other cases the device ought to be put back into the
+full power state, for example to be configured for system wakeup or so that its
+system wakeup capability can be disabled.  That all depends on the hardware
+and the design of the subsystem and device driver in question.
+
+During system-wide resume from a sleep state it's better to put devices into
+the full power state, as explained in Documentation/power/runtime_pm.txt.  Refer
+to that document for more information regarding this particular issue as well as
+for information on the device runtime power management framework in general.
