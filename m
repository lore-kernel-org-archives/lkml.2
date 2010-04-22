Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758288Ab0DVUUg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 16:20:36 -0400
Received: from kroah.org ([198.145.64.141]:59757 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758010Ab0DVUAd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 16:00:33 -0400
X-Mailbox-Line: From gregkh@kvm.kroah.org Thu Apr 22 12:54:11 2010
Message-Id: <20100422195411.184387110@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Thu, 22 Apr 2010 12:54:01 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Jerome Oufella <jerome.oufella@savoirfairelinux.com>,
       Jonathan Cameron <jic23@cam.ac.uk>, Jean Delvare <khali@linux-fr.org>
Subject: [064/139] hwmon: (sht15) Fix sht15_calc_temp interpolation function
In-Reply-To: <20100422195715.GA25490@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Jerome Oufella <jerome.oufella@savoirfairelinux.com>

commit 328a2c22abd08911e37fa66f1358f829cecd72e9 upstream.

I discovered two issues.
First the previous sht15_calc_temp() loop did not iterate through the
temppoints array since the (data->supply_uV > temppoints[i - 1].vdd)
test is always true in this direction.

Also the two-points linear interpolation function was returning biased
values due to a stray division by 1000 which shouldn't be there.

[JD: Also change the default value for d1 from 0 to something saner.]

Signed-off-by: Jerome Oufella <jerome.oufella@savoirfairelinux.com>
Acked-by: Jonathan Cameron <jic23@cam.ac.uk>
Signed-off-by: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/hwmon/sht15.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/hwmon/sht15.c
+++ b/drivers/hwmon/sht15.c
@@ -302,13 +302,13 @@ error_ret:
  **/
 static inline int sht15_calc_temp(struct sht15_data *data)
 {
-	int d1 = 0;
+	int d1 = temppoints[0].d1;
 	int i;
 
-	for (i = 1; i < ARRAY_SIZE(temppoints); i++)
+	for (i = ARRAY_SIZE(temppoints) - 1; i > 0; i--)
 		/* Find pointer to interpolate */
 		if (data->supply_uV > temppoints[i - 1].vdd) {
-			d1 = (data->supply_uV/1000 - temppoints[i - 1].vdd)
+			d1 = (data->supply_uV - temppoints[i - 1].vdd)
 				* (temppoints[i].d1 - temppoints[i - 1].d1)
 				/ (temppoints[i].vdd - temppoints[i - 1].vdd)
 				+ temppoints[i - 1].d1;


