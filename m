Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932250Ab1BXDUx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 22:20:53 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:57163 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932098Ab1BXDUw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 22:20:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=XW2aHvtdhOuVvzXlP2L93KKOsV88Mpyo0F/0P/OQunmoLkF4yZrvAc57mibYNDkLCp
         I92qCFRW28RiZPL2O0et4jKHPtiZm1/BaWmK8dGdy6sSExkcBj0h2G8DA41y9x3qb35Y
         rc46U9gc848VJCanEG+Otor9GuiJc8fVszgpk=
MIME-Version: 1.0
Date: Wed, 23 Feb 2011 22:20:51 -0500
Message-ID: <AANLkTinr+p9QXMxcZWrefi-g697sODOsVP7Hdx8MxBW4@mail.gmail.com>
Subject: IO performance issue related to buffer cache?
From: Patrick LeBoutillier <patrick.leboutillier@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'm copying large files (3 x 30G) between 2 filesystems on a Linux
server (vanilla kernel 2.6.37, 16 cores, 32G RAM) and I'm getting poor
performance. I suspect that the usage of the buffer cache is killing
the I/O performance.

To try and narrow down the problem I used fio directly on the SAS disk
to monitor the performance.

Here is the output of 2 fio runs (the first with direct=1, the second
one direct=0):


=== Config ===

[test]
rw=write
blocksize=32k
size=20G
filename=/dev/sda
# direct=1


=== Run 1 ===

test: (g=0): rw=write, bs=32K-32K/32K-32K, ioengine=sync, iodepth=1
Starting 1 process
Jobs: 1 (f=1): [W] [100.0% done] [0K/205M /s] [0/6K iops] [eta 00m:00s]
test: (groupid=0, jobs=1): err= 0: pid=4667
  write: io=20,480MB, bw=199MB/s, iops=6,381, runt=102698msec
    clat (usec): min=104, max=13,388, avg=152.06, stdev=72.43
    bw (KB/s) : min=192448, max=213824, per=100.01%, avg=204232.82,
stdev=4084.67
  cpu          : usr=3.37%, sys=16.55%, ctx=655410, majf=0, minf=29
  IO depths    : 1=100.0%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, >=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     issued r/w: total=0/655360, short=0/0
     lat (usec): 250=99.50%, 500=0.45%, 750=0.01%, 1000=0.01%
     lat (msec): 2=0.01%, 4=0.02%, 10=0.01%, 20=0.01%

Run status group 0 (all jobs):
  WRITE: io=20,480MB, aggrb=199MB/s, minb=204MB/s, maxb=204MB/s,
mint=102698msec,    maxt=102698msec

Disk stats (read/write):
  sda: ios=0/655238, merge=0/0, ticks=0/79552, in_queue=78640, util=76.55%


=== Run 2 ===

test: (g=0): rw=write, bs=32K-32K/32K-32K, ioengine=sync, iodepth=1
Starting 1 process
Jobs: 1 (f=1): [W] [100.0% done] [0K/0K /s] [0/0 iops] [eta 00m:00s]
test: (groupid=0, jobs=1): err= 0: pid=4733
  write: io=20,480MB, bw=91,265KB/s, iops=2,852, runt=229786msec
    clat (usec): min=16, max=127K, avg=349.53, stdev=4694.98
    bw (KB/s) : min=56013, max=1390016, per=101.47%, avg=92607.31,
stdev=167453.17
  cpu          : usr=0.41%, sys=6.93%, ctx=21128, majf=0, minf=33
  IO depths    : 1=100.0%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, >=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     issued r/w: total=0/655360, short=0/0
     lat (usec): 20=5.53%, 50=93.89%, 100=0.02%, 250=0.01%, 500=0.01%
     lat (msec): 2=0.01%, 4=0.01%, 10=0.01%, 20=0.01%, 50=0.12%
     lat (msec): 100=0.38%, 250=0.04%

Run status group 0 (all jobs):
  WRITE: io=20,480MB, aggrb=91,265KB/s, minb=93,455KB/s,
maxb=93,455KB/s, mint=229786msec, maxt=229786msec

Disk stats (read/write):
  sda: ios=8/79811, merge=7/7721388, ticks=9/32418456,
in_queue=32471983, util=98.98%

I'm not knowledgeable enough with fio to interpret the results, but I
don't expect the overall performance using the buffer cache to be 50%
less than with O_DIRECT. I also get basically the same results using
dd.

Can someone help me interpret the fio output?
Are there any kernel tunings that could fix/minimize the problem?


Thanks a lot,

Patrick

-- 
=====================
Patrick LeBoutillier
Rosemère, Québec, Canada
