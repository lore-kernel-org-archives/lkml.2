Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753751Ab0JHF0J (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 01:26:09 -0400
Received: from mailx.hitachi.co.jp ([133.145.228.49]:45285 "EHLO
	mailx.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752606Ab0JHFZx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 01:25:53 -0400
X-AuditID: b753bd60-a9cd2ba000005dcc-c0-4caeaadb8b9a
Message-ID: <4CAEAAD4.2080504@hitachi.com>
Date: Fri, 08 Oct 2010 14:23:32 +0900
From: Nao Nishijima <nao.nishijima.xt@hitachi.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.2.9) Gecko/20100915 Thunderbird/3.1.4
MIME-Version: 1.0
To: gregkh@suse.de, James.Bottomley@suse.de, rwheeler@redhat.com
Cc: linux-kernel@vger.kernel.org, linux-hotplug-devel@lists.sourceforge.net,
        linux-hotplug@vger.kernel.org, masami.hiramatsu.pt@hitachi.com
Subject: [RFD] Device Renaming Mechanism
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
X-FMFTCR: RANGEC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'm trying to solve a device name(or device node) mismatch problem caused by
device configuration changes. Now I have an idea of device renaming to solve it,
and would like to request for comments from kernel developers.


Device Name Mismatch
====================

Device names(e.g. sda) are assigned by the order of driver loading and device
recognizing (usually from small bus number). This may cause a device name
mismatch between previous and current boot whenever the device configuration is
changed. Suppose there is an application opens disk via /dev/sdb. When device
configuration changing (hot-plug, device breakdown) or system configuration
changing(driver loading order, changing modprobe.conf) causes changing order
device names. This device names does not always point to same disks.

This mismatch causes unexpected disk access and redundancy miss setting (e.g.
Multipath, software-raid), if you use device file names to a configuration file.


Udev Solution
=============

Typically we use to avoid this problem we uses persistent device names provided
by udev.

Udev makes persistent symbolic links(by-{id, uuid, path, label}) pointing to each
device based on device information. Applications access the device via these
symbolic links. Udev solves mismatch between device name and physical disk.
However the persistent name mismatches kernel's device name.
This mismatch causes following 4 issues.

Issue 1: /proc/partitions, /proc/diskstat gives you device names
We have to run "ls -l /dev/disk/by-*" or "udevadm" for finding corresponding
persistent symbolic links.

Issue 2: dmesg output device name instead of persistent symbolic links
Users might not know which disk is sdX, because they identify the disk by a
persistent symbolic link.

Issue 3: Some system commands don't accept symbolic link(e.g. df, iostat,...)
These commands just expect sdX device name or check input by /proc information.
This will also occur on several GNOME/KDE/etc GUI sysadmin tools. :(

Issue 4: Undecided symbolic link
Even if we would like to introduce device names/persistent symbolic links
mapping tool to solve it, we can not determine a symbolic link from a device,
because several symbolic links point a device file.

Therefore, I think the symbolic link is not enough to solve. We need a
better solution.


Proposal
========
I'd like to propose introducing device renaming interface to solve these issues.

I think renaming device name in the kernel is the simplest way to solve mismatch
dmesg and /proc information. This can be done while kernel booting up(like
ifcfg). Of course, udev still needs to assign new name for each device via that
interface.

This proposal just requests to add a simple interface to kernel as below. And we
can continue to use user program without any modification.

int rename_device(const char *newname, const char *oldname)

Any comments, or suggestions are very welcome!
Best Regards,

-- 
Nao NISHIJIMA
2nd Dept. Linux Technology Center
Hitachi, Ltd., Systems Development Laboratory
Email： nao.nishijima.xt@hitachi.com
