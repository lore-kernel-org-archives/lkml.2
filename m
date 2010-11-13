Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755849Ab0KMKJ6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Nov 2010 05:09:58 -0500
Received: from hera.kernel.org ([140.211.167.34]:42722 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754191Ab0KMKJz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Nov 2010 05:09:55 -0500
Message-ID: <4CDE63D3.4010608@kernel.org>
Date: Sat, 13 Nov 2010 11:09:23 +0100
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.12) Gecko/20101027 Lightning/1.0b2 Thunderbird/3.1.6
MIME-Version: 1.0
To: akataria@vmware.com
CC: linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Petr Vandrovec <petr@vmware.com>,
        Pekka Enberg <penberg@cs.helsinki.fi>,
        Christoph Lameter <cl@linux-foundation.org>
Subject: Re: (mem hotplug, pcpu_alloc) BUG: sleeping function called from
 invalid context at kernel/mutex.c:94
References: <1289588178.7486.15.camel@ank32.eng.vmware.com>
In-Reply-To: <1289588178.7486.15.camel@ank32.eng.vmware.com>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sat, 13 Nov 2010 10:09:28 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 11/12/2010 07:56 PM, Alok Kataria wrote:
> We have seen following might_sleep warning while hot adding memory...
> 
> [  142.339267] BUG: sleeping function called from invalid context at kernel/mutex.c:94
> [  142.339276] in_atomic(): 0, irqs_disabled(): 1, pid: 4, name: migration/0
> [  142.339283] Pid: 4, comm: migration/0 Not tainted 2.6.35.6-45.fc14.x86_64 #1
> [  142.339288] Call Trace:
> [  142.339305]  [<ffffffff8103d12b>] __might_sleep+0xeb/0xf0
> [  142.339316]  [<ffffffff81468245>] mutex_lock+0x24/0x50
> [  142.339326]  [<ffffffff8110eaa6>] pcpu_alloc+0x6d/0x7ee
> [  142.339336]  [<ffffffff81048888>] ? load_balance+0xbe/0x60e
> [  142.339343]  [<ffffffff8103a1b3>] ? rt_se_boosted+0x21/0x2f
> [  142.339349]  [<ffffffff8103e1cf>] ? dequeue_rt_stack+0x18b/0x1ed
> [  142.339356]  [<ffffffff8110f237>] __alloc_percpu+0x10/0x12
> [  142.339362]  [<ffffffff81465e22>] setup_zone_pageset+0x38/0xbe
> [  142.339373]  [<ffffffff810d6d81>] ? build_zonelists_node.clone.58+0x79/0x8c
> [  142.339384]  [<ffffffff81452539>] __build_all_zonelists+0x419/0x46c
> [  142.339395]  [<ffffffff8108ef01>] ? cpu_stopper_thread+0xb2/0x198
> [  142.339401]  [<ffffffff8108f075>] stop_machine_cpu_stop+0x8e/0xc5
> [  142.339407]  [<ffffffff8108efe7>] ? stop_machine_cpu_stop+0x0/0xc5
> [  142.339414]  [<ffffffff8108ef57>] cpu_stopper_thread+0x108/0x198
> [  142.339420]  [<ffffffff81467a37>] ? schedule+0x5b2/0x5cc
> [  142.339426]  [<ffffffff8108ee4f>] ? cpu_stopper_thread+0x0/0x198
> [  142.339434]  [<ffffffff81065f29>] kthread+0x7f/0x87
> [  142.339443]  [<ffffffff8100aae4>] kernel_thread_helper+0x4/0x10
> [  142.339449]  [<ffffffff81065eaa>] ? kthread+0x0/0x87
> [  142.339455]  [<ffffffff8100aae0>] ? kernel_thread_helper+0x0/0x10
> [  142.340099] Built 5 zonelists in Node order, mobility grouping on.  Total pages: 289456
> [  142.340108] Policy zone: Normal
> 
> 
> This warning was seen on the FC14 kernel, though looking at the current
> git, the problem seems to exist on mainline too.
> The problem is that pcpu_alloc expects that it is called from non-atomic
> context as a result it grabs the pcpu_alloc_mutex. 
> In the memory-hotplug case though, we do end up calling pcpu_alloc from
> atomic context, while all cpus are stopped.
> 
> void build_all_zonelists(void *data)
> {
>    set_zonelist_order();
> 
>    if (system_state == SYSTEM_BOOTING) {
>       __build_all_zonelists(NULL);
>       mminit_verify_zonelist();
>       cpuset_init_current_mems_allowed();
>    } else {
>       /* we have to stop all cpus to guarantee there is no user
>          of zonelist */
>       stop_machine(__build_all_zonelists, data, NULL);   <=========
>       /* cpuset refresh routine should be here */
>    }
> 
> __build_all_zonelists eventually calls pcpu_alloc. 
> 
> I didn't dive through the history, so am not sure when was this
> regression introduced, but could have regressed with the new pcpu memory
> allocator.

Meh... the percpu allocator required user context from the beginning.
The new allocator didn't change that.

Wouldn't it be possible to prepare hotplug outside of cpu_stop and use
stop_machine() only to make it available to the system.  In general,
it's a very bad idea to allocate memory from inside stop_machine.  The
whole machine is stopped, after all.  In general, it shouldn't be too
difficult to add new resource without stop_machine too unlike removing
one.  Pekka, Christoph, any ideas?

Thanks.

-- 
tejun
