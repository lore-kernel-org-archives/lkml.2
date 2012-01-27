Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753129Ab2A0Go4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 01:44:56 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:43586 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750948Ab2A0Goz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 01:44:55 -0500
Message-ID: <1327646687.2919.26.camel@edumazet-laptop>
Subject: Re: Bad SSD performance with recent kernels
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Herbert Poetzl <herbert@13thfloor.at>
Cc: Linux Kernel ML <linux-kernel@vger.kernel.org>
Date: Fri, 27 Jan 2012 07:44:47 +0100
In-Reply-To: <20120127060034.GG29272@MAIL.13thfloor.at>
References: <20120127060034.GG29272@MAIL.13thfloor.at>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le vendredi 27 janvier 2012 à 07:00 +0100, Herbert Poetzl a écrit :
> Dear Community!
> 
> Recently I decided to update the kernel on a Dell Laptop to
> a more recent version than 2.6.38.x, but experienced bad
> I/O performance with the new kernel, so I started to dig
> a little deeper and ended up with the following test:
> 
>   1) download and extract kernel (on 2.6.38.8)
>   2) make defconfig
>   3) make localmodconfig
>   4) make
>   5) make modules_install install
> 
> Then I booted each kernel in single user and ran the following
> test script:
> 
>   echo noop >/sys/class/block/sda/queue/scheduler
>   for n in 1 2 3; do sync; echo $n > /proc/sys/vm/drop_caches; done
>   /usr/bin/time -f "real = %e, user = %U, sys = %S, %P cpu" \
>         ionice -c0 nice -20 \
>         dd if=/dev/sda of=/dev/null bs=1M count=20480
> 
>   echo deadline >/sys/class/block/sda/queue/scheduler
>   for n in 1 2 3; do sync; echo $n > /proc/sys/vm/drop_caches; done
>   /usr/bin/time -f "real = %e, user = %U, sys = %S, %P cpu" \
>         ionice -c0 nice -20 \
>         dd if=/dev/sda of=/dev/null bs=1M count=20480
> 
>   echo cfq >/sys/class/block/sda/queue/scheduler
>   for n in 1 2 3; do sync; echo $n > /proc/sys/vm/drop_caches; done
>   /usr/bin/time -f "real = %e, user = %U, sys = %S, %P cpu" \
>         ionice -c0 nice -20 \
>         dd if=/dev/sda of=/dev/null bs=1M count=20480
> 
> 
> note that the Laptop is a relatively modern Latitude E6400
> with a Samsung 830 Series 256GB SSD
> 
> here are the surprising results:
> 
> @ linux 2.6.38.8
>   248 MB/s  real = 86.74, user = 0.01, sys = 21.65, 24% cpu
>   248 MB/s  real = 86.81, user = 0.02, sys = 21.75, 25% cpu
>   251 MB/s  real = 85.63, user = 0.01, sys = 22.24, 25% cpu
> 
> @ linux 2.6.39.4
>  49.0 MB/s  real = 438.79, user = 0.01, sys = 19.79, 4% cpu
>  25.7 MB/s  real = 836.70, user = 0.02, sys = 18.39, 2% cpu
>  27.7 MB/s  real = 776.53, user = 0.01, sys = 16.03, 2% cpu
> 
> @ linux 3.0.18
>  48.9 MB/s  real = 439.07, user = 0.01, sys = 17.55, 4% cpu
>  25.0 MB/s  real = 859.03, user = 0.01, sys = 16.97, 1% cpu
>  49.8 MB/s  real = 431.61, user = 0.01, sys = 16.68, 3% cpu
> 
> @ linux 3.1.10
>  54.0 MB/s  real = 398.23, user = 0.01, sys = 17.36, 4% cpu
>  29.4 MB/s  real = 731.47, user = 0.01, sys = 17.14, 2% cpu
>  25.0 MB/s  real = 859.35, user = 0.01, sys = 14.51, 1% cpu
> 
> @ linux 3.2.2
>  45.8 MB/s  real = 468.85, user = 0.01, sys = 17.11, 3% cpu
>  44.8 MB/s  real = 478.92, user = 0.01, sys = 17.02, 3% cpu
>  45.0 MB/s  real = 476.91, user = 0.01, sys = 16.14, 3% cpu
> 
> 
> I have no idea why the I/O performance is that bad on any
> kernel newer than 2.6.38.x, but I'm happy to test and/or
> try various configurations as time permits ...
> 
> The detailed test results as well as the dmesg and config
> of each kernel can be found here:
> http://vserver.13thfloor.at/Stuff/SSD
> 
> many thanks in advance,
> Herbert
> 
> here some technical information:
> 
> http://www.dell.com/us/dfb/p/latitude-e6400/pd
> SATA controller: Intel Corporation ICH9M/M-E SATA AHCI Controller (rev 03)
> 
> http://www.samsung.com/uk/consumer/memory-cards-hdd-odd/ssd/ssd/MZ-7PC256N/EU-spec
> Model=SAMSUNG SSD 830 Series, FwRev=CXM03B1Q
> supposed 520MB/s seq. read, 320MB/s seq. write, 75K IOPS
> 
> 


I confirm I just noticed this on a brand new SSD from Crucial (128 GB)
and a Dell E6400 too (3.5 years old model)

The Ubuntu upgrade from 11.04 to 11.10 switched kernel (from 2.6.38.X to
3.0.0.X) and raw SSD performance (hdparm -t /dev/sda) dropped from 200
MB/s to 140 MB/s or so.



