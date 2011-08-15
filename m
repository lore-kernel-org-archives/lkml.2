Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752413Ab1HOSHd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 14:07:33 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:43206 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751302Ab1HOSHc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 14:07:32 -0400
From: Jeff Layton <jlayton@redhat.com>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: npiggin@suse.de
Subject: [PATCH] iov_iter: have iov_iter_advance decrement nr_segs appropriately
Date: Mon, 15 Aug 2011 14:07:26 -0400
Message-Id: <1313431646-14961-1-git-send-email-jlayton@redhat.com>
X-Mailer: git-send-email 1.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, when you call iov_iter_advance, then the pointer to the kvec
array can be incremented, but it does not decrement the nr_segs value in
the iov_iter struct. The result is a iov_iter struct with a nr_segs
value that goes beyond the end of the array.

While I'm not aware of anything that's specifically broken by this, it
seems odd and a bit dangerous not to decrement that value. If someone
were to trust the nr_segs value to be correct, then they could end up
walking off the end of the array.

Changing this might also provide some micro-optimization when dealing
with the last kvec in an array. Many of the other routines that deal
with iov_iter have optimized codepaths when nr_segs == 1.

Cc: Nick Piggin <npiggin@suse.de>
Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 mm/filemap.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/mm/filemap.c b/mm/filemap.c
index 645a080..86508cc 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -2113,6 +2113,7 @@ void iov_iter_advance(struct iov_iter *i, size_t bytes)
 	} else {
 		const struct iovec *iov = i->iov;
 		size_t base = i->iov_offset;
+		unsigned long nr_segs = i->nr_segs;
 
 		/*
 		 * The !iov->iov_len check ensures we skip over unlikely
@@ -2128,11 +2129,13 @@ void iov_iter_advance(struct iov_iter *i, size_t bytes)
 			base += copy;
 			if (iov->iov_len == base) {
 				iov++;
+				nr_segs--;
 				base = 0;
 			}
 		}
 		i->iov = iov;
 		i->iov_offset = base;
+		i->nr_segs = nr_segs;
 	}
 }
 EXPORT_SYMBOL(iov_iter_advance);
-- 
1.7.6

