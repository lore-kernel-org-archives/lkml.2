Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752056Ab2A2InF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jan 2012 03:43:05 -0500
Received: from MAIL.13thfloor.at ([213.145.232.33]:50679 "EHLO
	MAIL.13thfloor.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751611Ab2A2InD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jan 2012 03:43:03 -0500
Date: Sun, 29 Jan 2012 09:42:59 +0100
From: Herbert Poetzl <herbert@13thfloor.at>
To: Wu Fengguang <wfg@linux.intel.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>,
        Tejun Heo <tj@kernel.org>
Subject: Re: Bad SSD performance with recent kernels
Message-ID: <20120129084259.GI29272@MAIL.13thfloor.at>
Mail-Followup-To: Wu Fengguang <wfg@linux.intel.com>,
	Eric Dumazet <eric.dumazet@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	LKML <linux-kernel@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>,
	Tejun Heo <tj@kernel.org>
References: <20120127060034.GG29272@MAIL.13thfloor.at> <20120128125108.GA9661@localhost> <1327757611.7199.6.camel@edumazet-laptop> <20120129055917.GB8513@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20120129055917.GB8513@localhost>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 29, 2012 at 01:59:17PM +0800, Wu Fengguang wrote:
> On Sat, Jan 28, 2012 at 02:33:31PM +0100, Eric Dumazet wrote:
>> Le samedi 28 janvier 2012 à 20:51 +0800, Wu Fengguang a écrit :

>>> Would you please create a filesystem and large file on sda
>>> and run the tests on the file? There was some performance bug
>>> on reading the raw /dev/sda device file..

as promised, I did the tests on a filesystem, created on
a partition of the disk, and here are the (IMHO quite
interesting) results:

kernel    -- write ---  ------------------read -----------------
          --- noop ---  --- noop ---  - deadline -  ---- cfs ---
          [MB/s]  %CPU  [MB/s]  %CPU  [MB/s]  %CPU  [MB/s]  %CPU
----------------------------------------------------------------
2.6.38.8  268.76  49.6  169.20  11.3  169.17  11.3  167.89  11.4
2.6.39.4  269.73  50.3  162.03  10.9  161.58  10.9  161.64  11.0
3.0.18    269.17  42.0  161.87   9.9  161.36  10.0  161.68  10.1
3.1.10    271.62  43.1  161.91   9.9  161.68   9.9  161.25  10.1
3.2.2     270.95  42.6  162.36   9.9  162.63   9.9  162.65  10.1

so while the 'expected' performance should be somewhere around
300MB/s for read and write (raw disk access) we end up with
good write performance and roughly half the read performance
with 'dd bs=1M' on ext3

here the script I used:

mke2fs -j /dev/sda5
mount /dev/sda5 /media

/usr/bin/time -f "real = %e, user = %U, sys = %S, %P cpu" \
	ionice -c0 nice -20 \
	dd if=/dev/zero of=/media/zero.data bs=1M count=19900

echo noop >/sys/class/block/sda/queue/scheduler
for n in 1 2 3; do sync; echo $n > /proc/sys/vm/drop_caches; done
/usr/bin/time -f "real = %e, user = %U, sys = %S, %P cpu" \
	ionice -c0 nice -20 \
	dd if=/media/zero.data of=/dev/null bs=1M count=19900

echo deadline >/sys/class/block/sda/queue/scheduler
for n in 1 2 3; do sync; echo $n > /proc/sys/vm/drop_caches; done
/usr/bin/time -f "real = %e, user = %U, sys = %S, %P cpu" \
	ionice -c0 nice -20 \
	dd if=/media/zero.data of=/dev/null bs=1M count=19900

echo cfq >/sys/class/block/sda/queue/scheduler
for n in 1 2 3; do sync; echo $n > /proc/sys/vm/drop_caches; done
/usr/bin/time -f "real = %e, user = %U, sys = %S, %P cpu" \
	ionice -c0 nice -20 \
	dd if=/media/zero.data of=/dev/null bs=1M count=19900

>> Hmm... latest kernel has the performance bug right now.

>> Really if /dev/sda is slow, we are stuck.

> What's the block size? If it's < 4k, performance might be hurt.
>         blockdev --getbsz /dev/sda

4096

>> FYI, I started a bisection.

> Thank you! If the bisection would take much human time, it should be
> easier to collect some blktrace data on reading /dev/sda for analyzes.

will do some bonnie++ tests on the partition later today

HTH,
Herbert

> Thanks,
> Fengguang
