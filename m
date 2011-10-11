Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755428Ab1JKRFq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Oct 2011 13:05:46 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33405 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755062Ab1JKRFo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Oct 2011 13:05:44 -0400
X-Mailbox-Line: From gregkh@pistachio.kroah.org Tue Oct 11 10:57:13 2011
Message-Id: <20111011165712.936325301@pistachio.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Tue, 11 Oct 2011 10:55:40 -0600
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Alex Deucher <alexander.deucher@amd.com>,
        Dave Airlie <airlied@redhat.com>
Subject: [30/38] drm/radeon/kms: retry aux transactions if there are status flags
In-Reply-To: <20111011165903.GA30976@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit 4f332844cc87c5f99c5300f788abbe8a8c731390 upstream.

If there are error flags in the aux status, retry the transaction.
This makes aux much more reliable, especially on llano systems.

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Reviewed-by: Michel Dänzer <michel.daenzer@amd.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/radeon/atombios_dp.c |   12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

--- a/drivers/gpu/drm/radeon/atombios_dp.c
+++ b/drivers/gpu/drm/radeon/atombios_dp.c
@@ -129,7 +129,9 @@ static int radeon_dp_aux_native_write(st
 	for (retry = 0; retry < 4; retry++) {
 		ret = radeon_process_aux_ch(dig_connector->dp_i2c_bus,
 					    msg, msg_bytes, NULL, 0, delay, &ack);
-		if (ret < 0)
+		if (ret == -EBUSY)
+			continue;
+		else if (ret < 0)
 			return ret;
 		if ((ack & AUX_NATIVE_REPLY_MASK) == AUX_NATIVE_REPLY_ACK)
 			return send_bytes;
@@ -160,7 +162,9 @@ static int radeon_dp_aux_native_read(str
 	for (retry = 0; retry < 4; retry++) {
 		ret = radeon_process_aux_ch(dig_connector->dp_i2c_bus,
 					    msg, msg_bytes, recv, recv_bytes, delay, &ack);
-		if (ret < 0)
+		if (ret == -EBUSY)
+			continue;
+		else if (ret < 0)
 			return ret;
 		if ((ack & AUX_NATIVE_REPLY_MASK) == AUX_NATIVE_REPLY_ACK)
 			return ret;
@@ -236,7 +240,9 @@ int radeon_dp_i2c_aux_ch(struct i2c_adap
 	for (retry = 0; retry < 4; retry++) {
 		ret = radeon_process_aux_ch(auxch,
 					    msg, msg_bytes, reply, reply_bytes, 0, &ack);
-		if (ret < 0) {
+		if (ret == -EBUSY)
+			continue;
+		else if (ret < 0) {
 			DRM_DEBUG_KMS("aux_ch failed %d\n", ret);
 			return ret;
 		}


