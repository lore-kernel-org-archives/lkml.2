Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758904Ab2IKLWB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 07:22:01 -0400
Received: from e28smtp02.in.ibm.com ([122.248.162.2]:34834 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757924Ab2IKLV6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 07:21:58 -0400
Message-ID: <504F1EB6.6040602@linux.vnet.ibm.com>
Date: Tue, 11 Sep 2012 16:51:26 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Neil Horman <nhorman@tuxdriver.com>
CC: Gao feng <gaofeng@cn.fujitsu.com>, eric.dumazet@gmail.com,
        davem@davemloft.net, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, mark.d.rustad@intel.com,
        john.r.fastabend@intel.com, lizefan@huawei.com
Subject: Re: [PATCH] net, cgroup: Fix boot failure due to iteration of uninitialized
 list
References: <20120719162532.23505.85946.stgit@srivatsabhat.in.ibm.com> <500CA599.6030907@cn.fujitsu.com> <20120723114057.GA16518@hmsreliant.think-freely.org> <504DB2EE.2030700@linux.vnet.ibm.com> <20120910131603.GA29742@hmsreliant.think-freely.org>
In-Reply-To: <20120910131603.GA29742@hmsreliant.think-freely.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
x-cbid: 12091111-5816-0000-0000-00000467DE71
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/10/2012 06:46 PM, Neil Horman wrote:
> On Mon, Sep 10, 2012 at 02:59:18PM +0530, Srivatsa S. Bhat wrote:
>> On 07/23/2012 05:10 PM, Neil Horman wrote:
>>> On Mon, Jul 23, 2012 at 09:15:05AM +0800, Gao feng wrote:
>>>> 于 2012年07月20日 00:27, Srivatsa S. Bhat 写道:
>>>>> After commit ef209f15 (net: cgroup: fix access the unallocated memory in
>>>>> netprio cgroup), boot fails with the following NULL pointer dereference:
>>>>>
>> [...]
>>>>> Call Trace:
>>>>>  [<ffffffff81b1cb78>] cgroup_init_subsys+0x83/0x169
>>>>>  [<ffffffff81b1ce13>] cgroup_init+0x36/0x119
>>>>>  [<ffffffff81affef7>] start_kernel+0x3ba/0x3ef
>>>>>  [<ffffffff81aff95b>] ? kernel_init+0x27b/0x27b
>>>>>  [<ffffffff81aff356>] x86_64_start_reservations+0x131/0x136
>>>>>  [<ffffffff81aff45e>] x86_64_start_kernel+0x103/0x112
>>>>> RIP  [<ffffffff8145e8d6>] cgrp_create+0xf6/0x190
>>>>>  RSP <ffffffff81a01ea8>
>>>>> CR2: 0000000000000698
>>>>> ---[ end trace a7919e7f17c0a725 ]---
>>>>> Kernel panic - not syncing: Attempted to kill the idle task!
>>>>>
>>>>> The code corresponds to:
>>>>>
>>>>> update_netdev_tables():
>>>>>         for_each_netdev(&init_net, dev) {
>>>>>                 map = rtnl_dereference(dev->priomap);  <---- HERE
>>>>>
>>>>>
>>>>> The list head is initialized in netdev_init(), which is called much
>>>>> later than cgrp_create(). So the problem is that we are calling
>>>>> update_netdev_tables() way too early (in cgrp_create()), which will
>>>>> end up traversing the not-yet-circular linked list. So at some point,
>>>>> the dev pointer will become NULL and hence dev->priomap becomes an
>>>>> invalid access.
>>>>>
>>>>> To fix this, just remove the update_netdev_tables() function entirely,
>>>>> since it appears that write_update_netdev_table() will handle things
>>>>> just fine.
>>>>
>>>> The reason I add update_netdev_tables in cgrp_create is to avoid additional
>>>> bound checkings when we accessing the dev->priomap.priomap.
>>>>
>>>> Eric,can we revert this commit 91c68ce2b26319248a32d7baa1226f819d283758 now?
>>>> I think it's safe enough to access priomap without bound check.
>>>>
>>>
>>> I think its probably safe, yes, but lets leave it there for just a bit.  Its not
>>> hurting anything, and I'd like to look into getting Srivatsa' patch in first.
>>
>> Hi Neil,
>>
>> Did you get around to look into this again?
>>
> I haven't looked at it specifically no, I apologize.  That said I think the
> other changes that went in back in that time frame have had time to soak, and
> looking at the way we current update the priomap table, I think its safe for us
> to remove the update_netdev_table call and definition.  If you repost your
> patch, I'll ack it. 
> 

Cool! I'll repost the patch, along with another small improvement that I happened
to observe, as a separate patch. Thanks!

Regards,
Srivatsa S. Bhat

