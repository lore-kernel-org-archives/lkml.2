Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754665Ab2J1DR1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2012 23:17:27 -0400
Received: from tru75-7-88-161-131-83.fbx.proxad.net ([88.161.131.83]:48874
	"EHLO next.fork.zz" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751231Ab2J1DR0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2012 23:17:26 -0400
Message-ID: <508CA3AC.4060600@free.fr>
Date: Sun, 28 Oct 2012 04:17:00 +0100
From: Wallak <wallak@free.fr>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:16.0) Gecko/20100101 Firefox/16.0
MIME-Version: 1.0
To: Chris Friesen <chris.friesen@genband.com>
CC: linux-kernel@vger.kernel.org, ak@linux.intel.com
Subject: Re: Linix-3.6.3 sda, sdb drives in reverse order (with a USB 2.0
 drives and a monolithic kernel configuration)
References: <5089C20E.4090707@free.fr> <5089C70B.1020007@genband.com> <508AE7D7.309@free.fr> <508AF0E4.7030701@genband.com> <508B2382.60108@free.fr>
In-Reply-To: <508B2382.60108@free.fr>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've found where this issue come from. This behavior was introduced with 
the commit: 0cc15d03bcccdf95e2bd82e094e6064e61b54207.The description is 
available below. Removing this patch fix the drive order.


Best Regards,
Wallak.


commit 0cc15d03bcccdf95e2bd82e094e6064e61b54207
Author: Andi Kleen <ak@linux.intel.com>
Date:   Mon Jul 2 17:27:04 2012 -0700

     floppy: Run floppy initialization asynchronous

     floppy_init is quite slow, 3s on my test system to determine
     that there is no floppy. Run it asynchronous to the other
     init calls to improve boot time.

     [jkosina@suse.cz: fix modular build]

     Signed-off-by: Andi Kleen <ak@linux.intel.com>
     Signed-off-by: Jiri Kosina <jkosina@suse.cz>




Wallak wrote:
> Chris Friesen wrote:
>> On 10/26/2012 01:43 PM, Wallak wrote:
>>> Chris Friesen wrote:
>>>> On 10/25/2012 04:49 PM, Wallak wrote:
>>>>> I've a very annoying behavior with the linux-3.6.x kernels 
>>>>> release, and
>>>>> a monolithic configuration. The USB 2.0 drives are mapped first with
>>>>> /dev/sda, /dev/sdb... devices, and than the SATA AHCI drives come 
>>>>> after.
>>>>> This is out of order with the BIOS configuration and breaks a program
>>>>> like lilo. This is also annoying when we use a static partition 
>>>>> mapping.
>>>>>
>>>>> Linux-3.5 works fine. Where this bug come from ? Is this a patch 
>>>>> to get
>>>>> the old, and classical behavior ?
>>>>
>>>> As you have discovered it's fragile to rely on /dev/sd* names since a
>>>> BIOS update, kernel update, or motherboard replacement could
>>>> conceivably cause them to change.
>>>>
>>>> Better to use something like partition labels that you control and
>>>> that don't change.
>>>>
>>>> Chris
>>>>
>>> You are right, when we have a configuration with a lot of drvies and
>>> adapters SATA, old SCSI,.. etc. the order may change. But having the
>>> main SATA hard drive defined, as the BIOS boot device, behind external
>>> and removable USB drives is in my opinion a bug.And may lead to 
>>> security
>>> issues (drives with the same label, etc...).
>>>
>>> Using =LABEL, or =UUID with a bootloader like grub or lilo, save the 
>>> the
>>> boot device mapped drive partition number , and so booting on an older
>>> kernel like linux 3.5 will fail. If we remove the external USB drive,
>>> the boot process will fail too...
>>>
>>> So such a bug have to be fix.
>>
>> If you specify "root=LABEL=<label>" as part of the kernel boot args 
>> in grub does it not check the label at boot time?
>
> Using root=LABEL= or root=UUID= don't work on a plain kernel, this 
> feature may be handled by an initrd trick. Otherwise for all non root 
> partitions UUID= work fine.
> Nevertheless not fixing this bug yields some other issues:  Using lilo 
> to launch a second OS (other= option) fail, the command try to parse 
> partitions available on /dev/sda, and miss the real main HDD. Boot 
> drive must be force with lilo options...
> SATA drives have, most of the time, no reason to be behind USB drives. 
> If we want to get a reliable behavior: /dev/sda must be mapped to the 
> BIOS boot device. Using the same behavior as linux-3.5 will be fine.
>
> Wallak.
>
>>
>> Chris
>>
>

