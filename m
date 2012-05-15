Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965940Ab2EORL1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 13:11:27 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:47834 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965109Ab2EORLZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 13:11:25 -0400
From: Richard Weinberger <richard@nod.at>
To: linux-mtd@lists.infradead.org
Cc: tglx@linutronix.de, dedekind1@gmail.com, linux-kernel@vger.kernel.org,
        Heinz.Egger@linutronix.de, tim.bird@am.sony.com
Subject: [RFC v4] UBI: Fastmap support (aka checkpointing)
Date: Tue, 15 May 2012 19:11:04 +0200
Message-Id: <1337101871-31181-1-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.7.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

v1: https://lwn.net/Articles/481612/
v2: https://lwn.net/Articles/496586/
v3: Didn't release it to linux-mtd

Changes since v1:
        - renamed it to UBIVIS (at least in Kconfig)
        - UBIVIS parameters are now configurable via Kconfig
        - several bugs have been fixed (design and implementation bugs)
        - added lots of comments to make the review process easier
        - made checkpatch.pl happy

Changes since v2:
        - minor bugs have been fixed
        - renamed it to UBI fastmap (as Artem requested)

Changes since v3:
        - changed the on-flash layout (added padding fields, turned the
          EBA storage into an array)
        - fixed some corner cases (the protection queue needed some extra work)
	- removed the data type hint logic
	- rebased to Artems mtd tree

[PATCH 1/7] [RFC] UBI: Export next_sqnum()
[PATCH 2/7] [RFC] UBI: Export compare_lebs()
[PATCH 3/7] [RFC] UBI: Add fastmap on-flash layout
[PATCH 4/7] [RFC] UBI: Add fastmap structs to ubi_device
[PATCH 5/7] [RFC] UBI: Make wl subsystem fastmap aware
[PATCH 6/7] [RFC] UBI: Implement fastmapping support
[PATCH 7/7] [RFC] UBI: Wire up fastmap support

git://git.kernel.org/pub/scm/linux/kernel/git/rw/ubi2.git ubi2/v4

Some benchmark numbers:

4GiB NAND
Erase block size: 1MiB
Page size: 4096
Total PEBs: 4081*

Attach method   Time**          #scanned PEBs
---------------------------------------------
scanning        0m4.568s        4081
fastmap         0m0.486s        3


2GiB NAND
Erase block size: 1MiB
Page size: 4096
Total PEBs: 2062*

Attach method   Time            #scanned PEBs
---------------------------------------------
scanning        0m2.440s        2062
fastmap         0m0.439s        3


1GiB NAND
Erase block size: 1MiB
Page size: 4096
Total PEBs: 1038*

Attach method   Time            #scanned PEBs
---------------------------------------------
scanning        0m1.351s        1038
fastmap         0m0.422s        4


We observe that attaching by scanning depends on the total size N of the UBI
device.It has a complexity of O(N).
Whereas attaching by fastmap has a nearly constant attaching time.
In the best case fastmap has to scan only one PEB.
This case can happen if the complete fastmap fits into one PEB, the fastmap
super block is the first PEB on the MTD partition and the fastmap pool is empty.
On the other side, in the worst case fastmap has to scan UBI_FM_MAX_START +
UBI_FM_MAX_BLOCKS + UBI_FM_MAX_POOL_SIZE PEBs.
With the current default settings this would be 192 PEBs.
So, attaching via fastmap has a complexity of O(1).
I think we can reduce UBI_FM_MAX_BLOCKS and UBI_FM_MAX_POOL_SIZE to a much
smaller value. On most real NAND chips the whole fastmap fits into one PEB.

TODO:
        - Artem is fully happy with the current on-flash layout,
          maybe I can merge the erase counters into the EBA table
        - Get a full review :)

Thanks,
//richard

*) Didn't use the full NAND for UBI because Kernel, U-Boot, DT needed also
some space.

**) Time was taken by: "time ubiattach -m 5"
