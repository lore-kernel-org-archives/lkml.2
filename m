Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965173Ab2B1BL4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 20:11:56 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:58461 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965158Ab2B1BLw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 20:11:52 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of gregkh@linuxfoundation.org designates 10.68.220.168 as permitted sender) smtp.mail=gregkh@linuxfoundation.org
MIME-Version: 1.0
Message-Id: <20120228010433.981169612@linuxfoundation.org>
User-Agent: quilt/0.51-17.1
Date: Mon, 27 Feb 2012 17:05:21 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Guenter Roeck <guenter.roeck@ericsson.com>,
        Dirk Eibach <eibach@gdsys.de>, Jean Delvare <khali@linux-fr.org>
Subject: [ 52/72] hwmon: (ads1015) Fix file leak in probe function
In-Reply-To: <20120228010511.GA8453@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guenter Roeck <guenter.roeck@ericsson.com>

commit 363434b5dc352464ac7601547891e5fc9105f124 upstream.

An error while creating sysfs attribute files in the driver's probe function
results in an error abort, but already created files are not removed. This patch
fixes the problem.

Signed-off-by: Guenter Roeck <guenter.roeck@ericsson.com>
Cc: Dirk Eibach <eibach@gdsys.de>
Acked-by: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/hwmon/ads1015.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/hwmon/ads1015.c
+++ b/drivers/hwmon/ads1015.c
@@ -271,7 +271,7 @@ static int ads1015_probe(struct i2c_clie
 			continue;
 		err = device_create_file(&client->dev, &ads1015_in[k].dev_attr);
 		if (err)
-			goto exit_free;
+			goto exit_remove;
 	}
 
 	data->hwmon_dev = hwmon_device_register(&client->dev);
@@ -285,7 +285,6 @@ static int ads1015_probe(struct i2c_clie
 exit_remove:
 	for (k = 0; k < ADS1015_CHANNELS; ++k)
 		device_remove_file(&client->dev, &ads1015_in[k].dev_attr);
-exit_free:
 	kfree(data);
 exit:
 	return err;


