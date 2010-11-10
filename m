Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755241Ab0KJJCW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 04:02:22 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:60604 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754952Ab0KJJCR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 04:02:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=f56DHb+MO7w1MGzYpYpyv3elYK7fLyyQmC7qPA8bB87QIBbwCRNsFMDQ/u4m3wcSmm
         J6xF9FQPV/ZzTP0Gjb516ZfsmBIB2P6NyWgSARl9g492lpm02Rx3bQH6byXlmqdRzYcn
         KrW3+g+89XwJtiB8lHW2Uis8TwtTgqM6uFA7Y=
From: Marek Belisko <marek.belisko@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Marek Belisko <marek.belisko@gmail.com>
Subject: [PATCH] staging: ft100: Create common return point.
Date: Wed, 10 Nov 2010 10:04:30 +0100
Message-Id: <1289379870-14493-1-git-send-email-marek.belisko@gmail.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When reg_ft1000_netdev() fails created kthread isn't stopped.
So add return point for stopping thread.

Signed-off-by: Marek Belisko <marek.belisko@gmail.com>
---
 drivers/staging/ft1000/ft1000-usb/ft1000_usb.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_usb.c b/drivers/staging/ft1000/ft1000-usb/ft1000_usb.c
index dcbc97c..99e3339 100644
--- a/drivers/staging/ft1000/ft1000-usb/ft1000_usb.c
+++ b/drivers/staging/ft1000/ft1000-usb/ft1000_usb.c
@@ -178,15 +178,13 @@ static int ft1000_probe(struct usb_interface *interface,
 
 	if (IS_ERR(pft1000info->pPollThread)) {
 		ret = PTR_ERR(pft1000info->pPollThread);
-		goto err_load;
+		goto err_thread;
 	}
 
 	msleep(500);
 
 	while (!pft1000info->CardReady) {
 		if (gPollingfailed) {
-			if (pft1000info->pPollThread)
-				kthread_stop(pft1000info->pPollThread);
 			ret = -EIO;
 			goto err_load;
 		}
@@ -207,6 +205,8 @@ static int ft1000_probe(struct usb_interface *interface,
 	return 0;
 
 err_load:
+	kthread_stop(pft1000info->pPollThread);
+err_thread:
 	kfree(pFileStart);
 err_fw:
 	kfree(ft1000dev);
-- 
1.7.1

