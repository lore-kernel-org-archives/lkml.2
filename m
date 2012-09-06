Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760109Ab2IFAmM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 20:42:12 -0400
Received: from mga14.intel.com ([143.182.124.37]:14901 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759463Ab2IFAmK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 20:42:10 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,377,1344236400"; 
   d="scan'208";a="141980632"
From: "Liu, Chuansheng" <chuansheng.liu@intel.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: "'linux-kernel@vger.kernel.org' (linux-kernel@vger.kernel.org)" 
	<linux-kernel@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "airlied@redhat.com" <airlied@redhat.com>,
        "alexander.deucher@amd.com" <alexander.deucher@amd.com>,
        "Shi, Yang A" <yang.a.shi@intel.com>
Subject: RE: [Patch 0/1]drm_irq: Introducing the irq_thread support
Thread-Topic: [Patch 0/1]drm_irq: Introducing the irq_thread support
Thread-Index: AQHNi2RAGw34DfcXvEyjDrzHnr2E5pd8ebww
Date: Thu, 6 Sep 2012 00:42:05 +0000
Message-ID: <27240C0AC20F114CBF8149A2696CBE4A177FB6@SHSMSX101.ccr.corp.intel.com>
References: <27240C0AC20F114CBF8149A2696CBE4A177306@SHSMSX101.ccr.corp.intel.com>
 <20120905134932.00707b98@pyramind.ukuu.org.uk>
In-Reply-To: <20120905134932.00707b98@pyramind.ukuu.org.uk>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This possibly ought to be submitted in parallel with the code that uses it so that
> the whole proposal can be evaluated as one thing ?
> 
> Alan

Patch is here, thanks.

From: liu chuansheng <chuansheng.liu@intel.com>
Subject: [PATCH] drm_irq: Introducing the irq_thread support

For some GPUs, the irq handler need >1ms to handle the irq action.
And it will delay the whole system irq handler.

This patch is adding the irq thread support, it will make the drm_irq
interface more flexible.

The changes include:
1/ Change the request_irq to request_thread_irq, and add new callback
   irq_handler_t;
2/ Normally we need IRQF_ONESHOT flag support for irq thread, so add
   this option in drm_irq;

Cc: Shi Yang <yang.a.shi@intel.com>
Signed-off-by: liu chuansheng <chuansheng.liu@intel.com>
---
 drivers/gpu/drm/drm_irq.c |    8 ++++++--
 include/drm/drmP.h        |    2 ++
 2 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/drm_irq.c b/drivers/gpu/drm/drm_irq.c
index 03f16f3..bc105fe 100644
--- a/drivers/gpu/drm/drm_irq.c
+++ b/drivers/gpu/drm/drm_irq.c
@@ -345,13 +345,17 @@ int drm_irq_install(struct drm_device *dev)
        if (drm_core_check_feature(dev, DRIVER_IRQ_SHARED))
                sh_flags = IRQF_SHARED;
 
+       if (drm_core_check_feature(dev, DRIVER_IRQ_ONESHOT))
+               sh_flags |= IRQF_ONESHOT;
+
        if (dev->devname)
                irqname = dev->devname;
        else
                irqname = dev->driver->name;
 
-       ret = request_irq(drm_dev_to_irq(dev), dev->driver->irq_handler,
-                         sh_flags, irqname, dev);
+       ret = request_threaded_irq(drm_dev_to_irq(dev),
+               dev->driver->irq_handler, dev->driver->irq_handler_t,
+               sh_flags, irqname, dev);
 
        if (ret < 0) {
                mutex_lock(&dev->struct_mutex);
diff --git a/include/drm/drmP.h b/include/drm/drmP.h
index d6b67bb..b28be4b 100644
--- a/include/drm/drmP.h
+++ b/include/drm/drmP.h
@@ -152,6 +152,7 @@ int drm_err(const char *func, const char *format, ...);
 #define DRIVER_GEM         0x1000
 #define DRIVER_MODESET     0x2000
 #define DRIVER_PRIME       0x4000
+#define DRIVER_IRQ_ONESHOT 0x8000
 
 #define DRIVER_BUS_PCI 0x1
 #define DRIVER_BUS_PLATFORM 0x2
@@ -872,6 +873,7 @@ struct drm_driver {
        /* these have to be filled in */
 
        irqreturn_t(*irq_handler) (DRM_IRQ_ARGS);
+       irqreturn_t(*irq_handler_t) (DRM_IRQ_ARGS);
        void (*irq_preinstall) (struct drm_device *dev);
        int (*irq_postinstall) (struct drm_device *dev);
        void (*irq_uninstall) (struct drm_device *dev);
-- 
1.7.0.4
