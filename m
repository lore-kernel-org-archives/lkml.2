Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756299Ab0JETBb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 15:01:31 -0400
Received: from smtp104.prem.mail.ac4.yahoo.com ([76.13.13.43]:28633 "HELO
	smtp104.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753890Ab0JES6Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 14:58:16 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: HGF37BAVM1lvmvw8AE7JtvOmmbbnlAXCTlhqjIvyMTRKq4W
 6p96PYkdR_2antkl9XZG09bfNBuNhXRsiT98wZD0MUYTPe9XWiIsjMUcqY0C
 B74KAaeZchImkZW3N4ojpzA9lA_blT_FS305s4UZRZmf6082Xx1byxeO9fkF
 ylbTPYC1232Isa4GqkMMfYRbkQxnpynzEFcENtHFT19hZIdBo5GJ4Wvzsf_E
 OQ2e3z09Cr5.z53Lqe3QnJg2gsH.z
X-Yahoo-Newman-Property: ymail-3
Message-Id: <20101005185725.088808842@linux.com>
User-Agent: quilt/0.48-1
Date: Tue, 05 Oct 2010 13:57:25 -0500
From: Christoph Lameter <cl@linux.com>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org
Cc: David Rientjes <rientjes@google.com>
Subject: [UnifiedV4 00/16] The Unified slab allocator (V4)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

V3->V4:
- Lots of debugging
- Performance optimizations (more would be good)...
- Drop per slab locking in favor of per node locking for
  partial lists (queuing implies freeing large amounts of objects
  to per node lists of slab).
- Implement object expiration via reclaim VM logic.

The following is a release of an allocator based on SLAB
and SLUB that integrates the best approaches from both allocators. The
per cpu queuing is like in SLAB whereas much of the infrastructure
comes from SLUB.

After this patches SLUB will track the cpu cache contents
like SLAB attemped to. There are a number of architectural differences:

1. SLUB accurately tracks cpu caches instead of assuming that there
   is only a single cpu cache per node or system.

2. SLUB object expiration is tied into the page reclaim logic. There
   is no periodic cache expiration.

3. SLUB caches are dynamically configurable via the sysfs filesystem.

4. There is no per slab page metadata structure to maintain (aside
   from the object bitmap that usually fits into the page struct).

5. Has all the resiliency and diagnostic features of SLUB.

The unified allocator is a merging of SLUB with some queuing concepts from
SLAB and a new way of managing objects in the slabs using bitmaps. Memory
wise this is slightly more inefficient than SLUB (due to the need to place
large bitmaps --sized a few words--in some slab pages if there are more
than BITS_PER_LONG objects in a slab) but in general does not increase space
use too much.

The SLAB scheme of not touching the object during management is adopted.
The unified allocator can efficiently free and allocate cache cold objects
without causing cache misses.

Some numbers using tcp_rr on localhost


Dell R910 128G RAM, 64 processors, 4 NUMA nodes

threads	unified		slub		slab
64	4141798		3729037		3884939
128	4146587		3890993		4105276
192	4003063		3876570		4110971
256	3928857		3942806		4099249
320	3922623		3969042		4093283
384	3827603		4002833		4108420
448	4140345		4027251		4118534
512	4163741		4050130		4122644
576	4175666		4099934		4149355
640	4190332		4142570		4175618
704	4198779		4173177		4193657
768	4662216		4200462		4222686


