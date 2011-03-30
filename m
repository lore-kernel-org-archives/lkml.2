Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965317Ab1C3Vij (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 17:38:39 -0400
Received: from mga11.intel.com ([192.55.52.93]:51950 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964895Ab1C3VIP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 17:08:15 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,270,1299484800"; 
   d="scan'208";a="903735529"
From: Andi Kleen <andi@firstfloor.org>
References: <20110330203.501921634@firstfloor.org>
In-Reply-To: <20110330203.501921634@firstfloor.org>
To: Warns@pre-sense.de, warns@pre-sense.de, ak@linux.intel.com,
        eugeneteo@kernel.sg, ldm@flatcap.org, harvey.harrison@gmail.com,
        akpm@linux-foundation.org, torvalds@linux-foundation.org,
        gregkh@suse.de, linux-kernel@vger.kernel.org, stable@kernel.org,
        tim.bird@am.sony.com
Subject: [PATCH] [151/275] ldm: corrupted partition table can cause kernel oops
Message-Id: <20110330210632.AC9D93E1A05@tassilo.jf.intel.com>
Date: Wed, 30 Mar 2011 14:06:32 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Timo Warns <Warns@pre-sense.de>

commit 294f6cf48666825d23c9372ef37631232746e40d upstream.

The kernel automatically evaluates partition tables of storage devices.
The code for evaluating LDM partitions (in fs/partitions/ldm.c) contains
a bug that causes a kernel oops on certain corrupted LDM partitions.  A
kernel subsystem seems to crash, because, after the oops, the kernel no
longer recognizes newly connected storage devices.

The patch changes ldm_parse_vmdb() to Validate the value of vblk_size.

Signed-off-by: Timo Warns <warns@pre-sense.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>
Cc: Eugene Teo <eugeneteo@kernel.sg>
Acked-by: Richard Russon <ldm@flatcap.org>
Cc: Harvey Harrison <harvey.harrison@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/partitions/ldm.c |    5 +++++
 1 file changed, 5 insertions(+)

Index: linux-2.6.35.y/fs/partitions/ldm.c
===================================================================
--- linux-2.6.35.y.orig/fs/partitions/ldm.c	2011-03-29 22:51:05.872572904 -0700
+++ linux-2.6.35.y/fs/partitions/ldm.c	2011-03-29 23:03:01.398264393 -0700
@@ -251,6 +251,11 @@
 	}
 
 	vm->vblk_size     = get_unaligned_be32(data + 0x08);
+	if (vm->vblk_size == 0) {
+		ldm_error ("Illegal VBLK size");
+		return false;
+	}
+
 	vm->vblk_offset   = get_unaligned_be32(data + 0x0C);
 	vm->last_vblk_seq = get_unaligned_be32(data + 0x04);
 
