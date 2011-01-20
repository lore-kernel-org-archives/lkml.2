Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754744Ab1ATAiQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 19:38:16 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44727 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753873Ab1ATAiP convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 19:38:15 -0500
Date: Wed, 19 Jan 2011 16:37:58 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Mike Frysinger <vapier@gentoo.org>
Cc: linux-kernel@vger.kernel.org, device-drivers-devel@blackfin.uclinux.org
Subject: Re: [PATCH] sigma-firmware: loader for Analog Devices' SigmaStudio
Message-Id: <20110119163758.bb43d4ff.akpm@linux-foundation.org>
In-Reply-To: <1294810891-23348-1-git-send-email-vapier@gentoo.org>
References: <1294810891-23348-1-git-send-email-vapier@gentoo.org>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Jan 2011 00:41:31 -0500
Mike Frysinger <vapier@gentoo.org> wrote:

> Analog Devices' SigmaStudio can produce firmware blobs for devices with
> these DSPs embedded (like some audio codecs).  Allow these device drivers
> to easily parse and load them.
> 
> Signed-off-by: Mike Frysinger <vapier@gentoo.org>
> ---
>  drivers/firmware/Kconfig  |   12 +++++
>  drivers/firmware/Makefile |    1 +
>  drivers/firmware/sigma.c  |  110 +++++++++++++++++++++++++++++++++++++++++++++
>  include/linux/sigma.h     |   60 ++++++++++++++++++++++++

The newly-added code has no callsites.  What are we to make of this?

> diff --git a/drivers/firmware/Kconfig b/drivers/firmware/Kconfig
> index e8b6a13..8f4f7b2 100644
> --- a/drivers/firmware/Kconfig
> +++ b/drivers/firmware/Kconfig
> @@ -134,4 +134,16 @@ config ISCSI_IBFT
>  	  detect iSCSI boot parameters dynamically during system boot, say Y.
>  	  Otherwise, say N.
>  
> +config SIGMA
> +	tristate "SigmaStudio firmware loader"
> +	depends on I2C

The dependence on just I2C looks odd.  What's the rationale here?

> +	select CRC32
> +	default n
> +	help
> +	  Enable helper functions for working with Analog Devices SigmaDSP
> +	  parts and binary firmwares produced by Analog Devices SigmaStudio.
> +
> +	  If unsure, say N here.  Drivers that need these helpers will select
> +	  this option automatically.
> +
>  endmenu
> diff --git a/drivers/firmware/Makefile b/drivers/firmware/Makefile
> index 1c3c173..ede9722 100644
> --- a/drivers/firmware/Makefile
> +++ b/drivers/firmware/Makefile
> @@ -11,3 +11,4 @@ obj-$(CONFIG_DMIID)		+= dmi-id.o
>  obj-$(CONFIG_ISCSI_IBFT_FIND)	+= iscsi_ibft_find.o
>  obj-$(CONFIG_ISCSI_IBFT)	+= iscsi_ibft.o
>  obj-$(CONFIG_FIRMWARE_MEMMAP)	+= memmap.o
> +obj-$(CONFIG_SIGMA)		+= sigma.o
> diff --git a/drivers/firmware/sigma.c b/drivers/firmware/sigma.c
> new file mode 100644
> index 0000000..e2945be
> --- /dev/null
> +++ b/drivers/firmware/sigma.c
> @@ -0,0 +1,110 @@
> +/*
> + * Load Analog Devices SigmaStudio firmware files
> + *
> +__* Copyright 2009 Analog Devices Inc.
> +__*
> +__* Licensed under the GPL-2 or later.
> + */

Code had weird non-ascii chars.

> +
> +#include <linux/crc32.h>
> +#include <linux/delay.h>
> +#include <linux/firmware.h>
> +#include <linux/kernel.h>
> +#include <linux/i2c.h>
> +#include <linux/sigma.h>
> +
> +/* Return: 0==OK, <0==error, =1 ==no more actions */
> +int process_sigma_action(struct i2c_client *client, struct sigma_firmware *ssfw)
> +{
> +	struct sigma_action *sa = (void *)(ssfw->fw->data + ssfw->pos);
> +	size_t len = sigma_action_len(sa);
> +	int ret = 0;
> +
> +	pr_debug("%s: instr:%i addr:%#x len:%zu\n", __func__,
> +		sa->instr, sa->addr, len);
> +
> +	switch (sa->instr) {
> +		case SIGMA_ACTION_WRITEXBYTES:
> +		case SIGMA_ACTION_WRITESINGLE:
> +		case SIGMA_ACTION_WRITESAFELOAD:
> +			if (ssfw->fw->size < ssfw->pos + len)
> +				return -EINVAL;
> +			ret = i2c_master_send(client, (void *)&sa->addr, len);
> +			if (ret < 0)
> +				return -EINVAL;
> +			break;
> +
> +		case SIGMA_ACTION_DELAY:
> +			ret = 0;
> +			udelay(len);
> +			len = 0;
> +			break;
> +
> +		case SIGMA_ACTION_END:
> +			return 1;
> +
> +		default:
> +			return -EINVAL;
> +	}

Indent in the switch was wrong.  Please use checkpatch.

> +	/* when arrive here ret=0 or sent data */
> +	ssfw->pos += sigma_action_size(sa, len);
> +	return ssfw->pos == ssfw->fw->size;
> +}
> +
> +int process_sigma_actions(struct i2c_client *client, struct sigma_firmware *ssfw)

