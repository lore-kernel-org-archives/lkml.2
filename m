Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932697Ab1DYUkA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 16:40:00 -0400
Received: from 1wt.eu ([62.212.114.60]:34404 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932324Ab1DYUY6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 16:24:58 -0400
Message-Id: <20110425200235.558608258@pcw.home.local>
User-Agent: quilt/0.48-1
Date: Mon, 25 Apr 2011 22:03:31 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org
Cc: Timo Warns <warns@pre-sense.de>, Eugene Teo <eugeneteo@kernel.sg>,
        Richard Russon <ldm@flatcap.org>,
        Harvey Harrison <harvey.harrison@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 059/173] ldm: corrupted partition table can cause kernel oops
In-Reply-To: <46075c3a3ef08be6d70339617d6afc98@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27.59-stable review patch.  If anyone has any objections, please let us know.

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
Cc: Eugene Teo <eugeneteo@kernel.sg>
Acked-by: Richard Russon <ldm@flatcap.org>
Cc: Harvey Harrison <harvey.harrison@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/partitions/ldm.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/fs/partitions/ldm.c
+++ b/fs/partitions/ldm.c
@@ -251,6 +251,11 @@ static bool ldm_parse_vmdb (const u8 *da
 	}
 
 	vm->vblk_size     = get_unaligned_be32(data + 0x08);
+	if (vm->vblk_size == 0) {
+		ldm_error ("Illegal VBLK size");
+		return false;
+	}
+
 	vm->vblk_offset   = get_unaligned_be32(data + 0x0C);
 	vm->last_vblk_seq = get_unaligned_be32(data + 0x04);
 


