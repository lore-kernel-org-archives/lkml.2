Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758655Ab2KVWnW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 17:43:22 -0500
Received: from mail.kernel.org ([198.145.19.201]:49017 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753526Ab2KVSdj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 13:33:39 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        "Bryan K. Wright" <bryan@virginia.edu>, Alex Elder <elder@inktank.com>,
        Sage Weil <sage@inktank.com>
Subject: [ 164/171] libceph: only kunmap kmapped pages
Date: Wed, 21 Nov 2012 16:41:50 -0800
Message-Id: <20121122004049.803751159@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.197.g5a90748
In-Reply-To: <20121122004033.298367941@linuxfoundation.org>
References: <20121122004033.298367941@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Elder <elder@inktank.com>

(cherry picked from commit 5ce765a540f34d1e2005e1210f49f67fdf11e997)

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ceph/messenger.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

--- a/net/ceph/messenger.c
+++ b/net/ceph/messenger.c
@@ -1069,16 +1069,13 @@ static int write_partial_msg_pages(struc
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
 


