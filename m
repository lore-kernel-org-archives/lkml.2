Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932556Ab2IQVVP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 17:21:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49227 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753878Ab2IQVT7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 17:19:59 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>, Jens Axboe <axboe@kernel.dk>,
        Andrea Arcangeli <aarcange@redhat.com>, Jan Kara <jack@suse.cz>,
        dm-devel@redhat.com, linux-kernel@vger.kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        kosaki.motohiro@jp.fujitsu.com, linux-fsdevel@vger.kernel.org,
        lwoodman@redhat.com, "Alasdair G. Kergon" <agk@redhat.com>
Subject: Re: [PATCH 0/4] Fix a crash when block device is read and block size is changed at the same time
References: <Pine.LNX.4.64.1206272226050.22857@file.rdu.redhat.com>
	<20120628111541.GB17515@quack.suse.cz>
	<Pine.LNX.4.64.1207152051490.4240@file.rdu.redhat.com>
	<x49ipdmyz4q.fsf@segfault.boston.devel.redhat.com>
	<Pine.LNX.4.64.1207181512530.10923@file.rdu.redhat.com>
	<x49k3xzq3jc.fsf@segfault.boston.devel.redhat.com>
	<Pine.LNX.4.64.1207281236230.30415@file.rdu.redhat.com>
	<Pine.LNX.4.64.1207281240270.30415@file.rdu.redhat.com>
	<1343508252.2626.13184.camel@edumazet-glaptop>
	<Pine.LNX.4.64.1207290107460.29910@file.rdu.redhat.com>
	<1343556630.2626.13257.camel@edumazet-glaptop>
	<1343586962.2626.13266.camel@edumazet-glaptop>
	<Pine.LNX.4.64.1208011601280.21832@file.rdu.redhat.com>
	<Pine.LNX.4.64.1208311433480.2212@file.rdu.redhat.com>
	<Pine.LNX.4.64.1208311518340.16960@file.rdu.redhat.com>
	<x49liguyg6r.fsf@segfault.boston.devel.redhat.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Mon, 17 Sep 2012 17:19:44 -0400
In-Reply-To: <x49liguyg6r.fsf@segfault.boston.devel.redhat.com> (Jeff Moyer's
	message of "Fri, 31 Aug 2012 16:11:56 -0400")
Message-ID: <x49wqzswdn3.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=

Jeff Moyer <jmoyer@redhat.com> writes:
> Mikulas Patocka <mpatocka@redhat.com> writes:
>> I would be interested if other people did performance testing of the 
>> patches too.
>
> I'll do some testing next week, but don't expect to get to it before
> Wednesday.

Sorry for taking so long on this.  I managed to get access to an 80cpu
(160 threads) system with 1TB of memory.  I installed a pcie ssd into
this machine and did some testing against the raw block device.

I've attached the fio job file I used.  Basically, I tested sequential
reads, sequential writes, random reads, random writes, and then a mix of
sequential reads and writes, and a mix of random reads and writes.  All
tests used direct I/O to the block device, and each number shown is an
average of 5 runs.  I had to pin the fio processes to the same numa node
as the pcie adapter in order to get low run-to-run variations.  Because
of the numa factor, I was unable to get reliable results running
processes against all of the 160 threads on the system.  The runs below
have 4 processes, each pushing a queue depth of 1024.

So, on to the results.  I haven't fully investigated them yet, but I
plan to as they are rather surprising.

The first patch in the series simply adds a semaphore to the
block_device structure.  Mikulas, you had mentioned that this managed to
have a large effect on your test load.  In my case, this didn't seem to
make any difference at all:

      3.6.0-rc5+-job.fio-run2/output-avg
          	        READ                WRITE                 CPU          
  Job Name	     BW   IOPS  msec      BW   IOPS  msec   usr  sys   csw
    write1	      0      0     0  748522 187130 44864 16.34 60.65 3799440.00
     read1	 690615 172653 48602       0      0     0 13.45 61.42 4044720.00
