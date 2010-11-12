Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756184Ab0KLJZd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 04:25:33 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:49524 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752444Ab0KLJZb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 04:25:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=nzstjr8ReiA7xOq+J/OI4V7Pc68uYDjoIEnqFBWNeETP+rY2wMpZFfmsbljrq8Tc9w
         GzwmN7Bfk0VrZNXSmNIzxMd/YezXGPxmVLUZ3nukJzn2FdO6pYCX5y+xnbthk4+wiU9o
         PM/8ui01mrpVA8akmy+Wm0M5hrGJ6Gf8hRR+8=
From: Marek Belisko <marek.belisko@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Marek Belisko <marek.belisko@gmail.com>
Subject: [PATCH] staging: ft1000: Fix error goto statements.
Date: Fri, 12 Nov 2010 10:27:44 +0100
Message-Id: <1289554064-12733-1-git-send-email-marek.belisko@gmail.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With commit 2dab1ac81b4767095f96503a9ac093a68c6e9c95 there
was intruduced error which lead to stopping uninitialized
kthread which leads to kernel panics.

This patch fix problems with common entry point in correct
way.

Signed-off-by: Marek Belisko <marek.belisko@gmail.com>
---
 drivers/staging/ft1000/ft1000-usb/ft1000_usb.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_usb.c b/drivers/staging/ft1000/ft1000-usb/ft1000_usb.c
index 99e3339..6925622 100644
--- a/drivers/staging/ft1000/ft1000-usb/ft1000_usb.c
+++ b/drivers/staging/ft1000/ft1000-usb/ft1000_usb.c
@@ -178,7 +178,7 @@ static int ft1000_probe(struct usb_interface *interface,
 
 	if (IS_ERR(pft1000info->pPollThread)) {
 		ret = PTR_ERR(pft1000info->pPollThread);
-		goto err_thread;
+		goto err_load;
 	}
 
 	msleep(500);
@@ -186,7 +186,7 @@ static int ft1000_probe(struct usb_interface *interface,
 	while (!pft1000info->CardReady) {
 		if (gPollingfailed) {
 			ret = -EIO;
-			goto err_load;
+			goto err_thread;
 		}
 		msleep(100);
 		DEBUG("ft1000_probe::Waiting for Card Ready\n");
@@ -196,7 +196,7 @@ static int ft1000_probe(struct usb_interface *interface,
 
 	ret = reg_ft1000_netdev(ft1000dev, interface);
 	if (ret)
-		goto err_load;
+		goto err_thread;
 
 	pft1000info->NetDevRegDone = 1;
 
-- 
1.7.1

