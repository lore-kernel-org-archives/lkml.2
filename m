Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752713Ab2GPBFf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jul 2012 21:05:35 -0400
Received: from nm8-vm0.bullet.mail.sp2.yahoo.com ([98.139.91.194]:29926 "HELO
	nm8-vm0.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751996Ab2GPBFd convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jul 2012 21:05:33 -0400
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 745919.44259.bm@omp1050.mail.sp2.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Mailer:Message-ID:Date:From:Reply-To:Subject:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=3iO3B48Og0qFM5+aE996PpIdKWe3Cbqa0UHbT+Jqq8sBODL4ez95gFMFe3IxeAhT9RGg6z1+9fmTWpVzv9e4aMVRjRSahedOtM+gPoHxGc2e11rznkQyGW2T9NoPuvDE2DBizobgG0zh0aUQW1Leh1UIsi77s+Sh5Soyp1Y5cWM=;
X-YMail-OSG: EWciWrcVM1ku3prhbKTVQgjSG9X9G5sw4ELCbZ9Y61QJY5E
 CDZJhQpziIntArEaCwdZWM9GPl0vqqIds2osfQSsP_swOAbyJ7e0GeuBNuZf
 QIlnE4ucRWVEJjRhtorE9DdgzzM8_gu_2ZdOsPty1KX9dw7BisNiRZn9vbGe
 X3YHHZ.N_GvHIEWMLafHSZiU1vZZFjiRhCLXpVUSkXLrhpvGrZX7PvCtEZya
 XGkZB3OeIsjLq9bRb2C_SrYrWzoBG210ZRil8pS91HH3MMv6oh6jdGxfpvUL
 Rz5GiZrADHUFD.EmQQgF5iRDKpfbueP1FK7ISdCt8cdcGI3pABYRhyBhaFQn
 ZLbmhLuhmLSZmH4YS5iVfEE6w9HSKGsqgcVa.KG2_rDjLgWQjnmwrMMXgJfl
 MeFbdAjjN_Y.HwcyE6KjXHfN43sT26M5YfRMmD1fGIpAWL_6gPA9TUihDNvP
 JXQ--
X-Mailer: YahooMailWebService/0.8.120.356233
Message-ID: <1342400731.4834.YahooMailNeo@web112017.mail.gq1.yahoo.com>
Date: Sun, 15 Jul 2012 18:05:31 -0700 (PDT)
From: Paulo da Silva <psdasilva@yahoo.com>
Reply-To: Paulo da Silva <psdasilva@yahoo.com>
Subject: [PATCH] loop device: Fix wrong return check from idr_pre_get in loop.c
To: "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

idr_pre_get always returns 0 (no memory) or 1 (OK). Never a negative value.
So, it must be checked accordingly.

Signed-off-by: Paulo da Silva <psdasilva@yahoo.com>
---
 drivers/block/loop.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)


--- linux-3.5-rc6/drivers/block/loop.c.orig    2012-07-08 01:23:56.000000000 +0100
+++ linux-3.5-rc6/drivers/block/loop.c    2012-07-13 19:45:10.000000000 +0100
@@ -1603,9 +1603,10 @@ static int loop_add(struct loop_device *
         goto out;
     }
 
-    err = idr_pre_get(&loop_index_idr, GFP_KERNEL);
-    if (err < 0)
+    if (idr_pre_get(&loop_index_idr, GFP_KERNEL) == 0) {
+        err = -ENOMEM;
         goto out_free_dev;
+    }
 
     if (i >= 0) {
         int m;