randwrite1	      0      0     0  716406 179101 46839 29.03 52.79 3151140.00
 randread1	 683466 170866 49108       0      0     0 25.92 54.67 3081610.00
readwrite1	 377518  94379 44450  377645  94410 44450 15.49 64.32 3139240.00
   randrw1	 355815  88953 47178  355733  88933 47178 27.96 54.24 2944570.00
3.6.0-rc5.mikulas.1+-job.fio-run2/output-avg
          	        READ                WRITE                 CPU          
  Job Name	     BW   IOPS  msec      BW   IOPS  msec   usr  sys   csw
    write1	      0      0     0  764037 191009 43925 17.14 60.15 3536950.00
     read1	 696880 174220 48152       0      0     0 13.90 61.74 3710168.00
randwrite1	      0      0     0  737331 184332 45511 29.82 52.71 2869440.00
 randread1	 689319 172329 48684       0      0     0 26.38 54.58 2927411.00
readwrite1	 387651  96912 43294  387799  96949 43294 16.06 64.92 2814340.00
   randrw1	 360298  90074 46591  360304  90075 46591 28.53 54.10 2793120.00
                                   %diff
          	        READ                WRITE                 CPU          
  Job Name	     BW   IOPS  msec      BW   IOPS  msec   usr  sys   csw
    write1	      0      0     0       0      0     0 0.00 0.00  -6.91
     read1	      0      0     0       0      0     0 0.00 0.00  -8.27
randwrite1	      0      0     0       0      0     0 0.00 0.00  -8.94
 randread1	      0      0     0       0      0     0 0.00 0.00  -5.00
readwrite1	      0      0     0       0      0     0 0.00 0.00 -10.35
   randrw1	      0      0     0       0      0     0 0.00 0.00  -5.14


The headings are:
BW = bandwidth in KB/s
IOPS = I/Os per second
msec = number of miliseconds the run took (smaller is better)
usr = %user time
sys = %system time
csw = context switches

The first two tables show the results of each run.  In this case, the
first is the unpatched kernel, and the second is the one with the
block_device structure change.  The third table is the % difference
between the two.  A positive number indicates the second run had a
larger average than the first.  I found that the context switch rate was
rather unpredictable, so I really should have just left that out of the
reporting.

As you can see, adding a member to struct block_device did not really
change the results.


Next up is the patch that actually uses the rw semaphore to protect
access to the block size.  Here are the results:

3.6.0-rc5.mikulas.1+-job.fio-run2/output-avg
          	        READ                WRITE                 CPU          
  Job Name	     BW   IOPS  msec      BW   IOPS  msec   usr  sys   csw
    write1	      0      0     0  764037 191009 43925 17.14 60.15 3536950.00
     read1	 696880 174220 48152       0      0     0 13.90 61.74 3710168.00
randwrite1	      0      0     0  737331 184332 45511 29.82 52.71 2869440.00
 randread1	 689319 172329 48684       0      0     0 26.38 54.58 2927411.00
readwrite1	 387651  96912 43294  387799  96949 43294 16.06 64.92 2814340.00
   randrw1	 360298  90074 46591  360304  90075 46591 28.53 54.10 2793120.00
3.6.0-rc5.mikulas.2+-job.fio-run2/output-avg
          	        READ                WRITE                 CPU          
  Job Name	     BW   IOPS  msec      BW   IOPS  msec   usr  sys   csw
    write1	      0      0     0  816713 204178 41108 16.60 62.06 3159574.00
     read1	 749437 187359 44800       0      0     0 13.91 63.69 3190050.00
randwrite1	      0      0     0  747534 186883 44941 29.96 53.23 2617590.00
 randread1	 734627 183656 45699       0      0     0 27.02 56.27 2403191.00
readwrite1	 396113  99027 42397  396120  99029 42397 14.50 63.21 3460140.00
   randrw1	 374408  93601 44806  374556  93638 44806 28.46 54.33 2688985.00
                                   %diff
          	        READ                WRITE                 CPU          
  Job Name	     BW   IOPS  msec      BW   IOPS  msec   usr  sys   csw
    write1	      0      0     0       6      6    -6 0.00 0.00 -10.67
     read1	      7      7    -6       0      0     0 0.00 0.00 -14.02
