Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755145Ab1ERVKx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 17:10:53 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:46294 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755062Ab1ERVKr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 17:10:47 -0400
Message-ID: <4DD435C2.6040305@kernel.org>
Date: Wed, 18 May 2011 14:10:26 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110414 SUSE/3.1.10 Thunderbird/3.1.10
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL rcu/next] rcu commits for 2.6.40
References: <20110513130414.GA6863@elte.hu> <20110513131218.GA7669@elte.hu> <20110513141431.GV2258@linux.vnet.ibm.com> <20110513150744.GE32688@elte.hu> <20110513162646.GW2258@linux.vnet.ibm.com> <20110516070808.GC24836@elte.hu> <20110516074822.GE2573@linux.vnet.ibm.com> <20110516115148.GA2421@elte.hu> <20110516122329.GA29356@elte.hu> <20110516212449.GJ2573@linux.vnet.ibm.com> <20110517024000.GA5026@nowhere>
In-Reply-To: <20110517024000.GA5026@nowhere>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090201.4DD435C9.003F,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/16/2011 07:40 PM, Frederic Weisbecker wrote:
> On Mon, May 16, 2011 at 02:24:49PM -0700, Paul E. McKenney wrote:
>> On Mon, May 16, 2011 at 02:23:29PM +0200, Ingo Molnar wrote:
>>>
>>> * Ingo Molnar <mingo@elte.hu> wrote:
>>>
>>>>> In the meantime, would you be willing to try out the patch at 
>>>>> https://lkml.org/lkml/2011/5/14/89?  This patch helped out Yinghai in 
>>>>> several configurations.
>>>>
>>>> Wasn't this the one i tested - or is it a new iteration?
>>>>
>>>> I'll try it in any case.
>>>
>>> oh, this was a new iteration, mea culpa!
>>>
>>> And yes, it solves all problems for me as well. Mind pushing it as a fix? :-)
>>
>> ;-)
>>
>> Unfortunately, the only reason I can see that it works is (1) there
>> is some obscure bug in my code or (2) someone somewhere is failing to
>> call irq_exit() on some interrupt-exit path.  Much as I might be tempted
>> to paper this one over, I believe that we do need to find whatever the
>> underlying bug is.
>>
>> Oh, yes, there is option (3) as well: maybe if an interrupt deschedules
>> a process, the final irq_exit() is omitted in favor of rcu_enter_nohz()?
>> But I couldn't see any evidence of this in my admittedly cursory scan
>> of the x86 interrupt-handling code.
>>
>> So until I learn differently, I am assuming that each and every
>> irq_enter() has a matching call to irq_exit(), and that rcu_enter_nohz()
>> is called after the final irq_exit() of a given burst of interrupts.
>>
>> If my assumptions are mistaken, please do let me know!
> 
> So it would be nice to have a trace of the calls to rcu_irq_*() / rcu_*_nohz()
> before the unpairing happened.
> 
> I have tried to reproduce it but couldn't trigger anything.
> 
> So it would be nice if Yinghai can test the patch below, since he was able
> to trigger the warning.
> 
> This is essentially Paul's patch but with stacktrace of the calls recorded.
> Then the whole trace is dumped on the console when one of the WARN_ON_ONCE
> sanity check is positive. Beware as the trace will be dumped everytime
> WARN_ON_ONCE() is positive. So the first dump is enough, you can ignore the
> rest.
> 
> This requires CONFIG_TRACING. May be a good thing to boot with
> "ftrace=nop" parameter, so that ftrace will set up a long enough buffer
> to have an interesting trace.

with this patches if the kernel is compiled from opensuse 11.3 no delay anymore, but have one warning:

