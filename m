Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755014Ab1ESEe2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 00:34:28 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:30209 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753466Ab1ESEe1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 00:34:27 -0400
Message-ID: <4DD49DAF.5080605@kernel.org>
Date: Wed, 18 May 2011 21:33:51 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110414 SUSE/3.1.10 Thunderbird/3.1.10
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [GIT PULL rcu/next] rcu commits for 2.6.40
References: <20110513141431.GV2258@linux.vnet.ibm.com> <20110513150744.GE32688@elte.hu> <20110513162646.GW2258@linux.vnet.ibm.com> <20110516070808.GC24836@elte.hu> <20110516074822.GE2573@linux.vnet.ibm.com> <20110516115148.GA2421@elte.hu> <20110516122329.GA29356@elte.hu> <20110516212449.GJ2573@linux.vnet.ibm.com> <20110517024000.GA5026@nowhere> <4DD435C2.6040305@kernel.org> <20110518231314.GA1723@nowhere>
In-Reply-To: <20110518231314.GA1723@nowhere>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090201.4DD49DBB.009B,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/18/2011 04:13 PM, Frederic Weisbecker wrote:
> On Wed, May 18, 2011 at 02:10:26PM -0700, Yinghai Lu wrote:
>> On 05/16/2011 07:40 PM, Frederic Weisbecker wrote:
>>> On Mon, May 16, 2011 at 02:24:49PM -0700, Paul E. McKenney wrote:
>>>> On Mon, May 16, 2011 at 02:23:29PM +0200, Ingo Molnar wrote:
>>>>>
>>>>> * Ingo Molnar <mingo@elte.hu> wrote:
>>>>>
>>>>>>> In the meantime, would you be willing to try out the patch at 
>>>>>>> https://lkml.org/lkml/2011/5/14/89?  This patch helped out Yinghai in 
>>>>>>> several configurations.
>>>>>>
>>>>>> Wasn't this the one i tested - or is it a new iteration?
>>>>>>
>>>>>> I'll try it in any case.
>>>>>
>>>>> oh, this was a new iteration, mea culpa!
>>>>>
>>>>> And yes, it solves all problems for me as well. Mind pushing it as a fix? :-)
>>>>
>>>> ;-)
>>>>
>>>> Unfortunately, the only reason I can see that it works is (1) there
>>>> is some obscure bug in my code or (2) someone somewhere is failing to
>>>> call irq_exit() on some interrupt-exit path.  Much as I might be tempted
>>>> to paper this one over, I believe that we do need to find whatever the
>>>> underlying bug is.
>>>>
>>>> Oh, yes, there is option (3) as well: maybe if an interrupt deschedules
>>>> a process, the final irq_exit() is omitted in favor of rcu_enter_nohz()?
>>>> But I couldn't see any evidence of this in my admittedly cursory scan
>>>> of the x86 interrupt-handling code.
>>>>
>>>> So until I learn differently, I am assuming that each and every
>>>> irq_enter() has a matching call to irq_exit(), and that rcu_enter_nohz()
>>>> is called after the final irq_exit() of a given burst of interrupts.
>>>>
>>>> If my assumptions are mistaken, please do let me know!
>>>
>>> So it would be nice to have a trace of the calls to rcu_irq_*() / rcu_*_nohz()
>>> before the unpairing happened.
>>>
>>> I have tried to reproduce it but couldn't trigger anything.
>>>
>>> So it would be nice if Yinghai can test the patch below, since he was able
>>> to trigger the warning.
>>>
>>> This is essentially Paul's patch but with stacktrace of the calls recorded.
>>> Then the whole trace is dumped on the console when one of the WARN_ON_ONCE
>>> sanity check is positive. Beware as the trace will be dumped everytime
>>> WARN_ON_ONCE() is positive. So the first dump is enough, you can ignore the
>>> rest.
>>>
>>> This requires CONFIG_TRACING. May be a good thing to boot with
>>> "ftrace=nop" parameter, so that ftrace will set up a long enough buffer
>>> to have an interesting trace.
>>
>> with this patches if the kernel is compiled from opensuse 11.3 no delay anymore, but have one warning:
>>
>> [   82.895182] ------------[ cut here ]------------
>> [   82.895189] WARNING: at kernel/rcutree.c:352 rcu_enter_nohz+0x49/0x8b()
>> [   82.895193] Switched to NOHz mode on CPU #90
>> [   82.895199] Switched to NOHz mode on CPU #8
>> [   82.895202] Modules linked in:
>> [   82.895206] Switched to NOHz mode on CPU #28
>> [   82.895211] Pid: 0, comm: swapper Not tainted 2.6.39-rc7-tip-yh-05234-g3a108a0-dirty #1016
>> [   82.895213] Call Trace:
>> [   82.895233]  [<ffffffff81080144>] warn_slowpath_common+0x85/0x9d
>> [   82.895238]  [<ffffffff81080176>] warn_slowpath_null+0x1a/0x1c
>> [   82.895242]  [<ffffffff810d32cc>] rcu_enter_nohz+0x49/0x8b
>> [   82.895250]  [<ffffffff810ab121>] tick_nohz_stop_sched_tick+0x27d/0x366
>> [   82.895255]  [<ffffffff810391bc>] cpu_idle+0x7a/0xcc
>> [   82.895261]  [<ffffffff81bda6e3>] rest_init+0xb7/0xbe
>> [   82.895266]  [<ffffffff81bda62c>] ? csum_partial_copy_generic+0x16c/0x16c
>> [   82.895272]  [<ffffffff82742e39>] start_kernel+0x3b2/0x3bd
>> [   82.895276]  [<ffffffff827422cc>] x86_64_start_reservations+0x9c/0xa0
>> [   82.895281]  [<ffffffff827424a8>] x86_64_start_kernel+0x1d8/0x1e3
>> [   82.895290] ---[ end trace 2cfc591bf7de931f ]---
>> [   82.895310] Switched to NOHz mode on CPU #72
>> [   82.895315] Dumping ftrace buffer:
>> [   82.895328] ---------------------------------
>> [   82.895340] CPU:0 [LOST 35328 EVENTS]
>> [   82.895341]   <idle>-0       0d... 82735399us : Unknown type 4
> 
> Doh, ftrace couldn't recognize that trace is of stacktrace type. We
> need to initialize the events output earlier.
> 
> Sorry, can you retry after applying the following patch?
> 
> diff --git a/kernel/trace/trace_output.c b/kernel/trace/trace_output.c
> index cf535cc..ad92d9c 100644
> --- a/kernel/trace/trace_output.c
> +++ b/kernel/trace/trace_output.c
> @@ -1278,4 +1278,4 @@ __init static int init_events(void)
>  
>  	return 0;
>  }
> -device_initcall(init_events);
> +early_initcall(init_events);

