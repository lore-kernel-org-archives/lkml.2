Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753522Ab2BEW0X (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Feb 2012 17:26:23 -0500
Received: from 1wt.eu ([62.212.114.60]:61829 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753368Ab2BEW0L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Feb 2012 17:26:11 -0500
Message-Id: <20120205220950.429546088@pcw.home.local>
User-Agent: quilt/0.48-1
Date: Sun, 05 Feb 2012 23:10:12 +0100
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Timo Warns <warns@pre-sense.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg KH <gregkh@linuxfoundation.org>
Subject: [PATCH 23/91] Fix for buffer overflow in ldm_frag_add not sufficient
In-Reply-To: <0635750f5f06ed2ca212b91fcb5c4483@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-longterm review patch.  If anyone has any objections, please let us know.

------------------

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
---
 fs/partitions/ldm.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

Index: longterm-2.6.27/fs/partitions/ldm.c
===================================================================
--- longterm-2.6.27.orig/fs/partitions/ldm.c	2012-02-05 22:34:36.759915873 +0100
+++ longterm-2.6.27/fs/partitions/ldm.c	2012-02-05 22:34:38.150914572 +0100
@@ -1335,6 +1335,11 @@
 
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


