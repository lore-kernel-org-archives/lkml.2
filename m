Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751933Ab1HaKFZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Aug 2011 06:05:25 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:22538 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751407Ab1HaKFY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Aug 2011 06:05:24 -0400
Date: Wed, 31 Aug 2011 12:05:13 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Guenter Roeck <guenter.roeck@ericsson.com>,
        lm-sensors@lm-sensors.org
Subject: Re: [PATCH v2] hwmon: (pmbus) Fix the logic of checking if no id is
  matched
Message-ID: <20110831120513.31bb62ee@endymion.delvare>
In-Reply-To: <1314766699.3960.1.camel@phoenix>
References: <1314766699.3960.1.camel@phoenix>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alex,

On Wed, 31 Aug 2011 12:58:19 +0800, Axel Lin wrote:
> If no id is matched, the mid pointer is not NULL in current implementation.

The NULL check is presumably there to catch the (impossible) case
ARRAY_SIZE(ucd9000_id) == 0 (array of ids is empty), not the case "no
id is matched". The initialization of mid to NULL is for the same
reason. Both should be unnecessary but may have been motivated by a
compiler warning (although I would think gcc is smart enough to not
emit these when it can check that the array isn't empty.) Guenter
should be able to tell more.

The check for "no id is matched" is !strlen(mid->name), which works as
intended as far as I can see. Did you actually hit a bug with the
current code? I bet not.

Now I would agree that the current code is somewhat misleading because
mixing null-terminated arrays with ARRAY_SIZE() is unusual (and
inefficient - the last iteration always fails.) Also, strlen() is
relatively slow and would rather be avoided when only testing if a
string is empty or not: it's faster to test for mid->name[0].

So if anything I would propose the following changes (for performance
and readability, NOT bug fix), untested:

--- linux-3.1-rc4.orig/drivers/hwmon/pmbus/ucd9000.c	2011-08-30 13:41:32.000000000 +0200
+++ linux-3.1-rc4/drivers/hwmon/pmbus/ucd9000.c	2011-08-31 11:53:28.000000000 +0200
@@ -141,13 +141,11 @@ static int ucd9000_probe(struct i2c_clie
 	block_buffer[ret] = '\0';
 	dev_info(&client->dev, "Device ID %s\n", block_buffer);
 
-	mid = NULL;
-	for (i = 0; i < ARRAY_SIZE(ucd9000_id); i++) {
-		mid = &ucd9000_id[i];
+	for (mid = ucd9000_id; mid->name[0]; mid++) {
 		if (!strncasecmp(mid->name, block_buffer, strlen(mid->name)))
 			break;
 	}
-	if (!mid || !strlen(mid->name)) {
+	if (!mid->name[0]) {
 		dev_err(&client->dev, "Unsupported device\n");
 		return -ENODEV;
 	}
--- linux-3.1-rc4.orig/drivers/hwmon/pmbus/ucd9200.c	2011-08-30 13:41:32.000000000 +0200
+++ linux-3.1-rc4/drivers/hwmon/pmbus/ucd9200.c	2011-08-31 11:53:20.000000000 +0200
@@ -68,13 +68,11 @@ static int ucd9200_probe(struct i2c_clie
 	block_buffer[ret] = '\0';
 	dev_info(&client->dev, "Device ID %s\n", block_buffer);
 
-	mid = NULL;
-	for (i = 0; i < ARRAY_SIZE(ucd9200_id); i++) {
-		mid = &ucd9200_id[i];
+	for (mid = ucd9200_id; mid->name[0]; mid++) {
 		if (!strncasecmp(mid->name, block_buffer, strlen(mid->name)))
 			break;
 	}
-	if (!mid || !strlen(mid->name)) {
+	if (!mid->name[0]) {
 		dev_err(&client->dev, "Unsupported device\n");
 		return -ENODEV;
 	}


> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> ---
> v2:
> It seems we don't need to check strlen(mid->name) here.
> If there is a match, strlen(mid->name) is always not 0.
> If ther is no match, comparing variable i with ARRAY_SIZE(ucd9000_id)
> or ARRAY_SIZE(ucd9200_id) is enough. 
> 
>  drivers/hwmon/pmbus/ucd9000.c |    3 +--
>  drivers/hwmon/pmbus/ucd9200.c |    3 +--
>  2 files changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/hwmon/pmbus/ucd9000.c b/drivers/hwmon/pmbus/ucd9000.c
> index 285bb15..a2d4a72 100644
> --- a/drivers/hwmon/pmbus/ucd9000.c
> +++ b/drivers/hwmon/pmbus/ucd9000.c
> @@ -141,13 +141,12 @@ static int ucd9000_probe(struct i2c_client *client,
>  	block_buffer[ret] = '\0';
>  	dev_info(&client->dev, "Device ID %s\n", block_buffer);
>  
> -	mid = NULL;
>  	for (i = 0; i < ARRAY_SIZE(ucd9000_id); i++) {
>  		mid = &ucd9000_id[i];
>  		if (!strncasecmp(mid->name, block_buffer, strlen(mid->name)))
>  			break;
>  	}
> -	if (!mid || !strlen(mid->name)) {
> +	if (i == ARRAY_SIZE(ucd9000_id)) {
>  		dev_err(&client->dev, "Unsupported device\n");
>  		return -ENODEV;
>  	}
> diff --git a/drivers/hwmon/pmbus/ucd9200.c b/drivers/hwmon/pmbus/ucd9200.c
> index 786f6cd..a72e55e 100644
> --- a/drivers/hwmon/pmbus/ucd9200.c
> +++ b/drivers/hwmon/pmbus/ucd9200.c
> @@ -68,13 +68,12 @@ static int ucd9200_probe(struct i2c_client *client,
>  	block_buffer[ret] = '\0';
>  	dev_info(&client->dev, "Device ID %s\n", block_buffer);
>  
> -	mid = NULL;
>  	for (i = 0; i < ARRAY_SIZE(ucd9200_id); i++) {
>  		mid = &ucd9200_id[i];
>  		if (!strncasecmp(mid->name, block_buffer, strlen(mid->name)))
>  			break;
>  	}
> -	if (!mid || !strlen(mid->name)) {
> +	if (i == ARRAY_SIZE(ucd9200_id)) {
>  		dev_err(&client->dev, "Unsupported device\n");
>  		return -ENODEV;
>  	}


-- 
Jean Delvare