randwrite1	      0      0     0       0      0     0 0.00 0.00  -8.78
 randread1	      6      6    -6       0      0     0 0.00 0.00 -17.91
readwrite1	      0      0     0       0      0     0 -9.71 0.00  22.95
   randrw1	      0      0     0       0      0     0 0.00 0.00   0.00

As you can see, there were modest gains in write, read, and randread.
This is somewhat unexpected, as you would think that introducing locking
would not *help* performance!  Investigating the standard deviations for
each set of 5 runs shows that the performance difference is significant
(the standard deviation is reported as a percentage of the average):

This is a table of standard deviations for the 5 runs comprising the
above average with this kernel: 3.6.0-rc5.mikulas.1+

          	        READ                WRITE                 CPU          
  Job Name	     BW   IOPS  msec      BW   IOPS  msec   usr  sys   csw
    write1	      0      0     0       1      1     1 2.99 1.27   9.10
     read1	      0      0     0       0      0     0 2.12 0.53   5.03
randwrite1	      0      0     0       0      0     0 1.25 0.49   5.52
 randread1	      1      1     1       0      0     0 1.81 1.18  10.04
readwrite1	      2      2     2       2      2     2 11.35 1.86  26.83
   randrw1	      2      2     2       2      2     2 4.01 2.71  22.72

And here are the standard deviations for the .2+ kernel:

          	        READ                WRITE                 CPU          
  Job Name	     BW   IOPS  msec      BW   IOPS  msec   usr  sys   csw
    write1	      0      0     0       2      2     2 3.33 2.95   7.88
     read1	      2      2     2       0      0     0 6.44 2.30  19.27
randwrite1	      0      0     0       3      3     3 0.18 0.52   1.71
 randread1	      2      2     2       0      0     0 3.72 2.34  23.70
readwrite1	      3      3     3       3      3     3 3.35 2.61   7.38
   randrw1	      1      1     1       1      1     1 1.80 1.00   9.73


Next, we'll move on to the third patch in the series, which converts the
rw semaphore to a per-cpu semaphore.

3.6.0-rc5.mikulas.2+-job.fio-run2/output-avg
          	        READ                WRITE                 CPU          
  Job Name	     BW   IOPS  msec      BW   IOPS  msec   usr  sys   csw
    write1	      0      0     0  816713 204178 41108 16.60 62.06 3159574.00
     read1	 749437 187359 44800       0      0     0 13.91 63.69 3190050.00
randwrite1	      0      0     0  747534 186883 44941 29.96 53.23 2617590.00
 randread1	 734627 183656 45699       0      0     0 27.02 56.27 2403191.00
readwrite1	 396113  99027 42397  396120  99029 42397 14.50 63.21 3460140.00
   randrw1	 374408  93601 44806  374556  93638 44806 28.46 54.33 2688985.00
3.6.0-rc5.mikulas.3+-job.fio-run2/output-avg
          	        READ                WRITE                 CPU          
  Job Name	     BW   IOPS  msec      BW   IOPS  msec   usr  sys   csw
    write1	      0      0     0  870892 217723 38528 17.83 41.57 1697870.00
     read1	1430164 357541 23462       0      0     0 14.41 56.00 241315.00
randwrite1	      0      0     0  759789 189947 44163 31.48 36.36 1256040.00
 randread1	1043830 260958 32146       0      0     0 31.89 44.39 185032.00
readwrite1	 692567 173141 24226  692489 173122 24226 18.65 53.64 311255.00
   randrw1	 501208 125302 33469  501446 125361 33469 35.40 41.61 246391.00
                                   %diff
          	        READ                WRITE                 CPU          
  Job Name	     BW   IOPS  msec      BW   IOPS  msec   usr  sys   csw
    write1	      0      0     0       6      6    -6 7.41 -33.02 -46.26
     read1	     90     90   -47       0      0     0 0.00 -12.07 -92.44
