Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753202Ab2GZVnZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 17:43:25 -0400
Received: from 1010ds2-suoe.0.fullrate.dk ([90.184.90.115]:42479 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752875Ab2GZVnX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 17:43:23 -0400
Date: Thu, 26 Jul 2012 23:43:22 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Forest Bond <forest@alittletooquiet.net>
Subject: [PATCH 1/5] staging: vt6656: don't leak 'param' in vt6656_hostap_ioctl()
 when returning -EOPNOTSUPP
In-Reply-To: <alpine.LNX.2.00.1207262335340.14949@swampdragon.chaosbits.net>
Message-ID: <alpine.LNX.2.00.1207262338250.14949@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1207262335340.14949@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Don't return -EOPNOTSUPP directly in switch case's since it'll leak
the memory allocated to 'param' when that variable goes out of scope
without having been assigned to anything.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 drivers/staging/vt6656/hostap.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/vt6656/hostap.c b/drivers/staging/vt6656/hostap.c
index 51b5adf..bc49611 100644
--- a/drivers/staging/vt6656/hostap.c
+++ b/drivers/staging/vt6656/hostap.c
@@ -789,8 +789,8 @@ int vt6656_hostap_ioctl(PSDevice pDevice, struct iw_point *p)
 		break;
 	case VIAWGET_HOSTAPD_SET_ASSOC_AP_ADDR:
 	    DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "VIAWGET_HOSTAPD_SET_ASSOC_AP_ADDR \n");
-		return -EOPNOTSUPP;
-		break;
+		ret = -EOPNOTSUPP;
+		goto out;
 	case VIAWGET_HOSTAPD_FLUSH:
 	    DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "VIAWGET_HOSTAPD_FLUSH \n");
         spin_lock_irq(&pDevice->lock);
@@ -840,13 +840,13 @@ int vt6656_hostap_ioctl(PSDevice pDevice, struct iw_point *p)
 
 	case VIAWGET_HOSTAPD_STA_CLEAR_STATS:
 	    DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "VIAWGET_HOSTAPD_STA_CLEAR_STATS \n");
-	    return -EOPNOTSUPP;
-
+	    ret = -EOPNOTSUPP;
+	    goto out;
 	default:
 	    DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "vt6656_hostap_ioctl: unknown cmd=%d\n",
 		       (int)param->cmd);
-		return -EOPNOTSUPP;
-		break;
+		ret = -EOPNOTSUPP;
+		goto out;
 	}
 
 
-- 
1.7.11.3


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