...
[   89.913205] ------------[ cut here ]------------
[   89.913216] WARNING: at kernel/rcutree.c:352 rcu_enter_nohz+0x49/0x8b()
[   89.913220] Hardware name: Sun Fire X4800 M2 
[   89.913224] Modules linked in:
[   89.913230] Switched to NOHz mode on CPU #34
[   89.913237] Pid: 0, comm: swapper Tainted: G        W   2.6.39-rc7-tip-yh-05281-g8e9254b-dirty #1019
[   89.913242] Call Trace:
[   89.913269]  [<ffffffff81080144>] warn_slowpath_common+0x85/0x9d
[   89.913280]  [<ffffffff81080176>] warn_slowpath_null+0x1a/0x1c
[   89.913290]  [<ffffffff810d32cc>] rcu_enter_nohz+0x49/0x8b
[   89.913305]  [<ffffffff810ab121>] tick_nohz_stop_sched_tick+0x27d/0x366
[   89.913317]  [<ffffffff810391bc>] cpu_idle+0x7a/0xcc
[   89.913329]  [<ffffffff81bda6e3>] rest_init+0xb7/0xbe
[   89.913340]  [<ffffffff81bda62c>] ? csum_partial_copy_generic+0x16c/0x16c
[   89.913352]  [<ffffffff82742e39>] start_kernel+0x3b2/0x3bd
[   89.913363]  [<ffffffff827422cc>] x86_64_start_reservations+0x9c/0xa0
[   89.913374]  [<ffffffff827424a8>] x86_64_start_kernel+0x1d8/0x1e3
[   89.913379] ---[ end trace a7919e7f17c0a726 ]---
[   89.913401] Dumping ftrace buffer:
[   89.913417] Switched to NOHz mode on CPU #4
[   89.913428] ---------------------------------
[   89.913444] Switched to NOHz mode on CPU #54
[   89.913467] CPU:0 [LOST 39120 EVENTS]
[   89.913469]   <idle>-0       0d... 89769327us : <stack trace>
[   89.913472]  => rcu_irq_enter
[   89.913474]  => irq_enter
[   89.913475]  => smp_apic_timer_interrupt
[   89.913478]  => apic_timer_interrupt
[   89.913479]  => cpu_idle
[   89.913481]  => rest_init
[   89.913482]  => start_kernel
[   89.913484]  => x86_64_start_reservations
[   89.913490] Switched to NOHz mode on CPU #48
[   89.913496] Switched to NOHz mode on CPU #42
[   89.913509]   <idle>-0       0dN.. 89769365us : <stack trace>
[   89.913512]  => rcu_irq_exit
[   89.913513]  => irq_exit
[   89.913515]  => smp_apic_timer_interrupt
[   89.913517]  => apic_timer_interrupt
[   89.913518]  => cpu_idle
[   89.913520]  => rest_init
[   89.913521]  => start_kernel
[   89.913523]  => x86_64_start_reservations
[   89.913546]   <idle>-0       0d... 89773320us : <stack trace>
[   89.913549]  => rcu_irq_enter
[   89.913550]  => irq_enter
[   89.913552]  => smp_apic_timer_interrupt
[   89.913554]  => apic_timer_interrupt
[   89.913556]  => cpu_idle
[   89.913557]  => rest_init
[   89.913558]  => start_kernel
[   89.913560]  => x86_64_start_reservations
[   89.913583]   <idle>-0       0dN.. 89773360us : <stack trace>
[   89.913588]  => rcu_irq_exit
[   89.913589]  => irq_exit
[   89.913592]  => smp_apic_timer_interrupt
[   89.913594]  => apic_timer_interrupt
[   89.913595]  => cpu_idle
[   89.913597]  => rest_init
[   89.913598]  => start_kernel
[   89.913600]  => x86_64_start_reservations
[   89.913606] Switched to NOHz mode on CPU #33
[   89.913613] Switched to NOHz mode on CPU #61
[   89.913623] Switched to NOHz mode on CPU #102
[   89.913629] Switched to NOHz mode on CPU #50
[   89.913634]   <idle>-0       0d... 89777313us : <stack trace>
[   89.913637]  => rcu_irq_enter
[   89.913638]  => irq_enter
[   89.913640]  => smp_apic_timer_interrupt
[   89.913641]  => apic_timer_interrupt
[   89.913643]  => cpu_idle
[   89.913645]  => rest_init
[   89.913646]  => start_kernel
[   89.913648]  => x86_64_start_reservations
[   89.913662] Switched to NOHz mode on CPU #41
[   89.913668] Switched to NOHz mode on CPU #45
[   89.913674]   <idle>-0       0dN.. 89777352us : <stack trace>
[   89.913677]  => rcu_irq_exit
[   89.913678]  => irq_exit
[   89.913680]  => smp_apic_timer_interrupt
[   89.913682]  => apic_timer_interrupt
[   89.913683]  => cpu_idle
[   89.913685]  => rest_init
[   89.913686]  => start_kernel
[   89.913688]  => x86_64_start_reservations
[   89.913711]   <idle>-0       0d... 89781306us : <stack trace>
[   89.913713]  => rcu_irq_enter
[   89.913715]  => irq_enter
[   89.913717]  => smp_apic_timer_interrupt
[   89.913719]  => apic_timer_interrupt
[   89.913720]  => cpu_idle
[   89.913722]  => rest_init
[   89.913723]  => start_kernel
[   89.913725]  => x86_64_start_reservations
[   89.913747]   <idle>-0       0dN.. 89781340us : <stack trace>
[   89.913751]  => rcu_irq_exit
[   89.913753]  => irq_exit
[   89.913754]  => smp_apic_timer_interrupt
[   89.913756]  => apic_timer_interrupt
[   89.913758]  => cpu_idle
[   89.913759]  => rest_init
[   89.913761]  => start_kernel
[   89.913762]  => x86_64_start_reservations
[   89.913768] Switched to NOHz mode on CPU #35
[   89.913786]   <idle>-0       0d... 89785299us : <stack trace>
[   89.913788]  => rcu_irq_enter
[   89.913790]  => irq_enter
[   89.913791]  => smp_apic_timer_interrupt
[   89.913793]  => apic_timer_interrupt
[   89.913795]  => cpu_idle
[   89.913796]  => rest_init
[   89.913798]  => start_kernel
[   89.913799]  => x86_64_start_reservations
[   89.913822]   <idle>-0       0dN.. 89785334us : <stack trace>
[   89.913825]  => rcu_irq_exit
[   89.913826]  => irq_exit
[   89.913828]  => smp_apic_timer_interrupt
[   89.913830]  => apic_timer_interrupt
[   89.913831]  => cpu_idle
[   89.913833]  => rest_init
[   89.913834]  => start_kernel
[   89.913836]  => x86_64_start_reservations
[   89.913859]   <idle>-0       0d... 89789292us : <stack trace>
[   89.913861]  => rcu_irq_enter
[   89.913863]  => irq_enter
[   89.913865]  => smp_apic_timer_interrupt
[   89.913866]  => apic_timer_interrupt
[   89.913868]  => cpu_idle
[   89.913870]  => rest_init
[   89.913871]  => start_kernel
[   89.913873]  => x86_64_start_reservations
[   89.913895]   <idle>-0       0dN.. 89789326us : <stack trace>
[   89.913898]  => rcu_irq_exit
[   89.913900]  => irq_exit
[   89.913901]  => smp_apic_timer_interrupt
[   89.913903]  => apic_timer_interrupt
[   89.913905]  => cpu_idle
[   89.913906]  => rest_init
[   89.913908]  => start_kernel
[   89.913909]  => x86_64_start_reservations
[   89.913932]   <idle>-0       0d... 89793285us : <stack trace>
[   89.913935]  => rcu_irq_enter
[   89.913936]  => irq_enter
[   89.913938]  => smp_apic_timer_interrupt
[   89.913939]  => apic_timer_interrupt
[   89.913941]  => cpu_idle
[   89.913943]  => rest_init
[   89.913944]  => start_kernel
[   89.913946]  => x86_64_start_reservations
[   89.913968]   <idle>-0       0dN.. 89793320us : <stack trace>
[   89.913971]  => rcu_irq_exit
[   89.913973]  => irq_exit
[   89.913974]  => smp_apic_timer_interrupt
[   89.913976]  => apic_timer_interrupt
[   89.913978]  => cpu_idle
[   89.913979]  => rest_init
[   89.913981]  => start_kernel
[   89.913982]  => x86_64_start_reservations
[   89.914005]   <idle>-0       0d... 89797278us : <stack trace>
[   89.914008]  => rcu_irq_enter
[   89.914009]  => irq_enter
[   89.914011]  => smp_apic_timer_interrupt
[   89.914013]  => apic_timer_interrupt
[   89.914014]  => cpu_idle
[   89.914016]  => rest_init
[   89.914017]  => start_kernel
[   89.914019]  => x86_64_start_reservations
[   89.914042]   <idle>-0       0dN.. 89797319us : <stack trace>
[   89.914044]  => rcu_irq_exit
[   89.914046]  => irq_exit
[   89.914047]  => smp_apic_timer_interrupt
[   89.914049]  => apic_timer_interrupt
[   89.914051]  => cpu_idle
[   89.914052]  => rest_init
[   89.914054]  => start_kernel
[   89.914055]  => x86_64_start_reservations
[   89.914078]   <idle>-0       0d... 89801271us : <stack trace>
[   89.914081]  => rcu_irq_enter
[   89.914082]  => irq_enter
[   89.914084]  => smp_apic_timer_interrupt
[   89.914086]  => apic_timer_interrupt
[   89.914088]  => cpu_idle
[   89.914089]  => rest_init
[   89.914090]  => start_kernel
[   89.914092]  => x86_64_start_reservations
[   89.914115]   <idle>-0       0dN.. 89801311us : <stack trace>
[   89.914118]  => rcu_irq_exit
[   89.914119]  => irq_exit
[   89.914121]  => smp_apic_timer_interrupt
[   89.914123]  => apic_timer_interrupt
[   89.914124]  => cpu_idle
[   89.914126]  => rest_init
[   89.914127]  => start_kernel
[   89.914129]  => x86_64_start_reservations
[   89.914152]   <idle>-0       0d... 89805264us : <stack trace>
[   89.914154]  => rcu_irq_enter
[   89.914156]  => irq_enter
[   89.914158]  => smp_apic_timer_interrupt
[   89.914159]  => apic_timer_interrupt
[   89.914161]  => cpu_idle
[   89.914163]  => rest_init
[   89.914164]  => start_kernel
[   89.914166]  => x86_64_start_reservations
[   89.914188]   <idle>-0       0dN.. 89805297us : <stack trace>
[   89.914191]  => rcu_irq_exit
[   89.914193]  => irq_exit
[   89.914194]  => smp_apic_timer_interrupt
[   89.914196]  => apic_timer_interrupt
[   89.914198]  => cpu_idle
[   89.914199]  => rest_init
[   89.914200]  => start_kernel
[   89.914202]  => x86_64_start_reservations
[   89.914225]   <idle>-0       0d... 89809257us : <stack trace>
[   89.914227]  => rcu_irq_enter
[   89.914229]  => irq_enter
[   89.914231]  => smp_apic_timer_interrupt
[   89.914232]  => apic_timer_interrupt
[   89.914234]  => cpu_idle
[   89.914236]  => rest_init
[   89.914237]  => start_kernel
[   89.914239]  => x86_64_start_reservations
[   89.914261]   <idle>-0       0dN.. 89809292us : <stack trace>
[   89.914264]  => rcu_irq_exit
[   89.914266]  => irq_exit
[   89.914267]  => smp_apic_timer_interrupt
[   89.914269]  => apic_timer_interrupt
[   89.914271]  => cpu_idle
[   89.914272]  => rest_init
[   89.914274]  => start_kernel
[   89.914275]  => x86_64_start_reservations
[   89.914298]   <idle>-0       0d... 89813250us : <stack trace>
[   89.914301]  => rcu_irq_enter
[   89.914302]  => irq_enter
[   89.914304]  => smp_apic_timer_interrupt
[   89.914306]  => apic_timer_interrupt
[   89.914307]  => cpu_idle
[   89.914309]  => rest_init
[   89.914310]  => start_kernel
[   89.914312]  => x86_64_start_reservations
[   89.914329] Switched to NOHz mode on CPU #38
[   89.914335]   <idle>-0       0dN.. 89813283us : <stack trace>
[   89.914338]  => rcu_irq_exit
[   89.914339]  => irq_exit
[   89.914341]  => smp_apic_timer_interrupt
[   89.914343]  => apic_timer_interrupt
[   89.914344]  => cpu_idle
[   89.914346]  => rest_init
[   89.914347]  => start_kernel
[   89.914349]  => x86_64_start_reservations
[   89.914359] Switched to NOHz mode on CPU #154
[   89.914365] Switched to NOHz mode on CPU #159
[   89.914373]   <idle>-0       0d... 89817243us : <stack trace>
[   89.914376]  => rcu_irq_enter
[   89.914378]  => irq_enter
[   89.914381]  => smp_apic_timer_interrupt
[   89.914384]  => apic_timer_interrupt
[   89.914385]  => cpu_idle
[   89.914387]  => rest_init
[   89.914388]  => start_kernel
[   89.914390]  => x86_64_start_reservations
[   89.914400] Switched to NOHz mode on CPU #142
[   89.914407] Switched to NOHz mode on CPU #148
[   89.914415] Switched to NOHz mode on CPU #147
[   89.914423] Switched to NOHz mode on CPU #153
[   89.914430] Switched to NOHz mode on CPU #157
[   89.914438]   <idle>-0       0dN.. 89817279us : <stack trace>
[   89.914441]  => rcu_irq_exit
[   89.914443]  => irq_exit
[   89.914444]  => smp_apic_timer_interrupt
[   89.914446]  => apic_timer_interrupt
[   89.914448]  => cpu_idle
[   89.914449]  => rest_init
[   89.914451]  => start_kernel
[   89.914452]  => x86_64_start_reservations
[   89.914458] Switched to NOHz mode on CPU #146
[   89.914462] Switched to NOHz mode on CPU #144
[   89.914467] Switched to NOHz mode on CPU #136
[   89.914472] Switched to NOHz mode on CPU #133
[   89.914479]   <idle>-0       0d... 89821236us : <stack trace>
[   89.914482]  => rcu_irq_enter
[   89.914484]  => irq_enter
[   89.914485]  => smp_apic_timer_interrupt
[   89.914487]  => apic_timer_interrupt
[   89.914489]  => cpu_idle
[   89.914490]  => rest_init
[   89.914492]  => start_kernel
[   89.914494]  => x86_64_start_reservations
[   89.914500] Switched to NOHz mode on CPU #123
[   89.914505] Switched to NOHz mode on CPU #128
[   89.914510] Switched to NOHz mode on CPU #119
[   89.914515] Switched to NOHz mode on CPU #117
[   89.914524] Switched to NOHz mode on CPU #116
[   89.914533] Switched to NOHz mode on CPU #115
[   89.914541] Switched to NOHz mode on CPU #131
[   89.914547] Switched to NOHz mode on CPU #150
[   89.914554]   <idle>-0       0dN.. 89821271us : <stack trace>
[   89.914557]  => rcu_irq_exit
[   89.914559]  => irq_exit
[   89.914560]  => smp_apic_timer_interrupt
[   89.914562]  => apic_timer_interrupt
[   89.914564]  => cpu_idle
[   89.914566]  => rest_init
[   89.914567]  => start_kernel
[   89.914569]  => x86_64_start_reservations
[   89.914576] Switched to NOHz mode on CPU #109
[   89.914585] Switched to NOHz mode on CPU #106
[   89.914593] Switched to NOHz mode on CPU #100
[   89.914601] Switched to NOHz mode on CPU #101
[   89.914611] Switched to NOHz mode on CPU #111
[   89.914619] Switched to NOHz mode on CPU #124
[   89.914628] Switched to NOHz mode on CPU #83
[   89.914636]   <idle>-0       0d... 89825229us : <stack trace>
[   89.914642]  => rcu_irq_enter
[   89.914646]  => irq_enter
[   89.914648]  => smp_apic_timer_interrupt
[   89.914651]  => apic_timer_interrupt
[   89.914653]  => cpu_idle
[   89.914655]  => rest_init
[   89.914659]  => start_kernel
[   89.914660]  => x86_64_start_reservations
[   89.914673] Switched to NOHz mode on CPU #7
[   89.914682] Switched to NOHz mode on CPU #87
[   89.914697] Switched to NOHz mode on CPU #9
[   89.914711] Switched to NOHz mode on CPU #6
[   89.914736]   <idle>-0       0dN.. 89825262us : <stack trace>
[   89.914740]  => rcu_irq_exit
[   89.914743]  => irq_exit
[   89.914745]  => smp_apic_timer_interrupt
[   89.914748]  => apic_timer_interrupt
[   89.914759]  => cpu_idle
[   89.914761]  => rest_init
[   89.914763]  => start_kernel
[   89.914766]  => x86_64_start_reservations
[   89.914773] Switched to NOHz mode on CPU #80
[   89.914794] Switched to NOHz mode on CPU #2
[   89.914804] Switched to NOHz mode on CPU #82
[   89.914824] Switched to NOHz mode on CPU #85
[   89.914847] Switched to NOHz mode on CPU #88
[   89.914881]   <idle>-0       0d... 89829222us : <stack trace>
[   89.914891]  => rcu_irq_enter
[   89.914893]  => irq_enter
[   89.914894]  => smp_apic_timer_interrupt
[   89.914896]  => apic_timer_interrupt
[   89.914898]  => cpu_idle
[   89.914899]  => rest_init
[   89.914901]  => start_kernel
[   89.914902]  => x86_64_start_reservations
[   89.914926] Switched to NOHz mode on CPU #97
[   89.914954] Switched to NOHz mode on CPU #95
[   89.915011] Switched to NOHz mode on CPU #99
[   89.915049] Switched to NOHz mode on CPU #10
[   89.915080] Switched to NOHz mode on CPU #90
[   89.915142] Switched to NOHz mode on CPU #13
[   89.915166] Switched to NOHz mode on CPU #93
[   89.915209] Switched to NOHz mode on CPU #15
[   89.915274] Switched to NOHz mode on CPU #98
[   89.915294] Switched to NOHz mode on CPU #18
[   89.915333] Switched to NOHz mode on CPU #92
[   89.915381] Switched to NOHz mode on CPU #12
[   89.915450] Switched to NOHz mode on CPU #14
[   89.915512] Switched to NOHz mode on CPU #94
[   89.915551] Switched to NOHz mode on CPU #91
[   89.915600] Switched to NOHz mode on CPU #96
[   89.915639] Switched to NOHz mode on CPU #21
[   89.915677] Switched to NOHz mode on CPU #22
[   89.915722] Switched to NOHz mode on CPU #29
[   89.915761] Switched to NOHz mode on CPU #107
[   89.915789] Switched to NOHz mode on CPU #26
[   89.915857] Switched to NOHz mode on CPU #105
[   89.915876] Switched to NOHz mode on CPU #25
[   89.915902] Switched to NOHz mode on CPU #108
[   89.915911] Switched to NOHz mode on CPU #28
[   89.915942] Switched to NOHz mode on CPU #23
[   89.915964] Switched to NOHz mode on CPU #103
[   89.915994] Switched to NOHz mode on CPU #20
[   89.916024] Switched to NOHz mode on CPU #27
[   89.916043] Switched to NOHz mode on CPU #24
[   89.916059] Switched to NOHz mode on CPU #104
[   89.916104] Switched to NOHz mode on CPU #31
[   89.916140] Switched to NOHz mode on CPU #32
[   89.916153] Switched to NOHz mode on CPU #112
[   89.916179] Switched to NOHz mode on CPU #114
[   89.916216] Switched to NOHz mode on CPU #30
[   89.916233] Switched to NOHz mode on CPU #110
[   89.916253] Switched to NOHz mode on CPU #113
[   89.916276] Switched to NOHz mode on CPU #118
[   89.916305] Switched to NOHz mode on CPU #129
[   89.916323] Switched to NOHz mode on CPU #121
[   89.916340] Switched to NOHz mode on CPU #125
[   89.916367] Switched to NOHz mode on CPU #122
[   89.916387] Switched to NOHz mode on CPU #127
[   89.916415] Switched to NOHz mode on CPU #120
[   89.916437] Switched to NOHz mode on CPU #126
[   89.916454] Switched to NOHz mode on CPU #139
[   89.916479] Switched to NOHz mode on CPU #135
[   89.916492] Switched to NOHz mode on CPU #137
[   89.916513] Switched to NOHz mode on CPU #134
[   89.916530] Switched to NOHz mode on CPU #138
[   89.916539] Switched to NOHz mode on CPU #132
[   89.916560] Switched to NOHz mode on CPU #130
[   89.916575] Switched to NOHz mode on CPU #68
[   89.916581] Switched to NOHz mode on CPU #64
[   89.916597] Switched to NOHz mode on CPU #65
[   89.916608] Switched to NOHz mode on CPU #145
[   89.916620] Switched to NOHz mode on CPU #141
[   89.916633] Switched to NOHz mode on CPU #63
[   89.916642] Switched to NOHz mode on CPU #67
[   89.916650] Switched to NOHz mode on CPU #152
[   89.916659] Switched to NOHz mode on CPU #72
[   89.916673] Switched to NOHz mode on CPU #77
[   89.916688] Switched to NOHz mode on CPU #158
[   89.916699] Switched to NOHz mode on CPU #78
[   89.916713] Switched to NOHz mode on CPU #70
[   89.916725] Switched to NOHz mode on CPU #76
[   89.916736] Switched to NOHz mode on CPU #156
[   89.916748] Switched to NOHz mode on CPU #151
[   89.916756] Switched to NOHz mode on CPU #71
[   89.916768] Switched to NOHz mode on CPU #75
[   89.916775] Switched to NOHz mode on CPU #155
[   89.916786] Switched to NOHz mode on CPU #73
[   89.916795] Switched to NOHz mode on CPU #74
[   89.916806]   <idle>-0       0dN.. 89829255us : <stack trace>
[   89.916812]  => rcu_irq_exit
[   89.916814]  => irq_exit
[   89.916816]  => smp_apic_timer_interrupt
[   89.916818]  => apic_timer_interrupt
[   89.916819]  => cpu_idle
[   89.916821]  => rest_init
[   89.916823]  => start_kernel
[   89.916824]  => x86_64_start_reservations
[   89.916832] Switched to NOHz mode on CPU #89
[   89.916841] Switched to NOHz mode on CPU #84
[   89.916853] Switched to NOHz mode on CPU #81
[   89.916863] Switched to NOHz mode on CPU #1
[   89.916872] Switched to NOHz mode on CPU #5
[   89.916882] Switched to NOHz mode on CPU #8
[   89.916889] Switched to NOHz mode on CPU #3
[   89.916898] Switched to NOHz mode on CPU #86
[   89.916904]   <idle>-0       0d... 89833215us : <stack trace>
[   89.916907]  => rcu_irq_enter
[   89.916909]  => irq_enter
[   89.916911]  => smp_apic_timer_interrupt
[   89.916913]  => apic_timer_interrupt
[   89.916915]  => cpu_idle
[   89.916916]  => rest_init
[   89.916918]  => start_kernel
[   89.916919]  => x86_64_start_reservations
[   89.916926] Switched to NOHz mode on CPU #16
[   89.916932] Switched to NOHz mode on CPU #17
[   89.916939] Switched to NOHz mode on CPU #11
[   89.916946] Switched to NOHz mode on CPU #19
[   89.916952] Switched to NOHz mode on CPU #66
[   89.916956] Switched to NOHz mode on CPU #69
[   89.916960] Switched to NOHz mode on CPU #149
[   89.916964] Switched to NOHz mode on CPU #140
[   89.916969]   <idle>-0       0dN.. 89833252us : <stack trace>
[   89.916971]  => rcu_irq_exit
[   89.916973]  => irq_exit
[   89.916974]  => smp_apic_timer_interrupt
[   89.916976]  => apic_timer_interrupt
[   89.916978]  => cpu_idle
[   89.916980]  => rest_init
[   89.916981]  => start_kernel
[   89.916983]  => x86_64_start_reservations
[   89.917006]   <idle>-0       0d... 89837208us : <stack trace>
[   89.917009]  => rcu_irq_enter
[   89.917010]  => irq_enter
[   89.917012]  => smp_apic_timer_interrupt
[   89.917014]  => apic_timer_interrupt
[   89.917015]  => cpu_idle
[   89.917017]  => rest_init
[   89.917018]  => start_kernel
[   89.917020]  => x86_64_start_reservations
[   89.917043]   <idle>-0       0dN.. 89837248us : <stack trace>
[   89.917046]  => rcu_irq_exit
[   89.917047]  => irq_exit
[   89.917049]  => smp_apic_timer_interrupt
[   89.917051]  => apic_timer_interrupt
[   89.917053]  => cpu_idle
[   89.917054]  => rest_init
[   89.917055]  => start_kernel
[   89.917057]  => x86_64_start_reservations
[   89.917080]   <idle>-0       0d... 89841201us : <stack trace>
[   89.917083]  => rcu_irq_enter
[   89.917084]  => irq_enter
[   89.917086]  => smp_apic_timer_interrupt
[   89.917088]  => apic_timer_interrupt
[   89.917089]  => cpu_idle
[   89.917091]  => rest_init
[   89.917092]  => start_kernel
[   89.917094]  => x86_64_start_reservations
[   89.917117]   <idle>-0       0dN.. 89841242us : <stack trace>
[   89.917119]  => rcu_irq_exit
[   89.917121]  => irq_exit
[   89.917123]  => smp_apic_timer_interrupt
[   89.917125]  => apic_timer_interrupt
[   89.917126]  => cpu_idle
[   89.917128]  => rest_init
[   89.917129]  => start_kernel
[   89.917131]  => x86_64_start_reservations
[   89.917154]   <idle>-0       0d... 89845194us : <stack trace>
[   89.917156]  => rcu_irq_enter
[   89.917158]  => irq_enter
[   89.917160]  => smp_apic_timer_interrupt
[   89.917161]  => apic_timer_interrupt
[   89.917163]  => cpu_idle
[   89.917165]  => rest_init
[   89.917166]  => start_kernel
[   89.917168]  => x86_64_start_reservations
[   89.917190]   <idle>-0       0dN.. 89845234us : <stack trace>
[   89.917193]  => rcu_irq_exit
[   89.917195]  => irq_exit
[   89.917196]  => smp_apic_timer_interrupt
[   89.917198]  => apic_timer_interrupt
[   89.917200]  => cpu_idle
[   89.917201]  => rest_init
[   89.917203]  => start_kernel
[   89.917204]  => x86_64_start_reservations
[   89.917227]   <idle>-0       0d... 89849187us : <stack trace>
[   89.917230]  => rcu_irq_enter
[   89.917231]  => irq_enter
[   89.917233]  => smp_apic_timer_interrupt
[   89.917235]  => apic_timer_interrupt
[   89.917237]  => cpu_idle
[   89.917238]  => rest_init
[   89.917240]  => start_kernel
[   89.917241]  => x86_64_start_reservations
[   89.917264]   <idle>-0       0dN.. 89849228us : <stack trace>
[   89.917267]  => rcu_irq_exit
[   89.917269]  => irq_exit
[   89.917270]  => smp_apic_timer_interrupt
[   89.917272]  => apic_timer_interrupt
[   89.917274]  => cpu_idle
[   89.917275]  => rest_init
[   89.917276]  => start_kernel
[   89.917278]  => x86_64_start_reservations
[   89.917301]   <idle>-0       0d... 89853180us : <stack trace>
[   89.917304]  => rcu_irq_enter
[   89.917305]  => irq_enter
[   89.917307]  => smp_apic_timer_interrupt
[   89.917309]  => apic_timer_interrupt
[   89.917310]  => cpu_idle
[   89.917312]  => rest_init
[   89.917313]  => start_kernel
[   89.917315]  => x86_64_start_reservations
[   89.917338]   <idle>-0       0dN.. 89853222us : <stack trace>
[   89.917340]  => rcu_irq_exit
[   89.917342]  => irq_exit
[   89.917343]  => smp_apic_timer_interrupt
[   89.917345]  => apic_timer_interrupt
[   89.917347]  => cpu_idle
[   89.917349]  => rest_init
[   89.917350]  => start_kernel
[   89.917352]  => x86_64_start_reservations
[   89.917375]   <idle>-0       0d... 89857173us : <stack trace>
[   89.917378]  => rcu_irq_enter
[   89.917379]  => irq_enter
[   89.917381]  => smp_apic_timer_interrupt
[   89.917383]  => apic_timer_interrupt
[   89.917384]  => cpu_idle
[   89.917386]  => rest_init
[   89.917387]  => start_kernel
[   89.917389]  => x86_64_start_reservations
[   89.917412]   <idle>-0       0dN.. 89857211us : <stack trace>
[   89.917414]  => rcu_irq_exit
[   89.917416]  => irq_exit
[   89.917418]  => smp_apic_timer_interrupt
[   89.917419]  => apic_timer_interrupt
[   89.917421]  => cpu_idle
[   89.917423]  => rest_init
[   89.917424]  => start_kernel
[   89.917426]  => x86_64_start_reservations
[   89.917449]   <idle>-0       0d... 89861166us : <stack trace>
[   89.917451]  => rcu_irq_enter
[   89.917453]  => irq_enter
[   89.917454]  => smp_apic_timer_interrupt
[   89.917456]  => apic_timer_interrupt
[   89.917458]  => cpu_idle
[   89.917459]  => rest_init
[   89.917461]  => start_kernel
[   89.917462]  => x86_64_start_reservations
[   89.917485]   <idle>-0       0dN.. 89861199us : <stack trace>
[   89.917488]  => rcu_irq_exit
[   89.917490]  => irq_exit
[   89.917491]  => smp_apic_timer_interrupt
[   89.917493]  => apic_timer_interrupt
[   89.917495]  => cpu_idle
[   89.917496]  => rest_init
[   89.917498]  => start_kernel
[   89.917499]  => x86_64_start_reservations
[   89.917524]   <idle>-0       0d... 89865159us : <stack trace>
[   89.917526]  => rcu_irq_enter
[   89.917528]  => irq_enter
[   89.917530]  => smp_apic_timer_interrupt
[   89.917531]  => apic_timer_interrupt
[   89.917533]  => cpu_idle
[   89.917535]  => rest_init
[   89.917536]  => start_kernel
[   89.917538]  => x86_64_start_reservations
[   89.917560]   <idle>-0       0dN.. 89865193us : <stack trace>
[   89.917563]  => rcu_irq_exit
[   89.917565]  => irq_exit
[   89.917566]  => smp_apic_timer_interrupt
[   89.917568]  => apic_timer_interrupt
[   89.917570]  => cpu_idle
[   89.917571]  => rest_init
[   89.917573]  => start_kernel
[   89.917574]  => x86_64_start_reservations
[   89.917597]   <idle>-0       0d... 89869152us : <stack trace>
[   89.917600]  => rcu_irq_enter
[   89.917602]  => irq_enter
[   89.917603]  => smp_apic_timer_interrupt
[   89.917605]  => apic_timer_interrupt
[   89.917607]  => cpu_idle
[   89.917608]  => rest_init
[   89.917610]  => start_kernel
[   89.917611]  => x86_64_start_reservations
[   89.917634]   <idle>-0       0dN.. 89869185us : <stack trace>
[   89.917636]  => rcu_irq_exit
[   89.917638]  => irq_exit
[   89.917640]  => smp_apic_timer_interrupt
[   89.917641]  => apic_timer_interrupt
[   89.917643]  => cpu_idle
[   89.917645]  => rest_init
[   89.917646]  => start_kernel
[   89.917648]  => x86_64_start_reservations
[   89.917671]   <idle>-0       0d... 89873145us : <stack trace>
[   89.917673]  => rcu_irq_enter
[   89.917675]  => irq_enter
[   89.917677]  => smp_apic_timer_interrupt
[   89.917678]  => apic_timer_interrupt
[   89.917680]  => cpu_idle
[   89.917682]  => rest_init
[   89.917683]  => start_kernel
[   89.917685]  => x86_64_start_reservations
[   89.917708]   <idle>-0       0dN.. 89873178us : <stack trace>
[   89.917710]  => rcu_irq_exit
[   89.917712]  => irq_exit
[   89.917713]  => smp_apic_timer_interrupt
[   89.917715]  => apic_timer_interrupt
[   89.917717]  => cpu_idle
[   89.917718]  => rest_init
[   89.917720]  => start_kernel
[   89.917721]  => x86_64_start_reservations
[   89.917744]   <idle>-0       0d... 89877138us : <stack trace>
[   89.917747]  => rcu_irq_enter
[   89.917749]  => irq_enter
[   89.917750]  => smp_apic_timer_interrupt
[   89.917752]  => apic_timer_interrupt
[   89.917754]  => cpu_idle
[   89.917755]  => rest_init
[   89.917757]  => start_kernel
[   89.917758]  => x86_64_start_reservations
[   89.917781]   <idle>-0       0dN.. 89877174us : <stack trace>
[   89.917784]  => rcu_irq_exit
[   89.917786]  => irq_exit
[   89.917787]  => smp_apic_timer_interrupt
[   89.917789]  => apic_timer_interrupt
[   89.917791]  => cpu_idle
[   89.917792]  => rest_init
[   89.917794]  => start_kernel
[   89.917795]  => x86_64_start_reservations
[   89.917818]   <idle>-0       0d... 89881131us : <stack trace>
[   89.917821]  => rcu_irq_enter
[   89.917823]  => irq_enter
[   89.917824]  => smp_apic_timer_interrupt
[   89.917826]  => apic_timer_interrupt
[   89.917828]  => cpu_idle
[   89.917829]  => rest_init
[   89.917831]  => start_kernel
[   89.917832]  => x86_64_start_reservations
[   89.917855]   <idle>-0       0dN.. 89881165us : <stack trace>
[   89.917858]  => rcu_irq_exit
[   89.917859]  => irq_exit
[   89.917861]  => smp_apic_timer_interrupt
[   89.917863]  => apic_timer_interrupt
[   89.917865]  => cpu_idle
[   89.917866]  => rest_init
[   89.917867]  => start_kernel
[   89.917869]  => x86_64_start_reservations
[   89.917892]   <idle>-0       0d... 89885124us : <stack trace>
[   89.917894]  => rcu_irq_enter
[   89.917896]  => irq_enter
[   89.917898]  => smp_apic_timer_interrupt
[   89.917899]  => apic_timer_interrupt
[   89.917901]  => cpu_idle
[   89.917903]  => rest_init
[   89.917904]  => start_kernel
[   89.917906]  => x86_64_start_reservations
[   89.917929]   <idle>-0       0dN.. 89885161us : <stack trace>
[   89.917931]  => rcu_irq_exit
[   89.917933]  => irq_exit
[   89.917934]  => smp_apic_timer_interrupt
[   89.917936]  => apic_timer_interrupt
[   89.917938]  => cpu_idle
[   89.917940]  => rest_init
[   89.917941]  => start_kernel
[   89.917943]  => x86_64_start_reservations
[   89.917965]   <idle>-0       0d... 89889117us : <stack trace>
[   89.917968]  => rcu_irq_enter
[   89.917970]  => irq_enter
[   89.917971]  => smp_apic_timer_interrupt
[   89.917973]  => apic_timer_interrupt
[   89.917975]  => cpu_idle
[   89.917976]  => rest_init
[   89.917978]  => start_kernel
[   89.917979]  => x86_64_start_reservations
[   89.918002]   <idle>-0       0dN.. 89889150us : <stack trace>
[   89.918005]  => rcu_irq_exit
[   89.918006]  => irq_exit
[   89.918008]  => smp_apic_timer_interrupt
[   89.918010]  => apic_timer_interrupt
[   89.918011]  => cpu_idle
[   89.918013]  => rest_init
[   89.918014]  => start_kernel
[   89.918016]  => x86_64_start_reservations
[   89.918039]   <idle>-0       0d... 89893110us : <stack trace>
[   89.918041]  => rcu_irq_enter
[   89.918043]  => irq_enter
[   89.918045]  => smp_apic_timer_interrupt
[   89.918046]  => apic_timer_interrupt
[   89.918048]  => cpu_idle
[   89.918050]  => rest_init
[   89.918051]  => start_kernel
[   89.918053]  => x86_64_start_reservations
[   89.918075]   <idle>-0       0dN.. 89893147us : <stack trace>
[   89.918078]  => rcu_irq_exit
[   89.918080]  => irq_exit
[   89.918081]  => smp_apic_timer_interrupt
[   89.918083]  => apic_timer_interrupt
[   89.918085]  => cpu_idle
[   89.918086]  => rest_init
[   89.918088]  => start_kernel
[   89.918089]  => x86_64_start_reservations
[   89.918112]   <idle>-0       0d... 89897103us : <stack trace>
[   89.918115]  => rcu_irq_enter
[   89.918116]  => irq_enter
[   89.918118]  => smp_apic_timer_interrupt
[   89.918120]  => apic_timer_interrupt
[   89.918121]  => cpu_idle
[   89.918123]  => rest_init
[   89.918124]  => start_kernel
[   89.918126]  => x86_64_start_reservations
[   89.918149]   <idle>-0       0dN.. 89897136us : <stack trace>
[   89.918151]  => rcu_irq_exit
[   89.918153]  => irq_exit
[   89.918155]  => smp_apic_timer_interrupt
[   89.918157]  => apic_timer_interrupt
[   89.918158]  => cpu_idle
[   89.918160]  => rest_init
[   89.918161]  => start_kernel
[   89.918163]  => x86_64_start_reservations
[   89.918186]   <idle>-0       0d... 89901096us : <stack trace>
[   89.918188]  => rcu_irq_enter
[   89.918190]  => irq_enter
[   89.918192]  => smp_apic_timer_interrupt
[   89.918193]  => apic_timer_interrupt
[   89.918195]  => cpu_idle
[   89.918197]  => rest_init
[   89.918198]  => start_kernel
[   89.918200]  => x86_64_start_reservations
[   89.918223]   <idle>-0       0dN.. 89901133us : <stack trace>
[   89.918225]  => rcu_irq_exit
[   89.918227]  => irq_exit
[   89.918228]  => smp_apic_timer_interrupt
[   89.918230]  => apic_timer_interrupt
[   89.918232]  => cpu_idle
[   89.918234]  => rest_init
[   89.918235]  => start_kernel
[   89.918237]  => x86_64_start_reservations
[   89.918260]   <idle>-0       0d... 89905089us : <stack trace>
[   89.918262]  => rcu_irq_enter
[   89.918264]  => irq_enter
[   89.918265]  => smp_apic_timer_interrupt
[   89.918267]  => apic_timer_interrupt
[   89.918269]  => cpu_idle
[   89.918270]  => rest_init
[   89.918272]  => start_kernel
[   89.918273]  => x86_64_start_reservations
[   89.918296]   <idle>-0       0dN.. 89905128us : <stack trace>
[   89.918299]  => rcu_irq_exit
[   89.918300]  => irq_exit
[   89.918302]  => smp_apic_timer_interrupt
[   89.918304]  => apic_timer_interrupt
[   89.918305]  => cpu_idle
[   89.918307]  => rest_init
[   89.918308]  => start_kernel
[   89.918310]  => x86_64_start_reservations
[   89.918333]   <idle>-0       0d... 89909082us : <stack trace>
[   89.918336]  => rcu_irq_enter
[   89.918337]  => irq_enter
[   89.918339]  => smp_apic_timer_interrupt
[   89.918341]  => apic_timer_interrupt
[   89.918342]  => cpu_idle
[   89.918344]  => rest_init
[   89.918345]  => start_kernel
[   89.918347]  => x86_64_start_reservations
[   89.918370]   <idle>-0       0dN.. 89909122us : <stack trace>
[   89.918372]  => rcu_irq_exit
[   89.918374]  => irq_exit
[   89.918376]  => smp_apic_timer_interrupt
[   89.918377]  => apic_timer_interrupt
[   89.918379]  => cpu_idle
[   89.918381]  => rest_init
[   89.918382]  => start_kernel
[   89.918384]  => x86_64_start_reservations
[   89.918408]   <idle>-0       0d... 89912671us : <stack trace>
[   89.918410]  => rcu_irq_enter
[   89.918412]  => irq_enter
[   89.918413]  => do_IRQ
[   89.918415]  => ret_from_intr
[   89.918416]  => cpu_idle
[   89.918418]  => rest_init
[   89.918419]  => start_kernel
[   89.918421]  => x86_64_start_reservations
[   89.918443]   <idle>-0       0d... 89912711us : <stack trace>
[   89.918446]  => rcu_irq_exit
[   89.918448]  => irq_exit
[   89.918449]  => do_IRQ
[   89.918451]  => ret_from_intr
[   89.918452]  => cpu_idle
[   89.918454]  => rest_init
[   89.918455]  => start_kernel
[   89.918457]  => x86_64_start_reservations
[   89.918480]   <idle>-0       0d... 89913074us : <stack trace>
[   89.918482]  => rcu_irq_enter
[   89.918484]  => irq_enter
[   89.918486]  => smp_apic_timer_interrupt
[   89.918488]  => apic_timer_interrupt
[   89.918489]  => cpu_idle
[   89.918491]  => rest_init
[   89.918492]  => start_kernel
[   89.918494]  => x86_64_start_reservations
[   89.918517]   <idle>-0       0dN.. 89913130us : <stack trace>
[   89.918519]  => rcu_irq_exit
[   89.918521]  => irq_exit
[   89.918522]  => smp_apic_timer_interrupt
[   89.918524]  => apic_timer_interrupt
[   89.918526]  => cpu_idle
[   89.918527]  => rest_init
[   89.918529]  => start_kernel
[   89.918530]  => x86_64_start_reservations
[   89.918552]   <idle>-0       0d... 89913196us : <stack trace>
[   89.918555]  => rcu_enter_nohz
[   89.918556]  => tick_nohz_stop_sched_tick
[   89.918558]  => cpu_idle
[   89.918560]  => rest_init
[   89.918561]  => start_kernel
[   89.918563]  => x86_64_start_reservations
[   89.918565]  => x86_64_start_kernel
[   89.918569] ---------------------------------


