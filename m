Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755178Ab2CINQo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 08:16:44 -0500
Received: from e28smtp03.in.ibm.com ([122.248.162.3]:33319 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753395Ab2CINQm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 08:16:42 -0500
Message-ID: <4F5A02AC.4090205@linux.vnet.ibm.com>
Date: Fri, 09 Mar 2012 18:46:28 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.1) Gecko/20120209 Thunderbird/10.0.1
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: lenb@kernel.org, deepthi@linux.vnet.ibm.com, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org
Subject: Re: [PATCH] PM/Sleep, ACPI: Teach acpi_cpu_soft_notify() to handle
 CPU hotplug in suspend/resume path
References: <20120228155137.3061.97133.stgit@srivatsabhat.in.ibm.com> <201203042333.18501.rjw@sisk.pl>
In-Reply-To: <201203042333.18501.rjw@sisk.pl>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12030913-3864-0000-0000-000001C38FE6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/05/2012 04:03 AM, Rafael J. Wysocki wrote:

> On Tuesday, February 28, 2012, Srivatsa S. Bhat wrote:
>> acpi_cpu_soft_notify handles only CPU_ONLINE and CPU_DEAD events. However,
>> during a system-wide suspend/hibernation operation, CPU_ONLINE_FROZEN and
>> CPU_DEAD_FROZEN events are sent as part of CPU hotplug.
>>
>> Those events are really no different from regular CPU hotplug in this context,
>> and hence acpi shouldn't ignore them. So, teach acpi_cpu_soft_notify() to
>> handle those events as well.
>>
>> Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
>> ---
>>
>> I am no ACPI expert! So requesting a thorough review of this patch..
> 
> Well, as far as I can tell, it _looks_ correct.  That said, I don't think
> anyone will really tell you on the basis of code review alone, this requires
> testing.
> 
> Since Len hasn't been very responsive recently, I can take this patch into
> linux-pm/linux-next and see what the feedback is.
> 


I was running some tests (linux mainline, 3.3-rc6+) and I noticed this:

If I try the processors level using pm_test, I get the following ACPI error
on resume: (But note that even though I see that error message, there is no
noticeable damage. ie., suspend/resume etc works as expected.)

