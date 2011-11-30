Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753691Ab1K3Mkk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Nov 2011 07:40:40 -0500
Received: from rrzmta2.uni-regensburg.de ([194.94.155.52]:49459 "EHLO
	rrzmta2.uni-regensburg.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751118Ab1K3Mkj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Nov 2011 07:40:39 -0500
X-Greylist: delayed 435 seconds by postgrey-1.27 at vger.kernel.org; Wed, 30 Nov 2011 07:40:39 EST
Message-Id: <4ED6309E020000A100008348@gwsmtp1.uni-regensburg.de>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 Beta 
Date: Wed, 30 Nov 2011 13:33:18 +0100
From: "Ulrich Windl" <Ulrich.Windl@rz.uni-regensburg.de>
To: <linux-kernel@vger.kernel.org>
Subject: Q: ext3 barrier=1
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

I have a question on "barrier=1" (and SLES11 SP1):

Background: We had a serious latency problem while heavy writes were happening, specifically some LVM commands that use direct I/O were about 1000 times slower than usual. The ext3 filesystem to write on had "barrier=1" enabled. Writes were sent to a storage system that uses a battery-backed write-back cache.

In my understanding the barrier partially prevents reordering of a devices I/O requests, mostly to support journaled filesystems that rely on write-ordering.

However as it seems, "barrier=1" also does flush (maybe invalidate also?) the write cache of the storage device. In our case that does not make sense, and mostly (as the storage system is used by many clients) it reduces the throughput (at least writes) of the storage system significantly.

Now my question is: Shouldn't the barriers per filesystem be treated independently of cache flushes of the storage (systems)?

Also: If several filesystems that are using the same device (e.g. disk partitions) are written to simultaneously, won't the barriers (that are issued for the whole device) restrict reordering too much?

I mean (FS is filesystem, w is write, | is barrier):

FS1: wwwwwww|wwwwww|wwwwwwww|wwwwwww
FS2: wwww|wwwwww|wwwwww|wwwwwww|wwwwww
FS3: wwwwww|wwwwww|wwwwww|wwwwwww|wwww
would have the following ordering restrictions:
     ....|.|......||...|.|..|..|.|....

That is, the barriers also prevent reordering of unrelated data streams.

flushing/invalidating the write-back cache of a device will only make sense if the device has a write-back cache that doesn't have a battery-backed memory.

So I feel that filesystem barriers make sense even with battery-backed external disk caches (as the issuing host may go down), but cache flushes/invalidations on the disk system don't (because neither a reboot/crash of the issuing host, nor a power failure on the storage system will make a difference regarding the data streams).

Also the scope of the barriers for filesystems is quite different to the scope of device caches: Many systems, devices, and partitions may use one single cache, so flushing that cache may affect otherwise unrelated data streams.

Any comments on those ideas/question?

As I'm not subscribed to the kernel mailing list, plese be so kind to CC: any replies.

Thank you!

Regards,
Ulrich


