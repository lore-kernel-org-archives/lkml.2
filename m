Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756194Ab1I2OVV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 10:21:21 -0400
Received: from fnarfbargle.com ([93.93.131.224]:50609 "EHLO fnarfbargle.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752452Ab1I2OVT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 10:21:19 -0400
Message-ID: <4E847ED4.5090703@fnarfbargle.com>
Date: Thu, 29 Sep 2011 22:21:08 +0800
From: Brad Campbell <brad@fnarfbargle.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.21) Gecko/20110831 Lightning/1.0b2 Thunderbird/3.1.13
MIME-Version: 1.0
To: alexdeucher@gmail.com
CC: airlied@redhat.com, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Subject: Radeon regression fix
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes a regression introduced between 2.6.39 & 3.1-rc1 
whereby the displayport AUX channel stopped re-trying commands that 
elicited a DEFER response.

Signed-off-by: Brad Campbell <brad@fnarfbargle.com>

diff --git a/drivers/gpu/drm/radeon/atombios_dp.c 
b/drivers/gpu/drm/radeon/atombios_dp.c
index 7ad43c6..b8450f4 100644
--- a/drivers/gpu/drm/radeon/atombios_dp.c
+++ b/drivers/gpu/drm/radeon/atombios_dp.c
@@ -60,11 +60,13 @@ static int radeon_process_aux_ch(struct 
radeon_i2c_chan *chan,
  	int index = GetIndexIntoMasterTable(COMMAND, 
ProcessAuxChannelTransaction);
  	unsigned char *base;
  	int recv_bytes;
+	int retry_count = 0;

  	memset(&args, 0, sizeof(args));

  	base = (unsigned char *)rdev->mode_info.atom_context->scratch;

+retry:
  	memcpy(base, send, send_bytes);

  	args.v1.lpAuxRequest = 0;
@@ -79,6 +81,16 @@ static int radeon_process_aux_ch(struct 
radeon_i2c_chan *chan,

  	*ack = args.v1.ucReplyStatus;

+	/* defer */
+	if (args.v1.ucReplyStatus == 0x20){
+		DRM_DEBUG_KMS("dp_aux_ch defer\n");
+			/* 10 is an arbitrary value from the pre-regression patch
+			in practice I've never seen more than one */
+			if (retry_count++ < 10)
+				goto retry;
+		return -EBUSY;
+	}
+
  	/* timeout */
  	if (args.v1.ucReplyStatus == 1) {
  		DRM_DEBUG_KMS("dp_aux_ch timeout\n");
