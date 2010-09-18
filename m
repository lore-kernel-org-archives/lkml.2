Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753878Ab0IRWRV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Sep 2010 18:17:21 -0400
Received: from skyboo.net ([82.160.187.4]:38200 "EHLO skyboo.net"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753601Ab0IRWRU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Sep 2010 18:17:20 -0400
Message-ID: <4C953A66.3070003@skyboo.net>
Date: Sun, 19 Sep 2010 00:17:10 +0200
From: Mariusz Bialonczyk <manio@skyboo.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100620 Icedove/3.0.5
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
References: <4C940D5C.4090408@skyboo.net>
In-Reply-To: <4C940D5C.4090408@skyboo.net>
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 2001:470:1f0b:1af:f000::2
X-SA-Exim-Mail-From: manio@skyboo.net
Subject: Re: PROBLEM: GPT partition table + RAID: kernel could not load init
 while root filesystem is mounted
X-SA-Exim-Version: 4.2.1 (built Mon, 22 Mar 2010 06:26:47 +0000)
X-SA-Exim-Scanned: Yes (on skyboo.net)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/18/2010 02:52 AM, manio wrote:
> Hello
> I am trying to migrate from old root filesystem (linux raid1 on disks
> with msdos partition table) to new (4K sector) disks with GPT partition
> table (also raid1). I am using raid autodetection (i have superblock
> v0.90 on all raid devices) and i am passing /dev/mdX as a root device to
> the kernel. When i am passing root=/dev/md10 (old disks with msdos
> partition tables) booting process is fine (i am pasting relevant info):
>
> [ 6.695241] raid1: raid set md10 active with 2 out of 2 mirrors
> [ 6.695280] md10: detected capacity change from 0 to 6999572480
> [ 6.695332] md: ... autorun DONE.
> [ 6.695407] md10: unknown partition table
> [ 6.696236] EXT3-fs (md10): error: couldn't mount because of unsupported
> optional features (240)
> [ 6.696508] EXT2-fs (md10): error: couldn't mount because of unsupported
> optional features (240)
> [ 6.743086] EXT4-fs (md10): mounted filesystem with ordered data mode
> [ 6.743185] VFS: Mounted root (ext4 filesystem) readonly on device 9:10.
> [ 6.743227] Freeing unused kernel memory: 424k freed
> ..... now comes INIT - and it boots correctly
>
> BUT (!) the problem is when i am trying to pass root=/dev/md0 (raid1 on
> new disks with GPT partition tables). Then it seems like kernel cannot
> run /sbin/init from my ext4 root partition. The root filesystem seems to
> be mounted OK:
>
> md: ... autorun DONE.
> md0: unknown partition table
> EXT3-fs (md0): error: couldn't mount because of unsupported optional
> features (240)
> EXT2-fs (md0): error: couldn't mount because of unsupported optional
> features (240)
> EXT4-fs (md0): mounted filesystem with ordered data mode
> VFS: Mounted root (ext4 filesystem) readonly on device 9:0.
> Freeing unused kernel memory: 424k freed
>
> ..... now there is some USB init debug info and it stop :(
> /sbin/init is not launched and it seems like the kernel hung :(
> i was waiting several minutes then - and nothing happend.

after some investigation i am almost sure that the problem is with
kernel_execve() - i put some debug info and i can see that last call
from init/main.c is:
run_init_process("/sbin/init");
i was checking the boot partition - it is same correct ext4 filesystem
with same contents - the only difference between them is the partition
table - the problem is on GPT, while on msdos partition table it calls
INIT correctly after kernel_execve call. On GPT it hungs - maybe it is
not jumping into correct location?
Strange thing is - that the root filesystem in both cases is mounted,
so why it has trouble to run /sbin/init in GPT case?

Last time i forgot to mention that i am using kernel 2.6.36-rc4 but i
was also testing it on 2.6.34 with same results.
I am using x86_64 architecture.

regards,
-- 
Mariusz Bialonczyk
jabber/e-mail: manio@skyboo.net
http://manio.skyboo.net
