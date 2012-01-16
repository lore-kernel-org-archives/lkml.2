Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753270Ab2APHBi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jan 2012 02:01:38 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:48489 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750728Ab2APHBh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jan 2012 02:01:37 -0500
Message-ID: <1326697292.5287.122.camel@edumazet-laptop>
Subject: Re: Why the number of /proc/interrupts doesn't change when nic is
 under heavy workload?
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Yuehai Xu <yuehaixu@gmail.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, yhxu@wayne.edu
Date: Mon, 16 Jan 2012 08:01:32 +0100
In-Reply-To: <1326696808.5287.115.camel@edumazet-laptop>
References: <CAEc1PS0doeaH59621ia7n2GT=WgRSsCit_EzGrCV93QH95XZqw@mail.gmail.com>
	 <1326665367.5287.97.camel@edumazet-laptop>
	 <CAEc1PS0QxYfHfLFTiSFdTX27ufuxVfJd6Vg5oyv5aip5r=tD4A@mail.gmail.com>
	 <1326696808.5287.115.camel@edumazet-laptop>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le lundi 16 janvier 2012 à 07:53 +0100, Eric Dumazet a écrit :
> Le dimanche 15 janvier 2012 à 17:27 -0500, Yuehai Xu a écrit :
> > Thanks for replying! Please see below:
> 
> > My memcached uses 8 different UDP sockets(8 different UDP ports), so
> > there should be no lock contention for a single UDP rx-queue.
> 
> Ah, I missed this mail, so you really should post here result of "perf
> top -C 0", after you make sure your NIC interrupts are handled by cpu 0.
> 
> Also, what speed is your link, and how many UDP messages per second do
> you receive ?
> 

RPS is not good for you because the generic rxhash computation will
spread messages for UDP port XX on many different cpus (because rxhash
computation takes into account the complete tuple (src ip, dst ip, src
port, dst port), not only dst port.

It would be better for your workload to only hash dst port, to avoid
false sharing on socket structure.

I guess we could extend rxhash computation to use a pluggable BPF
filter, now we can have fast filters.



