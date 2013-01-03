Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753514Ab3ACNcE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2013 08:32:04 -0500
Received: from mail-pa0-f52.google.com ([209.85.220.52]:47845 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753220Ab3ACNcC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2013 08:32:02 -0500
Subject: Re: [PATCH net-next] softirq: reduce latencies
From: Eric Dumazet <eric.dumazet@gmail.com>
To: sedat.dilek@gmail.com
Cc: netdev@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <CA+icZUVEvzyrPsQG1QWLnHxhtaewaWTOVzBpTnLqjKuHMjjFHg@mail.gmail.com>
References: <CA+icZUVEvzyrPsQG1QWLnHxhtaewaWTOVzBpTnLqjKuHMjjFHg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 03 Jan 2013 05:31:59 -0800
Message-ID: <1357219919.21409.24519.camel@edumazet-glaptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-01-03 at 14:12 +0100, Sedat Dilek wrote:
> Hi Eric,
> 
> your patch from [2] applies cleanly on top of Linux v3.8-rc2.
> I would like to test it.
> In [1] you were talking about benchmarks you did.
> Can you describe them or provide a testcase (script etc.)?
> You made only network testing?

Yes I did network testing : 

- net_rx_action() softirq handler is the typical function that can
consume 2 ms per call.

I did some netperf sessions, with multiqueue 10G nics, tuned to that IRQ
would be handled by few cpus.
 (check /proc/irq/*/eth0-$QUEUE/../smp_affinity )

Another way to make the softirq processing use more cpu cycles is by
adding a fake iptable setup like :

for n in `seq 1 100`
do
 iptables -I INPUT
done

A common network load is to launch ~200 concurrent TCP_RR netperf
sessions like the following

netperf -H remote_host -t TCP_RR -l 1000

And then you can launch some netperf asking P99_LATENCY results :

netperf -H remote_host -t TCP_RR -- -k P99_LATENCY

You can play with taskset or netperf option -T to force
netperf/netserver running on given cpus.



