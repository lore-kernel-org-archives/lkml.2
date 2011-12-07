Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933645Ab1LGQWr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 11:22:47 -0500
Received: from cantor2.suse.de ([195.135.220.15]:34082 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933628Ab1LGQWp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 11:22:45 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Dec  7 08:12:19 2011
Message-Id: <20111207161218.969833891@clark.kroah.org>
User-Agent: quilt/0.50-23.1
Date: Wed, 07 Dec 2011 08:11:53 -0800
From: Greg KH <gregkh@suse.de>
To: <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>, greg@kroah.com
Cc: <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <alan@lxorguk.ukuu.org.uk>, xfs@oss.sgi.com, bpm@sgi.com,
        Mitsuo Hayasaka <mitsuo.hayasaka.hu@hitachi.com>,
        Alex Elder <aelder@sgi.com>, Christoph Hellwig <hch@infradead.org>
Subject: [051/104] xfs: use doalloc flag in xfs_qm_dqattach_one()
In-Reply-To: <20111207161246.GA10995@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mitsuo Hayasaka <mitsuo.hayasaka.hu@hitachi.com>

commit db3e74b582915d66e10b0c73a62763418f54c340 upstream.

The doalloc arg in xfs_qm_dqattach_one() is a flag that indicates
whether a new area to handle quota information will be allocated
if needed. Originally, it was passed to xfs_qm_dqget(), but has
been removed by the following commit (probably by mistake):

	commit 8e9b6e7fa4544ea8a0e030c8987b918509c8ff47
	Author: Christoph Hellwig <hch@lst.de>
	Date:   Sun Feb 8 21:51:42 2009 +0100

	xfs: remove the unused XFS_QMOPT_DQLOCK flag

As the result, xfs_qm_dqget() called from xfs_qm_dqattach_one()
never allocates the new area even if it is needed.

This patch gives the doalloc arg to xfs_qm_dqget() in
xfs_qm_dqattach_one() to fix this problem.

Signed-off-by: Mitsuo Hayasaka <mitsuo.hayasaka.hu@hitachi.com>
Cc: Alex Elder <aelder@sgi.com>
Cc: Christoph Hellwig <hch@infradead.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Ben Myers <bpm@sgi.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/xfs/xfs_qm.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -674,7 +674,8 @@ xfs_qm_dqattach_one(
 	 * disk and we didn't ask it to allocate;
 	 * ESRCH if quotas got turned off suddenly.
 	 */
-	error = xfs_qm_dqget(ip->i_mount, ip, id, type, XFS_QMOPT_DOWARN, &dqp);
+	error = xfs_qm_dqget(ip->i_mount, ip, id, type,
+			     doalloc | XFS_QMOPT_DOWARN, &dqp);
 	if (error)
 		return error;
 


