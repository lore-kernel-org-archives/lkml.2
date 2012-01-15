Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752648Ab2AOWJc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jan 2012 17:09:32 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:58721 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752541Ab2AOWJb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jan 2012 17:09:31 -0500
Message-ID: <1326665367.5287.97.camel@edumazet-laptop>
Subject: Re: Why the number of /proc/interrupts doesn't change when nic is
 under heavy workload?
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Yuehai Xu <yuehaixu@gmail.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, yhxu@wayne.edu
Date: Sun, 15 Jan 2012 23:09:27 +0100
In-Reply-To: <CAEc1PS0doeaH59621ia7n2GT=WgRSsCit_EzGrCV93QH95XZqw@mail.gmail.com>
References: <CAEc1PS0doeaH59621ia7n2GT=WgRSsCit_EzGrCV93QH95XZqw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le dimanche 15 janvier 2012 à 15:53 -0500, Yuehai Xu a écrit :
> Hi All,
> 
> My nic of server is Intel Corporation 80003ES2LAN Gigabit Ethernet
> Controller, the driver is e1000e, and my Linux version is 3.1.4. I
> have a Memcached server running on this 8 core box, the weird thing is
> that when my server is under heavy workload, the number of
> /proc/interrupts doesn't change at all. Below are some details:
> =======
> cat /proc/interrupts | grep eth0
> 68:     330887     330861     331432     330544     330346     330227
>    330830     330575   PCI-MSI-edge      eth0
> =======
> cat /proc/irq/68/smp_affinity
> ff
> 
> I know when network is under heavy load, NAPI will disable nic
> interrupt and poll ring buffer in nic. My question is, when is nic
> interrupt enabled again? It seems that it will never be enabled if the
> heavy workload doesn't stop, simply because the number showed by
> /proc/interrupts doesn't change at all. In my case, one of core is
> saturated by ksoftirqd, because lots of softirqs are pending to that
> core. I just want to distribute these softirqs to other cores. Even
> RPS is enabled, that core is still occupied by ksoftirq, nearly 100%.
> 
> I dive into the codes and find these statements:
> __napi_schedule ==>
>    local_irq_save(flags);
>    ____napi_schedule(&__get_cpu_var(softnet_data), n);
>    local_irq_restore(flags);
> 
> here "local_irq_save" actually invokes "cli" which disable interrupt
> for the local core, is this the one that used in NAPI to disable nic
> interrupt? Personally I don't think it is because it just disables
> local cpu.
> 
> I also find "enable_irq/disable_irq/e1000_irq_enable/e1000_irq_disable"
> under drivers/net/e1000e, are these used in NAPI to disable nic
> interrupt, but I fail to get any clue that they are used in the code
> path of NAPI?

This is done in the device driver itself, not in generic NAPI code.

When NAPI poll() get less packets than the budget, it re-enables chip
interrupts.


> 
> My current situation is that, almost 60% of time of other 7 cores are
> idle, while only one core which is occupied by ksoftirq is 100% busy.
> 

You could post some info, like "cat /proc/net/softnet_stat"

If you use RPS on a very high workload, on a mono queue NIC, best is to
stick for example cpu0 for the packet dispatching, and other cpus for
IP/UDP handling.

echo 01 >/proc/irq/68/smp_affinity
echo fe >/sys/class/net/eth0/queues/rx-0/rps_cpus

Please keep in mind that if your memcache uses a single UDP socket, you
probably hit a lot of contention on the socket spinlock and various
counters. So maybe it would be better to _reduce_ number of cpus
handling network load to reduce false sharing.

echo 0e >/sys/class/net/eth0/queues/rx-0/rps_cpus

Really, if you have a single UDP queue, best would be to not use RPS and
only have :

echo 01 >/proc/irq/68/smp_affinity

Then you could post the result of "perf top -C 0" so that we can spot
obvious problems on the hot path for this particular cpu.



