Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755246Ab0JRLpZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 07:45:25 -0400
Received: from mailx.hitachi.co.jp ([133.145.228.49]:33707 "EHLO
	mailx.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755163Ab0JRLpY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 07:45:24 -0400
X-AuditID: b753bd60-a6b32ba000000226-79-4cbc32cde3f5
Message-ID: <4CBC32CC.6010506@hitachi.com>
Date: Mon, 18 Oct 2010 20:43:08 +0900
From: Nao Nishijima <nao.nishijima.xt@hitachi.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.2.9) Gecko/20100915 Thunderbird/3.1.4
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>, kay.sievers@vrfy.org
Cc: James.Bottomley@suse.de, rwheeler@redhat.com, linux-kernel@vger.kernel.org,
        linux-hotplug@vger.kernel.org, masami.hiramatsu.pt@hitachi.com,
        Matt_Domsch@dell.com
Subject: Re: [RFD] Device Renaming Mechanism
References: <4CAEAAD4.2080504@hitachi.com> <20101008204802.GA21542@kroah.com>
In-Reply-To: <20101008204802.GA21542@kroah.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Brightmail-Tracker: AAAAAA==
X-FMFTCR: RANGEC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

(2010/10/09 5:48), Greg KH wrote:
> 
>> Udev makes persistent symbolic links(by-{id, uuid, path, label}) pointing to each
>> device based on device information. Applications access the device via these
>> symbolic links. Udev solves mismatch between device name and physical disk.
>> However the persistent name mismatches kernel's device name.
>> This mismatch causes following 4 issues.
>>
>> Issue 1: /proc/partitions, /proc/diskstat gives you device names
>> We have to run "ls -l /dev/disk/by-*" or "udevadm" for finding corresponding
>> persistent symbolic links.
> 
> That's fine, don't use the /proc files :)

I think that the tool which displays persistent names instead of device names,
is necessary for uses who use persistent symbolic links.


> 
>> Issue 2: dmesg output device name instead of persistent symbolic links
>> Users might not know which disk is sdX, because they identify the disk by a
>> persistent symbolic link.
> 
> Again, that's fine as well, don't use "raw" dmesg output and expect it
> to map to what the user has mounted.  There are a number of tools to
> handle the mapping of this out there by companies (IBM, CA, etc.)
> 

Are these tools released under open source license? (IOW, anyone who uses linux
can use it?) If not, we should provide a tool under open source license, because
I think that it is necessary to solve the issue of OSS kernel with OSS tool.


>> Issue 3: Some system commands don't accept symbolic link(e.g. df, iostat,...)
>> These commands just expect sdX device name or check input by /proc information.
>> This will also occur on several GNOME/KDE/etc GUI sysadmin tools. :(
> 
> Then we should fix those programs, it is a simple one line change.  Can
> you please tell us which programs you have tested and found problems
> with?
> 

Persistent symbolic links cannot be used for the argument of following commands.
"smartctl", "sgpio", "grub-isntall", "iostat". And we should have to fix a
number of commands which use device name for output, because those commands do
not show persistent device name.


>> Issue 4: Undecided symbolic link
>> Even if we would like to introduce device names/persistent symbolic links
>> mapping tool to solve it, we can not determine a symbolic link from a device,
>> because several symbolic links point a device file.
> 
> Huh?  You want to move from a kernel name to the one that the user used?
> As you are the user, you should know which one you used :)
> 

On a multi-admin system, an admin may not be able to know which name
has been used by others. Of course, that case might be finally handled
by themselves. But from the viewpoint of fool-proof, current solution
is easy to lead that situation.


>> Therefore, I think the symbolic link is not enough to solve. We need a
>> better solution.
> 
> I strongly disagree.
> 
>> Proposal
>> ========
>> I'd like to propose introducing device renaming interface to solve these issues.
> 
> Ick, no, please, no.
> 
>> I think renaming device name in the kernel is the simplest way to solve mismatch
>> dmesg and /proc information. This can be done while kernel booting up(like
>> ifcfg). Of course, udev still needs to assign new name for each device via that
>> interface.
>>
>> This proposal just requests to add a simple interface to kernel as below. And we
>> can continue to use user program without any modification.
>>
>> int rename_device(const char *newname, const char *oldname)
> 
> I'll quote a message that Kay wrote to me last week when I told him
> about this talk.  It's why we don't want to rename kernel devices, and
> why using symlinks are the way to go:
> 
> 	- All links or nodes can be stat()'d an then /sys/dev/block/M:m
> 	  points to the kernel. So easy!
> 

Hmm, agreed


> 	- Libudev provides all device meta information, list of links,
> 	  events.  No app/management tool can ever work properly in 2010
> 	  that does not react on hotplug or device update events. 1980
> 	  is over, we are all 100% hotplug aware, or we die!
> 

Yes.


> 	- Kernel device renaming is very fragile and only done for
> 	  netdevs because they can't have symlinks. There are many
> 	  cross-refs for blockdevs like holders/ slaves/ sysfs dirs,
> 	  they all need to be renamed atomically and race-free, which is
> 	  almost impossible I would say.
> 
> 	- Biggest problem with renaming is that the device gets
> 	  advertised and is accessed immediately by userspace. Renaming
> 	  after advertising (sysfs, devtmpfs, uevent) is very difficult,
> 	  racy, almost impossible.
> 

I agree that renaming after advertising to be difficult, but network goes well?


> 	- The only option to have named block devs is to have change the
> 	  block layer to create intermediate devices in sysfs (which are
> 	  advertised but not accessible as blockdevs) and then let
> 	  userspace hook into it and request a real blockdev with a
> 	  specified name, and only _after_ this create the real
> 	  blockdev. This is, and must be, not  a renaming, but a naming.
> 

It sounds good to me. but i don't understand clearly.
Is "Not accessible as blockdevs" meaning that a device not register
bdi(backing_dev_info) list or Major/miner not given to device?
Could you tell me in detail?


> Kay said he had lots more reasons why this shouldn't be done, if you
> want them as well :)
> 
> Also, note that the network people are really wanting symlinks these
> days, and the fact that renaming the device can cause problems, so
> please don't look to them as the "correct" solution at all.
> 

I think that network people will face the same mismatch problems because they
use symlinks. I understand that renaming is a problem. I'd like to try Kay's idea.


> Hope this helps,
> 
> greg k-h
> 

Thank you for your advice.
Best Regards,

-- 
Nao NISHIJIMA
2nd Dept. Linux Technology Center
Hitachi, Ltd., Systems Development Laboratory
Email： nao.nishijima.xt@hitachi.com
