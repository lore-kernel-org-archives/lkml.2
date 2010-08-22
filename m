Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752247Ab0HVPJg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Aug 2010 11:09:36 -0400
Received: from filtteri1.pp.htv.fi ([213.243.153.184]:40506 "EHLO
	filtteri1.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751300Ab0HVPJf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Aug 2010 11:09:35 -0400
From: Pekka Enberg <penberg@kernel.org>
To: gregkh@suse.de
Cc: linux-kernel@vger.kernel.org, Pekka Enberg <penberg@kernel.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH] firmware: fix request_firmware() error handling
Date: Sun, 22 Aug 2010 18:09:30 +0300
Message-Id: <1282489770-2757-1-git-send-email-penberg@kernel.org>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If _request_firmware() fails and we do release_firmware(), update the pointer
pointed to by 'firmware_p' so that we don't return a free'd pointer to the
caller.

This patch fixes a boot-time crash on my MacBook that's caused by failing
isight_firmware_load(). The bug was introduced in commit f8a4bd34 ("firmware
loader: embed device into firmware_priv structure") and makes 2.6.36-rc1
unusable on my box.

Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Pekka Enberg <penberg@kernel.org>
---
Here's a picture of the oops:

  http://twitpic.com/2h76gv

Unfortunately I don't have a serial console hooked up so I couldn't get a text
version of it.

 drivers/base/firmware_class.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/base/firmware_class.c b/drivers/base/firmware_class.c
index c8a44f5..40af43e 100644
--- a/drivers/base/firmware_class.c
+++ b/drivers/base/firmware_class.c
@@ -568,7 +568,7 @@ static int _request_firmware(const struct firmware **firmware_p,
 out:
 	if (retval) {
 		release_firmware(firmware);
-		firmware_p = NULL;
+		*firmware_p = NULL;
 	}
 
 	return retval;
-- 
1.6.3.3

