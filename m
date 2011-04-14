Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757661Ab1DNIPp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 04:15:45 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:55434 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756786Ab1DNIPk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 04:15:40 -0400
X-AuditID: b753bd60-a3cafba0000019f4-5b-4da6ad291ed0
X-AuditID: b753bd60-a3cafba0000019f4-5b-4da6ad291ed0
Message-ID: <4DA6AD28.5020604@hitachi.com>
Date: Thu, 14 Apr 2011 17:15:36 +0900
From: Nao Nishijima <nao.nishijima.xt@hitachi.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.2.15) Gecko/20110303 Thunderbird/3.1.9
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-hotplug@vger.kernel.org, Kay Sievers <kay.sievers@vrfy.org>,
        James Bottomley <James.Bottomley@suse.de>,
        Jon Masters <jcm@redhat.com>, 2nddept-manager@sdl.hitachi.co.jp
Subject: Re: [PATCH 1/2] SCSI: Add a SCSI option for persistent device names
 in Kernel.
References: <20110405124946.7969.66796.stgit@ltc233.sdl.hitachi.co.jp> <20110405161454.GB885@kroah.com> <4D9F16AD.2090408@hitachi.com> <20110408161212.GA12111@kroah.com>
In-Reply-To: <20110408161212.GA12111@kroah.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

(2011/04/09 1:12), Greg KH wrote:
> On Fri, Apr 08, 2011 at 11:07:41PM +0900, Nao Nishijima wrote:
>> Hi,
>>
>> (2011/04/06 1:14), Greg KH wrote:
>>> On Tue, Apr 05, 2011 at 09:49:46PM +0900, Nao Nishijima wrote:
>>>> This patch series provides a SCSI option for persistent device
>>>> names in kernel. With this option, user can always assign a
>>>> same device name (e.g. sda) to a specific device according to
>>>> udev rules and device id.
>>>>
>>>> Issue:
>>>> Recently, kernel registers block devices in parallel. As a result,
>>>> different device names will be assigned at each boot time. This
>>>> will confuse file-system mounter, thus we usually use persistent
>>>> symbolic links provided by udev. However, dmesg and procfs outputs
>>>> show device names instead of the symbolic link names. This causes
>>>> a serious problem when managing multiple devices (e.g. on a
>>>> large-scale storage), because usually, device errors are output
>>>> with device names on dmesg. We also concern about some commands
>>>> which output device names, as well as kernel messages.
>>>>
>>>> Solution:
>>>> To assign a persistent device name, I create unnamed devices (not
>>>> a block device, but an intermediate device. users cannot read/write
>>>> this device). When scsi device driver finds a LU, the LU is registered
>>>> as an unnamed device and inform to udev. After udev finds the unnamed
>>>> device, udev assigns a persistent device name to a specific device
>>>> according to udev rules and registers it as a block device. Hence,
>>>> this is just a naming, not a renaming.
>>>>
>>>> Some users are satisfied with current udev solution. Therefore, my
>>>> proposal is implemented as an option.
>>>>
>>>> If using this option, add the following kernel parameter.
>>>>
>>>> 	scsi_mod.persistent_name=1
>>>>
>>>> Also, if you want to assign a device name with sda, add the
>>>> following udev rules.
>>>>
>>>> SUBSYSTEM=="scsi_unnamed", ATTR{disk_id}=="xxx", PROGRAM="/bin/sh
>>>> -c 'echo -n sda > /sys/%p/disk_name'"
>>>
>>> Also, where is the "real" program you have created to properly name
>>> devices from userspace?  You need that to properly test this patch,
>>> right?
>>>
>>
>> In the udev rule described above, notation “xxx” indicated by
>> ATTR(disk_id) is scsi id given by disk. Then, when udev finds this rule,
>> "/bin/sh -c 'echo -n sda>  /sys/%p/disk_name'" indicated by PROGRAM is
>> operated using xxx (scsi id) if udev find the disk with scic id xxx.
>> Thus, persistent device name is assigned.
>>
>> I have tested this patch using the udev rule. and It works well.
> 
> That's nice, but it's a "toy".  What have you used to test this with
> 20000 scsi devices to properly work like it does today?  Where is the
> program that will name them in a deterministic manner?
> 
> We have that functionality today, you can't break it.
> 
> thanks,

Indeed, I have not (can not, of course) tested 20000 scsi devices to
properly work. This feature targets only scsi disk/cdrom/tape devices.
Not all devices. We expect the target users are system administrators
who need to control all devices for maintenance. They know all devices
connected to the server and those devices will tested before connecting.

We expect that admin will enable this option after installation. This
means that device names are assigned by current mechanism when
installation. Admin enables the option and makes udev rules (we are
planning to make shell script which generate udev rules use by-id and
assigned device names). In other word, this feature will be used just
for "fixing" the names.

In our scenario, admin appends a new rule manually when a new LU is
added. In the future, we are planning to enhance udev to append a new
rule automatically as like as NIC.

Thanks,


-- 
Nao NISHIJIMA
Software Platform Research Dept. Linux Technology Center
Hitachi, Ltd., YOKOHAMA Research  Laboratory
Email： nao.nishijima.xt@hitachi.com
