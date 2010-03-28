Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754099Ab0C1LXT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Mar 2010 07:23:19 -0400
Received: from mail-bw0-f209.google.com ([209.85.218.209]:61275 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751647Ab0C1LXS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Mar 2010 07:23:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:mime-version
         :content-type:content-disposition:user-agent;
        b=gujIjUu+wUkXwA2DFZmu1ZTuZ+h6rrp2iIswTTFpGoOGlfchwMmraOcVk9tTvZMpSi
         TaMOcCVAqjJ7e6tBQWLIlCa/i3OxBdsqY0yqvvNsMMaS6yQg1eeaKtV33nFVm5t3QDHz
         TMFTSc/gcjQQSXdvsT0ERwe/9PHaBS1Z5v2LY=
Date: Sun, 28 Mar 2010 14:23:09 +0300
From: Dan Carpenter <error27@gmail.com>
To: Dave Airlie <airlied@redhat.com>
Cc: Alex Deucher <alexdeucher@gmail.com>, Jerome Glisse <jglisse@redhat.com>,
       =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
       dri-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: [patch] radeon: range check issues
Message-ID: <20100328112309.GJ5069@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Dave Airlie <airlied@redhat.com>,
	Alex Deucher <alexdeucher@gmail.com>,
	Jerome Glisse <jglisse@redhat.com>,
	=?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
	dri-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This change makes the array larger, "MAX_SUPPORTED_TV_TIMING_V1_2" is 3
and the original size "MAX_SUPPORTED_TV_TIMING" is 2.

Also there were checks that were off by one.

Signed-off-by: Dan Carpenter <error27@gmail.com>
---
Compile tested only.  Changing the array size seemed like the right
thing to do, in the context, but please review carefully.

diff --git a/drivers/gpu/drm/radeon/atombios.h b/drivers/gpu/drm/radeon/atombios.h
index 6732b5d..27e2c71 100644
--- a/drivers/gpu/drm/radeon/atombios.h
+++ b/drivers/gpu/drm/radeon/atombios.h
@@ -2912,7 +2912,7 @@ typedef struct _ATOM_ANALOG_TV_INFO_V1_2
   UCHAR                    ucTV_BootUpDefaultStandard; 
   UCHAR                    ucExt_TV_ASIC_ID;
   UCHAR                    ucExt_TV_ASIC_SlaveAddr;
-  ATOM_DTD_FORMAT          aModeTimings[MAX_SUPPORTED_TV_TIMING];
+  ATOM_DTD_FORMAT          aModeTimings[MAX_SUPPORTED_TV_TIMING_V1_2];
 }ATOM_ANALOG_TV_INFO_V1_2;
 
 typedef struct _ATOM_DPCD_INFO
diff --git a/drivers/gpu/drm/radeon/radeon_atombios.c b/drivers/gpu/drm/radeon/radeon_atombios.c
index 93783b1..bdc0ab3 100644
--- a/drivers/gpu/drm/radeon/radeon_atombios.c
+++ b/drivers/gpu/drm/radeon/radeon_atombios.c
@@ -1275,7 +1275,7 @@ bool radeon_atom_get_tv_timings(struct radeon_device *rdev, int index,
 	switch (crev) {
 	case 1:
 		tv_info = (ATOM_ANALOG_TV_INFO *)(mode_info->atom_context->bios + data_offset);
-		if (index > MAX_SUPPORTED_TV_TIMING)
+		if (index >= MAX_SUPPORTED_TV_TIMING)
 			return false;
 
 		mode->crtc_htotal = le16_to_cpu(tv_info->aModeTimings[index].usCRTC_H_Total);
@@ -1313,7 +1313,7 @@ bool radeon_atom_get_tv_timings(struct radeon_device *rdev, int index,
 		break;
 	case 2:
 		tv_info_v1_2 = (ATOM_ANALOG_TV_INFO_V1_2 *)(mode_info->atom_context->bios + data_offset);
-		if (index > MAX_SUPPORTED_TV_TIMING_V1_2)
+		if (index >= MAX_SUPPORTED_TV_TIMING_V1_2)
 			return false;
 
 		dtd_timings = &tv_info_v1_2->aModeTimings[index];

