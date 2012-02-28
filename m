Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965008Ab2B1BLX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 20:11:23 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:46792 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964973Ab2B1BIJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 20:08:09 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of gregkh@linuxfoundation.org designates 10.68.213.73 as permitted sender) smtp.mail=gregkh@linuxfoundation.org
MIME-Version: 1.0
Message-Id: <20120228010215.826821772@linuxfoundation.org>
User-Agent: quilt/0.51-17.1
Date: Mon, 27 Feb 2012 17:03:12 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Nikolaus Schulz <mail@microschulz.de>,
        Riku Voipio <riku.voipio@iki.fi>,
        Guenter Roeck <guenter.roeck@ericsson.com>
Subject: [ 69/73] hwmon: (f75375s) Fix register write order when setting fans to full speed
In-Reply-To: <20120228010246.GA24299@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nikolaus Schulz <schulz@macnetix.de>

commit c1c1a3d012fe5e82a9a025fb4b5a4f8ee67a53f6 upstream.

By hwmon sysfs interface convention, setting pwm_enable to zero sets a fan
to full speed.  In the f75375s driver, this need be done by enabling
manual fan control, plus duty mode for the F875387 chip, and then setting
the maximum duty cycle.  Fix a bug where the two necessary register writes
were swapped, effectively discarding the setting to full-speed.

Signed-off-by: Nikolaus Schulz <mail@microschulz.de>
Cc: Riku Voipio <riku.voipio@iki.fi>
Signed-off-by: Guenter Roeck <guenter.roeck@ericsson.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/hwmon/f75375s.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/hwmon/f75375s.c
+++ b/drivers/hwmon/f75375s.c
@@ -304,8 +304,6 @@ static int set_pwm_enable_direct(struct
 	case 0: /* Full speed */
 		fanmode  |= (3 << FAN_CTRL_MODE(nr));
 		data->pwm[nr] = 255;
-		f75375_write8(client, F75375_REG_FAN_PWM_DUTY(nr),
-				data->pwm[nr]);
 		break;
 	case 1: /* PWM */
 		fanmode  |= (3 << FAN_CTRL_MODE(nr));
@@ -318,6 +316,9 @@ static int set_pwm_enable_direct(struct
 	}
 	f75375_write8(client, F75375_REG_FAN_TIMER, fanmode);
 	data->pwm_enable[nr] = val;
+	if (val == 0)
+		f75375_write8(client, F75375_REG_FAN_PWM_DUTY(nr),
+				data->pwm[nr]);
 	return 0;
 }
 


