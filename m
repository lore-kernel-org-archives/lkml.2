Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754261Ab2ISNuq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 09:50:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55567 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752211Ab2ISNup (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 09:50:45 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: jens.axboe@fusionio.com
Cc: Mikulas Patocka <mpatocka@redhat.com>, LKML <linux-kernel@vger.kernel.org>
Subject: [patch] block: make struct block_device cacheline_aligned
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Wed, 19 Sep 2012 09:50:40 -0400
Message-ID: <x49lig686kv.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

When testing against a pcie ssd or a ramdisk, making the block device
structure cacheline_aligned provided a significant increase in
performance:

                                    vanilla
          	        READ                WRITE                 CPU          
  Job Name	     BW   IOPS  msec      BW   IOPS  msec   usr  sys   csw
    write1	      0      0     0  748522 187130 44864 16.34 60.65 3799440.00
     read1	 690615 172653 48602       0      0     0 13.45 61.42 4044720.00
randwrite1	      0      0     0  716406 179101 46839 29.03 52.79 3151140.00
 randread1	 683466 170866 49108       0      0     0 25.92 54.67 3081610.00
readwrite1	 377518  94379 44450  377645  94410 44450 15.49 64.32 3139240.00
   randrw1	 355815  88953 47178  355733  88933 47178 27.96 54.24 2944570.00

                                   patched
          	        READ                WRITE                 CPU          
  Job Name	     BW   IOPS  msec      BW   IOPS  msec   usr  sys   csw
    write1	      0      0     0  871355 217838 38508 17.49 42.46 1642870.00
     read1	1418560 354639 23675       0      0     0 14.96 54.75 337489.00
randwrite1	      0      0     0  736970 184242 45633 30.62 35.25 1409440.00
 randread1	1065440 266359 31544       0      0     0 32.67 43.74 255394.00
readwrite1	 657940 164484 25867  657848 164461 25867 18.54 50.55 619474.00
   randrw1	 491940 122985 34245  492014 123003 34245 34.44 41.05 418999.00

                                   %diff
          	        READ                WRITE                 CPU          
  Job Name	     BW   IOPS  msec      BW   IOPS  msec   usr  sys   csw
    write1	      0      0     0      16     16   -14 7.04 -29.99 -56.76
     read1	    105    105   -51       0      0     0 11.23 -10.86 -91.66
randwrite1	      0      0     0       0      0     0 5.48 -33.23 -55.27
 randread1	     55     55   -35       0      0     0 26.04 -19.99 -91.71
readwrite1	     74     74   -41      74     74   -41 19.69 -21.41 -80.27
   randrw1	     38     38   -27      38     38   -27 23.18 -24.32 -85.77

BW=bandwidth in KB/s
IOPS = I/Os per second
msec = # of miliseconds the run took (lower is better)
usr = % user time
sys = % system time
csw = # of context switches

The test is doing asynchronous direct I/O to the block device using 4
processes each driving a queue depth of 1024 to a different part of the
disk.  The rows, in order, are sequential write, sequential read,
random write, random read, 50% mix of sequential reads and sequential
writes, 50% mix of random reads and random writes.  The block size in
all cases is 4k.

I'd appreciate it if others could verify an increase in performance with
this patch.  Thanks to Mikulas for initially suggesting that the cache
size/alignment was relevant to performance.

Cheers,
Jeff

Signed-off-by: Jeff Moyer <jmoyer@redhat.com>

diff --git a/include/linux/fs.h b/include/linux/fs.h
index aa11047..87ce6ca 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -724,7 +724,7 @@ struct block_device {
 	int			bd_fsfreeze_count;
 	/* Mutex for freeze */
 	struct mutex		bd_fsfreeze_mutex;
-};
+} __cacheline_aligned;
 
 /*
  * Radix-tree tags, for tagging dirty and writeback pages within the pagecache
