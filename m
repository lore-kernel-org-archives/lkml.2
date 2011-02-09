Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754539Ab1BILEN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Feb 2011 06:04:13 -0500
Received: from nm29-vm0.bullet.mail.sp2.yahoo.com ([98.139.91.236]:42282 "HELO
	nm29-vm0.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753566Ab1BILEL convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Feb 2011 06:04:11 -0500
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 541805.50617.bm@omp1030.mail.sp2.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=0waP8p+75OxMAXf5gQRBE5dZ0LanagA59h5qdd+6NlPsMLCRaKsYM8dUTb/TJr3XQDB4esh1bmCOlcmTe8G+YC2E022DGuCAzL5zrLy/nYIDk5w+6RHfZlI5QJkABu2kjUI1rm+gELbPGYdJVbGAXvmqVje09APmwyfOSPsdJ88=;
Message-ID: <143565.70888.qm@web110315.mail.gq1.yahoo.com>
X-YMail-OSG: yq.cmXEVM1nSEH80uQ.bFn18RqYklHRrVceQaB.JSGrWwQc
 bziUaaFLWwyjSTAy9J4XiVa9QlgPAiFIUdFoDNPSU2dJwx.TAiRroXfMBNkD
 J7tCyE1UpJ_yipWfmU2_JA92ESkm1gVuVf8nNsfqT_k2hFunFUdfT80iW5HG
 Z5KRwWhUWBipfMvP51WAkppjUWxghq8H0BCCgvXr7tlrHclpOZHEIVGvanwB
 7KKT4fVQecdnt6rCBVDMwtRuh7y1Ej_oM1CiToU0rHbMPfFOnPBp.QrOiDBT
 jTvOExb2eFVrR96nZMdmyfRd5mRql17R3uO1vjEqH.N15nkA_zAdA.cjM.hS
 VZNUYW7ZGIrS5Aqo2bf9KSxawciDZrxe9v69cfH3bAF4TrprHnU_gms2lRgP
 2s3GdZQPr6AI-
X-Mailer: YahooMailClassic/11.4.20 YahooMailWebService/0.8.108.291010
Date: Wed, 9 Feb 2011 03:04:10 -0800 (PST)
From: Ken Stailey <kstailey@yahoo.com>
Subject: [PATCH] virtio-net: add schedule check to napi_enable call, kernel 2.6.38-RC4
To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Several people are experiencing virtio-net driver lock ups while attempting to do real work and this patch which was submitted in the past and ignored fixes that.  For details see:
https://bugs.launchpad.net/ubuntu/+source/linux/+bug/579276

--- drivers/net/virtio_net.c.orig    2011-02-08 14:34:51.444099190 -0500
+++ drivers/net/virtio_net.c    2011-02-08 14:18:00.484400134 -0500
@@ -446,6 +446,20 @@
     }
 }
 
+static void virtnet_napi_enable(struct virtnet_info *vi)
+{
+    napi_enable(&vi->napi);
+
+    /* If all buffers were filled by other side before we napi_enabled, we
+     * won't get another interrupt, so process any outstanding packets
+     * now.  virtnet_poll wants re-enable the queue, so we disable here.
+     * We synchronize against interrupts via NAPI_STATE_SCHED */
+    if (napi_schedule_prep(&vi->napi)) {
+        virtqueue_disable_cb(vi->rvq);
+        __napi_schedule(&vi->napi);
+    }
+}
+
 static void refill_work(struct work_struct *work)
 {
     struct virtnet_info *vi;
@@ -454,7 +468,7 @@
     vi = container_of(work, struct virtnet_info, refill.work);
     napi_disable(&vi->napi);
     still_empty = !try_fill_recv(vi, GFP_KERNEL);
-    napi_enable(&vi->napi);
+    virtnet_napi_enable(vi);
 
     /* In theory, this can happen: if we don't get any buffers in
      * we will *never* try to fill again. */
@@ -638,16 +652,7 @@
 {
     struct virtnet_info *vi = netdev_priv(dev);
 
-    napi_enable(&vi->napi);
-
-    /* If all buffers were filled by other side before we napi_enabled, we
-     * won't get another interrupt, so process any outstanding packets
-     * now.  virtnet_poll wants re-enable the queue, so we disable here.
-     * We synchronize against interrupts via NAPI_STATE_SCHED */
-    if (napi_schedule_prep(&vi->napi)) {
-        virtqueue_disable_cb(vi->rvq);
-        __napi_schedule(&vi->napi);
-    }
+    virtnet_napi_enable(vi);
     return 0;
 }