[  118.614331] PM: Syncing filesystems ... done.
[  118.810015] PM: Preparing system for mem sleep
[  119.023881] Freezing user space processes ... (elapsed 0.01 seconds) done.
[  119.036740] Freezing remaining freezable tasks ... (elapsed 0.01 seconds) done.
[  119.049251] PM: Entering mem sleep
[  119.050864] Suspending console(s) (use no_console_suspend to debug)
[  119.212380] sd 0:0:0:0: [sda] Synchronizing SCSI cache
[  119.292494] sd 0:0:0:0: [sda] Stopping disk
[  119.454865] [drm] nouveau 0000:01:00.0: Disabling display...
[  119.455150] [drm] nouveau 0000:01:00.0: Disabling fbcon...
[  119.455159] [drm] nouveau 0000:01:00.0: Unpinning framebuffer(s)...
[  119.455235] [drm] nouveau 0000:01:00.0: Evicting buffers...
[  119.455308] ACPI handle has no context!
[  119.468621] i915 0000:00:02.0: power state changed by ACPI to D3
[  119.469537] [drm] nouveau 0000:01:00.0: Idling channels...
[  119.469653] [drm] nouveau 0000:01:00.0: Suspending GPU objects...
[  119.668554] e1000e 0000:00:19.0: wake-up capability enabled by ACPI
[  119.692192] [drm] nouveau 0000:01:00.0: And we're gone!
[  119.702686] nouveau 0000:01:00.0: power state changed by ACPI to D3
[  119.702900] PM: suspend of devices complete after 649.631 msecs
[  119.705137] ehci_hcd 0000:00:1d.0: wake-up capability enabled by ACPI
[  119.715566] ehci_hcd 0000:00:1d.0: power state changed by ACPI to D3
[  119.716252] ehci_hcd 0000:00:1a.0: wake-up capability enabled by ACPI
[  119.726557] ehci_hcd 0000:00:1a.0: power state changed by ACPI to D3
[  119.727183] PM: late suspend of devices complete after 24.279 msecs
[  119.727928] ACPI: Preparing to enter system sleep state S3
[  119.773691] PM: Saving platform NVS memory
[  119.786581] Disabling non-boot CPUs ...
[  119.789037] CPU 1 is now offline
[  119.793272] CPU 2 is now offline
[  119.796330] CPU 3 is now offline
[  119.796332] lockdep: fixing up alternatives.
[  119.796914] suspend debug: Waiting for 5 seconds.
[  124.793624] sched: RT throttling activated
[  124.830791] Enabling non-boot CPUs ...
[  124.860880] lockdep: fixing up alternatives.
[  124.860885] Booting Node 0 Processor 1 APIC 0x1
[  124.860887] smpboot cpu 1: start_ip = 98000
[  124.871913] Disabled fast string operations
[  124.871932] Calibrating delay loop (skipped) already calibrated this CPU
[  125.052388] NMI watchdog enabled, takes one hw-pmu counter.
[  125.053207] ACPI Exception: AE_BAD_PARAMETER, Returned by Handler for [EmbeddedControl] (20120111/evregion-501)
[  125.053215] ACPI Error: Method parse/execution failed [\_SB_.PCI0.LPC_.EC__.LPMD] (Node ffff88023286cc58), AE_BAD_PARAMETER (20120111/psparse-536)
[  125.053231] ACPI Error: Method parse/execution failed [\_PR_.CPU0._PPC] (Node ffff8802328900f0), AE_BAD_PARAMETER (20120111/psparse-536)
[  125.053244] ACPI Error: Method parse/execution failed [\_PR_.CPU1._PPC] (Node ffff880232890910), AE_BAD_PARAMETER (20120111/psparse-536)
[  125.053263] ACPI Exception: AE_BAD_PARAMETER, Evaluating _PPC (20120111/processor_perflib-140)
[  125.053292] CPU1 is up
[  125.053465] lockdep: fixing up alternatives.
[  125.053471] Booting Node 0 Processor 2 APIC 0x2
[  125.053473] smpboot cpu 2: start_ip = 98000
[  125.064508] Disabled fast string operations
[  125.064526] Calibrating delay loop (skipped) already calibrated this CPU
[  125.085490] NMI watchdog enabled, takes one hw-pmu counter.
[  125.086393] ACPI Exception: AE_BAD_PARAMETER, Returned by Handler for [EmbeddedControl] (20120111/evregion-501)
[  125.086402] ACPI Error: Method parse/execution failed [\_SB_.PCI0.LPC_.EC__.LPMD] (Node ffff88023286cc58), AE_BAD_PARAMETER (20120111/psparse-536)
[  125.086417] ACPI Error: Method parse/execution failed [\_PR_.CPU0._PPC] (Node ffff8802328900f0), AE_BAD_PARAMETER (20120111/psparse-536)
[  125.086430] ACPI Error: Method parse/execution failed [\_PR_.CPU2._PPC] (Node ffff880232890ac8), AE_BAD_PARAMETER (20120111/psparse-536)
[  125.086448] ACPI Exception: AE_BAD_PARAMETER, Evaluating _PPC (20120111/processor_perflib-140)
[  125.086478] CPU2 is up
[  125.086675] lockdep: fixing up alternatives.
[  125.086681] Booting Node 0 Processor 3 APIC 0x3
[  125.086683] smpboot cpu 3: start_ip = 98000
[  125.097707] Disabled fast string operations
[  125.097726] Calibrating delay loop (skipped) already calibrated this CPU
[  125.118659] NMI watchdog enabled, takes one hw-pmu counter.
[  125.119203] ACPI Exception: AE_BAD_PARAMETER, Returned by Handler for [EmbeddedControl] (20120111/evregion-501)
[  125.119210] ACPI Error: Method parse/execution failed [\_SB_.PCI0.LPC_.EC__.LPMD] (Node ffff88023286cc58), AE_BAD_PARAMETER (20120111/psparse-536)
[  125.119220] ACPI Error: Method parse/execution failed [\_PR_.CPU0._PPC] (Node ffff8802328900f0), AE_BAD_PARAMETER (20120111/psparse-536)
[  125.119228] ACPI Error: Method parse/execution failed [\_PR_.CPU3._PPC] (Node ffff880232890a28), AE_BAD_PARAMETER (20120111/psparse-536)
[  125.119239] ACPI Exception: AE_BAD_PARAMETER, Evaluating _PPC (20120111/processor_perflib-140)
[  125.119260] CPU3 is up
[  125.122640] ACPI: Waking up from system sleep state S3
[  125.209906] i915 0000:00:02.0: power state changed by ACPI to D0
[  125.220687] i915 0000:00:02.0: power state changed by ACPI to D0
[  125.242761] ehci_hcd 0000:00:1a.0: power state changed by ACPI to D0
[  125.253677] ehci_hcd 0000:00:1a.0: power state changed by ACPI to D0
[  125.253758] ehci_hcd 0000:00:1a.0: wake-up capability disabled by ACPI
[  125.253768] ehci_hcd 0000:00:1a.0: power state changed by ACPI to D0
[  125.253774] ehci_hcd 0000:00:1a.0: power state changed by ACPI to D0
[  125.265063] ehci_hcd 0000:00:1d.0: power state changed by ACPI to D0
[  125.275669] ehci_hcd 0000:00:1d.0: power state changed by ACPI to D0
[  125.275750] ehci_hcd 0000:00:1d.0: wake-up capability disabled by ACPI
[  125.275759] ehci_hcd 0000:00:1d.0: power state changed by ACPI to D0
[  125.275765] ehci_hcd 0000:00:1d.0: power state changed by ACPI to D0
[  125.287074] nouveau 0000:01:00.0: power state changed by ACPI to D0
[  125.297658] nouveau 0000:01:00.0: power state changed by ACPI to D0
[  125.308813] sdhci-pci 0000:0d:00.0: MMC controller base frequency changed to 50Mhz.
[  125.309096] PM: early resume of devices complete after 99.415 msecs
[  125.309229] i915 0000:00:02.0: power state changed by ACPI to D0
[  125.309236] i915 0000:00:02.0: power state changed by ACPI to D0
[  125.309243] i915 0000:00:02.0: setting latency timer to 64
[  125.309334] e1000e 0000:00:19.0: wake-up capability disabled by ACPI
[  125.309458] e1000e 0000:00:19.0: irq 43 for MSI/MSI-X
[  125.317762] ehci_hcd 0000:00:1a.0: power state changed by ACPI to D0
[  125.317768] ehci_hcd 0000:00:1a.0: power state changed by ACPI to D0
[  125.317783] ehci_hcd 0000:00:1a.0: setting latency timer to 64
[  125.317893] snd_hda_intel 0000:00:1b.0: irq 44 for MSI/MSI-X
[  125.317981] ehci_hcd 0000:00:1d.0: power state changed by ACPI to D0
[  125.317987] ehci_hcd 0000:00:1d.0: power state changed by ACPI to D0
[  125.318000] ehci_hcd 0000:00:1d.0: setting latency timer to 64
[  125.318052] ahci 0000:00:1f.2: setting latency timer to 64
[  125.318471] [drm] nouveau 0000:01:00.0: We're back, enabling device...
[  125.318477] nouveau 0000:01:00.0: power state changed by ACPI to D0
[  125.318483] nouveau 0000:01:00.0: power state changed by ACPI to D0
[  125.318490] nouveau 0000:01:00.0: power state changed by ACPI to D0
[  125.318496] nouveau 0000:01:00.0: power state changed by ACPI to D0
[  125.318504] [drm] nouveau 0000:01:00.0: POSTing device...
[  125.318506] [drm] nouveau 0000:01:00.0: Parsing VBIOS init table 0 at offset 0x73B5
[  125.338999] [drm] nouveau 0000:01:00.0: 0x7393: i2c wr fail: -5
[  125.339207] [drm] nouveau 0000:01:00.0: 0x73A5: i2c rd fail: -5
[  125.359827] [drm] nouveau 0000:01:00.0: Parsing VBIOS init table 1 at offset 0x7A29
[  125.382725] tpm_tis 00:0a: A TPM error (6) occurred attempting to read a pcr value
[  125.382735] tpm_tis 00:0a: TPM is disabled/deactivated (0x6)
[  125.386896] [drm] nouveau 0000:01:00.0: Parsing VBIOS init table 2 at offset 0x89D9
[  125.386904] [drm] nouveau 0000:01:00.0: Parsing VBIOS init table 3 at offset 0x89DA
[  125.386971] [drm] nouveau 0000:01:00.0: Parsing VBIOS init table 4 at offset 0x8ACB
[  125.386977] [drm] nouveau 0000:01:00.0: Parsing VBIOS init table at offset 0x8B30
[  125.407019] [drm] nouveau 0000:01:00.0: Restoring GPU objects...
[  125.508179] [drm] nouveau 0000:01:00.0: Reinitialising engines...
[  125.508303] [drm] nouveau 0000:01:00.0: Restoring mode...
[  125.640647] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[  125.642601] ata4: SATA link down (SStatus 0 SControl 300)
[  125.643353] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
[  125.643362] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
[  125.643369] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
[  125.644607] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[  125.646617] ata5: SATA link down (SStatus 0 SControl 300)
[  125.768663] ata2.00: ACPI cmd e3/00:1f:00:00:00:a0 (IDLE) succeeded
[  125.768933] ata2.00: ACPI cmd e3/00:02:00:00:00:a0 (IDLE) succeeded
[  125.768942] ata2.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
[  125.773238] ata2.00: ACPI cmd e3/00:1f:00:00:00:a0 (IDLE) succeeded
[  125.773432] ata2.00: ACPI cmd e3/00:02:00:00:00:a0 (IDLE) succeeded
[  125.773441] ata2.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
[  125.775032] ata2.00: configured for UDMA/66
[  128.253678] e1000e: em1 NIC Link is Up 100 Mbps Full Duplex, Flow Control: None
[  128.253686] e1000e 0000:00:19.0: em1: 10/100 speed: disabling TSO
[  128.499934] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
[  128.499945] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
[  128.499952] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
[  128.501667] ata1.00: configured for UDMA/100
[  128.501962] sd 0:0:0:0: [sda] Starting disk
[  128.503185] Extended CMOS year: 2000
[  128.537762] PM: resume of devices complete after 3229.628 msecs
[  129.025353] PM: Finishing wakeup.
[  129.028514] Restarting tasks ... done.
[  129.046206] video LNXVIDEO:00: Restoring backlight state
[  129.050252] video LNXVIDEO:01: Restoring backlight state


