Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756200Ab2KVVTN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 16:19:13 -0500
Received: from mail.kernel.org ([198.145.19.201]:49610 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755264Ab2KVSkq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 13:40:46 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Sage Weil <sage@inktank.com>, Alex Elder <elder@inktank.com>,
        Yehuda Sadeh <yehuda@inktank.com>
Subject: [ 140/171] libceph: report socket read/write error message
Date: Wed, 21 Nov 2012 16:41:26 -0800
Message-Id: <20121122004047.400544934@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.197.g5a90748
In-Reply-To: <20121122004033.298367941@linuxfoundation.org>
References: <20121122004033.298367941@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sage Weil <sage@inktank.com>

(cherry picked from commit 3a140a0d5c4b9e35373b016e41dfc85f1e526bdb)

We need to set error_msg to something useful before calling ceph_fault();
do so here for try_{read,write}().  This is more informative than

libceph: osd0 192.168.106.220:6801 (null)

Signed-off-by: Sage Weil <sage@inktank.com>
Reviewed-by: Alex Elder <elder@inktank.com>
Reviewed-by: Yehuda Sadeh <yehuda@inktank.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ceph/messenger.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/net/ceph/messenger.c
+++ b/net/ceph/messenger.c
@@ -2287,14 +2287,18 @@ restart:
 	ret = try_read(con);
 	if (ret == -EAGAIN)
 		goto restart;
-	if (ret < 0)
+	if (ret < 0) {
+		con->error_msg = "socket error on read";
 		goto fault;
+	}
 
 	ret = try_write(con);
 	if (ret == -EAGAIN)
 		goto restart;
-	if (ret < 0)
+	if (ret < 0) {
+		con->error_msg = "socket error on write";
 		goto fault;
+	}
 
 done:
 	mutex_unlock(&con->mutex);


