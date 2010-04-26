Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754339Ab0DZSWI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Apr 2010 14:22:08 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:59670 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754253Ab0DZSWF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Apr 2010 14:22:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=x5qj+0xU6heIyugMXFcDvXfEeBlnCsyPDiEZlu+qXWONaXsSsyFwOizkDIlFzj+jbq
         E4ILvh7K5mjybJOQhNmqBpr9NxpjpiwYVupW2YZoRq6ZALhwOeisFcUaAyagOtSSDc/l
         V1f2XNApdxqMJY2SvFszNsZWOCrVoS6EL/UUc=
Date: Mon, 26 Apr 2010 22:22:00 +0400
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Mike Rapoport <mike@compulab.co.il>
Cc: Ryan Mallon <ryan@bluewatersys.com>, linux-kernel@vger.kernel.org,
       Yulia Vilensky <vilensky@compulab.co.il>
Subject: Re: [PATCH v3] ds2782_battery: add support for ds2786 battery gas
 gauge
Message-ID: <20100426182200.GA18024@oksana.dev.rtsoft.ru>
References: <1272279925-3122-1-git-send-email-mike@compulab.co.il>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1272279925-3122-1-git-send-email-mike@compulab.co.il>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 26, 2010 at 02:05:25PM +0300, Mike Rapoport wrote:
> From: Yulia Vilensky <vilensky@compulab.co.il>
> 
> v2 changes:
>  * add ds278x_platform_data
>  * address Anton comments
> v3 changes:
>  * use ds278x_get_temp for both ds2782 and ds2786
>  * update math as per Ryan comments
> 
> Signed-off-by: Yulia Vilensky <vilensky@compulab.co.il>
> Signed-off-by: Mike Rapoport <mike@compulab.co.il>

Thanks, applied to battery-2.6 with the following change
(we shouldn't compare pointers and integers):

diff --git a/drivers/power/ds2782_battery.c b/drivers/power/ds2782_battery.c
index 6b3cee0..c665e80 100644
--- a/drivers/power/ds2782_battery.c
+++ b/drivers/power/ds2782_battery.c
@@ -325,7 +325,7 @@ static int ds278x_battery_probe(struct i2c_client *client,
 	 * ds2786 should have the sense resistor value set
 	 * in the platform data
 	 */
-	if (id->driver_data == 1 && pdata == 0) {
+	if (id->driver_data == 1 && !pdata) {
 		dev_err(&client->dev, "missing platform data for ds2786\n");
 		return -EINVAL;
 	}

----

Btw, I don't quite like the 'if (id->driver_data == 1)' stuff.
How about the following patch on top?

>From acf917d3880465b76875f671ee450a8fdff62c9f Mon Sep 17 00:00:00 2001
From: Anton Vorontsov <cbouatmailru@gmail.com>
Date: Mon, 26 Apr 2010 22:10:52 +0400
Subject: [PATCH] ds2782_battery: Get rid of magic numbers in driver_data

Constructions like 'if (id->driver_data == 1)' look quite weird.
This patch introduces 'enum ds278x_num_id', which makes things
much more understandable, i.e. 'if (id->driver_data == DS2786)'.

Signed-off-by: Anton Vorontsov <cbouatmailru@gmail.com>
---
 drivers/power/ds2782_battery.c |   17 +++++++++++------
 1 files changed, 11 insertions(+), 6 deletions(-)

diff --git a/drivers/power/ds2782_battery.c b/drivers/power/ds2782_battery.c
index c665e80..d762a0c 100644
--- a/drivers/power/ds2782_battery.c
+++ b/drivers/power/ds2782_battery.c
@@ -300,13 +300,18 @@ static int ds278x_battery_remove(struct i2c_client *client)
 	return 0;
 }
 
+enum ds278x_num_id {
+	DS2782 = 0,
+	DS2786,
+};
+
 static struct ds278x_battery_ops ds278x_ops[] = {
-	[0] = {
+	[DS2782] = {
 		.get_current  = ds2782_get_current,
 		.get_voltage  = ds2782_get_voltage,
 		.get_capacity = ds2782_get_capacity,
 	},
-	[1] = {
+	[DS2786] = {
 		.get_current  = ds2786_get_current,
 		.get_voltage  = ds2786_get_voltage,
 		.get_capacity = ds2786_get_capacity,
@@ -325,7 +330,7 @@ static int ds278x_battery_probe(struct i2c_client *client,
 	 * ds2786 should have the sense resistor value set
 	 * in the platform data
 	 */
-	if (id->driver_data == 1 && !pdata) {
+	if (id->driver_data == DS2786 && !pdata) {
 		dev_err(&client->dev, "missing platform data for ds2786\n");
 		return -EINVAL;
 	}
@@ -355,7 +360,7 @@ static int ds278x_battery_probe(struct i2c_client *client,
 		goto fail_name;
 	}
 
-	if (id->driver_data == 1)
+	if (id->driver_data == DS2786)
 		info->rsns = pdata->rsns;
 
 	i2c_set_clientdata(client, info);
@@ -385,8 +390,8 @@ fail_id:
 }
 
 static const struct i2c_device_id ds278x_id[] = {
-	{"ds2782", 0},
-	{"ds2786", 1},
+	{"ds2782", DS2782},
+	{"ds2786", DS2786},
 	{},
 };
 
-- 
1.7.0.5

