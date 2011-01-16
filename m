Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753535Ab1APSuM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Jan 2011 13:50:12 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:40531 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753404Ab1APSuH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Jan 2011 13:50:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=SYtG+QO7Z0qYGXj0OX0aVlPk4y6sOPu/n1NNlz8C4ZYBl7h6iRV6ggpgwKLRJnHnUE
         E3Xf1y8rfHfKvjJoYMNlV0wB7Vma+aKUw/X9EkPETKeRPSm33kgR6OVoE2vs75rriItW
         2WNIvEGMgcMaJFB1EjzzuJ+bcVv5+1zMi9H4w=
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1101071506480.10997@p34.internal.lan>
References: <alpine.DEB.2.00.1101071506480.10997@p34.internal.lan>
From: "Ian E. Morgan" <penguin.wrangler@gmail.com>
Date: Sun, 16 Jan 2011 13:49:46 -0500
Message-ID: <AANLkTimMz9xgVB2njxvKEe=CXrvig_1wTc1g7keTHZp1@mail.gmail.com>
Subject: Re: Only ~85MiB/s (e1000e/write) to ~310MiB/s RAID-0 on ATOM board?
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: linux-kernel@vger.kernel.org, linux-net@vger.kernel.org,
        Alan Piszcz <ap@solarrain.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Justin,

I have two Supermicro 5015a-EHF-D525's. They use the same Intel 82574L
NICs as your slightly older board.
I asked myself the same questions as you just recently, and my
research into multi-queue NIC support led to:

Receive Packet Steering

Take a look at the output of NET_TX and NET_RX in /proc/softirq.
The interrupts were not balanced across the cpus until I did:

echo f > /sys/devices/pci0000:00/0000:00:1c.1/0000:02:00.0/net/eth0/queues/rx-0/rps_cpus
("f" being a bitmask of cpus)

Then the interrupts started balancing across all cpus.
I haven't had a chance to try this in a high throughput transfer
situation yet, as I just happened to look into this last night.

Hope it leads you down the right path, and please let me know if it
does or doesn't help, or any other solutions you've found or come up
with.

--
Ian Morgan




On Fri, Jan 7, 2011 at 15:18, Justin Piszcz <jpiszcz@lucidpixels.com> wrote:
> Hi,
>
> Motherboard: Supermicro X7SPA-HF (MINI-ITX)
>
> I tried changing various settings with ethtool, ifconfig, and e1000e module
> parameters.
>
> => I get ~310MiB/s write with 5 Raptor 150s in RAID-0
> atom166:/r1# dd if=/dev/zero of=bigfile bs=1M count=10240
> 10240+0 records in
> 10240+0 records out
> 10737418240 bytes (11 GB) copied, 34.7194 s, 309 MB/s
> atom166:/r1#
>
>
> => I get 239MiB/s read with 5 Raptor 150s in RAID-0
> # dd if=bigfile of=/dev/null bs=1M count=10240
> 10240+0 records in
> 10240+0 records out
> 10737418240 bytes (11 GB) copied, 44.9199 s, 239 MB/s
>
> When I use samba to push files to this RAID I only get between 80-90MiB/s
> instead of the usual 100-120MiB/s I see between my main (ATX) boards..  It
> seems to hover around 85MiB/s average..
>
> I also tried an external PCI-e 1.0 Intel NIC, made no difference.  From the
> NM10 chipset block diagram, there should be enough bandwidth to fully
> saturate a gigabit link, is the CPU (Dual core Atom D510) too slow to
> achieve the maximum speed?
>
> FTP is slightly faster:
> `20101030-t500.tib' at 400541736 (3%) 88.72M/s eta:2m [Receiving data]
> `20101030-t500.tib' at 565772280 (4%) 91.51M/s eta:2m [Receiving data]
> `20101030-t500.tib' at 982224624 (7%) 94.75M/s eta:2m [Receiving data]
> `20101030-t500.tib' at 1967568384 (15%) 96.39M/s eta:2m [Receiving data]
> `20101030-t500.tib' at 2299966640 (17%) 96.90M/s eta:2m [Receiving data]
>
> Getting the same file to an ATX motherboard:
> `20101030-t500.tib' at 1020865896 (7%) 106.13M/s eta:2m [Receiving data]
> `20101030-t500.tib' at 1394552704 (10%) 107.53M/s eta:2m [Receiving data]
> `20101030-t500.tib' at 1861689088 (14%) 108.49M/s eta:97s [Receiving data]
> `20101030-t500.tib' at 2702497824 (21%) 109.56M/s eta:88s [Receiving data]
> `20101030-t500.tib' at 3636710872 (28%) 110.27M/s eta:80s [Receiving data]
>
> Why cannot I achieve the last 10-20MiB/s in performance on the Atom board?
>
> Also, the other direction (READ) I get 105-110MiB/s:
> procs -----------memory---------- ---swap-- -----io---- -system--
> ----cpu----
>  r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us sy id
> wa
>  0  0      0  37260    328 3888560    0    0  3187  6746 2295  309  1 13 84
>  1
>  0  0      0  36632    328 3890492    0    0 105184     0 23332 4924  3 21
> 75  0
>  0  0      0  35516    328 3893688    0    0 105616     0 23567 5143  3 22
> 75  0
>  1  0      0  35888    328 3894428    0    0 106404     0 23247 5167  3 21
> 76  0
>  0  0      0  35392    328 3897068    0    0 106472     0 23351 5221  3 21
> 76  0
>
> What is causing the bottleneck for write?
>
> Justin.
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
