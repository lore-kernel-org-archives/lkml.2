Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757168Ab0C3XhP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 19:37:15 -0400
Received: from kroah.org ([198.145.64.141]:46383 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756859Ab0C3XUz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 19:20:55 -0400
X-Mailbox-Line: From linux@linux.site Tue Mar 30 15:48:23 2010
Message-Id: <20100330224822.839646817@linux.site>
User-Agent: quilt/0.47-14.9
Date: Tue, 30 Mar 2010 15:42:08 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [094/156] nilfs2: fix hang-up of cleaner after log writer returned with error
In-Reply-To: <20100330230630.GA28824@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>

commit 110d735a0ae69bdd11af9acb6ea3b979137eb118 upstream.

According to the report from Andreas Beckmann (Message-ID:
<4BA54677.3090902@abeckmann.de>), nilfs in 2.6.33 kernel got stuck
after a disk full error.

This turned out to be a regression by log writer updates merged at
kernel 2.6.33.  nilfs_segctor_abort_construction, which is a cleanup
function for erroneous cases, was skipping writeback completion for
some logs.

This fixes the bug and would resolve the hang issue.

Reported-by: Andreas Beckmann <debian@abeckmann.de>
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Tested-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/nilfs2/segment.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/fs/nilfs2/segment.c
+++ b/fs/nilfs2/segment.c
@@ -1902,8 +1902,7 @@ static void nilfs_segctor_abort_construc
 
 	list_splice_tail_init(&sci->sc_write_logs, &logs);
 	ret = nilfs_wait_on_logs(&logs);
-	if (ret)
-		nilfs_abort_logs(&logs, NULL, sci->sc_super_root, ret);
+	nilfs_abort_logs(&logs, NULL, sci->sc_super_root, ret ? : err);
 
 	list_splice_tail_init(&sci->sc_segbufs, &logs);
 	nilfs_cancel_segusage(&logs, nilfs->ns_sufile);


