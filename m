Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759833Ab1KWEfU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 23:35:20 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:45915 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752496Ab1KWEfS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 23:35:18 -0500
From: Xi Wang <xi.wang@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Subject: [PATCH 2/2] ax25: integer overflows in ax25_ctl_ioctl()
Date: Tue, 22 Nov 2011 23:35:13 -0500
Message-Id: <BE9FC917-43B3-47E1-BFC7-5E5F2B1F68A1@gmail.com>
Cc: Joerg Reuter <jreuter@yaina.de>, Ralf Baechle <ralf@linux-mips.org>,
        David Miller <davem@davemloft.net>, linux-hams@vger.kernel.org,
        netdev@vger.kernel.org
To: linux-kernel@vger.kernel.org
Mime-Version: 1.0 (Apple Message framework v1084)
X-Mailer: Apple Mail (2.1084)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ax25_ctl_ioctl() misses several bound checks on the user-controlled value.

Signed-off-by: Xi Wang <xi.wang@gmail.com>
---
 net/ax25/af_ax25.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/net/ax25/af_ax25.c b/net/ax25/af_ax25.c
index be6a8cf..bd47e22 100644
--- a/net/ax25/af_ax25.c
+++ b/net/ax25/af_ax25.c
@@ -402,14 +402,14 @@ static int ax25_ctl_ioctl(const unsigned int cmd, void __user *arg)
 		break;
 
 	case AX25_T1:
-		if (ax25_ctl.arg < 1)
+		if (ax25_ctl.arg < 1 || ax25_ctl.arg > 30)
 			goto einval_put;
 		ax25->rtt = (ax25_ctl.arg * HZ) / 2;
 		ax25->t1  = ax25_ctl.arg * HZ;
 		break;
 
 	case AX25_T2:
-		if (ax25_ctl.arg < 1)
+		if (ax25_ctl.arg < 1 || ax25_ctl.arg > 20)
 			goto einval_put;
 		ax25->t2 = ax25_ctl.arg * HZ;
 		break;
@@ -422,10 +422,14 @@ static int ax25_ctl_ioctl(const unsigned int cmd, void __user *arg)
 		break;
 
 	case AX25_T3:
+		if (ax25_ctl.arg > 3600)
+			goto einval_put;
 		ax25->t3 = ax25_ctl.arg * HZ;
 		break;
 
 	case AX25_IDLE:
+		if (ax25_ctl.arg > 65535)
+			goto einval_put;
 		ax25->idle = ax25_ctl.arg * 60 * HZ;
 		break;
 
-- 
1.7.5.4