However, if I set none to pm_test and echo mem > /sys/power/state, no such error
message is seen. Same with normal pm-suspend - no error messages.


And when this patch is applied, the ACPI error messages during processors level
test appear twice:


[  780.064004] PM: Syncing filesystems ... done.
[  780.284925] PM: Preparing system for mem sleep
[  780.361141] Freezing user space processes ... (elapsed 0.01 seconds) done.
[  780.373711] Freezing remaining freezable tasks ... (elapsed 0.01 seconds) done.
[  780.386269] PM: Entering mem sleep
[  780.387856] Suspending console(s) (use no_console_suspend to debug)
[  780.564624] sd 0:0:0:0: [sda] Synchronizing SCSI cache
[  780.564943] sd 0:0:0:0: [sda] Stopping disk
[  780.803771] [drm] nouveau 0000:01:00.0: Disabling display...
[  780.804094] ACPI handle has no context!
[  780.804103] [drm] nouveau 0000:01:00.0: Disabling fbcon...
[  780.804111] [drm] nouveau 0000:01:00.0: Unpinning framebuffer(s)...
[  780.804203] [drm] nouveau 0000:01:00.0: Evicting buffers...
[  780.817629] i915 0000:00:02.0: power state changed by ACPI to D3
[  780.818811] [drm] nouveau 0000:01:00.0: Idling channels...
[  780.818918] [drm] nouveau 0000:01:00.0: Suspending GPU objects...
[  781.017536] e1000e 0000:00:19.0: wake-up capability enabled by ACPI
[  781.038014] [drm] nouveau 0000:01:00.0: And we're gone!
[  781.048804] nouveau 0000:01:00.0: power state changed by ACPI to D3
[  781.049048] PM: suspend of devices complete after 658.847 msecs
[  781.051298] ehci_hcd 0000:00:1d.0: wake-up capability enabled by ACPI
[  781.061543] ehci_hcd 0000:00:1d.0: power state changed by ACPI to D3
[  781.062247] ehci_hcd 0000:00:1a.0: wake-up capability enabled by ACPI
[  781.072540] ehci_hcd 0000:00:1a.0: power state changed by ACPI to D3
[  781.073173] PM: late suspend of devices complete after 24.125 msecs
[  781.073913] ACPI: Preparing to enter system sleep state S3
[  781.119604] PM: Saving platform NVS memory
[  781.135454] Disabling non-boot CPUs ...
[  781.137842] CPU 1 is now offline
[  781.142204] CPU 2 is now offline
[  781.146111] CPU 3 is now offline
[  781.146113] lockdep: fixing up alternatives.
[  781.146602] suspend debug: Waiting for 5 seconds.
[  786.143612] sched: RT throttling activated
[  786.157584] Enabling non-boot CPUs ...
[  786.187784] lockdep: fixing up alternatives.
[  786.187789] Booting Node 0 Processor 1 APIC 0x1
[  786.187791] smpboot cpu 1: start_ip = 98000
[  786.198818] Disabled fast string operations
[  786.198837] Calibrating delay loop (skipped) already calibrated this CPU
[  786.413560] NMI watchdog enabled, takes one hw-pmu counter.
[  786.413968] ACPI Exception: AE_BAD_PARAMETER, Returned by Handler for [EmbeddedControl] (20120111/evregion-501)
[  786.413977] ACPI Error: Method parse/execution failed [\_SB_.PCI0.LPC_.EC__.LPMD] (Node ffff88023286cc58), AE_BAD_PARAMETER (20120111/psparse-536)
[  786.413992] ACPI Error: Method parse/execution failed [\_PR_.CPU0._PPC] (Node ffff8802328900f0), AE_BAD_PARAMETER (20120111/psparse-536)
[  786.414004] ACPI Error: Method parse/execution failed [\_PR_.CPU1._PPC] (Node ffff880232890910), AE_BAD_PARAMETER (20120111/psparse-536)
[  786.414021] ACPI Exception: AE_BAD_PARAMETER, Evaluating _PPC (20120111/processor_perflib-140)
[  786.414511] ACPI Exception: AE_BAD_PARAMETER, Returned by Handler for [EmbeddedControl] (20120111/evregion-501)
[  786.414519] ACPI Error: Method parse/execution failed [\_SB_.PCI0.LPC_.EC__.LPMD] (Node ffff88023286cc58), AE_BAD_PARAMETER (20120111/psparse-536)
[  786.414533] ACPI Error: Method parse/execution failed [\_PR_.CPU0._PPC] (Node ffff8802328900f0), AE_BAD_PARAMETER (20120111/psparse-536)
[  786.414547] ACPI Error: Method parse/execution failed [\_PR_.CPU1._PPC] (Node ffff880232890910), AE_BAD_PARAMETER (20120111/psparse-536)
[  786.414565] ACPI Exception: AE_BAD_PARAMETER, Evaluating _PPC (20120111/processor_perflib-140)
[  786.414601] CPU1 is up
[  786.414784] lockdep: fixing up alternatives.
[  786.414790] Booting Node 0 Processor 2 APIC 0x2
[  786.414793] smpboot cpu 2: start_ip = 98000
[  786.425827] Disabled fast string operations
[  786.425846] Calibrating delay loop (skipped) already calibrated this CPU
[  786.446749] NMI watchdog enabled, takes one hw-pmu counter.
[  786.447159] ACPI Exception: AE_BAD_PARAMETER, Returned by Handler for [EmbeddedControl] (20120111/evregion-501)
[  786.447168] ACPI Error: Method parse/execution failed [\_SB_.PCI0.LPC_.EC__.LPMD] (Node ffff88023286cc58), AE_BAD_PARAMETER (20120111/psparse-536)
[  786.447183] ACPI Error: Method parse/execution failed [\_PR_.CPU0._PPC] (Node ffff8802328900f0), AE_BAD_PARAMETER (20120111/psparse-536)
[  786.447194] ACPI Error: Method parse/execution failed [\_PR_.CPU2._PPC] (Node ffff880232890ac8), AE_BAD_PARAMETER (20120111/psparse-536)
[  786.447212] ACPI Exception: AE_BAD_PARAMETER, Evaluating _PPC (20120111/processor_perflib-140)
[  786.447570] ACPI Exception: AE_BAD_PARAMETER, Returned by Handler for [EmbeddedControl] (20120111/evregion-501)
[  786.447576] ACPI Error: Method parse/execution failed [\_SB_.PCI0.LPC_.EC__.LPMD] (Node ffff88023286cc58), AE_BAD_PARAMETER (20120111/psparse-536)
[  786.447586] ACPI Error: Method parse/execution failed [\_PR_.CPU0._PPC] (Node ffff8802328900f0), AE_BAD_PARAMETER (20120111/psparse-536)
[  786.447594] ACPI Error: Method parse/execution failed [\_PR_.CPU2._PPC] (Node ffff880232890ac8), AE_BAD_PARAMETER (20120111/psparse-536)
[  786.447605] ACPI Exception: AE_BAD_PARAMETER, Evaluating _PPC (20120111/processor_perflib-140)
[  786.447631] CPU2 is up
[  786.447757] lockdep: fixing up alternatives.
[  786.447761] Booting Node 0 Processor 3 APIC 0x3
[  786.447763] smpboot cpu 3: start_ip = 98000
[  786.458790] Disabled fast string operations
[  786.458810] Calibrating delay loop (skipped) already calibrated this CPU
[  786.479664] NMI watchdog enabled, takes one hw-pmu counter.
[  786.479987] ACPI Exception: AE_BAD_PARAMETER, Returned by Handler for [EmbeddedControl] (20120111/evregion-501)
[  786.479993] ACPI Error: Method parse/execution failed [\_SB_.PCI0.LPC_.EC__.LPMD] (Node ffff88023286cc58), AE_BAD_PARAMETER (20120111/psparse-536)
[  786.480003] ACPI Error: Method parse/execution failed [\_PR_.CPU0._PPC] (Node ffff8802328900f0), AE_BAD_PARAMETER (20120111/psparse-536)
[  786.480010] ACPI Error: Method parse/execution failed [\_PR_.CPU3._PPC] (Node ffff880232890a28), AE_BAD_PARAMETER (20120111/psparse-536)
[  786.480021] ACPI Exception: AE_BAD_PARAMETER, Evaluating _PPC (20120111/processor_perflib-140)
[  786.480352] ACPI Exception: AE_BAD_PARAMETER, Returned by Handler for [EmbeddedControl] (20120111/evregion-501)
[  786.480357] ACPI Error: Method parse/execution failed [\_SB_.PCI0.LPC_.EC__.LPMD] (Node ffff88023286cc58), AE_BAD_PARAMETER (20120111/psparse-536)
[  786.480366] ACPI Error: Method parse/execution failed [\_PR_.CPU0._PPC] (Node ffff8802328900f0), AE_BAD_PARAMETER (20120111/psparse-536)
[  786.480374] ACPI Error: Method parse/execution failed [\_PR_.CPU3._PPC] (Node ffff880232890a28), AE_BAD_PARAMETER (20120111/psparse-536)
[  786.480385] ACPI Exception: AE_BAD_PARAMETER, Evaluating _PPC (20120111/processor_perflib-140)
[  786.480410] CPU3 is up
[  786.483786] ACPI: Waking up from system sleep state S3
[  786.569882] i915 0000:00:02.0: power state changed by ACPI to D0
[  786.580658] i915 0000:00:02.0: power state changed by ACPI to D0
[  786.602728] ehci_hcd 0000:00:1a.0: power state changed by ACPI to D0
[  786.613647] ehci_hcd 0000:00:1a.0: power state changed by ACPI to D0
[  786.613729] ehci_hcd 0000:00:1a.0: wake-up capability disabled by ACPI
[  786.613739] ehci_hcd 0000:00:1a.0: power state changed by ACPI to D0
[  786.613745] ehci_hcd 0000:00:1a.0: power state changed by ACPI to D0
[  786.625038] ehci_hcd 0000:00:1d.0: power state changed by ACPI to D0
[  786.635638] ehci_hcd 0000:00:1d.0: power state changed by ACPI to D0
[  786.635720] ehci_hcd 0000:00:1d.0: wake-up capability disabled by ACPI
[  786.635729] ehci_hcd 0000:00:1d.0: power state changed by ACPI to D0
[  786.635734] ehci_hcd 0000:00:1d.0: power state changed by ACPI to D0
[  786.647039] nouveau 0000:01:00.0: power state changed by ACPI to D0
[  786.657628] nouveau 0000:01:00.0: power state changed by ACPI to D0
[  786.668781] sdhci-pci 0000:0d:00.0: MMC controller base frequency changed to 50Mhz.
[  786.669062] PM: early resume of devices complete after 99.409 msecs
[  786.669186] i915 0000:00:02.0: power state changed by ACPI to D0
[  786.669195] i915 0000:00:02.0: power state changed by ACPI to D0
[  786.669202] i915 0000:00:02.0: setting latency timer to 64
[  786.669210] e1000e 0000:00:19.0: wake-up capability disabled by ACPI
[  786.669348] e1000e 0000:00:19.0: irq 43 for MSI/MSI-X
[  786.669774] ehci_hcd 0000:00:1a.0: power state changed by ACPI to D0
[  786.669783] ehci_hcd 0000:00:1a.0: power state changed by ACPI to D0
[  786.669799] ehci_hcd 0000:00:1a.0: setting latency timer to 64
[  786.669924] snd_hda_intel 0000:00:1b.0: irq 44 for MSI/MSI-X
[  786.670024] ehci_hcd 0000:00:1d.0: power state changed by ACPI to D0
[  786.670031] ehci_hcd 0000:00:1d.0: power state changed by ACPI to D0
[  786.670044] ehci_hcd 0000:00:1d.0: setting latency timer to 64
[  786.670100] ahci 0000:00:1f.2: setting latency timer to 64
[  786.670327] [drm] nouveau 0000:01:00.0: We're back, enabling device...
[  786.670333] nouveau 0000:01:00.0: power state changed by ACPI to D0
[  786.670340] nouveau 0000:01:00.0: power state changed by ACPI to D0
[  786.670348] nouveau 0000:01:00.0: power state changed by ACPI to D0
[  786.670355] nouveau 0000:01:00.0: power state changed by ACPI to D0
[  786.670363] [drm] nouveau 0000:01:00.0: POSTing device...
[  786.670366] [drm] nouveau 0000:01:00.0: Parsing VBIOS init table 0 at offset 0x73B5
[  786.690739] [drm] nouveau 0000:01:00.0: 0x7393: i2c wr fail: -5
[  786.690892] [drm] nouveau 0000:01:00.0: 0x73A5: i2c rd fail: -5
[  786.711427] [drm] nouveau 0000:01:00.0: Parsing VBIOS init table 1 at offset 0x7A29
[  786.717630] tpm_tis 00:0a: A TPM error (6) occurred attempting to read a pcr value
[  786.717633] tpm_tis 00:0a: TPM is disabled/deactivated (0x6)
[  786.718481] [drm] nouveau 0000:01:00.0: Parsing VBIOS init table 2 at offset 0x89D9
[  786.718483] [drm] nouveau 0000:01:00.0: Parsing VBIOS init table 3 at offset 0x89DA
[  786.718538] [drm] nouveau 0000:01:00.0: Parsing VBIOS init table 4 at offset 0x8ACB
[  786.718539] [drm] nouveau 0000:01:00.0: Parsing VBIOS init table at offset 0x8B30
[  786.738553] [drm] nouveau 0000:01:00.0: Restoring GPU objects...
[  786.773642] [drm] nouveau 0000:01:00.0: Reinitialising engines...
[  786.773786] [drm] nouveau 0000:01:00.0: Restoring mode...
[  786.985584] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[  786.987582] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[  786.988338] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
[  786.988348] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
[  786.988355] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
[  786.989589] ata5: SATA link down (SStatus 0 SControl 300)
[  786.991596] ata4: SATA link down (SStatus 0 SControl 300)
[  787.111651] ata2.00: ACPI cmd e3/00:1f:00:00:00:a0 (IDLE) succeeded
[  787.111857] ata2.00: ACPI cmd e3/00:02:00:00:00:a0 (IDLE) succeeded
[  787.111865] ata2.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
[  787.116309] ata2.00: ACPI cmd e3/00:1f:00:00:00:a0 (IDLE) succeeded
[  787.116554] ata2.00: ACPI cmd e3/00:02:00:00:00:a0 (IDLE) succeeded
[  787.116561] ata2.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
[  787.118059] ata2.00: configured for UDMA/66
[  789.825152] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
[  789.825165] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
[  789.825174] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
[  789.826998] ata1.00: configured for UDMA/100
[  789.827186] sd 0:0:0:0: [sda] Starting disk
[  789.856776] PM: resume of devices complete after 3188.667 msecs
[  790.001194] PM: Finishing wakeup.
[  790.001196] Restarting tasks ... done.
[  790.010857] video LNXVIDEO:00: Restoring backlight state
[  790.016656] video LNXVIDEO:01: Restoring backlight state
[  790.511508] e1000e: em1 NIC Link is Up 100 Mbps Full Duplex, Flow Control: None
[  790.511525] e1000e 0000:00:19.0: em1: 10/100 speed: disabling TSO> 


