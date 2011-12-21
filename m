Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752335Ab1LUG3h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 01:29:37 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:33694 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751138Ab1LUG3e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 01:29:34 -0500
Message-ID: <1324456132.4579.0.camel@lappy>
Subject: Re: [PATCH 0/6][RFC] virtio-blk: Change I/O path from request to BIO
From: Sasha Levin <levinsasha928@gmail.com>
To: Minchan Kim <minchan@kernel.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>, Chris Wright <chrisw@sous-sol.org>,
        Jens Axboe <axboe@kernel.dk>,
        Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>
Date: Wed, 21 Dec 2011 10:28:52 +0200
In-Reply-To: <1324429254-28383-1-git-send-email-minchan@kernel.org>
References: <1324429254-28383-1-git-send-email-minchan@kernel.org>
Content-Type: text/plain; charset="us-ascii"
X-Mailer: Evolution 3.2.2 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-12-21 at 10:00 +0900, Minchan Kim wrote:
> This patch is follow-up of Christohp Hellwig's work
> [RFC: ->make_request support for virtio-blk].
> http://thread.gmane.org/gmane.linux.kernel/1199763
> 
> Quote from hch
> "This patchset allows the virtio-blk driver to support much higher IOP
> rates which can be driven out of modern PCI-e flash devices.  At this
> point it really is just a RFC due to various issues."
> 
> I fixed race bug and add batch I/O for enhancing sequential I/O,
> FLUSH/FUA emulation.
> 
> I tested this patch on fusion I/O device by aio-stress.
> Result is following as.
> 
> Benchmark : aio-stress (64 thread, test file size 512M, 8K io per IO, O_DIRECT write)
> Environment: 8 socket - 8 core, 2533.372Hz, Fusion IO 320G storage
> Test repeated by 20 times
> Guest I/O scheduler : CFQ
> Host I/O scheduler : NOOP
> 
>             Request            	BIO(patch 1-4)          BIO-batch(patch 1-6)
>          (MB/s)  stddev 	(MB/s)  stddev  	(MB/s)  stddev
> w        737.820 4.063  	613.735 31.605  	730.288 24.854
> rw       208.754 20.450 	314.630 37.352  	317.831 41.719
> r        770.974 2.340  	347.483 51.370  	750.324 8.280
> rr       250.391 16.910 	350.053 29.986  	325.976 24.846
> 
> This patch enhances ramdom I/O performance compared to request-based I/O path.
> It's still RFC so welcome to any comment and review.

I did a benchmark against a /dev/shm device instead of an actual storage
to get rid of any artifacts which are caused by the storage itself, and
saw that while there was a nice improvement across the board, the hit
against sequential read and write was quite significant.

I ran the tests with fio running in KVM tool against a 2G file located
in /dev/shm. Here is a summary of the results:

Before:
write_iops_seq
  write: io=1409.8MB, bw=144217KB/s, iops=36054 , runt= 10010msec
write_bw_seq
  write: io=7700.0MB, bw=1323.5MB/s, iops=1323 , runt=  5818msec
read_iops_seq
  read : io=1453.7MB, bw=148672KB/s, iops=37168 , runt= 10012msec
read_bw_seq
  read : io=7700.0MB, bw=1882.7MB/s, iops=1882 , runt=  4090msec
write_iops_rand
  write: io=1266.4MB, bw=129479KB/s, iops=32369 , runt= 10015msec
write_bw_rand
  write: io=7539.0MB, bw=1106.1MB/s, iops=1106 , runt=  6811msec
read_iops_rand
  read : io=1373.3MB, bw=140475KB/s, iops=35118 , runt= 10010msec
read_bw_rand
  read : io=7539.0MB, bw=1314.4MB/s, iops=1314 , runt=  5736msec
readwrite_iops_seq
  read : io=726172KB, bw=72292KB/s, iops=18072 , runt= 10045msec
  write: io=726460KB, bw=72321KB/s, iops=18080 , runt= 10045msec
readwrite_bw_seq
  read : io=3856.0MB, bw=779574KB/s, iops=761 , runt=  5065msec
  write: io=3844.0MB, bw=777148KB/s, iops=758 , runt=  5065msec
readwrite_iops_rand
  read : io=701780KB, bw=70094KB/s, iops=17523 , runt= 10012msec
  write: io=706120KB, bw=70527KB/s, iops=17631 , runt= 10012msec
readwrite_bw_rand
  read : io=3705.0MB, bw=601446KB/s, iops=587 , runt=  6308msec
  write: io=3834.0MB, bw=622387KB/s, iops=607 , runt=  6308msec

After:
write_iops_seq
  write: io=1591.4MB, bw=162626KB/s, iops=40656 , runt= 10020msec
write_bw_seq
  write: io=7700.0MB, bw=1276.4MB/s, iops=1276 , runt=  6033msec
read_iops_seq
  read : io=1615.7MB, bw=164680KB/s, iops=41170 , runt= 10046msec
read_bw_seq
  read : io=7700.0MB, bw=1407.1MB/s, iops=1407 , runt=  5469msec
write_iops_rand
  write: io=1243.1MB, bw=126304KB/s, iops=31575 , runt= 10085msec
write_bw_rand
  write: io=7539.0MB, bw=1206.3MB/s, iops=1206 , runt=  6250msec
read_iops_rand
  read : io=1533.1MB, bw=156795KB/s, iops=39198 , runt= 10018msec
read_bw_rand
  read : io=7539.0MB, bw=1413.7MB/s, iops=1413 , runt=  5333msec
readwrite_iops_seq
  read : io=819124KB, bw=81790KB/s, iops=20447 , runt= 10015msec
  write: io=823136KB, bw=82190KB/s, iops=20547 , runt= 10015msec
readwrite_bw_seq
  read : io=3913.0MB, bw=704946KB/s, iops=688 , runt=  5684msec
  write: io=3787.0MB, bw=682246KB/s, iops=666 , runt=  5684msec
readwrite_iops_rand
  read : io=802148KB, bw=80159KB/s, iops=20039 , runt= 10007msec
  write: io=801192KB, bw=80063KB/s, iops=20015 , runt= 10007msec
readwrite_bw_rand
  read : io=3731.0MB, bw=677762KB/s, iops=661 , runt=  5637msec
  write: io=3808.0MB, bw=691750KB/s, iops=675 , runt=  5637msec

-- 

Sasha.


