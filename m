Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932069Ab0LHB77 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 20:59:59 -0500
Received: from kroah.org ([198.145.64.141]:48434 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756739Ab0LHA7U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 19:59:20 -0500
X-Mailbox-Line: From gregkh@clark.site Tue Dec  7 16:57:23 2010
Message-Id: <20101208005723.901036605@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 07 Dec 2010 16:56:42 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Senthil Balasubramanian <senthilkumar@atheros.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [025/289] ath9k_hw: Fix divide by zero cases in paprd.
In-Reply-To: <20101208005821.GA2922@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Senthil Balasubramanian <senthilkumar@atheros.com>

commit 2d3fca180710c6832de22c44155ce6a3a4953c6b upstream.

We are not handling all divide by zero cases in paprd.
Add additional checks for divide by zero cases in papard.

This patch has fixes intended for kernel 2.6.36.

Signed-off-by: Senthil Balasubramanian <senthilkumar@atheros.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/ath/ath9k/ar9003_paprd.c |   14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

--- a/drivers/net/wireless/ath/ath9k/ar9003_paprd.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_paprd.c
@@ -347,6 +347,10 @@ static bool create_pa_curve(u32 *data_L,
 	    (((Y[6] - Y[3]) * 1 << scale_factor) +
 	     (x_est[6] - x_est[3])) / (x_est[6] - x_est[3]);
 
+	/* prevent division by zero */
+	if (G_fxp == 0)
+		return false;
+
 	Y_intercept =
 	    (G_fxp * (x_est[0] - x_est[3]) +
 	     (1 << scale_factor)) / (1 << scale_factor) + Y[3];
@@ -356,14 +360,12 @@ static bool create_pa_curve(u32 *data_L,
 
 	for (i = 0; i <= 3; i++) {
 		y_est[i] = i * 32;
-
-		/* prevent division by zero */
-		if (G_fxp == 0)
-			return false;
-
 		x_est[i] = ((y_est[i] * 1 << scale_factor) + G_fxp) / G_fxp;
 	}
 
+	if (y_est[max_index] == 0)
+		return false;
+
 	x_est_fxp1_nonlin =
 	    x_est[max_index] - ((1 << scale_factor) * y_est[max_index] +
 				G_fxp) / G_fxp;
@@ -457,6 +459,8 @@ static bool create_pa_curve(u32 *data_L,
 
 	Q_scale_B = find_proper_scale(find_expn(abs(scale_B)), 10);
 	scale_B = scale_B / (1 << Q_scale_B);
+	if (scale_B == 0)
+		return false;
 	Q_beta = find_proper_scale(find_expn(abs(beta_raw)), 10);
 	Q_alpha = find_proper_scale(find_expn(abs(alpha_raw)), 10);
 	beta_raw = beta_raw / (1 << Q_beta);


