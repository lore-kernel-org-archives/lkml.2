Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755573Ab1BWEgm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 23:36:42 -0500
Received: from ishtar.tlinx.org ([173.164.175.65]:33113 "EHLO
	Ishtar.sc.tlinx.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754630Ab1BWEgk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 23:36:40 -0500
X-Greylist: delayed 303 seconds by postgrey-1.27 at vger.kernel.org; Tue, 22 Feb 2011 23:36:32 EST
Message-ID: <4D648D7D.7040500@tlinx.org>
Date: Tue, 22 Feb 2011 20:30:53 -0800
From: Linda Walsh <lkml@tlinx.org>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.0; en-US; rv:1.8.1.24) Thunderbird/2.0.0.24 Mnenhy/0.7.6.666
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
Subject: write 'O_DIRECT' file w/odd amount of data: desirable result?
X-Stationery: 0.4.10
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org




I understand, somewhat, what is happening.
I have two different utils, 'dd' and mbuffer both of
which have a 'direct' option to write to disk.
mbuffer was from my distro with a direct added, which
is

I'm not sure if it's truncating the write to the
lower bound of the sector size or the file-allocation-unit size
but from a dump, piped into {cat, dd mbuffer}, the
output sizes are:

file              size       delta
-------------   ----------   ----
dumptest.cat    5776419696
dumptest.dd     5776343040   76656   
dumptest.mbuff  5368709120   407710576

params:

dd of=dumptest.dd bs=512M oflag=direct
mbuffer -b 5 -s 512m --direct -f -o dumptest.mbuff

original file size MOD 512M = 407710576 (answer from mbuff).

The disk it is being written to is a RAID with a span
size of 640k (64k io*10 data disks) and formatted to
indicated that with 'xfs' (stripe-unit=64k stripe=width=10).

This gives a 'coincidental' (??) interpretation for
the output from 'dd', where the original file size MOD
640K = 76656  (the amount 'dd' is short).

Was that a coincidence or a fluke?
Why didn't 'mbuffer' have the same shortfall -- it's was
only related to it's 512m buffer size.

In any event, shouldn't the kernel yield the correct answer
in either case?  It would be consistent with the processor it
was natively developed on, the x86, where a misaligned memory
access doesn't cause a fault at the user level, but is handled
correctly, with a slight penalty to speed for the unaligned
data parts.

Shouldn't the linux kernel behave similarly? 

Note, that the mbuffer program indicated an error
(which didn't help the 'dump' program that had already exited
with what it thought was a 'success'), though a bit
cryptic:
buffer: error: outputThread: error writing to dumptest.mbuff at offset 
0x140000000: Invalid argument

summary: 5509 MByte in  8.4 sec - average of  658 MB/s
mbuffer: warning: error during output to dumptest.mbuff: Invalid argument

dd indicated no warning or error.

----
I'm not aware of what either did, but no doubt neither
expected an error in the final write and didn't handle the results properly.

However, wouldn't it be a good thing for linux to do 'the right thing' 
and successfully the last partial write (whichever is the case!), even 
if it has to be internally buffered and slightly slowed?  Seems 
correctness of the function should be given preference over the 
adherence to some limitation where possible.
Software should be as forgiving and tolerant and 'err' to the side of 
least harm -- which I'd argue is getting the data to the disk, NOT 
generating some 'abnormal end' (ABEND) condition that the software can't 
handle. 

I'd think of it like a page-fault of a record not in memory.  The 
remainder of the I/O record is a 'zero-filled' buffer that fills in the 
remainder of the sector while the size of the field is set to the size 
written. ??

Vanilla kernel 2.6.35-7 x86_64 (SMP PREMPT)








