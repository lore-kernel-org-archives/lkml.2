Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754650Ab1CKKzU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Mar 2011 05:55:20 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:61530 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754429Ab1CKKzQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Mar 2011 05:55:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:subject:date:user-agent:organization:cc:mime-version
         :content-type:content-transfer-encoding:message-id;
        b=LqgLUfy4WCygsSm01gyod3YhtXwf7XCa3wD4vhak+SZG+5JQi8hYp4yUhjs/K8YEz6
         rYPsjy1PINxemtBUDupG2dx1vYuCo2OoPmi7Pvgmf1XHwjeJJK0/Av7Q41e0PZ7Oj2q1
         wo9BmeMtzoEsB3MY04MRymHOpoAID4x8yL0oQ=
From: Florian Fainelli <florian@openwrt.org>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] VLYNQ: vlynq_enable_device should try remote enabling first
Date: Fri, 11 Mar 2011 11:57:28 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.35-25-server; KDE/4.5.1; x86_64; ; )
Organization: OpenWrt
Cc: akpm@linux-foundation.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201103111157.28347.florian@openwrt.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I noticed device lockups on TNETD7200 chips when vlynq_enable_device tried
enabling the device in the following order: external -> local -> remote

inverting the external and remote order fixes the lock up and allows normal
operation of the remote VLYNQ device on all TNETD generations (7100, 7200,
7300).

Signed-off-by: Florian Fainelli <florian@openwrt.org>
---
diff --git a/drivers/vlynq/vlynq.c b/drivers/vlynq/vlynq.c
index f885c86..0dd05ce 100644
--- a/drivers/vlynq/vlynq.c
+++ b/drivers/vlynq/vlynq.c
@@ -516,9 +516,9 @@ static int __vlynq_enable_device(struct vlynq_device *dev)
 				!__vlynq_try_external(dev))
 				return 0;
 		} else {
-			if (!__vlynq_try_external(dev) ||
-				!__vlynq_try_local(dev)    ||
-				!__vlynq_try_remote(dev))
+			if (!__vlynq_try_remote(dev) ||
+				!__vlynq_try_local(dev)  ||
+				!__vlynq_try_external(dev))
 				return 0;
 		}
 		break;
--
1.7.1
