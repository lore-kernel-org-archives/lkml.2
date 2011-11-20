Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754699Ab1KTXgA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Nov 2011 18:36:00 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:48430 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754301Ab1KTXf4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Nov 2011 18:35:56 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linux PM list <linux-pm@vger.kernel.org>
Subject: [PATCH 5] PM: Update comments describing device power management callbacks
Date: Mon, 21 Nov 2011 00:38:41 +0100
User-Agent: KMail/1.13.6 (Linux/3.1.0-rc10+; KDE/4.6.0; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>, Randy Dunlap <rdunlap@xenotime.net>
References: <201111200153.40224.rjw@sisk.pl>
In-Reply-To: <201111200153.40224.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201111210038.41490.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

The comments describing device power management callbacks in
include/pm.h are outdated and somewhat confusing, so make them
reflect the reality more accurately.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 include/linux/pm.h |  193 ++++++++++++++++++++++++++++++-----------------------
 1 file changed, 110 insertions(+), 83 deletions(-)

Index: linux/include/linux/pm.h
===================================================================
--- linux.orig/include/linux/pm.h
+++ linux/include/linux/pm.h
@@ -54,15 +54,22 @@ typedef struct pm_message {
 /**
  * struct dev_pm_ops - device PM callbacks
  *
- * Several driver power state transitions are externally visible, affecting
+ * Several device power state transitions are externally visible, affecting
  * the state of pending I/O queues and (for drivers that touch hardware)
  * interrupts, wakeups, DMA, and other hardware state.  There may also be
- * internal transitions to various low power modes, which are transparent
+ * internal transitions to various low-power modes which are transparent
  * to the rest of the driver stack (such as a driver that's ON gating off
  * clocks which are not in active use).
  *
- * The externally visible transitions are handled with the help of the following
- * callbacks included in this structure:
+ * The externally visible transitions are handled with the help of callbacks
+ * included in this structure in such a way that two levels of callbacks are
+ * involved.  First, the PM core executes callbacks provided by PM domains,
+ * device types, classes and bus types.  They are the subsystem-level callbacks
+ * supposed to execute callbacks provided by device drivers, although they may
+ * choose not to do that.  If the driver callbacks are executed, they have to
+ * collaborate with the subsystem-level callbacks to achieve the goals
+ * appropriate for the given system transition, given transition phase and the
+ * subsystem the device belongs to.
  *
  * @prepare: Prepare the device for the upcoming transition, but do NOT change
  *	its hardware state.  Prevent new children of the device from being
@@ -71,101 +78,118 @@ typedef struct pm_message {
  *	probe method from being made too once @prepare() has succeeded).  If
  *	@prepare() detects a situation it cannot handle (e.g. registration of a
  *	child already in progress), it may return -EAGAIN, so that the PM core
- *	can execute it once again (e.g. after the new child has been registered)
+ *	can execute it once again (e.g. after a new child has been registered)
  *	to recover from the race condition.  This method is executed for all
  *	kinds of suspend transitions and is followed by one of the suspend
  *	callbacks: @suspend(), @freeze(), or @poweroff().
- *	The PM core executes @prepare() for all devices before starting to
- *	execute suspend callbacks for any of them, so drivers may assume all of
- *	the other devices to be present and functional while @prepare() is being
- *	executed.  In particular, it is safe to make GFP_KERNEL memory
- *	allocations from within @prepare().  However, drivers may NOT assume
- *	anything about the availability of the user space at that time and it
- *	is not correct to request firmware from within @prepare() (it's too
- *	late to do that).  [To work around this limitation, drivers may
- *	register suspend and hibernation notifiers that are executed before the
+ *	The PM core executes subsystem-level @prepare() for all devices before
+ *	starting to execute suspend callbacks for any of them, so all devices
+ *	may be assumed to be present and functional while @prepare() is being
+ *	executed.  However, device drivers may NOT assume anything about the
+ *	availability of user space at that time and it is NOT valid to request
+ *	firmware from within @prepare() (it's too late to do that).  It also is
+ *	NOT valid to allocate substantial amounts of memory from @prepare() in
+ *	the GFP_KERNEL mode.  [To work around these limitations, drivers may
+ *	register suspend and hibernation notifiers to be executed before the
  *	freezing of tasks.]
  *
  * @complete: Undo the changes made by @prepare().  This method is executed for
  *	all kinds of resume transitions, following one of the resume callbacks:
  *	@resume(), @thaw(), @restore().  Also called if the state transition
- *	fails before the driver's suspend callback (@suspend(), @freeze(),
- *	@poweroff()) can be executed (e.g. if the suspend callback fails for one
+ *	fails before the driver's suspend callback: @suspend(), @freeze() or
+ *	@poweroff(), can be executed (e.g. if the suspend callback fails for one
  *	of the other devices that the PM core has unsuccessfully attempted to
  *	suspend earlier).
- *	The PM core executes @complete() after it has executed the appropriate
- *	resume callback for all devices.
+ *	The PM core executes subsystem-level @complete() after it has executed
+ *	the appropriate resume callbacks for all devices.
  *
  * @suspend: Executed before putting the system into a sleep state in which the
- *	contents of main memory are preserved.  Quiesce the device, put it into
- *	a low power state appropriate for the upcoming system state (such as
- *	PCI_D3hot), and enable wakeup events as appropriate.
+ *	contents of main memory are preserved.  The exact action to perform
+ *	depends on the device's subsystem (PM domain, device type, class or bus
+ *	type), but generally the device must be quiescent after @suspend() has
+ *	returned, so that it doesn't do any I/O or DMA.
+ *	Subsystem-level @suspend() is executed for all devices after invoking
+ *	subsystem-level @prepare() for all of them.
  *
  * @resume: Executed after waking the system up from a sleep state in which the
- *	contents of main memory were preserved.  Put the device into the
- *	appropriate state, according to the information saved in memory by the
- *	preceding @suspend().  The driver starts working again, responding to
- *	hardware events and software requests.  The hardware may have gone
- *	through a power-off reset, or it may have maintained state from the
- *	previous suspend() which the driver may rely on while resuming.  On most
- *	platforms, there are no restrictions on availability of resources like
- *	clocks during @resume().
+ *	contents of main memory were preserved.  Undo the changes made by
+ *	the preceding @suspend() and cause the device to become operational
+ *	(the exact action to perform depends on the device's subsystem).
+ *	The driver starts working again, responding to hardware events and
+ *	software requests.  The state of the device at the time its driver's
+ *	@resume() callback is run depends on the platform and subsystem the
+ *	device belongs to.  On most platforms, there are no restrictions on
+ *	availability of resources like clocks during @resume().
+ *	Subsystem-level @resume() is executed for all devices after invoking
+ *	subsystem-level @resume_noirq() for all of them.
  *
  * @freeze: Hibernation-specific, executed before creating a hibernation image.
- *	Quiesce operations so that a consistent image can be created, but do NOT
- *	otherwise put the device into a low power device state and do NOT emit
- *	system wakeup events.  Save in main memory the device settings to be
- *	used by @restore() during the subsequent resume from hibernation or by
- *	the subsequent @thaw(), if the creation of the image or the restoration
- *	of main memory contents from it fails.
+ *	Analogous to @suspend(), but it should not enable the device to signal
+ *	wakeup events.  The majority of subsystems (with the notable exception
+ *	of the PCI bus type) expect the driver-level @freeze() to save the
+ *	device settings in memory to be used by @restore() during the subsequent
+ *	resume from hibernation.
+ *	Subsystem-level @freeze() is executed for all devices after invoking
+ *	subsystem-level @prepare() for all of them.
  *
  * @thaw: Hibernation-specific, executed after creating a hibernation image OR
- *	if the creation of the image fails.  Also executed after a failing
+ *	if the creation of an image has failed.  Also executed after a failing
  *	attempt to restore the contents of main memory from such an image.
  *	Undo the changes made by the preceding @freeze(), so the device can be
  *	operated in the same way as immediately before the call to @freeze().
+ *	Subsystem-level @thaw() is executed for all devices after invoking
+ *	subsystem-level @thaw_noirq() for all of them.  It also may be executed
+ *	directly after @freeze() in case of a transition error.
  *
  * @poweroff: Hibernation-specific, executed after saving a hibernation image.
- *	Quiesce the device, put it into a low power state appropriate for the
- *	upcoming system state (such as PCI_D3hot), and enable wakeup events as
- *	appropriate.
+ *	Analogous to @suspend(), but it need not save the the device settings in
+ *	memory.
+ *	Subsystem-level @poweroff() is executed for all devices after invoking
+ *	subsystem-level @prepare() for all of them.
  *
  * @restore: Hibernation-specific, executed after restoring the contents of main
- *	memory from a hibernation image.  Driver starts working again,
- *	responding to hardware events and software requests.  Drivers may NOT
- *	make ANY assumptions about the hardware state right prior to @restore().
- *	On most platforms, there are no restrictions on availability of
- *	resources like clocks during @restore().
- *
- * @suspend_noirq: Complete the operations of ->suspend() by carrying out any
- *	actions required for suspending the device that need interrupts to be
- *	disabled
- *
- * @resume_noirq: Prepare for the execution of ->resume() by carrying out any
- *	actions required for resuming the device that need interrupts to be
- *	disabled
- *
- * @freeze_noirq: Complete the operations of ->freeze() by carrying out any
- *	actions required for freezing the device that need interrupts to be
- *	disabled
- *
- * @thaw_noirq: Prepare for the execution of ->thaw() by carrying out any
- *	actions required for thawing the device that need interrupts to be
- *	disabled
- *
- * @poweroff_noirq: Complete the operations of ->poweroff() by carrying out any
- *	actions required for handling the device that need interrupts to be
- *	disabled
- *
- * @restore_noirq: Prepare for the execution of ->restore() by carrying out any
- *	actions required for restoring the operations of the device that need
- *	interrupts to be disabled
+ *	memory from a hibernation image.  The state of the device at the time
+ *	its driver's @restore() callback is run depends on the platform and
+ *	subsystem the device belongs to.  On most platforms, there are no
+ *	restrictions on availability of resources like clocks during @restore().
+ *	Subsystem-level @restore() is executed for all devices after invoking
+ *	subsystem-level @restore_noirq() for all of them.
+ *
+ * @suspend_noirq: Complete the actions started by @suspend().  Carry out any
+ *	additional operations required for suspending the device that might be
+ *	racing with its driver's interrupt handler, which is guaranteed not to
+ *	run while @suspend_noirq() is being executed.
+ *
+ * @resume_noirq: Prepare for the execution of @resume() by carrying out any
+ *	operations required for resuming the device that might be racing with
+ *	its driver's interrupt handler, which is guaranteed not to run while
+ *	@resume_noirq() is being executed.
+ *
+ * @freeze_noirq: Complete the actions started by @freeze().  Carry out any
+ *	additional operations required for freezing the device that might be
+ *	racing with its driver's interrupt handler, which is guaranteed not to
+ *	run while @freeze_noirq() is being executed.
+ *
+ * @thaw_noirq: Prepare for the execution of @thaw() by carrying out any
+ *	operations required for thawing the device that might be racing with its
+ *	driver's interrupt handler, which is guaranteed not to run while
+ *	@thaw_noirq() is being executed.
+ *
+ * @poweroff_noirq: Complete the actions started by @poweroff().  Carry out any
+ *	additional operations required for powering off the device that might be
+ *	racing with its driver's interrupt handler, which is guaranteed not to
+ *	run while @poweroff_noirq() is being executed.
+ *
+ * @restore_noirq: Prepare for the execution of @restore() by carrying out any
+ *	operations required for thawing the device that might be racing with its
+ *	driver's interrupt handler, which is guaranteed not to run while
+ *	@restore_noirq() is being executed.
  *
  * All of the above callbacks, except for @complete(), return error codes.
  * However, the error codes returned by the resume operations, @resume(),
- * @thaw(), @restore(), @resume_noirq(), @thaw_noirq(), and @restore_noirq() do
+ * @thaw(), @restore(), @resume_noirq(), @thaw_noirq(), and @restore_noirq(), do
  * not cause the PM core to abort the resume transition during which they are
- * returned.  The error codes returned in that cases are only printed by the PM
+ * returned.  The error codes returned in those cases are only printed by the PM
  * core to the system logs for debugging purposes.  Still, it is recommended
  * that drivers only return error codes from their resume methods in case of an
  * unrecoverable failure (i.e. when the device being handled refuses to resume
@@ -174,29 +198,32 @@ typedef struct pm_message {
  * their children.
  *
  * It is allowed to unregister devices while the above callbacks are being
- * executed.  However, it is not allowed to unregister a device from within any
- * of its own callbacks.
+ * executed.  However, it is NOT allowed to unregister a device from within any
+ * of its driver's callbacks.
  *
- * There also are the following callbacks related to run-time power management
- * of devices:
+ * There also are callbacks related to runtime power management of devices.
+ * Again, these callbacks are executed by the PM core only for subsystems
+ * (PM domains, device types, classes and bus types) and the subsystem-level
+ * callbacks are supposed to invoke the driver callbacks.  Moreover, the exact
+ * actions to be performed by a device driver's callbacks generally depend on
+ * the platform and subsystem the device belongs to.
  *
  * @runtime_suspend: Prepare the device for a condition in which it won't be
  *	able to communicate with the CPU(s) and RAM due to power management.
- *	This need not mean that the device should be put into a low power state.
+ *	This need not mean that the device should be put into a low-power state.
  *	For example, if the device is behind a link which is about to be turned
  *	off, the device may remain at full power.  If the device does go to low
- *	power and is capable of generating run-time wake-up events, remote
- *	wake-up (i.e., a hardware mechanism allowing the device to request a
- *	change of its power state via a wake-up event, such as PCI PME) should
- *	be enabled for it.
+ *	power and is capable of generating runtime wakeup events, remote wakeup
+ *	(i.e., a hardware mechanism allowing the device to request a change of
+ *	its power state via an interrupt) should be enabled for it.
  *
  * @runtime_resume: Put the device into the fully active state in response to a
- *	wake-up event generated by hardware or at the request of software.  If
- *	necessary, put the device into the full power state and restore its
+ *	wakeup event generated by hardware or at the request of software.  If
+ *	necessary, put the device into the full-power state and restore its
  *	registers, so that it is fully operational.
  *
- * @runtime_idle: Device appears to be inactive and it might be put into a low
- *	power state if all of the necessary conditions are satisfied.  Check
+ * @runtime_idle: Device appears to be inactive and it might be put into a
+ *	low-power state if all of the necessary conditions are satisfied.  Check
  *	these conditions and handle the device as appropriate, possibly queueing
  *	a suspend request for it.  The return value is ignored by the PM core.
  */
