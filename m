Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755629Ab2A0G2u (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 01:28:50 -0500
Received: from MAIL.13thfloor.at ([213.145.232.33]:57110 "EHLO
	MAIL.13thfloor.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751371Ab2A0G2t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 01:28:49 -0500
X-Greylist: delayed 1693 seconds by postgrey-1.27 at vger.kernel.org; Fri, 27 Jan 2012 01:28:48 EST
Date: Fri, 27 Jan 2012 07:00:34 +0100
From: Herbert Poetzl <herbert@13thfloor.at>
To: Linux Kernel ML <linux-kernel@vger.kernel.org>
Subject: Bad SSD performance with recent kernels
Message-ID: <20120127060034.GG29272@MAIL.13thfloor.at>
Mail-Followup-To: Linux Kernel ML <linux-kernel@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Dear Community!

Recently I decided to update the kernel on a Dell Laptop to
a more recent version than 2.6.38.x, but experienced bad
I/O performance with the new kernel, so I started to dig
a little deeper and ended up with the following test:

  1) download and extract kernel (on 2.6.38.8)
  2) make defconfig
  3) make localmodconfig
  4) make
  5) make modules_install install

Then I booted each kernel in single user and ran the following
test script:

  echo noop >/sys/class/block/sda/queue/scheduler
  for n in 1 2 3; do sync; echo $n > /proc/sys/vm/drop_caches; done
  /usr/bin/time -f "real = %e, user = %U, sys = %S, %P cpu" \
        ionice -c0 nice -20 \
        dd if=/dev/sda of=/dev/null bs=1M count=20480

  echo deadline >/sys/class/block/sda/queue/scheduler
  for n in 1 2 3; do sync; echo $n > /proc/sys/vm/drop_caches; done
  /usr/bin/time -f "real = %e, user = %U, sys = %S, %P cpu" \
        ionice -c0 nice -20 \
        dd if=/dev/sda of=/dev/null bs=1M count=20480

  echo cfq >/sys/class/block/sda/queue/scheduler
  for n in 1 2 3; do sync; echo $n > /proc/sys/vm/drop_caches; done
  /usr/bin/time -f "real = %e, user = %U, sys = %S, %P cpu" \
        ionice -c0 nice -20 \
        dd if=/dev/sda of=/dev/null bs=1M count=20480


note that the Laptop is a relatively modern Latitude E6400
with a Samsung 830 Series 256GB SSD

here are the surprising results:

@ linux 2.6.38.8
  248 MB/s  real = 86.74, user = 0.01, sys = 21.65, 24% cpu
  248 MB/s  real = 86.81, user = 0.02, sys = 21.75, 25% cpu
  251 MB/s  real = 85.63, user = 0.01, sys = 22.24, 25% cpu

@ linux 2.6.39.4
 49.0 MB/s  real = 438.79, user = 0.01, sys = 19.79, 4% cpu
 25.7 MB/s  real = 836.70, user = 0.02, sys = 18.39, 2% cpu
 27.7 MB/s  real = 776.53, user = 0.01, sys = 16.03, 2% cpu

@ linux 3.0.18
 48.9 MB/s  real = 439.07, user = 0.01, sys = 17.55, 4% cpu
 25.0 MB/s  real = 859.03, user = 0.01, sys = 16.97, 1% cpu
 49.8 MB/s  real = 431.61, user = 0.01, sys = 16.68, 3% cpu

@ linux 3.1.10
 54.0 MB/s  real = 398.23, user = 0.01, sys = 17.36, 4% cpu
 29.4 MB/s  real = 731.47, user = 0.01, sys = 17.14, 2% cpu
 25.0 MB/s  real = 859.35, user = 0.01, sys = 14.51, 1% cpu

@ linux 3.2.2
 45.8 MB/s  real = 468.85, user = 0.01, sys = 17.11, 3% cpu
 44.8 MB/s  real = 478.92, user = 0.01, sys = 17.02, 3% cpu
 45.0 MB/s  real = 476.91, user = 0.01, sys = 16.14, 3% cpu


I have no idea why the I/O performance is that bad on any
kernel newer than 2.6.38.x, but I'm happy to test and/or
try various configurations as time permits ...

The detailed test results as well as the dmesg and config
of each kernel can be found here:
http://vserver.13thfloor.at/Stuff/SSD

many thanks in advance,
Herbert

here some technical information:

http://www.dell.com/us/dfb/p/latitude-e6400/pd
SATA controller: Intel Corporation ICH9M/M-E SATA AHCI Controller (rev 03)

http://www.samsung.com/uk/consumer/memory-cards-hdd-odd/ssd/ssd/MZ-7PC256N/EU-spec
Model=SAMSUNG SSD 830 Series, FwRev=CXM03B1Q
supposed 520MB/s seq. read, 320MB/s seq. write, 75K IOPS





