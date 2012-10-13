Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753910Ab2JMQv2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Oct 2012 12:51:28 -0400
Received: from rsk.demon.co.uk ([80.176.90.227]:13416 "EHLO castor.rsk"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753834Ab2JMQv0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Oct 2012 12:51:26 -0400
X-Greylist: delayed 997 seconds by postgrey-1.27 at vger.kernel.org; Sat, 13 Oct 2012 12:51:26 EDT
From: Richard Kennedy <richard@rsk.demon.co.uk>
To: Christoph Lameter <cl@linux-foundation.org>,
        Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Richard Kennedy <richard@rsk.demon.co.uk>
Subject: [PATCH 0/2] RFC SLUB: increase range of kmalloc slab sizes
Date: Sat, 13 Oct 2012 17:31:23 +0100
Message-Id: <1350145885-6099-1-git-send-email-richard@rsk.demon.co.uk>
X-Mailer: git-send-email 1.7.11.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch increases the range of slab sizes available to kmalloc, adding
slabs half way between the existing power of two sized ones, so allowing slightly
 more efficient use of memory.
Most of the new slabs already exist as kmem_cache slabs so only the 1.5k,3k & 6k 
are entirely new.
The code in get_slab_index() is simple, optimizes well and only adds a few
instructions to the code path of dynamically sized kmallocs.
It also simplifies the slab initialisation code as it removes the special case of the 2 
odd sized slabs of 96 & 192 and the need for the slab_index array.

I have been running this on an x86_64 desktop machine for a few weeks without any problems,
and have not measured any significant performance difference, nothing about the noise anyway.

The new slabs (1.5k,3k,6k) get used by several hundred objects on desktop workloads so this 
patch has a small but useful impact on memory usage.
As the other new slabs are aliased to existing slabs it's difficult to measure any differences.

The code should correctly support KMALLOC_MIN_SIZE and therefore work on architectures other
than x86_64, but I don't have any hardware to test it on. So if anyone feels like testing this patch
I will be interested in the results.

The patches are agains v3.6
I have only tested this on x86_64 with gcc 4.7.2

The first patch is just to tidy up hardcoded constants in resiliency_test() replacing them
with calls to kmalloc_index so that it will still work after the kmalloc_cache array get reordered.

The second patch adds the new slabs, updates the kmalloc code and kmem_cache_init(). 

This version is a drop in replacement for the existing code, but I could make it a config option if 
you prefer.    

regards
Richard

Richard Kennedy (2):
  SLUB: remove hard coded magic numbers from resiliency_test
  SLUB: increase the range of slab sizes available to kmalloc, allowing
    a somewhat more effient use of memory.

 include/linux/slub_def.h |  95 +++++++++++++-------------
 mm/slub.c                | 174 ++++++++++++++++++-----------------------------
 2 files changed, 114 insertions(+), 155 deletions(-)

-- 
1.7.11.7