Global scope appears to be unnecessary.

> +{
> +	pr_debug("%s: processing %p\n", __func__, ssfw);
> +
> +	while (1) {
> +		int ret = process_sigma_action(client, ssfw);
> +		pr_debug("%s: action returned %i\n", __func__, ret);
> +		if (ret == 1)
> +			return 0;
> +		else if (ret)
> +			return ret;
> +	}
> +}
> +
> +int process_sigma_firmware(struct i2c_client *client, const char *name)

Global scope appears to be unnecessary.

> +{
> +	int ret;
> +	struct sigma_firmware_header *ssfw_head;
> +	struct sigma_firmware ssfw;
> +	const struct firmware *fw;
> +
> +	pr_debug("%s: loading firmware %s\n", __func__, name);
> +
> +	/* first load the blob */
> +	ret = request_firmware(&fw, name, &client->dev);
> +	if (ret) {
> +		pr_debug("%s: request_firmware() failed with %i\n", __func__, ret);
> +		return ret;
> +	}
> +	ssfw.fw = fw;
> +
> +	/* then verify the header */
> +	if (fw->size < sizeof(*ssfw_head)) {
> +		ret = -ENODATA;
> +		goto done;
> +	}
> +	ssfw_head = (void *)fw->data;
> +	if (memcmp(ssfw_head->magic, SIGMA_MAGIC, ARRAY_SIZE(ssfw_head->magic))) {
> +		ret = -EINVAL;
> +		goto done;
> +	}
> +	pr_debug("%s: crc=%x\n", __func__, crc32(0, fw->data, fw->size));

The code calculates and prints the crc but doesn't actually check it
against anything.  What's up with that?

> +	ssfw.pos = sizeof(*ssfw_head);
> +
> +	/* finally process all of the actions */
> +	ret = process_sigma_actions(client, &ssfw);
> +
> + done:
> +	release_firmware(fw);
> +
> +	pr_debug("%s: loaded %s\n", __func__, name);
> +
> +	return ret;
> +}
> +EXPORT_SYMBOL(process_sigma_firmware);
> diff --git a/include/linux/sigma.h b/include/linux/sigma.h
> new file mode 100644
> index 0000000..510765f
> --- /dev/null
> +++ b/include/linux/sigma.h
> @@ -0,0 +1,60 @@
> +/*
> + * Load firmware files from Analog Devices SigmaStudio
> + *
> +__* Copyright 2009 Analog Devices Inc.
> +__*
> +__* Licensed under the GPL-2 or later.
> + */

More weird non-ascii chars.

> +#ifndef __SIGMA_FIRMWARE_H__
> +#define __SIGMA_FIRMWARE_H__
> +
> +#include <linux/firmware.h>
> +#include <linux/types.h>
> +
> +#define SIGMA_MAGIC "ADISIGM"
> +
> +struct sigma_firmware {
> +	const struct firmware *fw;
> +	size_t pos;
> +};
> +
> +struct sigma_firmware_header {
> +	unsigned char magic[7];
> +	u8 version;
> +	u32 crc;
> +};
> +
> +enum {
> +	SIGMA_ACTION_WRITEXBYTES = 0,
> +	SIGMA_ACTION_WRITESINGLE,
> +	SIGMA_ACTION_WRITESAFELOAD,
> +	SIGMA_ACTION_DELAY,
> +	SIGMA_ACTION_PLLWAIT,
> +	SIGMA_ACTION_NOOP,
> +	SIGMA_ACTION_END,
> +};
> +
> +struct sigma_action {
> +	u8 instr;
> +	u8 len_hi;
> +	u16 len;
> +	u16 addr;
> +	unsigned char payload[];
> +};
> +
> +static inline u32 sigma_action_len(struct sigma_action *sa)
> +{
> +	return (sa->len_hi << 16) | sa->len;
> +}
> +
> +static inline size_t sigma_action_size(struct sigma_action *sa, u32 payload_len)
> +{
> +	return sizeof(*sa) + payload_len + (payload_len % 2);
> +}

Did these two functions need to be in a header?  If they're only ever
used in sigma.c then they should be located in that file.

> +struct i2c_client;

