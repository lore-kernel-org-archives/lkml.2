Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759609Ab0JHUtp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 16:49:45 -0400
Received: from kroah.org ([198.145.64.141]:59488 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757681Ab0JHUto (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 16:49:44 -0400
Date: Fri, 8 Oct 2010 13:48:02 -0700
From: Greg KH <greg@kroah.com>
To: Nao Nishijima <nao.nishijima.xt@hitachi.com>
Cc: gregkh@suse.de, James.Bottomley@suse.de, rwheeler@redhat.com,
        linux-kernel@vger.kernel.org, linux-hotplug@vger.kernel.org,
        masami.hiramatsu.pt@hitachi.com
Subject: Re: [RFD] Device Renaming Mechanism
Message-ID: <20101008204802.GA21542@kroah.com>
References: <4CAEAAD4.2080504@hitachi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CAEAAD4.2080504@hitachi.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 08, 2010 at 02:23:32PM +0900, Nao Nishijima wrote:
> Hi,
> 
> I'm trying to solve a device name(or device node) mismatch problem caused by
> device configuration changes. Now I have an idea of device renaming to solve it,
> and would like to request for comments from kernel developers.

Hi,

We spoke at LinuxCon Tokyo about this, so it's good to see you continue
here on the mailing lists.

> Device Name Mismatch
> ====================
> 
> Device names(e.g. sda) are assigned by the order of driver loading and device
> recognizing (usually from small bus number). This may cause a device name
> mismatch between previous and current boot whenever the device configuration is
> changed.

This is as it always has been.

> This mismatch causes unexpected disk access and redundancy miss setting (e.g.
> Multipath, software-raid), if you use device file names to a configuration file.

That's why most people know to not use the kernel name for their fstab,
and why distros haven't for a very long time, used them when installing.

> Udev Solution
> =============
> 
> Typically we use to avoid this problem we uses persistent device names provided
> by udev.

Yes.

> Udev makes persistent symbolic links(by-{id, uuid, path, label}) pointing to each
> device based on device information. Applications access the device via these
> symbolic links. Udev solves mismatch between device name and physical disk.
> However the persistent name mismatches kernel's device name.
> This mismatch causes following 4 issues.
> 
> Issue 1: /proc/partitions, /proc/diskstat gives you device names
> We have to run "ls -l /dev/disk/by-*" or "udevadm" for finding corresponding
> persistent symbolic links.

That's fine, don't use the /proc files :)

> Issue 2: dmesg output device name instead of persistent symbolic links
> Users might not know which disk is sdX, because they identify the disk by a
> persistent symbolic link.

Again, that's fine as well, don't use "raw" dmesg output and expect it
to map to what the user has mounted.  There are a number of tools to
handle the mapping of this out there by companies (IBM, CA, etc.)

> Issue 3: Some system commands don't accept symbolic link(e.g. df, iostat,...)
> These commands just expect sdX device name or check input by /proc information.
> This will also occur on several GNOME/KDE/etc GUI sysadmin tools. :(

Then we should fix those programs, it is a simple one line change.  Can
you please tell us which programs you have tested and found problems
with?

> Issue 4: Undecided symbolic link
> Even if we would like to introduce device names/persistent symbolic links
> mapping tool to solve it, we can not determine a symbolic link from a device,
> because several symbolic links point a device file.

Huh?  You want to move from a kernel name to the one that the user used?
As you are the user, you should know which one you used :)

> Therefore, I think the symbolic link is not enough to solve. We need a
> better solution.

I strongly disagree.

> Proposal
> ========
> I'd like to propose introducing device renaming interface to solve these issues.

Ick, no, please, no.

> I think renaming device name in the kernel is the simplest way to solve mismatch
> dmesg and /proc information. This can be done while kernel booting up(like
> ifcfg). Of course, udev still needs to assign new name for each device via that
> interface.
> 
> This proposal just requests to add a simple interface to kernel as below. And we
> can continue to use user program without any modification.
> 
> int rename_device(const char *newname, const char *oldname)

I'll quote a message that Kay wrote to me last week when I told him
about this talk.  It's why we don't want to rename kernel devices, and
why using symlinks are the way to go:

	- All links or nodes can be stat()'d an then /sys/dev/block/M:m
	  points to the kernel. So easy!

	- Libudev provides all device meta information, list of links,
	  events.  No app/management tool can ever work properly in 2010
	  that does not react on hotplug or device update events. 1980
	  is over, we are all 100% hotplug aware, or we die!

	- Kernel device renaming is very fragile and only done for
	  netdevs because they can't have symlinks. There are many
	  cross-refs for blockdevs like holders/ slaves/ sysfs dirs,
	  they all need to be renamed atomically and race-free, which is
	  almost impossible I would say.

	- Biggest problem with renaming is that the device gets
	  advertised and is accessed immediately by userspace. Renaming
	  after advertising (sysfs, devtmpfs, uevent) is very difficult,
	  racy, almost impossible.

	- The only option to have named block devs is to have change the
	  block layer to create intermediate devices in sysfs (which are
	  advertised but not accessible as blockdevs) and then let
	  userspace hook into it and request a real blockdev with a
	  specified name, and only _after_ this create the real
	  blockdev. This is, and must be, not  a renaming, but a naming.

Kay said he had lots more reasons why this shouldn't be done, if you
want them as well :)

Also, note that the network people are really wanting symlinks these
days, and the fact that renaming the device can cause problems, so
please don't look to them as the "correct" solution at all.

Hope this helps,

greg k-h
