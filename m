Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759172Ab2IGDIf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 23:08:35 -0400
Received: from e28smtp06.in.ibm.com ([122.248.162.6]:58805 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758565Ab2IGDI2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 23:08:28 -0400
Message-ID: <5049651E.6000900@linux.vnet.ibm.com>
Date: Fri, 07 Sep 2012 11:08:14 +0800
From: Michael Wang <wangyun@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Fengguang Wu <fengguang.wu@intel.com>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        LKML <linux-kernel@vger.kernel.org>, x86@kernel.org,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Venkatesh Pallipadi <venki@google.com>
Subject: Re: WARNING: cpu_is_offline() at native_smp_send_reschedule()
References: <20120905011152.GA19853@localhost> <5046D69F.9000705@linux.vnet.ibm.com> <1346842480.2461.11.camel@laptop> <20120905125700.GA5833@localhost> <20120907012058.GA9000@localhost>
In-Reply-To: <20120907012058.GA9000@localhost>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 12090703-9574-0000-0000-0000044D089E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/07/2012 09:20 AM, Fengguang Wu wrote:
> On Wed, Sep 05, 2012 at 08:57:00PM +0800, Fengguang Wu wrote:
>> On Wed, Sep 05, 2012 at 12:54:40PM +0200, Peter Zijlstra wrote:
>>> On Wed, 2012-09-05 at 12:35 +0800, Michael Wang wrote:
>>>>> [   10.968565] reboot: machine restart
>>>>> [   10.983510] ------------[ cut here ]------------
>>>>> [   10.984218] WARNING: at /c/kernel-tests/src/stable/arch/x86/kernel/smp.c:123 native_smp_send_reschedule+0x46/0x50()
>>>>> [   10.985880] Pid: 88, comm: kpktgend_0 Not tainted 3.6.0-rc3-00005-gb374aa1 #10
>>>>> [   10.987185] Call Trace:
>>>>> [   10.987506]  [<7902f42a>] warn_slowpath_common+0x5a/0x80
>>>>> [   10.987506]  [<7901ee16>] ? native_smp_send_reschedule+0x46/0x50
>>>>> [   10.987506]  [<7901ee16>] ? native_smp_send_reschedule+0x46/0x50
>>>>> [   10.987506]  [<7902f4fd>] warn_slowpath_null+0x1d/0x20
>>>>> [   10.987506]  [<7901ee16>] native_smp_send_reschedule+0x46/0x50
>>>>
>>>> So this cpu try to fire a nohz balance kick ipi to an offline cpu?
>>>>
>>>> May be we are choosing a wrong cpu to kick but that's not the point,
>>>> what I can't understand is why this cpu could do this kick.
>>>>
>>>> We have nohz_kick_needed() to check whether current cpu should do kick ,
>>>> and the first condition we need to match is that current cpu should be
>>>> idle, but the trace show current pid is 88 not 0.
>>>>
>>>> We should add Peter to cc list, may be he will be interested on what
>>>> happened.
>>>
>>>>> [   10.987506]  [<7905fdad>] trigger_load_balance+0x1bd/0x250
>>>>> [   10.987506]  [<79056d14>] scheduler_tick+0xd4/0x100
>>>>> [   10.987506]  [<7903bde5>] update_process_times+0x55/0x70 
>>>
>>> Hmm, added both venki and suresh as they touched it last ;-)
>>>
>>> I suppose you're running a hotplug loop along with your workload?
>>
>> I would definitely like to add some hotplug tests! However for this
>> trace, it's simply booting into an ubuntu-core initrd and run the
>> "reboot" command in some late init.d script.
>>
>> It seems that the bug was introduced somewhere in v3.3..v3.4. I'm now
>> running 100 kvms to speedup the bisect progress :)
> 
> FYI, the bisect result is
> 
> commit 554cecaf733623b327eef9652b65965eb1081b81
> Author: Diwakar Tundlam <dtundlam@nvidia.com>
> Date:   Wed Mar 7 14:44:26 2012 -0800
> 
>     sched/nohz: Correctly initialize 'next_balance' in 'nohz' idle balancer
> 
>     The 'next_balance' field of 'nohz' idle balancer must be initialized
>     to jiffies. Since jiffies is initialized to negative 300 seconds the
>     'nohz' idle balancer does not run for the first 300s (5mins) after
>     bootup. If no new processes are spawed or no idle cycles happen, the
>     load on the cpus will remain unbalanced for that duration.
> 
>     Signed-off-by: Diwakar Tundlam <dtundlam@nvidia.com>
>     Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
>     Link: http://lkml.kernel.org/r/1DD7BFEDD3147247B1355BEFEFE4665237994F30EF@HQMAIL04.nvidia.com
>     Signed-off-by: Ingo Molnar <mingo@elte.hu>

This patch enabled the nohz kick during the booting, without it, nohz
load balance won't happen until jiffies reach 0.

So the issue disappear because the nohz balance was disabled in testing
time, I think that's not what we want...

I still can't figure out why a cpu do nohz kick while it's not idle :(

Regards,
Michael Wang

> 
> Thanks,
> Fengguang
> 

