Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756060Ab0HIKBt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Aug 2010 06:01:49 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:53300 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755835Ab0HIKBs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Aug 2010 06:01:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=L33OtnxMW1aecw0Ad1XJHblFead1r1daZTTMzBwl6VTLflhKECHO5g2z/M/9RyiBLC
         icxNliRwfsCYUIvv5VM1BeAbkriImLNKloYE/aUj2nl6AYexE4uOPtd59OoD5hublq5K
         sXPdpZCNFRk+faiRwG3sT+ad7lsbOgANTFIBU=
Message-ID: <4C5FD1D1.9060302@gmail.com>
Date: Mon, 09 Aug 2010 12:00:49 +0200
From: Tejun Heo <htejun@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.8) Gecko/20100802 Thunderbird/3.1.2
MIME-Version: 1.0
To: Markus Trippelsdorf <markus@trippelsdorf.de>
CC: Heiko Carstens <heiko.carstens@de.ibm.com>, walt <w41ter@gmail.com>,
        linux-kernel@vger.kernel.org,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        David Airlie <airlied@linux.ie>, DRI <dri-devel@lists.freedesktop.org>
Subject: [PATCH wq#for-linus] drm: fix a fallout from slow-work -> wq conversion
References: <i3n3dh$t48$1@dough.gmane.org> <20100809063742.GA1632@arch.tripp.de> <20100809083053.GB2169@osiris.boeblingen.de.ibm.com> <20100809083451.GC2169@osiris.boeblingen.de.ibm.com> <4C5FC49B.9040208@kernel.org> <4C5FCC14.6030901@gmail.com> <20100809094630.GA1603@arch.tripp.de> <4C5FCF0C.2000100@gmail.com>
In-Reply-To: <4C5FCF0C.2000100@gmail.com>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 991ea75c (drm: use workqueue instead of slow-work), which made
drm to use wq instead of slow-work, didn't account for the return
value difference between delayed_slow_work_enqueue() and
queue_delayed_work().  The former returns 0 on success and -errno on
failures while the latter never fails and only uses the return value
to indicate whether the work was already pending or not.

This misconversion triggered spurious error messages.  Remove the now
unnecessary return value check and error message.

Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-by: Markus Trippelsdorf <markus@trippelsdorf.de>
Cc: David Airlie <airlied@linux.ie>
Cc: dri-devel@lists.freedesktop.org
---
Markus, it's almost trivial but it would be great if you can test this
one too.

David, may I route this wq#for-linus?

Thanks.

 drivers/gpu/drm/drm_crtc_helper.c |    8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/drm_crtc_helper.c b/drivers/gpu/drm/drm_crtc_helper.c
index 4598130..211ed7e 100644
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
