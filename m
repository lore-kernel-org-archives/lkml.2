Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756058Ab0HIKOL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Aug 2010 06:14:11 -0400
Received: from smtp-out-166.synserver.de ([212.40.180.166]:1073 "HELO
	smtp-out-165.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with SMTP id S1755836Ab0HIKOJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Aug 2010 06:14:09 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: markus@trippelsdorf.de
X-SynServer-PPID: 31059
Date: Mon, 9 Aug 2010 12:14:06 +0200
From: Markus Trippelsdorf <markus@trippelsdorf.de>
To: Tejun Heo <htejun@gmail.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>, walt <w41ter@gmail.com>,
        linux-kernel@vger.kernel.org,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        David Airlie <airlied@linux.ie>, DRI <dri-devel@lists.freedesktop.org>
Subject: Re: [PATCH wq#for-linus] drm: fix a fallout from slow-work -> wq
 conversion
Message-ID: <20100809101406.GA1633@arch.tripp.de>
References: <i3n3dh$t48$1@dough.gmane.org>
 <20100809063742.GA1632@arch.tripp.de>
 <20100809083053.GB2169@osiris.boeblingen.de.ibm.com>
 <20100809083451.GC2169@osiris.boeblingen.de.ibm.com>
 <4C5FC49B.9040208@kernel.org>
 <4C5FCC14.6030901@gmail.com>
 <20100809094630.GA1603@arch.tripp.de>
 <4C5FCF0C.2000100@gmail.com>
 <4C5FD1D1.9060302@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4C5FD1D1.9060302@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 09, 2010 at 12:00:49PM +0200, Tejun Heo wrote:
> Commit 991ea75c (drm: use workqueue instead of slow-work), which made
> drm to use wq instead of slow-work, didn't account for the return
> value difference between delayed_slow_work_enqueue() and
> queue_delayed_work().  The former returns 0 on success and -errno on
> failures while the latter never fails and only uses the return value
> to indicate whether the work was already pending or not.
> 
> This misconversion triggered spurious error messages.  Remove the now
> unnecessary return value check and error message.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Reported-by: Markus Trippelsdorf <markus@trippelsdorf.de>
> Cc: David Airlie <airlied@linux.ie>
> Cc: dri-devel@lists.freedesktop.org
> ---
> Markus, it's almost trivial but it would be great if you can test this
> one too.

Looks good, but drm_kms_helper_poll_disable needs the same treatment.


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
»A man who doesn't know he is in prison can never escape.«
William S. Burroughs
