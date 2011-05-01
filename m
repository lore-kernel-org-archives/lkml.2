Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752899Ab1EACfm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Apr 2011 22:35:42 -0400
Received: from smtp-out.google.com ([216.239.44.51]:12760 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752211Ab1EACfj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Apr 2011 22:35:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=pYXPdlnGNILIUag4BlD5g25+mRNjbgHOT1RyYWmebYo4hDudfe7yB/JWK/ivnBd7EJ
         3EFVwWp4Eu7L460MHo6g==
Date: Sat, 30 Apr 2011 19:35:38 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@sister.anvils
To: Andrew Morton <akpm@linux-foundation.org>
cc: Christoph Hellwig <hch@lst.de>, Wu Fengguang <fengguang.wu@intel.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-fsdevel@vger.kernel.org
Subject: [PATCH] mmotm: fix hang at startup
In-Reply-To: <201104300002.p3U02Ma2026266@imap1.linux-foundation.org>
Message-ID: <alpine.LSU.2.00.1104301929520.1343@sister.anvils>
References: <201104300002.p3U02Ma2026266@imap1.linux-foundation.org>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yesterday's mmotm hangs at startup, and with lockdep it reports:
BUG: spinlock recursion on CPU#1, blkid/284 - with bdi_lock_two()
called from bdev_inode_switch_bdi() in the backtrace.  It appears
that this function is sometimes called with new the same as old.

Signed-off-by: Hugh Dickins <hughd@google.com>
---
Fix to
writeback-split-inode_wb_list_lock-into-bdi_writebacklist_lock.patch

 fs/block_dev.c |    2 ++
 1 file changed, 2 insertions(+)

--- 2.6.39-rc5-mm1/fs/block_dev.c	2011-04-29 18:20:09.183314733 -0700
+++ linux/fs/block_dev.c	2011-04-30 17:55:45.718785263 -0700
@@ -57,6 +57,8 @@ static void bdev_inode_switch_bdi(struct
 {
 	struct backing_dev_info *old = inode->i_data.backing_dev_info;
 
+	if (dst == old)
+		return;
 	bdi_lock_two(&old->wb, &dst->wb);
 	spin_lock(&inode->i_lock);
 	inode->i_data.backing_dev_info = dst;
