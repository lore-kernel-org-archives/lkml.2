Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752287Ab2DBLFU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 07:05:20 -0400
Received: from e28smtp07.in.ibm.com ([122.248.162.7]:33140 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751047Ab2DBLFS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 07:05:18 -0400
Message-ID: <4F7987D0.3090106@linux.vnet.ibm.com>
Date: Mon, 02 Apr 2012 16:34:48 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Martin Steigerwald <Martin@lichtvoll.de>
CC: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        a.p.zijlstra@chello.nl, stern@rowland.harvard.edu, rjw@sisk.pl,
        pavel@ucw.cz
Subject: Re: [REGRESSION] NMI received for unknown reason 3c on CPU 0, strange
 powersaving mode?
References: <201203301304.49708.Martin@lichtvoll.de>
In-Reply-To: <201203301304.49708.Martin@lichtvoll.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
x-cbid: 12040211-8878-0000-0000-000001EA5380
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/30/2012 04:34 PM, Martin Steigerwald wrote:

> Hi!
> 
> Since some time I am seeing things like
> 
> Message from syslogd@merkaba at Mar 30 00:29:30 ...
>  kernel:[49074.294260] Uhhuh. NMI received for unknown reason 3c on CPU 0.
> 
> Message from syslogd@merkaba at Mar 30 00:29:30 ...
>  kernel:[49074.294263] Do you have a strange power saving mode enabled?
> 
> Message from syslogd@merkaba at Mar 30 00:29:30 ...
>  kernel:[49074.294264] Dazed and confused, but trying to continue
> 
> on resume after in-kernel hibernation.
> 


Do you see this after suspend-to-ram too?

> I do not see any trace of it in syslog, kern.log or dmesg.
> 
> From the timestemp it seems that these messages are issued shortly before 
> I send the laptop to hibernation last night.
> 
> 
> I am using a ThinkPad T520 with Intel(R) Core(TM) i5-2520M CPU @ 2.50GHz 
> and Sandybridge graphics.
> 
> I am not exactly sure since when it happens, cause I basically ignored it 
> for quite some time. Might be some 3.2 kernel where it started, maybe even 
> the first 3.2 kernel I had. Currently I am using:
> 
> martin@merkaba:~> cat /proc/version
> Linux version 3.3.0-trunk-amd64 (Debian 3.3-1~experimental.1) (debian-
> kernel@lists.debian.org) (gcc version 4.6.3 (Debian 4.6.3-1) ) #1 SMP Thu 
> Mar 22 18:02:10 UTC 2012
> 
> Since I am quite sure I didn´t see this with the first kernel I used on 
> this machine, which was a 2.6.39 if I remember correctly, I consider this 
> to be a regression for now.
> 
> 
> I did not see any other strange effects, only this message.
> 
> 
> When searching for it I see quite some references¹. But what I looked at 
> seemed to either quite old or different in that the machine was frozen 
> then.
> 


There was once such a bug report and commit 144060fee (perf: Add PM notifiers
to fix CPU hotplug races) tried to fix it, however it didn't work out IIRC.

Can you please try out the pm-test framework and let us know in which phase
this message is encountered?
Documentation/power/basic-pm-debugging.txt

1. Recompile the kernel with CONFIG_PM_DEBUG=y
2. # cat /sys/power/pm_test
3. # echo <value> > /sys/power/pm_test
   Use the values from the list given in step 2.
   From freezer to core, it is increasing depth of suspend phase.
4. # echo mem > /sys/power/state  (for suspend-to-ram)
   or echo disk > /sys/power/state  (for suspend-to-disk)

It would be great if you could tell which of the phases (freezer to core)
fails.

> 
> There seems to be some hints that its related to USB power management.
> 


Adding Alan Stern to CC.

> Here is what powertop says about the autosuspend settings - I did not 
> change anything in there:
> 
>    Bad           Wireless Power Saving for interface wlan0            
>    Bad           Enable SATA link power management for /dev/sda
>    Bad           Power Aware CPU scheduler
>    Bad           VM writeback timeout
>    Bad           Enable Audio codec power management
>    Bad           Autosuspend for USB device Biometric Coprocessor (UPE
>    Bad           Autosuspend for USB device Integrated Smart Card Read
>    Bad           Autosuspend for USB device USB-PS/2 Optical Mouse (Lo
>    Bad           Runtime PM for PCI Device Ricoh Co Ltd MMC/SD Host Co
>    Bad           Runtime PM for PCI Device Intel Corporation 2nd Gener
>    Bad           Runtime PM for PCI Device Intel Corporation 2nd Gener
>    Bad           Runtime PM for PCI Device Intel Corporation 82579LM G
>    Bad           Runtime PM for PCI Device Intel Corporation 6 Series/
>    Bad           Runtime PM for PCI Device Intel Corporation 6 Series/
>    Bad           Runtime PM for PCI Device Ricoh Co Ltd FireWire Host
>    Bad           Runtime PM for PCI Device Intel Corporation 6 Series/
>    Bad           Runtime PM for PCI Device Intel Corporation 6 Series/
>    Bad           Runtime PM for PCI Device Silicon Image, Inc. SiI 353
>    Bad           Runtime PM for PCI Device Intel Corporation 6 Series/
>    Bad           Runtime PM for PCI Device Intel Corporation 6 Series/
>    Bad           Runtime PM for PCI Device Intel Corporation 6 Series/
>    Bad           Runtime PM for PCI Device Intel Corporation 6 Series/
>    Bad           Runtime PM for PCI Device Intel Corporation 6 Series/
>    Bad           Runtime PM for PCI Device Intel Corporation Centrino
>    Good          NMI watchdog should be turned off
>    Good          Autosuspend for unknown USB device 1-1.5 (17ef:100a)
>    Good          Autosuspend for unknown USB device 1-1 (8087:0024)
>    Good          Autosuspend for unknown USB device 2-1 (8087:0024)
>    Good          Autosuspend for USB device EHCI Host Controller [usb1
>    Good          Autosuspend for USB device EHCI Host Controller [usb2
>    Good          Wake-on-lan status for device eth0
>    Good          Wake-on-lan status for device wlan0
>    Good          Using 'ondemand' cpufreq governor
> 
> merkaba:~> lsusb 
> Bus 001 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
> Bus 002 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
> Bus 001 Device 002: ID 8087:0024 Intel Corp. Integrated Rate Matching Hub
> Bus 002 Device 002: ID 8087:0024 Intel Corp. Integrated Rate Matching Hub
> Bus 001 Device 003: ID 147e:2016 Upek Biometric Touchchip/Touchstrip 
> Fingerprint Sensor
> Bus 001 Device 004: ID 17ef:100a Lenovo ThinkPad Mini Dock Plus Series 3
> Bus 002 Device 003: ID 17ef:1003 Lenovo Integrated Smart Card Reader
> Bus 001 Device 005: ID 046d:c00e Logitech, Inc. M-BJ58/M-BJ69 Optical 
> Wheel Mouse
> 
> 
> But I think I have seen it at work as well where I use different USB 
> devices (except for the builtin) and no Minidock for now.
> 
> 
> As for other settings that might be related:
> 
> merkaba:~> cat /etc/modprobe.d/i915-kms.conf 
> # Thorsten Leemhuis, Die Woche: Ungenutztes Stromsparpotenzial
> # http://www.heise.de/open/artikel/Die-Woche-Ungenutztes-
> Stromsparpotenzial-1361381.html
> # Eugeni Dodonov, Intel Linux Graphics
> # Following the open source road from Kernel to UI toolkits
> # http://www.scribd.com/doc/73071712/Intel-Linux-Graphics
> # i915_enable_fbc wieder aus, da:
> # Enabling FBC is causing the BLT ring to run between 10-100x slower than
> # normal and frequently lockup. The interim solution is disable FBC once
> # more until we know why.
> # http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;
> # a=commitdiff;h=d56d8b28e9247e7e35e02fbb12b12239a2c33ad1
> options i915 modeset=1 i915_enable_rc6=1 semaphores=1
> 
> 
> /etc/sysfs.conf:
> # Werner Fischer, ADMIN 03/2011
> # Schnelligkeit ist keine Hexerei
> # http://www.admin-magazin.de/Das-Heft/2011/03/SSD-Performance-optimieren
> class/scsi_host/host1/link_power_management_policy = min_power
> class/scsi_host/host2/link_power_management_policy = min_power
> # eSATA-Port
> class/scsi_host/host3/link_power_management_policy = medium_power
> class/scsi_host/host4/link_power_management_policy = min_power
> class/scsi_host/host5/link_power_management_policy = min_power
> class/scsi_host/host6/link_power_management_policy = min_power
> 
> # c`t kompakt Linux 1/2012
> # Thorsten Leemhuis, Notebooks unter Linux, S. 38ff
> # S. 42, Kasten Handoptimiert
> devices/system/cpu/sched_mc_power_savings = 1
> # Macht modprobe/kmod anhand von /etc/modprobe.d/snd-hda-intel.conf 
> derzeit nicht.
> module/snd_hda_intel/parameters/power_save = 1
> 
> # By setting this to '1', under light load scenarios, the process load is
> # distributed such that all the threads in a core and all the cores in a
> # processor package are busy before distributing the process load to
> # threads and cores, in other processor packages.
> # http://lesswatts.org/tips/cpu.php#smpsched
> devices/system/cpu/sched_smt_power_savings = 1
> 
> 
> /etc/grub/default:
> 
> GRUB_CMDLINE_LINUX_DEFAULT="threadirqsi init=/bin/systemd"
> 
> Which is currently not used due to my Vim typo in there.
> 
> I am using systemd only since last week and think that I have seen the 
> message before.
> 
> 
> Anyway, if you suggest to alter some settings, please tell me and I will 
> try it.
> 
> If you need additional info like dmidecode or something please tell me as 
> well.
> 
> 
> [1] https://bugs.launchpad.net/ubuntu/+source/linux-
> source-2.6.20/+bug/116752 and quite some others
> 
> Ciao,


