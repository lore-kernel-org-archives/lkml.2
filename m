Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933875Ab2DKXQ0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 19:16:26 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:35695 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933825Ab2DKXQV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 19:16:21 -0400
Message-Id: <20120411231023.489450259@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Wed, 11 Apr 2012 16:10:49 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Paul Stewart <pstew@google.com>,
        Gary Morain <gmorain@google.com>,
        Madhan Jaganathan <madhanj@qca.qualcomm.com>,
        Rajkumar Manoharan <rmanohar@qca.qualcomm.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [ 31/78] ath9k: fix max noise floor threshold
In-Reply-To: <20120411231102.GA6404@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>

commit 2ee0a07028d2cde6e131b73f029dae2b93c50f3a upstream.

Currently the maximum noise floor limit is set as too high (-60dB). The
assumption of having a higher threshold limit is that it would help
de-sensitize the receiver (reduce phy errors) from continuous
interference. But when we have a bursty interference where there are
collisions and then free air time and if the receiver is desensitized too
much, it will miss the normal packets too. Lets make use of chips
specific min, nom and max limits always. This patch helps to improve the
connection stability in congested networks.

Cc: Paul Stewart <pstew@google.com>
Tested-by: Gary Morain <gmorain@google.com>
Signed-off-by: Madhan Jaganathan <madhanj@qca.qualcomm.com>
Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/ath/ath9k/calib.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/drivers/net/wireless/ath/ath9k/calib.c
+++ b/drivers/net/wireless/ath/ath9k/calib.c
@@ -20,7 +20,6 @@
 
 /* Common calibration code */
 
-#define ATH9K_NF_TOO_HIGH	-60
 
 static int16_t ath9k_hw_get_nf_hist_mid(int16_t *nfCalBuffer)
 {
@@ -346,10 +345,10 @@ static void ath9k_hw_nf_sanitize(struct
 			"NF calibrated [%s] [chain %d] is %d\n",
 			(i >= 3 ? "ext" : "ctl"), i % 3, nf[i]);
 
-		if (nf[i] > ATH9K_NF_TOO_HIGH) {
+		if (nf[i] > limit->max) {
 			ath_dbg(common, CALIBRATE,
 				"NF[%d] (%d) > MAX (%d), correcting to MAX\n",
-				i, nf[i], ATH9K_NF_TOO_HIGH);
+				i, nf[i], limit->max);
 			nf[i] = limit->max;
 		} else if (nf[i] < limit->min) {
 			ath_dbg(common, CALIBRATE,


