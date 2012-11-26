Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756978Ab2KZRsZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 12:48:25 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:47676 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933280Ab2KZRIz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 12:08:55 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alex Elder <elder@inktank.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 145/270] libceph: only kunmap kmapped pages
Date: Mon, 26 Nov 2012 14:57:15 -0200
Message-Id: <1353949160-26803-146-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
References: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7u1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Elder <elder@inktank.com>

commit 5ce765a540f34d1e2005e1210f49f67fdf11e997 upstream.

In write_partial_msg_pages(), pages need to be kmapped in order to
perform a CRC-32c calculation on them.  As an artifact of the way
this code used to be structured, the kunmap() call was separated
from the kmap() call and both were done conditionally.  But the
conditions under which the kmap() and kunmap() calls were made
differed, so there was a chance a kunmap() call would be done on a
page that had not been mapped.

The symptom of this was tripping a BUG() in kunmap_high() when
pkmap_count[nr] became 0.

Reported-by: Bryan K. Wright <bryan@virginia.edu>
Signed-off-by: Alex Elder <elder@inktank.com>
Reviewed-by: Sage Weil <sage@inktank.com>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 net/ceph/messenger.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/net/ceph/messenger.c b/net/ceph/messenger.c
index b141c86..8ba0eee 100644
--- a/net/ceph/messenger.c
+++ b/net/ceph/messenger.c
@@ -1069,16 +1069,13 @@ static int write_partial_msg_pages(struct ceph_connection *con)
 			BUG_ON(kaddr == NULL);
 			base = kaddr + con->out_msg_pos.page_pos + bio_offset;
 			crc = crc32c(crc, base, len);
+			kunmap(page);
 			msg->footer.data_crc = cpu_to_le32(crc);
 			con->out_msg_pos.did_page_crc = true;
 		}
 		ret = ceph_tcp_sendpage(con->sock, page,
 				      con->out_msg_pos.page_pos + bio_offset,
 				      len, 1);
-
-		if (do_datacrc)
-			kunmap(page);
-
 		if (ret <= 0)
 			goto out;
 
-- 
1.7.9.5

