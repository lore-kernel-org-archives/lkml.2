Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755541Ab1JKRGy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Oct 2011 13:06:54 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33651 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755062Ab1JKRGv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Oct 2011 13:06:51 -0400
X-Mailbox-Line: From gregkh@pistachio.kroah.org Tue Oct 11 10:57:11 2011
Message-Id: <20111011165710.903622924@pistachio.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Tue, 11 Oct 2011 10:55:27 -0600
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Alex Deucher <alexander.deucher@amd.com>,
        Brad Campbell <brad@fnarfbargle.com>, Dave Airlie <airlied@redhat.com>
Subject: [17/38] drm/radeon/kms: fix regression in DP aux defer handling
In-Reply-To: <20111011165903.GA30976@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit 109bc10d30f33e84f1d7289f0039e0c858ade82f upstream.

An incorrect ordering in the error checking code lead
to DP aux defer being skipped in the aux native write
path.  Move the bytes transferred check (ret == 0)
below the defer check.

Tracked down by: Brad Campbell <brad@fnarfbargle.com>

Fixes:
https://bugs.freedesktop.org/show_bug.cgi?id=41121

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: Brad Campbell <brad@fnarfbargle.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/radeon/atombios_dp.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/radeon/atombios_dp.c
+++ b/drivers/gpu/drm/radeon/atombios_dp.c
@@ -158,14 +158,14 @@ static int radeon_dp_aux_native_read(str
 	while (1) {
 		ret = radeon_process_aux_ch(dig_connector->dp_i2c_bus,
 					    msg, msg_bytes, recv, recv_bytes, delay, &ack);
-		if (ret == 0)
-			return -EPROTO;
 		if (ret < 0)
 			return ret;
 		if ((ack & AUX_NATIVE_REPLY_MASK) == AUX_NATIVE_REPLY_ACK)
 			return ret;
 		else if ((ack & AUX_NATIVE_REPLY_MASK) == AUX_NATIVE_REPLY_DEFER)
 			udelay(400);
+		else if (ret == 0)
+			return -EPROTO;
 		else
 			return -EIO;
 	}


