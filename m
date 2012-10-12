Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751099Ab2JLThp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2012 15:37:45 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:44156 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750769Ab2JLTho (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2012 15:37:44 -0400
Message-ID: <1350070656.2554.6.camel@vpcz1>
Subject: PROBLEM: [dm-crypt] read starvation during writeback
From: Michael Zugelder <michael@zugelder.org>
To: linux-kernel@vger.kernel.org
Cc: dm-devel@redhat.com
Date: Fri, 12 Oct 2012 21:37:36 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

this mail was originally only sent to the dm-crypt mailing list
(dm-crypt@saout.de), but since it didn't exactly attract a lot of
feedback, I'm resending it to reach a larger target audience.

Please keep me in CC, since I'm not subscribed to the LKML.

I'm having an issue reading data via dm-crypt when there is heavy
writeback going on (i.e. copying large files or using dd). A single
read takes anywhere from a few seconds to multiple minutes.

Testing setup:
 * Fedora 17, stock 3.5.4-2.fc17 kernel and a self-compiled 3.6.1 kernel
 * 320 GiB USB hard drive (sdb)
 * dmsetup library version 1.02.74 (2012-03-06), driver version 4.23.0
 * dm-crypt set up using cipher_null:
   echo "0 $(blockdev --getsize /dev/sdb) crypt cipher_null - 0 /dev/sdb 0"|dmsetup create test
 * seeker [1] to benchmark random read performance
 * writeback induced by running 'dd if=/dev/zero of=$target bs=1M'

Raw device performance (idle):
  55 seeks/second, 18.15 ms random access time

dm-crypt performance (idle):
  54 seeks/second, 18.33 ms random access time

Raw device performance (during writeback):
  49 seeks/second, 20.35 ms random access time

dm-crypt performance (during writeback):
  0 seeks/second, 3750.00 ms random access time
  0 seeks/second, 30000.00 ms random access time
  0 seeks/second, 30000.00 ms random access time
  3 seeks/second, 297.03 ms random access time
  47 seeks/second, 21.14 ms random access time
  15 seeks/second, 64.24 ms random access time
  0 seeks/second, 10000.00 ms random access time

Sometimes it almost works, but most of the time, the device is
completely unusable.

I experimented a bit with the other device mapper targets, namely linear
and stripe, but both worked completely fine. I also tried putting a
linear mapping above dm-crypt, with no impact on performance. Comparing
the content of the /sys/block/$DEV files of the linear mapping and
dm-crypt, there are no differences beside the name, dev no, stats,
uevent and inflight files.

But the inflight counters seem to provide some interesting data. When
writing to the raw device, there are 127--131 writes in flight and a
single read (seeker seems to use a queue depth of 1). But in the
dm-crypt case, there are about 160000--250000 writes in flight for the
mapping device, with 127--300 on the raw device. There is also a single
read but only at the dm-crypt device, the raw device stays at
0 reads the whole time. The linear mapping, in contrast, has "only" 
~3500--9000 writes in flight, and the reads actually reach the raw
device.

Any pointers would be appreciated, I haven't found much on the web about
this issue.

Keep up the good work.


Michael

[1] http://www.linuxinsight.com/files/seeker.c

