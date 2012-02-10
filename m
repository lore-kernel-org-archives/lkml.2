Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760207Ab2BJVDy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 16:03:54 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:49741 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1759084Ab2BJVDw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 16:03:52 -0500
Date: Fri, 10 Feb 2012 16:03:51 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Tejun Heo <tj@kernel.org>
cc: Jens Axboe <axboe@kernel.dk>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linux-pm mailing list <linux-pm@vger.kernel.org>,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: Bug in disk event polling
In-Reply-To: <20120210204652.GJ19392@google.com>
Message-ID: <Pine.LNX.4.44L0.1202101557280.1281-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 10 Feb 2012, Tejun Heo wrote:

> > You can see this for yourself easily enough by suspending or
> > hibernating while a USB flash drive is plugged in.  You don't even need
> > to go through the full suspend procedure; the first two stages are
> > enough (echo devices >/sys/power/pm_test).  Check the system log
> > afterward; most likely you'll find the flash drive got errors and had
> > to be unregistered and re-enumerated.
> 
> Do you happen to have log of such failure?  Polilng failure itself
> shouldn't lead to such failure mode.

It does, because the lower-level driver (such as usb-storage) tries to
recover from the error and runs into problems when it's unable to
communicate with the suspended device.  Here's an example:

[ 2854.836894] PM: Marking nosave pages: 000000000009f000 - 0000000000100000
[ 2854.836903] PM: Basic memory bitmaps created
[ 2854.836906] PM: Syncing filesystems ... done.
[ 2854.841396] Freezing user space processes ... (elapsed 0.01 seconds) done.
[ 2854.856914] PM: Preallocating image memory... done (allocated 33805 pages)
[ 2854.973369] PM: Allocated 135220 kbytes in 0.11 seconds (1229.27 MB/s)
[ 2854.973442] Freezing remaining freezable tasks ... (elapsed 0.01 seconds) done.
[ 2854.991081] hub 2-0:1.0: hub_suspend
[ 2854.991109] usb usb2: bus suspend, wakeup 0
[ 2854.991116] ehci_hcd 0000:00:1d.7: suspend root hub
[ 2854.994727] i8042 aux 00:0a: wake-up capability disabled by ACPI
[ 2854.996329] i8042 kbd 00:09: wake-up capability enabled by ACPI
[ 2855.012852] serial 00:05: disabled
[ 2855.028375] pci 0000:00:1e.0: wake-up capability enabled by ACPI
[ 2855.044195] PM: freeze of devices complete after 54.686 msecs
[ 2855.045721] PM: late freeze of devices complete after 1.448 msecs
[ 2855.045910] ACPI: Preparing to enter system sleep state S4
[ 2855.066804] PM: Saving platform NVS memory
[ 2855.080991] Disabling non-boot CPUs ...
[ 2855.081189] PM: Creating hibernation image:
[ 2855.084032] PM: Need to copy 33649 pages
[ 2855.084032] PM: Normal pages needed: 33649 + 1024, available pages: 159745
[ 2855.084032] PM: Restoring platform NVS memory
[ 2855.084032] Force enabled HPET at resume
[ 2855.088362] ACPI: Waking up from system sleep state S4
[ 2855.146474] pci 0000:00:1f.0: power state changed by ACPI to D0
[ 2855.146608] pci 0000:00:1f.0: power state changed by ACPI to D0
[ 2855.147702] PM: early restore of devices complete after 1.959 msecs
[ 2855.256478] i915 0000:00:02.0: setting latency timer to 64
[ 2855.260350] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[ 2855.261135] usb usb2: root hub lost power or was reset
[ 2855.261218] ehci_hcd 0000:00:1d.7: reset command 0080002 (park)=0 ithresh=8 period=1024 Reset HALT
[ 2855.264089] pci 0000:00:1e.0: setting latency timer to 64
[ 2855.264234] PIIX_IDE 0000:00:1f.1: setting latency timer to 64
[ 2855.265349] usb usb4: root hub lost power or was reset
[ 2855.265420] ehci_hcd 0000:01:01.2: reset command 0080b02  park=3 ithresh=8 period=1024 Reset HALT
[ 2855.265435] ehci_hcd 0000:01:01.2: MWI active
[ 2855.265443] ehci_hcd 0000:01:01.2: ...powerup ports...
[ 2855.265965] pci 0000:00:1e.0: wake-up capability disabled by ACPI
[ 2855.276423] ehci_hcd 0000:00:1d.7: cache line size of 32 is not supported
[ 2855.276455] usb usb2: usb resume
[ 2855.276463] ehci_hcd 0000:00:1d.7: resume root hub after power loss
[ 2855.288176] usb usb4: usb resume
[ 2855.288186] ehci_hcd 0000:01:01.2: resume root hub after power loss
[ 2855.304037] hub 2-0:1.0: hub_reset_resume
[ 2855.304045] hub 2-0:1.0: trying to enable port power on non-switchable hub
[ 2855.316066] hub 4-0:1.0: hub_reset_resume
[ 2855.316074] hub 4-0:1.0: enabling power on all ports
[ 2855.324178] e100 0000:01:08.0: eth0: NIC Link is Up 100 Mbps Full Duplex
[ 2855.375159] serial 00:05: activated
[ 2855.376755] i8042 kbd 00:09: wake-up capability disabled by ACPI
[ 2855.379728] hda: host max PIO4 wanted PIO255(auto-tune) selected PIO4
[ 2855.384054] hda: UDMA/100 mode selected
[ 2855.386940] hdb: host max PIO4 wanted PIO255(auto-tune) selected PIO4
[ 2855.409021] ehci_hcd 0000:00:1d.7: GetStatus port:8 status 001103 0  ACK POWER sig=se0 RESET CSC CONNECT
[ 2855.409087] hub 2-0:1.0: port 8: status 0511 change 0001
[ 2855.448429] ehci_hcd 0000:00:1d.7: port 8 full speed --> companion
[ 2855.448440] ehci_hcd 0000:00:1d.7: GetStatus port:8 status 003001 0  ACK POWER OWNER sig=se0 CONNECT
[ 2855.448514] hub 2-0:1.0: port 8 not reset yet, waiting 50ms
[ 2855.456055] hdb: UDMA/100 mode selected
[ 2855.458606] hdc: host max PIO4 wanted PIO255(auto-tune) selected PIO4
[ 2855.458774] hdc: UDMA/66 mode selected
[ 2855.504214] hub 2-0:1.0: port 8 not reset yet, waiting 200ms
[ 2855.708205] hub 2-0:1.0: port 8 not reset yet, waiting 200ms
[ 2855.912189] hub 2-0:1.0: port 8 not reset yet, waiting 200ms
[ 2855.912196] hub 2-0:1.0: port_wait_reset: err = -16
[ 2855.912201] hub 2-0:1.0: port 8 not enabled, trying reset again...
[ 2856.116416] ehci_hcd 0000:00:1d.7: port 8 high speed
[ 2856.116427] ehci_hcd 0000:00:1d.7: GetStatus port:8 status 001005 0  ACK POWER sig=se0 PE CONNECT
[ 2856.172187] usb 2-8: reset high-speed USB device number 2 using ehci_hcd
[ 2856.232393] ehci_hcd 0000:00:1d.7: port 8 high speed
[ 2856.232405] ehci_hcd 0000:00:1d.7: GetStatus port:8 status 001005 0  ACK POWER sig=se0 PE CONNECT
[ 2856.288157] usb 2-8: device descriptor read/64, error -113
[ 2856.448347] ehci_hcd 0000:00:1d.7: port 8 high speed
[ 2856.448357] ehci_hcd 0000:00:1d.7: GetStatus port:8 status 001005 0  ACK POWER sig=se0 PE CONNECT
[ 2856.504154] usb 2-8: device descriptor read/64, error -113
[ 2856.664429] ehci_hcd 0000:00:1d.7: port 8 high speed
[ 2856.664440] ehci_hcd 0000:00:1d.7: GetStatus port:8 status 001005 0  ACK POWER sig=se0 PE CONNECT

None of those resets above should have occurred.  They are the result
of trying to recover from the failure of a TEST UNIT READY command.

> > I have verified that changing all occurrences of system_nrt_wq in 
> > block/genhd.c to system_freezable_wq fixes the bug.  However this may 
> > not be the way you want to solve it; you may prefer to have a freezable 
> > non-reentrant work queue.
> 
> Please feel free to send out a patch to fix the issue. :)

Is there a real reason for using system_nrt_wq?  Are you okay with just
switching over to system_freezable_wq?

Alan Stern

