Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757182Ab2HOU0w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 16:26:52 -0400
Received: from mail1.windriver.com ([147.11.146.13]:62871 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756544Ab2HOTuQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 15:50:16 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Mark Salyzyn <mark_salyzyn@us.xyratex.com>,
        Mark Salyzyn <msalyzyn@us.xyratex.com>,
        James Bottomley <JBottomley@parallels.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [v2.6.34-stable 056/165] libsas: fix failure to revalidate domain for anything but the first expander child.
Date: Wed, 15 Aug 2012 15:46:40 -0400
Message-ID: <1345060109-9187-57-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.12.rc2
In-Reply-To: <1345060109-9187-1-git-send-email-paul.gortmaker@windriver.com>
References: <1345060109-9187-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mark Salyzyn <mark_salyzyn@us.xyratex.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 24926dadc41cc566e974022b0e66231b82c6375f upstream.

In an enclosure model where there are chaining expanders to a large body
of storage, it was discovered that libsas, responding to a broadcast
event change, would only revalidate the domain of first child expander
in the list.

The issue is that the pointer value to the discovered source device was
used to break out of the loop, rather than the content of the pointer.

This still remains non-compliant as the revalidate domain code is
supposed to loop through all child expanders, and not stop at the first
one it finds that reports a change count. However, the design of this
routine does not allow multiple device discoveries and that would be a
more complicated set of patches reserved for another day. We are fixing
the glaring bug rather than refactoring the code.

Signed-off-by: Mark Salyzyn <msalyzyn@us.xyratex.com>
Signed-off-by: James Bottomley <JBottomley@Parallels.com>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/scsi/libsas/sas_expander.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/libsas/sas_expander.c b/drivers/scsi/libsas/sas_expander.c
index fbf0a09..46acf74 100644
--- a/drivers/scsi/libsas/sas_expander.c
+++ b/drivers/scsi/libsas/sas_expander.c
@@ -1713,7 +1713,7 @@ static int sas_find_bcast_dev(struct domain_device *dev,
 	list_for_each_entry(ch, &ex->children, siblings) {
 		if (ch->dev_type == EDGE_DEV || ch->dev_type == FANOUT_DEV) {
 			res = sas_find_bcast_dev(ch, src_dev);
-			if (src_dev)
+			if (*src_dev)
 				return res;
 		}
 	}
-- 
1.7.12.rc2

