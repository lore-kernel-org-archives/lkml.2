Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752211Ab1EJUxs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 16:53:48 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:22987 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750750Ab1EJUxp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 16:53:45 -0400
Message-ID: <4DC9A5A4.1050308@kernel.org>
Date: Tue, 10 May 2011 13:52:52 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110414 SUSE/3.1.10 Thunderbird/3.1.10
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
CC: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL rcu/next] rcu commits for 2.6.40
References: <20110508151848.GA21906@linux.vnet.ibm.com> <20110509073636.GA18247@elte.hu> <BANLkTin82W0yZ5Nvv3Dp62X1eou_GxZ6EA@mail.gmail.com> <20110510085623.GG2258@linux.vnet.ibm.com> <4DC97E49.7040401@kernel.org> <20110510193216.GN2258@linux.vnet.ibm.com>
In-Reply-To: <20110510193216.GN2258@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: rtcsinet22.oracle.com [66.248.204.30]
X-CT-RefId: str=0001.0A090206.4DC9A5B1.0161,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/10/2011 12:32 PM, Paul E. McKenney wrote:
> On Tue, May 10, 2011 at 11:04:57AM -0700, Yinghai Lu wrote:
>> On 05/10/2011 01:56 AM, Paul E. McKenney wrote:
>>> On Mon, May 09, 2011 at 02:09:21PM -0700, Yinghai Lu wrote:
>>>> On Mon, May 9, 2011 at 12:36 AM, Ingo Molnar <mingo@elte.hu> wrote:
>>>>>
>>>>> * Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:
>>>>>
>>>>>> Hello, Ingo,
>>>>>>
>>>>>> This pull request covers RCU chnages for 2.6.40.  The major new features
>>>>>> are RCU priority boosting and the addition of kfree_rcu(), the latter
>>>>>> courtesy of Lai Jiangshan.  These two features cover well over half
>>>>>> of the commits.  There are a number of smaller features and bug fixes.
>>>>>> All have been sent to LKML in the following batches:
>>>>>>
>>>>>> 0.    https://lkml.org/lkml/2011/2/22/660: RCU priority boosting preview
>>>>>> 1.    https://lkml.org/lkml/2011/5/1/19: RCU priority boosting, kfree_rcu()
>>>>>> 2.    https://lkml.org/lkml/2011/5/2/40: More uses of kfree_rcu()
>>>>>> 3.    https://lkml.org/lkml/2011/5/8/60: miscellaneous
>>>>>>
>>>>>> The kfree_rcu() uses in the pull request have Acked-by:s from the
>>>>>> maintainers.  I have some additional kfree_rcu() requests that lack
>>>>>> Acked-by:s, and I will deal with these later.
>>>>>>
>>>>>> These channges are available in the -rcu git repository at:
>>>>>>
>>>>>>   git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-2.6-rcu.git rcu/next
>>>>>
>>>>> Pulled, thanks a lot Paul!
>>>>>
>>>>
>>>> it seems with this one in tip, my 8 sockets test setup will report cpu stall.
>>>>
>>>> after hard code to enable rcu_cpu_stall_suppress
>>>>
>>>> Index: linux-2.6/kernel/rcutree.c
>>>> ===================================================================
>>>> --- linux-2.6.orig/kernel/rcutree.c
>>>> +++ linux-2.6/kernel/rcutree.c
>>>> @@ -174,7 +174,7 @@ module_param(blimit, int, 0);
>>>>  module_param(qhimark, int, 0);
>>>>  module_param(qlowmark, int, 0);
>>>>
>>>> -int rcu_cpu_stall_suppress __read_mostly;
>>>> +int rcu_cpu_stall_suppress __read_mostly = 1;
>>>>  module_param(rcu_cpu_stall_suppress, int, 0644);
>>>>
>>>>  static void force_quiescent_state(struct rcu_state *rsp, int relaxed);
>>>>
>>>> will get system hang after pnp ACPI init.
>>>
>>> Could you please send the stack traces from the RCU CPU stall?  Also,
>>> you do have ce31332d3c77532d6ea97ddcb475a2b02dd358b4 applied, correct?
>>>
>>> 							Thanx, Paul
>>
>> Do not have time to bisect it at this point.
> 
> Could you please send the stack traces from the RCU CPU stall?
> 
[   76.553010] calling  pnpacpi_init+0x0/0x8c @ 1
[   76.553236] pnp: PnP ACPI init
[   76.572833] ACPI: bus type pnp registered
[   76.573570] pnp 00:00: [bus 00-3f]
[   76.573766] pnp 00:00: [io  0x0000-0x5fff window]
[   76.592818] pnp 00:00: [mem 0x000a0000-0x000bffff window]
[   76.593099] pnp 00:00: [mem 0x000d0000-0x000dffff window]
[   76.612741] pnp 00:00: [mem 0x00000000-0xffffffff window]
[   76.613001] pnp 00:00: [mem 0x90000000-0xafffffff window]
[   76.632696] pnp 00:00: [mem 0xfed40000-0xfed44fff window]
[   76.632951] pnp 00:00: [mem 0xfc000000000-0xfc07fffffff window]
[   76.653366] pnp 00:00: Plug and Play ACPI device, IDs PNP0a08 PNP0a03 (active)
[   76.653730] pnp 00:01: [mem 0xfc000000-0xfcffffff]
[   76.672665] pnp 00:01: [mem 0xfd000000-0xfdffffff]
[   76.672887] pnp 00:01: [mem 0xfe000000-0xfebfffff]
[   76.693831] system 00:01: [mem 0xfc000000-0xfcffffff] has been reserved
[   76.694151] system 00:01: [mem 0xfd000000-0xfdffffff] has been reserved
[   76.712632] system 00:01: [mem 0xfe000000-0xfebfffff] has been reserved
[   76.712927] system 00:01: Plug and Play ACPI device, IDs PNP0c01 (active)
[  136.364832] INFO: rcu_sched_state detected stalls on CPUs/tasks: { 0} (detected by 124, t=15002 jiffies)
[  136.365317] sending NMI to all CPUs:
[  136.381054] NMI backtrace for cpu 0
[  136.381364] CPU 0 
[  136.381450] Modules linked in:
[  136.381638] 
[  136.400938] Pid: 0, comm: swapper Not tainted 2.6.39-rc6-tip-yh-03030-gfb0b6a9 #985 Oracle Corporation  Sun Fire X4800/     
[  136.420934] RIP: 0010:[<ffffffff810409eb>]  [<ffffffff810409eb>] mwait_idle+0xef/0x169
[  136.421313] RSP: 0018:ffffffff82397ee8  EFLAGS: 00000246
[  136.440953] RAX: 0000000000000000 RBX: ffffffff82397fd8 RCX: 0000000000000000
[  136.441256] RDX: 0000000000000000 RSI: 0000000000000001 RDI: ffffffff823a5020
[  136.461059] RBP: ffffffff82397ef8 R08: 0000000000000000 R09: 0000000000000000
[  136.480842] R10: ffffffffffffffff R11: ffffffff82397ed8 R12: 0000000000000000
[  136.481133] R13: ffff88807ffff300 R14: ffffffffffffffff R15: 0000000000000000
[  136.500932] FS:  0000000000000000(0000) GS:ffff88107de00000(0000) knlGS:0000000000000000
[  136.520779] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  136.521046] CR2: 0000000000000000 CR3: 000000000239d000 CR4: 00000000000006f0
[  136.540800] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  136.560608] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  136.560936] Process swapper (pid: 0, threadinfo ffffffff82396000, task ffffffff823a5020)
[  136.580762] Stack:
[  136.580852]  ffffffff82396000 ffffffff82525380 ffffffff82397f28 ffffffff810391f0
[  136.600682]  6db6db6db6db6db7 f51568c424a0f956 0000000000000002 6db6db6db6db6db7
[  136.601087]  ffffffff82397f58 ffffffff81bbbb93 ffffffff81bbbadc 0000000000000000
[  136.620945] Call Trace:
[  136.621063]  [<ffffffff810391f0>] cpu_idle+0xae/0xcc
[  136.640561]  [<ffffffff81bbbb93>] rest_init+0xb7/0xbe
[  136.640805]  [<ffffffff81bbbadc>] ? csum_partial_copy_generic+0x16c/0x16c
[  136.660553]  [<ffffffff826ffb4a>] start_kernel+0x3ba/0x3c5
[  136.660814]  [<ffffffff826ff2a6>] x86_64_start_reservations+0xb6/0xba
[  136.680553]  [<ffffffff826ff39c>] x86_64_start_kernel+0xf2/0xf9
[  136.680831] Code: 00 00 48 89 d1 48 8d 83 38 e0 ff ff 0f 01 c8 0f ae f0 48 8b 83 38 e0 ff ff a8 08 75 10 e8 ec fd 06 00 31 c0 48 89 c1 fb 0f 01 c9 <eb> 06 e8 dc fd 06 00 fb 8b 05 0f 0a 4e 01 65 44 8b 24 25 30 c7 
[  136.721038] Call Trace:
[  136.721160]  [<ffffffff810391f0>] cpu_idle+0xae/0xcc
[  136.740386]  [<ffffffff81bbbb93>] rest_init+0xb7/0xbe
[  136.740630]  [<ffffffff81bbbadc>] ? csum_partial_copy_generic+0x16c/0x16c
[  136.760349]  [<ffffffff826ffb4a>] start_kernel+0x3ba/0x3c5
[  136.760626]  [<ffffffff826ff2a6>] x86_64_start_reservations+0xb6/0xba
[  136.780369]  [<ffffffff826ff39c>] x86_64_start_kernel+0xf2/0xf9
[  136.800134] NMI backtrace for cpu 1
[  136.800321] CPU 1 
[  136.800436] Modules linked in:
[  136.800616] 
[  136.800703] Pid: 0, comm: kworker/0:0 Not tainted 2.6.39-rc6-tip-yh-03030-gfb0b6a9 #985 Oracle Corporation  Sun Fire X4800/     
[  136.839999] RIP: 0010:[<ffffffff810409eb>]  [<ffffffff810409eb>] mwait_idle+0xef/0x169
[  136.840388] RSP: 0000:ffff88103ee33ee8  EFLAGS: 00000246
[  136.860052] RAX: 0000000000000000 RBX: ffff88103ee33fd8 RCX: 0000000000000000
[  136.860373] RDX: 0000000000000000 RSI: 0000000000000001 RDI: ffff88103ee38000
[  136.880168] RBP: ffff88103ee33ef8 R08: 0000000000000000 R09: 0000000000000000
[  136.900089] R10: 0000000000000000 R11: ffff88103ee33ed8 R12: 0000000000000001
[  136.900416] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
[  136.920090] FS:  0000000000000000(0000) GS:ffff88107e000000(0000) knlGS:0000000000000000
[  136.950414] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  136.950684] CR2: 0000000000000000 CR3: 000000000239d000 CR4: 00000000000006e0
[  136.970157] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  136.970455] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  136.990120] Process kworker/0:0 (pid: 0, threadinfo ffff88103ee32000, task ffff88103ee38000)
[  137.009848] Stack:
[  137.009959]  ffff88103ee32000 ffffffff82525380 ffff88103ee33f28 ffffffff810391f0
[  137.032505]  ffff88103ee33f18 2bd3bd551d7037b4 0000000000000000 0000000000000000
[  137.032879]  ffff88103ee33f48 ffffffff81c064f3 0000000000000000 661fe41cd64eec39
[  137.049938] Call Trace:
[  137.050080]  [<ffffffff810391f0>] cpu_idle+0xae/0xcc
[  137.069800]  [<ffffffff81c064f3>] start_secondary+0xbd/0xbf
[  137.070075] Code: 00 00 48 89 d1 48 8d 83 38 e0 ff ff 0f 01 c8 0f ae f0 48 8b 83 38 e0 ff ff a8 08 75 10 e8 ec fd 06 00 31 c0 48 89 c1 fb 0f 01 c9 <eb> 06 e8 dc fd 06 00 fb 8b 05 0f 0a 4e 01 65 44 8b 24 25 30 c7 
[  137.109943] Call Trace:
[  137.110080]  [<ffffffff810391f0>] cpu_idle+0xae/0xcc
[  137.129466]  [<ffffffff81c064f3>] start_secondary+0xbd/0xbf
[  137.129703] NMI backtrace for cpu 2
[  137.129877] CPU 2 
[  137.149412] Modules linked in:
[  137.149603] 
[  137.149705] Pid: 0, comm: kworker/0:1 Not tainted 2.6.39-rc6-tip-yh-03030-gfb0b6a9 #985 Oracle Corporation  Sun Fire X4800/     
[  137.169681] RIP: 0010:[<ffffffff810409eb>]  [<ffffffff810409eb>] mwait_idle+0xef/0x169
[  137.189674] RSP: 0000:ffff88103ee5bee8  EFLAGS: 00000246
[  137.189933] RAX: 0000000000000000 RBX: ffff88103ee5bfd8 RCX: 0000000000000000
[  137.209465] RDX: 0000000000000000 RSI: 0000000000000001 RDI: ffff88103ee60000
[  137.229230] RBP: ffff88103ee5bef8 R08: 0000000000000000 R09: 0000000000000000
[  137.229570] R10: 0000000000000000 R11: ffff88103ee5bed8 R12: 0000000000000002
[  137.249542] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
[  137.269122] FS:  0000000000000000(0000) GS:ffff88107e200000(0000) knlGS:0000000000000000
[  137.269486] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  137.289226] CR2: 0000000000000000 CR3: 000000000239d000 CR4: 00000000000006e0
[  137.289536] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  137.309303] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  137.329096] Process kworker/0:1 (pid: 0, threadinfo ffff88103ee5a000, task ffff88103ee60000)
[  137.329443] Stack:
[  137.349030]  ffff88103ee5a000 ffffffff82525380 ffff88103ee5bf28 ffffffff810391f0
[  137.349444]  ffff88103ee5bf18 2a2988cc3681d8f7 0000000000000000 0000000000000000
[  137.369236]  ffff88103ee5bf48 ffffffff81c064f3 0000000000000000 63a332c588e07727
[  137.388974] Call Trace:
[  137.389121]  [<ffffffff810391f0>] cpu_idle+0xae/0xcc
[  137.389353]  [<ffffffff81c064f3>] start_secondary+0xbd/0xbf
[  137.409021] Code: 00 00 48 89 d1 48 8d 83 38 e0 ff ff 0f 01 c8 0f ae f0 48 8b 83 38 e0 ff ff a8 08 75 10 e8 ec fd 06 00 31 c0 48 89 c1 fb 0f 01 c9 <eb> 06 e8 dc fd 06 00 fb 8b 05 0f 0a 4e 01 65 44 8b 24 25 30 c7 
[  137.448825] Call Trace:
[  137.448951]  [<ffffffff810391f0>] cpu_idle+0xae/0xcc
[  137.449175]  [<ffffffff81c064f3>] start_secondary+0xbd/0xbf
[  137.468814] NMI backtrace for cpu 3
[  137.468990] CPU 3 
[  137.469084] Modules linked in:
[  137.469272] 
[  137.488737] Pid: 0, comm: kworker/0:1 Not tainted 2.6.39-rc6-tip-yh-03030-gfb0b6a9 #985 Oracle Corporation  Sun Fire X4800/     
[  137.508741] RIP: 0010:[<ffffffff810409eb>]  [<ffffffff810409eb>] mwait_idle+0xef/0x169
[  137.509123] RSP: 0000:ffff88103ee83ee8  EFLAGS: 00000246
[  137.528765] RAX: 0000000000000000 RBX: ffff88103ee83fd8 RCX: 0000000000000000
[  137.529096] RDX: 0000000000000000 RSI: 0000000000000001 RDI: ffff88103ee88000
[  137.548872] RBP: ffff88103ee83ef8 R08: 0000000000000000 R09: 0000000000000000
[  137.568641] R10: 0000000000000000 R11: ffff88103ee83ed8 R12: 0000000000000003
[  137.568957] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
[  137.588755] FS:  0000000000000000(0000) GS:ffff88107e400000(0000) knlGS:0000000000000000
[  137.608591] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  137.608847] CR2: 0000000000000000 CR3: 000000000239d000 CR4: 00000000000006e0
[  137.628623] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  137.648432] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  137.648728] Process kworker/0:1 (pid: 0, threadinfo ffff88103ee82000, task ffff88103ee88000)
[  137.670089] Stack:
[  137.670189]  ffff88103ee82000 ffffffff82525380 ffff88103ee83f28 ffffffff810391f0
[  137.688507]  ffff88103ee83f18 cacb1e5ab5a0da93 0000000000000000 0000000000000000
[  137.708279]  ffff88103ee83f48 ffffffff81c064f3 0000000000000000 83c0d3c3e7f0ed35
[  137.708699] Call Trace:
[  137.708835]  [<ffffffff810391f0>] cpu_idle+0xae/0xcc
[  137.728388]  [<ffffffff81c064f3>] start_secondary+0xbd/0xbf
[  137.728645] Code: 00 00 48 89 d1 48 8d 83 38 e0 ff ff 0f 01 c8 0f ae f0 48 8b 83 38 e0 ff ff a8 08 75 10 e8 ec fd 06 00 31 c0 48 89 c1 fb 0f 01 c9 <eb> 06 e8 dc fd 06 00 fb 8b 05 0f 0a 4e 01 65 44 8b 24 25 30 c7 
[  137.768750] Call Trace:
[  137.768874]  [<ffffffff810391f0>] cpu_idle+0xae/0xcc
[  137.788207]  [<ffffffff81c064f3>] start_secondary+0xbd/0xbf
[  137.788493] NMI backtrace for cpu 4
[  137.808088] CPU 4 
[  137.808175] Modules linked in:
[  137.808384] 
[  137.808461] Pid: 0, comm: kworker/0:1 Not tainted 2.6.39-rc6-tip-yh-03030-gfb0b6a9 #985 Oracle Corporation  Sun Fire X4800/     
[  137.828362] RIP: 0010:[<ffffffff810409eb>]  [<ffffffff810409eb>] mwait_idle+0xef/0x169
[  137.848186] RSP: 0000:ffff88103eeadee8  EFLAGS: 00000246
[  137.848440] RAX: 0000000000000000 RBX: ffff88103eeadfd8 RCX: 0000000000000000
[  137.868205] RDX: 0000000000000000 RSI: 0000000000000001 RDI: ffff88103eeb0000
[  137.887990] RBP: ffff88103eeadef8 R08: 0000000000000000 R09: 0000000000000000
[  137.888308] R10: 0000000000000000 R11: ffff88103eeaded8 R12: 0000000000000004
[  137.908084] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
[  137.928028] FS:  0000000000000000(0000) GS:ffff88107e600000(0000) knlGS:0000000000000000
[  137.928376] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  137.948182] CR2: 0000000000000000 CR3: 000000000239d000 CR4: 00000000000006e0
[  137.968138] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  137.968453] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  137.987930] Process kworker/0:1 (pid: 0, threadinfo ffff88103eeac000, task ffff88103eeb0000)
[  138.007782] Stack:
[  138.007905]  ffff88103eeac000 ffffffff82525380 ffff88103eeadf28 ffffffff810391f0
[  138.008306]  ffff88103eeadf18 37300352987163c3 0000000000000000 0000000000000000
[  138.028077]  ffff88103eeadf48 ffffffff81c064f3 0000000000000000 f12528251e665927
[  138.048050] Call Trace:
[  138.048173]  [<ffffffff810391f0>] cpu_idle+0xae/0xcc
[  138.048386]  [<ffffffff81c064f3>] start_secondary+0xbd/0xbf
[  138.067974] Code: 00 00 48 89 d1 48 8d 83 38 e0 ff ff 0f 01 c8 0f ae f0 48 8b 83 38 e0 ff ff a8 08 75 10 e8 ec fd 06 00 31 c0 48 89 c1 fb 0f 01 c9 <eb> 06 e8 dc fd 06 00 fb 8b 05 0f 0a 4e 01 65 44 8b 24 25 30 c7 
[  138.107791] Call Trace:
[  138.107916]  [<ffffffff810391f0>] cpu_idle+0xae/0xcc
[  138.108150]  [<ffffffff81c064f3>] start_secondary+0xbd/0xbf
[  138.127714] NMI backtrace for cpu 5
[  138.127899] CPU 5 
[  138.127999] Modules linked in:
[  138.147833] 
[  138.147911] Pid: 0, comm: kworker/0:1 Not tainted 2.6.39-rc6-tip-yh-03030-gfb0b6a9 #985 Oracle Corporation  Sun Fire X4800/     
[  138.167633] RIP: 0010:[<ffffffff810409eb>]  [<ffffffff810409eb>] mwait_idle+0xef/0x169
[  138.187390] RSP: 0000:ffff88103eecfee8  EFLAGS: 00000246
[  138.187621] RAX: 0000000000000000 RBX: ffff88103eecffd8 RCX: 0000000000000000
[  138.207291] RDX: 0000000000000000 RSI: 0000000000000001 RDI: ffff88103eed0000
[  138.207625] RBP: ffff88103eecfef8 R08: 0000000000000000 R09: 0000000000000000
[  138.227397] R10: 0000000000000000 R11: ffff88103eecfed8 R12: 0000000000000005
[  138.247345] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
[  138.247657] FS:  0000000000000000(0000) GS:ffff88107e800000(0000) knlGS:0000000000000000
[  138.267316] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  138.267577] CR2: 0000000000000000 CR3: 000000000239d000 CR4: 00000000000006e0
[  138.287344] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  138.307936] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  138.308252] Process kworker/0:1 (pid: 0, threadinfo ffff88103eece000, task ffff88103eed0000)
[  138.327333] Stack:
[  138.327424]  ffff88103eece000 ffffffff82525380 ffff88103eecff28 ffffffff810391f0
[  138.347307]  ffff88103eecff18 5c976e576efe47b3 0000000000000000 0000000000000000
[  138.367037]  ffff88103eecff48 ffffffff81c064f3 0000000000000000 f61e8ac9274555e7
[  138.367426] Call Trace:
[  138.386913]  [<ffffffff810391f0>] cpu_idle+0xae/0xcc
[  138.387162]  [<ffffffff81c064f3>] start_secondary+0xbd/0xbf
[  138.406850] Code: 00 00 48 89 d1 48 8d 83 38 e0 ff ff 0f 01 c8 0f ae f0 48 8b 83 38 e0 ff ff a8 08 75 10 e8 ec fd 06 00 31 c0 48 89 c1 fb 0f 01 c9 <eb> 06 e8 dc fd 06 00 fb 8b 05 0f 0a 4e 01 65 44 8b 24 25 30 c7 
[  138.427617] Call Trace:
[  138.427731]  [<ffffffff810391f0>] cpu_idle+0xae/0xcc
[  138.446968]  [<ffffffff81c064f3>] start_secondary+0xbd/0xbf
[  138.447219] NMI backtrace for cpu 6
[  138.466818] CPU 6 
[  138.466913] Modules linked in:
[  138.467084] 
[  138.467169] Pid: 0, comm: kworker/0:1 Not tainted 2.6.39-rc6-tip-yh-03030-gfb0b6a9 #985 Oracle Corporation  Sun Fire X4800/     
[  138.487237] RIP: 0010:[<ffffffff810409eb>]  [<ffffffff810409eb>] mwait_idle+0xef/0x169
[  138.506894] RSP: 0000:ffff88103eef7ee8  EFLAGS: 00000246
[  138.526591] RAX: 0000000000000000 RBX: ffff88103eef7fd8 RCX: 0000000000000000
[  138.526931] RDX: 0000000000000000 RSI: 0000000000000001 RDI: ffff88103eef8000
[  138.546705] RBP: ffff88103eef7ef8 R08: 0000000000000000 R09: 0000000000000000
[  138.566499] R10: 0000000000000000 R11: ffff88103eef7ed8 R12: 0000000000000006
[  138.566831] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
[  138.586585] FS:  0000000000000000(0000) GS:ffff88107ea00000(0000) knlGS:0000000000000000
[  138.606412] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  138.606667] CR2: 0000000000000000 CR3: 000000000239d000 CR4: 00000000000006e0
[  138.626666] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  138.626982] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  138.646565] Process kworker/0:1 (pid: 0, threadinfo ffff88103eef6000, task ffff88103eef8000)
[  138.666398] Stack:
[  138.666489]  ffff88103eef6000 ffffffff82525380 ffff88103eef7f28 ffffffff810391f0
[  138.686347]  ffff88103eef7f18 15e4bcc96f1f15ba 0000000000000000 0000000000000000
[  138.686762]  ffff88103eef7f48 ffffffff81c064f3 0000000000000000 9898fe604c13b8fd
[  138.706504] Call Trace:
[  138.706613]  [<ffffffff810391f0>] cpu_idle+0xae/0xcc
[  138.726202]  [<ffffffff81c064f3>] start_secondary+0xbd/0xbf
[  138.726447] Code: 00 00 48 89 d1 48 8d 83 38 e0 ff ff 0f 01 c8 0f ae f0 48 8b 83 38 e0 ff ff a8 08 75 10 e8 ec fd 06 00 31 c0 48 89 c1 fb 0f 01 c9 <eb> 06 e8 dc fd 06 00 fb 8b 05 0f 0a 4e 01 65 44 8b 24 25 30 c7 
[  138.766487] Call Trace:
[  138.766626]  [<ffffffff810391f0>] cpu_idle+0xae/0xcc
[  138.766890]  [<ffffffff81c064f3>] start_secondary+0xbd/0xbf
[  138.786275] NMI backtrace for cpu 7
[  138.786460] CPU 7 
[  138.786556] Modules linked in:
[  138.806144] 
[  138.806222] Pid: 0, comm: kworker/0:1 Not tainted 2.6.39-rc6-tip-yh-03030-gfb0b6a9 #985 Oracle Corporation  Sun Fire X4800/     
[  138.826206] RIP: 0010:[<ffffffff810409eb>]  [<ffffffff810409eb>] mwait_idle+0xef/0x169
[  138.845997] RSP: 0000:ffff88103ef17ee8  EFLAGS: 00000246
[  138.846225] RAX: 0000000000000000 RBX: ffff88103ef17fd8 RCX: 0000000000000000
[  138.866022] RDX: 0000000000000000 RSI: 0000000000000001 RDI: ffff88103ef20000
[  138.866343] RBP: ffff88103ef17ef8 R08: 0000000000000000 R09: 0000000000000000
[  138.886108] R10: 0000000000000000 R11: ffff88103ef17ed8 R12: 0000000000000007
[  138.905915] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
[  138.906216] FS:  0000000000000000(0000) GS:ffff88107ec00000(0000) knlGS:0000000000000000
[  138.926104] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  138.945846] CR2: 0000000000000000 CR3: 000000000239d000 CR4: 00000000000006e0
[  138.946147] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  138.976047] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  138.995888] Process kworker/0:1 (pid: 0, threadinfo ffff88103ef16000, task ffff88103ef20000)
[  138.996263] Stack:
[  139.015720]  ffff88103ef16000 ffffffff82525380 ffff88103ef17f28 ffffffff810391f0
[  139.016116]  ffff88103ef17f18 5945687aae80abf9 0000000000000000 0000000000000000
[  139.035768]  ffff88103ef17f48 ffffffff81c064f3 0000000000000000 1e4ee324f58b290c
[  139.055524] Call Trace:
[  139.055657]  [<ffffffff810391f0>] cpu_idle+0xae/0xcc
[  139.055904]  [<ffffffff81c064f3>] start_secondary+0xbd/0xbf
[  139.075528] Code: 00 00 48 89 d1 48 8d 83 38 e0 ff ff 0f 01 c8 0f ae f0 48 8b 83 38 e0 ff ff a8 08 75 10 e8 ec fd 06 00 31 c0 48 89 c1 fb 0f 01 c9 <eb> 06 e8 dc fd 06 00 fb 8b 05 0f 0a 4e 01 65 44 8b 24 25 30 c7 
[  139.096417] Call Trace:
[  139.115416]  [<ffffffff810391f0>] cpu_idle+0xae/0xcc
[  139.115626]  [<ffffffff81c064f3>] start_secondary+0xbd/0xbf
[  139.135361] NMI backtrace for cpu 8
[  139.135539] CPU 8 
[  139.135636] Modules linked in:
[  139.135810] 
[  139.135888] Pid: 0, comm: kworker/0:1 Not tainted 2.6.39-rc6-tip-yh-03030-gfb0b6a9 #985 Oracle Corporation  Sun Fire X4800/     
[  139.175277] RIP: 0010:[<ffffffff810409eb>]  [<ffffffff810409eb>] mwait_idle+0xef/0x169
[  139.175644] RSP: 0000:ffff88103ef2dee8  EFLAGS: 00000246
[  139.195308] RAX: 0000000000000000 RBX: ffff88103ef2dfd8 RCX: 0000000000000000
[  139.195607] RDX: 0000000000000000 RSI: 0000000000000001 RDI: ffff88103ef24560
[  139.215407] RBP: ffff88103ef2def8 R08: 0000000000000000 R09: 0000000000000000
[  139.235209] R10: 0000000000000000 R11: ffff88103ef2ded8 R12: 0000000000000008
[  139.235524] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
[  139.255299] FS:  0000000000000000(0000) GS:ffff88207de00000(0000) knlGS:0000000000000000
[  139.275144] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  139.275380] CR2: 0000000000000000 CR3: 000000000239d000 CR4: 00000000000006e0
[  139.295174] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  139.295480] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  139.315261] Process kworker/0:1 (pid: 0, threadinfo ffff88103ef2c000, task ffff88103ef24560)
[  139.335121] Stack:
[  139.335229]  ffff88103ef2c000 ffffffff82525380 ffff88103ef2df28 ffffffff810391f0
[  139.355031]  ffff88103ef2df18 eb2a74b30d32a306 0000000000000000 0000000000000000
[  139.355459]  ffff88103ef2df48 ffffffff81c064f3 0000000000000000 27567f4754362612
[  139.375207] Call Trace:
[  139.375321]  [<ffffffff810391f0>] cpu_idle+0xae/0xcc
[  139.394922]  [<ffffffff81c064f3>] start_secondary+0xbd/0xbf
[  139.395182] Code: 00 00 48 89 d1 48 8d 83 38 e0 ff ff 0f 01 c8 0f ae f0 48 8b 83 38 e0 ff ff a8 08 75 10 e8 ec fd 06 00 31 c0 48 89 c1 fb 0f 01 c9 <eb> 06 e8 dc fd 06 00 fb 8b 05 0f 0a 4e 01 65 44 8b 24 25 30 c7 
[  139.435249] Call Trace:
[  139.435373]  [<ffffffff810391f0>] cpu_idle+0xae/0xcc
[  139.454753]  [<ffffffff81c064f3>] start_secondary+0xbd/0xbf
[  139.455037] NMI backtrace for cpu 9
[  139.455259] CPU 9 
[  139.474697] Modules linked in:
[  139.474865] 
[  139.474955] Pid: 0, comm: kworker/0:1 Not tainted 2.6.39-rc6-tip-yh-03030-gfb0b6a9 #985 Oracle Corporation  Sun Fire X4800/     
[  139.494927] RIP: 0010:[<ffffffff810409eb>]  [<ffffffff810409eb>] mwait_idle+0xef/0x169
[  139.514696] RSP: 0000:ffff88103ef43ee8  EFLAGS: 00000246
[  139.514927] RAX: 0000000000000000 RBX: ffff88103ef43fd8 RCX: 0000000000000000
[  139.534738] RDX: 0000000000000000 RSI: 0000000000000001 RDI: ffff88103ef3a2b0
[  139.554512] RBP: ffff88103ef43ef8 R08: 0000000000000000 R09: 0000000000000000
[  139.554835] R10: 0000000000000000 R11: ffff88103ef43ed8 R12: 0000000000000009
[  139.574608] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
[  139.594406] FS:  0000000000000000(0000) GS:ffff88207e000000(0000) knlGS:0000000000000000
[  139.594741] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  139.615073] CR2: 0000000000000000 CR3: 000000000239d000 CR4: 00000000000006e0
[  139.615381] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  139.634602] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  139.654372] Process kworker/0:1 (pid: 0, threadinfo ffff88103ef42000, task ffff88103ef3a2b0)
[  139.654753] Stack:
[  139.674315]  ffff88103ef42000 ffffffff82525380 ffff88103ef43f28 ffffffff810391f0
[  139.674694]  ffff88103ef43f18 259a5068eb4fd413 0000000000000000 0000000000000000
[  139.694533]  ffff88103ef43f48 ffffffff81c064f3 0000000000000000 239846a0b996998b
[  139.714264] Call Trace:
[  139.714401]  [<ffffffff810391f0>] cpu_idle+0xae/0xcc
[  139.714636]  [<ffffffff81c064f3>] start_secondary+0xbd/0xbf
[  139.734285] Code: 00 00 48 89 d1 48 8d 83 38 e0 ff ff 0f 01 c8 0f ae f0 48 8b 83 38 e0 ff ff a8 08 75 10 e8 ec fd 06 00 31 c0 48 89 c1 fb 0f 01 c9 <eb> 06 e8 dc fd 06 00 fb 8b 05 0f 0a 4e 01 65 44 8b 24 25 30 c7 
[  139.774083] Call Trace:
[  139.774217]  [<ffffffff810391f0>] cpu_idle+0xae/0xcc
[  139.774475]  [<ffffffff81c064f3>] start_secondary+0xbd/0xbf
[  139.794095] NMI backtrace for cpu 10
[  139.794275] CPU 10 
[  139.794363] Modules linked in:
[  139.813951] 
[  139.814034] Pid: 0, comm: kworker/0:1 Not tainted 2.6.39-rc6-tip-yh-03030-gfb0b6a9 #985 Oracle Corporation  Sun Fire X4800/     
[  139.834046] RIP: 0010:[<ffffffff810409eb>]  [<ffffffff810409eb>] mwait_idle+0xef/0x169
[  139.834393] RSP: 0000:ffff88103ef51ee8  EFLAGS: 00000246
[  139.854066] RAX: 0000000000000000 RBX: ffff88103ef51fd8 RCX: 0000000000000000
[  139.873832] RDX: 0000000000000000 RSI: 0000000000000001 RDI: ffff88103ef4a2b0
[  139.874139] RBP: ffff88103ef51ef8 R08: 0000000000000000 R09: 0000000000000000
[  139.893924] R10: 0000000000000000 R11: ffff88103ef51ed8 R12: 000000000000000a
[  139.894249] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
[  139.914130] FS:  0000000000000000(0000) GS:ffff88207e200000(0000) knlGS:0000000000000000
[  139.934036] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  139.934308] CR2: 0000000000000000 CR3: 000000000239d000 CR4: 00000000000006e0
[  139.954045] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  139.973916] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  139.974244] Process kworker/0:1 (pid: 0, threadinfo ffff88103ef50000, task ffff88103ef4a2b0)
[  139.993995] Stack:
[  139.994086]  ffff88103ef50000 ffffffff82525380 ffff88103ef51f28 ffffffff810391f0
[  140.013955]  ffff88103ef51f18 ecfea0cf87080794 0000000000000000 0000000000000000
[  140.033587]  ffff88103ef51f48 ffffffff81c064f3 0000000000000000 18b78e007f343e26
[  140.033982] Call Trace:
[  140.034112]  [<ffffffff810391f0>] cpu_idle+0xae/0xcc
[  140.053671]  [<ffffffff81c064f3>] start_secondary+0xbd/0xbf
[  140.053948] Code: 00 00 48 89 d1 48 8d 83 38 e0 ff ff 0f 01 c8 0f ae f0 48 8b 83 38 e0 ff ff a8 08 75 10 e8 ec fd 06 00 31 c0 48 89 c1 fb 0f 01 c9 <eb> 06 e8 dc fd 06 00 fb 8b 05 0f 0a 4e 01 65 44 8b 24 25 30 c7 
[  140.094038] Call Trace:
[  140.094184]  [<ffffffff810391f0>] cpu_idle+0xae/0xcc
[  140.113500]  [<ffffffff81c064f3>] start_secondary+0xbd/0xbf
[  140.113767] NMI backtrace for cpu 11
[  140.133361] CPU 11 
[  140.133453] Modules linked in:
[  140.133631] 
[  140.133721] Pid: 0, comm: kworker/0:1 Not tainted 2.6.39-rc6-tip-yh-03030-gfb0b6a9 #985 Oracle Corporation  Sun Fire X4800/     
[  140.153658] RIP: 0010:[<ffffffff810409eb>]  [<ffffffff810409eb>] mwait_idle+0xef/0x169
[  140.173459] RSP: 0000:ffff88103ef69ee8  EFLAGS: 00000246
[  140.173730] RAX: 0000000000000000 RBX: ffff88103ef69fd8 RCX: 0000000000000000
[  140.193479] RDX: 0000000000000000 RSI: 0000000000000001 RDI: ffff88103ef5a2b0
[  140.213268] RBP: ffff88103ef69ef8 R08: 0000000000000000 R09: 0000000000000000
[  140.213583] R10: 0000000000000000 R11: ffff88103ef69ed8 R12: 000000000000000b
[  140.233334] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
[  140.258346] FS:  0000000000000000(0000) GS:ffff88207e400000(0000) knlGS:0000000000000000
[  140.258715] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  140.273228] CR2: 0000000000000000 CR3: 000000000239d000 CR4: 00000000000006e0
[  140.293022] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  140.293328] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  140.313135] Process kworker/0:1 (pid: 0, threadinfo ffff88103ef68000, task ffff88103ef5a2b0)
[  140.332980] Stack:
[  140.333075]  ffff88103ef68000 ffffffff82525380 ffff88103ef69f28 ffffffff810391f0
[  140.352854]  ffff88103ef69f18 11d983a4aef23a75 0000000000000000 0000000000000000
[  140.353269]  ffff88103ef69f48 ffffffff81c064f3 0000000000000000 32786c201221b6e6
[  140.373033] Call Trace:
[  140.373147]  [<ffffffff810391f0>] cpu_idle+0xae/0xcc
[  140.392777]  [<ffffffff81c064f3>] start_secondary+0xbd/0xbf
[  140.393028] Code: 00 00 48 89 d1 48 8d 83 38 e0 ff ff 0f 01 c8 0f ae f0 48 8b 83 38 e0 ff ff a8 08 75 10 e8 ec fd 06 00 31 c0 48 89 c1 fb 0f 01 c9 <eb> 06 e8 dc fd 06 00 fb 8b 05 0f 0a 4e 01 65 44 8b 24 25 30 c7 
[  140.432965] Call Trace:
[  140.433087]  [<ffffffff810391f0>] cpu_idle+0xae/0xcc
[  140.433318]  [<ffffffff81c064f3>] start_secondary+0xbd/0xbf
[  140.452856] NMI backtrace for cpu 12
[  140.453047] CPU 12 
[  140.453152] Modules linked in:
[  140.472699] 
[  140.472804] Pid: 0, comm: kworker/0:1 Not tainted 2.6.39-rc6-tip-yh-03030-gfb0b6a9 #985 Oracle Corporation  Sun Fire X4800/     
[  140.492785] RIP: 0010:[<ffffffff810409eb>]  [<ffffffff810409eb>] mwait_idle+0xef/0x169
[  140.512550] RSP: 0000:ffff88103ef6fee8  EFLAGS: 00000246
[  140.512772] RAX: 0000000000000000 RBX: ffff88103ef6ffd8 RCX: 0000000000000000
[  140.532588] RDX: 0000000000000000 RSI: 0000000000000001 RDI: ffff88103ef7a2b0
[  140.532919] RBP: ffff88103ef6fef8 R08: 0000000000000000 R09: 0000000000000000
[  140.552775] R10: 0000000000000000 R11: ffff88103ef6fed8 R12: 000000000000000c
[  140.572474] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
[  140.572805] FS:  0000000000000000(0000) GS:ffff88207e600000(0000) knlGS:0000000000000000
[  140.592615] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  140.612359] CR2: 0000000000000000 CR3: 000000000239d000 CR4: 00000000000006e0
[  140.612675] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  140.632533] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  140.632844] Process kworker/0:1 (pid: 0, threadinfo ffff88103ef6e000, task ffff88103ef7a2b0)
[  140.652591] Stack:
[  140.652685]  ffff88103ef6e000 ffffffff82525380 ffff88103ef6ff28 ffffffff810391f0
[  140.672580]  ffff88103ef6ff18 9d782048b5866d90 0000000000000000 0000000000000000
[  140.692362]  ffff88103ef6ff48 ffffffff81c064f3 0000000000000000 05d404c0ff314e85
[  140.692756] Call Trace:
[  140.712335]  [<ffffffff810391f0>] cpu_idle+0xae/0xcc
[  140.712575]  [<ffffffff81c064f3>] start_secondary+0xbd/0xbf
[  140.732124] Code: 00 00 48 89 d1 48 8d 83 38 e0 ff ff 0f 01 c8 0f ae f0 48 8b 83 38 e0 ff ff a8 08 75 10 e8 ec fd 06 00 31 c0 48 89 c1 fb 0f 01 c9 <eb> 06 e8 dc fd 06 00 fb 8b 05 0f 0a 4e 01 65 44 8b 24 25 30 c7 
[  140.752935] Call Trace:
[  140.772011]  [<ffffffff810391f0>] cpu_idle+0xae/0xcc
[  140.772230]  [<ffffffff81c064f3>] start_secondary+0xbd/0xbf
[  140.772510] NMI backtrace for cpu 13
[  140.792102] CPU 13 
[  140.792197] Modules linked in:
[  140.792371] 
[  140.792458] Pid: 0, comm: kworker/0:1 Not tainted 2.6.39-rc6-tip-yh-03030-gfb0b6a9 #985 Oracle Corporation  Sun Fire X4800/     
[  140.812395] RIP: 0010:[<ffffffff810409eb>]  [<ffffffff810409eb>] mwait_idle+0xef/0x169
[  140.832216] RSP: 0000:ffff88103ef8dee8  EFLAGS: 00000246
[  140.851940] RAX: 0000000000000000 RBX: ffff88103ef8dfd8 RCX: 0000000000000000
[  140.852244] RDX: 0000000000000000 RSI: 0000000000000001 RDI: ffff88103ef822b0
[  140.872040] RBP: ffff88103ef8def8 R08: 0000000000000000 R09: 0000000000000000
[  140.892636] R10: 0000000000000000 R11: ffff88103ef8ded8 R12: 000000000000000d
[  140.892947] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
[  140.911916] FS:  0000000000000000(0000) GS:ffff88207e800000(0000) knlGS:0000000000000000
[  140.931832] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  140.932117] CR2: 0000000000000000 CR3: 000000000239d000 CR4: 00000000000006e0
[  140.952036] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  140.952379] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  140.972012] Process kworker/0:1 (pid: 0, threadinfo ffff88103ef8c000, task ffff88103ef822b0)
[  140.991960] Stack:
[  140.992061]  ffff88103ef8c000 ffffffff82525380 ffff88103ef8df28 ffffffff810391f0
[  141.011881]  ffff88103ef8df18 1496eb38451a5aa8 0000000000000000 0000000000000000
[  141.012288]  ffff88103ef8df48 ffffffff81c064f3 0000000000000000 1946ee8e3f03f230
[  141.031949] Call Trace:
[  141.032057]  [<ffffffff810391f0>] cpu_idle+0xae/0xcc
[  141.051548]  [<ffffffff81c064f3>] start_secondary+0xbd/0xbf
[  141.051815] Code: 00 00 48 89 d1 48 8d 83 38 e0 ff ff 0f 01 c8 0f ae f0 48 8b 83 38 e0 ff ff a8 08 75 10 e8 ec fd 06 00 31 c0 48 89 c1 fb 0f 01 c9 <eb> 06 e8 dc fd 06 00 fb 8b 05 0f 0a 4e 01 65 44 8b 24 25 30 c7 
[  141.091816] Call Trace:
[  141.091945]  [<ffffffff810391f0>] cpu_idle+0xae/0xcc
[  141.111379]  [<ffffffff81c064f3>] start_secondary+0xbd/0xbf
[  141.111673] NMI backtrace for cpu 14
[  141.111839] CPU 14 
[  141.131299] Modules linked in:
[  141.131492] 
[  141.131579] Pid: 0, comm: kworker/0:1 Not tainted 2.6.39-rc6-tip-yh-03030-gfb0b6a9 #985 Oracle Corporation  Sun Fire X4800/     
[  141.151543] RIP: 0010:[<ffffffff810409eb>]  [<ffffffff810409eb>] mwait_idle+0xef/0x169
[  141.171304] RSP: 0000:ffff88103efa3ee8  EFLAGS: 00000246
[  141.171553] RAX: 0000000000000000 RBX: ffff88103efa3fd8 RCX: 0000000000000000
[  141.191319] RDX: 0000000000000000 RSI: 0000000000000001 RDI: ffff88103ef9a2b0
[  141.211122] RBP: ffff88103efa3ef8 R08: 0000000000000000 R09: 0000000000000000
[  141.211430] R10: 0000000000000000 R11: ffff88103efa3ed8 R12: 000000000000000e
[  141.231204] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
[  141.231532] FS:  0000000000000000(0000) GS:ffff88207ea00000(0000) knlGS:0000000000000000
[  141.251365] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  141.271218] CR2: 0000000000000000 CR3: 000000000239d000 CR4: 00000000000006e0
[  141.271561] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  141.291197] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  141.310971] Process kworker/0:1 (pid: 0, threadinfo ffff88103efa2000, task ffff88103ef9a2b0)
[  141.311371] Stack:
[  141.330919]  ffff88103efa2000 ffffffff82525380 ffff88103efa3f28 ffffffff810391f0
[  141.331318]  ffff88103efa3f18 0ab959daf09fa942 0000000000000000 0000000000000000
[  141.351115]  ffff88103efa3f48 ffffffff81c064f3 0000000000000000 4298453ed66e2456
[  141.370848] Call Trace:
[  141.370981]  [<ffffffff810391f0>] cpu_idle+0xae/0xcc
[  141.371225]  [<ffffffff81c064f3>] start_secondary+0xbd/0xbf
[  141.390899] Code: 00 00 48 89 d1 48 8d 83 38 e0 ff ff 0f 01 c8 0f ae f0 48 8b 83 38 e0 ff ff a8 08 75 10 e8 ec fd 06 00 31 c0 48 89 c1 fb 0f 01 c9 <eb> 06 e8 dc fd 06 00 fb 8b 05 0f 0a 4e 01 65 44 8b 24 25 30 c7 
[  141.430647] Call Trace:
[  141.430774]  [<ffffffff810391f0>] cpu_idle+0xae/0xcc
[  141.431011]  [<ffffffff81c064f3>] start_secondary+0xbd/0xbf
[  141.450711] NMI backtrace for cpu 15
[  141.450896] CPU 15 
[  141.451011] Modules linked in:
[  141.451189] 
[  141.470621] Pid: 0, comm: kworker/0:1 Not tainted 2.6.39-rc6-tip-yh-03030-gfb0b6a9 #985 Oracle Corporation  Sun Fire X4800/     
[  141.490630] RIP: 0010:[<ffffffff810409eb>]  [<ffffffff810409eb>] mwait_idle+0xef/0x169
[  141.491003] RSP: 0000:ffff88103efb1ee8  EFLAGS: 00000246
[  141.510686] RAX: 0000000000000000 RBX: ffff88103efb1fd8 RCX: 0000000000000000
[  141.510979] RDX: 0000000000000000 RSI: 0000000000000001 RDI: ffff88103efaa2b0
[  141.530758] RBP: ffff88103efb1ef8 R08: 0000000000000000 R09: 0000000000000000
[  141.555764] R10: 0000000000000000 R11: ffff88103efb1ed8 R12: 000000000000000f
[  141.556182] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
[  141.570663] FS:  0000000000000000(0000) GS:ffff88207ec00000(0000) knlGS:0000000000000000
[  141.590492] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  141.590742] CR2: 0000000000000000 CR3: 000000000239d000 CR4: 00000000000006e0
[  141.610514] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  141.630305] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  141.630631] Process kworker/0:1 (pid: 0, threadinfo ffff88103efb0000, task ffff88103efaa2b0)
[  141.650438] Stack:
[  141.650531]  ffff88103efb0000 ffffffff82525380 ffff88103efb1f28 ffffffff810391f0
[  141.670404]  ffff88103efb1f18 c089ea705be6a98b 0000000000000000 0000000000000000
[  141.690174]  ffff88103efb1f48 ffffffff81c064f3 0000000000000000 f5949bd6339eff74
[  141.690594] Call Trace:
[  141.690713]  [<ffffffff810391f0>] cpu_idle+0xae/0xcc
[  141.710299]  [<ffffffff81c064f3>] start_secondary+0xbd/0xbf
[  141.710559] Code: 00 00 48 89 d1 48 8d 83 38 e0 ff ff 0f 01 c8 0f ae f0 48 8b 83 38 e0 ff ff a8 08 75 10 e8 ec fd 06 00 31 c0 48 89 c1 fb 0f 01 c9 <eb> 06 e8 dc fd 06 00 fb 8b 05 0f 0a 4e 01 65 44 8b 24 25 30 c7 
[  141.750698] Call Trace:
[  141.750815]  [<ffffffff810391f0>] cpu_idle+0xae/0xcc
[  141.770102]  [<ffffffff81c064f3>] start_secondary+0xbd/0xbf
[  141.770384] NMI backtrace for cpu 16
[  141.789970] CPU 16 
[  141.790081] Modules linked in:
[  141.790289] 
[  141.790389] Pid: 0, comm: kworker/0:1 Not tainted 2.6.39-rc6-tip-yh-03030-gfb0b6a9 #985 Oracle Corporation  Sun Fire X4800/     
[  141.810304] RIP: 0010:[<ffffffff810409eb>]  [<ffffffff810409eb>] mwait_idle+0xef/0x169
[  141.830083] RSP: 0000:ffff88103efd1ee8  EFLAGS: 00000246
[  141.830332] RAX: 0000000000000000 RBX: ffff88103efd1fd8 RCX: 0000000000000000
[  141.850103] RDX: 0000000000000000 RSI: 0000000000000001 RDI: ffff88103efc22b0
[  141.869892] RBP: ffff88103efd1ef8 R08: 0000000000000000 R09: 0000000000000000
[  141.870237] R10: 0000000000000000 R11: ffff88103efd1ed8 R12: 0000000000000010
[  141.889988] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
[  141.909768] FS:  0000000000000000(0000) GS:ffff88307de00000(0000) knlGS:0000000000000000
[  141.910145] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  141.930014] CR2: 0000000000000000 CR3: 000000000239d000 CR4: 00000000000006e0
[  141.949891] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  141.950219] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  141.969788] Process kworker/0:1 (pid: 0, threadinfo ffff88103efd0000, task ffff88103efc22b0)
[  141.989625] Stack:
[  141.989728]  ffff88103efd0000 ffffffff82525380 ffff88103efd1f28 ffffffff810391f0
[  141.990131]  ffff88103efd1f18 d308e5f636b1a8a6 0000000000000000 0000000000000000
[  142.010042]  ffff88103efd1f48 ffffffff81c064f3 0000000000000000 6ff58ab7fd41784e
[  142.029662] Call Trace:
[  142.029803]  [<ffffffff810391f0>] cpu_idle+0xae/0xcc
[  142.030037]  [<ffffffff81c064f3>] start_secondary+0xbd/0xbf
[  142.049772] Code: 00 00 48 89 d1 48 8d 83 38 e0 ff ff 0f 01 c8 0f ae f0 48 8b 83 38 e0 ff ff a8 08 75 10 e8 ec fd 06 00 31 c0 48 89 c1 fb 0f 01 c9 <eb> 06 e8 dc fd 06 00 fb 8b 05 0f 0a 4e 01 65 44 8b 24 25 30 c7 
[  142.089841] Call Trace:
[  142.089956]  [<ffffffff810391f0>] cpu_idle+0xae/0xcc
[  142.090215]  [<ffffffff81c064f3>] start_secondary+0xbd/0xbf
[  142.109532] NMI backtrace for cpu 17
[  142.109722] CPU 17 
[  142.109821] Modules linked in:
[  142.129537] 
[  142.129634] Pid: 0, comm: kworker/0:1 Not tainted 2.6.39-rc6-tip-yh-03030-gfb0b6a9 #985 Oracle Corporation  Sun Fire X4800/     
[  142.169733] RIP: 0010:[<ffffffff810409eb>]  [<ffffffff810409eb>] mwait_idle+0xef/0x169
[  142.189467] RSP: 0000:ffff88103efe1ee8  EFLAGS: 00000246
[  142.189728] RAX: 0000000000000000 RBX: ffff88103efe1fd8 RCX: 0000000000000000
[  142.214907] RDX: 0000000000000000 RSI: 0000000000000001 RDI: ffff88103efda2b0
[  142.215275] RBP: ffff88103efe1ef8 R08: 0000000000000000 R09: 0000000000000000
[  142.229406] R10: 0000000000000000 R11: ffff88103efe1ed8 R12: 0000000000000011
[  142.249462] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
[  142.249788] FS:  0000000000000000(0000) GS:ffff88307e000000(0000) knlGS:0000000000000000
[  142.279529] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  142.298927] CR2: 0000000000000000 CR3: 000000000239d000 CR4: 00000000000006e0
[  142.299266] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  142.319011] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  142.319354] Process kworker/0:1 (pid: 0, threadinfo ffff88103efe0000, task ffff88103efda2b0)
[  142.339157] Stack:
[  142.339263]  ffff88103efe0000 ffffffff82525380 ffff88103efe1f28 ffffffff810391f0
[  142.359098]  ffff88103efe1f18 2cfef7407d13bcdc 0000000000000000 0000000000000000
[  142.378864]  ffff88103efe1f48 ffffffff81c064f3 0000000000000000 5aef71e9d25d79be
[  142.379280] Call Trace:
[  142.398788]  [<ffffffff810391f0>] cpu_idle+0xae/0xcc
[  142.399028]  [<ffffffff81c064f3>] start_secondary+0xbd/0xbf
[  142.418688] Code: 00 00 48 89 d1 48 8d 83 38 e0 ff ff 0f 01 c8 0f ae f0 48 8b 83 38 e0 ff ff a8 08 75 10 e8 ec fd 06 00 31 c0 48 89 c1 fb 0f 01 c9 <eb> 06 e8 dc fd 06 00 fb 8b 05 0f 0a 4e 01 65 44 8b 24 25 30 c7 
[  142.439455] Call Trace:
[  142.439602]  [<ffffffff810391f0>] cpu_idle+0xae/0xcc
[  142.458800]  [<ffffffff81c064f3>] start_secondary+0xbd/0xbf
[  142.459070] NMI backtrace for cpu 18
[  142.478648] CPU 18 
[  142.478761] Modules linked in:
[  142.478954] 
[  142.479053] Pid: 0, comm: kworker/0:1 Not tainted 2.6.39-rc6-tip-yh-03030-gfb0b6a9 #985 Oracle Corporation  Sun Fire X4800/     
[  142.498981] RIP: 0010:[<ffffffff810409eb>]  [<ffffffff810409eb>] mwait_idle+0xef/0x169
[  142.518775] RSP: 0000:ffff88103efe7ee8  EFLAGS: 00000246
[  142.538455] RAX: 0000000000000000 RBX: ffff88103efe7fd8 RCX: 0000000000000000
[  142.538785] RDX: 0000000000000000 RSI: 0000000000000001 RDI: ffff88103efea2b0
[  142.558556] RBP: ffff88103efe7ef8 R08: 0000000000000000 R09: 0000000000000000
[  142.578332] R10: 0000000000000000 R11: ffff88103efe7ed8 R12: 0000000000000012
[  142.578695] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
[  142.598439] FS:  0000000000000000(0000) GS:ffff88307e200000(0000) knlGS:0000000000000000
[  142.618278] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  142.618556] CR2: 0000000000000000 CR3: 000000000239d000 CR4: 00000000000006e0
[  142.638537] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  142.638904] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  142.658418] Process kworker/0:1 (pid: 0, threadinfo ffff88103efe6000, task ffff88103efea2b0)
[  142.678265] Stack:
[  142.678357]  ffff88103efe6000 ffffffff82525380 ffff88103efe7f28 ffffffff810391f0
[  142.698172]  ffff88103efe7f18 9996aca01738a61f 0000000000000000 0000000000000000
[  142.698616]  ffff88103efe7f48 ffffffff81c064f3 0000000000000000 40c7708621549c8a
[  142.718380] Call Trace:
[  142.718506]  [<ffffffff810391f0>] cpu_idle+0xae/0xcc
[  142.738070]  [<ffffffff81c064f3>] start_secondary+0xbd/0xbf
[  142.738368] Code: 00 00 48 89 d1 48 8d 83 38 e0 ff ff 0f 01 c8 0f ae f0 48 8b 83 38 e0 ff ff a8 08 75 10 e8 ec fd 06 00 31 c0 48 89 c1 fb 0f 01 c9 <eb> 06 e8 dc fd 06 00 fb 8b 05 0f 0a 4e 01 65 44 8b 24 25 30 c7 
[  142.778351] Call Trace:
[  142.778493]  [<ffffffff810391f0>] cpu_idle+0xae/0xcc
[  142.797883]  [<ffffffff81c064f3>] start_secondary+0xbd/0xbf
[  142.798156] NMI backtrace for cpu 19
[  142.798348] CPU 19 
[  142.817835] Modules linked in:
[  142.818037] 
[  142.818129] Pid: 0, comm: kworker/0:1 Not tainted 2.6.39-rc6-tip-yh-03030-gfb0b6a9 #985 Oracle Corporation  Sun Fire X4800/     
[  142.838089] RIP: 0010:[<ffffffff810409eb>]  [<ffffffff810409eb>] mwait_idle+0xef/0x169
[  142.862710] RSP: 0000:ffff88103e805ee8  EFLAGS: 00000246
[  142.862964] RAX: 0000000000000000 RBX: ffff88103e805fd8 RCX: 0000000000000000
[  142.877887] RDX: 0000000000000000 RSI: 0000000000000001 RDI: ffff88103effa2b0
[  142.878204] RBP: ffff88103e805ef8 R08: 0000000000000000 R09: 0000000000000000
[  142.897981] R10: 0000000000000000 R11: ffff88103e805ed8 R12: 0000000000000013
[  142.917799] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
[  142.918130] FS:  0000000000000000(0000) GS:ffff88307e400000(0000) knlGS:0000000000000000
[  142.939106] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  142.957676] CR2: 0000000000000000 CR3: 000000000239d000 CR4: 00000000000006e0
[  142.958011] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  142.977809] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  142.997672] Process kworker/0:1 (pid: 0, threadinfo ffff88103e804000, task ffff88103effa2b0)
[  142.998085] Stack:
[  143.017695]  ffff88103e804000 ffffffff82525380 ffff88103e805f28 ffffffff810391f0
[  143.018151]  ffff88103e805f18 d4ede08c6a7229e8 0000000000000000 0000000000000000
[  143.037816]  ffff88103e805f48 ffffffff81c064f3 0000000000000000 0d5fb9e457f7ceed
[  143.057424] Call Trace:
[  143.057539]  [<ffffffff810391f0>] cpu_idle+0xae/0xcc
[  143.057804]  [<ffffffff81c064f3>] start_secondary+0xbd/0xbf
[  143.077411] Code: 00 00 48 89 d1 48 8d 83 38 e0 ff ff 0f 01 c8 0f ae f0 48 8b 83 38 e0 ff ff a8 08 75 10 e8 ec fd 06 00 31 c0 48 89 c1 fb 0f 01 c9 <eb> 06 e8 dc fd 06 00 fb 8b 05 0f 0a 4e 01 65 44 8b 24 25 30 c7 
[  143.098284] Call Trace:
[  143.117331]  [<ffffffff810391f0>] cpu_idle+0xae/0xcc
[  143.117603]  [<ffffffff81c064f3>] start_secondary+0xbd/0xbf
[  143.137288] NMI backtrace for cpu 20
[  143.137473] CPU 20 
[  143.137573] Modules linked in:
[  143.137783] 
[  143.157190] Pid: 0, comm: kworker/0:1 Not tainted 2.6.39-rc6-tip-yh-03030-gfb0b6a9 #985 Oracle Corporation  Sun Fire X4800/     
[  143.177190] RIP: 0010:[<ffffffff810409eb>]  [<ffffffff810409eb>] mwait_idle+0xef/0x169
[  143.177590] RSP: 0000:ffff88103e825ee8  EFLAGS: 00000246
[  143.197215] RAX: 0000000000000000 RBX: ffff88103e825fd8 RCX: 0000000000000000
[  143.197561] RDX: 0000000000000000 RSI: 0000000000000001 RDI: ffff88103e80a2b0
[  143.217831] RBP: ffff88103e825ef8 R08: 0000000000000000 R09: 0000000000000000
[  143.237318] R10: 0000000000000000 R11: ffff88103e825ed8 R12: 0000000000000014
[  143.237658] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
[  143.257208] FS:  0000000000000000(0000) GS:ffff88307e600000(0000) knlGS:0000000000000000
[  143.277028] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  143.277307] CR2: 0000000000000000 CR3: 000000000239d000 CR4: 00000000000006e0
[  143.297038] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  143.316856] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  143.317171] Process kworker/0:1 (pid: 0, threadinfo ffff88103e824000, task ffff88103e80a2b0)
[  143.337024] Stack:
[  143.337115]  ffff88103e824000 ffffffff82525380 ffff88103e825f28 ffffffff810391f0
[  143.356948]  ffff88103e825f18 0744bf4983a87a1b 0000000000000000 0000000000000000
[  143.357406]  ffff88103e825f48 ffffffff81c064f3 0000000000000000 1cb607dd8301e40b
[  143.377130] Call Trace:
[  143.377266]  [<ffffffff810391f0>] cpu_idle+0xae/0xcc
[  143.397110]  [<ffffffff81c064f3>] start_secondary+0xbd/0xbf
[  143.397386] Code: 00 00 48 89 d1 48 8d 83 38 e0 ff ff 0f 01 c8 0f ae f0 48 8b 83 38 e0 ff ff a8 08 75 10 e8 ec fd 06 00 31 c0 48 89 c1 fb 0f 01 c9 <eb> 06 e8 dc fd 06 00 fb 8b 05 0f 0a 4e 01 65 44 8b 24 25 30 c7 
[  143.437171] Call Trace:
[  143.437301]  [<ffffffff810391f0>] cpu_idle+0xae/0xcc
[  143.456669]  [<ffffffff81c064f3>] start_secondary+0xbd/0xbf
[  143.456963] NMI backtrace for cpu 21
[  143.476513] CPU 21 
[  143.476611] Modules linked in:
[  143.476785] 
[  143.476890] Pid: 0, comm: kworker/0:1 Not tainted 2.6.39-rc6-tip-yh-03030-gfb0b6a9 #985 Oracle Corporation  Sun Fire X4800/     
[  143.497586] RIP: 0010:[<ffffffff810409eb>]  [<ffffffff810409eb>] mwait_idle+0xef/0x169
[  143.516629] RSP: 0000:ffff88103e833ee8  EFLAGS: 00000246
[  143.516873] RAX: 0000000000000000 RBX: ffff88103e833fd8 RCX: 0000000000000000
[  143.536620] RDX: 0000000000000000 RSI: 0000000000000001 RDI: ffff88103e82a2b0
[  143.556431] RBP: ffff88103e833ef8 R08: 0000000000000000 R09: 0000000000000000
[  143.556789] R10: 0000000000000000 R11: ffff88103e833ed8 R12: 0000000000000015
[  143.576579] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
[  143.596325] FS:  0000000000000000(0000) GS:ffff88307e800000(0000) knlGS:0000000000000000
[  143.596690] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  143.616381] CR2: 0000000000000000 CR3: 000000000239d000 CR4: 00000000000006e0
[  143.636171] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  143.636502] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  143.656270] Process kworker/0:1 (pid: 0, threadinfo ffff88103e832000, task ffff88103e82a2b0)
[  143.676139] Stack:
[  143.676268]  ffff88103e832000 ffffffff82525380 ffff88103e833f28 ffffffff810391f0
[  143.676696]  ffff88103e833f18 9272018b68de3072 0000000000000000 0000000000000000
[  143.696488]  ffff88103e833f48 ffffffff81c064f3 0000000000000000 30c832b73c95166f
[  143.716202] Call Trace:
[  143.716330]  [<ffffffff810391f0>] cpu_idle+0xae/0xcc
[  143.716569]  [<ffffffff81c064f3>] start_secondary+0xbd/0xbf
[  143.736181] Code: 00 00 48 89 d1 48 8d 83 38 e0 ff ff 0f 01 c8 0f ae f0 48 8b 83 38 e0 ff ff a8 08 75 10 e8 ec fd 06 00 31 c0 48 89 c1 fb 0f 01 c9 <eb> 06 e8 dc fd 06 00 fb 8b 05 0f 0a 4e 01 65 44 8b 24 25 30 c7 
[  143.776036] Call Trace:
[  143.776163]  [<ffffffff810391f0>] cpu_idle+0xae/0xcc
[  143.776410]  [<ffffffff81c064f3>] start_secondary+0xbd/0xbf
[  143.795995] NMI backtrace for cpu 22
[  143.796190] CPU 22 
[  143.796290] Modules linked in:
[  143.815859] 
[  143.815964] Pid: 0, comm: kworker/0:1 Not tainted 2.6.39-rc6-tip-yh-03030-gfb0b6a9 #985 Oracle Corporation  Sun Fire X4800/     
[  143.835923] RIP: 0010:[<ffffffff810409eb>]  [<ffffffff810409eb>] mwait_idle+0xef/0x169
[  143.836331] RSP: 0000:ffff88103e849ee8  EFLAGS: 00000246
[  143.855953] RAX: 0000000000000000 RBX: ffff88103e849fd8 RCX: 0000000000000000
[  143.875743] RDX: 0000000000000000 RSI: 0000000000000001 RDI: ffff88103e83a2b0
[  143.876075] RBP: ffff88103e849ef8 R08: 0000000000000000 R09: 0000000000000000
[  143.895826] R10: 0000000000000000 R11: ffff88103e849ed8 R12: 0000000000000016
[  143.915639] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
[  143.915990] FS:  0000000000000000(0000) GS:ffff88307ea00000(0000) knlGS:0000000000000000
[  143.935797] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  143.936056] CR2: 0000000000000000 CR3: 000000000239d000 CR4: 00000000000006e0
[  143.955929] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  143.975745] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  143.976088] Process kworker/0:1 (pid: 0, threadinfo ffff88103e848000, task ffff88103e83a2b0)
[  143.996164] Stack:
[  143.996279]  ffff88103e848000 ffffffff82525380 ffff88103e849f28 ffffffff810391f0
[  144.015921]  ffff88103e849f18 55c4bc74ee10c3a9 0000000000000000 0000000000000000
[  144.035620]  ffff88103e849f48 ffffffff81c064f3 0000000000000000 c6af0e0725d8e279
[  144.036085] Call Trace:
[  144.055485]  [<ffffffff810391f0>] cpu_idle+0xae/0xcc
[  144.055735]  [<ffffffff81c064f3>] start_secondary+0xbd/0xbf
[  144.075270] Code: 00 00 48 89 d1 48 8d 83 38 e0 ff ff 0f 01 c8 0f ae f0 48 8b 83 38 e0 ff ff a8 08 75 10 e8 ec fd 06 00 31 c0 48 89 c1 fb 0f 01 c9 <eb> 06 e8 dc fd 06 00 fb 8b 05 0f 0a 4e 01 65 44 8b 24 25 30 c7 
[  144.096011] Call Trace:
[  144.096144]  [<ffffffff810391f0>] cpu_idle+0xae/0xcc
[  144.115394]  [<ffffffff81c064f3>] start_secondary+0xbd/0xbf
[  144.115679] NMI backtrace for cpu 23
[  144.135256] CPU 23 
[  144.135358] Modules linked in:
[  144.135545] 
[  144.135637] Pid: 0, comm: kworker/0:1 Not tainted 2.6.39-rc6-tip-yh-03030-gfb0b6a9 #985 Oracle Corporation  Sun Fire X4800/     
[  144.156262] RIP: 0010:[<ffffffff810409eb>]  [<ffffffff810409eb>] mwait_idle+0xef/0x169
[  144.175570] RSP: 0000:ffff88103e859ee8  EFLAGS: 00000246
[  144.195054] RAX: 0000000000000000 RBX: ffff88103e859fd8 RCX: 0000000000000000
[  144.195389] RDX: 0000000000000000 RSI: 0000000000000001 RDI: ffff88103e8522b0
[  144.215178] RBP: ffff88103e859ef8 R08: 0000000000000000 R09: 0000000000000000
[  144.234967] R10: 0000000000000000 R11: ffff88103e859ed8 R12: 0000000000000017
[  144.235325] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
[  144.255061] FS:  0000000000000000(0000) GS:ffff88307ec00000(0000) knlGS:0000000000000000
[  144.274868] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  144.275157] CR2: 0000000000000000 CR3: 000000000239d000 CR4: 00000000000006e0
[  144.295041] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  144.295381] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  144.315016] Process kworker/0:1 (pid: 0, threadinfo ffff88103e858000, task ffff88103e8522b0)
[  144.334863] Stack:
[  144.334969]  ffff88103e858000 ffffffff82525380 ffff88103e859f28 ffffffff810391f0
[  144.354806]  ffff88103e859f18 908465f609e5cf69 0000000000000000 0000000000000000
[  144.355285]  ffff88103e859f48 ffffffff81c064f3 0000000000000000 901034fa9e9275cf
[  144.374955] Call Trace:
[  144.375070]  [<ffffffff810391f0>] cpu_idle+0xae/0xcc
[  144.394687]  [<ffffffff81c064f3>] start_secondary+0xbd/0xbf
[  144.394970] Code: 00 00 48 89 d1 48 8d 83 38 e0 ff ff 0f 01 c8 0f ae f0 48 8b 83 38 e0 ff ff a8 08 75 10 e8 ec fd 06 00 31 c0 48 89 c1 fb 0f 01 c9 <eb> 06 e8 dc fd 06 00 fb 8b 05 0f 0a 4e 01 65 44 8b 24 25 30 c7 
[  144.434889] Call Trace:
[  144.435031]  [<ffffffff810391f0>] cpu_idle+0xae/0xcc
[  144.435292]  [<ffffffff81c064f3>] start_secondary+0xbd/0xbf
[  144.454765] NMI backtrace for cpu 24
[  144.454967] CPU 24 
[  144.455060] Modules linked in:
[  144.474733] 
[  144.474821] Pid: 0, comm: kworker/0:1 Not tainted 2.6.39-rc6-tip-yh-03030-gfb0b6a9 #985 Oracle Corporation  Sun Fire X4800/     
[  144.494676] RIP: 0010:[<ffffffff810409eb>]  [<ffffffff810409eb>] mwait_idle+0xef/0x169
[  144.514460] RSP: 0000:ffff88103e85fee8  EFLAGS: 00000246
[  144.514725] RAX: 0000000000000000 RBX: ffff88103e85ffd8 RCX: 0000000000000000
[  144.534483] RDX: 0000000000000000 RSI: 0000000000000001 RDI: ffff88103e864560
[  144.534810] RBP: ffff88103e85fef8 R08: 0000000000000000 R09: 0000000000000000
[  144.554590] R10: 0000000000000000 R11: ffff88103e85fed8 R12: 0000000000000018
[  144.574373] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
[  144.574733] FS:  0000000000000000(0000) GS:ffff88407de00000(0000) knlGS:0000000000000000
[  144.594545] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  144.614252] CR2: 0000000000000000 CR3: 000000000239d000 CR4: 00000000000006e0
[  144.614576] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  144.634345] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  144.654133] Process kworker/0:1 (pid: 0, threadinfo ffff88103e85e000, task ffff88103e864560)
[  144.654530] Stack:
[  144.674053]  ffff88103e85e000 ffffffff82525380 ffff88103e85ff28 ffffffff810391f0
[  144.674514]  ffff88103e85ff18 39cac7e094841c82 0000000000000000 0000000000000000
[  144.694241]  ffff88103e85ff48 ffffffff81c064f3 0000000000000000 2dcf15bc6b5f3387
[  144.714026] Call Trace:
[  144.714173]  [<ffffffff810391f0>] cpu_idle+0xae/0xcc
[  144.714426]  [<ffffffff81c064f3>] start_secondary+0xbd/0xbf
[  144.734049] Code: 00 00 48 89 d1 48 8d 83 38 e0 ff ff 0f 01 c8 0f ae f0 48 8b 83 38 e0 ff ff a8 08 75 10 e8 ec fd 06 00 31 c0 48 89 c1 fb 0f 01 c9 <eb> 06 e8 dc fd 06 00 fb 8b 05 0f 0a 4e 01 65 44 8b 24 25 30 c7 
[  144.754866] Call Trace:
[  144.773919]  [<ffffffff810391f0>] cpu_idle+0xae/0xcc
[  144.774151]  [<ffffffff81c064f3>] start_secondary+0xbd/0xbf
[  144.795051] NMI backtrace for cpu 25
[  144.795234] CPU 25 
[  144.795340] Modules linked in:
[  144.795511] 
[  144.813758] Pid: 0, comm: kworker/0:1 Not tainted 2.6.39-rc6-tip-yh-03030-gfb0b6a9 #985 Oracle Corporation  Sun Fire X4800/     
[  144.833771] RIP: 0010:[<ffffffff810409eb>]  [<ffffffff810409eb>] mwait_idle+0xef/0x169
[  144.834146] RSP: 0000:ffff88103e875ee8  EFLAGS: 00000246
[  144.853849] RAX: 0000000000000000 RBX: ffff88103e875fd8 RCX: 0000000000000000
[  144.854177] RDX: 0000000000000000 RSI: 0000000000000001 RDI: ffff88103e884560
[  144.873888] RBP: ffff88103e875ef8 R08: 0000000000000000 R09: 0000000000000000
[  144.893689] R10: 0000000000000000 R11: ffff88103e875ed8 R12: 0000000000000019
[  144.894027] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
[  144.913789] FS:  0000000000000000(0000) GS:ffff88407e000000(0000) knlGS:0000000000000000
[  144.933631] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  144.933898] CR2: 0000000000000000 CR3: 000000000239d000 CR4: 00000000000006e0
[  144.953718] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  144.973714] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  144.974058] Process kworker/0:1 (pid: 0, threadinfo ffff88103e874000, task ffff88103e884560)
[  144.993800] Stack:
[  144.993892]  ffff88103e874000 ffffffff82525380 ffff88103e875f28 ffffffff810391f0
[  145.013686]  ffff88103e875f18 0a3cfc4bd45819c1 0000000000000000 0000000000000000
[  145.014135]  ffff88103e875f48 ffffffff81c064f3 0000000000000000 6e7bcc21ed33ee47
[  145.033735] Call Trace:
[  145.033868]  [<ffffffff810391f0>] cpu_idle+0xae/0xcc
[  145.053445]  [<ffffffff81c064f3>] start_secondary+0xbd/0xbf
[  145.053733] Code: 00 00 48 89 d1 48 8d 83 38 e0 ff ff 0f 01 c8 0f ae f0 48 8b 83 38 e0 ff ff a8 08 75 10 e8 ec fd 06 00 31 c0 48 89 c1 fb 0f 01 c9 <eb> 06 e8 dc fd 06 00 fb 8b 05 0f 0a 4e 01 65 44 8b 24 25 30 c7 
[  145.093757] Call Trace:
[  145.093889]  [<ffffffff810391f0>] cpu_idle+0xae/0xcc
[  145.113231]  [<ffffffff81c064f3>] start_secondary+0xbd/0xbf
[  145.113524] NMI backtrace for cpu 26
[  145.113697] CPU 26 
[  145.133220] Modules linked in:
[  145.133387] 
[  145.133489] Pid: 0, comm: kworker/0:1 Not tainted 2.6.39-rc6-tip-yh-03030-gfb0b6a9 #985 Oracle Corporation  Sun Fire X4800/     
[  145.153444] RIP: 0010:[<ffffffff810409eb>]  [<ffffffff810409eb>] mwait_idle+0xef/0x169
[  145.173225] RSP: 0000:ffff88103e893ee8  EFLAGS: 00000246
[  145.173498] RAX: 0000000000000000 RBX: ffff88103e893fd8 RCX: 0000000000000000
[  145.193256] RDX: 0000000000000000 RSI: 0000000000000001 RDI: ffff88103e88c560
[  145.213024] RBP: ffff88103e893ef8 R08: 0000000000000000 R09: 0000000000000000
[  145.213354] R10: 0000000000000000 R11: ffff88103e893ed8 R12: 000000000000001a
[  145.233866] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
[  145.252944] FS:  0000000000000000(0000) GS:ffff88407e200000(0000) knlGS:0000000000000000
[  145.253340] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  145.273003] CR2: 0000000000000000 CR3: 000000000239d000 CR4: 00000000000006e0
[  145.273344] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  145.293091] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  145.312900] Process kworker/0:1 (pid: 0, threadinfo ffff88103e892000, task ffff88103e88c560)
[  145.332710] Stack:
[  145.332810]  ffff88103e892000 ffffffff82525380 ffff88103e893f28 ffffffff810391f0
[  145.333249]  ffff88103e893f18 66000d941fa900df 0000000000000000 0000000000000000
[  145.353045]  ffff88103e893f48 ffffffff81c064f3 0000000000000000 fcf39f4b7ffe7411
[  145.372789] Call Trace:
[  145.372924]  [<ffffffff810391f0>] cpu_idle+0xae/0xcc
[  145.373167]  [<ffffffff81c064f3>] start_secondary+0xbd/0xbf
[  145.413174] Code: 00 00 48 89 d1 48 8d 83 38 e0 ff ff 0f 01 c8 0f ae f0 48 8b 83 38 e0 ff ff a8 08 75 10 e8 ec fd 06 00 31 c0 48 89 c1 fb 0f 01 c9 <eb> 06 e8 dc fd 06 00 fb 8b 05 0f 0a 4e 01 65 44 8b 24 25 30 c7 
[  145.453313] Call Trace:
[  145.453445]  [<ffffffff810391f0>] cpu_idle+0xae/0xcc
[  145.453693]  [<ffffffff81c064f3>] start_secondary+0xbd/0xbf
[  145.472568] NMI backtrace for cpu 27
[  145.472745] CPU 27 
[  145.472848] Modules linked in:
[  145.492451] 
[  145.492543] Pid: 0, comm: kworker/0:1 Not tainted 2.6.39-rc6-tip-yh-03030-gfb0b6a9 #985 Oracle Corporation  Sun Fire X4800/     
[  145.512476] RIP: 0010:[<ffffffff810409eb>]  [<ffffffff810409eb>] mwait_idle+0xef/0x169
[  145.512900] RSP: 0000:ffff88103e8a9ee8  EFLAGS: 00000246
[  145.532517] RAX: 0000000000000000 RBX: ffff88103e8a9fd8 RCX: 0000000000000000
[  145.552323] RDX: 0000000000000000 RSI: 0000000000000001 RDI: ffff88103e8a4560
[  145.552650] RBP: ffff88103e8a9ef8 R08: 0000000000000000 R09: 0000000000000000
[  145.572405] R10: 0000000000000000 R11: ffff88103e8a9ed8 R12: 000000000000001b
[  145.592190] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
[  145.592531] FS:  0000000000000000(0000) GS:ffff88407e400000(0000) knlGS:0000000000000000
[  145.612347] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  145.612595] CR2: 0000000000000000 CR3: 000000000239d000 CR4: 00000000000006e0
[  145.632371] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  145.652160] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  145.652497] Process kworker/0:1 (pid: 0, threadinfo ffff88103e8a8000, task ffff88103e8a4560)
[  145.672331] Stack:
[  145.672432]  ffff88103e8a8000 ffffffff82525380 ffff88103e8a9f28 ffffffff810391f0
[  145.692272]  ffff88103e8a9f18 df03c4b0aef93378 0000000000000000 0000000000000000
[  145.712012]  ffff88103e8a9f48 ffffffff81c064f3 0000000000000000 6f15585bec259797
[  145.712423] Call Trace:
[  145.731931]  [<ffffffff810391f0>] cpu_idle+0xae/0xcc
[  145.732172]  [<ffffffff81c064f3>] start_secondary+0xbd/0xbf
[  145.732428] Code: 00 00 48 89 d1 48 8d 83 38 e0 ff ff 0f 01 c8 0f ae f0 48 8b 83 38 e0 ff ff a8 08 75 10 e8 ec fd 06 00 31 c0 48 89 c1 fb 0f 01 c9 <eb> 06 e8 dc fd 06 00 fb 8b 05 0f 0a 4e 01 65 44 8b 24 25 30 c7 
[  145.772555] Call Trace:
[  145.772700]  [<ffffffff810391f0>] cpu_idle+0xae/0xcc
[  145.791961]  [<ffffffff81c064f3>] start_secondary+0xbd/0xbf
[  145.792260] NMI backtrace for cpu 28
[  145.811820] CPU 28 
[  145.811918] Modules linked in:
[  145.812103] 
[  145.812191] Pid: 0, comm: kworker/0:1 Not tainted 2.6.39-rc6-tip-yh-03030-gfb0b6a9 #985 Oracle Corporation  Sun Fire X4800/     
[  145.832145] RIP: 0010:[<ffffffff810409eb>]  [<ffffffff810409eb>] mwait_idle+0xef/0x169
[  145.851958] RSP: 0000:ffff88103e8dfee8  EFLAGS: 00000246
[  145.871617] RAX: 0000000000000000 RBX: ffff88103e8dffd8 RCX: 0000000000000000
[  145.871942] RDX: 0000000000000000 RSI: 0000000000000001 RDI: ffff88103e8bc560
[  145.891718] RBP: ffff88103e8dfef8 R08: 0000000000000000 R09: 0000000000000000
[  145.892044] R10: 0000000000000000 R11: ffff88103e8dfed8 R12: 000000000000001c
[  145.911835] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
[  145.931622] FS:  0000000000000000(0000) GS:ffff88407e600000(0000) knlGS:0000000000000000
[  145.931976] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  145.951702] CR2: 0000000000000000 CR3: 000000000239d000 CR4: 00000000000006e0
[  145.971542] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  145.971856] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  145.991730] Process kworker/0:1 (pid: 0, threadinfo ffff88103e8de000, task ffff88103e8bc560)
[  146.011809] Stack:
[  146.011900]  ffff88103e8de000 ffffffff82525380 ffff88103e8dff28 ffffffff810391f0
[  146.031465]  ffff88103e8dff18 413f0ec1ba26191e 0000000000000000 0000000000000000
[  146.031947]  ffff88103e8dff48 ffffffff81c064f3 0000000000000000 a5eb12480065c24e
[  146.051796] Call Trace:
[  146.051942]  [<ffffffff810391f0>] cpu_idle+0xae/0xcc
[  146.071240]  [<ffffffff81c064f3>] start_secondary+0xbd/0xbf
[  146.071509] Code: 00 00 48 89 d1 48 8d 83 38 e0 ff ff 0f 01 c8 0f ae f0 48 8b 83 38 e0 ff ff a8 08 75 10 e8 ec fd 06 00 31 c0 48 89 c1 fb 0f 01 c9 <eb> 06 e8 dc fd 06 00 fb 8b 05 0f 0a 4e 01 65 44 8b 24 25 30 c7 
[  146.111423] Call Trace:
[  146.111559]  [<ffffffff810391f0>] cpu_idle+0xae/0xcc
[  146.111807]  [<ffffffff81c064f3>] start_secondary+0xbd/0xbf
[  146.131412] NMI backtrace for cpu 29
[  146.131602] CPU 29 
[  146.131702] Modules linked in:
[  146.151356] 
[  146.151458] Pid: 0, comm: kworker/0:1 Not tainted 2.6.39-rc6-tip-yh-03030-gfb0b6a9 #985 Oracle Corporation  Sun Fire X4800/     
[  146.171256] RIP: 0010:[<ffffffff810409eb>]  [<ffffffff810409eb>] mwait_idle+0xef/0x169
[  146.191027] RSP: 0000:ffff88103e8e7ee8  EFLAGS: 00000246
[  146.191302] RAX: 0000000000000000 RBX: ffff88103e8e7fd8 RCX: 0000000000000000
[  146.211054] RDX: 0000000000000000 RSI: 0000000000000001 RDI: ffff88103e8ec560
[  146.211390] RBP: ffff88103e8e7ef8 R08: 0000000000000000 R09: 0000000000000000
[  146.231169] R10: 0000000000000000 R11: ffff88103e8e7ed8 R12: 000000000000001d
[  146.250948] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
[  146.251264] FS:  0000000000000000(0000) GS:ffff88407e800000(0000) knlGS:0000000000000000
[  146.271080] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  146.290841] CR2: 0000000000000000 CR3: 000000000239d000 CR4: 00000000000006e0
[  146.291181] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  146.311243] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  146.330731] Process kworker/0:1 (pid: 0, threadinfo ffff88103e8e6000, task ffff88103e8ec560)
[  146.331132] Stack:
[  146.331248]  ffff88103e8e6000 ffffffff82525380 ffff88103e8e7f28 ffffffff810391f0
[  146.351311]  ffff88103e8e7f18 d32ef0dd85d433ad 0000000000000000 0000000000000000
[  146.371016]  ffff88103e8e7f48 ffffffff81c064f3 0000000000000000 a92aa153b95503a5
[  146.371414] Call Trace:
[  146.391290]  [<ffffffff810391f0>] cpu_idle+0xae/0xcc
[  146.391561]  [<ffffffff81c064f3>] start_secondary+0xbd/0xbf
[  146.410586] Code: 00 00 48 89 d1 48 8d 83 38 e0 ff ff 0f 01 c8 0f ae f0 48 8b 83 38 e0 ff ff a8 08 75 10 e8 ec fd 06 00 31 c0 48 89 c1 fb 0f 01 c9 <eb> 06 e8 dc fd 06 00 fb 8b 05 0f 0a 4e 01 65 44 8b 24 25 30 c7 
[  146.431456] Call Trace:
[  146.450599]  [<ffffffff810391f0>] cpu_idle+0xae/0xcc
[  146.450836]  [<ffffffff81c064f3>] start_secondary+0xbd/0xbf
[  146.470418] NMI backtrace for cpu 30
[  146.470593] CPU 30 
[  146.470693] Modules linked in:
[  146.470901] 
[  146.470976] Pid: 0, comm: kworker/0:1 Not tainted 2.6.39-rc6-tip-yh-03030-gfb0b6a9 #985 Oracle Corporation  Sun Fire X4800/     
[  146.510310] RIP: 0010:[<ffffffff810409eb>]  [<ffffffff810409eb>] mwait_idle+0xef/0x169
[  146.510726] RSP: 0000:ffff88103e8fdee8  EFLAGS: 00000246
[  146.530366] RAX: 0000000000000000 RBX: ffff88103e8fdfd8 RCX: 0000000000000000
[  146.530725] RDX: 0000000000000000 RSI: 0000000000000001 RDI: ffff88103e904560
[  146.550485] RBP: ffff88103e8fdef8 R08: 0000000000000000 R09: 0000000000000000
[  146.570257] R10: 0000000000000000 R11: ffff88103e8fded8 R12: 000000000000001e
[  146.570570] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
[  146.590387] FS:  0000000000000000(0000) GS:ffff88407ea00000(0000) knlGS:0000000000000000
[  146.610177] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  146.610447] CR2: 0000000000000000 CR3: 000000000239d000 CR4: 00000000000006e0
[  146.630240] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  146.630576] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  146.650412] Process kworker/0:1 (pid: 0, threadinfo ffff88103e8fc000, task ffff88103e904560)
[  146.670189] Stack:
[  146.670287]  ffff88103e8fc000 ffffffff82525380 ffff88103e8fdf28 ffffffff810391f0
[  146.690115]  ffff88103e8fdf18 913051ccc440aefd 0000000000000000 0000000000000000
[  146.690513]  ffff88103e8fdf48 ffffffff81c064f3 0000000000000000 621a96059901cbc3
[  146.710278] Call Trace:
[  146.710398]  [<ffffffff810391f0>] cpu_idle+0xae/0xcc
[  146.730006]  [<ffffffff81c064f3>] start_secondary+0xbd/0xbf
[  146.730287] Code: 00 00 48 89 d1 48 8d 83 38 e0 ff ff 0f 01 c8 0f ae f0 48 8b 83 38 e0 ff ff a8 08 75 10 e8 ec fd 06 00 31 c0 48 89 c1 fb 0f 01 c9 <eb> 06 e8 dc fd 06 00 fb 8b 05 0f 0a 4e 01 65 44 8b 24 25 30 c7 
[  146.770294] Call Trace:
[  146.770412]  [<ffffffff810391f0>] cpu_idle+0xae/0xcc
[  146.789833]  [<ffffffff81c064f3>] start_secondary+0xbd/0xbf
[  146.790121] NMI backtrace for cpu 32
[  146.790346] CPU 32 
[  146.809763] Modules linked in:
[  146.809964] 
[  146.810054] Pid: 0, comm: kworker/0:1 Not tainted 2.6.39-rc6-tip-yh-03030-gfb0b6a9 #985 Oracle Corporation  Sun Fire X4800/     
[  146.830045] RIP: 0010:[<ffffffff810409eb>]  [<ffffffff810409eb>] mwait_idle+0xef/0x169
[  146.849776] RSP: 0000:ffff88103e933ee8  EFLAGS: 00000246
[  146.850020] RAX: 0000000000000000 RBX: ffff88103e933fd8 RCX: 0000000000000000
[  146.869805] RDX: 0000000000000000 RSI: 0000000000000001 RDI: ffff88103e92c560
[  146.889563] RBP: ffff88103e933ef8 R08: 0000000000000000 R09: 0000000000000000
[  146.889911] R10: 0000000000000000 R11: ffff88103e933ed8 R12: 0000000000000020
[  146.909684] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
[  146.929468] FS:  0000000000000000(0000) GS:ffff88507de00000(0000) knlGS:0000000000000000
[  146.929838] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  146.949546] CR2: 0000000000000000 CR3: 000000000239d000 CR4: 00000000000006e0
[  146.949896] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  146.971294] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  146.989462] Process kworker/0:1 (pid: 0, threadinfo ffff88103e932000, task ffff88103e92c560)
[  146.989840] Stack:
[  147.009427]  ffff88103e932000 ffffffff82525380 ffff88103e933f28 ffffffff810391f0
[  147.009877]  ffff88103e933f18 cc93d566d9aab073 0000000000000000 0000000000000000
[  147.029800]  ffff88103e933f48 ffffffff81c064f3 0000000000000000 0892a3361bfa89c4
[  147.049752] Call Trace:
[  147.049901]  [<ffffffff810391f0>] cpu_idle+0xae/0xcc
[  147.050162]  [<ffffffff81c064f3>] start_secondary+0xbd/0xbf
[  147.069459] Code: 00 00 48 89 d1 48 8d 83 38 e0 ff ff 0f 01 c8 0f ae f0 48 8b 83 38 e0 ff ff a8 08 75 10 e8 ec fd 06 00 31 c0 48 89 c1 fb 0f 01 c9 <eb> 06 e8 dc fd 06 00 fb 8b 05 0f 0a 4e 01 65 44 8b 24 25 30 c7 
[  147.109150] Call Trace:
[  147.109282]  [<ffffffff810391f0>] cpu_idle+0xae/0xcc
[  147.109531]  [<ffffffff81c064f3>] start_secondary+0xbd/0xbf
[  147.129165] NMI backtrace for cpu 33
[  147.129355] CPU 33 
[  147.129455] Modules linked in:
[  147.149006] 
[  147.149103] Pid: 0, comm: kworker/0:1 Not tainted 2.6.39-rc6-tip-yh-03030-gfb0b6a9 #985 Oracle Corporation  Sun Fire X4800/     
[  147.169122] RIP: 0010:[<ffffffff810409eb>]  [<ffffffff810409eb>] mwait_idle+0xef/0x169
[  147.169515] RSP: 0000:ffff88103e941ee8  EFLAGS: 00000246
[  147.189157] RAX: 0000000000000000 RBX: ffff88103e941fd8 RCX: 0000000000000000
[  147.208902] RDX: 0000000000000000 RSI: 0000000000000001 RDI: ffff88103e93c560
[  147.209238] RBP: ffff88103e941ef8 R08: 0000000000000000 R09: 0000000000000000
[  147.229248] R10: 0000000000000000 R11: ffff88103e941ed8 R12: 0000000000000021
[  147.229602] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
[  147.249097] FS:  0000000000000000(0000) GS:ffff88507e000000(0000) knlGS:0000000000000000
[  147.268935] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  147.269201] CR2: 0000000000000000 CR3: 000000000239d000 CR4: 00000000000006e0
[  147.289003] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  147.308778] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  147.309104] Process kworker/0:1 (pid: 0, threadinfo ffff88103e940000, task ffff88103e93c560)
[  147.328926] Stack:
[  147.329031]  ffff88103e940000 ffffffff82525380 ffff88103e941f28 ffffffff810391f0
[  147.348891]  ffff88103e941f18 ab385c0f8fb97b87 0000000000000000 0000000000000000
[  147.368624]  ffff88103e941f48 ffffffff81c064f3 0000000000000000 bbbf54853ffbc8f6
[  147.369042] Call Trace:
[  147.369173]  [<ffffffff810391f0>] cpu_idle+0xae/0xcc
[  147.390147]  [<ffffffff81c064f3>] start_secondary+0xbd/0xbf
[  147.390442] Code: 00 00 48 89 d1 48 8d 83 38 e0 ff ff 0f 01 c8 0f ae f0 48 8b 83 38 e0 ff ff a8 08 75 10 e8 ec fd 06 00 31 c0 48 89 c1 fb 0f 01 c9 <eb> 06 e8 dc fd 06 00 fb 8b 05 0f 0a 4e 01 65 44 8b 24 25 30 c7 
[  147.429144] Call Trace:
[  147.429258]  [<ffffffff810391f0>] cpu_idle+0xae/0xcc
[  147.448575]  [<ffffffff81c064f3>] start_secondary+0xbd/0xbf
[  147.448889] NMI backtrace for cpu 34
[  147.468539] CPU 34 
[  147.468637] Modules linked in:
[  147.468842] 
[  147.468918] Pid: 0, comm: kworker/0:1 Not tainted 2.6.39-rc6-tip-yh-03030-gfb0b6a9 #985 Oracle Corporation  Sun Fire X4800/     
[  147.488774] RIP: 0010:[<ffffffff810409eb>]  [<ffffffff810409eb>] mwait_idle+0xef/0x169
[  147.508554] RSP: 0000:ffff88103e947ee8  EFLAGS: 00000246
[  147.508813] RAX: 0000000000000000 RBX: ffff88103e947fd8 RCX: 0000000000000000
[  147.528534] RDX: 0000000000000000 RSI: 0000000000000001 RDI: ffff88103e954560
[  147.548340] RBP: ffff88103e947ef8 R08: 0000000000000000 R09: 0000000000000000
[  147.548688] R10: 0000000000000000 R11: ffff88103e947ed8 R12: 0000000000000022
[  147.568442] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
[  147.593543] FS:  0000000000000000(0000) GS:ffff88507e200000(0000) knlGS:0000000000000000
[  147.593938] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  147.608329] CR2: 0000000000000000 CR3: 000000000239d000 CR4: 00000000000006e0
[  147.628094] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  147.628428] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  147.648223] Process kworker/0:1 (pid: 0, threadinfo ffff88103e946000, task ffff88103e954560)
[  147.668048] Stack:
[  147.668146]  ffff88103e946000 ffffffff82525380 ffff88103e947f28 ffffffff810391f0
[  147.687912]  ffff88103e947f18 c3e1387ef72955fb 0000000000000000 0000000000000000
[  147.688367]  ffff88103e947f48 ffffffff81c064f3 0000000000000000 3b02cb3a56ca3450
[  147.708128] Call Trace:
[  147.708264]  [<ffffffff810391f0>] cpu_idle+0xae/0xcc
[  147.727833]  [<ffffffff81c064f3>] start_secondary+0xbd/0xbf
[  147.728107] Code: 00 00 48 89 d1 48 8d 83 38 e0 ff ff 0f 01 c8 0f ae f0 48 8b 83 38 e0 ff ff a8 08 75 10 e8 ec fd 06 00 31 c0 48 89 c1 fb 0f 01 c9 <eb> 06 e8 dc fd 06 00 fb 8b 05 0f 0a 4e 01 65 44 8b 24 25 30 c7 
[  147.768011] Call Trace:
[  147.768133]  [<ffffffff810391f0>] cpu_idle+0xae/0xcc
[  147.768364]  [<ffffffff81c064f3>] start_secondary+0xbd/0xbf
[  147.787920] NMI backtrace for cpu 35
[  147.788127] CPU 35 
[  147.788220] Modules linked in:
[  147.807761] 
[  147.807868] Pid: 0, comm: kworker/0:1 Not tainted 2.6.39-rc6-tip-yh-03030-gfb0b6a9 #985 Oracle Corporation  Sun Fire X4800/     
[  147.827846] RIP: 0010:[<ffffffff810409eb>]  [<ffffffff810409eb>] mwait_idle+0xef/0x169
[  147.847643] RSP: 0000:ffff88103e95fee8  EFLAGS: 00000246
[  147.847920] RAX: 0000000000000000 RBX: ffff88103e95ffd8 RCX: 0000000000000000
[  147.867634] RDX: 0000000000000000 RSI: 0000000000000001 RDI: ffff88103e964560
[  147.868005] RBP: ffff88103e95fef8 R08: 0000000000000000 R09: 0000000000000000
[  147.887786] R10: 0000000000000000 R11: ffff88103e95fed8 R12: 0000000000000023
[  147.907528] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
[  147.907897] FS:  0000000000000000(0000) GS:ffff88507e400000(0000) knlGS:0000000000000000
[  147.927674] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  147.947412] CR2: 0000000000000000 CR3: 000000000239d000 CR4: 00000000000006e0
[  147.947790] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  147.967603] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  147.967925] Process kworker/0:1 (pid: 0, threadinfo ffff88103e95e000, task ffff88103e964560)
[  147.987807] Stack:
[  147.987908]  ffff88103e95e000 ffffffff82525380 ffff88103e95ff28 ffffffff810391f0
[  148.008237]  ffff88103e95ff18 b04a6bcc5d16a033 0000000000000000 0000000000000000
[  148.028386]  ffff88103e95ff48 ffffffff81c064f3 0000000000000000 86562f64e45d9875
[  148.028826] Call Trace:
[  148.047569]  [<ffffffff810391f0>] cpu_idle+0xae/0xcc
[  148.047852]  [<ffffffff81c064f3>] start_secondary+0xbd/0xbf
[  148.067261] Code: 00 00 48 89 d1 48 8d 83 38 e0 ff ff 0f 01 c8 0f ae f0 48 8b 83 38 e0 ff ff a8 08 75 10 e8 ec fd 06 00 31 c0 48 89 c1 fb 0f 01 c9 <eb> 06 e8 dc fd 06 00 fb 8b 05 0f 0a 4e 01 65 44 8b 24 25 30 c7 
[  148.088104] Call Trace:
[  148.107087]  [<ffffffff810391f0>] cpu_idle+0xae/0xcc
[  148.107324]  [<ffffffff81c064f3>] start_secondary+0xbd/0xbf
[  148.107595] NMI backtrace for cpu 36
[  148.127204] CPU 36 
[  148.127307] Modules linked in:
[  148.127492] 
[  148.127592] Pid: 0, comm: kworker/0:1 Not tainted 2.6.39-rc6-tip-yh-03030-gfb0b6a9 #985 Oracle Corporation  Sun Fire X4800/     
[  148.147493] RIP: 0010:[<ffffffff810409eb>]  [<ffffffff810409eb>] mwait_idle+0xef/0x169
[  148.167294] RSP: 0000:ffff88103e96dee8  EFLAGS: 00000246
[  148.187190] RAX: 0000000000000000 RBX: ffff88103e96dfd8 RCX: 0000000000000000
[  148.187541] RDX: 0000000000000000 RSI: 0000000000000001 RDI: ffff88103e974560
[  148.207048] RBP: ffff88103e96def8 R08: 0000000000000000 R09: 0000000000000000
[  148.226862] R10: 0000000000000000 R11: ffff88103e96ded8 R12: 0000000000000024
[  148.227187] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
[  148.246985] FS:  0000000000000000(0000) GS:ffff88507e600000(0000) knlGS:0000000000000000
[  148.266789] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  148.267065] CR2: 0000000000000000 CR3: 000000000239d000 CR4: 00000000000006e0
[  148.286836] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  148.287182] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  148.306949] Process kworker/0:1 (pid: 0, threadinfo ffff88103e96c000, task ffff88103e974560)
[  148.326800] Stack:
[  148.326914]  ffff88103e96c000 ffffffff82525380 ffff88103e96df28 ffffffff810391f0
[  148.346724]  ffff88103e96df18 acf4d12aa3bac806 0000000000000000 0000000000000000
[  148.347157]  ffff88103e96df48 ffffffff81c064f3 0000000000000000 f751ed781526a858
[  148.366914] Call Trace:
[  148.367029]  [<ffffffff810391f0>] cpu_idle+0xae/0xcc
[  148.386641]  [<ffffffff81c064f3>] start_secondary+0xbd/0xbf
[  148.386909] Code: 00 00 48 89 d1 48 8d 83 38 e0 ff ff 0f 01 c8 0f ae f0 48 8b 83 38 e0 ff ff a8 08 75 10 e8 ec fd 06 00 31 c0 48 89 c1 fb 0f 01 c9 <eb> 06 e8 dc fd 06 00 fb 8b 05 0f 0a 4e 01 65 44 8b 24 25 30 c7 
[  148.427152] Call Trace:
[  148.427274]  [<ffffffff810391f0>] cpu_idle+0xae/0xcc
[  148.446410]  [<ffffffff81c064f3>] start_secondary+0xbd/0xbf
[  148.446654] NMI backtrace for cpu 37
[  148.446833] CPU 37 
[  148.466376] Modules linked in:
[  148.466589] 
[  148.466691] Pid: 0, comm: kworker/0:1 Not tainted 2.6.39-rc6-tip-yh-03030-gfb0b6a9 #985 Oracle Corporation  Sun Fire X4800/     
[  148.486626] RIP: 0010:[<ffffffff810409eb>]  [<ffffffff810409eb>] mwait_idle+0xef/0x169
[  148.506390] RSP: 0000:ffff88103e993ee8  EFLAGS: 00000246
[  148.506644] RAX: 0000000000000000 RBX: ffff88103e993fd8 RCX: 0000000000000000
[  148.526396] RDX: 0000000000000000 RSI: 0000000000000001 RDI: ffff88103e98c560
[  148.546191] RBP: ffff88103e993ef8 R08: 0000000000000000 R09: 0000000000000000
[  148.546529] R10: 0000000000000000 R11: ffff88103e993ed8 R12: 0000000000000025
[  148.566297] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
[  148.566608] FS:  0000000000000000(0000) GS:ffff88507e800000(0000) knlGS:0000000000000000
[  148.586422] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  148.606177] CR2: 0000000000000000 CR3: 000000000239d000 CR4: 00000000000006e0
[  148.606523] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  148.626281] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  148.646040] Process kworker/0:1 (pid: 0, threadinfo ffff88103e992000, task ffff88103e98c560)
[  148.646449] Stack:
[  148.670787]  ffff88103e992000 ffffffff82525380 ffff88103e993f28 ffffffff810391f0
[  148.671236]  ffff88103e993f18 fb85c5af419ff264 0000000000000000 0000000000000000
[  148.686415]  ffff88103e993f48 ffffffff81c064f3 0000000000000000 9331422f9e8ccc3d
[  148.705894] Call Trace:
[  148.706023]  [<ffffffff810391f0>] cpu_idle+0xae/0xcc
[  148.706270]  [<ffffffff81c064f3>] start_secondary+0xbd/0xbf
[  148.725959] Code: 00 00 48 89 d1 48 8d 83 38 e0 ff ff 0f 01 c8 0f ae f0 48 8b 83 38 e0 ff ff a8 08 75 10 e8 ec fd 06 00 31 c0 48 89 c1 fb 0f 01 c9 <eb> 06 e8 dc fd 06 00 fb 8b 05 0f 0a 4e 01 65 44 8b 24 25 30 c7 
[  148.746866] Call Trace:
[  148.765852]  [<ffffffff810391f0>] cpu_idle+0xae/0xcc
[  148.766124]  [<ffffffff81c064f3>] start_secondary+0xbd/0xbf
[  148.785780] NMI backtrace for cpu 40
[  148.785966] CPU 40 
[  148.786077] Modules linked in:
[  148.786246] 
[  148.805683] Pid: 0, comm: kworker/0:1 Not tainted 2.6.39-rc6-tip-yh-03030-gfb0b6a9 #985 Oracle Corporation  Sun Fire X4800/     
[  148.825696] RIP: 0010:[<ffffffff810409eb>]  [<ffffffff810409eb>] mwait_idle+0xef/0x169
[  148.826070] RSP: 0000:ffff88103e9bdee8  EFLAGS: 00000246
[  148.845734] RAX: 0000000000000000 RBX: ffff88103e9bdfd8 RCX: 0000000000000000
[  148.846090] RDX: 0000000000000000 RSI: 0000000000000001 RDI: ffff88103e9c8000
[  148.865826] RBP: ffff88103e9bdef8 R08: 0000000000000000 R09: 0000000000000000
[  148.885628] R10: 0000000000000000 R11: ffff88103e9bded8 R12: 0000000000000028
[  148.885953] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
[  148.905723] FS:  0000000000000000(0000) GS:ffff88607de00000(0000) knlGS:0000000000000000
[  148.925555] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  148.925826] CR2: 0000000000000000 CR3: 000000000239d000 CR4: 00000000000006e0
[  148.945565] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  148.965384] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  148.965728] Process kworker/0:1 (pid: 0, threadinfo ffff88103e9bc000, task ffff88103e9c8000)
[  148.985555] Stack:
[  148.985648]  ffff88103e9bc000 ffffffff82525380 ffff88103e9bdf28 ffffffff810391f0
[  149.005650]  ffff88103e9bdf18 8884672454ef25f4 0000000000000000 0000000000000000
[  149.025515]  ffff88103e9bdf48 ffffffff81c064f3 0000000000000000 c3c2f6eeaf432544
[  149.025926] Call Trace:
[  149.026053]  [<ffffffff810391f0>] cpu_idle+0xae/0xcc
[  149.045493]  [<ffffffff81c064f3>] start_secondary+0xbd/0xbf
[  149.045764] Code: 00 00 48 89 d1 48 8d 83 38 e0 ff ff 0f 01 c8 0f ae f0 48 8b 83 38 e0 ff ff a8 08 75 10 e8 ec fd 06 00 31 c0 48 89 c1 fb 0f 01 c9 <eb> 06 e8 dc fd 06 00 fb 8b 05 0f 0a 4e 01 65 44 8b 24 25 30 c7 
[  149.085854] Call Trace:
[  149.085976]  [<ffffffff810391f0>] cpu_idle+0xae/0xcc
[  149.105177]  [<ffffffff81c064f3>] start_secondary+0xbd/0xbf
[  149.105478] NMI backtrace for cpu 42
[  149.125059] CPU 42 
[  149.125164] Modules linked in:
[  149.125383] 
[  149.125460] Pid: 0, comm: kworker/0:1 Not tainted 2.6.39-rc6-tip-yh-03030-gfb0b6a9 #985 Oracle Corporation  Sun Fire X4800/     
[  149.145540] RIP: 0010:[<ffffffff810409eb>]  [<ffffffff810409eb>] mwait_idle+0xef/0x169
[  149.165163] RSP: 0000:ffff88103e9ebee8  EFLAGS: 00000246
[  149.165452] RAX: 0000000000000000 RBX: ffff88103e9ebfd8 RCX: 0000000000000000
[  149.185144] RDX: 0000000000000000 RSI: 0000000000000001 RDI: ffff88103e9f0000
[  149.204974] RBP: ffff88103e9ebef8 R08: 0000000000000000 R09: 0000000000000000
[  149.205299] R10: 0000000000000000 R11: ffff88103e9ebed8 R12: 000000000000002a
[  149.225235] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
[  149.244814] FS:  0000000000000000(0000) GS:ffff88607e200000(0000) knlGS:0000000000000000
[  149.245197] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  149.265453] CR2: 0000000000000000 CR3: 000000000239d000 CR4: 00000000000006e0
[  149.284690] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  149.285023] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  149.304772] Process kworker/0:1 (pid: 0, threadinfo ffff88103e9ea000, task ffff88103e9f0000)
[  149.325516] Stack:
[  149.325619]  ffff88103e9ea000 ffffffff82525380 ffff88103e9ebf28 ffffffff810391f0
[  149.326088]  ffff88103e9ebf18 b7850adb4e3fa3f3 0000000000000000 0000000000000000
[  149.344913]  ffff88103e9ebf48 ffffffff81c064f3 0000000000000000 cba24f187a031774
[  149.364697] Call Trace:
[  149.364828]  [<ffffffff810391f0>] cpu_idle+0xae/0xcc
[  149.365069]  [<ffffffff81c064f3>] start_secondary+0xbd/0xbf
[  149.384751] Code: 00 00 48 89 d1 48 8d 83 38 e0 ff ff 0f 01 c8 0f ae f0 48 8b 83 38 e0 ff ff a8 08 75 10 e8 ec fd 06 00 31 c0 48 89 c1 fb 0f 01 c9 <eb> 06 e8 dc fd 06 00 fb 8b 05 0f 0a 4e 01 65 44 8b 24 25 30 c7 
[  149.424582] Call Trace:
[  149.424714]  [<ffffffff810391f0>] cpu_idle+0xae/0xcc
[  149.424975]  [<ffffffff81c064f3>] start_secondary+0xbd/0xbf
[  149.444530] NMI backtrace for cpu 41
[  149.444721] CPU 41 
[  149.444843] Modules linked in:
[  149.464363] 
[  149.464455] Pid: 0, comm: kworker/0:1 Not tainted 2.6.39-rc6-tip-yh-03030-gfb0b6a9 #985 Oracle Corporation  Sun Fire X4800/     
[  149.484442] RIP: 0010:[<ffffffff810409eb>]  [<ffffffff810409eb>] mwait_idle+0xef/0x169
[  149.504229] RSP: 0000:ffff88103e9d5ee8  EFLAGS: 00000246
[  149.504490] RAX: 0000000000000000 RBX: ffff88103e9d5fd8 RCX: 0000000000000000
[  149.524276] RDX: 0000000000000000 RSI: 0000000000000001 RDI: ffff88103e9e0000
[  149.524620] RBP: ffff88103e9d5ef8 R08: 0000000000000000 R09: 0000000000000000
[  149.544358] R10: 0000000000000000 R11: ffff88103e9d5ed8 R12: 0000000000000029
[  149.564177] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
[  149.564512] FS:  0000000000000000(0000) GS:ffff88607e000000(0000) knlGS:0000000000000000
[  149.584333] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  149.584601] CR2: 0000000000000000 CR3: 000000000239d000 CR4: 00000000000006e0
[  149.604398] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  149.624129] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  149.624494] Process kworker/0:1 (pid: 0, threadinfo ffff88103e9d4000, task ffff88103e9e0000)
[  149.644334] Stack:
[  149.644449]  ffff88103e9d4000 ffffffff82525380 ffff88103e9d5f28 ffffffff810391f0
[  149.664249]  ffff88103e9d5f18 f21ec8d6397b0a89 0000000000000000 0000000000000000
[  149.684023]  ffff88103e9d5f48 ffffffff81c064f3 0000000000000000 37d0a573f1bb7502
[  149.684455] Call Trace:
[  149.703863]  [<ffffffff810391f0>] cpu_idle+0xae/0xcc
[  149.704114]  [<ffffffff81c064f3>] start_secondary+0xbd/0xbf
[  149.723783] Code: 00 00 48 89 d1 48 8d 83 38 e0 ff ff 0f 01 c8 0f ae f0 48 8b 83 38 e0 ff ff a8 08 75 10 e8 ec fd 06 00 31 c0 48 89 c1 fb 0f 01 c9 <eb> 06 e8 dc fd 06 00 fb 8b 05 0f 0a 4e 01 65 44 8b 24 25 30 c7 
[  149.744613] Call Trace:
[  149.744743]  [<ffffffff810391f0>] cpu_idle+0xae/0xcc
[  149.763901]  [<ffffffff81c064f3>] start_secondary+0xbd/0xbf
[  149.764220] NMI backtrace for cpu 43
[  149.783770] CPU 43 
[  149.783882] Modules linked in:
[  149.784092] 
[  149.784184] Pid: 0, comm: kworker/0:1 Not tainted 2.6.39-rc6-tip-yh-03030-gfb0b6a9 #985 Oracle Corporation  Sun Fire X4800/     
[  149.804123] RIP: 0010:[<ffffffff810409eb>]  [<ffffffff810409eb>] mwait_idle+0xef/0x169
[  149.823907] RSP: 0000:ffff88103ea11ee8  EFLAGS: 00000246
[  149.843590] RAX: 0000000000000000 RBX: ffff88103ea11fd8 RCX: 0000000000000000
[  149.843928] RDX: 0000000000000000 RSI: 0000000000000001 RDI: ffff88103ea08000
[  149.863690] RBP: ffff88103ea11ef8 R08: 0000000000000000 R09: 0000000000000000
[  149.883452] R10: 0000000000000000 R11: ffff88103ea11ed8 R12: 000000000000002b
[  149.883791] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
[  149.903583] FS:  0000000000000000(0000) GS:ffff88607e400000(0000) knlGS:0000000000000000
[  149.923406] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  149.923672] CR2: 0000000000000000 CR3: 000000000239d000 CR4: 00000000000006e0
[  149.943429] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  149.943764] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  149.964167] Process kworker/0:1 (pid: 0, threadinfo ffff88103ea10000, task ffff88103ea08000)
[  149.983386] Stack:
[  149.983501]  ffff88103ea10000 ffffffff82525380 ffff88103ea11f28 ffffffff810391f0
[  150.003322]  ffff88103ea11f18 427e6af2afeb849d 0000000000000000 0000000000000000
[  150.003762]  ffff88103ea11f48 ffffffff81c064f3 0000000000000000 2a7ca1ca1d9c5d76
[  150.023654] Call Trace:
[  150.023807]  [<ffffffff810391f0>] cpu_idle+0xae/0xcc
[  150.043573]  [<ffffffff81c064f3>] start_secondary+0xbd/0xbf
[  150.043854] Code: 00 00 48 89 d1 48 8d 83 38 e0 ff ff 0f 01 c8 0f ae f0 48 8b 83 38 e0 ff ff a8 08 75 10 e8 ec fd 06 00 31 c0 48 89 c1 fb 0f 01 c9 <eb> 06 e8 dc fd 06 00 fb 8b 05 0f 0a 4e 01 65 44 8b 24 25 30 c7 
[  150.083583] Call Trace:
[  150.083715]  [<ffffffff810391f0>] cpu_idle+0xae/0xcc
[  150.103023]  [<ffffffff81c064f3>] start_secondary+0xbd/0xbf
[  150.103305] NMI backtrace for cpu 31
[  150.103487] CPU 31 
[  150.122956] Modules linked in:
[  150.123144] 
[  150.123237] Pid: 0, comm: kworker/0:1 Not tainted 2.6.39-rc6-tip-yh-03030-gfb0b6a9 #985 Oracle Corporation  Sun Fire X4800/     
[  150.143189] RIP: 0010:[<ffffffff810409eb>]  [<ffffffff810409eb>] mwait_idle+0xef/0x169
[  150.163215] RSP: 0000:ffff88103e913ee8  EFLAGS: 00000246
[  150.163475] RAX: 0000000000000000 RBX: ffff88103e913fd8 RCX: 0000000000000000
[  150.183032] RDX: 0000000000000000 RSI: 0000000000000001 RDI: ffff88103e90c560
[  150.183340] RBP: ffff88103e913ef8 R08: 0000000000000000 R09: 0000000000000000
[  150.203113] R10: 0000000000000000 R11: ffff88103e913ed8 R12: 000000000000001f
[  150.222906] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
[  150.223225] FS:  0000000000000000(0000) GS:ffff88407ec00000(0000) knlGS:0000000000000000
[  150.243031] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  150.262763] CR2: 0000000000000000 CR3: 000000000239d000 CR4: 00000000000006e0
[  150.263096] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  150.282880] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  150.302627] Process kworker/0:1 (pid: 0, threadinfo ffff88103e912000, task ffff88103e90c560)
[  150.303003] Stack:
[  150.322564]  ffff88103e912000 ffffffff82525380 ffff88103e913f28 ffffffff810391f0
[  150.322981]  ffff88103e913f18 36e0850fd202b94f 0000000000000000 0000000000000000
[  150.342905]  ffff88103e913f48 ffffffff81c064f3 0000000000000000 23640462fccc8760
[  150.362518] Call Trace:
[  150.362656]  [<ffffffff810391f0>] cpu_idle+0xae/0xcc
[  150.362927]  [<ffffffff81c064f3>] start_secondary+0xbd/0xbf
[  150.382583] Code: 00 00 48 89 d1 48 8d 83 38 e0 ff ff 0f 01 c8 0f ae f0 48 8b 83 38 e0 ff ff a8 08 75 10 e8 ec fd 06 00 31 c0 48 89 c1 fb 0f 01 c9 <eb> 06 e8 dc fd 06 00 fb 8b 05 0f 0a 4e 01 65 44 8b 24 25 30 c7 
[  150.403742] Call Trace:
[  150.423046]  [<ffffffff810391f0>] cpu_idle+0xae/0xcc
[  150.423294]  [<ffffffff81c064f3>] start_secondary+0xbd/0xbf
[  150.442462] NMI backtrace for cpu 48
[  150.442655] CPU 48 
[  150.442756] Modules linked in:
[  150.442931] 
[  150.462450] Pid: 0, comm: kworker/0:1 Not tainted 2.6.39-rc6-tip-yh-03030-gfb0b6a9 #985 Oracle Corporation  Sun Fire X4800/     
[  150.482459] RIP: 0010:[<ffffffff810409eb>]  [<ffffffff810409eb>] mwait_idle+0xef/0x169
[  150.482837] RSP: 0000:ffff88103ea6bee8  EFLAGS: 00000246
[  150.502491] RAX: 0000000000000000 RBX: ffff88103ea6bfd8 RCX: 0000000000000000
[  150.502796] RDX: 0000000000000000 RSI: 0000000000000001 RDI: ffff88103ea70000
[  150.522451] RBP: ffff88103ea6bef8 R08: 0000000000000000 R09: 0000000000000000
[  150.542236] R10: 0000000000000000 R11: ffff88103ea6bed8 R12: 0000000000000030
[  150.542541] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
[  150.562303] FS:  0000000000000000(0000) GS:ffff88707de00000(0000) knlGS:0000000000000000
[  150.582145] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  150.582394] CR2: 0000000000000000 CR3: 000000000239d000 CR4: 00000000000006e0
[  150.603461] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  150.621958] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  150.622276] Process kworker/0:1 (pid: 0, threadinfo ffff88103ea6a000, task ffff88103ea70000)
[  150.642103] Stack:
[  150.642199]  ffff88103ea6a000 ffffffff82525380 ffff88103ea6bf28 ffffffff810391f0
[  150.662184]  ffff88103ea6bf18 0978fc6520c78880 0000000000000000 0000000000000000
[  150.662561]  ffff88103ea6bf48 ffffffff81c064f3 0000000000000000 9353423d8473ae89
[  150.682209] Call Trace:
[  150.682348]  [<ffffffff810391f0>] cpu_idle+0xae/0xcc
[  150.701940]  [<ffffffff81c064f3>] start_secondary+0xbd/0xbf
[  150.702196] Code: 00 00 48 89 d1 48 8d 83 38 e0 ff ff 0f 01 c8 0f ae f0 48 8b 83 38 e0 ff ff a8 08 75 10 e8 ec fd 06 00 31 c0 48 89 c1 fb 0f 01 c9 <eb> 06 e8 dc fd 06 00 fb 8b 05 0f 0a 4e 01 65 44 8b 24 25 30 c7 
[  150.742272] Call Trace:
[  150.742395]  [<ffffffff810391f0>] cpu_idle+0xae/0xcc
[  150.761756]  [<ffffffff81c064f3>] start_secondary+0xbd/0xbf
[  150.762009] NMI backtrace for cpu 49
[  150.781726] CPU 49 
[  150.781824] Modules linked in:
[  150.781995] 
[  150.782082] Pid: 0, comm: kworker/0:1 Not tainted 2.6.39-rc6-tip-yh-03030-gfb0b6a9 #985 Oracle Corporation  Sun Fire X4800/     
[  150.801931] RIP: 0010:[<ffffffff810409eb>]  [<ffffffff810409eb>] mwait_idle+0xef/0x169
[  150.821720] RSP: 0000:ffff88103ea89ee8  EFLAGS: 00000246
[  150.821962] RAX: 0000000000000000 RBX: ffff88103ea89fd8 RCX: 0000000000000000
[  150.841744] RDX: 0000000000000000 RSI: 0000000000000001 RDI: ffff88103ea80000
[  150.861530] RBP: ffff88103ea89ef8 R08: 0000000000000000 R09: 0000000000000000
[  150.861832] R10: 0000000000000000 R11: ffff88103ea89ed8 R12: 0000000000000031
[  150.881622] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
[  150.901428] FS:  0000000000000000(0000) GS:ffff88707e000000(0000) knlGS:0000000000000000
[  150.901777] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  150.921487] CR2: 0000000000000000 CR3: 000000000239d000 CR4: 00000000000006e0
[  150.941299] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  150.941625] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  150.961397] Process kworker/0:1 (pid: 0, threadinfo ffff88103ea88000, task ffff88103ea80000)
[  150.981223] Stack:
[  150.981324]  ffff88103ea88000 ffffffff82525380 ffff88103ea89f28 ffffffff810391f0
[  150.981726]  ffff88103ea89f18 951b3f639aa8d187 0000000000000000 0000000000000000
[  151.002912]  ffff88103ea89f48 ffffffff81c064f3 0000000000000000 604a3900ef2607fb
[  151.021327] Call Trace:
[  151.021454]  [<ffffffff810391f0>] cpu_idle+0xae/0xcc
[  151.021673]  [<ffffffff81c064f3>] start_secondary+0xbd/0xbf
[  151.041382] Code: 00 00 48 89 d1 48 8d 83 38 e0 ff ff 0f 01 c8 0f ae f0 48 8b 83 38 e0 ff ff a8 08 75 10 e8 ec fd 06 00 31 c0 48 89 c1 fb 0f 01 c9 <eb> 06 e8 dc fd 06 00 fb 8b 05 0f 0a 4e 01 65 44 8b 24 25 30 c7 
[  151.081354] Call Trace:
[  151.081467]  [<ffffffff810391f0>] cpu_idle+0xae/0xcc
[  151.081698]  [<ffffffff81c064f3>] start_secondary+0xbd/0xbf
[  151.101243] NMI backtrace for cpu 50
[  151.101407] CPU 50 
[  151.101497] Modules linked in:
[  151.120977] 
[  151.121058] Pid: 0, comm: kworker/0:1 Not tainted 2.6.39-rc6-tip-yh-03030-gfb0b6a9 #985 Oracle Corporation  Sun Fire X4800/     
[  151.141171] RIP: 0010:[<ffffffff810409eb>]  [<ffffffff810409eb>] mwait_idle+0xef/0x169
[  151.141532] RSP: 0000:ffff88103ea8fee8  EFLAGS: 00000246
[  151.161045] RAX: 0000000000000000 RBX: ffff88103ea8ffd8 RCX: 0000000000000000
[  151.180842] RDX: 0000000000000000 RSI: 0000000000000001 RDI: ffff88103ea98000
[  151.181186] RBP: ffff88103ea8fef8 R08: 0000000000000000 R09: 0000000000000000
[  151.200975] R10: 0000000000000000 R11: ffff88103ea8fed8 R12: 0000000000000032
[  151.220978] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
[  151.221291] FS:  0000000000000000(0000) GS:ffff88707e200000(0000) knlGS:0000000000000000
[  151.241589] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  151.241838] CR2: 0000000000000000 CR3: 000000000239d000 CR4: 00000000000006e0
[  151.260913] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  151.280708] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  151.281016] Process kworker/0:1 (pid: 0, threadinfo ffff88103ea8e000, task ffff88103ea98000)
[  151.300848] Stack:
[  151.300944]  ffff88103ea8e000 ffffffff82525380 ffff88103ea8ff28 ffffffff810391f0
[  151.320844]  ffff88103ea8ff18 13948b935e8bb551 0000000000000000 0000000000000000
[  151.340727]  ffff88103ea8ff48 ffffffff81c064f3 0000000000000000 799b066110ec0e64
[  151.341115] Call Trace:
[  151.360457]  [<ffffffff810391f0>] cpu_idle+0xae/0xcc
[  151.360681]  [<ffffffff81c064f3>] start_secondary+0xbd/0xbf
[  151.380646] Code: 00 00 48 89 d1 48 8d 83 38 e0 ff ff 0f 01 c8 0f ae f0 48 8b 83 38 e0 ff ff a8 08 75 10 e8 ec fd 06 00 31 c0 48 89 c1 fb 0f 01 c9 <eb> 06 e8 dc fd 06 00 fb 8b 05 0f 0a 4e 01 65 44 8b 24 25 30 c7 
[  151.401120] Call Trace:
[  151.401253]  [<ffffffff810391f0>] cpu_idle+0xae/0xcc
[  151.420617]  [<ffffffff81c064f3>] start_secondary+0xbd/0xbf
[  151.420870] NMI backtrace for cpu 56
[  151.440510] CPU 56 
[  151.440610] Modules linked in:
[  151.440800] 
[  151.440876] Pid: 0, comm: kworker/0:1 Not tainted 2.6.39-rc6-tip-yh-03030-gfb0b6a9 #985 Oracle Corporation  Sun Fire X4800/     
[  151.460859] RIP: 0010:[<ffffffff810409eb>]  [<ffffffff810409eb>] mwait_idle+0xef/0x169
[  151.480498] RSP: 0000:ffff88103eb05ee8  EFLAGS: 00000246
[  151.500180] RAX: 0000000000000000 RBX: ffff88103eb05fd8 RCX: 0000000000000000
[  151.500497] RDX: 0000000000000000 RSI: 0000000000000001 RDI: ffff88103eafc560
[  151.520264] RBP: ffff88103eb05ef8 R08: 0000000000000000 R09: 0000000000000000
[  151.520575] R10: 0000000000000000 R11: ffff88103eb05ed8 R12: 0000000000000038
[  151.540745] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
[  151.560192] FS:  0000000000000000(0000) GS:ffff88807d800000(0000) knlGS:0000000000000000
[  151.580000] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  151.580255] CR2: 0000000000000000 CR3: 000000000239d000 CR4: 00000000000006e0
[  151.600026] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  151.600345] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  151.620157] Process kworker/0:1 (pid: 0, threadinfo ffff88103eb04000, task ffff88103eafc560)
[  151.640138] Stack:
[  151.640244]  ffff88103eb04000 ffffffff82525380 ffff88103eb05f28 ffffffff810391f0
[  151.659894]  ffff88103eb05f18 1f33aead7ea68430 0000000000000000 0000000000000000
[  151.660313]  ffff88103eb05f48 ffffffff81c064f3 0000000000000000 595592b75fa60d89
[  151.680074] Call Trace:
[  151.680190]  [<ffffffff810391f0>] cpu_idle+0xae/0xcc
[  151.699819]  [<ffffffff81c064f3>] start_secondary+0xbd/0xbf
[  151.700082] Code: 00 00 48 89 d1 48 8d 83 38 e0 ff ff 0f 01 c8 0f ae f0 48 8b 83 38 e0 ff ff a8 08 75 10 e8 ec fd 06 00 31 c0 48 89 c1 fb 0f 01 c9 <eb> 06 e8 dc fd 06 00 fb 8b 05 0f 0a 4e 01 65 44 8b 24 25 30 c7 
[  151.740150] Call Trace:
[  151.740272]  [<ffffffff810391f0>] cpu_idle+0xae/0xcc
[  151.740513]  [<ffffffff81c064f3>] start_secondary+0xbd/0xbf
[  151.759862] NMI backtrace for cpu 47
[  151.760045] CPU 47 
[  151.760158] Modules linked in:
[  151.779745] 
[  151.779852] Pid: 0, comm: kworker/0:1 Not tainted 2.6.39-rc6-tip-yh-03030-gfb0b6a9 #985 Oracle Corporation  Sun Fire X4800/     
[  151.799837] RIP: 0010:[<ffffffff810409eb>]  [<ffffffff810409eb>] mwait_idle+0xef/0x169
[  151.819578] RSP: 0000:ffff88103ea53ee8  EFLAGS: 00000246
[  151.819830] RAX: 0000000000000000 RBX: ffff88103ea53fd8 RCX: 0000000000000000
[  151.839604] RDX: 0000000000000000 RSI: 0000000000000001 RDI: ffff88103ea58000
[  151.839946] RBP: ffff88103ea53ef8 R08: 0000000000000000 R09: 0000000000000000
[  151.859711] R10: 0000000000000000 R11: ffff88103ea53ed8 R12: 000000000000002f
[  151.879497] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
[  151.879830] FS:  0000000000000000(0000) GS:ffff88607ec00000(0000) knlGS:0000000000000000
[  151.900927] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  151.919469] CR2: 0000000000000000 CR3: 000000000239d000 CR4: 00000000000006e0
[  151.919823] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  151.939479] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  151.959236] Process kworker/0:1 (pid: 0, threadinfo ffff88103ea52000, task ffff88103ea58000)
[  151.959634] Stack:
[  151.979194]  ffff88103ea52000 ffffffff82525380 ffff88103ea53f28 ffffffff810391f0
[  151.979671]  ffff88103ea53f18 50617d206f7b41f7 0000000000000000 0000000000000000
[  151.999370]  ffff88103ea53f48 ffffffff81c064f3 0000000000000000 036c0faac09abc9f
[  152.019268] Call Trace:
[  152.019426]  [<ffffffff810391f0>] cpu_idle+0xae/0xcc
[  152.019671]  [<ffffffff81c064f3>] start_secondary+0xbd/0xbf
[  152.039785] Code: 00 00 48 89 d1 48 8d 83 38 e0 ff ff 0f 01 c8 0f ae f0 48 8b 83 38 e0 ff ff a8 08 75 10 e8 ec fd 06 00 31 c0 48 89 c1 fb 0f 01 c9 <eb> 06 e8 dc fd 06 00 fb 8b 05 0f 0a 4e 01 65 44 8b 24 25 30 c7 
[  152.060107] Call Trace:
[  152.079243]  [<ffffffff810391f0>] cpu_idle+0xae/0xcc
[  152.079515]  [<ffffffff81c064f3>] start_secondary+0xbd/0xbf
[  152.099144] NMI backtrace for cpu 57
[  152.099326] CPU 57 
[  152.099427] Modules linked in:
[  152.099600] 
[  152.099676] Pid: 0, comm: kworker/0:1 Not tainted 2.6.39-rc6-tip-yh-03030-gfb0b6a9 #985 Oracle Corporation  Sun Fire X4800/     
[  152.138887] RIP: 0010:[<ffffffff810409eb>]  [<ffffffff810409eb>] mwait_idle+0xef/0x169
[  152.139266] RSP: 0000:ffff88103eb23ee8  EFLAGS: 00000246
[  152.158951] RAX: 0000000000000000 RBX: ffff88103eb23fd8 RCX: 0000000000000000
[  152.159318] RDX: 0000000000000000 RSI: 0000000000000001 RDI: ffff88103eb0a2b0
[  152.179048] RBP: ffff88103eb23ef8 R08: 0000000000000000 R09: 0000000000000000
[  152.198914] R10: 0000000000000000 R11: ffff88103eb23ed8 R12: 0000000000000039
[  152.199247] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
[  152.218930] FS:  0000000000000000(0000) GS:ffff88807da00000(0000) knlGS:0000000000000000
[  152.238749] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  152.239019] CR2: 0000000000000000 CR3: 000000000239d000 CR4: 00000000000006e0
[  152.258793] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  152.278574] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  152.278911] Process kworker/0:1 (pid: 0, threadinfo ffff88103eb22000, task ffff88103eb0a2b0)
[  152.298711] Stack:
[  152.298819]  ffff88103eb22000 ffffffff82525380 ffff88103eb23f28 ffffffff810391f0
[  152.318635]  ffff88103eb23f18 cfa00dc14662a13f 0000000000000000 0000000000000000
[  152.319037]  ffff88103eb23f48 ffffffff81c064f3 0000000000000000 7b7fb8c1286f7e8a
[  152.338824] Call Trace:
[  152.338960]  [<ffffffff810391f0>] cpu_idle+0xae/0xcc
[  152.358541]  [<ffffffff81c064f3>] start_secondary+0xbd/0xbf
[  152.358800] Code: 00 00 48 89 d1 48 8d 83 38 e0 ff ff 0f 01 c8 0f ae f0 48 8b 83 38 e0 ff ff a8 08 75 10 e8 ec fd 06 00 31 c0 48 89 c1 fb 0f 01 c9 <eb> 06 e8 dc fd 06 00 fb 8b 05 0f 0a 4e 01 65 44 8b 24 25 30 c7 
[  152.398851] Call Trace:
[  152.398966]  [<ffffffff810391f0>] cpu_idle+0xae/0xcc
[  152.418372]  [<ffffffff81c064f3>] start_secondary+0xbd/0xbf
[  152.418640] NMI backtrace for cpu 44
[  152.418833] CPU 44 
[  152.438326] Modules linked in:
[  152.438524] 
[  152.438622] Pid: 0, comm: kworker/0:1 Not tainted 2.6.39-rc6-tip-yh-03030-gfb0b6a9 #985 Oracle Corporation  Sun Fire X4800/     
[  152.458574] RIP: 0010:[<ffffffff810409eb>]  [<ffffffff810409eb>] mwait_idle+0xef/0x169
[  152.478339] RSP: 0000:ffff88103ea17ee8  EFLAGS: 00000246
[  152.478586] RAX: 0000000000000000 RBX: ffff88103ea17fd8 RCX: 0000000000000000
[  152.498355] RDX: 0000000000000000 RSI: 0000000000000001 RDI: ffff88103ea18000
[  152.518562] RBP: ffff88103ea17ef8 R08: 0000000000000000 R09: 0000000000000000
[  152.518939] R10: 0000000000000000 R11: ffff88103ea17ed8 R12: 000000000000002c
[  152.539224] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
[  152.558012] FS:  0000000000000000(0000) GS:ffff88607e600000(0000) knlGS:0000000000000000
[  152.558383] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  152.578111] CR2: 0000000000000000 CR3: 000000000239d000 CR4: 00000000000006e0
[  152.578441] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  152.598218] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  152.618018] Process kworker/0:1 (pid: 0, threadinfo ffff88103ea16000, task ffff88103ea18000)
[  152.637851] Stack:
[  152.637974]  ffff88103ea16000 ffffffff82525380 ffff88103ea17f28 ffffffff810391f0
[  152.638402]  ffff88103ea17f18 dc4e2695c0884d50 0000000000000000 0000000000000000
[  152.658134]  ffff88103ea17f48 ffffffff81c064f3 0000000000000000 7517c64c020bf9bd
[  152.677905] Call Trace:
[  152.678068]  [<ffffffff810391f0>] cpu_idle+0xae/0xcc
[  152.678326]  [<ffffffff81c064f3>] start_secondary+0xbd/0xbf
[  152.697921] Code: 00 00 48 89 d1 48 8d 83 38 e0 ff ff 0f 01 c8 0f ae f0 48 8b 83 38 e0 ff ff a8 08 75 10 e8 ec fd 06 00 31 c0 48 89 c1 fb 0f 01 c9 <eb> 06 e8 dc fd 06 00 fb 8b 05 0f 0a 4e 01 65 44 8b 24 25 30 c7 
[  152.737725] Call Trace:
[  152.737867]  [<ffffffff810391f0>] cpu_idle+0xae/0xcc
[  152.738091]  [<ffffffff81c064f3>] start_secondary+0xbd/0xbf
[  152.757760] NMI backtrace for cpu 52
[  152.757934] CPU 52 
[  152.758025] Modules linked in:
[  152.777587] 
[  152.777683] Pid: 0, comm: kworker/0:1 Not tainted 2.6.39-rc6-tip-yh-03030-gfb0b6a9 #985 Oracle Corporation  Sun Fire X4800/     
[  152.797670] RIP: 0010:[<ffffffff810409eb>]  [<ffffffff810409eb>] mwait_idle+0xef/0x169
[  152.798037] RSP: 0000:ffff88103eab5ee8  EFLAGS: 00000246
[  152.817677] RAX: 0000000000000000 RBX: ffff88103eab5fd8 RCX: 0000000000000000
[  152.837468] RDX: 0000000000000000 RSI: 0000000000000001 RDI: ffff88103eac0000
[  152.837771] RBP: ffff88103eab5ef8 R08: 0000000000000000 R09: 0000000000000000
[  152.857537] R10: 0000000000000000 R11: ffff88103eab5ed8 R12: 0000000000000034
[  152.877346] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
[  152.877674] FS:  0000000000000000(0000) GS:ffff88707e600000(0000) knlGS:0000000000000000
[  152.897481] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  152.897733] CR2: 0000000000000000 CR3: 000000000239d000 CR4: 00000000000006e0
[  152.917526] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  152.937326] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  152.937635] Process kworker/0:1 (pid: 0, threadinfo ffff88103eab4000, task ffff88103eac0000)
[  152.957451] Stack:
[  152.957547]  ffff88103eab4000 ffffffff82525380 ffff88103eab5f28 ffffffff810391f0
[  152.977438]  ffff88103eab5f18 930c2eb4f563a0aa 0000000000000000 0000000000000000
[  152.997187]  ffff88103eab5f48 ffffffff81c064f3 0000000000000000 19e27f03b5b56431
[  152.997579] Call Trace:
[  153.017117]  [<ffffffff810391f0>] cpu_idle+0xae/0xcc
[  153.017338]  [<ffffffff81c064f3>] start_secondary+0xbd/0xbf
[  153.017600] Code: 00 00 48 89 d1 48 8d 83 38 e0 ff ff 0f 01 c8 0f ae f0 48 8b 83 38 e0 ff ff a8 08 75 10 e8 ec fd 06 00 31 c0 48 89 c1 fb 0f 01 c9 <eb> 06 e8 dc fd 06 00 fb 8b 05 0f 0a 4e 01 65 44 8b 24 25 30 c7 
[  153.057985] Call Trace:
[  153.058104]  [<ffffffff810391f0>] cpu_idle+0xae/0xcc
[  153.077322]  [<ffffffff81c064f3>] start_secondary+0xbd/0xbf
[  153.077582] NMI backtrace for cpu 51
[  153.097261] CPU 51 
[  153.097354] Modules linked in:
[  153.097541] 
[  153.097620] Pid: 0, comm: kworker/0:1 Not tainted 2.6.39-rc6-tip-yh-03030-gfb0b6a9 #985 Oracle Corporation  Sun Fire X4800/     
[  153.117429] RIP: 0010:[<ffffffff810409eb>]  [<ffffffff810409eb>] mwait_idle+0xef/0x169
[  153.137096] RSP: 0000:ffff88103eaa5ee8  EFLAGS: 00000246
[  153.156777] RAX: 0000000000000000 RBX: ffff88103eaa5fd8 RCX: 0000000000000000
[  153.157085] RDX: 0000000000000000 RSI: 0000000000000001 RDI: ffff88103eaa8000
[  153.178037] RBP: ffff88103eaa5ef8 R08: 0000000000000000 R09: 0000000000000000
[  153.178355] R10: 0000000000000000 R11: ffff88103eaa5ed8 R12: 0000000000000033
[  153.196963] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
[  153.216960] FS:  0000000000000000(0000) GS:ffff88707e400000(0000) knlGS:0000000000000000
[  153.217319] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  153.236846] CR2: 0000000000000000 CR3: 000000000239d000 CR4: 00000000000006e0
[  153.256641] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  153.256962] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  153.276744] Process kworker/0:1 (pid: 0, threadinfo ffff88103eaa4000, task ffff88103eaa8000)
[  153.297121] Stack:
[  153.297217]  ffff88103eaa4000 ffffffff82525380 ffff88103eaa5f28 ffffffff810391f0
[  153.316494]  ffff88103eaa5f18 6c5150727d6760c1 0000000000000000 0000000000000000
[  153.316903]  ffff88103eaa5f48 ffffffff81c064f3 0000000000000000 a26eef57dafda858
[  153.336663] Call Trace:
[  153.336780]  [<ffffffff810391f0>] cpu_idle+0xae/0xcc
[  153.356413]  [<ffffffff81c064f3>] start_secondary+0xbd/0xbf
[  153.356674] Code: 00 00 48 89 d1 48 8d 83 38 e0 ff ff 0f 01 c8 0f ae f0 48 8b 83 38 e0 ff ff a8 08 75 10 e8 ec fd 06 00 31 c0 48 89 c1 fb 0f 01 c9 <eb> 06 e8 dc fd 06 00 fb 8b 05 0f 0a 4e 01 65 44 8b 24 25 30 c7 
[  153.396587] Call Trace:
[  153.396710]  [<ffffffff810391f0>] cpu_idle+0xae/0xcc
[  153.396928]  [<ffffffff81c064f3>] start_secondary+0xbd/0xbf
[  153.416571] NMI backtrace for cpu 59
[  153.416754] CPU 59 
[  153.416860] Modules linked in:
[  153.436338] 
[  153.436432] Pid: 0, comm: kworker/0:1 Not tainted 2.6.39-rc6-tip-yh-03030-gfb0b6a9 #985 Oracle Corporation  Sun Fire X4800/     
[  153.456387] RIP: 0010:[<ffffffff810409eb>]  [<ffffffff810409eb>] mwait_idle+0xef/0x169
[  153.476180] RSP: 0000:ffff88103eb49ee8  EFLAGS: 00000246
[  153.476420] RAX: 0000000000000000 RBX: ffff88103eb49fd8 RCX: 0000000000000000
[  153.496211] RDX: 0000000000000000 RSI: 0000000000000001 RDI: ffff88103eb3a2b0
[  153.496537] RBP: ffff88103eb49ef8 R08: 0000000000000000 R09: 0000000000000000
[  153.516302] R10: 0000000000000000 R11: ffff88103eb49ed8 R12: 000000000000003b
[  153.536107] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
[  153.536425] FS:  0000000000000000(0000) GS:ffff88807de00000(0000) knlGS:0000000000000000
[  153.556227] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  153.575968] CR2: 0000000000000000 CR3: 000000000239d000 CR4: 00000000000006e0
[  153.576275] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  153.596051] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  153.615844] Process kworker/0:1 (pid: 0, threadinfo ffff88103eb48000, task ffff88103eb3a2b0)
[  153.616225] Stack:
[  153.616318]  ffff88103eb48000 ffffffff82525380 ffff88103eb49f28 ffffffff810391f0
[  153.636195]  ffff88103eb49f18 faa21ce5a923a46e 0000000000000000 0000000000000000
[  153.656034]  ffff88103eb49f48 ffffffff81c064f3 0000000000000000 37ef54861a9d44d1
[  153.656443] Call Trace:
[  153.675826]  [<ffffffff810391f0>] cpu_idle+0xae/0xcc
[  153.676062]  [<ffffffff81c064f3>] start_secondary+0xbd/0xbf
[  153.695766] Code: 00 00 48 89 d1 48 8d 83 38 e0 ff ff 0f 01 c8 0f ae f0 48 8b 83 38 e0 ff ff a8 08 75 10 e8 ec fd 06 00 31 c0 48 89 c1 fb 0f 01 c9 <eb> 06 e8 dc fd 06 00 fb 8b 05 0f 0a 4e 01 65 44 8b 24 25 30 c7 
[  153.716540] Call Trace:
[  153.735645]  [<ffffffff810391f0>] cpu_idle+0xae/0xcc
[  153.735886]  [<ffffffff81c064f3>] start_secondary+0xbd/0xbf
[  153.755566] NMI backtrace for cpu 38
[  153.755747] CPU 38 
[  153.755873] Modules linked in:
[  153.756045] 
[  153.756125] Pid: 0, comm: kworker/0:1 Not tainted 2.6.39-rc6-tip-yh-03030-gfb0b6a9 #985 Oracle Corporation  Sun Fire X4800/     
[  153.776086] RIP: 0010:[<ffffffff810409eb>]  [<ffffffff810409eb>] mwait_idle+0xef/0x169
[  153.796312] RSP: 0000:ffff88103e9a1ee8  EFLAGS: 00000246
[  153.816517] RAX: 0000000000000000 RBX: ffff88103e9a1fd8 RCX: 0000000000000000
[  153.816833] RDX: 0000000000000000 RSI: 0000000000000001 RDI: ffff88103e99c560
[  153.835672] RBP: ffff88103e9a1ef8 R08: 0000000000000000 R09: 0000000000000000
[  153.855425] R10: 0000000000000000 R11: ffff88103e9a1ed8 R12: 0000000000000026
[  153.855748] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
[  153.875542] FS:  0000000000000000(0000) GS:ffff88507ea00000(0000) knlGS:0000000000000000
[  153.895361] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  153.895631] CR2: 0000000000000000 CR3: 000000000239d000 CR4: 00000000000006e0
[  153.915395] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  153.915726] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  153.935522] Process kworker/0:1 (pid: 0, threadinfo ffff88103e9a0000, task ffff88103e99c560)
[  153.955341] Stack:
[  153.955447]  ffff88103e9a0000 ffffffff82525380 ffff88103e9a1f28 ffffffff810391f0
[  153.975253]  ffff88103e9a1f18 9647bc97204c30cb 0000000000000000 0000000000000000
[  153.975691]  ffff88103e9a1f48 ffffffff81c064f3 0000000000000000 dced99c97795ba22
[  153.995441] Call Trace:
[  153.995561]  [<ffffffff810391f0>] cpu_idle+0xae/0xcc
[  154.015155]  [<ffffffff81c064f3>] start_secondary+0xbd/0xbf
[  154.015436] Code: 00 00 48 89 d1 48 8d 83 38 e0 ff ff 0f 01 c8 0f ae f0 48 8b 83 38 e0 ff ff a8 08 75 10 e8 ec fd 06 00 31 c0 48 89 c1 fb 0f 01 c9 <eb> 06 e8 dc fd 06 00 fb 8b 05 0f 0a 4e 01 65 44 8b 24 25 30 c7 
[  154.055760] Call Trace:
[  154.055869]  [<ffffffff810391f0>] cpu_idle+0xae/0xcc
[  154.075315]  [<ffffffff81c064f3>] start_secondary+0xbd/0xbf
[  154.075587] NMI backtrace for cpu 53
[  154.075758] CPU 53 
[  154.095150] Modules linked in:
[  154.095325] 
[  154.095412] Pid: 0, comm: kworker/0:1 Not tainted 2.6.39-rc6-tip-yh-03030-gfb0b6a9 #985 Oracle Corporation  Sun Fire X4800/     
[  154.115299] RIP: 0010:[<ffffffff810409eb>]  [<ffffffff810409eb>] mwait_idle+0xef/0x169
[  154.135163] RSP: 0000:ffff88103ead3ee8  EFLAGS: 00000246
[  154.135400] RAX: 0000000000000000 RBX: ffff88103ead3fd8 RCX: 0000000000000000
[  154.154947] RDX: 0000000000000000 RSI: 0000000000000001 RDI: ffff88103ead8000
[  154.174742] RBP: ffff88103ead3ef8 R08: 0000000000000000 R09: 0000000000000000
[  154.175055] R10: 0000000000000000 R11: ffff88103ead3ed8 R12: 0000000000000035
[  154.194870] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
[  154.214621] FS:  0000000000000000(0000) GS:ffff88707e800000(0000) knlGS:0000000000000000
[  154.214972] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  154.234707] CR2: 0000000000000000 CR3: 000000000239d000 CR4: 00000000000006e0
[  154.235015] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  154.254816] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  154.274588] Process kworker/0:1 (pid: 0, threadinfo ffff88103ead2000, task ffff88103ead8000)
[  154.274966] Stack:
[  154.294531]  ffff88103ead2000 ffffffff82525380 ffff88103ead3f28 ffffffff810391f0
[  154.294930]  ffff88103ead3f18 4ad8b2f69adc9d19 0000000000000000 0000000000000000
[  154.314743]  ffff88103ead3f48 ffffffff81c064f3 0000000000000000 39135bbcd7b3444d
[  154.334507] Call Trace:
[  154.334634]  [<ffffffff810391f0>] cpu_idle+0xae/0xcc
[  154.334855]  [<ffffffff81c064f3>] start_secondary+0xbd/0xbf
[  154.354483] Code: 00 00 48 89 d1 48 8d 83 38 e0 ff ff 0f 01 c8 0f ae f0 48 8b 83 38 e0 ff ff a8 08 75 10 e8 ec fd 06 00 31 c0 48 89 c1 fb 0f 01 c9 <eb> 06 e8 dc fd 06 00 fb 8b 05 0f 0a 4e 01 65 44 8b 24 25 30 c7 
[  154.394279] Call Trace:
[  154.394408]  [<ffffffff810391f0>] cpu_idle+0xae/0xcc
[  154.394632]  [<ffffffff81c064f3>] start_secondary+0xbd/0xbf
[  154.414308] NMI backtrace for cpu 39
[  154.414511] CPU 39 
[  154.414612] Modules linked in:
[  154.414789] 
[  154.434266] Pid: 0, comm: kworker/0:1 Not tainted 2.6.39-rc6-tip-yh-03030-gfb0b6a9 #985 Oracle Corporation  Sun Fire X4800/     
[  154.454256] RIP: 0010:[<ffffffff810409eb>]  [<ffffffff810409eb>] mwait_idle+0xef/0x169
[  154.454639] RSP: 0000:ffff88103e9a7ee8  EFLAGS: 00000246
[  154.475040] RAX: 0000000000000000 RBX: ffff88103e9a7fd8 RCX: 0000000000000000
[  154.494068] RDX: 0000000000000000 RSI: 0000000000000001 RDI: ffff88103e9b4560
[  154.494399] RBP: ffff88103e9a7ef8 R08: 0000000000000000 R09: 0000000000000000
[  154.514242] R10: 0000000000000000 R11: ffff88103e9a7ed8 R12: 0000000000000027
[  154.514578] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
[  154.534415] FS:  0000000000000000(0000) GS:ffff88507ec00000(0000) knlGS:0000000000000000
[  154.554298] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  154.554583] CR2: 0000000000000000 CR3: 000000000239d000 CR4: 00000000000006e0
[  154.574564] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  154.594101] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  154.594440] Process kworker/0:1 (pid: 0, threadinfo ffff88103e9a6000, task ffff88103e9b4560)
[  154.614406] Stack:
[  154.614512]  ffff88103e9a6000 ffffffff82525380 ffff88103e9a7f28 ffffffff810391f0
[  154.634084]  ffff88103e9a7f18 38d6f42eba77c3bb 0000000000000000 0000000000000000
[  154.653780]  ffff88103e9a7f48 ffffffff81c064f3 0000000000000000 755b949bb9c12001
[  154.654233] Call Trace:
[  154.654356]  [<ffffffff810391f0>] cpu_idle+0xae/0xcc
[  154.674028]  [<ffffffff81c064f3>] start_secondary+0xbd/0xbf
[  154.674284] Code: 00 00 48 89 d1 48 8d 83 38 e0 ff ff 0f 01 c8 0f ae f0 48 8b 83 38 e0 ff ff a8 08 75 10 e8 ec fd 06 00 31 c0 48 89 c1 fb 0f 01 c9 <eb> 06 e8 dc fd 06 00 fb 8b 05 0f 0a 4e 01 65 44 8b 24 25 30 c7 
[  154.714309] Call Trace:
[  154.714444]  [<ffffffff810391f0>] cpu_idle+0xae/0xcc
[  154.733725]  [<ffffffff81c064f3>] start_secondary+0xbd/0xbf
[  154.733995] NMI backtrace for cpu 45
[  154.753592] CPU 45 
[  154.753695] Modules linked in:
[  154.753892] 
[  154.753990] Pid: 0, comm: kworker/0:1 Not tainted 2.6.39-rc6-tip-yh-03030-gfb0b6a9 #985 Oracle Corporation  Sun Fire X4800/     
[  154.773908] RIP: 0010:[<ffffffff810409eb>]  [<ffffffff810409eb>] mwait_idle+0xef/0x169
[  154.793770] RSP: 0000:ffff88103ea2dee8  EFLAGS: 00000246
[  154.794049] RAX: 0000000000000000 RBX: ffff88103ea2dfd8 RCX: 0000000000000000
[  154.813735] RDX: 0000000000000000 RSI: 0000000000000001 RDI: ffff88103ea30000
[  154.833523] RBP: ffff88103ea2def8 R08: 0000000000000000 R09: 0000000000000000
[  154.833866] R10: 0000000000000000 R11: ffff88103ea2ded8 R12: 000000000000002d
[  154.853602] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
[  154.873380] FS:  0000000000000000(0000) GS:ffff88607e800000(0000) knlGS:0000000000000000
[  154.873755] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  154.893466] CR2: 0000000000000000 CR3: 000000000239d000 CR4: 00000000000006e0
[  154.913330] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  154.913678] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  154.933355] Process kworker/0:1 (pid: 0, threadinfo ffff88103ea2c000, task ffff88103ea30000)
[  154.953193] Stack:
[  154.953286]  ffff88103ea2c000 ffffffff82525380 ffff88103ea2df28 ffffffff810391f0
[  154.953734]  ffff88103ea2df18 6270779be7160d7f 0000000000000000 0000000000000000
[  154.973602]  ffff88103ea2df48 ffffffff81c064f3 0000000000000000 3dd00b8e57918ee7
[  154.993277] Call Trace:
[  154.993418]  [<ffffffff810391f0>] cpu_idle+0xae/0xcc
[  155.012990]  [<ffffffff81c064f3>] start_secondary+0xbd/0xbf
[  155.013263] Code: 00 00 48 89 d1 48 8d 83 38 e0 ff ff 0f 01 c8 0f ae f0 48 8b 83 38 e0 ff ff a8 08 75 10 e8 ec fd 06 00 31 c0 48 89 c1 fb 0f 01 c9 <eb> 06 e8 dc fd 06 00 fb 8b 05 0f 0a 4e 01 65 44 8b 24 25 30 c7 
[  155.053196] Call Trace:
[  155.053329]  [<ffffffff810391f0>] cpu_idle+0xae/0xcc
[  155.053555]  [<ffffffff81c064f3>] start_secondary+0xbd/0xbf
[  155.073623] NMI backtrace for cpu 58
[  155.073793] CPU 58 
[  155.073885] Modules linked in:
[  155.093438] 
[  155.093532] Pid: 0, comm: kworker/0:1 Not tainted 2.6.39-rc6-tip-yh-03030-gfb0b6a9 #985 Oracle Corporation  Sun Fire X4800/     
[  155.114036] RIP: 0010:[<ffffffff810409eb>]  [<ffffffff810409eb>] mwait_idle+0xef/0x169
[  155.133133] RSP: 0000:ffff88103eb33ee8  EFLAGS: 00000246
[  155.133378] RAX: 0000000000000000 RBX: ffff88103eb33fd8 RCX: 0000000000000000
[  155.152847] RDX: 0000000000000000 RSI: 0000000000000001 RDI: ffff88103eb2a2b0
[  155.153187] RBP: ffff88103eb33ef8 R08: 0000000000000000 R09: 0000000000000000
[  155.172903] R10: 0000000000000000 R11: ffff88103eb33ed8 R12: 000000000000003a
[  155.192709] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
[  155.193015] FS:  0000000000000000(0000) GS:ffff88807dc00000(0000) knlGS:0000000000000000
[  155.213094] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  155.232578] CR2: 0000000000000000 CR3: 000000000239d000 CR4: 00000000000006e0
[  155.232902] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  155.252653] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  155.252979] Process kworker/0:1 (pid: 0, threadinfo ffff88103eb32000, task ffff88103eb2a2b0)
[  155.272834] Stack:
[  155.272930]  ffff88103eb32000 ffffffff82525380 ffff88103eb33f28 ffffffff810391f0
[  155.292791]  ffff88103eb33f18 3ec07093f886a24c 0000000000000000 0000000000000000
[  155.312567]  ffff88103eb33f48 ffffffff81c064f3 0000000000000000 51920f6bafeca5f6
[  155.312947] Call Trace:
[  155.334676]  [<ffffffff810391f0>] cpu_idle+0xae/0xcc
[  155.334930]  [<ffffffff81c064f3>] start_secondary+0xbd/0xbf
[  155.352495] Code: 00 00 48 89 d1 48 8d 83 38 e0 ff ff 0f 01 c8 0f ae f0 48 8b 83 38 e0 ff ff a8 08 75 10 e8 ec fd 06 00 31 c0 48 89 c1 fb 0f 01 c9 <eb> 06 e8 dc fd 06 00 fb 8b 05 0f 0a 4e 01 65 44 8b 24 25 30 c7 
[  155.373375] Call Trace:
[  155.402529]  [<ffffffff810391f0>] cpu_idle+0xae/0xcc
[  155.402802]  [<ffffffff81c064f3>] start_secondary+0xbd/0xbf
[  155.403078] NMI backtrace for cpu 46
[  155.422302] CPU 46 
[  155.422405] Modules linked in:
[  155.422613] 
[  155.422700] Pid: 0, comm: kworker/0:1 Not tainted 2.6.39-rc6-tip-yh-03030-gfb0b6a9 #985 Oracle Corporation  Sun Fire X4800/     
[  155.442647] RIP: 0010:[<ffffffff810409eb>]  [<ffffffff810409eb>] mwait_idle+0xef/0x169
[  155.462457] RSP: 0000:ffff88103ea43ee8  EFLAGS: 00000246
[  155.482116] RAX: 0000000000000000 RBX: ffff88103ea43fd8 RCX: 0000000000000000
[  155.482467] RDX: 0000000000000000 RSI: 0000000000000001 RDI: ffff88103ea48000
[  155.502221] RBP: ffff88103ea43ef8 R08: 0000000000000000 R09: 0000000000000000
[  155.521992] R10: 0000000000000000 R11: ffff88103ea43ed8 R12: 000000000000002e
[  155.522330] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
[  155.542121] FS:  0000000000000000(0000) GS:ffff88607ea00000(0000) knlGS:0000000000000000
[  155.561929] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  155.562187] CR2: 0000000000000000 CR3: 000000000239d000 CR4: 00000000000006e0
[  155.581979] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  155.582327] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  155.602060] Process kworker/0:1 (pid: 0, threadinfo ffff88103ea42000, task ffff88103ea48000)
[  155.621940] Stack:
[  155.622035]  ffff88103ea42000 ffffffff82525380 ffff88103ea43f28 ffffffff810391f0
[  155.641874]  ffff88103ea43f18 703d8aaf380a16b7 0000000000000000 0000000000000000
[  155.642280]  ffff88103ea43f48 ffffffff81c064f3 0000000000000000 378e401c49b042c7
[  155.662025] Call Trace:
[  155.662161]  [<ffffffff810391f0>] cpu_idle+0xae/0xcc
[  155.681724]  [<ffffffff81c064f3>] start_secondary+0xbd/0xbf
[  155.681979] Code: 00 00 48 89 d1 48 8d 83 38 e0 ff ff 0f 01 c8 0f ae f0 48 8b 83 38 e0 ff ff a8 08 75 10 e8 ec fd 06 00 31 c0 48 89 c1 fb 0f 01 c9 <eb> 06 e8 dc fd 06 00 fb 8b 05 0f 0a 4e 01 65 44 8b 24 25 30 c7 
[  155.721995] Call Trace:
[  155.722115]  [<ffffffff810391f0>] cpu_idle+0xae/0xcc
[  155.741535]  [<ffffffff81c064f3>] start_secondary+0xbd/0xbf
[  155.741804] NMI backtrace for cpu 60
[  155.742016] CPU 60 
[  155.762251] Modules linked in:
[  155.762427] 
[  155.762516] Pid: 0, comm: kworker/0:1 Not tainted 2.6.39-rc6-tip-yh-03030-gfb0b6a9 #985 Oracle Corporation  Sun Fire X4800/     
[  155.781721] RIP: 0010:[<ffffffff810409eb>]  [<ffffffff810409eb>] mwait_idle+0xef/0x169
[  155.801501] RSP: 0000:ffff88103eb4fee8  EFLAGS: 00000246
[  155.801736] RAX: 0000000000000000 RBX: ffff88103eb4ffd8 RCX: 0000000000000000
[  155.821550] RDX: 0000000000000000 RSI: 0000000000000001 RDI: ffff88103eb522b0
[  155.841322] RBP: ffff88103eb4fef8 R08: 0000000000000000 R09: 0000000000000000
[  155.841636] R10: 0000000000000000 R11: ffff88103eb4fed8 R12: 000000000000003c
[  155.861411] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
[  155.861738] FS:  0000000000000000(0000) GS:ffff88807e000000(0000) knlGS:0000000000000000
[  155.881570] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  155.901283] CR2: 0000000000000000 CR3: 000000000239d000 CR4: 00000000000006e0
[  155.901605] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  155.921374] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  155.941182] Process kworker/0:1 (pid: 0, threadinfo ffff88103eb4e000, task ffff88103eb522b0)
[  155.941553] Stack:
[  155.961097]  ffff88103eb4e000 ffffffff82525380 ffff88103eb4ff28 ffffffff810391f0
[  155.961503]  ffff88103eb4ff18 e93585d02d707a09 0000000000000000 0000000000000000
[  155.981321]  ffff88103eb4ff48 ffffffff81c064f3 0000000000000000 8eaacf10758f15f5
[  156.001050] Call Trace:
[  156.001182]  [<ffffffff810391f0>] cpu_idle+0xae/0xcc
[  156.001412]  [<ffffffff81c064f3>] start_secondary+0xbd/0xbf
[  156.021073] Code: 00 00 48 89 d1 48 8d 83 38 e0 ff ff 0f 01 c8 0f ae f0 48 8b 83 38 e0 ff ff a8 08 75 10 e8 ec fd 06 00 31 c0 48 89 c1 fb 0f 01 c9 <eb> 06 e8 dc fd 06 00 fb 8b 05 0f 0a 4e 01 65 44 8b 24 25 30 c7 
[  156.041987] Call Trace:
[  156.061141]  [<ffffffff810391f0>] cpu_idle+0xae/0xcc
[  156.061381]  [<ffffffff81c064f3>] start_secondary+0xbd/0xbf
[  156.081061] NMI backtrace for cpu 61
[  156.081225] CPU 61 
[  156.081330] Modules linked in:
[  156.081504] 
[  156.100974] Pid: 0, comm: kworker/0:1 Not tainted 2.6.39-rc6-tip-yh-03030-gfb0b6a9 #985 Oracle Corporation  Sun Fire X4800/     
[  156.121073] RIP: 0010:[<ffffffff810409eb>]  [<ffffffff810409eb>] mwait_idle+0xef/0x169
[  156.121457] RSP: 0000:ffff88103eb65ee8  EFLAGS: 00000246
[  156.140977] RAX: 0000000000000000 RBX: ffff88103eb65fd8 RCX: 0000000000000000
[  156.141324] RDX: 0000000000000000 RSI: 0000000000000001 RDI: ffff88103eb5a2b0
[  156.160959] RBP: ffff88103eb65ef8 R08: 0000000000000000 R09: 0000000000000000
[  156.181152] R10: 0000000000000000 R11: ffff88103eb65ed8 R12: 000000000000003d
[  156.181478] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
[  156.211235] FS:  0000000000000000(0000) GS:ffff88807e200000(0000) knlGS:0000000000000000
[  156.231217] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  156.231480] CR2: 0000000000000000 CR3: 000000000239d000 CR4: 00000000000006e0
[  156.250814] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  156.270483] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  156.270804] Process kworker/0:1 (pid: 0, threadinfo ffff88103eb64000, task ffff88103eb5a2b0)
[  156.290623] Stack:
[  156.290726]  ffff88103eb64000 ffffffff82525380 ffff88103eb65f28 ffffffff810391f0
[  156.310588]  ffff88103eb65f18 dc7459780c591b2f 0000000000000000 0000000000000000
[  156.330348]  ffff88103eb65f48 ffffffff81c064f3 0000000000000000 fcd3245bcc0358f7
[  156.330776] Call Trace:
[  156.330889]  [<ffffffff810391f0>] cpu_idle+0xae/0xcc
[  156.351067]  [<ffffffff81c064f3>] start_secondary+0xbd/0xbf
[  156.351311] Code: 00 00 48 89 d1 48 8d 83 38 e0 ff ff 0f 01 c8 0f ae f0 48 8b 83 38 e0 ff ff a8 08 75 10 e8 ec fd 06 00 31 c0 48 89 c1 fb 0f 01 c9 <eb> 06 e8 dc fd 06 00 fb 8b 05 0f 0a 4e 01 65 44 8b 24 25 30 c7 
[  156.390822] Call Trace:
[  156.390937]  [<ffffffff810391f0>] cpu_idle+0xae/0xcc
[  156.411673]  [<ffffffff81c064f3>] start_secondary+0xbd/0xbf
[  156.411946] NMI backtrace for cpu 63
[  156.430138] CPU 63 
[  156.430240] Modules linked in:
[  156.430408] 
[  156.430501] Pid: 0, comm: kworker/0:1 Not tainted 2.6.39-rc6-tip-yh-03030-gfb0b6a9 #985 Oracle Corporation  Sun Fire X4800/     
[  156.450462] RIP: 0010:[<ffffffff810409eb>]  [<ffffffff810409eb>] mwait_idle+0xef/0x169
[  156.470261] RSP: 0000:ffff88103eb91ee8  EFLAGS: 00000246
[  156.470494] RAX: 0000000000000000 RBX: ffff88103eb91fd8 RCX: 0000000000000000
[  156.490247] RDX: 0000000000000000 RSI: 0000000000000001 RDI: ffff88103eb8a2b0
[  156.510060] RBP: ffff88103eb91ef8 R08: 0000000000000000 R09: 0000000000000000
[  156.510374] R10: 0000000000000000 R11: ffff88103eb91ed8 R12: 000000000000003f
[  156.530133] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
[  156.549932] FS:  0000000000000000(0000) GS:ffff88807e600000(0000) knlGS:0000000000000000
[  156.550274] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  156.570064] CR2: 0000000000000000 CR3: 000000000239d000 CR4: 00000000000006e0
[  156.589827] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  156.590146] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  156.609918] Process kworker/0:1 (pid: 0, threadinfo ffff88103eb90000, task ffff88103eb8a2b0)
[  156.629740] Stack:
[  156.629845]  ffff88103eb90000 ffffffff82525380 ffff88103eb91f28 ffffffff810391f0
[  156.630227]  ffff88103eb91f18 84ed79833eb6a337 0000000000000000 0000000000000000
[  156.650055]  ffff88103eb91f48 ffffffff81c064f3 0000000000000000 44a6529148d78bbf
[  156.669816] Call Trace:
[  156.669952]  [<ffffffff810391f0>] cpu_idle+0xae/0xcc
[  156.670175]  [<ffffffff81c064f3>] start_secondary+0xbd/0xbf
[  156.689798] Code: 00 00 48 89 d1 48 8d 83 38 e0 ff ff 0f 01 c8 0f ae f0 48 8b 83 38 e0 ff ff a8 08 75 10 e8 ec fd 06 00 31 c0 48 89 c1 fb 0f 01 c9 <eb> 06 e8 dc fd 06 00 fb 8b 05 0f 0a 4e 01 65 44 8b 24 25 30 c7 
[  156.729686] Call Trace:
[  156.729804]  [<ffffffff810391f0>] cpu_idle+0xae/0xcc
[  156.730036]  [<ffffffff81c064f3>] start_secondary+0xbd/0xbf
[  156.749627] NMI backtrace for cpu 54
[  156.749802] CPU 54 
[  156.749903] Modules linked in:
[  156.769487] 
[  156.769582] Pid: 0, comm: kworker/0:1 Not tainted 2.6.39-rc6-tip-yh-03030-gfb0b6a9 #985 Oracle Corporation  Sun Fire X4800/     
[  156.789570] RIP: 0010:[<ffffffff810409eb>]  [<ffffffff810409eb>] mwait_idle+0xef/0x169
[  156.809354] RSP: 0000:ffff88103eae9ee8  EFLAGS: 00000246
[  156.809583] RAX: 0000000000000000 RBX: ffff88103eae9fd8 RCX: 0000000000000000
[  156.829385] RDX: 0000000000000000 RSI: 0000000000000001 RDI: ffff88103eae0000
[  156.829698] RBP: ffff88103eae9ef8 R08: 0000000000000000 R09: 0000000000000000
[  156.849455] R10: 0000000000000000 R11: ffff88103eae9ed8 R12: 0000000000000036
[  156.869245] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
[  156.869559] FS:  0000000000000000(0000) GS:ffff88707ea00000(0000) knlGS:0000000000000000
[  156.889381] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  156.889640] CR2: 0000000000000000 CR3: 000000000239d000 CR4: 00000000000006e0
[  156.909545] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  156.929239] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  156.929560] Process kworker/0:1 (pid: 0, threadinfo ffff88103eae8000, task ffff88103eae0000)
[  156.949369] Stack:
[  156.949462]  ffff88103eae8000 ffffffff82525380 ffff88103eae9f28 ffffffff810391f0
[  156.969339]  ffff88103eae9f18 8234c77185011823 0000000000000000 0000000000000000
[  156.989095]  ffff88103eae9f48 ffffffff81c064f3 0000000000000000 72311f7455859eb1
[  156.989512] Call Trace:
[  157.008980]  [<ffffffff810391f0>] cpu_idle+0xae/0xcc
[  157.009215]  [<ffffffff81c064f3>] start_secondary+0xbd/0xbf
[  157.028908] Code: 00 00 48 89 d1 48 8d 83 38 e0 ff ff 0f 01 c8 0f ae f0 48 8b 83 38 e0 ff ff a8 08 75 10 e8 ec fd 06 00 31 c0 48 89 c1 fb 0f 01 c9 <eb> 06 e8 dc fd 06 00 fb 8b 05 0f 0a 4e 01 65 44 8b 24 25 30 c7 
[  157.051654] Call Trace:
[  157.051780]  [<ffffffff810391f0>] cpu_idle+0xae/0xcc
[  157.074210]  [<ffffffff81c064f3>] start_secondary+0xbd/0xbf
[  157.074460] NMI backtrace for cpu 55
[  157.088911] CPU 55 
[  157.089011] Modules linked in:
[  157.089197] 
[  157.089273] Pid: 0, comm: kworker/0:1 Not tainted 2.6.39-rc6-tip-yh-03030-gfb0b6a9 #985 Oracle Corporation  Sun Fire X4800/     
[  157.109258] RIP: 0010:[<ffffffff810409eb>]  [<ffffffff810409eb>] mwait_idle+0xef/0x169
[  157.129339] RSP: 0000:ffff88103eaefee8  EFLAGS: 00000246
[  157.148954] RAX: 0000000000000000 RBX: ffff88103eaeffd8 RCX: 0000000000000000
[  157.149287] RDX: 0000000000000000 RSI: 0000000000000001 RDI: ffff88103eaf8000
[  157.168798] RBP: ffff88103eaefef8 R08: 0000000000000000 R09: 0000000000000000
[  157.188599] R10: 0000000000000000 R11: ffff88103eaefed8 R12: 0000000000000037
[  157.188918] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
[  157.211302] FS:  0000000000000000(0000) GS:ffff88707ec00000(0000) knlGS:0000000000000000
[  157.228522] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  157.228784] CR2: 0000000000000000 CR3: 000000000239d000 CR4: 00000000000006e0
[  157.248559] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  157.248868] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  157.268646] Process kworker/0:1 (pid: 0, threadinfo ffff88103eaee000, task ffff88103eaf8000)
[  157.288488] Stack:
[  157.288583]  ffff88103eaee000 ffffffff82525380 ffff88103eaeff28 ffffffff810391f0
[  157.308388]  ffff88103eaeff18 9e7c99cf43a1a877 0000000000000000 0000000000000000
[  157.308799]  ffff88103eaeff48 ffffffff81c064f3 0000000000000000 d8c1df20b1dbb268
[  157.328592] Call Trace:
[  157.328706]  [<ffffffff810391f0>] cpu_idle+0xae/0xcc
[  157.348307]  [<ffffffff81c064f3>] start_secondary+0xbd/0xbf
[  157.348584] Code: 00 00 48 89 d1 48 8d 83 38 e0 ff ff 0f 01 c8 0f ae f0 48 8b 83 38 e0 ff ff a8 08 75 10 e8 ec fd 06 00 31 c0 48 89 c1 fb 0f 01 c9 <eb> 06 e8 dc fd 06 00 fb 8b 05 0f 0a 4e 01 65 44 8b 24 25 30 c7 
[  157.388555] Call Trace:
[  157.388673]  [<ffffffff810391f0>] cpu_idle+0xae/0xcc
[  157.408129]  [<ffffffff81c064f3>] start_secondary+0xbd/0xbf
[  157.408368] NMI backtrace for cpu 62
[  157.408547] CPU 62 
[  157.428099] Modules linked in:
[  157.428289] 
[  157.428380] Pid: 0, comm: kworker/0:1 Not tainted 2.6.39-rc6-tip-yh-03030-gfb0b6a9 #985 Oracle Corporation  Sun Fire X4800/     
[  157.448323] RIP: 0010:[<ffffffff810409eb>]  [<ffffffff810409eb>] mwait_idle+0xef/0x169
[  157.468105] RSP: 0000:ffff88103eb83ee8  EFLAGS: 00000246
[  157.468384] RAX: 0000000000000000 RBX: ffff88103eb83fd8 RCX: 0000000000000000
[  157.488108] RDX: 0000000000000000 RSI: 0000000000000001 RDI: ffff88103eb722b0
[  157.488454] RBP: ffff88103eb83ef8 R08: 0000000000000000 R09: 0000000000000000
[  157.508219] R10: 0000000000000000 R11: ffff88103eb83ed8 R12: 000000000000003e
[  157.528004] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
[  157.528368] FS:  0000000000000000(0000) GS:ffff88807e400000(0000) knlGS:0000000000000000
[  157.548156] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  157.567893] CR2: 0000000000000000 CR3: 000000000239d000 CR4: 00000000000006e0
[  157.568206] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  157.587971] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  157.607746] Process kworker/0:1 (pid: 0, threadinfo ffff88103eb82000, task ffff88103eb722b0)
[  157.608116] Stack:
[  157.628263]  ffff88103eb82000 ffffffff82525380 ffff88103eb83f28 ffffffff810391f0
[  157.628758]  ffff88103eb83f18 4e93b1db6fe4c26f 0000000000000000 0000000000000000
[  157.647847]  ffff88103eb83f48 ffffffff81c064f3 0000000000000000 cc3ee426a493ae7b
[  157.667637] Call Trace:
[  157.667758]  [<ffffffff810391f0>] cpu_idle+0xae/0xcc
[  157.668008]  [<ffffffff81c064f3>] start_secondary+0xbd/0xbf
[  157.687739] Code: 00 00 48 89 d1 48 8d 83 38 e0 ff ff 0f 01 c8 0f ae f0 48 8b 83 38 e0 ff ff a8 08 75 10 e8 ec fd 06 00 31 c0 48 89 c1 fb 0f 01 c9 <eb> 06 e8 dc fd 06 00 fb 8b 05 0f 0a 4e 01 65 44 8b 24 25 30 c7 
[  157.709742] Call Trace:
[  157.727548]  [<ffffffff810391f0>] cpu_idle+0xae/0xcc
[  157.727762]  [<ffffffff81c064f3>] start_secondary+0xbd/0xbf
[  157.747486] NMI backtrace for cpu 64
[  157.747681] CPU 64 
[  157.747771] Modules linked in:
[  157.747974] 
[  157.767397] Pid: 0, comm: kworker/0:1 Not tainted 2.6.39-rc6-tip-yh-03030-gfb0b6a9 #985 Oracle Corporation  Sun Fire X4800/     
[  157.787407] RIP: 0010:[<ffffffff810409eb>]  [<ffffffff810409eb>] mwait_idle+0xef/0x169
[  157.787827] RSP: 0000:ffff88103ebbdee8  EFLAGS: 00000246
[  157.807451] RAX: 0000000000000000 RBX: ffff88103ebbdfd8 RCX: 0000000000000000
[  157.807774] RDX: 0000000000000000 RSI: 0000000000000001 RDI: ffff88103ebc0000
[  157.827550] RBP: ffff88103ebbdef8 R08: 0000000000000000 R09: 0000000000000000
[  157.847363] R10: 0000000000000000 R11: ffff88103ebbded8 R12: 0000000000000040
[  157.847704] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
[  157.867425] FS:  0000000000000000(0000) GS:ffff88107ee00000(0000) knlGS:0000000000000000
[  157.887265] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  157.887530] CR2: 0000000000000000 CR3: 000000000239d000 CR4: 00000000000006e0
[  157.907307] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  157.927079] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  157.927445] Process kworker/0:1 (pid: 0, threadinfo ffff88103ebbc000, task ffff88103ebc0000)
[  157.947240] Stack:
[  157.947345]  ffff88103ebbc000 ffffffff82525380 ffff88103ebbdf28 ffffffff810391f0
[  157.967173]  ffff88103ebbdf18 da2a35009143e8db 0000000000000000 0000000000000000
[  157.967569]  ffff88103ebbdf48 ffffffff81c064f3 0000000000000000 e202c1b2447d6be3
[  157.987308] Call Trace:
[  157.987435]  [<ffffffff810391f0>] cpu_idle+0xae/0xcc
[  158.007065]  [<ffffffff81c064f3>] start_secondary+0xbd/0xbf
[  158.007361] Code: 00 00 48 89 d1 48 8d 83 38 e0 ff ff 0f 01 c8 0f ae f0 48 8b 83 38 e0 ff ff a8 08 75 10 e8 ec fd 06 00 31 c0 48 89 c1 fb 0f 01 c9 <eb> 06 e8 dc fd 06 00 fb 8b 05 0f 0a 4e 01 65 44 8b 24 25 30 c7 
[  158.047366] Call Trace:
[  158.047483]  [<ffffffff810391f0>] cpu_idle+0xae/0xcc
[  158.067043]  [<ffffffff81c064f3>] start_secondary+0xbd/0xbf
[  158.067286] NMI backtrace for cpu 67
[  158.086766] CPU 67 
[  158.086860] Modules linked in:
[  158.087027] 
[  158.087130] Pid: 0, comm: kworker/0:1 Not tainted 2.6.39-rc6-tip-yh-03030-gfb0b6a9 #985 Oracle Corporation  Sun Fire X4800/     
[  158.107106] RIP: 0010:[<ffffffff810409eb>]  [<ffffffff810409eb>] mwait_idle+0xef/0x169
[  158.127207] RSP: 0000:ffff88103e44dee8  EFLAGS: 00000246
[  158.127455] RAX: 0000000000000000 RBX: ffff88103e44dfd8 RCX: 0000000000000000
[  158.147037] RDX: 0000000000000000 RSI: 0000000000000001 RDI: ffff88103e450000
[  158.166786] RBP: ffff88103e44def8 R08: 0000000000000000 R09: 0000000000000000
[  158.167114] R10: 0000000000000000 R11: ffff88103e44ded8 R12: 0000000000000043
[  158.186752] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
[  158.206566] FS:  0000000000000000(0000) GS:ffff88107f400000(0000) knlGS:0000000000000000
[  158.206952] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  158.226680] CR2: 0000000000000000 CR3: 000000000239d000 CR4: 00000000000006e0
[  158.227004] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  158.246752] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  158.266520] Process kworker/0:1 (pid: 0, threadinfo ffff88103e44c000, task ffff88103e450000)
[  158.286347] Stack:
[  158.286452]  ffff88103e44c000 ffffffff82525380 ffff88103e44df28 ffffffff810391f0
[  158.286848]  ffff88103e44df18 ebf5aa6367d481b1 0000000000000000 0000000000000000
[  158.306616]  ffff88103e44df48 ffffffff81c064f3 0000000000000000 27a37715890bf64b
[  158.326389] Call Trace:
[  158.326526]  [<ffffffff810391f0>] cpu_idle+0xae/0xcc
[  158.326802]  [<ffffffff81c064f3>] start_secondary+0xbd/0xbf
[  158.348029] Code: 00 00 48 89 d1 48 8d 83 38 e0 ff ff 0f 01 c8 0f ae f0 48 8b 83 38 e0 ff ff a8 08 75 10 e8 ec fd 06 00 31 c0 48 89 c1 fb 0f 01 c9 <eb> 06 e8 dc fd 06 00 fb 8b 05 0f 0a 4e 01 65 44 8b 24 25 30 c7 
[  158.386263] Call Trace:
[  158.386391]  [<ffffffff810391f0>] cpu_idle+0xae/0xcc
[  158.386626]  [<ffffffff81c064f3>] start_secondary+0xbd/0xbf
[  158.406330] NMI backtrace for cpu 65
[  158.406505] CPU 65 
[  158.406602] Modules linked in:
[  158.426114] 
[  158.426190] Pid: 0, comm: kworker/0:1 Not tainted 2.6.39-rc6-tip-yh-03030-gfb0b6a9 #985 Oracle Corporation  Sun Fire X4800/     
[  158.446186] RIP: 0010:[<ffffffff810409eb>]  [<ffffffff810409eb>] mwait_idle+0xef/0x169
[  158.446590] RSP: 0000:ffff88103ebe7ee8  EFLAGS: 00000246
[  158.466219] RAX: 0000000000000000 RBX: ffff88103ebe7fd8 RCX: 0000000000000000
[  158.485966] RDX: 0000000000000000 RSI: 0000000000000001 RDI: ffff88103ebe8000
[  158.486302] RBP: ffff88103ebe7ef8 R08: 0000000000000000 R09: 0000000000000000
[  158.506073] R10: 0000000000000000 R11: ffff88103ebe7ed8 R12: 0000000000000041
[  158.525901] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
[  158.526203] FS:  0000000000000000(0000) GS:ffff88107f000000(0000) knlGS:0000000000000000
[  158.546011] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  158.546279] CR2: 0000000000000000 CR3: 000000000239d000 CR4: 00000000000006e0
[  158.566057] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  158.585859] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  158.586252] Process kworker/0:1 (pid: 0, threadinfo ffff88103ebe6000, task ffff88103ebe8000)
[  158.606014] Stack:
[  158.606118]  ffff88103ebe6000 ffffffff82525380 ffff88103ebe7f28 ffffffff810391f0
[  158.636016]  ffff88103ebe7f18 26ab9a4774f02d67 0000000000000000 0000000000000000
[  158.656062]  ffff88103ebe7f48 ffffffff81c064f3 0000000000000000 3a137c915fdefa51
[  158.656439] Call Trace:
[  158.675780]  [<ffffffff810391f0>] cpu_idle+0xae/0xcc
[  158.676008]  [<ffffffff81c064f3>] start_secondary+0xbd/0xbf
[  158.695748] Code: 00 00 48 89 d1 48 8d 83 38 e0 ff ff 0f 01 c8 0f ae f0 48 8b 83 38 e0 ff ff a8 08 75 10 e8 ec fd 06 00 31 c0 48 89 c1 fb 0f 01 c9 <eb> 06 e8 dc fd 06 00 fb 8b 05 0f 0a 4e 01 65 44 8b 24 25 30 c7 
[  158.716263] Call Trace:
[  158.716384]  [<ffffffff810391f0>] cpu_idle+0xae/0xcc
[  158.735749]  [<ffffffff81c064f3>] start_secondary+0xbd/0xbf
[  158.735985] NMI backtrace for cpu 66
[  158.755480] CPU 66 
[  158.755581] Modules linked in:
[  158.755756] 
[  158.755846] Pid: 0, comm: kworker/0:1 Not tainted 2.6.39-rc6-tip-yh-03030-gfb0b6a9 #985 Oracle Corporation  Sun Fire X4800/     
[  158.775821] RIP: 0010:[<ffffffff810409eb>]  [<ffffffff810409eb>] mwait_idle+0xef/0x169
[  158.795583] RSP: 0000:ffff88103e42dee8  EFLAGS: 00000246
[  158.815274] RAX: 0000000000000000 RBX: ffff88103e42dfd8 RCX: 0000000000000000
[  158.815608] RDX: 0000000000000000 RSI: 0000000000000001 RDI: ffff88103e430000
[  158.835420] RBP: ffff88103e42def8 R08: 0000000000000000 R09: 0000000000000000
[  158.835734] R10: 0000000000000000 R11: ffff88103e42ded8 R12: 0000000000000042
[  158.855505] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
[  158.875267] FS:  0000000000000000(0000) GS:ffff88107f200000(0000) knlGS:0000000000000000
[  158.895089] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  158.895353] CR2: 0000000000000000 CR3: 000000000239d000 CR4: 00000000000006e0
[  158.915139] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  158.915459] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  158.935242] Process kworker/0:1 (pid: 0, threadinfo ffff88103e42c000, task ffff88103e430000)
[  158.955078] Stack:
[  158.955172]  ffff88103e42c000 ffffffff82525380 ffff88103e42df28 ffffffff810391f0
[  158.974989]  ffff88103e42df18 ecd678057994030d 0000000000000000 0000000000000000
[  158.975385]  ffff88103e42df48 ffffffff81c064f3 0000000000000000 6f39f013d9ac3289
[  158.996217] Call Trace:
[  158.996338]  [<ffffffff810391f0>] cpu_idle+0xae/0xcc
[  159.014900]  [<ffffffff81c064f3>] start_secondary+0xbd/0xbf
[  159.015180] Code: 00 00 48 89 d1 48 8d 83 38 e0 ff ff 0f 01 c8 0f ae f0 48 8b 83 38 e0 ff ff a8 08 75 10 e8 ec fd 06 00 31 c0 48 89 c1 fb 0f 01 c9 <eb> 06 e8 dc fd 06 00 fb 8b 05 0f 0a 4e 01 65 44 8b 24 25 30 c7 
[  159.055093] Call Trace:
[  159.055231]  [<ffffffff810391f0>] cpu_idle+0xae/0xcc
[  159.055486]  [<ffffffff81c064f3>] start_secondary+0xbd/0xbf
[  159.075260] NMI backtrace for cpu 69
[  159.075456] CPU 69 
[  159.075552] Modules linked in:
[  159.094880] 
[  159.094964] Pid: 0, comm: kworker/0:1 Not tainted 2.6.39-rc6-tip-yh-03030-gfb0b6a9 #985 Oracle Corporation  Sun Fire X4800/     
[  159.115131] RIP: 0010:[<ffffffff810409eb>]  [<ffffffff810409eb>] mwait_idle+0xef/0x169
[  159.134875] RSP: 0000:ffff88103e4a3ee8  EFLAGS: 00000246
[  159.135116] RAX: 0000000000000000 RBX: ffff88103e4a3fd8 RCX: 0000000000000000
[  159.154817] RDX: 0000000000000000 RSI: 0000000000000001 RDI: ffff88103e4a8000
[  159.155159] RBP: ffff88103e4a3ef8 R08: 0000000000000000 R09: 0000000000000000
[  159.174816] R10: 0000000000000000 R11: ffff88103e4a3ed8 R12: 0000000000000045
[  159.194596] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
[  159.194939] FS:  0000000000000000(0000) GS:ffff88107f800000(0000) knlGS:0000000000000000
[  159.214755] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  159.234471] CR2: 0000000000000000 CR3: 000000000239d000 CR4: 00000000000006e0
[  159.234789] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  159.254603] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  159.274337] Process kworker/0:1 (pid: 0, threadinfo ffff88103e4a2000, task ffff88103e4a8000)
[  159.274713] Stack:
[  159.294270]  ffff88103e4a2000 ffffffff82525380 ffff88103e4a3f28 ffffffff810391f0
[  159.294680]  ffff88103e4a3f18 12ef20a5c0174c7c 0000000000000000 0000000000000000
[  159.314468]  ffff88103e4a3f48 ffffffff81c064f3 0000000000000000 2874467214a4e39e
[  159.334199] Call Trace:
[  159.334330]  [<ffffffff810391f0>] cpu_idle+0xae/0xcc
[  159.334598]  [<ffffffff81c064f3>] start_secondary+0xbd/0xbf
[  159.354245] Code: 00 00 48 89 d1 48 8d 83 38 e0 ff ff 0f 01 c8 0f ae f0 48 8b 83 38 e0 ff ff a8 08 75 10 e8 ec fd 06 00 31 c0 48 89 c1 fb 0f 01 c9 <eb> 06 e8 dc fd 06 00 fb 8b 05 0f 0a 4e 01 65 44 8b 24 25 30 c7 
[  159.375041] Call Trace:
[  159.394132]  [<ffffffff810391f0>] cpu_idle+0xae/0xcc
[  159.394358]  [<ffffffff81c064f3>] start_secondary+0xbd/0xbf
[  159.414070] NMI backtrace for cpu 71
[  159.414251] CPU 71 
[  159.414338] Modules linked in:
[  159.414504] 
[  159.414591] Pid: 0, comm: kworker/0:1 Not tainted 2.6.39-rc6-tip-yh-03030-gfb0b6a9 #985 Oracle Corporation  Sun Fire X4800/     
[  159.453983] RIP: 0010:[<ffffffff810409eb>]  [<ffffffff810409eb>] mwait_idle+0xef/0x169
[  159.454366] RSP: 0000:ffff88103e4edee8  EFLAGS: 00000246
[  159.474019] RAX: 0000000000000000 RBX: ffff88103e4edfd8 RCX: 0000000000000000
[  159.474338] RDX: 0000000000000000 RSI: 0000000000000001 RDI: ffff88103e4f0000
[  159.494112] RBP: ffff88103e4edef8 R08: 0000000000000000 R09: 0000000000000000
[  159.513924] R10: 0000000000000000 R11: ffff88103e4eded8 R12: 0000000000000047
[  159.514269] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
[  159.534030] FS:  0000000000000000(0000) GS:ffff88107fc00000(0000) knlGS:0000000000000000
[  159.553842] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  159.554154] CR2: 0000000000000000 CR3: 000000000239d000 CR4: 00000000000006e0
[  159.573926] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  159.593668] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  159.594006] Process kworker/0:1 (pid: 0, threadinfo ffff88103e4ec000, task ffff88103e4f0000)
[  159.613854] Stack:
[  159.613968]  ffff88103e4ec000 ffffffff82525380 ffff88103e4edf28 ffffffff810391f0
[  159.633749]  ffff88103e4edf18 fe58eb5636563f39 0000000000000000 0000000000000000
[  159.634152]  ffff88103e4edf48 ffffffff81c064f3 0000000000000000 dfdfb102a569daf8
[  159.654863] Call Trace:
[  159.655000]  [<ffffffff810391f0>] cpu_idle+0xae/0xcc
[  159.673642]  [<ffffffff81c064f3>] start_secondary+0xbd/0xbf
[  159.673921] Code: 00 00 48 89 d1 48 8d 83 38 e0 ff ff 0f 01 c8 0f ae f0 48 8b 83 38 e0 ff ff a8 08 75 10 e8 ec fd 06 00 31 c0 48 89 c1 fb 0f 01 c9 <eb> 06 e8 dc fd 06 00 fb 8b 05 0f 0a 4e 01 65 44 8b 24 25 30 c7 
[  159.713904] Call Trace:
[  159.714028]  [<ffffffff810391f0>] cpu_idle+0xae/0xcc
[  159.733478]  [<ffffffff81c064f3>] start_secondary+0xbd/0xbf
[  159.733723] NMI backtrace for cpu 68
[  159.733904] CPU 68 
[  159.753420] Modules linked in:
[  159.753610] 
[  159.753689] Pid: 0, comm: kworker/0:1 Not tainted 2.6.39-rc6-tip-yh-03030-gfb0b6a9 #985 Oracle Corporation  Sun Fire X4800/     
[  159.773674] RIP: 0010:[<ffffffff810409eb>]  [<ffffffff810409eb>] mwait_idle+0xef/0x169
[  159.793424] RSP: 0000:ffff88103e479ee8  EFLAGS: 00000246
[  159.793666] RAX: 0000000000000000 RBX: ffff88103e479fd8 RCX: 0000000000000000
[  159.813458] RDX: 0000000000000000 RSI: 0000000000000001 RDI: ffff88103e470000
[  159.833223] RBP: ffff88103e479ef8 R08: 0000000000000000 R09: 0000000000000000
[  159.833564] R10: 0000000000000000 R11: ffff88103e479ed8 R12: 0000000000000044
[  159.853338] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
[  159.873135] FS:  0000000000000000(0000) GS:ffff88107f600000(0000) knlGS:0000000000000000
[  159.873502] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  159.893207] CR2: 0000000000000000 CR3: 000000000239d000 CR4: 00000000000006e0
[  159.893574] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  159.913329] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  159.933094] Process kworker/0:1 (pid: 0, threadinfo ffff88103e478000, task ffff88103e470000)
[  159.952924] Stack:
[  159.953033]  ffff88103e478000 ffffffff82525380 ffff88103e479f28 ffffffff810391f0
[  159.953469]  ffff88103e479f18 e7234dc0ddbdb12e 0000000000000000 0000000000000000
[  159.973235]  ffff88103e479f48 ffffffff81c064f3 0000000000000000 253694480af14bae
[  159.992964] Call Trace:
[  159.993116]  [<ffffffff810391f0>] cpu_idle+0xae/0xcc
[  159.993380]  [<ffffffff81c064f3>] start_secondary+0xbd/0xbf
[  160.012990] Code: 00 00 48 89 d1 48 8d 83 38 e0 ff ff 0f 01 c8 0f ae f0 48 8b 83 38 e0 ff ff a8 08 75 10 e8 ec fd 06 00 31 c0 48 89 c1 fb 0f 01 c9 <eb> 06 e8 dc fd 06 00 fb 8b 05 0f 0a 4e 01 65 44 8b 24 25 30 c7 
[  160.052829] Call Trace:
[  160.052958]  [<ffffffff810391f0>] cpu_idle+0xae/0xcc
[  160.053236]  [<ffffffff81c064f3>] start_secondary+0xbd/0xbf
[  160.072848] NMI backtrace for cpu 70
[  160.073062] CPU 70 
[  160.073154] Modules linked in:
[  160.092815] 
[  160.092896] Pid: 0, comm: kworker/0:1 Not tainted 2.6.39-rc6-tip-yh-03030-gfb0b6a9 #985 Oracle Corporation  Sun Fire X4800/     
[  160.112764] RIP: 0010:[<ffffffff810409eb>]  [<ffffffff810409eb>] mwait_idle+0xef/0x169
[  160.113213] RSP: 0000:ffff88103e4c5ee8  EFLAGS: 00000246
[  160.133168] RAX: 0000000000000000 RBX: ffff88103e4c5fd8 RCX: 0000000000000000
[  160.152740] RDX: 0000000000000000 RSI: 0000000000000001 RDI: ffff88103e4c8000
[  160.153090] RBP: ffff88103e4c5ef8 R08: 0000000000000000 R09: 0000000000000000
[  160.172802] R10: 0000000000000000 R11: ffff88103e4c5ed8 R12: 0000000000000046
[  160.173147] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
[  160.192773] FS:  0000000000000000(0000) GS:ffff88107fa00000(0000) knlGS:0000000000000000
[  160.212598] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  160.212864] CR2: 0000000000000000 CR3: 000000000239d000 CR4: 00000000000006e0
[  160.232649] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  160.252423] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  160.252734] Process kworker/0:1 (pid: 0, threadinfo ffff88103e4c4000, task ffff88103e4c8000)
[  160.272600] Stack:
[  160.272704]  ffff88103e4c4000 ffffffff82525380 ffff88103e4c5f28 ffffffff810391f0
[  160.293314]  ffff88103e4c5f18 6e7cc5eba8cea412 0000000000000000 0000000000000000
[  160.312278]  ffff88103e4c5f48 ffffffff81c064f3 0000000000000000 23ba843c07b63fab
[  160.312674] Call Trace:
[  160.332162]  [<ffffffff810391f0>] cpu_idle+0xae/0xcc
[  160.332416]  [<ffffffff81c064f3>] start_secondary+0xbd/0xbf
[  160.332714] Code: 00 00 48 89 d1 48 8d 83 38 e0 ff ff 0f 01 c8 0f ae f0 48 8b 83 38 e0 ff ff a8 08 75 10 e8 ec fd 06 00 31 c0 48 89 c1 fb 0f 01 c9 <eb> 06 e8 dc fd 06 00 fb 8b 05 0f 0a 4e 01 65 44 8b 24 25 30 c7 
[  160.372721] Call Trace:
[  160.372865]  [<ffffffff810391f0>] cpu_idle+0xae/0xcc
[  160.392225]  [<ffffffff81c064f3>] start_secondary+0xbd/0xbf
[  160.392540] NMI backtrace for cpu 79
[  160.412090] CPU 79 
[  160.412182] Modules linked in:
[  160.412350] 
[  160.412431] Pid: 0, comm: kworker/0:1 Not tainted 2.6.39-rc6-tip-yh-03030-gfb0b6a9 #985 Oracle Corporation  Sun Fire X4800/     
[  160.432387] RIP: 0010:[<ffffffff810409eb>]  [<ffffffff810409eb>] mwait_idle+0xef/0x169
[  160.452168] RSP: 0000:ffff88103e591ee8  EFLAGS: 00000246
[  160.471869] RAX: 0000000000000000 RBX: ffff88103e591fd8 RCX: 0000000000000000
[  160.472193] RDX: 0000000000000000 RSI: 0000000000000001 RDI: ffff88103e588000
[  160.491987] RBP: ffff88103e591ef8 R08: 0000000000000000 R09: 0000000000000000
[  160.492302] R10: 0000000000000000 R11: ffff88103e591ed8 R12: 000000000000004f
[  160.512076] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
[  160.531890] FS:  0000000000000000(0000) GS:ffff88207fc00000(0000) knlGS:0000000000000000
[  160.532287] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  160.551961] CR2: 0000000000000000 CR3: 000000000239d000 CR4: 00000000000006e0
[  160.571758] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  160.572094] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  160.591836] Process kworker/0:1 (pid: 0, threadinfo ffff88103e590000, task ffff88103e588000)
[  160.611673] Stack:
[  160.611779]  ffff88103e590000 ffffffff82525380 ffff88103e591f28 ffffffff810391f0
[  160.631590]  ffff88103e591f18 9b70b21e28590e01 0000000000000000 0000000000000000
[  160.631973]  ffff88103e591f48 ffffffff81c064f3 0000000000000000 db865ef5c8a39a71
[  160.651715] Call Trace:
[  160.651846]  [<ffffffff810391f0>] cpu_idle+0xae/0xcc
[  160.671492]  [<ffffffff81c064f3>] start_secondary+0xbd/0xbf
[  160.671751] Code: 00 00 48 89 d1 48 8d 83 38 e0 ff ff 0f 01 c8 0f ae f0 48 8b 83 38 e0 ff ff a8 08 75 10 e8 ec fd 06 00 31 c0 48 89 c1 fb 0f 01 c9 <eb> 06 e8 dc fd 06 00 fb 8b 05 0f 0a 4e 01 65 44 8b 24 25 30 c7 
[  160.711666] Call Trace:
[  160.711789]  [<ffffffff810391f0>] cpu_idle+0xae/0xcc
[  160.712020]  [<ffffffff81c064f3>] start_secondary+0xbd/0xbf
[  160.731566] NMI backtrace for cpu 73
[  160.731752] CPU 73 
[  160.731856] Modules linked in:
[  160.751431] 
[  160.751510] Pid: 0, comm: kworker/0:1 Not tainted 2.6.39-rc6-tip-yh-03030-gfb0b6a9 #985 Oracle Corporation  Sun Fire X4800/     
[  160.771486] RIP: 0010:[<ffffffff810409eb>]  [<ffffffff810409eb>] mwait_idle+0xef/0x169
[  160.791281] RSP: 0018:ffff88103e521ee8  EFLAGS: 00000246
[  160.791528] RAX: 0000000000000000 RBX: ffff88103e521fd8 RCX: 0000000000000000
[  160.811393] RDX: 0000000000000000 RSI: 0000000000000001 RDI: ffff88103e518000
[  160.811732] RBP: ffff88103e521ef8 R08: 0000000000000000 R09: 0000000000000000
[  160.831426] R10: 0000000000000000 R11: ffff88103e521ed8 R12: 0000000000000049
[  160.851216] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
[  160.851587] FS:  0000000000000000(0000) GS:ffff88207f000000(0000) knlGS:0000000000000000
[  160.871381] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  160.891082] CR2: 0000000000000000 CR3: 000000000239d000 CR4: 00000000000006e0
[  160.891408] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  160.911154] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  160.936751] Process kworker/0:1 (pid: 0, threadinfo ffff88103e520000, task ffff88103e518000)
[  160.937268] Stack:
[  160.937369]  ffff88103e520000 ffffffff82525380 ffff88103e521f28 ffffffff810391f0
[  160.951285]  ffff88103e521f18 d8b1686f1d48fddc 0000000000000000 0000000000000000
[  160.971049]  ffff88103e521f48 ffffffff81c064f3 0000000000000000 8790dbe0cba0e12f
[  160.971480] Call Trace:
[  160.990933]  [<ffffffff810391f0>] cpu_idle+0xae/0xcc
[  160.991198]  [<ffffffff81c064f3>] start_secondary+0xbd/0xbf
[  161.010845] Code: 00 00 48 89 d1 48 8d 83 38 e0 ff ff 0f 01 c8 0f ae f0 48 8b 83 38 e0 ff ff a8 08 75 10 e8 ec fd 06 00 31 c0 48 89 c1 fb 0f 01 c9 <eb> 06 e8 dc fd 06 00 fb 8b 05 0f 0a 4e 01 65 44 8b 24 25 30 c7 
[  161.031582] Call Trace:
[  161.050750]  [<ffffffff810391f0>] cpu_idle+0xae/0xcc
[  161.050978]  [<ffffffff81c064f3>] start_secondary+0xbd/0xbf
[  161.070683] NMI backtrace for cpu 75
[  161.070855] CPU 75 
[  161.070954] Modules linked in:
[  161.071122] 
[  161.071222] Pid: 0, comm: kworker/0:1 Not tainted 2.6.39-rc6-tip-yh-03030-gfb0b6a9 #985 Oracle Corporation  Sun Fire X4800/     
[  161.091281] RIP: 0010:[<ffffffff810409eb>]  [<ffffffff810409eb>] mwait_idle+0xef/0x169
[  161.111280] RSP: 0000:ffff88103e535ee8  EFLAGS: 00000246
[  161.130841] RAX: 0000000000000000 RBX: ffff88103e535fd8 RCX: 0000000000000000
[  161.131158] RDX: 0000000000000000 RSI: 0000000000000001 RDI: ffff88103e538000
[  161.150892] RBP: ffff88103e535ef8 R08: 0000000000000000 R09: 0000000000000000
[  161.170698] R10: 0000000000000000 R11: ffff88103e535ed8 R12: 000000000000004b
[  161.171032] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
[  161.190633] FS:  0000000000000000(0000) GS:ffff88207f400000(0000) knlGS:0000000000000000
[  161.210473] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  161.210738] CR2: 0000000000000000 CR3: 000000000239d000 CR4: 00000000000006e0
[  161.230638] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  161.230942] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  161.250591] Process kworker/0:1 (pid: 0, threadinfo ffff88103e534000, task ffff88103e538000)
[  161.270454] Stack:
[  161.270558]  ffff88103e534000 ffffffff82525380 ffff88103e535f28 ffffffff810391f0
[  161.290363]  ffff88103e535f18 cd61f3b922c9e5b4 0000000000000000 0000000000000000
[  161.290748]  ffff88103e535f48 ffffffff81c064f3 0000000000000000 029d491e869419ff
[  161.310478] Call Trace:
[  161.310611]  [<ffffffff810391f0>] cpu_idle+0xae/0xcc
[  161.330370]  [<ffffffff81c064f3>] start_secondary+0xbd/0xbf
[  161.330658] Code: 00 00 48 89 d1 48 8d 83 38 e0 ff ff 0f 01 c8 0f ae f0 48 8b 83 38 e0 ff ff a8 08 75 10 e8 ec fd 06 00 31 c0 48 89 c1 fb 0f 01 c9 <eb> 06 e8 dc fd 06 00 fb 8b 05 0f 0a 4e 01 65 44 8b 24 25 30 c7 
[  161.370461] Call Trace:
[  161.370589]  [<ffffffff810391f0>] cpu_idle+0xae/0xcc
[  161.390052]  [<ffffffff81c064f3>] start_secondary+0xbd/0xbf
[  161.390316] NMI backtrace for cpu 77
[  161.390486] CPU 77 
[  161.410029] Modules linked in:
[  161.410209] 
[  161.410297] Pid: 0, comm: kworker/0:1 Not tainted 2.6.39-rc6-tip-yh-03030-gfb0b6a9 #985 Oracle Corporation  Sun Fire X4800/     
[  161.430242] RIP: 0010:[<ffffffff810409eb>]  [<ffffffff810409eb>] mwait_idle+0xef/0x169
[  161.450041] RSP: 0000:ffff88103e55dee8  EFLAGS: 00000246
[  161.450268] RAX: 0000000000000000 RBX: ffff88103e55dfd8 RCX: 0000000000000000
[  161.470065] RDX: 0000000000000000 RSI: 0000000000000001 RDI: ffff88103e560000
[  161.489845] RBP: ffff88103e55def8 R08: 0000000000000000 R09: 0000000000000000
[  161.490169] R10: 0000000000000000 R11: ffff88103e55ded8 R12: 000000000000004d
[  161.509948] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
[  161.529741] FS:  0000000000000000(0000) GS:ffff88207f800000(0000) knlGS:0000000000000000
[  161.530113] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  161.549816] CR2: 0000000000000000 CR3: 000000000239d000 CR4: 00000000000006e0
[  161.550135] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  161.570786] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  161.589747] Process kworker/0:1 (pid: 0, threadinfo ffff88103e55c000, task ffff88103e560000)
[  161.590145] Stack:
[  161.609633]  ffff88103e55c000 ffffffff82525380 ffff88103e55df28 ffffffff810391f0
[  161.610023]  ffff88103e55df18 ad33531f6f46c54f 0000000000000000 0000000000000000
[  161.629816]  ffff88103e55df48 ffffffff81c064f3 0000000000000000 d9f51b4f236197d5
[  161.649593] Call Trace:
[  161.649705]  [<ffffffff810391f0>] cpu_idle+0xae/0xcc
[  161.649938]  [<ffffffff81c064f3>] start_secondary+0xbd/0xbf
[  161.669586] Code: 00 00 48 89 d1 48 8d 83 38 e0 ff ff 0f 01 c8 0f ae f0 48 8b 83 38 e0 ff ff a8 08 75 10 e8 ec fd 06 00 31 c0 48 89 c1 fb 0f 01 c9 <eb> 06 e8 dc fd 06 00 fb 8b 05 0f 0a 4e 01 65 44 8b 24 25 30 c7 
[  161.709392] Call Trace:
[  161.709526]  [<ffffffff810391f0>] cpu_idle+0xae/0xcc
[  161.709768]  [<ffffffff81c064f3>] start_secondary+0xbd/0xbf
[  161.729432] NMI backtrace for cpu 72
[  161.729640] CPU 72 
[  161.729727] Modules linked in:
[  161.729936] 
[  161.749342] Pid: 0, comm: kworker/0:1 Not tainted 2.6.39-rc6-tip-yh-03030-gfb0b6a9 #985 Oracle Corporation  Sun Fire X4800/     
[  161.769384] RIP: 0010:[<ffffffff810409eb>]  [<ffffffff810409eb>] mwait_idle+0xef/0x169
[  161.769830] RSP: 0000:ffff88103e4fbee8  EFLAGS: 00000246
[  161.789375] RAX: 0000000000000000 RBX: ffff88103e4fbfd8 RCX: 0000000000000000
[  161.809156] RDX: 0000000000000000 RSI: 0000000000000001 RDI: ffff88103e500000
[  161.809469] RBP: ffff88103e4fbef8 R08: 0000000000000000 R09: 0000000000000000
[  161.829271] R10: 0000000000000000 R11: ffff88103e4fbed8 R12: 0000000000000048
[  161.829589] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
[  161.849394] FS:  0000000000000000(0000) GS:ffff88207ee00000(0000) knlGS:0000000000000000
[  161.869228] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  161.869494] CR2: 0000000000000000 CR3: 000000000239d000 CR4: 00000000000006e0
[  161.889262] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  161.909042] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  161.909363] Process kworker/0:1 (pid: 0, threadinfo ffff88103e4fa000, task ffff88103e500000)
[  161.929206] Stack:
[  161.929300]  ffff88103e4fa000 ffffffff82525380 ffff88103e4fbf28 ffffffff810391f0
[  161.949137]  ffff88103e4fbf18 ce446216a9327bfa 0000000000000000 0000000000000000
[  161.968877]  ffff88103e4fbf48 ffffffff81c064f3 0000000000000000 35549ebda9dd1599
[  161.969277] Call Trace:
[  161.969393]  [<ffffffff810391f0>] cpu_idle+0xae/0xcc
[  161.989001]  [<ffffffff81c064f3>] start_secondary+0xbd/0xbf
[  161.989249] Code: 00 00 48 89 d1 48 8d 83 38 e0 ff ff 0f 01 c8 0f ae f0 48 8b 83 38 e0 ff ff a8 08 75 10 e8 ec fd 06 00 31 c0 48 89 c1 fb 0f 01 c9 <eb> 06 e8 dc fd 06 00 fb 8b 05 0f 0a 4e 01 65 44 8b 24 25 30 c7 
[  162.029298] Call Trace:
[  162.029416]  [<ffffffff810391f0>] cpu_idle+0xae/0xcc
[  162.048827]  [<ffffffff81c064f3>] start_secondary+0xbd/0xbf
[  162.049091] NMI backtrace for cpu 78
[  162.068668] CPU 78 
[  162.068785] Modules linked in:
[  162.068986] 
[  162.069060] Pid: 0, comm: kworker/0:1 Not tainted 2.6.39-rc6-tip-yh-03030-gfb0b6a9 #985 Oracle Corporation  Sun Fire X4800/     
[  162.089028] RIP: 0010:[<ffffffff810409eb>]  [<ffffffff810409eb>] mwait_idle+0xef/0x169
[  162.108891] RSP: 0000:ffff88103e57bee8  EFLAGS: 00000246
[  162.109126] RAX: 0000000000000000 RBX: ffff88103e57bfd8 RCX: 0000000000000000
[  162.129627] RDX: 0000000000000000 RSI: 0000000000000001 RDI: ffff88103e580000
[  162.148950] RBP: ffff88103e57bef8 R08: 0000000000000000 R09: 0000000000000000
[  162.149284] R10: 0000000000000000 R11: ffff88103e57bed8 R12: 000000000000004e
[  162.168852] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
[  162.188626] FS:  0000000000000000(0000) GS:ffff88207fa00000(0000) knlGS:0000000000000000
[  162.188981] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  162.208541] CR2: 0000000000000000 CR3: 000000000239d000 CR4: 00000000000006e0
[  162.229972] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  162.230346] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  162.248455] Process kworker/0:1 (pid: 0, threadinfo ffff88103e57a000, task ffff88103e580000)
[  162.268290] Stack:
[  162.268385]  ffff88103e57a000 ffffffff82525380 ffff88103e57bf28 ffffffff810391f0
[  162.268801]  ffff88103e57bf18 f032e5fdb3adf613 0000000000000000 0000000000000000
[  162.288547]  ffff88103e57bf48 ffffffff81c064f3 0000000000000000 57f6bb23ccbb4736
[  162.308355] Call Trace:
[  162.308489]  [<ffffffff810391f0>] cpu_idle+0xae/0xcc
[  162.308746]  [<ffffffff81c064f3>] start_secondary+0xbd/0xbf
[  162.328341] Code: 00 00 48 89 d1 48 8d 83 38 e0 ff ff 0f 01 c8 0f ae f0 48 8b 83 38 e0 ff ff a8 08 75 10 e8 ec fd 06 00 31 c0 48 89 c1 fb 0f 01 c9 <eb> 06 e8 dc fd 06 00 fb 8b 05 0f 0a 4e 01 65 44 8b 24 25 30 c7 
[  162.368494] Call Trace:
[  162.368649]  [<ffffffff810391f0>] cpu_idle+0xae/0xcc
[  162.368860]  [<ffffffff81c064f3>] start_secondary+0xbd/0xbf
[  162.388166] NMI backtrace for cpu 76
[  162.388337] CPU 76 
[  162.388429] Modules linked in:
[  162.408036] 
[  162.408115] Pid: 0, comm: kworker/0:1 Not tainted 2.6.39-rc6-tip-yh-03030-gfb0b6a9 #985 Oracle Corporation  Sun Fire X4800/     
[  162.428130] RIP: 0010:[<ffffffff810409eb>]  [<ffffffff810409eb>] mwait_idle+0xef/0x169
[  162.447877] RSP: 0000:ffff88103e54fee8  EFLAGS: 00000246
[  162.448131] RAX: 0000000000000000 RBX: ffff88103e54ffd8 RCX: 0000000000000000
[  162.467907] RDX: 0000000000000000 RSI: 0000000000000001 RDI: ffff88103e550000
[  162.468219] RBP: ffff88103e54fef8 R08: 0000000000000000 R09: 0000000000000000
[  162.488048] R10: 0000000000000000 R11: ffff88103e54fed8 R12: 000000000000004c
[  162.507800] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
[  162.508124] FS:  0000000000000000(0000) GS:ffff88207f600000(0000) knlGS:0000000000000000
[  162.527928] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  162.547669] CR2: 0000000000000000 CR3: 000000000239d000 CR4: 00000000000006e0
[  162.548032] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  162.567780] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  162.568095] Process kworker/0:1 (pid: 0, threadinfo ffff88103e54e000, task ffff88103e550000)
[  162.587923] Stack:
[  162.588018]  ffff88103e54e000 ffffffff82525380 ffff88103e54ff28 ffffffff810391f0
[  162.607881]  ffff88103e54ff18 cae5dd183ae409a6 0000000000000000 0000000000000000
[  162.627664]  ffff88103e54ff48 ffffffff81c064f3 0000000000000000 17a57ec2fee86728
[  162.628032] Call Trace:
[  162.647521]  [<ffffffff810391f0>] cpu_idle+0xae/0xcc
[  162.647750]  [<ffffffff81c064f3>] start_secondary+0xbd/0xbf
[  162.667465] Code: 00 00 48 89 d1 48 8d 83 38 e0 ff ff 0f 01 c8 0f ae f0 48 8b 83 38 e0 ff ff a8 08 75 10 e8 ec fd 06 00 31 c0 48 89 c1 fb 0f 01 c9 <eb> 06 e8 dc fd 06 00 fb 8b 05 0f 0a 4e 01 65 44 8b 24 25 30 c7 
[  162.688147] Call Trace:
[  162.707447]  [<ffffffff810391f0>] cpu_idle+0xae/0xcc
[  162.707667]  [<ffffffff81c064f3>] start_secondary+0xbd/0xbf
[  162.707931] NMI backtrace for cpu 74
[  162.747466] CPU 74 
[  162.747567] Modules linked in:
[  162.747742] 
[  162.747826] Pid: 0, comm: kworker/0:1 Not tainted 2.6.39-rc6-tip-yh-03030-gfb0b6a9 #985 Oracle Corporation  Sun Fire X4800/     
[  162.768064] RIP: 0010:[<ffffffff810409eb>]  [<ffffffff810409eb>] mwait_idle+0xef/0x169
[  162.787730] RSP: 0018:ffff88103e527ee8  EFLAGS: 00000246
[  162.807333] RAX: 0000000000000000 RBX: ffff88103e527fd8 RCX: 0000000000000000
[  162.807667] RDX: 0000000000000000 RSI: 0000000000000001 RDI: ffff88103e528000
[  162.827464] RBP: ffff88103e527ef8 R08: 0000000000000000 R09: 0000000000000000
[  162.847210] R10: 0000000000000000 R11: ffff88103e527ed8 R12: 000000000000004a
[  162.847530] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
[  162.867263] FS:  0000000000000000(0000) GS:ffff88207f200000(0000) knlGS:0000000000000000
[  162.893181] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  162.893478] CR2: 0000000000000000 CR3: 000000000239d000 CR4: 00000000000006e0
[  162.907170] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  162.907521] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  162.927151] Process kworker/0:1 (pid: 0, threadinfo ffff88103e526000, task ffff88103e528000)
[  162.947018] Stack:
[  162.947132]  ffff88103e526000 ffffffff82525380 ffff88103e527f28 ffffffff810391f0
[  162.966915]  ffff88103e527f18 3ceecc1c6f3146ab 0000000000000000 0000000000000000
[  162.967316]  ffff88103e527f48 ffffffff81c064f3 0000000000000000 c6250755f2f9eca7
[  162.987055] Call Trace:
[  162.987176]  [<ffffffff810391f0>] cpu_idle+0xae/0xcc
[  163.006813]  [<ffffffff81c064f3>] start_secondary+0xbd/0xbf
[  163.007072] Code: 00 00 48 89 d1 48 8d 83 38 e0 ff ff 0f 01 c8 0f ae f0 48 8b 83 38 e0 ff ff a8 08 75 10 e8 ec fd 06 00 31 c0 48 89 c1 fb 0f 01 c9 <eb> 06 e8 dc fd 06 00 fb 8b 05 0f 0a 4e 01 65 44 8b 24 25 30 c7 
[  163.047044] Call Trace:
[  163.047157]  [<ffffffff810391f0>] cpu_idle+0xae/0xcc
[  163.066622]  [<ffffffff81c064f3>] start_secondary+0xbd/0xbf
[  163.066876] NMI backtrace for cpu 81
[  163.067069] CPU 81 
[  163.086579] Modules linked in:
[  163.086762] 
[  163.086836] Pid: 0, comm: kworker/0:1 Not tainted 2.6.39-rc6-tip-yh-03030-gfb0b6a9 #985 Oracle Corporation  Sun Fire X4800/     
[  163.106837] RIP: 0010:[<ffffffff810409eb>]  [<ffffffff810409eb>] mwait_idle+0xef/0x169
[  163.126616] RSP: 0018:ffff88103e5afee8  EFLAGS: 00000246
[  163.126895] RAX: 0000000000000000 RBX: ffff88103e5affd8 RCX: 0000000000000000
[  163.147061] RDX: 0000000000000000 RSI: 0000000000000001 RDI: ffff88103e5b4560
[  163.166578] RBP: ffff88103e5afef8 R08: 0000000000000000 R09: 0000000000000000
[  163.166956] R10: 0000000000000000 R11: ffff88103e5afed8 R12: 0000000000000051
[  163.186810] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
[  163.187181] FS:  0000000000000000(0000) GS:ffff88307f000000(0000) knlGS:0000000000000000
[  163.206849] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  163.226392] CR2: 0000000000000000 CR3: 000000000239d000 CR4: 00000000000006e0
[  163.226762] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  163.246575] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  163.266265] Process kworker/0:1 (pid: 0, threadinfo ffff88103e5ae000, task ffff88103e5b4560)
[  163.266723] Stack:
[  163.286189]  ffff88103e5ae000 ffffffff82525380 ffff88103e5aff28 ffffffff810391f0
[  163.286584]  ffff88103e5aff18 7782e4a57542f064 0000000000000000 0000000000000000
[  163.306399]  ffff88103e5aff48 ffffffff81c064f3 0000000000000000 8ba93f0bab920685
[  163.326120] Call Trace:
[  163.326252]  [<ffffffff810391f0>] cpu_idle+0xae/0xcc
[  163.326540]  [<ffffffff81c064f3>] start_secondary+0xbd/0xbf
[  163.346197] Code: 00 00 48 89 d1 48 8d 83 38 e0 ff ff 0f 01 c8 0f ae f0 48 8b 83 38 e0 ff ff a8 08 75 10 e8 ec fd 06 00 31 c0 48 89 c1 fb 0f 01 c9 <eb> 06 e8 dc fd 06 00 fb 8b 05 0f 0a 4e 01 65 44 8b 24 25 30 c7 
[  163.366956] Call Trace:
[  163.386044]  [<ffffffff810391f0>] cpu_idle+0xae/0xcc
[  163.386320]  [<ffffffff81c064f3>] start_secondary+0xbd/0xbf
[  163.405982] NMI backtrace for cpu 85
[  163.406136] CPU 85 
[  163.406236] Modules linked in:
[  163.406409] 
[  163.425904] Pid: 0, comm: kworker/0:1 Not tainted 2.6.39-rc6-tip-yh-03030-gfb0b6a9 #985 Oracle Corporation  Sun Fire X4800/     
[  163.445897] RIP: 0010:[<ffffffff810409eb>]  [<ffffffff810409eb>] mwait_idle+0xef/0x169
[  163.446273] RSP: 0000:ffff88103e613ee8  EFLAGS: 00000246
[  163.466138] RAX: 0000000000000000 RBX: ffff88103e613fd8 RCX: 0000000000000000
[  163.466548] RDX: 0000000000000000 RSI: 0000000000000001 RDI: ffff88103e60c560
[  163.486079] RBP: ffff88103e613ef8 R08: 0000000000000000 R09: 0000000000000000
[  163.505826] R10: 0000000000000000 R11: ffff88103e613ed8 R12: 0000000000000055
[  163.506243] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
[  163.527647] FS:  0000000000000000(0000) GS:ffff88307f800000(0000) knlGS:0000000000000000
[  163.545778] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  163.546092] CR2: 0000000000000000 CR3: 000000000239d000 CR4: 00000000000006e0
[  163.565832] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  163.585568] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  163.585987] Process kworker/0:1 (pid: 0, threadinfo ffff88103e612000, task ffff88103e60c560)
[  163.605780] Stack:
[  163.605873]  ffff88103e612000 ffffffff82525380 ffff88103e613f28 ffffffff810391f0
[  163.625647]  ffff88103e613f18 1338bcfcabb32e6d 0000000000000000 0000000000000000
[  163.645439]  ffff88103e613f48 ffffffff81c064f3 0000000000000000 71bb112c4d5bc551
[  163.645899] Call Trace:
[  163.646032]  [<ffffffff810391f0>] cpu_idle+0xae/0xcc
[  163.665559]  [<ffffffff81c064f3>] start_secondary+0xbd/0xbf
[  163.665813] Code: 00 00 48 89 d1 48 8d 83 38 e0 ff ff 0f 01 c8 0f ae f0 48 8b 83 38 e0 ff ff a8 08 75 10 e8 ec fd 06 00 31 c0 48 89 c1 fb 0f 01 c9 <eb> 06 e8 dc fd 06 00 fb 8b 05 0f 0a 4e 01 65 44 8b 24 25 30 c7 
[  163.705851] Call Trace:
[  163.705981]  [<ffffffff810391f0>] cpu_idle+0xae/0xcc
[  163.725406]  [<ffffffff81c064f3>] start_secondary+0xbd/0xbf
[  163.725699] NMI backtrace for cpu 87
[  163.745234] CPU 87 
[  163.745337] Modules linked in:
[  163.745498] 
[  163.745574] Pid: 0, comm: kworker/0:1 Not tainted 2.6.39-rc6-tip-yh-03030-gfb0b6a9 #985 Oracle Corporation  Sun Fire X4800/     
[  163.765557] RIP: 0010:[<ffffffff810409eb>]  [<ffffffff810409eb>] mwait_idle+0xef/0x169
[  163.785347] RSP: 0000:ffff88103e641ee8  EFLAGS: 00000246
[  163.785634] RAX: 0000000000000000 RBX: ffff88103e641fd8 RCX: 0000000000000000
[  163.805440] RDX: 0000000000000000 RSI: 0000000000000001 RDI: ffff88103e63c560
[  163.825147] RBP: ffff88103e641ef8 R08: 0000000000000000 R09: 0000000000000000
[  163.825623] R10: 0000000000000000 R11: ffff88103e641ed8 R12: 0000000000000057
[  163.845315] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
[  163.865029] FS:  0000000000000000(0000) GS:ffff88307fc00000(0000) knlGS:0000000000000000
[  163.865477] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  163.885147] CR2: 0000000000000000 CR3: 000000000239d000 CR4: 00000000000006e0
[  163.904917] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  163.905367] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  163.925030] Process kworker/0:1 (pid: 0, threadinfo ffff88103e640000, task ffff88103e63c560)
[  163.944862] Stack:
[  163.944954]  ffff88103e640000 ffffffff82525380 ffff88103e641f28 ffffffff810391f0
[  163.945367]  ffff88103e641f18 41f11d18f408308f 0000000000000000 0000000000000000
[  163.965173]  ffff88103e641f48 ffffffff81c064f3 0000000000000000 388370f59e8df041
[  163.984907] Call Trace:
[  163.985023]  [<ffffffff810391f0>] cpu_idle+0xae/0xcc
[  163.985321]  [<ffffffff81c064f3>] start_secondary+0xbd/0xbf
[  164.004921] Code: 00 00 48 89 d1 48 8d 83 38 e0 ff ff 0f 01 c8 0f ae f0 48 8b 83 38 e0 ff ff a8 08 75 10 e8 ec fd 06 00 31 c0 48 89 c1 fb 0f 01 c9 <eb> 06 e8 dc fd 06 00 fb 8b 05 0f 0a 4e 01 65 44 8b 24 25 30 c7 
[  164.044771] Call Trace:
[  164.044911]  [<ffffffff810391f0>] cpu_idle+0xae/0xcc
[  164.045194]  [<ffffffff81c064f3>] start_secondary+0xbd/0xbf
[  164.064719] NMI backtrace for cpu 84
[  164.064933] CPU 84 
[  164.065020] Modules linked in:
[  164.084637] 
[  164.084708] Pid: 0, comm: kworker/0:1 Not tainted 2.6.39-rc6-tip-yh-03030-gfb0b6a9 #985 Oracle Corporation  Sun Fire X4800/     
[  164.104674] RIP: 0010:[<ffffffff810409eb>]  [<ffffffff810409eb>] mwait_idle+0xef/0x169
[  164.124627] RSP: 0000:ffff88103e5edee8  EFLAGS: 00000246
[  164.124880] RAX: 0000000000000000 RBX: ffff88103e5edfd8 RCX: 0000000000000000
[  164.144688] RDX: 0000000000000000 RSI: 0000000000000001 RDI: ffff88103e5f4560
[  164.145133] RBP: ffff88103e5edef8 R08: 0000000000000000 R09: 0000000000000000
[  164.166316] R10: 0000000000000000 R11: ffff88103e5eded8 R12: 0000000000000054
[  164.184492] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
[  164.184895] FS:  0000000000000000(0000) GS:ffff88307f600000(0000) knlGS:0000000000000000
[  164.204826] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  164.205180] CR2: 0000000000000000 CR3: 000000000239d000 CR4: 00000000000006e0
[  164.224723] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  164.244472] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  164.244862] Process kworker/0:1 (pid: 0, threadinfo ffff88103e5ec000, task ffff88103e5f4560)
[  164.264574] Stack:
[  164.264692]  ffff88103e5ec000 ffffffff82525380 ffff88103e5edf28 ffffffff810391f0
[  164.284428]  ffff88103e5edf18 ac950cdde64809da 0000000000000000 0000000000000000
[  164.304208]  ffff88103e5edf48 ffffffff81c064f3 0000000000000000 79cf6d869ee9f9b5
[  164.304641] Call Trace:
[  164.324105]  [<ffffffff810391f0>] cpu_idle+0xae/0xcc
[  164.324330]  [<ffffffff81c064f3>] start_secondary+0xbd/0xbf
[  164.344004] Code: 00 00 48 89 d1 48 8d 83 38 e0 ff ff 0f 01 c8 0f ae f0 48 8b 83 38 e0 ff ff a8 08 75 10 e8 ec fd 06 00 31 c0 48 89 c1 fb 0f 01 c9 <eb> 06 e8 dc fd 06 00 fb 8b 05 0f 0a 4e 01 65 44 8b 24 25 30 c7 
[  164.364677] Call Trace:
[  164.364797]  [<ffffffff810391f0>] cpu_idle+0xae/0xcc
[  164.384674]  [<ffffffff81c064f3>] start_secondary+0xbd/0xbf
[  164.385034] NMI backtrace for cpu 80
[  164.403994] CPU 80 
[  164.404084] Modules linked in:
[  164.404288] 
[  164.404374] Pid: 0, comm: kworker/0:1 Not tainted 2.6.39-rc6-tip-yh-03030-gfb0b6a9 #985 Oracle Corporation  Sun Fire X4800/     
[  164.424323] RIP: 0010:[<ffffffff810409eb>]  [<ffffffff810409eb>] mwait_idle+0xef/0x169
[  164.444136] RSP: 0000:ffff88103e5a9ee8  EFLAGS: 00000246
[  164.463804] RAX: 0000000000000000 RBX: ffff88103e5a9fd8 RCX: 0000000000000000
[  164.464126] RDX: 0000000000000000 RSI: 0000000000000001 RDI: ffff88103e5a4560
[  164.483918] RBP: ffff88103e5a9ef8 R08: 0000000000000000 R09: 0000000000000000
[  164.503706] R10: 0000000000000000 R11: ffff88103e5a9ed8 R12: 0000000000000050
[  164.504052] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
[  164.523786] FS:  0000000000000000(0000) GS:ffff88307ee00000(0000) knlGS:0000000000000000
[  164.543621] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  164.543938] CR2: 0000000000000000 CR3: 000000000239d000 CR4: 00000000000006e0
[  164.563679] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  164.564099] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  164.583788] Process kworker/0:1 (pid: 0, threadinfo ffff88103e5a8000, task ffff88103e5a4560)
[  164.603591] Stack:
[  164.603694]  ffff88103e5a8000 ffffffff82525380 ffff88103e5a9f28 ffffffff810391f0
[  164.623514]  ffff88103e5a9f18 e1ea2195949618ac 0000000000000000 0000000000000000
[  164.623940]  ffff88103e5a9f48 ffffffff81c064f3 0000000000000000 913d0aa0500edc01
[  164.643666] Call Trace:
[  164.643774]  [<ffffffff810391f0>] cpu_idle+0xae/0xcc
[  164.663404]  [<ffffffff81c064f3>] start_secondary+0xbd/0xbf
[  164.663733] Code: 00 00 48 89 d1 48 8d 83 38 e0 ff ff 0f 01 c8 0f ae f0 48 8b 83 38 e0 ff ff a8 08 75 10 e8 ec fd 06 00 31 c0 48 89 c1 fb 0f 01 c9 <eb> 06 e8 dc fd 06 00 fb 8b 05 0f 0a 4e 01 65 44 8b 24 25 30 c7 
[  164.703723] Call Trace:
[  164.703841]  [<ffffffff810391f0>] cpu_idle+0xae/0xcc
[  164.723230]  [<ffffffff81c064f3>] start_secondary+0xbd/0xbf
[  164.723575] NMI backtrace for cpu 82
[  164.723783] CPU 82 
[  164.743189] Modules linked in:
[  164.743378] 
[  164.743459] Pid: 0, comm: kworker/0:1 Not tainted 2.6.39-rc6-tip-yh-03030-gfb0b6a9 #985 Oracle Corporation  Sun Fire X4800/     
[  164.763419] RIP: 0010:[<ffffffff810409eb>]  [<ffffffff810409eb>] mwait_idle+0xef/0x169
[  164.783196] RSP: 0000:ffff88103e5d9ee8  EFLAGS: 00000246
[  164.783437] RAX: 0000000000000000 RBX: ffff88103e5d9fd8 RCX: 0000000000000000
[  164.803280] RDX: 0000000000000000 RSI: 0000000000000001 RDI: ffff88103e5cc560
[  164.803705] RBP: ffff88103e5d9ef8 R08: 0000000000000000 R09: 0000000000000000
[  164.825030] R10: 0000000000000000 R11: ffff88103e5d9ed8 R12: 0000000000000052
[  164.843096] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
[  164.843567] FS:  0000000000000000(0000) GS:ffff88307f200000(0000) knlGS:0000000000000000
[  164.863342] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  164.882987] CR2: 0000000000000000 CR3: 000000000239d000 CR4: 00000000000006e0
[  164.883337] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  164.903103] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  164.922856] Process kworker/0:1 (pid: 0, threadinfo ffff88103e5d8000, task ffff88103e5cc560)
[  164.923279] Stack:
[  164.942787]  ffff88103e5d8000 ffffffff82525380 ffff88103e5d9f28 ffffffff810391f0
[  164.943248]  ffff88103e5d9f18 3ca5437b49de96ec 0000000000000000 0000000000000000
[  164.962981]  ffff88103e5d9f48 ffffffff81c064f3 0000000000000000 2b4b5c0dcf3a906f
[  164.982749] Call Trace:
[  164.982871]  [<ffffffff810391f0>] cpu_idle+0xae/0xcc
[  164.983154]  [<ffffffff81c064f3>] start_secondary+0xbd/0xbf
[  165.002755] Code: 00 00 48 89 d1 48 8d 83 38 e0 ff ff 0f 01 c8 0f ae f0 48 8b 83 38 e0 ff ff a8 08 75 10 e8 ec fd 06 00 31 c0 48 89 c1 fb 0f 01 c9 <eb> 06 e8 dc fd 06 00 fb 8b 05 0f 0a 4e 01 65 44 8b 24 25 30 c7 
[  165.023581] Call Trace:
[  165.042671]  [<ffffffff810391f0>] cpu_idle+0xae/0xcc
[  165.042935]  [<ffffffff81c064f3>] start_secondary+0xbd/0xbf
[  165.062603] NMI backtrace for cpu 83
[  165.062792] CPU 83 
[  165.062913] Modules linked in:
[  165.063139] 
[  165.082496] Pid: 0, comm: kworker/0:1 Not tainted 2.6.39-rc6-tip-yh-03030-gfb0b6a9 #985 Oracle Corporation  Sun Fire X4800/     
[  165.102531] RIP: 0010:[<ffffffff810409eb>]  [<ffffffff810409eb>] mwait_idle+0xef/0x169
[  165.102959] RSP: 0000:ffff88103e5dfee8  EFLAGS: 00000246
[  165.122610] RAX: 0000000000000000 RBX: ffff88103e5dffd8 RCX: 0000000000000000
[  165.123043] RDX: 0000000000000000 RSI: 0000000000000001 RDI: ffff88103e5e4560
[  165.142773] RBP: ffff88103e5dfef8 R08: 0000000000000000 R09: 0000000000000000
[  165.162713] R10: 0000000000000000 R11: ffff88103e5dfed8 R12: 0000000000000053
[  165.163093] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
[  165.182668] FS:  0000000000000000(0000) GS:ffff88307f400000(0000) knlGS:0000000000000000
[  165.202485] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  165.202770] CR2: 0000000000000000 CR3: 000000000239d000 CR4: 00000000000006e0
[  165.222691] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  165.242184] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  165.242557] Process kworker/0:1 (pid: 0, threadinfo ffff88103e5de000, task ffff88103e5e4560)
[  165.262353] Stack:
[  165.262446]  ffff88103e5de000 ffffffff82525380 ffff88103e5dff28 ffffffff810391f0
[  165.282294]  ffff88103e5dff18 291962416f9caca0 0000000000000000 0000000000000000
[  165.282731]  ffff88103e5dff48 ffffffff81c064f3 0000000000000000 182eaafab45800c9
[  165.302476] Call Trace:
[  165.302606]  [<ffffffff810391f0>] cpu_idle+0xae/0xcc
[  165.322182]  [<ffffffff81c064f3>] start_secondary+0xbd/0xbf
[  165.322495] Code: 00 00 48 89 d1 48 8d 83 38 e0 ff ff 0f 01 c8 0f ae f0 48 8b 83 38 e0 ff ff a8 08 75 10 e8 ec fd 06 00 31 c0 48 89 c1 fb 0f 01 c9 <eb> 06 e8 dc fd 06 00 fb 8b 05 0f 0a 4e 01 65 44 8b 24 25 30 c7 
[  165.362412] Call Trace:
[  165.362529]  [<ffffffff810391f0>] cpu_idle+0xae/0xcc
[  165.393005]  [<ffffffff81c064f3>] start_secondary+0xbd/0xbf
[  165.393270] NMI backtrace for cpu 86
[  165.411822] CPU 86 
[  165.411937] Modules linked in:
[  165.412101] 
[  165.412177] Pid: 0, comm: kworker/0:1 Not tainted 2.6.39-rc6-tip-yh-03030-gfb0b6a9 #985 Oracle Corporation  Sun Fire X4800/     
[  165.432223] RIP: 0010:[<ffffffff810409eb>]  [<ffffffff810409eb>] mwait_idle+0xef/0x169
[  165.451948] RSP: 0000:ffff88103e629ee8  EFLAGS: 00000246
[  165.452228] RAX: 0000000000000000 RBX: ffff88103e629fd8 RCX: 0000000000000000
[  165.473706] RDX: 0000000000000000 RSI: 0000000000000001 RDI: ffff88103e624560
[  165.491738] RBP: ffff88103e629ef8 R08: 0000000000000000 R09: 0000000000000000
[  165.492121] R10: 0000000000000000 R11: ffff88103e629ed8 R12: 0000000000000056
[  165.511828] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
[  165.531631] FS:  0000000000000000(0000) GS:ffff88307fa00000(0000) knlGS:0000000000000000
[  165.532019] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  165.551714] CR2: 0000000000000000 CR3: 000000000239d000 CR4: 00000000000006e0
[  165.552087] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  165.571840] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  165.591613] Process kworker/0:1 (pid: 0, threadinfo ffff88103e628000, task ffff88103e624560)
[  165.611425] Stack:
[  165.611552]  ffff88103e628000 ffffffff82525380 ffff88103e629f28 ffffffff810391f0
[  165.611966]  ffff88103e629f18 18b050d3e519eccd 0000000000000000 0000000000000000
[  165.631721]  ffff88103e629f48 ffffffff81c064f3 0000000000000000 e4373b2097d82c28
[  165.651482] Call Trace:
[  165.651600]  [<ffffffff810391f0>] cpu_idle+0xae/0xcc
[  165.651845]  [<ffffffff81c064f3>] start_secondary+0xbd/0xbf
[  165.671528] Code: 00 00 48 89 d1 48 8d 83 38 e0 ff ff 0f 01 c8 0f ae f0 48 8b 83 38 e0 ff ff a8 08 75 10 e8 ec fd 06 00 31 c0 48 89 c1 fb 0f 01 c9 <eb> 06 e8 dc fd 06 00 fb 8b 05 0f 0a 4e 01 65 44 8b 24 25 30 c7 
[  165.711543] Call Trace:
[  165.711662]  [<ffffffff810391f0>] cpu_idle+0xae/0xcc
[  165.711928]  [<ffffffff81c064f3>] start_secondary+0xbd/0xbf
[  165.731348] NMI backtrace for cpu 95
[  165.731538] CPU 95 
[  165.731648] Modules linked in:
[  165.751183] 
[  165.751280] Pid: 0, comm: kworker/0:1 Not tainted 2.6.39-rc6-tip-yh-03030-gfb0b6a9 #985 Oracle Corporation  Sun Fire X4800/     
[  165.771263] RIP: 0010:[<ffffffff810409eb>]  [<ffffffff810409eb>] mwait_idle+0xef/0x169
[  165.771659] RSP: 0000:ffff88103e6d5ee8  EFLAGS: 00000246
[  165.791267] RAX: 0000000000000000 RBX: ffff88103e6d5fd8 RCX: 0000000000000000
[  165.811054] RDX: 0000000000000000 RSI: 0000000000000001 RDI: ffff88103e6dc560
[  165.811363] RBP: ffff88103e6d5ef8 R08: 0000000000000000 R09: 0000000000000000
[  165.831174] R10: 0000000000000000 R11: ffff88103e6d5ed8 R12: 000000000000005f
[  165.850938] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
[  165.851262] FS:  0000000000000000(0000) GS:ffff88407fc00000(0000) knlGS:0000000000000000
[  165.871114] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  165.871382] CR2: 0000000000000000 CR3: 000000000239d000 CR4: 00000000000006e0
[  165.891216] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  165.910931] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  165.911268] Process kworker/0:1 (pid: 0, threadinfo ffff88103e6d4000, task ffff88103e6dc560)
[  165.931078] Stack:
[  165.931169]  ffff88103e6d4000 ffffffff82525380 ffff88103e6d5f28 ffffffff810391f0
[  165.951035]  ffff88103e6d5f18 e9750d6e03254eac 0000000000000000 0000000000000000
[  165.970777]  ffff88103e6d5f48 ffffffff81c064f3 0000000000000000 26997d219409388f
[  165.971192] Call Trace:
[  165.990653]  [<ffffffff810391f0>] cpu_idle+0xae/0xcc
[  165.990873]  [<ffffffff81c064f3>] start_secondary+0xbd/0xbf
[  165.991119] Code: 00 00 48 89 d1 48 8d 83 38 e0 ff ff 0f 01 c8 0f ae f0 48 8b 83 38 e0 ff ff a8 08 75 10 e8 ec fd 06 00 31 c0 48 89 c1 fb 0f 01 c9 <eb> 06 e8 dc fd 06 00 fb 8b 05 0f 0a 4e 01 65 44 8b 24 25 30 c7 
[  166.031254] Call Trace:
[  166.031394]  [<ffffffff810391f0>] cpu_idle+0xae/0xcc
[  166.050708]  [<ffffffff81c064f3>] start_secondary+0xbd/0xbf
[  166.050969] NMI backtrace for cpu 89
[  166.070579] CPU 89 
[  166.070699] Modules linked in:
[  166.070907] 
[  166.070993] Pid: 0, comm: kworker/0:1 Not tainted 2.6.39-rc6-tip-yh-03030-gfb0b6a9 #985 Oracle Corporation  Sun Fire X4800/     
[  166.090981] RIP: 0010:[<ffffffff810409eb>]  [<ffffffff810409eb>] mwait_idle+0xef/0x169
[  166.111649] RSP: 0000:ffff88103e657ee8  EFLAGS: 00000246
[  166.130385] RAX: 0000000000000000 RBX: ffff88103e657fd8 RCX: 0000000000000000
[  166.130813] RDX: 0000000000000000 RSI: 0000000000000001 RDI: ffff88103e65c560
[  166.151071] RBP: ffff88103e657ef8 R08: 0000000000000000 R09: 0000000000000000
[  166.151435] R10: 0000000000000000 R11: ffff88103e657ed8 R12: 0000000000000059
[  166.170873] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
[  166.190468] FS:  0000000000000000(0000) GS:ffff88407f000000(0000) knlGS:0000000000000000
[  166.210462] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  166.210829] CR2: 0000000000000000 CR3: 000000000239d000 CR4: 00000000000006e0
[  166.230237] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  166.230596] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  166.250492] Process kworker/0:1 (pid: 0, threadinfo ffff88103e656000, task ffff88103e65c560)
[  166.270185] Stack:
[  166.270303]  ffff88103e656000 ffffffff82525380 ffff88103e657f28 ffffffff810391f0
[  166.290094]  ffff88103e657f18 99a1b0cf9e9d3ebb 0000000000000000 0000000000000000
[  166.290483]  ffff88103e657f48 ffffffff81c064f3 0000000000000000 25270db18ea19940
[  166.310257] Call Trace:
[  166.310402]  [<ffffffff810391f0>] cpu_idle+0xae/0xcc
[  166.329985]  [<ffffffff81c064f3>] start_secondary+0xbd/0xbf
[  166.330351] Code: 00 00 48 89 d1 48 8d 83 38 e0 ff ff 0f 01 c8 0f ae f0 48 8b 83 38 e0 ff ff a8 08 75 10 e8 ec fd 06 00 31 c0 48 89 c1 fb 0f 01 c9 <eb> 06 e8 dc fd 06 00 fb 8b 05 0f 0a 4e 01 65 44 8b 24 25 30 c7 
[  166.370192] Call Trace:
[  166.370349]  [<ffffffff810391f0>] cpu_idle+0xae/0xcc
[  166.370593]  [<ffffffff81c064f3>] start_secondary+0xbd/0xbf
[  166.390088] NMI backtrace for cpu 92
[  166.390299] CPU 92 
[  166.390439] Modules linked in:
[  166.410000] 
[  166.410077] Pid: 0, comm: kworker/0:1 Not tainted 2.6.39-rc6-tip-yh-03030-gfb0b6a9 #985 Oracle Corporation  Sun Fire X4800/     
[  166.430006] RIP: 0010:[<ffffffff810409eb>]  [<ffffffff810409eb>] mwait_idle+0xef/0x169
[  166.449777] RSP: 0000:ffff88103e6a1ee8  EFLAGS: 00000246
[  166.450048] RAX: 0000000000000000 RBX: ffff88103e6a1fd8 RCX: 0000000000000000
[  166.469820] RDX: 0000000000000000 RSI: 0000000000000001 RDI: ffff88103e69c560
[  166.470176] RBP: ffff88103e6a1ef8 R08: 0000000000000000 R09: 0000000000000000
[  166.489932] R10: 0000000000000000 R11: ffff88103e6a1ed8 R12: 000000000000005c
[  166.509692] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
[  166.510114] FS:  0000000000000000(0000) GS:ffff88407f600000(0000) knlGS:0000000000000000
[  166.529838] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  166.549585] CR2: 0000000000000000 CR3: 000000000239d000 CR4: 00000000000006e0
[  166.549971] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  166.570648] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  166.589433] Process kworker/0:1 (pid: 0, threadinfo ffff88103e6a0000, task ffff88103e69c560)
[  166.589840] Stack:
[  166.589953]  ffff88103e6a0000 ffffffff82525380 ffff88103e6a1f28 ffffffff810391f0
[  166.609811]  ffff88103e6a1f18 18a3b18c2c15ed65 0000000000000000 0000000000000000
[  166.629556]  ffff88103e6a1f48 ffffffff81c064f3 0000000000000000 6118231e21489cba
[  166.649294] Call Trace:
[  166.649445]  [<ffffffff810391f0>] cpu_idle+0xae/0xcc
[  166.649739]  [<ffffffff81c064f3>] start_secondary+0xbd/0xbf
[  166.669370] Code: 00 00 48 89 d1 48 8d 83 38 e0 ff ff 0f 01 c8 0f ae f0 48 8b 83 38 e0 ff ff a8 08 75 10 e8 ec fd 06 00 31 c0 48 89 c1 fb 0f 01 c9 <eb> 06 e8 dc fd 06 00 fb 8b 05 0f 0a 4e 01 65 44 8b 24 25 30 c7 
[  166.690108] Call Trace:
[  166.709251]  [<ffffffff810391f0>] cpu_idle+0xae/0xcc
[  166.709555]  [<ffffffff81c064f3>] start_secondary+0xbd/0xbf
[  166.729162] NMI backtrace for cpu 93
[  166.729336] CPU 93 
[  166.729424] Modules linked in:
[  166.729601] 
[  166.729704] Pid: 0, comm: kworker/0:1 Not tainted 2.6.39-rc6-tip-yh-03030-gfb0b6a9 #985 Oracle Corporation  Sun Fire X4800/     
[  166.769090] RIP: 0010:[<ffffffff810409eb>]  [<ffffffff810409eb>] mwait_idle+0xef/0x169
[  166.769509] RSP: 0000:ffff88103e6a7ee8  EFLAGS: 00000246
[  166.789274] RAX: 0000000000000000 RBX: ffff88103e6a7fd8 RCX: 0000000000000000
[  166.789705] RDX: 0000000000000000 RSI: 0000000000000001 RDI: ffff88103e6ac560
[  166.809219] RBP: ffff88103e6a7ef8 R08: 0000000000000000 R09: 0000000000000000
[  166.829023] R10: 0000000000000000 R11: ffff88103e6a7ed8 R12: 000000000000005d
[  166.829467] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
[  166.859237] FS:  0000000000000000(0000) GS:ffff88407f800000(0000) knlGS:0000000000000000
[  166.879116] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  166.879403] CR2: 0000000000000000 CR3: 000000000239d000 CR4: 00000000000006e0
[  166.899175] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  166.899576] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  166.919321] Process kworker/0:1 (pid: 0, threadinfo ffff88103e6a6000, task ffff88103e6ac560)
[  166.949119] Stack:
[  166.949207]  ffff88103e6a6000 ffffffff82525380 ffff88103e6a7f28 ffffffff810391f0
[  166.968960]  ffff88103e6a7f18 12bbac2f2ac6563c 0000000000000000 0000000000000000
[  166.969388]  ffff88103e6a7f48 ffffffff81c064f3 0000000000000000 2c0129df7ca7b3c8
[  166.989083] Call Trace:
[  166.989191]  [<ffffffff810391f0>] cpu_idle+0xae/0xcc
[  167.008734]  [<ffffffff81c064f3>] start_secondary+0xbd/0xbf
[  167.009075] Code: 00 00 48 89 d1 48 8d 83 38 e0 ff ff 0f 01 c8 0f ae f0 48 8b 83 38 e0 ff ff a8 08 75 10 e8 ec fd 06 00 31 c0 48 89 c1 fb 0f 01 c9 <eb> 06 e8 dc fd 06 00 fb 8b 05 0f 0a 4e 01 65 44 8b 24 25 30 c7 
[  167.049004] Call Trace:
[  167.049162]  [<ffffffff810391f0>] cpu_idle+0xae/0xcc
[  167.068530]  [<ffffffff81c064f3>] start_secondary+0xbd/0xbf
[  167.068821] NMI backtrace for cpu 98
[  167.069031] CPU 98 
[  167.088467] Modules linked in:
[  167.088698] 
[  167.088799] Pid: 0, comm: kworker/0:1 Not tainted 2.6.39-rc6-tip-yh-03030-gfb0b6a9 #985 Oracle Corporation  Sun Fire X4800/     
[  167.108739] RIP: 0010:[<ffffffff810409eb>]  [<ffffffff810409eb>] mwait_idle+0xef/0x169
[  167.129860] RSP: 0000:ffff88103e719ee8  EFLAGS: 00000246
[  167.130128] RAX: 0000000000000000 RBX: ffff88103e719fd8 RCX: 0000000000000000
[  167.148569] RDX: 0000000000000000 RSI: 0000000000000001 RDI: ffff88103e70a2b0
[  167.168308] RBP: ffff88103e719ef8 R08: 0000000000000000 R09: 0000000000000000
[  167.168679] R10: 0000000000000000 R11: ffff88103e719ed8 R12: 0000000000000062
[  167.189402] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
[  167.208443] FS:  0000000000000000(0000) GS:ffff88507f200000(0000) knlGS:0000000000000000
[  167.208868] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  167.228381] CR2: 0000000000000000 CR3: 000000000239d000 CR4: 00000000000006e0
[  167.228772] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  167.252818] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  167.268203] Process kworker/0:1 (pid: 0, threadinfo ffff88103e718000, task ffff88103e70a2b0)
[  167.268701] Stack:
[  167.288075]  ffff88103e718000 ffffffff82525380 ffff88103e719f28 ffffffff810391f0
[  167.288543]  ffff88103e719f18 c68544f99cc20e07 0000000000000000 0000000000000000
[  167.308301]  ffff88103e719f48 ffffffff81c064f3 0000000000000000 886503d07d16a597
[  167.328040] Call Trace:
[  167.328170]  [<ffffffff810391f0>] cpu_idle+0xae/0xcc
[  167.328468]  [<ffffffff81c064f3>] start_secondary+0xbd/0xbf
[  167.348094] Code: 00 00 48 89 d1 48 8d 83 38 e0 ff ff 0f 01 c8 0f ae f0 48 8b 83 38 e0 ff ff a8 08 75 10 e8 ec fd 06 00 31 c0 48 89 c1 fb 0f 01 c9 <eb> 06 e8 dc fd 06 00 fb 8b 05 0f 0a 4e 01 65 44 8b 24 25 30 c7 
[  167.387896] Call Trace:
[  167.388015]  [<ffffffff810391f0>] cpu_idle+0xae/0xcc
[  167.388281]  [<ffffffff81c064f3>] start_secondary+0xbd/0xbf
[  167.407899] NMI backtrace for cpu 99
[  167.408051] CPU 99 
[  167.408148] Modules linked in:
[  167.428828] 
[  167.428905] Pid: 0, comm: kworker/0:1 Not tainted 2.6.39-rc6-tip-yh-03030-gfb0b6a9 #985 Oracle Corporation  Sun Fire X4800/     
[  167.447787] RIP: 0010:[<ffffffff810409eb>]  [<ffffffff810409eb>] mwait_idle+0xef/0x169
[  167.448164] RSP: 0000:ffff88103e71fee8  EFLAGS: 00000246
[  167.467839] RAX: 0000000000000000 RBX: ffff88103e71ffd8 RCX: 0000000000000000
[  167.487619] RDX: 0000000000000000 RSI: 0000000000000001 RDI: ffff88103e72a2b0
[  167.488003] RBP: ffff88103e71fef8 R08: 0000000000000000 R09: 0000000000000000
[  167.507722] R10: 0000000000000000 R11: ffff88103e71fed8 R12: 0000000000000063
[  167.508045] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
[  167.527801] FS:  0000000000000000(0000) GS:ffff88507f400000(0000) knlGS:0000000000000000
[  167.547668] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  167.547980] CR2: 0000000000000000 CR3: 000000000239d000 CR4: 00000000000006e0
[  167.567717] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  167.587475] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  167.587866] Process kworker/0:1 (pid: 0, threadinfo ffff88103e71e000, task ffff88103e72a2b0)
[  167.607715] Stack:
[  167.607847]  ffff88103e71e000 ffffffff82525380 ffff88103e71ff28 ffffffff810391f0
[  167.627601]  ffff88103e71ff18 d1b7ebbe272fa90f 0000000000000000 0000000000000000
[  167.647336]  ffff88103e71ff48 ffffffff81c064f3 0000000000000000 4e968abbf0e34374
[  167.647776] Call Trace:
[  167.647891]  [<ffffffff810391f0>] cpu_idle+0xae/0xcc
[  167.667525]  [<ffffffff81c064f3>] start_secondary+0xbd/0xbf
[  167.667907] Code: 00 00 48 89 d1 48 8d 83 38 e0 ff ff 0f 01 c8 0f ae f0 48 8b 83 38 e0 ff ff a8 08 75 10 e8 ec fd 06 00 31 c0 48 89 c1 fb 0f 01 c9 <eb> 06 e8 dc fd 06 00 fb 8b 05 0f 0a 4e 01 65 44 8b 24 25 30 c7 
[  167.707784] Call Trace:
[  167.707902]  [<ffffffff810391f0>] cpu_idle+0xae/0xcc
[  167.727340]  [<ffffffff81c064f3>] start_secondary+0xbd/0xbf
[  167.727612] NMI backtrace for cpu 88
[  167.747140] CPU 88 
[  167.747258] Modules linked in:
[  167.747441] 
[  167.747520] Pid: 0, comm: kworker/0:1 Not tainted 2.6.39-rc6-tip-yh-03030-gfb0b6a9 #985 Oracle Corporation  Sun Fire X4800/     
[  167.767452] RIP: 0010:[<ffffffff810409eb>]  [<ffffffff810409eb>] mwait_idle+0xef/0x169
[  167.787360] RSP: 0000:ffff88103e651ee8  EFLAGS: 00000246
[  167.787650] RAX: 0000000000000000 RBX: ffff88103e651fd8 RCX: 0000000000000000
[  167.807319] RDX: 0000000000000000 RSI: 0000000000000001 RDI: ffff88103e64c560
[  167.827053] RBP: ffff88103e651ef8 R08: 0000000000000000 R09: 0000000000000000
[  167.827415] R10: 0000000000000000 R11: ffff88103e651ed8 R12: 0000000000000058
[  167.848237] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
[  167.866944] FS:  0000000000000000(0000) GS:ffff88407ee00000(0000) knlGS:0000000000000000
[  167.867406] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  167.887050] CR2: 0000000000000000 CR3: 000000000239d000 CR4: 00000000000006e0
[  167.906823] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  167.907276] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  167.926921] Process kworker/0:1 (pid: 0, threadinfo ffff88103e650000, task ffff88103e64c560)
[  167.946733] Stack:
[  167.946836]  ffff88103e650000 ffffffff82525380 ffff88103e651f28 ffffffff810391f0
[  167.966640]  ffff88103e651f18 864a7adc0ed319da 0000000000000000 0000000000000000
[  167.967117]  ffff88103e651f48 ffffffff81c064f3 0000000000000000 43de25d7d634e3af
[  167.986821] Call Trace:
[  167.986961]  [<ffffffff810391f0>] cpu_idle+0xae/0xcc
[  168.006546]  [<ffffffff81c064f3>] start_secondary+0xbd/0xbf
[  168.006909] Code: 00 00 48 89 d1 48 8d 83 38 e0 ff ff 0f 01 c8 0f ae f0 48 8b 83 38 e0 ff ff a8 08 75 10 e8 ec fd 06 00 31 c0 48 89 c1 fb 0f 01 c9 <eb> 06 e8 dc fd 06 00 fb 8b 05 0f 0a 4e 01 65 44 8b 24 25 30 c7 
[  168.046737] Call Trace:
[  168.046907]  [<ffffffff810391f0>] cpu_idle+0xae/0xcc
[  168.047123]  [<ffffffff81c064f3>] start_secondary+0xbd/0xbf
[  168.072366] NMI backtrace for cpu 91
[  168.072590] CPU 91 
[  168.072697] Modules linked in:
[  168.086500] 
[  168.086574] Pid: 0, comm: kworker/0:1 Not tainted 2.6.39-rc6-tip-yh-03030-gfb0b6a9 #985 Oracle Corporation  Sun Fire X4800/     
[  168.106603] RIP: 0010:[<ffffffff810409eb>]  [<ffffffff810409eb>] mwait_idle+0xef/0x169
[  168.126361] RSP: 0000:ffff88103e68bee8  EFLAGS: 00000246
[  168.126617] RAX: 0000000000000000 RBX: ffff88103e68bfd8 RCX: 0000000000000000
[  168.146509] RDX: 0000000000000000 RSI: 0000000000000001 RDI: ffff88103e684560
[  168.146838] RBP: ffff88103e68bef8 R08: 0000000000000000 R09: 0000000000000000
[  168.166733] R10: 0000000000000000 R11: ffff88103e68bed8 R12: 000000000000005b
[  168.186481] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
[  168.186845] FS:  0000000000000000(0000) GS:ffff88407f400000(0000) knlGS:0000000000000000
[  168.206569] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  168.226269] CR2: 0000000000000000 CR3: 000000000239d000 CR4: 00000000000006e0
[  168.226658] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  168.246454] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  168.266014] Process kworker/0:1 (pid: 0, threadinfo ffff88103e68a000, task ffff88103e684560)
[  168.266386] Stack:
[  168.266491]  ffff88103e68a000 ffffffff82525380 ffff88103e68bf28 ffffffff810391f0
[  168.286319]  ffff88103e68bf18 dacf332056ee6f33 0000000000000000 0000000000000000
[  168.306112]  ffff88103e68bf48 ffffffff81c064f3 0000000000000000 1e902c36a88edc60
[  168.306508] Call Trace:
[  168.325977]  [<ffffffff810391f0>] cpu_idle+0xae/0xcc
[  168.326224]  [<ffffffff81c064f3>] start_secondary+0xbd/0xbf
[  168.345962] Code: 00 00 48 89 d1 48 8d 83 38 e0 ff ff 0f 01 c8 0f ae f0 48 8b 83 38 e0 ff ff a8 08 75 10 e8 ec fd 06 00 31 c0 48 89 c1 fb 0f 01 c9 <eb> 06 e8 dc fd 06 00 fb 8b 05 0f 0a 4e 01 65 44 8b 24 25 30 c7 
[  168.366617] Call Trace:
[  168.385787]  [<ffffffff810391f0>] cpu_idle+0xae/0xcc
[  168.386052]  [<ffffffff81c064f3>] start_secondary+0xbd/0xbf
[  168.405723] NMI backtrace for cpu 94
[  168.405913] CPU 94 
[  168.406002] Modules linked in:
[  168.406238] 
[  168.406339] Pid: 0, comm: kworker/0:1 Not tainted 2.6.39-rc6-tip-yh-03030-gfb0b6a9 #985 Oracle Corporation  Sun Fire X4800/     
[  168.426256] RIP: 0010:[<ffffffff810409eb>]  [<ffffffff810409eb>] mwait_idle+0xef/0x169
[  168.446018] RSP: 0000:ffff88103e6b7ee8  EFLAGS: 00000246
[  168.465683] RAX: 0000000000000000 RBX: ffff88103e6b7fd8 RCX: 0000000000000000
[  168.466109] RDX: 0000000000000000 RSI: 0000000000000001 RDI: ffff88103e6cc560
[  168.485868] RBP: ffff88103e6b7ef8 R08: 0000000000000000 R09: 0000000000000000
[  168.505608] R10: 0000000000000000 R11: ffff88103e6b7ed8 R12: 000000000000005e
[  168.505956] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
[  168.525703] FS:  0000000000000000(0000) GS:ffff88407fa00000(0000) knlGS:0000000000000000
[  168.545537] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  168.545788] CR2: 0000000000000000 CR3: 000000000239d000 CR4: 00000000000006e0
[  168.565561] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  168.565992] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  168.585669] Process kworker/0:1 (pid: 0, threadinfo ffff88103e6b6000, task ffff88103e6cc560)
[  168.605513] Stack:
[  168.605644]  ffff88103e6b6000 ffffffff82525380 ffff88103e6b7f28 ffffffff810391f0
[  168.625416]  ffff88103e6b7f18 a9fa8bc8dff9b80c 0000000000000000 0000000000000000
[  168.625823]  ffff88103e6b7f48 ffffffff81c064f3 0000000000000000 37bc997f211760a8
[  168.645570] Call Trace:
[  168.645708]  [<ffffffff810391f0>] cpu_idle+0xae/0xcc
[  168.665305]  [<ffffffff81c064f3>] start_secondary+0xbd/0xbf
[  168.665604] Code: 00 00 48 89 d1 48 8d 83 38 e0 ff ff 0f 01 c8 0f ae f0 48 8b 83 38 e0 ff ff a8 08 75 10 e8 ec fd 06 00 31 c0 48 89 c1 fb 0f 01 c9 <eb> 06 e8 dc fd 06 00 fb 8b 05 0f 0a 4e 01 65 44 8b 24 25 30 c7 
[  168.706857] Call Trace:
[  168.706977]  [<ffffffff810391f0>] cpu_idle+0xae/0xcc
[  168.725229]  [<ffffffff81c064f3>] start_secondary+0xbd/0xbf
[  168.725492] NMI backtrace for cpu 90
[  168.725664] CPU 90 
[  168.745087] Modules linked in:
[  168.745301] 
[  168.745387] Pid: 0, comm: kworker/0:1 Not tainted 2.6.39-rc6-tip-yh-03030-gfb0b6a9 #985 Oracle Corporation  Sun Fire X4800/     
[  168.765351] RIP: 0010:[<ffffffff810409eb>]  [<ffffffff810409eb>] mwait_idle+0xef/0x169
[  168.785094] RSP: 0000:ffff88103e66dee8  EFLAGS: 00000246
[  168.785415] RAX: 0000000000000000 RBX: ffff88103e66dfd8 RCX: 0000000000000000
[  168.805151] RDX: 0000000000000000 RSI: 0000000000000001 RDI: ffff88103e67c560
[  168.824885] RBP: ffff88103e66def8 R08: 0000000000000000 R09: 0000000000000000
[  168.825303] R10: 0000000000000000 R11: ffff88103e66ded8 R12: 000000000000005a
[  168.845106] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
[  168.845509] FS:  0000000000000000(0000) GS:ffff88407f200000(0000) knlGS:0000000000000000
[  168.865194] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  168.884911] CR2: 0000000000000000 CR3: 000000000239d000 CR4: 00000000000006e0
[  168.885293] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  168.904978] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  168.924769] Process kworker/0:1 (pid: 0, threadinfo ffff88103e66c000, task ffff88103e67c560)
[  168.925292] Stack:
[  168.944713]  ffff88103e66c000 ffffffff82525380 ffff88103e66df28 ffffffff810391f0
[  168.945128]  ffff88103e66df18 6f19056750a6e749 0000000000000000 0000000000000000
[  168.964888]  ffff88103e66df48 ffffffff81c064f3 0000000000000000 66829d37004aca91
[  168.984629] Call Trace:
[  168.984750]  [<ffffffff810391f0>] cpu_idle+0xae/0xcc
[  168.985016]  [<ffffffff81c064f3>] start_secondary+0xbd/0xbf
[  169.004665] Code: 00 00 48 89 d1 48 8d 83 38 e0 ff ff 0f 01 c8 0f ae f0 48 8b 83 38 e0 ff ff a8 08 75 10 e8 ec fd 06 00 31 c0 48 89 c1 fb 0f 01 c9 <eb> 06 e8 dc fd 06 00 fb 8b 05 0f 0a 4e 01 65 44 8b 24 25 30 c7 
[  169.044433] Call Trace:
[  169.044580]  [<ffffffff810391f0>] cpu_idle+0xae/0xcc
[  169.044858]  [<ffffffff81c064f3>] start_secondary+0xbd/0xbf
[  169.064498] NMI backtrace for cpu 100
[  169.064677] CPU 100 
[  169.064810] Modules linked in:
[  169.065076] 
[  169.084413] Pid: 0, comm: kworker/0:1 Not tainted 2.6.39-rc6-tip-yh-03030-gfb0b6a9 #985 Oracle Corporation  Sun Fire X4800/     
[  169.104420] RIP: 0010:[<ffffffff810409eb>]  [<ffffffff810409eb>] mwait_idle+0xef/0x169
[  169.104894] RSP: 0000:ffff88103e73dee8  EFLAGS: 00000246
[  169.124467] RAX: 0000000000000000 RBX: ffff88103e73dfd8 RCX: 0000000000000000
[  169.144339] RDX: 0000000000000000 RSI: 0000000000000001 RDI: ffff88103e7322b0
[  169.144767] RBP: ffff88103e73def8 R08: 0000000000000000 R09: 0000000000000000
[  169.164487] R10: 0000000000000000 R11: ffff88103e73ded8 R12: 0000000000000064
[  169.164878] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
[  169.184760] FS:  0000000000000000(0000) GS:ffff88507f600000(0000) knlGS:0000000000000000
[  169.204573] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  169.204908] CR2: 0000000000000000 CR3: 000000000239d000 CR4: 00000000000006e0
[  169.224623] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  169.244215] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  169.244549] Process kworker/0:1 (pid: 0, threadinfo ffff88103e73c000, task ffff88103e7322b0)
[  169.264442] Stack:
[  169.264535]  ffff88103e73c000 ffffffff82525380 ffff88103e73df28 ffffffff810391f0
[  169.284155]  ffff88103e73df18 ec3d40b388e1a820 0000000000000000 0000000000000000
[  169.303948]  ffff88103e73df48 ffffffff81c064f3 0000000000000000 7819af42c6415509
[  169.304385] Call Trace:
[  169.304503]  [<ffffffff810391f0>] cpu_idle+0xae/0xcc
[  169.324093]  [<ffffffff81c064f3>] start_secondary+0xbd/0xbf
[  169.324354] Code: 00 00 48 89 d1 48 8d 83 38 e0 ff ff 0f 01 c8 0f ae f0 48 8b 83 38 e0 ff ff a8 08 75 10 e8 ec fd 06 00 31 c0 48 89 c1 fb 0f 01 c9 <eb> 06 e8 dc fd 06 00 fb 8b 05 0f 0a 4e 01 65 44 8b 24 25 30 c7 
[  169.364412] Call Trace:
[  169.364559]  [<ffffffff810391f0>] cpu_idle+0xae/0xcc
[  169.384024]  [<ffffffff81c064f3>] start_secondary+0xbd/0xbf
[  169.384305] NMI backtrace for cpu 103
[  169.403770] CPU 103 
[  169.403898] Modules linked in:
[  169.404109] 
[  169.404195] Pid: 0, comm: kworker/0:1 Not tainted 2.6.39-rc6-tip-yh-03030-gfb0b6a9 #985 Oracle Corporation  Sun Fire X4800/     
[  169.424087] RIP: 0010:[<ffffffff810409eb>]  [<ffffffff810409eb>] mwait_idle+0xef/0x169
[  169.443877] RSP: 0000:ffff88103e781ee8  EFLAGS: 00000246
[  169.444177] RAX: 0000000000000000 RBX: ffff88103e781fd8 RCX: 0000000000000000
[  169.463989] RDX: 0000000000000000 RSI: 0000000000000001 RDI: ffff88103e7722b0
[  169.483686] RBP: ffff88103e781ef8 R08: 0000000000000000 R09: 0000000000000000
[  169.484057] R10: 0000000000000000 R11: ffff88103e781ed8 R12: 0000000000000067
[  169.503796] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
[  169.523581] FS:  0000000000000000(0000) GS:ffff88507fc00000(0000) knlGS:0000000000000000
[  169.524098] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  169.543656] CR2: 0000000000000000 CR3: 000000000239d000 CR4: 00000000000006e0
[  169.563441] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  169.563857] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  169.583539] Process kworker/0:1 (pid: 0, threadinfo ffff88103e780000, task ffff88103e7722b0)
[  169.603357] Stack:
[  169.603495]  ffff88103e780000 ffffffff82525380 ffff88103e781f28 ffffffff810391f0
[  169.623253]  ffff88103e781f18 1edcc44015d74379 0000000000000000 0000000000000000
[  169.623711]  ffff88103e781f48 ffffffff81c064f3 0000000000000000 308c6b70699dc251
[  169.643418] Call Trace:
[  169.643554]  [<ffffffff810391f0>] cpu_idle+0xae/0xcc
[  169.663182]  [<ffffffff81c064f3>] start_secondary+0xbd/0xbf
[  169.663444] Code: 00 00 48 89 d1 48 8d 83 38 e0 ff ff 0f 01 c8 0f ae f0 48 8b 83 38 e0 ff ff a8 08 75 10 e8 ec fd 06 00 31 c0 48 89 c1 fb 0f 01 c9 <eb> 06 e8 dc fd 06 00 fb 8b 05 0f 0a 4e 01 65 44 8b 24 25 30 c7 
[  169.703340] Call Trace:
[  169.703458]  [<ffffffff810391f0>] cpu_idle+0xae/0xcc
[  169.703758]  [<ffffffff81c064f3>] start_secondary+0xbd/0xbf
[  169.723298] NMI backtrace for cpu 101
[  169.723463] CPU 101 
[  169.723565] Modules linked in:
[  169.743120] 
[  169.743197] Pid: 0, comm: kworker/0:1 Not tainted 2.6.39-rc6-tip-yh-03030-gfb0b6a9 #985 Oracle Corporation  Sun Fire X4800/     
[  169.763192] RIP: 0010:[<ffffffff810409eb>]  [<ffffffff810409eb>] mwait_idle+0xef/0x169
[  169.782980] RSP: 0000:ffff88103e753ee8  EFLAGS: 00000246
[  169.783243] RAX: 0000000000000000 RBX: ffff88103e753fd8 RCX: 0000000000000000
[  169.803029] RDX: 0000000000000000 RSI: 0000000000000001 RDI: ffff88103e7422b0
[  169.803351] RBP: ffff88103e753ef8 R08: 0000000000000000 R09: 0000000000000000
[  169.823148] R10: 0000000000000000 R11: ffff88103e753ed8 R12: 0000000000000065
[  169.842867] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
[  169.843256] FS:  0000000000000000(0000) GS:ffff88507f800000(0000) knlGS:0000000000000000
[  169.863068] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  169.882739] CR2: 0000000000000000 CR3: 000000000239d000 CR4: 00000000000006e0
[  169.883120] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  169.902849] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  169.922642] Process kworker/0:1 (pid: 0, threadinfo ffff88103e752000, task ffff88103e7422b0)
[  169.923101] Stack:
[  169.923202]  ffff88103e752000 ffffffff82525380 ffff88103e753f28 ffffffff810391f0
[  169.942961]  ffff88103e753f18 e51c0349f6f87d31 0000000000000000 0000000000000000
[  169.962742]  ffff88103e753f48 ffffffff81c064f3 0000000000000000 cf452dd59fbee8f3
[  169.963148] Call Trace:
[  169.982623]  [<ffffffff810391f0>] cpu_idle+0xae/0xcc
[  169.982891]  [<ffffffff81c064f3>] start_secondary+0xbd/0xbf
[  170.004075] Code: 00 00 48 89 d1 48 8d 83 38 e0 ff ff 0f 01 c8 0f ae f0 48 8b 83 38 e0 ff ff a8 08 75 10 e8 ec fd 06 00 31 c0 48 89 c1 fb 0f 01 c9 <eb> 06 e8 dc fd 06 00 fb 8b 05 0f 0a 4e 01 65 44 8b 24 25 30 c7 
[  170.023238] Call Trace:
[  170.042434]  [<ffffffff810391f0>] cpu_idle+0xae/0xcc
[  170.042747]  [<ffffffff81c064f3>] start_secondary+0xbd/0xbf
[  170.062353] NMI backtrace for cpu 97
[  170.062556] CPU 97 
[  170.062675] Modules linked in:
[  170.062851] 
[  170.062927] Pid: 0, comm: kworker/0:1 Not tainted 2.6.39-rc6-tip-yh-03030-gfb0b6a9 #985 Oracle Corporation  Sun Fire X4800/     
[  170.082837] RIP: 0010:[<ffffffff810409eb>]  [<ffffffff810409eb>] mwait_idle+0xef/0x169
[  170.102659] RSP: 0000:ffff88103e703ee8  EFLAGS: 00000246
[  170.122332] RAX: 0000000000000000 RBX: ffff88103e703fd8 RCX: 0000000000000000
[  170.122652] RDX: 0000000000000000 RSI: 0000000000000001 RDI: ffff88103e6fa2b0
[  170.142414] RBP: ffff88103e703ef8 R08: 0000000000000000 R09: 0000000000000000
[  170.162327] R10: 0000000000000000 R11: ffff88103e703ed8 R12: 0000000000000061
[  170.162671] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
[  170.182464] FS:  0000000000000000(0000) GS:ffff88507f000000(0000) knlGS:0000000000000000
[  170.202302] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  170.202604] CR2: 0000000000000000 CR3: 000000000239d000 CR4: 00000000000006e0
[  170.222348] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  170.222675] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  170.242449] Process kworker/0:1 (pid: 0, threadinfo ffff88103e702000, task ffff88103e6fa2b0)
[  170.262272] Stack:
[  170.262399]  ffff88103e702000 ffffffff82525380 ffff88103e703f28 ffffffff810391f0
[  170.282044]  ffff88103e703f18 5b6b76da7595c5ea 0000000000000000 0000000000000000
[  170.282455]  ffff88103e703f48 ffffffff81c064f3 0000000000000000 ef6e93bff8ea7807
[  170.302166] Call Trace:
[  170.302286]  [<ffffffff810391f0>] cpu_idle+0xae/0xcc
[  170.321949]  [<ffffffff81c064f3>] start_secondary+0xbd/0xbf
[  170.322203] Code: 00 00 48 89 d1 48 8d 83 38 e0 ff ff 0f 01 c8 0f ae f0 48 8b 83 38 e0 ff ff a8 08 75 10 e8 ec fd 06 00 31 c0 48 89 c1 fb 0f 01 c9 <eb> 06 e8 dc fd 06 00 fb 8b 05 0f 0a 4e 01 65 44 8b 24 25 30 c7 
[  170.362204] Call Trace:
[  170.362331]  [<ffffffff810391f0>] cpu_idle+0xae/0xcc
[  170.381831]  [<ffffffff81c064f3>] start_secondary+0xbd/0xbf
[  170.382118] NMI backtrace for cpu 96
[  170.382272] CPU 96 
[  170.401728] Modules linked in:
[  170.401964] 
[  170.403103] Pid: 0, comm: kworker/0:1 Not tainted 2.6.39-rc6-tip-yh-03030-gfb0b6a9 #985 Oracle Corporation  Sun Fire X4800/     
[  170.421996] RIP: 0010:[<ffffffff810409eb>]  [<ffffffff810409eb>] mwait_idle+0xef/0x169
[  170.441753] RSP: 0000:ffff88103e6edee8  EFLAGS: 00000246
[  170.442088] RAX: 0000000000000000 RBX: ffff88103e6edfd8 RCX: 0000000000000000
[  170.461779] RDX: 0000000000000000 RSI: 0000000000000001 RDI: ffff88103e6e4560
[  170.481516] RBP: ffff88103e6edef8 R08: 0000000000000000 R09: 0000000000000000
[  170.481904] R10: 0000000000000000 R11: ffff88103e6eded8 R12: 0000000000000060
[  170.501646] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
[  170.502047] FS:  0000000000000000(0000) GS:ffff88507ee00000(0000) knlGS:0000000000000000
[  170.521877] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  170.541472] CR2: 0000000000000000 CR3: 000000000239d000 CR4: 00000000000006e0
[  170.541835] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  170.561716] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  170.581394] Process kworker/0:1 (pid: 0, threadinfo ffff88103e6ec000, task ffff88103e6e4560)
[  170.581929] Stack:
[  170.601331]  ffff88103e6ec000 ffffffff82525380 ffff88103e6edf28 ffffffff810391f0
[  170.601707]  ffff88103e6edf18 38f7cba7c3e92042 0000000000000000 0000000000000000
[  170.621515]  ffff88103e6edf48 ffffffff81c064f3 0000000000000000 4bed50ad4b39cf1b
[  170.642398] Call Trace:
[  170.642538]  [<ffffffff810391f0>] cpu_idle+0xae/0xcc
[  170.642787]  [<ffffffff81c064f3>] start_secondary+0xbd/0xbf
[  170.661307] Code: 00 00 48 89 d1 48 8d 83 38 e0 ff ff 0f 01 c8 0f ae f0 48 8b 83 38 e0 ff ff a8 08 75 10 e8 ec fd 06 00 31 c0 48 89 c1 fb 0f 01 c9 <eb> 06 e8 dc fd 06 00 fb 8b 05 0f 0a 4e 01 65 44 8b 24 25 30 c7 
[  170.701074] Call Trace:
[  170.701196]  [<ffffffff810391f0>] cpu_idle+0xae/0xcc
[  170.701468]  [<ffffffff81c064f3>] start_secondary+0xbd/0xbf
[  170.721107] NMI backtrace for cpu 102
[  170.721292] CPU 102 
[  170.721387] Modules linked in:
[  170.721562] 
[  170.741029] Pid: 0, comm: kworker/0:1 Not tainted 2.6.39-rc6-tip-yh-03030-gfb0b6a9 #985 Oracle Corporation  Sun Fire X4800/     
[  170.761064] RIP: 0010:[<ffffffff810409eb>]  [<ffffffff810409eb>] mwait_idle+0xef/0x169
[  170.761494] RSP: 0000:ffff88103e763ee8  EFLAGS: 00000246
[  170.781065] RAX: 0000000000000000 RBX: ffff88103e763fd8 RCX: 0000000000000000
[  170.800849] RDX: 0000000000000000 RSI: 0000000000000001 RDI: ffff88103e75a2b0
[  170.801247] RBP: ffff88103e763ef8 R08: 0000000000000000 R09: 0000000000000000
[  170.820994] R10: 0000000000000000 R11: ffff88103e763ed8 R12: 0000000000000066
[  170.821358] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
[  170.841164] FS:  0000000000000000(0000) GS:ffff88507fa00000(0000) knlGS:0000000000000000
[  170.860923] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  170.861258] CR2: 0000000000000000 CR3: 000000000239d000 CR4: 00000000000006e0
[  170.880954] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  170.900721] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  170.901102] Process kworker/0:1 (pid: 0, threadinfo ffff88103e762000, task ffff88103e75a2b0)
[  170.920879] Stack:
[  170.920990]  ffff88103e762000 ffffffff82525380 ffff88103e763f28 ffffffff810391f0
[  170.940808]  ffff88103e763f18 73ced03514241cf0 0000000000000000 0000000000000000
[  170.970733]  ffff88103e763f48 ffffffff81c064f3 0000000000000000 e2284a4bb68b9280
[  170.971094] Call Trace:
[  170.971262]  [<ffffffff810391f0>] cpu_idle+0xae/0xcc
[  170.991230]  [<ffffffff81c064f3>] start_secondary+0xbd/0xbf
[  170.991552] Code: 00 00 48 89 d1 48 8d 83 38 e0 ff ff 0f 01 c8 0f ae f0 48 8b 83 38 e0 ff ff a8 08 75 10 e8 ec fd 06 00 31 c0 48 89 c1 fb 0f 01 c9 <eb> 06 e8 dc fd 06 00 fb 8b 05 0f 0a 4e 01 65 44 8b 24 25 30 c7 
[  171.031179] Call Trace:
[  171.031294]  [<ffffffff810391f0>] cpu_idle+0xae/0xcc
[  171.060699]  [<ffffffff81c064f3>] start_secondary+0xbd/0xbf
[  171.060986] NMI backtrace for cpu 108
[  171.080475] CPU 108 
[  171.080595] Modules linked in:
[  171.080795] 
[  171.080875] Pid: 0, comm: kworker/0:1 Not tainted 2.6.39-rc6-tip-yh-03030-gfb0b6a9 #985 Oracle Corporation  Sun Fire X4800/     
[  171.100803] RIP: 0010:[<ffffffff810409eb>]  [<ffffffff810409eb>] mwait_idle+0xef/0x169
[  171.120445] RSP: 0000:ffff88103e001ee8  EFLAGS: 00000246
[  171.120747] RAX: 0000000000000000 RBX: ffff88103e001fd8 RCX: 0000000000000000
[  171.140516] RDX: 0000000000000000 RSI: 0000000000000001 RDI: ffff88103e7d22b0
[  171.160264] RBP: ffff88103e001ef8 R08: 0000000000000000 R09: 0000000000000000
[  171.160674] R10: 0000000000000000 R11: ffff88103e001ed8 R12: 000000000000006c
[  171.180617] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
[  171.200160] FS:  0000000000000000(0000) GS:ffff88607f600000(0000) knlGS:0000000000000000
[  171.200691] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  171.220319] CR2: 0000000000000000 CR3: 000000000239d000 CR4: 00000000000006e0
[  171.241231] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  171.241544] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  171.270577] Process kworker/0:1 (pid: 0, threadinfo ffff88103e000000, task ffff88103e7d22b0)
[  171.290096] Stack:
[  171.290222]  ffff88103e000000 ffffffff82525380 ffff88103e001f28 ffffffff810391f0
[  171.310082]  ffff88103e001f18 cf3d086b299fbe80 0000000000000000 0000000000000000
[  171.310487]  ffff88103e001f48 ffffffff81c064f3 0000000000000000 b23c24525439199e
[  171.330119] Call Trace:
[  171.330227]  [<ffffffff810391f0>] cpu_idle+0xae/0xcc
[  171.349871]  [<ffffffff81c064f3>] start_secondary+0xbd/0xbf
[  171.350165] Code: 00 00 48 89 d1 48 8d 83 38 e0 ff ff 0f 01 c8 0f ae f0 48 8b 83 38 e0 ff ff a8 08 75 10 e8 ec fd 06 00 31 c0 48 89 c1 fb 0f 01 c9 <eb> 06 e8 dc fd 06 00 fb 8b 05 0f 0a 4e 01 65 44 8b 24 25 30 c7 
[  171.389904] Call Trace:
[  171.390044]  [<ffffffff810391f0>] cpu_idle+0xae/0xcc
[  171.390310]  [<ffffffff81c064f3>] start_secondary+0xbd/0xbf
[  171.409838] NMI backtrace for cpu 104
[  171.410012] CPU 104 
[  171.410110] Modules linked in:
[  171.429702] 
[  171.429788] Pid: 0, comm: kworker/0:1 Not tainted 2.6.39-rc6-tip-yh-03030-gfb0b6a9 #985 Oracle Corporation  Sun Fire X4800/     
[  171.449766] RIP: 0010:[<ffffffff810409eb>]  [<ffffffff810409eb>] mwait_idle+0xef/0x169
[  171.469562] RSP: 0000:ffff88103e787ee8  EFLAGS: 00000246
[  171.469810] RAX: 0000000000000000 RBX: ffff88103e787fd8 RCX: 0000000000000000
[  171.489590] RDX: 0000000000000000 RSI: 0000000000000001 RDI: ffff88103e78a2b0
[  171.490008] RBP: ffff88103e787ef8 R08: 0000000000000000 R09: 0000000000000000
[  171.509654] R10: 0000000000000000 R11: ffff88103e787ed8 R12: 0000000000000068
[  171.529460] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
[  171.529840] FS:  0000000000000000(0000) GS:ffff88607ee00000(0000) knlGS:0000000000000000
[  171.549642] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  171.569323] CR2: 0000000000000000 CR3: 000000000239d000 CR4: 00000000000006e0
[  171.569679] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  171.589412] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  171.609206] Process kworker/0:1 (pid: 0, threadinfo ffff88103e786000, task ffff88103e78a2b0)
[  171.609667] Stack:
[  171.609759]  ffff88103e786000 ffffffff82525380 ffff88103e787f28 ffffffff810391f0
[  171.629575]  ffff88103e787f18 dbaa9279e483322f 0000000000000000 0000000000000000
[  171.649302]  ffff88103e787f48 ffffffff81c064f3 0000000000000000 83aabbf70c51afbb
[  171.649704] Call Trace:
[  171.669186]  [<ffffffff810391f0>] cpu_idle+0xae/0xcc
[  171.669449]  [<ffffffff81c064f3>] start_secondary+0xbd/0xbf
[  171.689113] Code: 00 00 48 89 d1 48 8d 83 38 e0 ff ff 0f 01 c8 0f ae f0 48 8b 83 38 e0 ff ff a8 08 75 10 e8 ec fd 06 00 31 c0 48 89 c1 fb 0f 01 c9 <eb> 06 e8 dc fd 06 00 fb 8b 05 0f 0a 4e 01 65 44 8b 24 25 30 c7 
[  171.709807] Call Trace:
[  171.728985]  [<ffffffff810391f0>] cpu_idle+0xae/0xcc
[  171.729222]  [<ffffffff81c064f3>] start_secondary+0xbd/0xbf
[  171.748934] NMI backtrace for cpu 106
[  171.749093] CPU 106 
[  171.749194] Modules linked in:
[  171.749370] 
[  171.749456] Pid: 0, comm: kworker/0:1 Not tainted 2.6.39-rc6-tip-yh-03030-gfb0b6a9 #985 Oracle Corporation  Sun Fire X4800/     
[  171.769411] RIP: 0010:[<ffffffff810409eb>]  [<ffffffff810409eb>] mwait_idle+0xef/0x169
[  171.789292] RSP: 0000:ffff88103e7b3ee8  EFLAGS: 00000246
[  171.808904] RAX: 0000000000000000 RBX: ffff88103e7b3fd8 RCX: 0000000000000000
[  171.809327] RDX: 0000000000000000 RSI: 0000000000000001 RDI: ffff88103e7aa2b0
[  171.829106] RBP: ffff88103e7b3ef8 R08: 0000000000000000 R09: 0000000000000000
[  171.848782] R10: 0000000000000000 R11: ffff88103e7b3ed8 R12: 000000000000006a
[  171.849165] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
[  171.868898] FS:  0000000000000000(0000) GS:ffff88607f200000(0000) knlGS:0000000000000000
[  171.888714] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  171.888998] CR2: 0000000000000000 CR3: 000000000239d000 CR4: 00000000000006e0
[  171.908746] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  171.909098] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  171.928948] Process kworker/0:1 (pid: 0, threadinfo ffff88103e7b2000, task ffff88103e7aa2b0)
[  171.948728] Stack:
[  171.948868]  ffff88103e7b2000 ffffffff82525380 ffff88103e7b3f28 ffffffff810391f0
[  171.968618]  ffff88103e7b3f18 f9eadedccb2cfa6c 0000000000000000 0000000000000000
[  171.969035]  ffff88103e7b3f48 ffffffff81c064f3 0000000000000000 8ad0f992b6df189f
[  171.988770] Call Trace:
[  171.988923]  [<ffffffff810391f0>] cpu_idle+0xae/0xcc
[  172.008510]  [<ffffffff81c064f3>] start_secondary+0xbd/0xbf
[  172.008819] Code: 00 00 48 89 d1 48 8d 83 38 e0 ff ff 0f 01 c8 0f ae f0 48 8b 83 38 e0 ff ff a8 08 75 10 e8 ec fd 06 00 31 c0 48 89 c1 fb 0f 01 c9 <eb> 06 e8 dc fd 06 00 fb 8b 05 0f 0a 4e 01 65 44 8b 24 25 30 c7 
[  172.048800] Call Trace:
[  172.048950]  [<ffffffff810391f0>] cpu_idle+0xae/0xcc
[  172.068323]  [<ffffffff81c064f3>] start_secondary+0xbd/0xbf
[  172.068603] NMI backtrace for cpu 120
[  172.068801] CPU 120 
[  172.088292] Modules linked in:
[  172.088468] 
[  172.088556] Pid: 0, comm: kworker/0:1 Not tainted 2.6.39-rc6-tip-yh-03030-gfb0b6a9 #985 Oracle Corporation  Sun Fire X4800/     
[  172.108503] RIP: 0010:[<ffffffff810409eb>]  [<ffffffff810409eb>] mwait_idle+0xef/0x169
[  172.128297] RSP: 0000:ffff88103e0f9ee8  EFLAGS: 00000246
[  172.128556] RAX: 0000000000000000 RBX: ffff88103e0f9fd8 RCX: 0000000000000000
[  172.148296] RDX: 0000000000000000 RSI: 0000000000000001 RDI: ffff88103e0f0000
[  172.169509] RBP: ffff88103e0f9ef8 R08: 0000000000000000 R09: 0000000000000000
[  172.169837] R10: 0000000000000000 R11: ffff88103e0f9ed8 R12: 0000000000000078
[  172.188344] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
[  172.208120] FS:  0000000000000000(0000) GS:ffff88807e800000(0000) knlGS:0000000000000000
[  172.208485] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  172.228278] CR2: 0000000000000000 CR3: 000000000239d000 CR4: 00000000000006e0
[  172.228602] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  172.248367] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  172.268087] Process kworker/0:1 (pid: 0, threadinfo ffff88103e0f8000, task ffff88103e0f0000)
[  172.268481] Stack:
[  172.287908]  ffff88103e0f8000 ffffffff82525380 ffff88103e0f9f28 ffffffff810391f0
[  172.288303]  ffff88103e0f9f18 9d1fa4a474be1569 0000000000000000 0000000000000000
[  172.308077]  ffff88103e0f9f48 ffffffff81c064f3 0000000000000000 33afc904d5c4ddb1
[  172.327846] Call Trace:
[  172.327960]  [<ffffffff810391f0>] cpu_idle+0xae/0xcc
[  172.328222]  [<ffffffff81c064f3>] start_secondary+0xbd/0xbf
[  172.347875] Code: 00 00 48 89 d1 48 8d 83 38 e0 ff ff 0f 01 c8 0f ae f0 48 8b 83 38 e0 ff ff a8 08 75 10 e8 ec fd 06 00 31 c0 48 89 c1 fb 0f 01 c9 <eb> 06 e8 dc fd 06 00 fb 8b 05 0f 0a 4e 01 65 44 8b 24 25 30 c7 
[  172.387661] Call Trace:
[  172.387809]  [<ffffffff810391f0>] cpu_idle+0xae/0xcc
[  172.388043]  [<ffffffff81c064f3>] start_secondary+0xbd/0xbf
[  172.407680] NMI backtrace for cpu 122
[  172.407854] CPU 122 
[  172.407943] Modules linked in:
[  172.427557] 
[  172.427635] Pid: 0, comm: kworker/0:1 Not tainted 2.6.39-rc6-tip-yh-03030-gfb0b6a9 #985 Oracle Corporation  Sun Fire X4800/     
[  172.447626] RIP: 0010:[<ffffffff810409eb>]  [<ffffffff810409eb>] mwait_idle+0xef/0x169
[  172.447999] RSP: 0000:ffff88103e10dee8  EFLAGS: 00000246
[  172.467688] RAX: 0000000000000000 RBX: ffff88103e10dfd8 RCX: 0000000000000000
[  172.487433] RDX: 0000000000000000 RSI: 0000000000000001 RDI: ffff88103e118000
[  172.487759] RBP: ffff88103e10def8 R08: 0000000000000000 R09: 0000000000000000
[  172.507538] R10: 0000000000000000 R11: ffff88103e10ded8 R12: 000000000000007a
[  172.507849] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
[  172.527659] FS:  0000000000000000(0000) GS:ffff88807ec00000(0000) knlGS:0000000000000000
[  172.547478] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  172.547724] CR2: 0000000000000000 CR3: 000000000239d000 CR4: 00000000000006e0
[  172.567497] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  172.587308] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  172.587631] Process kworker/0:1 (pid: 0, threadinfo ffff88103e10c000, task ffff88103e118000)
[  172.607455] Stack:
[  172.607560]  ffff88103e10c000 ffffffff82525380 ffff88103e10df28 ffffffff810391f0
[  172.627383]  ffff88103e10df18 5932e94ddd4561db 0000000000000000 0000000000000000
[  172.647168]  ffff88103e10df48 ffffffff81c064f3 0000000000000000 44418799c393f5ed
[  172.647585] Call Trace:
[  172.647693]  [<ffffffff810391f0>] cpu_idle+0xae/0xcc
[  172.667275]  [<ffffffff81c064f3>] start_secondary+0xbd/0xbf
[  172.667530] Code: 00 00 48 89 d1 48 8d 83 38 e0 ff ff 0f 01 c8 0f ae f0 48 8b 83 38 e0 ff ff a8 08 75 10 e8 ec fd 06 00 31 c0 48 89 c1 fb 0f 01 c9 <eb> 06 e8 dc fd 06 00 fb 8b 05 0f 0a 4e 01 65 44 8b 24 25 30 c7 
[  172.707611] Call Trace:
[  172.707731]  [<ffffffff810391f0>] cpu_idle+0xae/0xcc
[  172.727104]  [<ffffffff81c064f3>] start_secondary+0xbd/0xbf
[  172.727355] NMI backtrace for cpu 124
[  172.746972] CPU 124 
[  172.747068] Modules linked in:
[  172.747246] 
[  172.747339] Pid: 0, comm: kworker/0:1 Not tainted 2.6.39-rc6-tip-yh-03030-gfb0b6a9 #985 Oracle Corporation  Sun Fire X4800/     
[  172.767337] RIP: 0010:[<ffffffff810591f0>]  [<ffffffff810591f0>] __x2apic_send_IPI_dest+0x1f/0x21
[  172.787134] RSP: 0000:ffff88807f003d58  EFLAGS: 00000046
[  172.806808] RAX: 0000000000000c00 RBX: 0000000000000092 RCX: 0000000000000830
[  172.807113] RDX: 00000000000f0008 RSI: 0000000000000002 RDI: 00000000000f0008
[  172.826918] RBP: ffff88807f003d58 R08: 0000000000000040 R09: ffffffff82525388
[  172.846685] R10: 0000000000000000 R11: 0000000000000000 R12: 000000000000c7d0
[  172.847006] R13: 0000000000000002 R14: ffffffff82525380 R15: 000000000000007d
[  172.866832] FS:  0000000000000000(0000) GS:ffff88807f000000(0000) knlGS:0000000000000000
[  172.886643] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  172.886914] CR2: 0000000000000000 CR3: 000000000239d000 CR4: 00000000000006e0
[  172.906649] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  172.906973] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  172.926749] Process kworker/0:1 (pid: 0, threadinfo ffff88103e142000, task ffff88103e148000)
[  172.946616] Stack:
[  172.946709]  ffff88807f003d98 ffffffff81059440 ffff88807f003d78 0000000000002710
[  172.966529]  ffffffff823cbf80 0000000000000010 ffffffff823cbf80 7fffffffffffffff
[  172.966927]  ffff88807f003da8 ffffffff8105949a ffff88807f003dc8 ffffffff810560de
[  172.986675] Call Trace:
[  172.986810]  <IRQ> 
[  172.986920]  [<ffffffff81059440>] x2apic_send_IPI_mask+0x52/0x95
[  173.006568]  [<ffffffff8105949a>] x2apic_send_IPI_all+0x17/0x19
[  173.006841]  [<ffffffff810560de>] arch_trigger_all_cpu_backtrace+0x5a/0x8c
[  173.026610]  [<ffffffff810d2940>] print_other_cpu_stall+0x11c/0x12f
[  173.046349]  [<ffffffff810d2a38>] check_cpu_stall+0xe5/0xe9
[  173.046627]  [<ffffffff810d2a64>] __rcu_pending+0x28/0x10f
[  173.066334]  [<ffffffff810d317d>] rcu_check_callbacks+0x8b/0xb8
[  173.066598]  [<ffffffff8108e1e7>] update_process_times+0x41/0x77
[  173.086305]  [<ffffffff810aaa21>] tick_sched_timer+0x77/0x97
[  173.086584]  [<ffffffff8109ff4f>] __run_hrtimer+0xde/0x167
[  173.106246]  [<ffffffff810aa9aa>] ? tick_nohz_handler+0xd6/0xd6
[  173.106532]  [<ffffffff810a08e7>] hrtimer_interrupt+0xd1/0x1bd
[  173.126284]  [<ffffffff81c17b4c>] smp_apic_timer_interrupt+0x88/0x9b
[  173.126629]  [<ffffffff81c16c93>] apic_timer_interrupt+0x13/0x20
[  173.146261]  <EOI> 
[  173.146373]  [<ffffffff810409eb>] ? mwait_idle+0xef/0x169
[  173.166082]  [<ffffffff810409e2>] ? mwait_idle+0xe6/0x169
[  173.166344]  [<ffffffff810391f0>] cpu_idle+0xae/0xcc
[  173.186053]  [<ffffffff81c064f3>] start_secondary+0xbd/0xbf
[  173.186318] Code: 66 66 90 48 8b 05 09 5b bd 00 c9 c3 55 48 89 e5 66 66 66 66 90 b9 30 08 00 00 89 f0 09 d0 80 ce 04 83 fe 02 0f 44 c2 89 fa 0f 30 <c9> c3 55 48 89 e5 66 66 66 66 90 b8 01 00 00 00 c9 c3 55 48 89 
[  173.226163] Call Trace:
[  173.226268]  <IRQ>  [<ffffffff81059440>] x2apic_send_IPI_mask+0x52/0x95
[  173.247016]  [<ffffffff8105949a>] x2apic_send_IPI_all+0x17/0x19
[  173.247322]  [<ffffffff810560de>] arch_trigger_all_cpu_backtrace+0x5a/0x8c
[  173.266474]  [<ffffffff810d2940>] print_other_cpu_stall+0x11c/0x12f
[  173.266773]  [<ffffffff810d2a38>] check_cpu_stall+0xe5/0xe9
[  173.286065]  [<ffffffff810d2a64>] __rcu_pending+0x28/0x10f
[  173.286330]  [<ffffffff810d317d>] rcu_check_callbacks+0x8b/0xb8
[  173.305908]  [<ffffffff8108e1e7>] update_process_times+0x41/0x77
[  173.306176]  [<ffffffff810aaa21>] tick_sched_timer+0x77/0x97
[  173.325886]  [<ffffffff8109ff4f>] __run_hrtimer+0xde/0x167
[  173.326138]  [<ffffffff810aa9aa>] ? tick_nohz_handler+0xd6/0xd6
[  173.345862]  [<ffffffff810a08e7>] hrtimer_interrupt+0xd1/0x1bd
[  173.346116]  [<ffffffff81c17b4c>] smp_apic_timer_interrupt+0x88/0x9b
[  173.366028]  [<ffffffff81c16c93>] apic_timer_interrupt+0x13/0x20
[  173.385593]  <EOI>  [<ffffffff810409eb>] ? mwait_idle+0xef/0x169
[  173.385898]  [<ffffffff810409e2>] ? mwait_idle+0xe6/0x169
[  173.405586]  [<ffffffff810391f0>] cpu_idle+0xae/0xcc
[  173.405848]  [<ffffffff81c064f3>] start_secondary+0xbd/0xbf
[  173.425526] NMI backtrace for cpu 107
[  173.425699] CPU 107 
[  173.425811] Modules linked in:
[  173.425975] 
[  173.426053] Pid: 0, comm: kworker/0:1 Not tainted 2.6.39-rc6-tip-yh-03030-gfb0b6a9 #985 Oracle Corporation  Sun Fire X4800/     
[  173.465445] RIP: 0010:[<ffffffff810409eb>]  [<ffffffff810409eb>] mwait_idle+0xef/0x169
[  173.465906] RSP: 0000:ffff88103e7c9ee8  EFLAGS: 00000246
[  173.485511] RAX: 0000000000000000 RBX: ffff88103e7c9fd8 RCX: 0000000000000000
[  173.485865] RDX: 0000000000000000 RSI: 0000000000000001 RDI: ffff88103e7c22b0
[  173.505646] RBP: ffff88103e7c9ef8 R08: 0000000000000000 R09: 0000000000000000
[  173.525384] R10: 0000000000000000 R11: ffff88103e7c9ed8 R12: 000000000000006b
[  173.525737] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
[  173.545617] FS:  0000000000000000(0000) GS:ffff88607f400000(0000) knlGS:0000000000000000
[  173.565311] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  173.565598] CR2: 0000000000000000 CR3: 000000000239d000 CR4: 00000000000006e0
[  173.585404] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  173.585754] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  173.605629] Process kworker/0:1 (pid: 0, threadinfo ffff88103e7c8000, task ffff88103e7c22b0)
[  173.625290] Stack:
[  173.625392]  ffff88103e7c8000 ffffffff82525380 ffff88103e7c9f28 ffffffff810391f0
[  173.645191]  ffff88103e7c9f18 1eef3661459e59f7 0000000000000000 0000000000000000
[  173.645606]  ffff88103e7c9f48 ffffffff81c064f3 0000000000000000 d110419bdf32a799
[  173.665391] Call Trace:
[  173.665508]  [<ffffffff810391f0>] cpu_idle+0xae/0xcc
[  173.685087]  [<ffffffff81c064f3>] start_secondary+0xbd/0xbf
[  173.685361] Code: 00 00 48 89 d1 48 8d 83 38 e0 ff ff 0f 01 c8 0f ae f0 48 8b 83 38 e0 ff ff a8 08 75 10 e8 ec fd 06 00 31 c0 48 89 c1 fb 0f 01 c9 <eb> 06 e8 dc fd 06 00 fb 8b 05 0f 0a 4e 01 65 44 8b 24 25 30 c7 
[  173.725355] Call Trace:
[  173.725467]  [<ffffffff810391f0>] cpu_idle+0xae/0xcc
[  173.744945]  [<ffffffff81c064f3>] start_secondary+0xbd/0xbf
[  173.745235] NMI backtrace for cpu 111
[  173.745414] CPU 111 
[  173.764882] Modules linked in:
[  173.765068] 
[  173.765154] Pid: 0, comm: kworker/0:1 Not tainted 2.6.39-rc6-tip-yh-03030-gfb0b6a9 #985 Oracle Corporation  Sun Fire X4800/     
[  173.785160] RIP: 0010:[<ffffffff810409eb>]  [<ffffffff810409eb>] mwait_idle+0xef/0x169
[  173.804932] RSP: 0000:ffff88103e03bee8  EFLAGS: 00000246
[  173.805225] RAX: 0000000000000000 RBX: ffff88103e03bfd8 RCX: 0000000000000000
[  173.824951] RDX: 0000000000000000 RSI: 0000000000000001 RDI: ffff88103e0322b0
[  173.844721] RBP: ffff88103e03bef8 R08: 0000000000000000 R09: 0000000000000000
[  173.845119] R10: 0000000000000000 R11: ffff88103e03bed8 R12: 000000000000006f
[  173.864820] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
[  173.884582] FS:  0000000000000000(0000) GS:ffff88607fc00000(0000) knlGS:0000000000000000
[  173.885062] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  173.904719] CR2: 0000000000000000 CR3: 000000000239d000 CR4: 00000000000006e0
[  173.905102] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  173.924773] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  173.944577] Process kworker/0:1 (pid: 0, threadinfo ffff88103e03a000, task ffff88103e0322b0)
[  173.964428] Stack:
[  173.964536]  ffff88103e03a000 ffffffff82525380 ffff88103e03bf28 ffffffff810391f0
[  173.964963]  ffff88103e03bf18 cbecccf87c85ab64 0000000000000000 0000000000000000
[  173.984657]  ffff88103e03bf48 ffffffff81c064f3 0000000000000000 7d8c76c902581a69
[  174.004435] Call Trace:
[  174.004556]  [<ffffffff810391f0>] cpu_idle+0xae/0xcc
[  174.004812]  [<ffffffff81c064f3>] start_secondary+0xbd/0xbf
[  174.024453] Code: 00 00 48 89 d1 48 8d 83 38 e0 ff ff 0f 01 c8 0f ae f0 48 8b 83 38 e0 ff ff a8 08 75 10 e8 ec fd 06 00 31 c0 48 89 c1 fb 0f 01 c9 <eb> 06 e8 dc fd 06 00 fb 8b 05 0f 0a 4e 01 65 44 8b 24 25 30 c7 
[  174.064286] Call Trace:
[  174.064421]  [<ffffffff810391f0>] cpu_idle+0xae/0xcc
[  174.064684]  [<ffffffff81c064f3>] start_secondary+0xbd/0xbf
[  174.084288] NMI backtrace for cpu 110
[  174.084454] CPU 110 
[  174.084554] Modules linked in:
[  174.104155] 
[  174.104246] Pid: 0, comm: kworker/0:1 Not tainted 2.6.39-rc6-tip-yh-03030-gfb0b6a9 #985 Oracle Corporation  Sun Fire X4800/     
[  174.124218] RIP: 0010:[<ffffffff810409eb>]  [<ffffffff810409eb>] mwait_idle+0xef/0x169
[  174.124669] RSP: 0000:ffff88103e01dee8  EFLAGS: 00000246
[  174.144277] RAX: 0000000000000000 RBX: ffff88103e01dfd8 RCX: 0000000000000000
[  174.164040] RDX: 0000000000000000 RSI: 0000000000000001 RDI: ffff88103e0122b0
[  174.164388] RBP: ffff88103e01def8 R08: 0000000000000000 R09: 0000000000000000
[  174.184207] R10: 0000000000000000 R11: ffff88103e01ded8 R12: 000000000000006e
[  174.203949] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
[  174.204325] FS:  0000000000000000(0000) GS:ffff88607fa00000(0000) knlGS:0000000000000000
[  174.224273] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  174.224543] CR2: 0000000000000000 CR3: 000000000239d000 CR4: 00000000000006e0
[  174.244436] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  174.264550] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  174.264896] Process kworker/0:1 (pid: 0, threadinfo ffff88103e01c000, task ffff88103e0122b0)
[  174.284294] Stack:
[  174.284387]  ffff88103e01c000 ffffffff82525380 ffff88103e01df28 ffffffff810391f0
[  174.304005]  ffff88103e01df18 e1449d45a00f96cd 0000000000000000 0000000000000000
[  174.323764]  ffff88103e01df48 ffffffff81c064f3 0000000000000000 02e0a2113f244cc6
[  174.324159] Call Trace:
[  174.343634]  [<ffffffff810391f0>] cpu_idle+0xae/0xcc
[  174.343882]  [<ffffffff81c064f3>] start_secondary+0xbd/0xbf
[  174.344158] Code: 00 00 48 89 d1 48 8d 83 38 e0 ff ff 0f 01 c8 0f ae f0 48 8b 83 38 e0 ff ff a8 08 75 10 e8 ec fd 06 00 31 c0 48 89 c1 fb 0f 01 c9 <eb> 06 e8 dc fd 06 00 fb 8b 05 0f 0a 4e 01 65 44 8b 24 25 30 c7 
[  174.384288] Call Trace:
[  174.384425]  [<ffffffff810391f0>] cpu_idle+0xae/0xcc
[  174.403684]  [<ffffffff81c064f3>] start_secondary+0xbd/0xbf
[  174.403923] NMI backtrace for cpu 113
[  174.423560] CPU 113 
[  174.423663] Modules linked in:
[  174.423861] 
[  174.423934] Pid: 0, comm: kworker/0:1 Not tainted 2.6.39-rc6-tip-yh-03030-gfb0b6a9 #985 Oracle Corporation  Sun Fire X4800/     
[  174.443871] RIP: 0010:[<ffffffff810409eb>]  [<ffffffff810409eb>] mwait_idle+0xef/0x169
[  174.463695] RSP: 0000:ffff88103e069ee8  EFLAGS: 00000246
[  174.483352] RAX: 0000000000000000 RBX: ffff88103e069fd8 RCX: 0000000000000000
[  174.483659] RDX: 0000000000000000 RSI: 0000000000000001 RDI: ffff88103e060000
[  174.503485] RBP: ffff88103e069ef8 R08: 0000000000000000 R09: 0000000000000000
[  174.503801] R10: 0000000000000000 R11: ffff88103e069ed8 R12: 0000000000000071
[  174.523541] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
[  174.543378] FS:  0000000000000000(0000) GS:ffff88707f000000(0000) knlGS:0000000000000000
[  174.543737] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  174.563452] CR2: 0000000000000000 CR3: 000000000239d000 CR4: 00000000000006e0
[  174.583232] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  174.583557] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  174.603297] Process kworker/0:1 (pid: 0, threadinfo ffff88103e068000, task ffff88103e060000)
[  174.623192] Stack:
[  174.623287]  ffff88103e068000 ffffffff82525380 ffff88103e069f28 ffffffff810391f0
[  174.643073]  ffff88103e069f18 d8cc0a5355bbe9f7 0000000000000000 0000000000000000
[  174.643484]  ffff88103e069f48 ffffffff81c064f3 0000000000000000 43f4297694e0e1e5
[  174.663235] Call Trace:
[  174.663371]  [<ffffffff810391f0>] cpu_idle+0xae/0xcc
[  174.682994]  [<ffffffff81c064f3>] start_secondary+0xbd/0xbf
[  174.683234] Code: 00 00 48 89 d1 48 8d 83 38 e0 ff ff 0f 01 c8 0f ae f0 48 8b 83 38 e0 ff ff a8 08 75 10 e8 ec fd 06 00 31 c0 48 89 c1 fb 0f 01 c9 <eb> 06 e8 dc fd 06 00 fb 8b 05 0f 0a 4e 01 65 44 8b 24 25 30 c7 
[  174.723167] Call Trace:
[  174.723277]  [<ffffffff810391f0>] cpu_idle+0xae/0xcc
[  174.723498]  [<ffffffff81c064f3>] start_secondary+0xbd/0xbf
[  174.743169] NMI backtrace for cpu 109
[  174.743359] CPU 109 
[  174.743470] Modules linked in:
[  174.762927] 
[  174.763016] Pid: 0, comm: kworker/0:1 Not tainted 2.6.39-rc6-tip-yh-03030-gfb0b6a9 #985 Oracle Corporation  Sun Fire X4800/     
[  174.783023] RIP: 0010:[<ffffffff810409eb>]  [<ffffffff810409eb>] mwait_idle+0xef/0x169
[  174.802779] RSP: 0000:ffff88103e007ee8  EFLAGS: 00000246
[  174.803081] RAX: 0000000000000000 RBX: ffff88103e007fd8 RCX: 0000000000000000
[  174.822839] RDX: 0000000000000000 RSI: 0000000000000001 RDI: ffff88103e00a2b0
[  174.823230] RBP: ffff88103e007ef8 R08: 0000000000000000 R09: 0000000000000000
[  174.843067] R10: 0000000000000000 R11: ffff88103e007ed8 R12: 000000000000006d
[  174.862777] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
[  174.863173] FS:  0000000000000000(0000) GS:ffff88607f800000(0000) knlGS:0000000000000000
[  174.882958] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  174.902533] CR2: 0000000000000000 CR3: 000000000239d000 CR4: 00000000000006e0
[  174.902933] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  174.922697] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  174.942450] Process kworker/0:1 (pid: 0, threadinfo ffff88103e006000, task ffff88103e00a2b0)
[  174.942950] Stack:
[  174.962373]  ffff88103e006000 ffffffff82525380 ffff88103e007f28 ffffffff810391f0
[  174.962788]  ffff88103e007f18 b33cc9080e000452 0000000000000000 0000000000000000
[  174.982569]  ffff88103e007f48 ffffffff81c064f3 0000000000000000 f44d519eb03a804f
[  175.002295] Call Trace:
[  175.002431]  [<ffffffff810391f0>] cpu_idle+0xae/0xcc
[  175.002716]  [<ffffffff81c064f3>] start_secondary+0xbd/0xbf
[  175.022347] Code: 00 00 48 89 d1 48 8d 83 38 e0 ff ff 0f 01 c8 0f ae f0 48 8b 83 38 e0 ff ff a8 08 75 10 e8 ec fd 06 00 31 c0 48 89 c1 fb 0f 01 c9 <eb> 06 e8 dc fd 06 00 fb 8b 05 0f 0a 4e 01 65 44 8b 24 25 30 c7 
[  175.043133] Call Trace:
[  175.062263]  [<ffffffff810391f0>] cpu_idle+0xae/0xcc
[  175.062507]  [<ffffffff81c064f3>] start_secondary+0xbd/0xbf
[  175.082302] NMI backtrace for cpu 118
[  175.082476] CPU 118 
[  175.082569] Modules linked in:
[  175.082750] 
[  175.102358] Pid: 0, comm: kworker/0:1 Not tainted 2.6.39-rc6-tip-yh-03030-gfb0b6a9 #985 Oracle Corporation  Sun Fire X4800/     
[  175.122313] RIP: 0010:[<ffffffff810409eb>]  [<ffffffff810409eb>] mwait_idle+0xef/0x169
[  175.122690] RSP: 0000:ffff88103e0c3ee8  EFLAGS: 00000246
[  175.142254] RAX: 0000000000000000 RBX: ffff88103e0c3fd8 RCX: 0000000000000000
[  175.142563] RDX: 0000000000000000 RSI: 0000000000000001 RDI: ffff88103e0c8000
[  175.162634] RBP: ffff88103e0c3ef8 R08: 0000000000000000 R09: 0000000000000000
[  175.182892] R10: 0000000000000000 R11: ffff88103e0c3ed8 R12: 0000000000000076
[  175.183236] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
[  175.202258] FS:  0000000000000000(0000) GS:ffff88707fa00000(0000) knlGS:0000000000000000
[  175.222203] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  175.222483] CR2: 0000000000000000 CR3: 000000000239d000 CR4: 00000000000006e0
[  175.242067] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  175.261990] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  175.262321] Process kworker/0:1 (pid: 0, threadinfo ffff88103e0c2000, task ffff88103e0c8000)
[  175.282550] Stack:
[  175.282651]  ffff88103e0c2000 ffffffff82525380 ffff88103e0c3f28 ffffffff810391f0
[  175.301851]  ffff88103e0c3f18 baf4c5c5e3b24d3d 0000000000000000 0000000000000000
[  175.302273]  ffff88103e0c3f48 ffffffff81c064f3 0000000000000000 93acd84e907831b6
[  175.321996] Call Trace:
[  175.322117]  [<ffffffff810391f0>] cpu_idle+0xae/0xcc
[  175.341999]  [<ffffffff81c064f3>] start_secondary+0xbd/0xbf
[  175.342255] Code: 00 00 48 89 d1 48 8d 83 38 e0 ff ff 0f 01 c8 0f ae f0 48 8b 83 38 e0 ff ff a8 08 75 10 e8 ec fd 06 00 31 c0 48 89 c1 fb 0f 01 c9 <eb> 06 e8 dc fd 06 00 fb 8b 05 0f 0a 4e 01 65 44 8b 24 25 30 c7 
[  175.401990] Call Trace:
[  175.402123]  [<ffffffff810391f0>] cpu_idle+0xae/0xcc
[  175.421541]  [<ffffffff81c064f3>] start_secondary+0xbd/0xbf
[  175.421796] NMI backtrace for cpu 115
[  175.441389] CPU 115 
[  175.441514] Modules linked in:
[  175.441702] 
[  175.441786] Pid: 0, comm: kworker/0:1 Not tainted 2.6.39-rc6-tip-yh-03030-gfb0b6a9 #985 Oracle Corporation  Sun Fire X4800/     
[  175.461710] RIP: 0010:[<ffffffff810409eb>]  [<ffffffff810409eb>] mwait_idle+0xef/0x169
[  175.481505] RSP: 0000:ffff88103e07fee8  EFLAGS: 00000246
[  175.481767] RAX: 0000000000000000 RBX: ffff88103e07ffd8 RCX: 0000000000000000
[  175.501529] RDX: 0000000000000000 RSI: 0000000000000001 RDI: ffff88103e090000
[  175.521310] RBP: ffff88103e07fef8 R08: 0000000000000000 R09: 0000000000000000
[  175.521652] R10: 0000000000000000 R11: ffff88103e07fed8 R12: 0000000000000073
[  175.541406] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
[  175.561195] FS:  0000000000000000(0000) GS:ffff88707f400000(0000) knlGS:0000000000000000
[  175.561547] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  175.581297] CR2: 0000000000000000 CR3: 000000000239d000 CR4: 00000000000006e0
[  175.581618] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  175.601376] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  175.621180] Process kworker/0:1 (pid: 0, threadinfo ffff88103e07e000, task ffff88103e090000)
[  175.641133] Stack:
[  175.641236]  ffff88103e07e000 ffffffff82525380 ffff88103e07ff28 ffffffff810391f0
[  175.641635]  ffff88103e07ff18 03a98b03e6b043dd 0000000000000000 0000000000000000
[  175.661262]  ffff88103e07ff48 ffffffff81c064f3 0000000000000000 7da074131e177f44
[  175.681050] Call Trace:
[  175.681160]  [<ffffffff810391f0>] cpu_idle+0xae/0xcc
[  175.681405]  [<ffffffff81c064f3>] start_secondary+0xbd/0xbf
[  175.701054] Code: 00 00 48 89 d1 48 8d 83 38 e0 ff ff 0f 01 c8 0f ae f0 48 8b 83 38 e0 ff ff a8 08 75 10 e8 ec fd 06 00 31 c0 48 89 c1 fb 0f 01 c9 <eb> 06 e8 dc fd 06 00 fb 8b 05 0f 0a 4e 01 65 44 8b 24 25 30 c7 
[  175.740906] Call Trace:
[  175.741016]  [<ffffffff810391f0>] cpu_idle+0xae/0xcc
[  175.741263]  [<ffffffff81c064f3>] start_secondary+0xbd/0xbf
[  175.760890] NMI backtrace for cpu 114
[  175.761067] CPU 114 
[  175.761164] Modules linked in:
[  175.780766] 
[  175.780857] Pid: 0, comm: kworker/0:1 Not tainted 2.6.39-rc6-tip-yh-03030-gfb0b6a9 #985 Oracle Corporation  Sun Fire X4800/     
[  175.800802] RIP: 0010:[<ffffffff810409eb>]  [<ffffffff810409eb>] mwait_idle+0xef/0x169
[  175.801175] RSP: 0000:ffff88103e06fee8  EFLAGS: 00000246
[  175.820949] RAX: 0000000000000000 RBX: ffff88103e06ffd8 RCX: 0000000000000000
[  175.840618] RDX: 0000000000000000 RSI: 0000000000000001 RDI: ffff88103e070000
[  175.840955] RBP: ffff88103e06fef8 R08: 0000000000000000 R09: 0000000000000000
[  175.860755] R10: 0000000000000000 R11: ffff88103e06fed8 R12: 0000000000000072
[  175.880628] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
[  175.880976] FS:  0000000000000000(0000) GS:ffff88707f200000(0000) knlGS:0000000000000000
[  175.900667] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  175.900937] CR2: 0000000000000000 CR3: 000000000239d000 CR4: 00000000000006e0
[  175.920699] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  175.940501] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  175.940824] Process kworker/0:1 (pid: 0, threadinfo ffff88103e06e000, task ffff88103e070000)
[  175.960649] Stack:
[  175.960757]  ffff88103e06e000 ffffffff82525380 ffff88103e06ff28 ffffffff810391f0
[  175.980616]  ffff88103e06ff18 fd4b0bbf3b80b10e 0000000000000000 0000000000000000
[  176.000385]  ffff88103e06ff48 ffffffff81c064f3 0000000000000000 c5d770f1aa6234e7
[  176.000798] Call Trace:
[  176.020263]  [<ffffffff810391f0>] cpu_idle+0xae/0xcc
[  176.020475]  [<ffffffff81c064f3>] start_secondary+0xbd/0xbf
[  176.040168] Code: 00 00 48 89 d1 48 8d 83 38 e0 ff ff 0f 01 c8 0f ae f0 48 8b 83 38 e0 ff ff a8 08 75 10 e8 ec fd 06 00 31 c0 48 89 c1 fb 0f 01 c9 <eb> 06 e8 dc fd 06 00 fb 8b 05 0f 0a 4e 01 65 44 8b 24 25 30 c7 
[  176.060840] Call Trace:
[  176.060957]  [<ffffffff810391f0>] cpu_idle+0xae/0xcc
[  176.080298]  [<ffffffff81c064f3>] start_secondary+0xbd/0xbf
[  176.080576] NMI backtrace for cpu 119
[  176.100160] CPU 119 
[  176.100260] Modules linked in:
[  176.100446] 
[  176.100549] Pid: 0, comm: kworker/0:1 Not tainted 2.6.39-rc6-tip-yh-03030-gfb0b6a9 #985 Oracle Corporation  Sun Fire X4800/     
[  176.120486] RIP: 0010:[<ffffffff810409eb>]  [<ffffffff810409eb>] mwait_idle+0xef/0x169
[  176.140276] RSP: 0000:ffff88103e0e9ee8  EFLAGS: 00000246
[  176.159969] RAX: 0000000000000000 RBX: ffff88103e0e9fd8 RCX: 0000000000000000
[  176.160268] RDX: 0000000000000000 RSI: 0000000000000001 RDI: ffff88103e0e0000
[  176.180076] RBP: ffff88103e0e9ef8 R08: 0000000000000000 R09: 0000000000000000
[  176.200108] R10: 0000000000000000 R11: ffff88103e0e9ed8 R12: 0000000000000077
[  176.200422] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
[  176.219971] FS:  0000000000000000(0000) GS:ffff88707fc00000(0000) knlGS:0000000000000000
[  176.240055] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  176.240329] CR2: 0000000000000000 CR3: 000000000239d000 CR4: 00000000000006e0
[  176.260001] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  176.260323] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  176.280178] Process kworker/0:1 (pid: 0, threadinfo ffff88103e0e8000, task ffff88103e0e0000)
[  176.299884] Stack:
[  176.299995]  ffff88103e0e8000 ffffffff82525380 ffff88103e0e9f28 ffffffff810391f0
[  176.319666]  ffff88103e0e9f18 6e7842f8b5c2a888 0000000000000000 0000000000000000
[  176.320047]  ffff88103e0e9f48 ffffffff81c064f3 0000000000000000 b8cf95fcbad3979a
[  176.339828] Call Trace:
[  176.339961]  [<ffffffff810391f0>] cpu_idle+0xae/0xcc
[  176.359579]  [<ffffffff81c064f3>] start_secondary+0xbd/0xbf
[  176.359827] Code: 00 00 48 89 d1 48 8d 83 38 e0 ff ff 0f 01 c8 0f ae f0 48 8b 83 38 e0 ff ff a8 08 75 10 e8 ec fd 06 00 31 c0 48 89 c1 fb 0f 01 c9 <eb> 06 e8 dc fd 06 00 fb 8b 05 0f 0a 4e 01 65 44 8b 24 25 30 c7 
[  176.399776] Call Trace:
[  176.399884]  [<ffffffff810391f0>] cpu_idle+0xae/0xcc
[  176.400113]  [<ffffffff81c064f3>] start_secondary+0xbd/0xbf
[  176.419675] NMI backtrace for cpu 121
[  176.419851] CPU 121 
[  176.439359] Modules linked in:
[  176.439537] 
[  176.439615] Pid: 0, comm: kworker/0:1 Not tainted 2.6.39-rc6-tip-yh-03030-gfb0b6a9 #985 Oracle Corporation  Sun Fire X4800/     
[  176.459586] RIP: 0010:[<ffffffff810409eb>]  [<ffffffff810409eb>] mwait_idle+0xef/0x169
[  176.479535] RSP: 0000:ffff88103e0ffee8  EFLAGS: 00000246
[  176.479766] RAX: 0000000000000000 RBX: ffff88103e0fffd8 RCX: 0000000000000000
[  176.499399] RDX: 0000000000000000 RSI: 0000000000000001 RDI: ffff88103e100000
[  176.499713] RBP: ffff88103e0ffef8 R08: 0000000000000000 R09: 0000000000000000
[  176.519517] R10: 0000000000000000 R11: ffff88103e0ffed8 R12: 0000000000000079
[  176.539297] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
[  176.539598] FS:  0000000000000000(0000) GS:ffff88807ea00000(0000) knlGS:0000000000000000
[  176.559431] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  176.579153] CR2: 0000000000000000 CR3: 000000000239d000 CR4: 00000000000006e0
[  176.579454] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  176.599256] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  176.619029] Process kworker/0:1 (pid: 0, threadinfo ffff88103e0fe000, task ffff88103e100000)
[  176.619417] Stack:
[  176.638976]  ffff88103e0fe000 ffffffff82525380 ffff88103e0fff28 ffffffff810391f0
[  176.639365]  ffff88103e0fff18 d84b97c200bc65b0 0000000000000000 0000000000000000
[  176.659164]  ffff88103e0fff48 ffffffff81c064f3 0000000000000000 0bb7ccf3334ed6b1
[  176.678914] Call Trace:
[  176.679045]  [<ffffffff810391f0>] cpu_idle+0xae/0xcc
[  176.679291]  [<ffffffff81c064f3>] start_secondary+0xbd/0xbf
[  176.698947] Code: 00 00 48 89 d1 48 8d 83 38 e0 ff ff 0f 01 c8 0f ae f0 48 8b 83 38 e0 ff ff a8 08 75 10 e8 ec fd 06 00 31 c0 48 89 c1 fb 0f 01 c9 <eb> 06 e8 dc fd 06 00 fb 8b 05 0f 0a 4e 01 65 44 8b 24 25 30 c7 
[  176.719685] Call Trace:
[  176.738829]  [<ffffffff810391f0>] cpu_idle+0xae/0xcc
[  176.739063]  [<ffffffff81c064f3>] start_secondary+0xbd/0xbf
[  176.758748] NMI backtrace for cpu 112
[  176.758915] CPU 112 
[  176.759030] Modules linked in:
[  176.759200] 
[  176.778702] Pid: 0, comm: kworker/0:1 Not tainted 2.6.39-rc6-tip-yh-03030-gfb0b6a9 #985 Oracle Corporation  Sun Fire X4800/     
[  176.798700] RIP: 0010:[<ffffffff810409eb>]  [<ffffffff810409eb>] mwait_idle+0xef/0x169
[  176.799094] RSP: 0000:ffff88103e04bee8  EFLAGS: 00000246
[  176.818735] RAX: 0000000000000000 RBX: ffff88103e04bfd8 RCX: 0000000000000000
[  176.819047] RDX: 0000000000000000 RSI: 0000000000000001 RDI: ffff88103e058000
[  176.838845] RBP: ffff88103e04bef8 R08: 0000000000000000 R09: 0000000000000000
[  176.858608] R10: 0000000000000000 R11: ffff88103e04bed8 R12: 0000000000000070
[  176.858935] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
[  176.878744] FS:  0000000000000000(0000) GS:ffff88707ee00000(0000) knlGS:0000000000000000
[  176.898581] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  176.898838] CR2: 0000000000000000 CR3: 000000000239d000 CR4: 00000000000006e0
[  176.918587] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  176.938368] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  176.938680] Process kworker/0:1 (pid: 0, threadinfo ffff88103e04a000, task ffff88103e058000)
[  176.958545] Stack:
[  176.958648]  ffff88103e04a000 ffffffff82525380 ffff88103e04bf28 ffffffff810391f0
[  176.978461]  ffff88103e04bf18 eddbed60db20a548 0000000000000000 0000000000000000
[  176.978874]  ffff88103e04bf48 ffffffff81c064f3 0000000000000000 cc0f66974ad24309
[  176.998604] Call Trace:
[  176.998722]  [<ffffffff810391f0>] cpu_idle+0xae/0xcc
[  177.018375]  [<ffffffff81c064f3>] start_secondary+0xbd/0xbf
[  177.018628] Code: 00 00 48 89 d1 48 8d 83 38 e0 ff ff 0f 01 c8 0f ae f0 48 8b 83 38 e0 ff ff a8 08 75 10 e8 ec fd 06 00 31 c0 48 89 c1 fb 0f 01 c9 <eb> 06 e8 dc fd 06 00 fb 8b 05 0f 0a 4e 01 65 44 8b 24 25 30 c7 
[  177.058662] Call Trace:
[  177.058783]  [<ffffffff810391f0>] cpu_idle+0xae/0xcc
[  177.078171]  [<ffffffff81c064f3>] start_secondary+0xbd/0xbf
[  177.078406] NMI backtrace for cpu 117
[  177.098030] CPU 117 
[  177.098133] Modules linked in:
[  177.098321] 
[  177.098413] Pid: 0, comm: kworker/0:1 Not tainted 2.6.39-rc6-tip-yh-03030-gfb0b6a9 #985 Oracle Corporation  Sun Fire X4800/     
[  177.118343] RIP: 0010:[<ffffffff810409eb>]  [<ffffffff810409eb>] mwait_idle+0xef/0x169
[  177.138165] RSP: 0000:ffff88103e0b3ee8  EFLAGS: 00000246
[  177.138419] RAX: 0000000000000000 RBX: ffff88103e0b3fd8 RCX: 0000000000000000
[  177.158150] RDX: 0000000000000000 RSI: 0000000000000001 RDI: ffff88103e0b8000
[  177.177953] RBP: ffff88103e0b3ef8 R08: 0000000000000000 R09: 0000000000000000
[  177.178278] R10: 0000000000000000 R11: ffff88103e0b3ed8 R12: 0000000000000075
[  177.198098] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
[  177.217970] FS:  0000000000000000(0000) GS:ffff88707f800000(0000) knlGS:0000000000000000
[  177.218347] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  177.238072] CR2: 0000000000000000 CR3: 000000000239d000 CR4: 00000000000006e0
[  177.257983] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  177.258296] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  177.277854] Process kworker/0:1 (pid: 0, threadinfo ffff88103e0b2000, task ffff88103e0b8000)
[  177.297799] Stack:
[  177.297902]  ffff88103e0b2000 ffffffff82525380 ffff88103e0b3f28 ffffffff810391f0
[  177.298272]  ffff88103e0b3f18 3c05f38b456efa63 0000000000000000 0000000000000000
[  177.317959]  ffff88103e0b3f48 ffffffff81c064f3 0000000000000000 c20981672419ff31
[  177.337683] Call Trace:
[  177.337806]  [<ffffffff810391f0>] cpu_idle+0xae/0xcc
[  177.338044]  [<ffffffff81c064f3>] start_secondary+0xbd/0xbf
[  177.357713] Code: 00 00 48 89 d1 48 8d 83 38 e0 ff ff 0f 01 c8 0f ae f0 48 8b 83 38 e0 ff ff a8 08 75 10 e8 ec fd 06 00 31 c0 48 89 c1 fb 0f 01 c9 <eb> 06 e8 dc fd 06 00 fb 8b 05 0f 0a 4e 01 65 44 8b 24 25 30 c7 
[  177.397558] Call Trace:
[  177.397668]  [<ffffffff810391f0>] cpu_idle+0xae/0xcc
[  177.397902]  [<ffffffff81c064f3>] start_secondary+0xbd/0xbf
[  177.417546] NMI backtrace for cpu 116
[  177.417702] CPU 116 
[  177.417815] Modules linked in:
[  177.437415] 
[  177.437495] Pid: 0, comm: kworker/0:1 Not tainted 2.6.39-rc6-tip-yh-03030-gfb0b6a9 #985 Oracle Corporation  Sun Fire X4800/     
[  177.457463] RIP: 0010:[<ffffffff810409eb>]  [<ffffffff810409eb>] mwait_idle+0xef/0x169
[  177.477254] RSP: 0000:ffff88103e09dee8  EFLAGS: 00000246
[  177.477534] RAX: 0000000000000000 RBX: ffff88103e09dfd8 RCX: 0000000000000000
[  177.497285] RDX: 0000000000000000 RSI: 0000000000000001 RDI: ffff88103e0a0000
[  177.497622] RBP: ffff88103e09def8 R08: 0000000000000000 R09: 0000000000000000
[  177.517372] R10: 0000000000000000 R11: ffff88103e09ded8 R12: 0000000000000074
[  177.537173] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
[  177.537477] FS:  0000000000000000(0000) GS:ffff88707f600000(0000) knlGS:0000000000000000
[  177.557300] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  177.557546] CR2: 0000000000000000 CR3: 000000000239d000 CR4: 00000000000006e0
[  177.577367] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  177.597127] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  177.597452] Process kworker/0:1 (pid: 0, threadinfo ffff88103e09c000, task ffff88103e0a0000)
[  177.617307] Stack:
[  177.617408]  ffff88103e09c000 ffffffff82525380 ffff88103e09df28 ffffffff810391f0
[  177.637217]  ffff88103e09df18 f5a140315aa62005 0000000000000000 0000000000000000
[  177.656995]  ffff88103e09df48 ffffffff81c064f3 0000000000000000 45979eb37cc9aeb0
[  177.657430] Call Trace:
[  177.676927]  [<ffffffff810391f0>] cpu_idle+0xae/0xcc
[  177.677154]  [<ffffffff81c064f3>] start_secondary+0xbd/0xbf
[  177.696815] Code: 00 00 48 89 d1 48 8d 83 38 e0 ff ff 0f 01 c8 0f ae f0 48 8b 83 38 e0 ff ff a8 08 75 10 e8 ec fd 06 00 31 c0 48 89 c1 fb 0f 01 c9 <eb> 06 e8 dc fd 06 00 fb 8b 05 0f 0a 4e 01 65 44 8b 24 25 30 c7 
[  177.717521] Call Trace:
[  177.717651]  [<ffffffff810391f0>] cpu_idle+0xae/0xcc
[  177.736943]  [<ffffffff81c064f3>] start_secondary+0xbd/0xbf
[  177.737188] NMI backtrace for cpu 125
[  177.756805] CPU 125 
[  177.756897] Modules linked in:
[  177.757087] 
[  177.757163] Pid: 0, comm: kworker/0:1 Not tainted 2.6.39-rc6-tip-yh-03030-gfb0b6a9 #985 Oracle Corporation  Sun Fire X4800/     
[  177.777127] RIP: 0010:[<ffffffff810409eb>]  [<ffffffff810409eb>] mwait_idle+0xef/0x169
[  177.796916] RSP: 0000:ffff88103e159ee8  EFLAGS: 00000246
[  177.816590] RAX: 0000000000000000 RBX: ffff88103e159fd8 RCX: 0000000000000000
[  177.816924] RDX: 0000000000000000 RSI: 0000000000000001 RDI: ffff88103e150000
[  177.836719] RBP: ffff88103e159ef8 R08: 0000000000000000 R09: 0000000000000000
[  177.856497] R10: 0000000000000000 R11: ffff88103e159ed8 R12: 000000000000007d
[  177.856810] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
[  177.876696] FS:  0000000000000000(0000) GS:ffff88807f200000(0000) knlGS:0000000000000000
[  177.896413] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  177.896670] CR2: 0000000000000000 CR3: 000000000239d000 CR4: 00000000000006e0
[  177.916474] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  177.916785] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  177.936571] Process kworker/0:1 (pid: 0, threadinfo ffff88103e158000, task ffff88103e150000)
[  177.956438] Stack:
[  177.956528]  ffff88103e158000 ffffffff82525380 ffff88103e159f28 ffffffff810391f0
[  177.976430]  ffff88103e159f18 2ccd79cfdd34ac9e 0000000000000000 0000000000000000
[  177.976840]  ffff88103e159f48 ffffffff81c064f3 0000000000000000 10ccf89162e4ca4a
[  177.996459] Call Trace:
[  177.996608]  [<ffffffff810391f0>] cpu_idle+0xae/0xcc
[  178.016238]  [<ffffffff81c064f3>] start_secondary+0xbd/0xbf
[  178.016516] Code: 00 00 48 89 d1 48 8d 83 38 e0 ff ff 0f 01 c8 0f ae f0 48 8b 83 38 e0 ff ff a8 08 75 10 e8 ec fd 06 00 31 c0 48 89 c1 fb 0f 01 c9 <eb> 06 e8 dc fd 06 00 fb 8b 05 0f 0a 4e 01 65 44 8b 24 25 30 c7 
[  178.056435] Call Trace:
[  178.056550]  [<ffffffff810391f0>] cpu_idle+0xae/0xcc
[  178.076039]  [<ffffffff81c064f3>] start_secondary+0xbd/0xbf
[  178.076359] NMI backtrace for cpu 123
[  178.076517] CPU 123 
[  178.096023] Modules linked in:
[  178.096213] 
[  178.096289] Pid: 0, comm: kworker/0:1 Not tainted 2.6.39-rc6-tip-yh-03030-gfb0b6a9 #985 Oracle Corporation  Sun Fire X4800/     
[  178.116243] RIP: 0010:[<ffffffff810409eb>]  [<ffffffff810409eb>] mwait_idle+0xef/0x169
[  178.136006] RSP: 0000:ffff88103e12bee8  EFLAGS: 00000246
[  178.136240] RAX: 0000000000000000 RBX: ffff88103e12bfd8 RCX: 0000000000000000
[  178.156040] RDX: 0000000000000000 RSI: 0000000000000001 RDI: ffff88103e130000
[  178.156368] RBP: ffff88103e12bef8 R08: 0000000000000000 R09: 0000000000000000
[  178.176117] R10: 0000000000000000 R11: ffff88103e12bed8 R12: 000000000000007b
[  178.195946] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
[  178.196293] FS:  0000000000000000(0000) GS:ffff88807ee00000(0000) knlGS:0000000000000000
[  178.216128] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  178.235947] CR2: 0000000000000000 CR3: 000000000239d000 CR4: 00000000000006e0
[  178.236261] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  178.255967] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  178.276291] Process kworker/0:1 (pid: 0, threadinfo ffff88103e12a000, task ffff88103e130000)
[  178.276664] Stack:
[  178.295771]  ffff88103e12a000 ffffffff82525380 ffff88103e12bf28 ffffffff810391f0
[  178.296163]  ffff88103e12bf18 a4a843542a24023c 0000000000000000 0000000000000000
[  178.315916]  ffff88103e12bf48 ffffffff81c064f3 0000000000000000 e267619a78df27fa
[  178.335708] Call Trace:
[  178.335834]  [<ffffffff810391f0>] cpu_idle+0xae/0xcc
[  178.336074]  [<ffffffff81c064f3>] start_secondary+0xbd/0xbf
[  178.355568] Code: 00 00 48 89 d1 48 8d 83 38 e0 ff ff 0f 01 c8 0f ae f0 48 8b 83 38 e0 ff ff a8 08 75 10 e8 ec fd 06 00 31 c0 48 89 c1 fb 0f 01 c9 <eb> 06 e8 dc fd 06 00 fb 8b 05 0f 0a 4e 01 65 44 8b 24 25 30 c7 
[  178.376576] Call Trace:
[  178.395482]  [<ffffffff810391f0>] cpu_idle+0xae/0xcc
[  178.395696]  [<ffffffff81c064f3>] start_secondary+0xbd/0xbf
[  178.415403] NMI backtrace for cpu 105
[  178.415563] CPU 105 
[  178.415663] Modules linked in:
[  178.415851] 
[  178.435334] Pid: 0, comm: kworker/0:1 Not tainted 2.6.39-rc6-tip-yh-03030-gfb0b6a9 #985 Oracle Corporation  Sun Fire X4800/     
[  178.455580] RIP: 0010:[<ffffffff810409eb>]  [<ffffffff810409eb>] mwait_idle+0xef/0x169
[  178.455977] RSP: 0000:ffff88103e79dee8  EFLAGS: 00000246
[  178.475387] RAX: 0000000000000000 RBX: ffff88103e79dfd8 RCX: 0000000000000000
[  178.475802] RDX: 0000000000000000 RSI: 0000000000000001 RDI: ffff88103e7922b0
[  178.495462] RBP: ffff88103e79def8 R08: 0000000000000000 R09: 0000000000000000
[  178.515274] R10: 0000000000000000 R11: ffff88103e79ded8 R12: 0000000000000069
[  178.515657] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
[  178.535391] FS:  0000000000000000(0000) GS:ffff88607f000000(0000) knlGS:0000000000000000
[  178.555181] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  178.555495] CR2: 0000000000000000 CR3: 000000000239d000 CR4: 00000000000006e0
[  178.575260] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  178.595017] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  178.595353] Process kworker/0:1 (pid: 0, threadinfo ffff88103e79c000, task ffff88103e7922b0)
[  178.615200] Stack:
[  178.615322]  ffff88103e79c000 ffffffff82525380 ffff88103e79df28 ffffffff810391f0
[  178.635134]  ffff88103e79df18 7cc4089422c6d371 0000000000000000 0000000000000000
[  178.654849]  ffff88103e79df48 ffffffff81c064f3 0000000000000000 6ca04c2dc270ff18
[  178.655284] Call Trace:
[  178.655424]  [<ffffffff810391f0>] cpu_idle+0xae/0xcc
[  178.674979]  [<ffffffff81c064f3>] start_secondary+0xbd/0xbf
[  178.675290] Code: 00 00 48 89 d1 48 8d 83 38 e0 ff ff 0f 01 c8 0f ae f0 48 8b 83 38 e0 ff ff a8 08 75 10 e8 ec fd 06 00 31 c0 48 89 c1 fb 0f 01 c9 <eb> 06 e8 dc fd 06 00 fb 8b 05 0f 0a 4e 01 65 44 8b 24 25 30 c7 
[  178.715289] Call Trace:
[  178.715406]  [<ffffffff810391f0>] cpu_idle+0xae/0xcc
[  178.734804]  [<ffffffff81c064f3>] start_secondary+0xbd/0xbf
[  178.735144] NMI backtrace for cpu 126
[  178.754941] CPU 126 
[  178.755032] Modules linked in:
[  178.755201] 
[  178.755290] Pid: 0, comm: kworker/0:1 Not tainted 2.6.39-rc6-tip-yh-03030-gfb0b6a9 #985 Oracle Corporation  Sun Fire X4800/     
[  178.775008] RIP: 0010:[<ffffffff810409eb>]  [<ffffffff810409eb>] mwait_idle+0xef/0x169
[  178.794775] RSP: 0000:ffff88103e171ee8  EFLAGS: 00000246
[  178.795025] RAX: 0000000000000000 RBX: ffff88103e171fd8 RCX: 0000000000000000
[  178.814809] RDX: 0000000000000000 RSI: 0000000000000001 RDI: ffff88103e168000
[  178.834586] RBP: ffff88103e171ef8 R08: 0000000000000000 R09: 0000000000000000
[  178.834896] R10: 0000000000000000 R11: ffff88103e171ed8 R12: 000000000000007e
[  178.854681] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
[  178.874557] FS:  0000000000000000(0000) GS:ffff88807f400000(0000) knlGS:0000000000000000
[  178.874911] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  178.894550] CR2: 0000000000000000 CR3: 000000000239d000 CR4: 00000000000006e0
[  178.914336] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  178.914650] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  178.934465] Process kworker/0:1 (pid: 0, threadinfo ffff88103e170000, task ffff88103e168000)
[  178.954274] Stack:
[  178.954381]  ffff88103e170000 ffffffff82525380 ffff88103e171f28 ffffffff810391f0
[  178.954773]  ffff88103e171f18 5b8357237cb2986a 0000000000000000 0000000000000000
[  178.974574]  ffff88103e171f48 ffffffff81c064f3 0000000000000000 5d4840ef688c0c41
[  178.994347] Call Trace:
[  178.994476]  [<ffffffff810391f0>] cpu_idle+0xae/0xcc
[  178.994722]  [<ffffffff81c064f3>] start_secondary+0xbd/0xbf
[  179.014351] Code: 00 00 48 89 d1 48 8d 83 38 e0 ff ff 0f 01 c8 0f ae f0 48 8b 83 38 e0 ff ff a8 08 75 10 e8 ec fd 06 00 31 c0 48 89 c1 fb 0f 01 c9 <eb> 06 e8 dc fd 06 00 fb 8b 05 0f 0a 4e 01 65 44 8b 24 25 30 c7 
[  179.054246] Call Trace:
[  179.054376]  [<ffffffff810391f0>] cpu_idle+0xae/0xcc
[  179.054598]  [<ffffffff81c064f3>] start_secondary+0xbd/0xbf
[  179.074151] NMI backtrace for cpu 127
[  179.074317] CPU 127 
[  179.074407] Modules linked in:
[  179.094038] 
[  179.094119] Pid: 0, comm: kworker/0:1 Not tainted 2.6.39-rc6-tip-yh-03030-gfb0b6a9 #985 Oracle Corporation  Sun Fire X4800/     
[  179.114091] RIP: 0010:[<ffffffff810409eb>]  [<ffffffff810409eb>] mwait_idle+0xef/0x169
[  179.133888] RSP: 0000:ffff88103e177ee8  EFLAGS: 00000246
[  179.134130] RAX: 0000000000000000 RBX: ffff88103e177fd8 RCX: 0000000000000000
[  179.153912] RDX: 0000000000000000 RSI: 0000000000000001 RDI: ffff88103e188000
[  179.154239] RBP: ffff88103e177ef8 R08: 0000000000000000 R09: 0000000000000000
[  179.174044] R10: 0000000000000000 R11: ffff88103e177ed8 R12: 000000000000007f
[  179.193801] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
[  179.194108] FS:  0000000000000000(0000) GS:ffff88807f600000(0000) knlGS:0000000000000000
[  179.213996] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  179.233745] CR2: 0000000000000000 CR3: 000000000239d000 CR4: 00000000000006e0
[  179.234072] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  179.254037] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  179.254359] Process kworker/0:1 (pid: 0, threadinfo ffff88103e176000, task ffff88103e188000)
[  179.273981] Stack:
[  179.274099]  ffff88103e176000 ffffffff82525380 ffff88103e177f28 ffffffff810391f0
[  179.294154]  ffff88103e177f18 23c99be1e1fa11ca 0000000000000000 0000000000000000
[  179.313859]  ffff88103e177f48 ffffffff81c064f3 0000000000000000 75b2778518a8799c
[  179.314286] Call Trace:
[  179.333745]  [<ffffffff810391f0>] cpu_idle+0xae/0xcc
[  179.333980]  [<ffffffff81c064f3>] start_secondary+0xbd/0xbf
[  179.353757] Code: 00 00 48 89 d1 48 8d 83 38 e0 ff ff 0f 01 c8 0f ae f0 48 8b 83 38 e0 ff ff a8 08 75 10 e8 ec fd 06 00 31 c0 48 89 c1 fb 0f 01 c9 <eb> 06 e8 dc fd 06 00 fb 8b 05 0f 0a 4e 01 65 44 8b 24 25 30 c7 
[  179.374328] Call Trace:
[  179.374439]  [<ffffffff810391f0>] cpu_idle+0xae/0xcc
[  179.393814]  [<ffffffff81c064f3>] start_secondary+0xbd/0xbf

