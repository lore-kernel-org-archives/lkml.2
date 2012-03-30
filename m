Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933755Ab2C3LE7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 07:04:59 -0400
Received: from mondschein.lichtvoll.de ([194.150.191.11]:43871 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759426Ab2C3LEv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 07:04:51 -0400
From: Martin Steigerwald <Martin@lichtvoll.de>
To: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org
Subject: [REGRESSION] NMI received for unknown reason 3c on CPU 0, strange powersaving mode?
Date: Fri, 30 Mar 2012 13:04:49 +0200
User-Agent: KMail/1.13.7 (Linux/3.3.0-trunk-amd64; KDE/4.7.4; x86_64; ; )
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <201203301304.49708.Martin@lichtvoll.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

Since some time I am seeing things like

Message from syslogd@merkaba at Mar 30 00:29:30 ...
 kernel:[49074.294260] Uhhuh. NMI received for unknown reason 3c on CPU 0.

Message from syslogd@merkaba at Mar 30 00:29:30 ...
 kernel:[49074.294263] Do you have a strange power saving mode enabled?

Message from syslogd@merkaba at Mar 30 00:29:30 ...
 kernel:[49074.294264] Dazed and confused, but trying to continue

on resume after in-kernel hibernation.

I do not see any trace of it in syslog, kern.log or dmesg.

>From the timestemp it seems that these messages are issued shortly before 
I send the laptop to hibernation last night.


I am using a ThinkPad T520 with Intel(R) Core(TM) i5-2520M CPU @ 2.50GHz 
and Sandybridge graphics.

I am not exactly sure since when it happens, cause I basically ignored it 
for quite some time. Might be some 3.2 kernel where it started, maybe even 
the first 3.2 kernel I had. Currently I am using:

martin@merkaba:~> cat /proc/version
Linux version 3.3.0-trunk-amd64 (Debian 3.3-1~experimental.1) (debian-
kernel@lists.debian.org) (gcc version 4.6.3 (Debian 4.6.3-1) ) #1 SMP Thu 
Mar 22 18:02:10 UTC 2012

Since I am quite sure I didn´t see this with the first kernel I used on 
this machine, which was a 2.6.39 if I remember correctly, I consider this 
to be a regression for now.


I did not see any other strange effects, only this message.


When searching for it I see quite some references¹. But what I looked at 
seemed to either quite old or different in that the machine was frozen 
then.


There seems to be some hints that its related to USB power management.

Here is what powertop says about the autosuspend settings - I did not 
change anything in there:

   Bad           Wireless Power Saving for interface wlan0            
   Bad           Enable SATA link power management for /dev/sda
   Bad           Power Aware CPU scheduler
   Bad           VM writeback timeout
   Bad           Enable Audio codec power management
   Bad           Autosuspend for USB device Biometric Coprocessor (UPE
   Bad           Autosuspend for USB device Integrated Smart Card Read
   Bad           Autosuspend for USB device USB-PS/2 Optical Mouse (Lo
   Bad           Runtime PM for PCI Device Ricoh Co Ltd MMC/SD Host Co
   Bad           Runtime PM for PCI Device Intel Corporation 2nd Gener
   Bad           Runtime PM for PCI Device Intel Corporation 2nd Gener
   Bad           Runtime PM for PCI Device Intel Corporation 82579LM G
   Bad           Runtime PM for PCI Device Intel Corporation 6 Series/
   Bad           Runtime PM for PCI Device Intel Corporation 6 Series/
   Bad           Runtime PM for PCI Device Ricoh Co Ltd FireWire Host
   Bad           Runtime PM for PCI Device Intel Corporation 6 Series/
   Bad           Runtime PM for PCI Device Intel Corporation 6 Series/
   Bad           Runtime PM for PCI Device Silicon Image, Inc. SiI 353
   Bad           Runtime PM for PCI Device Intel Corporation 6 Series/
   Bad           Runtime PM for PCI Device Intel Corporation 6 Series/
   Bad           Runtime PM for PCI Device Intel Corporation 6 Series/
   Bad           Runtime PM for PCI Device Intel Corporation 6 Series/
   Bad           Runtime PM for PCI Device Intel Corporation 6 Series/
   Bad           Runtime PM for PCI Device Intel Corporation Centrino
   Good          NMI watchdog should be turned off
   Good          Autosuspend for unknown USB device 1-1.5 (17ef:100a)
   Good          Autosuspend for unknown USB device 1-1 (8087:0024)
   Good          Autosuspend for unknown USB device 2-1 (8087:0024)
   Good          Autosuspend for USB device EHCI Host Controller [usb1
   Good          Autosuspend for USB device EHCI Host Controller [usb2
   Good          Wake-on-lan status for device eth0
   Good          Wake-on-lan status for device wlan0
   Good          Using 'ondemand' cpufreq governor

merkaba:~> lsusb 
Bus 001 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
Bus 002 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
Bus 001 Device 002: ID 8087:0024 Intel Corp. Integrated Rate Matching Hub
Bus 002 Device 002: ID 8087:0024 Intel Corp. Integrated Rate Matching Hub
Bus 001 Device 003: ID 147e:2016 Upek Biometric Touchchip/Touchstrip 
Fingerprint Sensor
Bus 001 Device 004: ID 17ef:100a Lenovo ThinkPad Mini Dock Plus Series 3
Bus 002 Device 003: ID 17ef:1003 Lenovo Integrated Smart Card Reader
Bus 001 Device 005: ID 046d:c00e Logitech, Inc. M-BJ58/M-BJ69 Optical 
Wheel Mouse


But I think I have seen it at work as well where I use different USB 
devices (except for the builtin) and no Minidock for now.


As for other settings that might be related:

merkaba:~> cat /etc/modprobe.d/i915-kms.conf 
# Thorsten Leemhuis, Die Woche: Ungenutztes Stromsparpotenzial
# http://www.heise.de/open/artikel/Die-Woche-Ungenutztes-
Stromsparpotenzial-1361381.html
# Eugeni Dodonov, Intel Linux Graphics
# Following the open source road from Kernel to UI toolkits
# http://www.scribd.com/doc/73071712/Intel-Linux-Graphics
# i915_enable_fbc wieder aus, da:
# Enabling FBC is causing the BLT ring to run between 10-100x slower than
# normal and frequently lockup. The interim solution is disable FBC once
# more until we know why.
# http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;
# a=commitdiff;h=d56d8b28e9247e7e35e02fbb12b12239a2c33ad1
options i915 modeset=1 i915_enable_rc6=1 semaphores=1


/etc/sysfs.conf:
# Werner Fischer, ADMIN 03/2011
# Schnelligkeit ist keine Hexerei
# http://www.admin-magazin.de/Das-Heft/2011/03/SSD-Performance-optimieren
class/scsi_host/host1/link_power_management_policy = min_power
class/scsi_host/host2/link_power_management_policy = min_power
# eSATA-Port
class/scsi_host/host3/link_power_management_policy = medium_power
class/scsi_host/host4/link_power_management_policy = min_power
class/scsi_host/host5/link_power_management_policy = min_power
class/scsi_host/host6/link_power_management_policy = min_power

# c`t kompakt Linux 1/2012
# Thorsten Leemhuis, Notebooks unter Linux, S. 38ff
# S. 42, Kasten Handoptimiert
devices/system/cpu/sched_mc_power_savings = 1
# Macht modprobe/kmod anhand von /etc/modprobe.d/snd-hda-intel.conf 
derzeit nicht.
module/snd_hda_intel/parameters/power_save = 1

# By setting this to '1', under light load scenarios, the process load is
# distributed such that all the threads in a core and all the cores in a
# processor package are busy before distributing the process load to
# threads and cores, in other processor packages.
# http://lesswatts.org/tips/cpu.php#smpsched
devices/system/cpu/sched_smt_power_savings = 1


/etc/grub/default:

GRUB_CMDLINE_LINUX_DEFAULT="threadirqsi init=/bin/systemd"

Which is currently not used due to my Vim typo in there.

I am using systemd only since last week and think that I have seen the 
message before.


Anyway, if you suggest to alter some settings, please tell me and I will 
try it.

If you need additional info like dmidecode or something please tell me as 
well.


[1] https://bugs.launchpad.net/ubuntu/+source/linux-
source-2.6.20/+bug/116752 and quite some others

Ciao,
-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
