Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752688Ab1CVEa3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 00:30:29 -0400
Received: from oproxy2-pub.bluehost.com ([67.222.39.60]:39400 "HELO
	oproxy2-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750820Ab1CVEaY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 00:30:24 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=tao.ma;
	h=Received:From:To:Cc:Subject:Date:Message-Id:X-Mailer:X-Identified-User;
	b=pQ8bJrJaFbG5xkv7UeNCZtCRr/KA8gXdVtRCLWT8VcgnPHsCfRrFEuUf4qJxHPZGvIV6HPxqKVtRBqkyHCKkxYejyCkp/Iw5HWIKx1LgydQ6z/ZijBnUaDzHpiNNnBta;
From: Tao Ma <tm@tao.ma>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH] usb_wwan: fix build error in play_delayed.
Date: Tue, 22 Mar 2011 12:29:22 +0800
Message-Id: <1300768162-18394-1-git-send-email-tm@tao.ma>
X-Mailer: git-send-email 1.7.1
X-Identified-User: {1390:box585.bluehost.com:colyli:tao.ma} {sentby:smtp auth 114.251.86.0 authed with tm@tao.ma}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tao Ma <boyu.mt@taobao.com>

There is a build error in today's linus tree.
drivers/usb/serial/usb_wwan.c: In function ‘play_delayed’:
drivers/usb/serial/usb_wwan.c:702: error: ‘struct dev_pm_info’ has no member named ‘usage_count’
The reason is that usage_count is wrapped with macro CONFIG_PM_RUNTIME
now in dev_pm_info.

So use the corresponding pm_runtime_get_noresume instead.

Cc: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Tao Ma <boyu.mt@taobao.com>
---
 drivers/usb/serial/usb_wwan.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/usb/serial/usb_wwan.c b/drivers/usb/serial/usb_wwan.c
index a65ddd5..5858ce4 100644
--- a/drivers/usb/serial/usb_wwan.c
+++ b/drivers/usb/serial/usb_wwan.c
@@ -699,7 +699,7 @@ static void play_delayed(struct usb_serial_port *port)
 			do {
 				unbusy_queued_urb(urb, portdata);
 				//extremely dirty
-				atomic_dec(&port->serial->interface->dev.power.usage_count);
+				pm_runtime_get_noresume(&port->serial->interface->dev);
 			} while ((urb = usb_get_from_anchor(&portdata->delayed)));
 			break;
 		}
-- 
1.6.3.GIT

