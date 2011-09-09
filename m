Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932491Ab1IISAk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Sep 2011 14:00:40 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:33778 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753205Ab1IISAi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Sep 2011 14:00:38 -0400
Date: Fri, 9 Sep 2011 11:00:31 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: John Sung <penmount.touch@gmail.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] Input: penmount - add PenMount 6000 support
Message-ID: <20110909180031.GA32383@core.coreip.homeip.net>
References: <1315555667-5893-1-git-send-email-penmount.touch@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1315555667-5893-1-git-send-email-penmount.touch@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi John,

On Fri, Sep 09, 2011 at 04:07:45PM +0800, John Sung wrote:
> Add support for PenMount 6000 touch controller.
> 
> Signed-off-by: John Sung <penmount.touch@gmail.com>
> ---
>  drivers/input/touchscreen/penmount.c |   64 +++++++++++++++++++++++++++++----
>  1 files changed, 56 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/input/touchscreen/penmount.c b/drivers/input/touchscreen/penmount.c
> index 3342c6d..240f6a2 100644
> --- a/drivers/input/touchscreen/penmount.c
> +++ b/drivers/input/touchscreen/penmount.c
> @@ -33,7 +33,7 @@ MODULE_LICENSE("GPL");
>   * Definitions & global arrays.
>   */
>  
> -#define	PM_MAX_LENGTH	5
> +#define	PM_MAX_LENGTH	6
>  
>  /*
>   * Per-touchscreen data.
> @@ -45,8 +45,25 @@ struct pm {
>  	int idx;
>  	unsigned char data[PM_MAX_LENGTH];
>  	char phys[32];
> +	unsigned char packetsize;
>  };
>  
> +/*
> + * pm_checkpacket() checks if data packet is valid
> + */
> +
> +static int pm_checkpacket(unsigned char *packet) {
> +	int i = 0;
> +	int total = 0;
> +	for (i = 0; i < 5; i++)
> +		total += packet[i];

This violates our coding standards: open brace for functions should be
on a new line, there should be an empty line between variable
declarations and the code.

Also, since the function returns, in effect, a boolean value, we should
declare it that way.

I've adjusted the patch as follows.

Thanks.

-- 
Dmitry

Input: penmount - add PenMount 6000 support

From: John Sung <penmount.touch@gmail.com>

Add support for PenMount 6000 touch controller.

Signed-off-by: John Sung <penmount.touch@gmail.com>
Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
---

 drivers/input/touchscreen/penmount.c |   65 ++++++++++++++++++++++++++++++----
 1 files changed, 57 insertions(+), 8 deletions(-)


diff --git a/drivers/input/touchscreen/penmount.c b/drivers/input/touchscreen/penmount.c
index 3342c6d..e9117ad 100644
--- a/drivers/input/touchscreen/penmount.c
+++ b/drivers/input/touchscreen/penmount.c
@@ -33,7 +33,7 @@ MODULE_LICENSE("GPL");
  * Definitions & global arrays.
  */
 
-#define	PM_MAX_LENGTH	5
+#define	PM_MAX_LENGTH	6
 
 /*
  * Per-touchscreen data.
@@ -45,8 +45,24 @@ struct pm {
 	int idx;
 	unsigned char data[PM_MAX_LENGTH];
 	char phys[32];
+	unsigned char packetsize;
 };
 
+/*
+ * pm_checkpacket() checks if data packet is valid
+ */
+
+static bool pm_checkpacket(unsigned char *packet)
+{
+	int total = 0;
+	int i;
+
+	for (i = 0; i < 5; i++)
+		total += packet[i];
+
+	return packet[5] == (unsigned char)~(total & 0xff);
+}
+
 static irqreturn_t pm_interrupt(struct serio *serio,
 		unsigned char data, unsigned int flags)
 {
@@ -55,14 +71,34 @@ static irqreturn_t pm_interrupt(struct serio *serio,
 
 	pm->data[pm->idx] = data;
 
-	if (pm->data[0] & 0x80) {
-		if (PM_MAX_LENGTH == ++pm->idx) {
-			input_report_abs(dev, ABS_X, pm->data[1] * 128 + pm->data[2]);
-			input_report_abs(dev, ABS_Y, pm->data[3] * 128 + pm->data[4]);
-			input_report_key(dev, BTN_TOUCH, !!(pm->data[0] & 0x40));
-			input_sync(dev);
-			pm->idx = 0;
+	switch (pm->dev->id.product) {
+	case 0x9000:
+		if (pm->data[0] & 0x80) {
+			if (pm->packetsize == ++pm->idx) {
+				input_report_abs(dev, ABS_X, pm->data[1] * 128 + pm->data[2]);
+				input_report_abs(dev, ABS_Y, pm->data[3] * 128 + pm->data[4]);
+				input_report_key(dev, BTN_TOUCH, !!(pm->data[0] & 0x40));
+				input_sync(dev);
+				pm->idx = 0;
+			}
+		}
+		break;
+
+	case 0x6000:
+		if ((pm->data[0] & 0xbf) == 0x30) {
+			if (pm->packetsize == ++pm->idx) {
+				if (pm_checkpacket(pm->data)) {
+					input_report_abs(dev, ABS_X,
+							pm->data[2] * 256 + pm->data[1]);
+					input_report_abs(dev, ABS_Y,
+							pm->data[4] * 256 + pm->data[3]);
+					input_report_key(dev, BTN_TOUCH, !!(pm->data[0] & 0x40));
+					input_sync(dev);
+				}
+				pm->idx = 0;
+			}
 		}
+		break;
 	}
 
 	return IRQ_HANDLED;
@@ -120,6 +156,19 @@ static int pm_connect(struct serio *serio, struct serio_driver *drv)
         input_set_abs_params(pm->dev, ABS_X, 0, 0x3ff, 0, 0);
         input_set_abs_params(pm->dev, ABS_Y, 0, 0x3ff, 0, 0);
 
+	switch (serio->id.id) {
+	default:
+	case 0:
+		pm->packetsize = 5;
+		input_dev->id.product = 0x9000;
+		break;
+
+	case 1:
+		pm->packetsize = 6;
+		input_dev->id.product = 0x6000;
+		break;
+	}
+
 	serio_set_drvdata(serio, pm);
 
 	err = serio_open(serio, drv);
