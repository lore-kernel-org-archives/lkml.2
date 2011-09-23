Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754455Ab1IWOb4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Sep 2011 10:31:56 -0400
Received: from mail09.linbit.com ([212.69.161.110]:39627 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754434Ab1IWObc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Sep 2011 10:31:32 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 10/10] drbd: For protocol versions before 100, use mixed header versions
Date: Fri, 23 Sep 2011 16:31:25 +0200
Message-Id: <1316788285-17433-11-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1316788285-17433-1-git-send-email-philipp.reisner@linbit.com>
References: <1316788285-17433-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andreas Gruenbacher <agruen@linbit.com>

Previous versions of drbd are using version 80 headers for all packets
short enough for protocol 80.  They support both header versions in
worker context, but only version 80 headers in asynchronous context.
For backwards compatibility, continue to use version 80 headers for
short packets before protocol version 100.

>From protocol version 100 on, use the same header version for all
packets.

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_main.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
index 99b467e..6afcfab 100644
--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -741,7 +741,8 @@ static unsigned int prepare_header(struct drbd_tconn *tconn, int vnr,
 {
 	if (tconn->agreed_pro_version >= 100)
 		return prepare_header100(buffer, cmd, size, vnr);
-	else if (tconn->agreed_pro_version >= 95)
+	else if (tconn->agreed_pro_version >= 95 &&
+		 size > DRBD_MAX_SIZE_H80_PACKET)
 		return prepare_header95(buffer, cmd, size);
 	else
 		return prepare_header80(buffer, cmd, size);
-- 
1.7.4.1

