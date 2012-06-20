Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758452Ab2FTXLy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 19:11:54 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:44975 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757372Ab2FTXLx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 19:11:53 -0400
Message-ID: <4FE258D1.9040304@gmail.com>
Date: Wed, 20 Jun 2012 19:12:17 -0400
From: John Moser <john.r.moser@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: tmem and swap pagecache
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dragonfly BSD has a feature by which--if you put a swap partition on an 
SSD--it will allow you to configure the swapping area to also accept 
page cache data.  In this way, page cache from spinning hard disks can 
be swapped into SSD for acceleration using the swap device.

It seems to me that creating a tmem[1] module that supplies page cache 
swap or supplies a swap area with page cache logic (i.e. a swap area 
that acts as a combined area, using its entire size as page cache but 
evicting page cache for swap when full) would be a good use of tmem.

It isn't apparent to me that tmem has any way of knowing where a page 
comes from, however.  Specifically, as far as I can tell (I may be 
wrong), you can't hint to tmem that a page is from page cache (you can 
tell it it's persistent or transient--probably swap or cache, but not 
necessarily), much less that it's page cache backed by a spinning disk 
versus an SSD or USB drive.

To my senses, it would be useful to be able to have a database server or 
mass file server with 4GB or 8GB of RAM and a 128GB SSD ($150, cheaper 
than 128GB of RAM...) that can back extended page cache.  Effectively 
you get an L2 page cache, with maybe 2-3GB of L1 page cache in system 
RAM and 108GB of L2 page cache on an SSD, with 20GB in use for the / 
file system (which you want to specifically NOT page cache into SSD).

[Tangent]

It may alternately be a generally good idea to check the backing device 
of page cache in general and favor evicting SSD-backed page cache over 
slow page cache, although now we're getting too specific and we want to 
generically call these devices "fast" or "slow" and more specifically 
"faster than X" and "Slower than Y" if we're discussing that.

Essentially I mean:  what about spinning hard disks on SATA2 vs SATA3 vs 
USB vs eSata?  eSATA is way faster than USB, SATA3 is faster than SATA2 
unless your disk is slower than the SATA2 disk and the SATA2 disk is 
slower than SATA2.  Obviously you want to evict the cache for a 7200RPM 
SATA3 hard disk with 64MB cache more readily than a spinning USB 1.0 
hard disk, if they're both used roughly as recently--the SATA3 drive is 
10% more likely to be used first than the USB drive but the USB drive 
has 500% of the access speed, overall you're likely to come out faster 
favoring the USB drive's page cache.  As you evict more of the SATA3 
drive's cache, what's left has been used far more recently than anything 
on the USB drive, so it starts making more sense to evict the old USB 
drive's data.

[/Tangent]

But even if you favor SSD eviction over hard drive eviction (by any 
metric), you'll eventually come to a point where you only have so much 
page cache and having the ability to swap page cache to a huge SSD 
becomes more attractive.  It becomes an extremely large read cache.  The 
Seagate Momentus XT fares pretty well with an 8GB read cache for this 
(although on their specialized, tightly integrated hardware, they've 
managed to use write-back caching to gain a LOT of write performance, 
too); it would make sense that using an SSD as a big page cache would 
supply similar gains in specialized environments for cheaper than the 
cost of RAM.

Of course that just takes us back to the original question:  Can we hint 
to tmem where the data is coming from, and let it decide if it cares and 
how to handle it?

[1] http://lwn.net/Articles/340409/
