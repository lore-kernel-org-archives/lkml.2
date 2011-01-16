Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753693Ab1APTIO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Jan 2011 14:08:14 -0500
Received: from lucidpixels.com ([75.144.35.66]:46789 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753335Ab1APTIM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Jan 2011 14:08:12 -0500
Date: Sun, 16 Jan 2011 14:08:11 -0500 (EST)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: "Ian E. Morgan" <penguin.wrangler@gmail.com>
cc: linux-kernel@vger.kernel.org, linux-net@vger.kernel.org,
        Alan Piszcz <ap@solarrain.com>
Subject: Re: Only ~85MiB/s (e1000e/write) to ~310MiB/s RAID-0 on ATOM
 board?
In-Reply-To: <AANLkTimMz9xgVB2njxvKEe=CXrvig_1wTc1g7keTHZp1@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.1101161402430.29729@p34.internal.lan>
References: <alpine.DEB.2.00.1101071506480.10997@p34.internal.lan> <AANLkTimMz9xgVB2njxvKEe=CXrvig_1wTc1g7keTHZp1@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sun, 16 Jan 2011, Ian E. Morgan wrote:

> Justin,
>
> I have two Supermicro 5015a-EHF-D525's. They use the same Intel 82574L
> NICs as your slightly older board.
> I asked myself the same questions as you just recently, and my
> research into multi-queue NIC support led to:
>
> Receive Packet Steering
>
> Take a look at the output of NET_TX and NET_RX in /proc/softirq.
> The interrupts were not balanced across the cpus until I did:
>
> echo f > /sys/devices/pci0000:00/0000:00:1c.1/0000:02:00.0/net/eth0/queues/rx-0/rps_cpus
> ("f" being a bitmask of cpus)
>
> Then the interrupts started balancing across all cpus.
> I haven't had a chance to try this in a high throughput transfer
> situation yet, as I just happened to look into this last night.
>
> Hope it leads you down the right path, and please let me know if it
> does or doesn't help, or any other solutions you've found or come up
> with.
>
> --
> Ian Morgan


Hi Ian,

Thanks for the response & suggestion!

Tried it on kernel 2.6.37:

Made sure it was enabled:
# grep RPS .config
CONFIG_RPS=y

Only achieved 79.98M/s on > 4 GB of data via FTP (downloading), does not
appear to change much.

# cat /sys/class/net/eth1/queues/rx-0/rps_cpus
0

# echo f > /sys/class/net/eth1/queues/rx-0/rps_cpus
# cat /sys/class/net/eth1/queues/rx-0/rps_cpus
f
#

# cat /proc/softirqs
                     CPU0       CPU1       CPU2       CPU3
           HI:          0          0          0          0
        TIMER:     508490     507869     508325     508253
       NET_TX:      22933      24274      23800      22124
       NET_RX:      94412     218903      93273      95787
        BLOCK:      63945      22646      21324       8084
BLOCK_IOPOLL:          0          0          0          0
      TASKLET:          8          4          2          5
        SCHED:     244572     218617     262071     242491
      HRTIMER:          0          0          0          0
          RCU:      52859      53519      53715      55199


What speed(s) do you achieve with the D525s?

If anyone finds out why these boards cannot achieve > 90-100MiB/s to disk,
I'd be curious to know why, thanks.

Justin.

