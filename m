Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755688Ab0I3Mok (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Sep 2010 08:44:40 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:47882 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751982Ab0I3Moi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Sep 2010 08:44:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=xQ7iT9MXM92hY6Z6cOaQioiPzcmrula7JREUczKjCMvPYBrhfLie5bnpire5FnA2sc
         S4lZbvYtFnIo0+VYfUAbTV5rFPNZ1eYm47udi1yVzhmiy/wlcoR7XKVgYALJHCFyAhyX
         ogujbyCfZbIN/uhwTINEJoZkXIcqROvAdRLxM=
Subject: Re: Packet time delays on multi-core systems
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Alexey Vlasov <renton@renton.name>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
In-Reply-To: <20100930122321.GA1575@beaver.vrungel.ru>
References: <20100929191851.GC86786@beaver.vrungel.ru>
	 <1285796721.5211.156.camel@edumazet-laptop>
	 <20100930062419.GD86786@beaver.vrungel.ru>
	 <1285828432.5211.812.camel@edumazet-laptop>
	 <20100930122321.GA1575@beaver.vrungel.ru>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 30 Sep 2010 14:44:29 +0200
Message-ID: <1285850669.2615.426.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le jeudi 30 septembre 2010 à 16:23 +0400, Alexey Vlasov a écrit :
> On Thu, Sep 30, 2010 at 08:33:52AM +0200, Eric Dumazet wrote:
> > Le jeudi 30 septembre 2010 ?? 10:24 +0400, Alexey Vlasov a ??crit :
> > > Here I found some dude with the same problem:
> > > http://lkml.org/lkml/2010/7/9/340
> > > 
> > 
> > In your opinion its the same problem.
> > 
> > But the description you gave is completely different.
> > 
> > You have time skew only when activating a particular iptables rule.
>  
> Well I put interrups from NIC, namely tx/rx query, to different
> processors and got normal pings by adding LOG rule.
> 
> I also found that overruns is constantly growing, I don't know if these are connected.
> RX packets:2831439546 errors:0 dropped:134726 overruns:947671733 frame:0
> TX packets:2880849825 errors:0 dropped:0 overruns:0 carrier:0
> 
> Rather strange that only one processor was involved, even in top was
> clear that ksoftirqd eats the first processor up to 100%. 
> 

OK, because only CPU0 gets interrupts of all queues.

> Here goes the typical distribution of interrups on new servers:
>            CPU0    CPU1    CPU2    CPU3 ... CPU23
> 752:         11       0       0       0 ...     0 PCI-MSI-edge eth0
> 753: 2799366721       0       0       0 ...     0 PCI-MSI-edge eth0-rx3
> 754: 2821840553       0       0       0 ...     0 PCI-MSI-edge eth0-rx2
> 755: 2786117044       0       0       0 ...     0 PCI-MSI-edge eth0-rx1
> 756: 2896099336       0       0       0 ...     0 PCI-MSI-edge eth0-rx0
> 757: 1808404680       0       0       0 ...     0 PCI-MSI-edge eth0-tx3
> 758: 1797855130       0       0       0 ...     0 PCI-MSI-edge eth0-tx2
> 759: 1807222032       0       0       0 ...     0 PCI-MSI-edge eth0-tx1
> 760: 1820309360       0       0       0 ...     0 PCI-MSI-edge eth0-tx0
> 

echo 01 >/proc/irq/*/eth0-rx0/../smp_affinity
echo 02 >/proc/irq/*/eth0-rx1/../smp_affinity
echo 04 >/proc/irq/*/eth0-rx2/../smp_affinity
echo 08 >/proc/irq/*/eth0-rx3/../smp_affinity


cat /proc/irq/*/eth0-rx0/../smp_affinity
cat /proc/irq/*/eth0-rx1/../smp_affinity
cat /proc/irq/*/eth0-rx2/../smp_affinity
cat /proc/irq/*/eth0-rx3/../smp_affinity



> On the old ones:
>            CPU0       CPU1       CPU2  ...      CPU8
> 502:  522320256  522384039  522327386  ... 522380267 PCI-MSI-edge eth0
> 

What network driver is it (newbox), was it (old box) ?

If you switch to 2.6.35, you can use RPS to dispatch packets to several
cpu, in the case interrupt affinity could not be changed (all interrupts
still handled by CPU0)



