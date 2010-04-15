Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754890Ab0DOFnx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Apr 2010 01:43:53 -0400
Received: from smtp-out.google.com ([216.239.44.51]:33646 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754419Ab0DOFnw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Apr 2010 01:43:52 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:subject:to:cc:date:message-id:user-agent:
	mime-version:content-type:content-transfer-encoding:x-system-of-record;
	b=T8VWm0hADpl3/TkFowzBY/U+T3Nw9KeEBmIl71p/zLuuFEy33mIwGEDYrt9JGLV8O
	VIdueOS5QSVuEk/9TmjOg==
From: Divyesh Shah <dpshah@google.com>
Subject: [PATCH 0/4] block: Per-partition block IO performance histograms
To: jens.axboe@oracle.com
Cc: linux-kernel@vger.kernel.org, nauman@google.com, rickyb@google.com
Date: Wed, 14 Apr 2010 22:43:43 -0700
Message-ID: <20100415054057.15836.17897.stgit@austin.mtv.corp.google.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following patchset implements per partition 2-d histograms for IO to block
devices. The 3 types of histograms added are:

1) request histograms - 2-d histogram of total request time in ms (queueing +
   service) broken down by IO size (in bytes).
2) dma histograms - 2-d histogram of total service time in ms broken down by
   IO size (in bytes).
3) seek histograms - 1-d histogram of seek distance

All of these histograms are per-partition. The first 2 are further divided into
separate read and write histograms. The buckets for these histograms are
configurable via config options as well as at runtime (per-device).

These histograms have proven very valuable to us over the years to understand
the seek distribution of IOs over our production machines, detect large
queueing delays, find latency outliers, etc. by being used as part of an
always-on monitoring system.

They can be reset by writing any value to them which makes them useful for
tests and debugging too.

This was initially written by Edward Falk in 2006 and I've forward ported
and improved it a few times it across kernel versions.

He had also sent a very old version of this patchset (minus some features like
runtime configurable buckets) back then to lkml - see
http://lkml.indiana.edu/hypermail/linux/kernel/0611.1/2684.html
Some of the reasons mentioned for not including these patches are given below.

I'm requesting re-consideration for this patchset in light of the following
arguments.

1) This can be done with blktrace too, why add another API?

Yes blktrace can be used to get this kind of information w/ some help from
userspace post-processing. However, to use this as an always-on monitoring tool
w/ blktrace and have negligible performance overhead is difficult to achieve.
I did a quick 10-thread iozone direct IO write phase run w/ and w/o blktrace
on a traditional rotational disk to get a feel of the impact on throughput.
This was kernel built from Jens' for-2.6.35 branch and did not have these new
block histogram patches.
  o w/o blktrace:
        Children see throughput for 10 initial writers  =   95211.22 KB/sec
        Parent sees throughput for 10 initial writers   =   37593.20 KB/sec
        Min throughput per thread                       =    9078.65 KB/sec
        Max throughput per thread                       =   10055.59 KB/sec
        Avg throughput per thread                       =    9521.12 KB/sec
        Min xfer                                        =  462848.00 KB

  o w/ blktrace:
        Children see throughput for 10 initial writers  =   93527.98 KB/sec
        Parent sees throughput for 10 initial writers   =   38594.47 KB/sec
        Min throughput per thread                       =    9197.06 KB/sec
        Max throughput per thread                       =    9640.09 KB/sec
        Avg throughput per thread                       =    9352.80 KB/sec
        Min xfer                                        =  490496.00 KB

This is about 1.8% average throughput loss per thread.
The extra cpu time spent with blktrace is in addition to this loss of
throughput. This overhead will only go up on faster SSDs.

2) sysfs should be only for one value per file. There are some exceptions but we
   are working on fixing them. Please don't add new ones.

There are excpetions like meminfo, etc. that violate this guideline (I'm not
sure if its an enforced rule) and some actually make sense since there is no way
of representing structured data. Though these block histograms are multi-valued
one can also interpret them as one logical piece of information.

IMO these histograms add value and given there seems to be no better way of
exporting this information w/o performance overhead, it might be ok to allow
this exception.

I might be wrong here and there are indeed better ways of exporting this data.
Any comments/suggestions for different representations for achieveing the same
goal are more than welcome.
---

Divyesh Shah (4):
      Make base bucket for the histograms to be configurable per-part.
      Add seek histograms to the block histograms
      Add disk performance histograms which can be read from sysfs and cleared
      Re-introduce rq->__nr_sectors to maintain the original size of the request


 block/Kconfig          |   35 ++++
 block/blk-core.c       |    5 +
 block/blk-merge.c      |    1 
 block/genhd.c          |  410 ++++++++++++++++++++++++++++++++++++++++++++++++
 fs/partitions/check.c  |   29 +++
 include/linux/blkdev.h |   11 +
 include/linux/genhd.h  |   73 +++++++++
 include/linux/time.h   |    5 +
 8 files changed, 567 insertions(+), 2 deletions(-)

--
Thanks,
Divyesh
