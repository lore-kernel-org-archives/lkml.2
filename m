Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752759Ab2AOXKh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jan 2012 18:10:37 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:40986 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750811Ab2AOXKf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jan 2012 18:10:35 -0500
Message-ID: <1326669030.5287.112.camel@edumazet-laptop>
Subject: Re: Why the number of /proc/interrupts doesn't change when nic is
 under heavy workload?
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Yuehai Xu <yuehaixu@gmail.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, yhxu@wayne.edu
Date: Mon, 16 Jan 2012 00:10:30 +0100
In-Reply-To: <CAEc1PS1gpA6p0Nb11bCkmi6q6e-yxN=63R1duPvimOFnjC9kLQ@mail.gmail.com>
References: <CAEc1PS0doeaH59621ia7n2GT=WgRSsCit_EzGrCV93QH95XZqw@mail.gmail.com>
	 <1326665367.5287.97.camel@edumazet-laptop>
	 <CAEc1PS0QxYfHfLFTiSFdTX27ufuxVfJd6Vg5oyv5aip5r=tD4A@mail.gmail.com>
	 <CAEc1PS1gpA6p0Nb11bCkmi6q6e-yxN=63R1duPvimOFnjC9kLQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le dimanche 15 janvier 2012 à 17:45 -0500, Yuehai Xu a écrit :

>  However, this also means there is a certain core
> needs to handle all softirqs, simply because my smp_affinity of irq
> doesn't work here.

You miss something here. You really should not ask to distribute
hardware irqs on all cores. This is in conflict with RPS, but also with
cache efficiency.

And anyway, if load is high enough, only one core is calling nic poll()
from its NAPI handler.

One cpu handles the nic poll(), and thanks to RPS distributes packets to
other cpus so that they handle (in their softirq handler) the IP stack,
plus the TCP/UDP stack.

>  Even RPS can alleviate some softirqs to other
> cores, it doesn't solve the problem 100%.

Problem is we dont know yet what is 'the problem', as you gave litle
info.

(You didnt tell us if your memcached was using TCP or UDP transport)

If your workload consists of many short lived tcp connections , RPS wont
help that much because the three way handshake needs to hold the
listener lock.



