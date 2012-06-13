Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752843Ab2FMB6J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 21:58:09 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:33217 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752612Ab2FMB6H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 21:58:07 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <4FD7F329.1000203@jp.fujitsu.com>
Date: Wed, 13 Jun 2012 10:55:53 +0900
From: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.0; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Bjorn Helgaas <bhelgaas@google.com>
CC: Wen Congyang <wency@cn.fujitsu.com>, rob@landley.net, tglx@linutronix.de,
        Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2 v2] x86: add max_addr boot option
References: <4FD5AFF2.3040306@cn.fujitsu.com> <CAErSpo6EnHFFPwcPhWy=ACTn5+7i72fUR+1jjZrpfEMQp1zv0A@mail.gmail.com> <4FD6E1DA.2090700@cn.fujitsu.com> <CAErSpo6UwL6kY4rHeYQbn1kghJH-kQDeat7VXp95JE2pGER5ZA@mail.gmail.com>
In-Reply-To: <CAErSpo6UwL6kY4rHeYQbn1kghJH-kQDeat7VXp95JE2pGER5ZA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2012/06/12 20:30), Bjorn Helgaas wrote:
> On Mon, Jun 11, 2012 at 11:29 PM, Wen Congyang<wency@cn.fujitsu.com>  wrote:
>> At 06/12/2012 01:35 AM, Bjorn Helgaas Wrote:
>>> On Mon, Jun 11, 2012 at 1:44 AM, Wen Congyang<wency@cn.fujitsu.com>  wrote:
>>>> Currently, the boot option max_addr is only supported on ia64 platform.
>>>> We also need it on x86 platform.
>>>> For example:
>>>> There are two nodes:
>>>>   NODE#0  address range 0x00000000 00000000 - 0x00010000 00000000
>>>>   NODE#1  address range 0x00010000 00000000 - 0x00020000 00000000
>>>> If we only want to use node0, we can specify the max_addr. The boot
>>>> option "mem=" can do the same thing now. But the boot option "mem="
>>>> means the total memory used by the system. If we tell the user
>>>> that the boot option "mem=" can do this, it will confuse the user.
>>>> So we need an new boot option "max_addr" on x86 platform.
>>>
>>> I don't object to this patch (and thanks for tweaking the mem range printk).
>>>
>>> I don't know what your use case is, but from a user interface
>>> perspective, the "max_addr=" option feels like a bit of a hack.  If
>>> you're trying to avoid use of other nodes, "max_addr" is an awkward
>>> way to do it.  It requires the user to know the physical address ->
>>> node mappings, and it doesn't affect the CPUs and I/O resources on
>>> other nodes.  You could implement a "numa_node=" or similar parameter
>>> that would allow you to ignore remote memory, CPUs, and I/O.
>>
>> Currently, I only need to ignore the memory. If we need to ignore a node,
>> "numa_node=" or similar parameter is a better choice.
>
> Doesn't the end user have to know the memory map of the system to use
> "max_addr="?  How do you know what value to supply?  Do you have to
> attempt a boot once to discover the highest address on node 0?  What
> if node 0 and node 1 memory are interleaved, so there's some node 1
> memory below the highest node 0 address?
>

Current our plan is to avoid asking end-user to fix their boot option by hand
even if memory size per node is changed. We'll ship a  hardware, which has
_fixed_ physical address range per each node regardless of equipped memory size.
The address will be written in Hardware manual or we'll ship some tool with hardware.
Of course, we disable interleave between nodes.

IIUC, memory layout can be changed because hardware error detection logic can
turn off DIMM before boot. So, if we use memmap=, which requires precise memory
mapping knowledge, the system admin need to modify it when the problem happens.

Problem happens => reboot (disable some DIMM) => remove memmap= option for avoiding
trouble => check memory layout again =>fix mem_map= => reboot again.
This reboot takes much time because the system which have Dynamic-partitioning tends to
be big....so, we'd like to have some _relaxed_ way to specify the region of memory.

Problem happens => reboot (disable some DIMM) => no changes required
(because we have enough memory hole between Node0 and Node1.)

BTW, how do you think about mem= boot option which works as max_addr=, now ?
This caused troubles some times on our support-desk, saying
Q. I specified mem=8G boot option but it seems the system has only 7GB....
A. it's because of PCI configuration area on 3G-4G address range...

Even if our requirement can be covered current mem= option, I'd like to have
max_addr= option and make mem= option to be sane as ia64.

Thanks,
-Kame

