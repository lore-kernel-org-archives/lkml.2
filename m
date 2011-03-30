Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965154Ab1C3VJb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 17:09:31 -0400
Received: from mga09.intel.com ([134.134.136.24]:9067 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964903Ab1C3VJ1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 17:09:27 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,270,1299484800"; 
   d="scan'208";a="621238672"
From: Andi Kleen <andi@firstfloor.org>
References: <20110330203.501921634@firstfloor.org>
In-Reply-To: <20110330203.501921634@firstfloor.org>
To: vivien.didelot@savoirfairelinux.com, khali@linux-fr.org,
        ak@linux.intel.com, jic23@cam.ac.uk, gregkh@suse.de,
        linux-kernel@vger.kernel.org, stable@kernel.org, tim.bird@am.sony.com
Subject: [PATCH] [220/275] hwmon: (sht15) Fix integer overflow in humidity calculation
Message-Id: <20110330210745.539DD3E1A05@tassilo.jf.intel.com>
Date: Wed, 30 Mar 2011 14:07:45 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Vivien Didelot <vivien.didelot@savoirfairelinux.com>

commit ccd32e735de7a941906e093f8dca924bb05c5794 upstream.

An integer overflow occurs in the calculation of RHlinear when the
relative humidity is greater than around 30%. The consequence is a subtle
(but noticeable) error in the resulting humidity measurement.

Signed-off-by: Vivien Didelot <vivien.didelot@savoirfairelinux.com>
Signed-off-by: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Andi Kleen <ak@linux.intel.com>
Cc: Jonathan Cameron <jic23@cam.ac.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/hwmon/sht15.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: linux-2.6.35.y/drivers/hwmon/sht15.c
===================================================================
--- linux-2.6.35.y.orig/drivers/hwmon/sht15.c	2011-03-29 22:50:29.011516087 -0700
+++ linux-2.6.35.y/drivers/hwmon/sht15.c	2011-03-29 23:03:02.824227904 -0700
@@ -333,11 +333,11 @@
 
 	const int c1 = -4;
 	const int c2 = 40500; /* x 10 ^ -6 */
-	const int c3 = -2800; /* x10 ^ -9 */
+	const int c3 = -28; /* x 10 ^ -7 */
 
 	RHlinear = c1*1000
 		+ c2 * data->val_humid/1000
-		+ (data->val_humid * data->val_humid * c3)/1000000;
+		+ (data->val_humid * data->val_humid * c3) / 10000;
 	return (temp - 25000) * (10000 + 80 * data->val_humid)
 		/ 1000000 + RHlinear;
 }