>From what I can tell, these error messages are coming from this piece of
code:

drivers/acpi/processor_perflib.c:
static int acpi_processor_get_platform_limit(struct acpi_processor *pr)
{
	...

        /*  
         * _PPC indicates the maximum state currently supported by the platform
         * (e.g. 0 = states 0..n; 1 = states 1..n; etc.
         */
        status = acpi_evaluate_integer(pr->handle, "_PPC", NULL, &ppc);

        if (status != AE_NOT_FOUND)
                acpi_processor_ppc_status |= PPC_IN_USE;

        if (ACPI_FAILURE(status) && status != AE_NOT_FOUND) {
                ACPI_EXCEPTION((AE_INFO, status, "Evaluating _PPC"));
                return -ENODEV;
        }  
 
	...
}

So I guess, with my patch this is being invoked twice, but I am not quite sure
how..
I mean, one path is acpi_cpu_soft_notify -> acpi_processor_ppc_has_changed()
-> acpi_processor_get_platform_limit().

I don't know what's the other path. I guess it is acpi_processor_notify() -> ...

Of course, the more important problem here is to find out what is going wrong
with processors level pm_test :-)

> 
>>  drivers/acpi/processor_driver.c |    6 ++++++
>>  1 files changed, 6 insertions(+), 0 deletions(-)
>>
>> diff --git a/drivers/acpi/processor_driver.c b/drivers/acpi/processor_driver.c
>> index 2801b41..3a87b13 100644
>> --- a/drivers/acpi/processor_driver.c
>> +++ b/drivers/acpi/processor_driver.c
>> @@ -422,6 +422,12 @@ static int acpi_cpu_soft_notify(struct notifier_block *nfb,
>>  	unsigned int cpu = (unsigned long)hcpu;
>>  	struct acpi_processor *pr = per_cpu(processors, cpu);
>>  
>> +	/*
>> +	 * Regular CPU hotplug, and CPU hotplug as part of the suspend/resume
>> +	 * sequence are really no different for us. So, let us handle both.
>> +	 */
>> +	action &= ~CPU_TASKS_FROZEN;
>> +
>>  	if (action == CPU_ONLINE && pr) {
>>  		/* CPU got physically hotplugged and onlined the first time:
>>  		 * Initialize missing things
>>

 
Regards,
Srivatsa S. Bhat

