Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754995Ab1G0WMe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 18:12:34 -0400
Received: from mga03.intel.com ([143.182.124.21]:9080 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755353Ab1G0VsE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 17:48:04 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,278,1309762800"; 
   d="scan'208";a="32274441"
From: Andi Kleen <andi@firstfloor.org>
References: <20110727247.325703029@firstfloor.org>
In-Reply-To: <20110727247.325703029@firstfloor.org>
To: Warns@pre-sense.de, warns@pre-sense.de, torvalds@linux-foundation.org,
        gregkh@suse.de, ak@linux.intel.com, linux-kernel@vger.kernel.org,
        stable@kernel.org, tim.bird@am.sony.com
Subject: [PATCH] [5/99] Fix for buffer overflow in ldm_frag_add not sufficient
Message-Id: <20110727214803.69CCD2403FF@tassilo.jf.intel.com>
Date: Wed, 27 Jul 2011 14:48:03 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Timo Warns <Warns@pre-sense.de>

commit cae13fe4cc3f24820ffb990c09110626837e85d4 upstream.

As Ben Hutchings discovered [1], the patch for CVE-2011-1017 (buffer
overflow in ldm_frag_add) is not sufficient.  The original patch in
commit c340b1d64000 ("fs/partitions/ldm.c: fix oops caused by corrupted
partition table") does not consider that, for subsequent fragments,
previously allocated memory is used.

[1] http://lkml.org/lkml/2011/5/6/407

Reported-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Timo Warns <warns@pre-sense.de>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 fs/partitions/ldm.c |    5 +++++
 1 file changed, 5 insertions(+)

Index: linux-2.6.35.y/fs/partitions/ldm.c
===================================================================
--- linux-2.6.35.y.orig/fs/partitions/ldm.c
+++ linux-2.6.35.y/fs/partitions/ldm.c
@@ -1335,6 +1335,11 @@ static bool ldm_frag_add (const u8 *data
 
 	list_add_tail (&f->list, frags);
 found:
+	if (rec >= f->num) {
+		ldm_error("REC value (%d) exceeds NUM value (%d)", rec, f->num);
+		return false;
+	}
+
 	if (f->map & (1 << rec)) {
 		ldm_error ("Duplicate VBLK, part %d.", rec);
 		f->map &= 0x7F;			/* Mark the group as broken */