also have

[    1.200814] ftrace: allocating 51307 entries in 202 pages
[    1.226119] ------------[ cut here ]------------
[    1.227489] WARNING: at kernel/trace/ftrace.c:984 ftrace_bug+0x79/0x189()
[    1.237463] Hardware name: Sun Fire X4800 M2 
[    1.238845] Modules linked in:
[    1.240113] Pid: 0, comm: swapper Not tainted 2.6.39-rc7-tip-yh-05281-g8e9254b-dirty #1019
[    1.260717] Call Trace:
[    1.261389]  [<ffffffff81080144>] warn_slowpath_common+0x85/0x9d
[    1.278249]  [<ffffffff814d5d97>] ? sci_base_state_machine_get_state+0x5/0xe
[    1.280207]  [<ffffffff814d5d97>] ? sci_base_state_machine_get_state+0x5/0xe
[    1.300928]  [<ffffffff81080176>] warn_slowpath_null+0x1a/0x1c
[    1.317318]  [<ffffffff810d9457>] ftrace_bug+0x79/0x189
[    1.318672]  [<ffffffff814d5d97>] ? sci_base_state_machine_get_state+0x5/0xe
[    1.339872]  [<ffffffff810d9699>] ftrace_update_code+0x75/0x118
[    1.341795]  [<ffffffff81bda3aa>] ? csum_partial_copy_from_user+0x11/0xe7
[    1.357948]  [<ffffffff810d9873>] ftrace_process_locs+0x69/0x80
[    1.359587]  [<ffffffff8275fd74>] ftrace_init+0x191/0x1b5
[    1.380143]  [<ffffffff82742e34>] start_kernel+0x3ad/0x3bd
[    1.381479]  [<ffffffff827422cc>] x86_64_start_reservations+0x9c/0xa0
[    1.397886]  [<ffffffff827424a8>] x86_64_start_kernel+0x1d8/0x1e3
[    1.399577] ---[ end trace a7919e7f17c0a725 ]---
[    1.420373] ftrace failed to modify [<ffffffff814d5d97>] sci_base_state_machine_get_state+0x5/0xe
[    1.437443]  actual: a5:f3:75:00:8b
