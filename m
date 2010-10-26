Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759873Ab0JZNgr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 09:36:47 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:41748 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752512Ab0JZNgq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 09:36:46 -0400
Date: Tue, 26 Oct 2010 15:38:53 +0200
From: Michal Nazarewicz <m.nazarewicz@samsung.com>
Subject: [PATCH 2/7] USB: gadget: f_mass_storage: put_device() in error recovery
In-reply-to: <7214986593243afb11434ddb86da7e0460dc1f51.1288099890.git.m.nazarewicz@samsung.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Rahul Ruikar <rahul.ruikar@gmail.com>,
        Michal Nazarewicz <mina86@mina86.com>
Message-id: <4a6e11ec91ee592689f553dc69df515b4302691b.1288099890.git.m.nazarewicz@samsung.com>
MIME-version: 1.0
X-Mailer: git-send-email 1.7.1
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
References: <7214986593243afb11434ddb86da7e0460dc1f51.1288099890.git.m.nazarewicz@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rahul Ruikar <rahul.ruikar@gmail.com>

This commit fixes an issue with error recovery after
device_register() fails in Mass Storage Function.  The device
needs to be put to avoid resource leakage.

Signed-off-by: Rahul Ruikar <rahul.ruikar@gmail.com>
[mina86@mina86.com: updated commit message]
Signed-off-by: Michal Nazarewicz <mina86@mina86.com>
---
 drivers/usb/gadget/f_mass_storage.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

I think this was in the end not accepted even though it is a valid
fix.  Mass storage function does nothing in LUN's device release
function so it's safe to call put_device() (which calls release
function).

diff --git a/drivers/usb/gadget/f_mass_storage.c b/drivers/usb/gadget/f_mass_storage.c
index 838286b..c89b992 100644
--- a/drivers/usb/gadget/f_mass_storage.c
+++ b/drivers/usb/gadget/f_mass_storage.c
@@ -2765,6 +2765,7 @@ static struct fsg_common *fsg_common_init(struct fsg_common *common,
 		if (rc) {
 			INFO(common, "failed to register LUN%d: %d\n", i, rc);
 			common->nluns = i;
+			put_device(&curlun->dev);
 			goto error_release;
 		}
 
-- 
1.7.1

