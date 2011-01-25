Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753935Ab1AYUtv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 15:49:51 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:55203 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753909Ab1AYUtu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 15:49:50 -0500
Message-ID: <4d3f376c.857a0e0a.122c.4795@mx.google.com>
From: "Igor M. Liplianin" <liplianin@me.by>
Date: Tue, 25 Jan 2011 22:08:00 +0200
Subject: [PATCH 9/9 v3] cx23885, altera-ci: enable all PID's less than 0x20 in hardware PID filter.
To: <mchehab@infradead.org>, <linux-media@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It takes too long time to scan due to low symbol rate PID's
like PAT, PMT, CAT, NIT.
For that matter we enabled permanently all PID's
less 0x20 in hardware PID filter for NetUP Dual DVB-T/C CI RF card
to combine rates.

Signed-off-by: Igor M. Liplianin <liplianin@netup.ru>
---
 drivers/media/video/cx23885/altera-ci.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/media/video/cx23885/altera-ci.c b/drivers/media/video/cx23885/altera-ci.c
index e5c0873..ad6cc68 100644
--- a/drivers/media/video/cx23885/altera-ci.c
+++ b/drivers/media/video/cx23885/altera-ci.c
@@ -521,7 +521,8 @@ static void altera_pid_control(struct netup_hw_pid_filter *pid_filt,
 	struct fpga_internal *inter = pid_filt->internal;
 	u8 store = 0;
 
-	if (pid == 0x2000)
+	/* pid 0-0x1f always enabled, don't touch them */
+	if ((pid == 0x2000) || (pid < 0x20))
 		return;
 
 	mutex_lock(&inter->fpga_mutex);
@@ -567,8 +568,9 @@ static void altera_toggle_fullts_streaming(struct netup_hw_pid_filter *pid_filt,
 
 		netup_fpga_op_rw(inter, NETUP_CI_PID_ADDR1,
 				((i >> 8) & 0x03) | (pid_filt->nr << 2), 0);
-
-		netup_fpga_op_rw(inter, NETUP_CI_PID_DATA, store, 0);
+		/* pid 0-0x1f always enabled */
+		netup_fpga_op_rw(inter, NETUP_CI_PID_DATA,
+				(i > 3 ? store : 0), 0);
 	}
 
 	mutex_unlock(&inter->fpga_mutex);
-- 
1.7.1

