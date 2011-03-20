Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751186Ab1CTFdJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Mar 2011 01:33:09 -0400
Received: from smtp-out.google.com ([74.125.121.67]:13447 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750875Ab1CTFdH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Mar 2011 01:33:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:message-id:user-agent
         :mime-version:content-type;
        b=w0kGitgmP8qLqglqIPgR3cRhGNChDbzWXZyDT8GTPNkuFH08jxblL53X/GXque2ky2
         2VwgTDXwz/8WRvDR+X4w==
Date: Sat, 19 Mar 2011 22:33:05 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@sister.anvils
To: Andrew Morton <akpm@linux-foundation.org>
cc: Tim Chen <tim.c.chen@linux.intel.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: [PATCH] tmpfs: fix off-by-one in max_blocks checks
Message-ID: <alpine.LSU.2.00.1103192230480.1659@sister.anvils>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If you fill up a tmpfs, df was showing
tmpfs                   460800         -         -   -  /tmp
because of an off-by-one in the max_blocks checks.  Fix it so df shows
tmpfs                   460800    460800         0 100% /tmp

Signed-off-by: Hugh Dickins <hughd@google.com>
---

 mm/shmem.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- 2.6.38/mm/shmem.c	2011-03-14 18:20:32.000000000 -0700
+++ linux/mm/shmem.c	2011-03-19 22:02:17.000000000 -0700
@@ -422,7 +422,8 @@ static swp_entry_t *shmem_swp_alloc(stru
 		 * a waste to allocate index if we cannot allocate data.
 		 */
 		if (sbinfo->max_blocks) {
-			if (percpu_counter_compare(&sbinfo->used_blocks, (sbinfo->max_blocks - 1)) > 0)
+			if (percpu_counter_compare(&sbinfo->used_blocks,
+						sbinfo->max_blocks - 1) >= 0)
 				return ERR_PTR(-ENOSPC);
 			percpu_counter_inc(&sbinfo->used_blocks);
 			spin_lock(&inode->i_lock);
@@ -1399,7 +1400,8 @@ repeat:
 		shmem_swp_unmap(entry);
 		sbinfo = SHMEM_SB(inode->i_sb);
 		if (sbinfo->max_blocks) {
-			if ((percpu_counter_compare(&sbinfo->used_blocks, sbinfo->max_blocks) > 0) ||
+			if (percpu_counter_compare(&sbinfo->used_blocks,
+						sbinfo->max_blocks) >= 0 ||
 			    shmem_acct_block(info->flags)) {
 				spin_unlock(&info->lock);
 				error = -ENOSPC;
