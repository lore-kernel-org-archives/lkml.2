Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757838Ab2KVVrj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 16:47:39 -0500
Received: from mail.kernel.org ([198.145.19.201]:49646 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755024Ab2KVSkX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 13:40:23 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Xi Wang <xi.wang@gmail.com>, Alex Elder <elder@inktank.com>
Subject: [ 112/171] libceph: fix overflow in osdmap_decode()
Date: Wed, 21 Nov 2012 16:40:58 -0800
Message-Id: <20121122004044.590722021@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.197.g5a90748
In-Reply-To: <20121122004033.298367941@linuxfoundation.org>
References: <20121122004033.298367941@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xi Wang <xi.wang@gmail.com>

(cherry picked from commit e91a9b639a691e0982088b5954eaafb5a25c8f1c)

On 32-bit systems, a large `n' would overflow `n * sizeof(u32)' and bypass
the check ceph_decode_need(p, end, n * sizeof(u32), bad).  It would also
overflow the subsequent kmalloc() size, leading to out-of-bounds write.

Signed-off-by: Xi Wang <xi.wang@gmail.com>
Reviewed-by: Alex Elder <elder@inktank.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ceph/osdmap.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/net/ceph/osdmap.c
+++ b/net/ceph/osdmap.c
@@ -674,6 +674,9 @@ struct ceph_osdmap *osdmap_decode(void *
 		ceph_decode_need(p, end, sizeof(u32) + sizeof(u64), bad);
 		ceph_decode_copy(p, &pgid, sizeof(pgid));
 		n = ceph_decode_32(p);
+		err = -EINVAL;
+		if (n > (UINT_MAX - sizeof(*pg)) / sizeof(u32))
+			goto bad;
 		ceph_decode_need(p, end, n * sizeof(u32), bad);
 		err = -ENOMEM;
 		pg = kmalloc(sizeof(*pg) + n*sizeof(u32), GFP_NOFS);


