Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756094Ab0HIKVM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Aug 2010 06:21:12 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:55178 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755835Ab0HIKVK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Aug 2010 06:21:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=s+BWCzy15rpTjE4Ver/OdulxAWq+SuPcyhGVYbXhvlfq8MQbUHnmV7nZvrV0W0yQur
         5GpvZ5AgmY/JGHDPbTC+9i2j7DYv9FP+RphJwGZhwGt2mZEZHNM/i5GFqHH/LETGo5va
         bx2ukn1lgpcnvCAGynZb0d7rsk6onp0h/0XPE=
Message-ID: <4C5FD65B.8080800@gmail.com>
Date: Mon, 09 Aug 2010 12:20:11 +0200
From: Tejun Heo <htejun@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.8) Gecko/20100802 Thunderbird/3.1.2
MIME-Version: 1.0
To: Markus Trippelsdorf <markus@trippelsdorf.de>
CC: Heiko Carstens <heiko.carstens@de.ibm.com>, walt <w41ter@gmail.com>,
        linux-kernel@vger.kernel.org,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        David Airlie <airlied@linux.ie>, DRI <dri-devel@lists.freedesktop.org>
Subject: [PATCH] drm: fix fallouts from slow-work -> wq conversion
References: <i3n3dh$t48$1@dough.gmane.org> <20100809063742.GA1632@arch.tripp.de> <20100809083053.GB2169@osiris.boeblingen.de.ibm.com> <20100809083451.GC2169@osiris.boeblingen.de.ibm.com> <4C5FC49B.9040208@kernel.org> <4C5FCC14.6030901@gmail.com> <20100809094630.GA1603@arch.tripp.de> <4C5FCF0C.2000100@gmail.com> <4C5FD1D1.9060302@gmail.com> <20100809101406.GA1633@arch.tripp.de>
In-Reply-To: <20100809101406.GA1633@arch.tripp.de>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 9a919c46dfa48a9c1f465174609b90253eb8ffc1 Mon Sep 17 00:00:00 2001
From: Tejun Heo <tj@kernel.org>
Date: Mon, 9 Aug 2010 12:01:27 +0200

Commit 991ea75c (drm: use workqueue instead of slow-work), which made
drm to use wq instead of slow-work, didn't account for the return
value difference between delayed_slow_work_enqueue() and
queue_delayed_work().  The former returns 0 on success and -errno on
failures while the latter never fails and only uses the return value
to indicate whether the work was already pending or not.

This misconversion triggered spurious error messages.  Remove the now
unnecessary return value check and error message.

Markus: caught another incorrect conversion in drm_kms_helper_poll_enable()

Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-by: Markus Trippelsdorf <markus@trippelsdorf.de>
Tested-by: Markus Trippelsdorf <markus@trippelsdorf.de>
Cc: David Airlie <airlied@linux.ie>
Cc: dri-devel@lists.freedesktop.org
---
Oops, you're right.  So, this should do it.

Thank you.

 drivers/gpu/drm/drm_crtc_helper.c |   16 ++++------------
 1 files changed, 4 insertions(+), 12 deletions(-)

diff --git a/drivers/gpu/drm/drm_crtc_helper.c b/drivers/gpu/drm/drm_crtc_helper.c
index 4598130..b9e4dbf 100644
--- a/drivers/gpu/drm/drm_crtc_helper.c
+++ b/drivers/gpu/drm/drm_crtc_helper.c
@@ -839,7 +839,6 @@ static void output_poll_execute(struct work_struct *work)
 	struct drm_connector *connector;
 	enum drm_connector_status old_status, status;
 	bool repoll = false, changed = false;
-	int ret;

 	mutex_lock(&dev->mode_config.mutex);
 	list_for_each_entry(connector, &dev->mode_config.connector_list, head) {
@@ -874,11 +873,8 @@ static void output_poll_execute(struct work_struct *work)
 			dev->mode_config.funcs->output_poll_changed(dev);
 	}

-	if (repoll) {
-		ret = queue_delayed_work(system_nrt_wq, delayed_work, DRM_OUTPUT_POLL_PERIOD);
-		if (ret)
-			DRM_ERROR("delayed enqueue failed %d\n", ret);
-	}
+	if (repoll)
+		queue_delayed_work(system_nrt_wq, delayed_work, DRM_OUTPUT_POLL_PERIOD);
 }

 void drm_kms_helper_poll_disable(struct drm_device *dev)
@@ -893,18 +889,14 @@ void drm_kms_helper_poll_enable(struct drm_device *dev)
 {
 	bool poll = false;
 	struct drm_connector *connector;
-	int ret;

 	list_for_each_entry(connector, &dev->mode_config.connector_list, head) {
 		if (connector->polled)
 			poll = true;
 	}

-	if (poll) {
-		ret = queue_delayed_work(system_nrt_wq, &dev->mode_config.output_poll_work, DRM_OUTPUT_POLL_PERIOD);
-		if (ret)
-			DRM_ERROR("delayed enqueue failed %d\n", ret);
-	}
+	if (poll)
+		queue_delayed_work(system_nrt_wq, &dev->mode_config.output_poll_work, DRM_OUTPUT_POLL_PERIOD);
 }
 EXPORT_SYMBOL(drm_kms_helper_poll_enable);

-- 
1.7.1

