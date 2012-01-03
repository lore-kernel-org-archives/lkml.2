Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755079Ab2ACUaf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jan 2012 15:30:35 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:46020 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752502Ab2ACUad (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jan 2012 15:30:33 -0500
Message-ID: <1325622628.2611.8.camel@edumazet-laptop>
Subject: Re: APIC seems not working under high network load
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Jia Rao <rickenrao@gmail.com>
Cc: linux-kernel@vger.kernel.org, netdev <netdev@vger.kernel.org>
Date: Tue, 03 Jan 2012 21:30:28 +0100
In-Reply-To: <CAA8E7hFwvhATa+LAsW4csnUh1gL-tFZVQMO7LN0iQBa6NFj3KQ@mail.gmail.com>
References: <CAA8E7hFwvhATa+LAsW4csnUh1gL-tFZVQMO7LN0iQBa6NFj3KQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mardi 03 janvier 2012 à 14:28 -0500, Jia Rao a écrit :
> Hi all,
> 
> I had scalability issues when running memcached-like workloads in a
> Intel 8-core system. It turned out that under high network load only
> one core handled the interrupts from NIC. In the output of mpstat, one
> of the core was overloaded with 100% %soft time. I tried to echo
> different core ids to /proc/irq/irq#/smp_affinity, it did not take
> effect until I stopped the incoming network traffic. It seems that
> APIC is not distributing interrupts to different cores.
> 
> The below are the details of the testing system:
> OS: Linux 3.1.4 X86_64
> CPU: Intel L5450, quad-core
> NIC: Intel e1000e

If network load is high enough, cpu handling network IRQ stay in softirq
mode (NAPI) and never re-arms interrupt, so no other cpu can handle the
load.

This is why its better to change /proc/irq/irq#/smp_affinity _before_
load starts.

With your kernel, one way to help this cpu exit from softirq is using
RPS (Receive Packet Steering), since packets will be spreaded on several
cpus. Then, later hardware IRQ might be spreaded on other cpus as well.

for n in `seq 0 7`
do
 echo ff >/sys/class/net/eth0/queues/rx-$n/rps_cpus
done

[ If your eth0 has 8 queues ]



