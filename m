Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752683Ab2CILWx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 06:22:53 -0500
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:45015 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751077Ab2CILWw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 06:22:52 -0500
Message-ID: <4F59E802.6070301@linux.vnet.ibm.com>
Date: Fri, 09 Mar 2012 16:52:42 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.1) Gecko/20120209 Thunderbird/10.0.1
MIME-Version: 1.0
To: Jeff Moyer <jmoyer@redhat.com>
CC: Sasha Levin <levinsasha928@gmail.com>,
        Nick Bowler <nbowler@elliptictech.com>, linux-kernel@vger.kernel.org
Subject: Re: the maxcpus= boot parameter broke somewhere along the line
References: <x49vcmhhj2f.fsf@segfault.boston.devel.redhat.com> <CA+1xoqe_xS95xKM2=X-Mq-_gc+DqzxF2D8YiuCf=0=7=mVKsyw@mail.gmail.com> <20120306164835.GA26094@elliptictech.com> <CA+1xoqfzCb5X8wwvR1Bz+D6K20n7v3ChUR0E4Jqw_BWam5C7TQ@mail.gmail.com> <x49mx7thabf.fsf@segfault.boston.devel.redhat.com> <4F578198.8060708@linux.vnet.ibm.com> <x49ipigustu.fsf@segfault.boston.devel.redhat.com>
In-Reply-To: <x49ipigustu.fsf@segfault.boston.devel.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 12030901-9264-0000-0000-0000010685AE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/08/2012 12:44 AM, Jeff Moyer wrote:

> "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com> writes:
> 
>> On 03/06/2012 11:38 PM, Jeff Moyer wrote:
>>
>>> Sasha Levin <levinsasha928@gmail.com> writes:
>>>
>>>> I can't reproduce it locally with a 3.3-rc5 kernel.
>>>
>>> First, thanks for looking into it.  I just did a git pull, up to -rc6,
>>> and the problem still persists on my machine.
>>>
>>
>>
>> I tried 3.3-rc4 as well as 3.3-rc6+ (last commit dac12d1). I did not
>> see the problem in either case.
> 
> I bisected the issue, and it landed here:
> 
> 8a25a2fd126c621f44f3aeaef80d51f00fc11639 is the first bad commit
> commit 8a25a2fd126c621f44f3aeaef80d51f00fc11639
> Author: Kay Sievers <kay.sievers@vrfy.org>
> Date:   Wed Dec 21 14:29:42 2011 -0800
> 
>     cpu: convert 'cpu' and 'machinecheck' sysdev_class to a regular
>     subsystem
> 
> Unfortunately, that's a HUGE commit.
> 


This was from your dmesg:

sd 0:0:10:1: [sdk] Attached SCSI disk
readahead: starting
udev: starting version 147
SMP alternatives: switching to SMP code
WARNING! power/level is deprecated; use power/control instead
EDAC MC: Ver: 2.1.0
Booting Node 0 Processor 3 APIC 0x3
smpboot cpu 3: start_ip = 9a000
EDAC MC0: Giving out device to 'i3200_edac' 'i3200': DEV 0000:00:00.0
NMI watchdog enabled, takes one hw-pmu counter.
Booting Node 0 Processor 2 APIC 0x1
smpboot cpu 2: start_ip = 9a000
NMI watchdog enabled, takes one hw-pmu counter.
Booting Node 0 Processor 1 APIC 0x2
smpboot cpu 1: start_ip = 9a000
NMI watchdog enabled, takes one hw-pmu counter.


Looking at the mention of udev above, and considering the commit you bisected
to, I think it would be good to see whether someone is writing 1 to
/sys/device/system/cpu/cpu*/online and hence the cpus are getting hot-added
towards the end of boot. Maybe that sounds stupid, but worth a try :)

So can you try the debug patch below? It applies on latest linux-3.3-rc6+

---

 drivers/base/cpu.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)


diff --git a/drivers/base/cpu.c b/drivers/base/cpu.c
index 4dabf50..49d5f83 100644
--- a/drivers/base/cpu.c
+++ b/drivers/base/cpu.c
@@ -43,11 +43,13 @@ static ssize_t __ref store_online(struct device *dev,
 	cpu_hotplug_driver_lock();
 	switch (buf[0]) {
 	case '0':
+		printk("CPU %d offline initated from userspace\n", cpu->dev.id);
 		ret = cpu_down(cpu->dev.id);
 		if (!ret)
 			kobject_uevent(&dev->kobj, KOBJ_OFFLINE);
 		break;
 	case '1':
+		printk("CPU %d online initated from userspace\n", cpu->dev.id);
 		ret = cpu_up(cpu->dev.id);
 		if (!ret)
 			kobject_uevent(&dev->kobj, KOBJ_ONLINE);