It's best to put forward declarations of this form right at the top of
the header file.  Otherwise, we end up with duplicated
forward-declarations as people add references to `struct i2c_client' at
earlier sites in this file.  This has happened before.

> +extern int process_sigma_firmware(struct i2c_client *client, const char *name);
> +
> +#endif


A patch to address some of the above:

--- a/drivers/firmware/sigma.c~sigma-firmware-loader-for-analog-devices-sigmastudio-fix
+++ a/drivers/firmware/sigma.c
@@ -1,9 +1,9 @@
 /*
  * Load Analog Devices SigmaStudio firmware files
  *
- * Copyright 2009 Analog Devices Inc.
- *
- * Licensed under the GPL-2 or later.
+_* Copyright 2009 Analog Devices Inc.
+_*
+_* Licensed under the GPL-2 or later.
  */
 
 #include <linux/crc32.h>
@@ -14,7 +14,8 @@
 #include <linux/sigma.h>
 
 /* Return: 0==OK, <0==error, =1 ==no more actions */
-int process_sigma_action(struct i2c_client *client, struct sigma_firmware *ssfw)
+static int process_sigma_action(struct i2c_client *client,
+				struct sigma_firmware *ssfw)
 {
 	struct sigma_action *sa = (void *)(ssfw->fw->data + ssfw->pos);
 	size_t len = sigma_action_len(sa);
@@ -24,27 +25,27 @@ int process_sigma_action(struct i2c_clie
 		sa->instr, sa->addr, len);
 
 	switch (sa->instr) {
-		case SIGMA_ACTION_WRITEXBYTES:
-		case SIGMA_ACTION_WRITESINGLE:
-		case SIGMA_ACTION_WRITESAFELOAD:
-			if (ssfw->fw->size < ssfw->pos + len)
-				return -EINVAL;
-			ret = i2c_master_send(client, (void *)&sa->addr, len);
-			if (ret < 0)
-				return -EINVAL;
-			break;
-
-		case SIGMA_ACTION_DELAY:
-			ret = 0;
-			udelay(len);
-			len = 0;
-			break;
+	case SIGMA_ACTION_WRITEXBYTES:
+	case SIGMA_ACTION_WRITESINGLE:
+	case SIGMA_ACTION_WRITESAFELOAD:
+		if (ssfw->fw->size < ssfw->pos + len)
+			return -EINVAL;
+		ret = i2c_master_send(client, (void *)&sa->addr, len);
+		if (ret < 0)
+			return -EINVAL;
+		break;
 
-		case SIGMA_ACTION_END:
-			return 1;
+	case SIGMA_ACTION_DELAY:
+		ret = 0;
+		udelay(len);
+		len = 0;
+		break;
 
-		default:
-			return -EINVAL;
+	case SIGMA_ACTION_END:
+		return 1;
+
+	default:
+		return -EINVAL;
 	}
 
 	/* when arrive here ret=0 or sent data */
@@ -52,7 +53,8 @@ int process_sigma_action(struct i2c_clie
 	return ssfw->pos == ssfw->fw->size;
 }
 
-int process_sigma_actions(struct i2c_client *client, struct sigma_firmware *ssfw)
+static int process_sigma_actions(struct i2c_client *client,
+				 struct sigma_firmware *ssfw)
 {
 	pr_debug("%s: processing %p\n", __func__, ssfw);
 
@@ -78,7 +80,8 @@ int process_sigma_firmware(struct i2c_cl
 	/* first load the blob */
 	ret = request_firmware(&fw, name, &client->dev);
 	if (ret) {
-		pr_debug("%s: request_firmware() failed with %i\n", __func__, ret);
+		pr_debug("%s: request_firmware() failed with %i\n",
+			 __func__, ret);
 		return ret;
 	}
 	ssfw.fw = fw;
diff -puN include/linux/sigma.h~sigma-firmware-loader-for-analog-devices-sigmastudio-fix include/linux/sigma.h
--- a/include/linux/sigma.h~sigma-firmware-loader-for-analog-devices-sigmastudio-fix
+++ a/include/linux/sigma.h
@@ -1,9 +1,9 @@
 /*
  * Load firmware files from Analog Devices SigmaStudio
  *
- * Copyright 2009 Analog Devices Inc.
- *
- * Licensed under the GPL-2 or later.
+_* Copyright 2009 Analog Devices Inc.
+_*
+_* Licensed under the GPL-2 or later.
  */
 
 #ifndef __SIGMA_FIRMWARE_H__
@@ -12,6 +12,8 @@
 #include <linux/firmware.h>
 #include <linux/types.h>
 
+struct i2c_client;
+
 #define SIGMA_MAGIC "ADISIGM"
 
 struct sigma_firmware {
@@ -53,8 +55,6 @@ static inline size_t sigma_action_size(s
 	return sizeof(*sa) + payload_len + (payload_len % 2);
 }
 
-struct i2c_client;
-
 extern int process_sigma_firmware(struct i2c_client *client, const char *name);
 
 #endif
_

