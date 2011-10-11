Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755551Ab1JKRHD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Oct 2011 13:07:03 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33664 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755062Ab1JKRHA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Oct 2011 13:07:00 -0400
X-Mailbox-Line: From gregkh@pistachio.kroah.org Tue Oct 11 10:57:11 2011
Message-Id: <20111011165711.046792794@pistachio.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Tue, 11 Oct 2011 10:55:28 -0600
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Alex Deucher <alexander.deucher@amd.com>,
        Brad Campbell <lists2009@fnarfbargle.com>,
        Dave Airlie <airlied@redhat.com>
Subject: [18/38] drm/radeon/kms: add retry limits for native DP aux defer
In-Reply-To: <20111011165903.GA30976@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit 6375bda073724ead7df08746866b724b1799a295 upstream.

The previous code could potentially loop forever.  Limit
the number of DP aux defer retries to 4 for native aux
transactions, same as i2c over aux transactions.

Noticed by: Brad Campbell <lists2009@fnarfbargle.com>

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: Brad Campbell <lists2009@fnarfbargle.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/radeon/atombios_dp.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

--- a/drivers/gpu/drm/radeon/atombios_dp.c
+++ b/drivers/gpu/drm/radeon/atombios_dp.c
@@ -115,6 +115,7 @@ static int radeon_dp_aux_native_write(st
 	u8 msg[20];
 	int msg_bytes = send_bytes + 4;
 	u8 ack;
+	unsigned retry;
 
 	if (send_bytes > 16)
 		return -1;
@@ -125,20 +126,20 @@ static int radeon_dp_aux_native_write(st
 	msg[3] = (msg_bytes << 4) | (send_bytes - 1);
 	memcpy(&msg[4], send, send_bytes);
 
-	while (1) {
+	for (retry = 0; retry < 4; retry++) {
 		ret = radeon_process_aux_ch(dig_connector->dp_i2c_bus,
 					    msg, msg_bytes, NULL, 0, delay, &ack);
 		if (ret < 0)
 			return ret;
 		if ((ack & AUX_NATIVE_REPLY_MASK) == AUX_NATIVE_REPLY_ACK)
-			break;
+			return send_bytes;
 		else if ((ack & AUX_NATIVE_REPLY_MASK) == AUX_NATIVE_REPLY_DEFER)
 			udelay(400);
 		else
 			return -EIO;
 	}
 
-	return send_bytes;
+	return -EIO;
 }
 
 static int radeon_dp_aux_native_read(struct radeon_connector *radeon_connector,
@@ -149,13 +150,14 @@ static int radeon_dp_aux_native_read(str
 	int msg_bytes = 4;
 	u8 ack;
 	int ret;
+	unsigned retry;
 
 	msg[0] = address;
 	msg[1] = address >> 8;
 	msg[2] = AUX_NATIVE_READ << 4;
 	msg[3] = (msg_bytes << 4) | (recv_bytes - 1);
 
-	while (1) {
+	for (retry = 0; retry < 4; retry++) {
 		ret = radeon_process_aux_ch(dig_connector->dp_i2c_bus,
 					    msg, msg_bytes, recv, recv_bytes, delay, &ack);
 		if (ret < 0)
@@ -169,6 +171,8 @@ static int radeon_dp_aux_native_read(str
 		else
 			return -EIO;
 	}
+
+	return -EIO;
 }
 
 static void radeon_write_dpcd_reg(struct radeon_connector *radeon_connector,


