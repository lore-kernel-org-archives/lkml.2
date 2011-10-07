Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759557Ab1JGFkQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Oct 2011 01:40:16 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:36433 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751306Ab1JGFkO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Oct 2011 01:40:14 -0400
Subject: Re: big picture UDP/IP performance question re 2.6.18  -> 2.6.32
From: Eric Dumazet <eric.dumazet@gmail.com>
To: starlight@binnacle.cx
Cc: linux-kernel@vger.kernel.org, netdev <netdev@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Christoph Lameter <cl@gentwo.org>, Willy Tarreau <w@1wt.eu>,
        Ingo Molnar <mingo@elte.hu>,
        Stephen Hemminger <stephen.hemminger@vyatta.com>,
        Benjamin LaHaise <bcrl@kvack.org>, Joe Perches <joe@perches.com>,
        Chetan Loke <Chetan.Loke@netscout.com>,
        Con Kolivas <conman@kolivas.org>,
        Serge Belyshev <belyshev@depni.sinp.msu.ru>
In-Reply-To: <6.2.5.6.2.20111006231958.039bb570@binnacle.cx>
References: <6.2.5.6.2.20111006231958.039bb570@binnacle.cx>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 07 Oct 2011 07:40:07 +0200
Message-ID: <1317966007.3457.47.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le jeudi 06 octobre 2011 à 23:27 -0400, starlight@binnacle.cx a écrit :
> After writing the last post, the large
> difference in IRQ rate between the older
> and newer kernels caught my eye.
> 
> I wonder if the hugely lower rate in the older
> kernels reflects a more agile shifting
> into and out of NAPI mode by the network
> bottom-half.
> 
> In this test the sending system
> pulses data out on millisecond boundaries
> due to the behavior of nsleep(), which
> is used to establish the playback pace.
> 
> If the older kernels are switching to NAPI
> for much of surge and the switching out
> once the pulse falls off, it might
> conceivably result in much better latency
> and overall performance.
> 
> All tests were run with Intel 82571 
> network interfaces and the 'e1000e'
> device driver.  Some used the driver
> packaged with the kernel, some used
> Intel driver compiled from the source
> found on sourceforge.net.  Never could
> detected any difference between the two.
> 
> Since data in the production environment
> also tends to arrive in bursts, I don't find
> the pulsing playback behavior a detriment.
> 

Thats exactly the opposite : Your old kernel is not fast enough to
enter/exit NAPI on every incoming frame.

Instead of one IRQ per incoming frame, you have less interrupts :
A napi run processes more than 1 frame.

Now increase your incoming rate, and you'll discover a new kernel will
be able to process more frames without losses.

About your thread model :

You have one thread that reads the incoming frame, and do a distribution
on several queues based on some flow parameters. Then you wakeup a
second thread.

This kind of model is very expensive and triggers lot of false sharing.

New kernels are able to perform this fanout in kernel land.

You really should take a look at Documentation/networking/scaling.txt

[ An other way of doing this fanout is using some iptables rules :
check following commit changelog for an idea ]

commit e8648a1fdb54da1f683784b36a17aa65ea56e931
Author: Eric Dumazet <eric.dumazet@gmail.com>
Date:   Fri Jul 23 12:59:36 2010 +0200

    netfilter: add xt_cpu match
    
    In some situations a CPU match permits a better spreading of
    connections, or select targets only for a given cpu.
    
    With Remote Packet Steering or multiqueue NIC and appropriate IRQ
    affinities, we can distribute trafic on available cpus, per session.
    (all RX packets for a given flow is handled by a given cpu)
    
    Some legacy applications being not SMP friendly, one way to scale a
    server is to run multiple copies of them.
    
    Instead of randomly choosing an instance, we can use the cpu number as a
    key so that softirq handler for a whole instance is running on a single
    cpu, maximizing cache effects in TCP/UDP stacks.
    
    Using NAT for example, a four ways machine might run four copies of
    server application, using a separate listening port for each instance,
    but still presenting an unique external port :
    
    iptables -t nat -A PREROUTING -p tcp --dport 80 -m cpu --cpu 0 \
            -j REDIRECT --to-port 8080
    
    iptables -t nat -A PREROUTING -p tcp --dport 80 -m cpu --cpu 1 \
            -j REDIRECT --to-port 8081
    
    iptables -t nat -A PREROUTING -p tcp --dport 80 -m cpu --cpu 2 \
            -j REDIRECT --to-port 8082
    
    iptables -t nat -A PREROUTING -p tcp --dport 80 -m cpu --cpu 3 \
            -j REDIRECT --to-port 8083
    


