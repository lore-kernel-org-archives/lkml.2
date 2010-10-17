Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757376Ab0JQOlp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Oct 2010 10:41:45 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:61194 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757362Ab0JQOlm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Oct 2010 10:41:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=VcfT/hgEbHgVfxsIcoBXzyTpRjVcQqZAjHc1L04My679Zy+Fb34cqEXAy90KA0EM/3
         mtSrtvMvCmMADn8tX6sMW3wzbV+tPknGQc0ZFA23Pqln/CG/uvmart0UqJ+XI5qq/kvC
         xyaFqDnxW7dbuXZfwIhJur6eX077JE9N+pxdY=
From: Vasiliy Kulikov <segooon@gmail.com>
To: kernel-janitors@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Alan Cox <alan@linux.intel.com>,
        Paul Fulghum <paulkf@microgate.com>,
        Kulikov Vasiliy <segooon@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 7/8] char: synclink_gt: fix information leak to userland
Date: Sun, 17 Oct 2010 18:41:36 +0400
Message-Id: <1287326496-8178-1-git-send-email-segooon@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Structures tmp_params and new_line are copied to userland with some padding
fields unitialized.  It leads to leaking of stack memory.

Signed-off-by: Vasiliy Kulikov <segooon@gmail.com>
---
 Compile tested.

 drivers/char/synclink_gt.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/char/synclink_gt.c b/drivers/char/synclink_gt.c
index 1746d91..c3c2cf8 100644
--- a/drivers/char/synclink_gt.c
+++ b/drivers/char/synclink_gt.c
@@ -1132,6 +1132,7 @@ static long get_params32(struct slgt_info *info, struct MGSL_PARAMS32 __user *us
 	struct MGSL_PARAMS32 tmp_params;
 
 	DBGINFO(("%s get_params32\n", info->device_name));
+	memset(&tmp_params, 0, sizeof(tmp_params));
 	tmp_params.mode            = (compat_ulong_t)info->params.mode;
 	tmp_params.loopback        = info->params.loopback;
 	tmp_params.flags           = info->params.flags;
@@ -1617,6 +1618,8 @@ static int hdlcdev_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
 	if (cmd != SIOCWANDEV)
 		return hdlc_ioctl(dev, ifr, cmd);
 
+	memset(&new_line, 0, sizeof(new_line));
+
 	switch(ifr->ifr_settings.type) {
 	case IF_GET_IFACE: /* return current sync_serial_settings */
 
-- 
1.7.0.4

