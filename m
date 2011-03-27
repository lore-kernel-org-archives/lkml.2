Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752869Ab1C0Xcx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Mar 2011 19:32:53 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:46141 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752223Ab1C0Xcp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Mar 2011 19:32:45 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/7] ARM: Use syscore_ops for "core" power management
Date: Mon, 28 Mar 2011 01:25:11 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.38+; KDE/4.6.0; x86_64; ; )
Cc: Greg KH <gregkh@suse.de>, Kay Sievers <kay.sievers@suse.de>,
        Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
        Russell King <linux@arm.linux.org.uk>, linux-omap@vger.kernel.org,
        Kevin Hilman <khilman@ti.com>, linux-arm-kernel@lists.infradead.org,
        Ben Dooks <ben-linux@fluff.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201103280125.11750.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

There are multiple problems with sysdevs, or struct sys_device objects to
be precise, that are so annoying that some people have started to think
of removind them entirely from the kernel.  To me, personally, the most
obvious issue is the way sysdevs are used for defining suspend/resume
callbacks to be executed with one CPU on-line and interrupts disabled.
Apart from this, sysdevs do not follow general rules related to the
representation of things in /sys/devices/, so user space that uses
/sys/devices/ to retrieve information on device hierarchy layout and
device configuration, such as udev, cannot really handle them correctly.

Some subsystems need to carry out certain operations during suspend after
we've disabled non-boot CPUs and interrupts have been switched off on the
only on-line one.  Currently, the only way to achieve that is to define
sysdev suspend/resume callbacks, but this is cumbersome and inefficient.
Namely, to do that, one has to define a sysdev class providing the callbacks
and a sysdev actually using them, which is excessively complicated.  Moreover,
the sysdev suspend/resume callbacks take arguments that are not really used
by the majority of subsystems defining sysdev suspend/resume callbacks
(or even if they are used, they don't really need to be used, so they
are simply unnecessary).  Of course, if a sysdev is only defined to provide
suspend/resume (and maybe shutdown) callbacks, there's no real reason why
it should show up in sysfs.

For this reason, I thought it would be a good idea to provide a simpler
interface for subsystems to define "very late" suspend callbacks and
"very early" resume callbacks (and "very late" shutdown callbacks as well)
without the entire bloat related to sysdevs.  Such an interface has been
merged recently in the form of struct syscore_ops framework that can be used
to replace sysdevs in the "core" power management area.

The x86 architecture and subsystems it depends on have already been converted
to using the new framework instead of sysdevs for "core" power management and
the following series of patches does the analogous thing for the ARM
architecture.  I have done my best to build the kernel for every affected
platform, but unfortunately some of them don't build even without my changes,
so some minor issues might have slept through my fingers.  Hopefully, though,
there won't be too many of them.

[1/7] - Use syscore_ops for "core" PM in some common ARM code.
[2/7] - Use syscore_ops for "core" PM on OMAP.
[3/7] - Use syscore_ops for "core" PM on Integrator.
[4/7] - Use syscore_ops for "core" PM on SA1100.
[5/7] - Use syscore_ops for "core" PM on PXA-based platforms.
[6/7] - Use syscore_ops for "core" PM on Samsung platforms.
[7/7] - Mark ARM select CONFIG_ARCH_NO_SYSDEV_OPS.

Thanks,
Rafael

