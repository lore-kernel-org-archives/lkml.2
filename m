Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751851Ab1JBHVY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Oct 2011 03:21:24 -0400
Received: from mail-ww0-f42.google.com ([74.125.82.42]:49006 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751692Ab1JBHVN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Oct 2011 03:21:13 -0400
Subject: Re: big picture UDP/IP performance question re 2.6.18 -> 2.6.32
From: Eric Dumazet <eric.dumazet@gmail.com>
To: starlight@binnacle.cx
Cc: linux-kernel@vger.kernel.org, netdev <netdev@vger.kernel.org>,
        Willy Tarreau <w@1wt.eu>, Peter Zijlstra <a.p.zijlstra@chello.nl>
In-Reply-To: <6.2.5.6.2.20111001215241.03a7ed48@binnacle.cx>
References: <6.2.5.6.2.20111001215241.03a7ed48@binnacle.cx>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 02 Oct 2011 09:21:06 +0200
Message-ID: <1317540066.3802.32.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le dimanche 02 octobre 2011 à 01:33 -0400, starlight@binnacle.cx a
écrit :
> Did some additional testing and have an update:
> 
> 1) compiled 2.6.32.27 with CGROUP and NAMESPACES
> disabled as much as 'make menuconfig' will allow.
> Made no difference on performance--same exact
> result.
> 
> 2) did observe that the IRQ rate is 100k on
> 2.6.32.27 where it is 33k on 2.6.18(rhel).
> 
> 3) compiled 2.6.39.4 with same config used
> in (1) above, allowing 'make menuconfig'
> to fill in differences.  Tried 'make defconfig'
> but it left out too many modules and the kernel
> would not even install.  The config used to
> build this kernel is attached.
> 
> .39 Runs 7% better than .32 but still 27.5% worse
> than 2.6.18(rhel) on total reported CPU and 97%
> worse on system CPU.  The IRQ rate was 50k here.
> 
> 4) Ran the full 30 minute test again with 
> 
>    perf record -a
> 
> running and generated a report (attached).
> This was done in packet socket mode because
> all the newer kernels have some serious bug
> where UDP data is not delivered to about
> half of the sockets even though it arrives
> to the interface.  [I've been ignoring
> this since packet socket performance is
> close to UDP socket performance and I'm more
> worried about network overhead than the
> UDP bug.  Comparisons are with same mode
> test on the 2.6.18(rhel) kernel.]
> 
> The application '_raw_spin_lock' number
> stands out to me--makes me think that
> 2.6.39 has greater bias toward spinning
> futexes than 2.6.18(rhel) as the user
> CPU was 6.5% higher.  The .32(rhel) kernel
> is exactly the same on user CPU.  In UDP
> mode there is little or none of this lock-
> contention CPU--it appears here due to the
> need for queuing messages to worker
> threads in packet-socket mode.
> 
> Beyond that it looks to me like the kernel paths
> have no notable hot-spots, which makes me think
> that the code path has gotten longer everywhere
> or that subtle changes have interacted badly
> with cache behavior to cause the performance
> loss.  However someone who knows the kernel
> code may see things here that I cannot.
> 
> -----
> 
> This popped into my head.  About two years ago
> I tried benchmarking SLES RT with our application.
> The results were horrifically bad.  Don't know
> if anything from the RT work was merged into
> the kernel, but my overall impression was that
> RT traded CPU for latency to the extreme point
> where any application that used more than
> 10% of the much higher CPU consumption would
> not work.  Haven't looked at latency during
> these tests, but I suppose if there are
> improvements it might be worth the extra CPU
> it's costing.  Any thoughts on this?

You might try to disable any fancy power saving mode in your machine.
Maybe on your machine, cost to enter/exit deep sleep state is too high.

I see nothing obvious in the profile but userland processing, futex
calls. 

Network processing seems to account less than 10% of total cpu...
All this sounds more a process scheduling regression than a network
stack one..
 
On new kernels, you can check if your udp sockets drops frames because
of rcvbuffer being full (cat /proc/net/udp, check last column 'drops')

To check if softirq processing hit some limits :
cat /proc/net/softnet_stat

Please send full "dmesg" output 