randwrite1	      0      0     0       0      0     0 5.07 -31.69 -52.02
 randread1	     42     42   -29       0      0     0 18.02 -21.11 -92.30
readwrite1	     74     74   -42      74     74   -42 28.62 -15.14 -91.00
   randrw1	     33     33   -25      33     33   -25 24.39 -23.41 -90.84

Wow!  Switching to the per-cpu semaphore implementation just boosted the
performance of the I/O path big-time.  Note that the system time also
goes down!  So, we get better throughput and less system time.  This
sounds too good to be true.  ;-)  Here are the standard deviations
(again, shown as percentages) for the .3+ kernel:

          	        READ                WRITE                 CPU          
  Job Name	     BW   IOPS  msec      BW   IOPS  msec   usr  sys   csw
    write1	      0      0     0       0      0     0 0.96 0.19   1.03
     read1	      0      0     0       0      0     0 1.82 0.24   2.46
randwrite1	      0      0     0       0      0     0 0.40 0.39   0.68
 randread1	      0      0     0       0      0     0 0.53 0.31   2.02
readwrite1	      0      0     0       0      0     0 2.73 4.07  33.27
   randrw1	      1      1     1       1      1     1 0.40 0.10   3.29

Again, there's no slop there, so the results are very reproducible.

Finally, the last patch changes to an rcu-based rw semaphore
implementation.  Here are the results for that, as compared with the
previous kernel:

3.6.0-rc5.mikulas.3+-job.fio-run2/output-avg
          	        READ                WRITE                 CPU          
  Job Name	     BW   IOPS  msec      BW   IOPS  msec   usr  sys   csw
    write1	      0      0     0  870892 217723 38528 17.83 41.57 1697870.00
     read1	1430164 357541 23462       0      0     0 14.41 56.00 241315.00
randwrite1	      0      0     0  759789 189947 44163 31.48 36.36 1256040.00
 randread1	1043830 260958 32146       0      0     0 31.89 44.39 185032.00
readwrite1	 692567 173141 24226  692489 173122 24226 18.65 53.64 311255.00
   randrw1	 501208 125302 33469  501446 125361 33469 35.40 41.61 246391.00
3.6.0-rc5.mikulas.4+-job.fio-run2/output-avg
          	        READ                WRITE                 CPU          
  Job Name	     BW   IOPS  msec      BW   IOPS  msec   usr  sys   csw
    write1	      0      0     0  812659 203164 41309 16.80 61.71 3208620.00
     read1	 739061 184765 45442       0      0     0 14.32 62.85 3375484.00
randwrite1	      0      0     0  726971 181742 46192 30.00 52.33 2736270.00
 randread1	 719040 179760 46683       0      0     0 26.47 54.78 2914080.00
readwrite1	 396670  99167 42309  396619  99154 42309 14.91 63.12 3412220.00
   randrw1	 374790  93697 44766  374807  93701 44766 28.42 54.10 2774690.00
                                   %diff
          	        READ                WRITE                 CPU          
  Job Name	     BW   IOPS  msec      BW   IOPS  msec   usr  sys   csw
    write1	      0      0     0      -6     -6     7 -5.78 48.45  88.98
     read1	    -48    -48    93       0      0     0 0.00 12.23 1298.79
randwrite1	      0      0     0       0      0     0 0.00 43.92 117.85
 randread1	    -31    -31    45       0      0     0 -17.00 23.41 1474.91
readwrite1	    -42    -42    74     -42    -42    74 -20.05 17.67 996.28
   randrw1	    -25    -25    33     -25    -25    33 -19.72 30.02
   1026.13

And we've lost a good bit of performance!  Talk about
counter-intuitive.  Here are the standard deviation numbers:

          	        READ                WRITE                 CPU          
  Job Name	     BW   IOPS  msec      BW   IOPS  msec   usr  sys   csw
    write1	      0      0     0       2      2     2 2.96 3.00   6.79
     read1	      3      3     3       0      0     0 6.52 2.82  21.86