[   82.895182] ------------[ cut here ]------------
[   82.895189] WARNING: at kernel/rcutree.c:352 rcu_enter_nohz+0x49/0x8b()
[   82.895193] Switched to NOHz mode on CPU #90
[   82.895199] Switched to NOHz mode on CPU #8
[   82.895202] Modules linked in:
[   82.895206] Switched to NOHz mode on CPU #28
[   82.895211] Pid: 0, comm: swapper Not tainted 2.6.39-rc7-tip-yh-05234-g3a108a0-dirty #1016
[   82.895213] Call Trace:
[   82.895233]  [<ffffffff81080144>] warn_slowpath_common+0x85/0x9d
[   82.895238]  [<ffffffff81080176>] warn_slowpath_null+0x1a/0x1c
[   82.895242]  [<ffffffff810d32cc>] rcu_enter_nohz+0x49/0x8b
[   82.895250]  [<ffffffff810ab121>] tick_nohz_stop_sched_tick+0x27d/0x366
[   82.895255]  [<ffffffff810391bc>] cpu_idle+0x7a/0xcc
[   82.895261]  [<ffffffff81bda6e3>] rest_init+0xb7/0xbe
[   82.895266]  [<ffffffff81bda62c>] ? csum_partial_copy_generic+0x16c/0x16c
[   82.895272]  [<ffffffff82742e39>] start_kernel+0x3b2/0x3bd
[   82.895276]  [<ffffffff827422cc>] x86_64_start_reservations+0x9c/0xa0
[   82.895281]  [<ffffffff827424a8>] x86_64_start_kernel+0x1d8/0x1e3
[   82.895290] ---[ end trace 2cfc591bf7de931f ]---
[   82.895310] Switched to NOHz mode on CPU #72
[   82.895315] Dumping ftrace buffer:
[   82.895328] ---------------------------------
[   82.895340] CPU:0 [LOST 35328 EVENTS]
[   82.895341]   <idle>-0       0d... 82735399us : Unknown type 4
[   82.895347]   <idle>-0       0dN.. 82735431us : Unknown type 4
[   82.895353]   <idle>-0       0d... 82739390us : Unknown type 4
[   82.895358]   <idle>-0       0dN.. 82739415us : Unknown type 4
[   82.895364]   <idle>-0       0d... 82743384us : Unknown type 4
[   82.895369]   <idle>-0       0dN.. 82743408us : Unknown type 4
[   82.895375]   <idle>-0       0d... 82747376us : Unknown type 4
[   82.895379] Switched to NOHz mode on CPU #53
[   82.895385]   <idle>-0       0dN.. 82747403us : Unknown type 4
[   82.895390]   <idle>-0       0d... 82751370us : Unknown type 4
[   82.895395]   <idle>-0       0dN.. 82751391us : Unknown type 4
[   82.895400] Switched to NOHz mode on CPU #60
[   82.895405]   <idle>-0       0d... 82755364us : Unknown type 4
[   82.895411]   <idle>-0       0dN.. 82755386us : Unknown type 4
[   82.895416]   <idle>-0       0d... 82759355us : Unknown type 4
[   82.895421]   <idle>-0       0dN.. 82759378us : Unknown type 4
[   82.895428] Switched to NOHz mode on CPU #102
[   82.895431]   <idle>-0       0d... 82763350us : Unknown type 4
[   82.895436]   <idle>-0       0dN.. 82763372us : Unknown type 4
[   82.895441]   <idle>-0       0d... 82767341us : Unknown type 4
[   82.895448] Switched to NOHz mode on CPU #155
[   82.895453]   <idle>-0       0dN.. 82767364us : Unknown type 4
[   82.895459]   <idle>-0       0d... 82771334us : Unknown type 4
[   82.895464]   <idle>-0       0dN.. 82771357us : Unknown type 4
[   82.895469]   <idle>-0       0d... 82775328us : Unknown type 4
[   82.895474]   <idle>-0       0dN.. 82775355us : Unknown type 4
[   82.895480]   <idle>-0       0d... 82779321us : Unknown type 4
[   82.895485]   <idle>-0       0dN.. 82779345us : Unknown type 4
[   82.895490]   <idle>-0       0d... 82783313us : Unknown type 4
[   82.895495]   <idle>-0       0dN.. 82783340us : Unknown type 4
[   82.895501]   <idle>-0       0d... 82787308us : Unknown type 4
[   82.895506]   <idle>-0       0dN.. 82787331us : Unknown type 4
[   82.895511]   <idle>-0       0d... 82791300us : Unknown type 4
[   82.895516]   <idle>-0       0dN.. 82791322us : Unknown type 4
[   82.895522]   <idle>-0       0d... 82795293us : Unknown type 4
[   82.895527]   <idle>-0       0dN.. 82795320us : Unknown type 4
[   82.895532]   <idle>-0       0d... 82799287us : Unknown type 4
[   82.895537]   <idle>-0       0dN.. 82799310us : Unknown type 4
[   82.895542]   <idle>-0       0d... 82803279us : Unknown type 4
[   82.895547]   <idle>-0       0dN.. 82803302us : Unknown type 4
[   82.895552]   <idle>-0       0d... 82807272us : Unknown type 4
[   82.895558]   <idle>-0       0dN.. 82807294us : Unknown type 4
[   82.895563]   <idle>-0       0d... 82811264us : Unknown type 4
[   82.895568]   <idle>-0       0dN.. 82811288us : Unknown type 4
[   82.895573]   <idle>-0       0d... 82815258us : Unknown type 4
[   82.895578]   <idle>-0       0dN.. 82815281us : Unknown type 4
[   82.895583]   <idle>-0       0d... 82819250us : Unknown type 4
[   82.895588]   <idle>-0       0dN.. 82819277us : Unknown type 4
[   82.895594]   <idle>-0       0d... 82823244us : Unknown type 4
[   82.895599]   <idle>-0       0dN.. 82823266us : Unknown type 4
[   82.895604]   <idle>-0       0d... 82827237us : Unknown type 4
[   82.895609]   <idle>-0       0dN.. 82827261us : Unknown type 4
[   82.895615]   <idle>-0       0d... 82831230us : Unknown type 4
[   82.895620]   <idle>-0       0dN.. 82831250us : Unknown type 4
[   82.895625]   <idle>-0       0d... 82835223us : Unknown type 4
[   82.895631]   <idle>-0       0dN.. 82835249us : Unknown type 4
[   82.895635] Switched to NOHz mode on CPU #54
[   82.895640]   <idle>-0       0d... 82839217us : Unknown type 4
[   82.895645]   <idle>-0       0dN.. 82839243us : Unknown type 4
[   82.895651]   <idle>-0       0d... 82843208us : Unknown type 4
[   82.895656]   <idle>-0       0dN.. 82843231us : Unknown type 4
[   82.895661]   <idle>-0       0d... 82847201us : Unknown type 4
[   82.895666]   <idle>-0       0dN.. 82847224us : Unknown type 4
[   82.895671]   <idle>-0       0d... 82851195us : Unknown type 4
[   82.895677]   <idle>-0       0dN.. 82851219us : Unknown type 4
[   82.895682]   <idle>-0       0d... 82855188us : Unknown type 4
[   82.895686] Switched to NOHz mode on CPU #42
[   82.895693] Switched to NOHz mode on CPU #46
[   82.895699] Switched to NOHz mode on CPU #49
[   82.895705]   <idle>-0       0dN.. 82855213us : Unknown type 4
[   82.895709] Switched to NOHz mode on CPU #109
[   82.895715] Switched to NOHz mode on CPU #111
[   82.895720]   <idle>-0       0d... 82859183us : Unknown type 4
[   82.895724] Switched to NOHz mode on CPU #101
[   82.895729]   <idle>-0       0dN.. 82859211us : Unknown type 4
[   82.895733] Switched to NOHz mode on CPU #98
[   82.895739] Switched to NOHz mode on CPU #96
[   82.895744]   <idle>-0       0d... 82863174us : Unknown type 4
[   82.895749]   <idle>-0       0dN.. 82863198us : Unknown type 4
[   82.895754]   <idle>-0       0d... 82867167us : Unknown type 4
[   82.895759]   <idle>-0       0dN.. 82867191us : Unknown type 4
[   82.895765]   <idle>-0       0d... 82871161us : Unknown type 4
[   82.895770]   <idle>-0       0dN.. 82871185us : Unknown type 4
[   82.895775]   <idle>-0       0d... 82875153us : Unknown type 4
[   82.895780] Switched to NOHz mode on CPU #17
[   82.895784]   <idle>-0       0dN.. 82875174us : Unknown type 4
[   82.895790] Switched to NOHz mode on CPU #14
[   82.895793]   <idle>-0       0d... 82879147us : Unknown type 4
[   82.895799] Switched to NOHz mode on CPU #3
[   82.895801]   <idle>-0       0dN.. 82879171us : Unknown type 4
[   82.895806]   <idle>-0       0d... 82883139us : Unknown type 4
[   82.895811]   <idle>-0       0dN.. 82883164us : Unknown type 4
[   82.895814] Switched to NOHz mode on CPU #4
[   82.895817]   <idle>-0       0d... 82887132us : Unknown type 4
[   82.895822] Switched to NOHz mode on CPU #153
[   82.895827]   <idle>-0       0dN.. 82887154us : Unknown type 4
[   82.895833]   <idle>-0       0d... 82891124us : Unknown type 4
[   82.895838]   <idle>-0       0dN.. 82891148us : Unknown type 4
[   82.895843]   <idle>-0       0d... 82893612us : Unknown type 4
[   82.895848]   <idle>-0       0d... 82893643us : Unknown type 4
[   82.895853]   <idle>-0       0d... 82895118us : Unknown type 4
[   82.895859]   <idle>-0       0dN.. 82895147us : Unknown type 4
[   82.895864]   <idle>-0       0d... 82895177us : Unknown type 4
[   82.895865] ---------------------------------


but if compile from fedora 14 gcc, will still have some delay.

[   33.464561] cpu_dev_init done
[   51.953005] memory_dev_init done

and it also have that warning...

Thanks

Yinghai

