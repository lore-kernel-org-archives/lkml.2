Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759509Ab1KWAr4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 19:47:56 -0500
Received: from cantor2.suse.de ([195.135.220.15]:43013 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759446Ab1KWAmG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 19:42:06 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Nov 22 16:24:08 2011
Message-Id: <20111123002408.631967363@clark.kroah.org>
User-Agent: quilt/0.48-20.1.2
Date: Tue, 22 Nov 2011 16:23:50 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, xfs@oss.sgi.com,
        Ajeet Yadav <ajeet.yadav.77@gmail.com>, Alex Elder <aelder@sgi.com>
Subject: [43/53] xfs: fix error handling for synchronous writes
In-Reply-To: <20111123002419.GA8531@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christoph Hellwig <hch@infradead.org>

If removed storage while synchronous buffer write underway,
"xfslogd" hangs.

Detailed log http://oss.sgi.com/archives/xfs/2011-07/msg00740.html

Related work bfc60177f8ab509bc225becbb58f7e53a0e33e81
"xfs: fix error handling for synchronous writes"

Given that xfs_bwrite actually does the shutdown already after
waiting for the b_iodone completion and given that we actually
found that calling xfs_force_shutdown from inside
xfs_buf_iodone_callbacks was a major contributor the problem
it better to drop this call.

Signed-off-by: Ajeet Yadav <ajeet.yadav.77@gmail.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Alex Elder <aelder@sgi.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/xfs/xfs_buf_item.c |    1 -
 1 file changed, 1 deletion(-)

--- a/fs/xfs/xfs_buf_item.c
+++ b/fs/xfs/xfs_buf_item.c
@@ -1023,7 +1023,6 @@ xfs_buf_iodone_callbacks(
 	XFS_BUF_UNDELAYWRITE(bp);
 
 	trace_xfs_buf_error_relse(bp, _RET_IP_);
-	xfs_force_shutdown(mp, SHUTDOWN_META_IO_ERROR);
 
 do_callbacks:
 	xfs_buf_do_callbacks(bp);