randwrite1	      0      0     0       2      2     2 0.71 0.55   4.07
 randread1	      1      1     1       0      0     0 4.13 2.31  20.12
readwrite1	      1      1     1       1      1     1 4.14 2.64   6.12
   randrw1	      0      0     0       0      0     0 0.59 0.25   2.99


Here is a comparison of the vanilla kernel versus the best performing
patch in this series (patch 3 of 4):

      3.6.0-rc5+-job.fio-run2/output-avg
          	        READ                WRITE                 CPU          
  Job Name	     BW   IOPS  msec      BW   IOPS  msec   usr  sys   csw
    write1	      0      0     0  748522 187130 44864 16.34 60.65 3799440.00
     read1	 690615 172653 48602       0      0     0 13.45 61.42 4044720.00
randwrite1	      0      0     0  716406 179101 46839 29.03 52.79 3151140.00
 randread1	 683466 170866 49108       0      0     0 25.92 54.67 3081610.00
readwrite1	 377518  94379 44450  377645  94410 44450 15.49 64.32 3139240.00
   randrw1	 355815  88953 47178  355733  88933 47178 27.96 54.24 2944570.00
3.6.0-rc5.mikulas.3+-job.fio-run2/output-avg
          	        READ                WRITE                 CPU          
  Job Name	     BW   IOPS  msec      BW   IOPS  msec   usr  sys   csw
    write1	      0      0     0  870892 217723 38528 17.83 41.57 1697870.00
     read1	1430164 357541 23462       0      0     0 14.41 56.00 241315.00
randwrite1	      0      0     0  759789 189947 44163 31.48 36.36 1256040.00
 randread1	1043830 260958 32146       0      0     0 31.89 44.39 185032.00
readwrite1	 692567 173141 24226  692489 173122 24226 18.65 53.64 311255.00
   randrw1	 501208 125302 33469  501446 125361 33469 35.40 41.61 246391.00
                                   %diff
          	        READ                WRITE                 CPU          
  Job Name	     BW   IOPS  msec      BW   IOPS  msec   usr  sys   csw
    write1	      0      0     0      16     16   -14 9.12 -31.46 -55.31
     read1	    107    107   -51       0      0     0 7.14 -8.82 -94.03
randwrite1	      0      0     0       6      6    -5 8.44 -31.12 -60.14
 randread1	     52     52   -34       0      0     0 23.03 -18.80 -94.00
readwrite1	     83     83   -45      83     83   -45 20.40 -16.60 -90.09
   randrw1	     40     40   -29      40     40   -29 26.61 -23.29 -91.63


Next up, I'm going to get some perf and blktrace data from these runs to
see if I can identify why there is such a drastic change in
performance.  I will also attempt to run the tests against a different
vendor's adapter, and maybe against some FC storage if I can set that up.

Cheers,
Jeff


--=-=-=
Content-Disposition: inline; filename=job.fio

[global]
ioengine=libaio
direct=1
iodepth=1024
iodepth_batch=32
iodepth_batch_complete=1
blocksize=4k
filename=/dev/XXX
size=8g
group_reporting=1
readwrite=write

[write1]
offset=0

[write2]
offset=8g

[write3]
offset=16g

[write4]
offset=24g

[global]
readwrite=read

[read1]
stonewall
offset=0

[read2]
offset=8g

[read3]
offset=16g

[read4]
offset=24g

[global]
readwrite=randwrite

[randwrite1]
stonewall
offset=0

[randwrite2]
offset=8g

[randwrite3]
offset=16g

[randwrite4]
offset=24g

[global]
readwrite=randread

[randread1]
stonewall
offset=0

[randread2]
offset=8g

[randread3]
offset=16g

[randread4]
offset=24g

[global]
readwrite=readwrite

[readwrite1]
stonewall
offset=0

[readwrite2]
offset=8g

[readwrite3]
offset=16g

[readwrite4]
offset=24g

[global]
readwrite=randrw

[randrw1]
stonewall
offset=0

[randrw2]
offset=8g

[randrw3]
offset=16g

[randrw4]
offset=24g

--=-=-=--
