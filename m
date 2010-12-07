Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754123Ab0LGXRe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 18:17:34 -0500
Received: from mx1.redhat.com ([209.132.183.28]:22794 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752964Ab0LGXRc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 18:17:32 -0500
From: Mike Snitzer <snitzer@redhat.com>
To: Hannes Reinecke <hare@suse.de>
Cc: k-ueda@ct.jp.nec.com, michaelc@cs.wisc.edu, tytso@mit.edu,
        sshtylyov@mvista.com, linux-scsi@vger.kernel.org, jaxboe@fusionio.com,
        jack@suse.cz, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, swhiteho@redhat.com,
        linux-raid@vger.kernel.org, linux-ide@vger.kernel.org,
        dm-devel@redhat.com, James.Bottomley@suse.de,
        konishi.ryusuke@lab.ntt.co.jp, j-nomura@ce.jp.nec.com, vst@vlnb.net,
        rwheeler@redhat.com, hch@lst.de, chris.mason@oracle.com, tj@kernel.org
Subject: [RFC PATCH v2 2/3] dm mpath: propagate target errors immediately
Date: Tue,  7 Dec 2010 18:16:41 -0500
Message-Id: <1291763802-8251-3-git-send-email-snitzer@redhat.com>
In-Reply-To: <1291763802-8251-1-git-send-email-snitzer@redhat.com>
References: <1291763802-8251-1-git-send-email-snitzer@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

DM now has more information about the nature of the underlying storage
failure.  Path failure is avoided if a request failed due to a target
error.  Instead the target error is immediately passed up the stack.

Discard requests that fail due to non-target errors may now be retried.

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm-mpath.c |   11 +----------
 1 files changed, 1 insertions(+), 10 deletions(-)

diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
index 487ecda..071529a 100644
--- a/drivers/md/dm-mpath.c
+++ b/drivers/md/dm-mpath.c
@@ -1270,16 +1270,7 @@ static int do_end_io(struct multipath *m, struct request *clone,
 	if (!error && !clone->errors)
 		return 0;	/* I/O complete */
 
-	if (error == -EOPNOTSUPP)
-		return error;
-
-	if (clone->cmd_flags & REQ_DISCARD)
-		/*
-		 * Pass all discard request failures up.
-		 * FIXME: only fail_path if the discard failed due to a
-		 * transport problem.  This requires precise understanding
-		 * of the underlying failure (e.g. the SCSI sense).
-		 */
+	if (error == -EOPNOTSUPP || error == -EREMOTEIO)
 		return error;
 
 	if (mpio->pgpath)
-- 
1.7.2.3

